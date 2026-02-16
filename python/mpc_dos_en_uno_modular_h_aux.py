# -*- coding: utf-8 -*-

from xml.parsers.expat import model
import numpy as np
import pandas as pd
import do_mpc
from casadi import *


# =========================
# Configuración global (mismos valores que en mpc_dos_en_uno.py)
# =========================
model_type = 'continuous'  # puede ser 'discrete' o 'continuous'

# Número de pozos y tanques
n_p = 3
n_t = 1

# Parámetros del modelo
ha = [40, 30, 60] # nivel estático de agua en el acuífero
Rp = [0.35, 0.35, 0.25] # m radio de los pozos
Rt = [4] # radio de los tanques
hs = [1.0, 1.0, 1.0] # altura mínima de succión (no usado en el modelo actual, se mantiene)
T = 15.58/4 # transmisividad del acuífero (m2/h)
alpha = [0.05, 0.05, 0.05] # sensibilidad a la lluvia
q = [27, 36, 42] # caudal máximo de bombeo m3/h


# Pesos
lambda_dem    = 16            # peso nivel mínimo de tanque
lambda_pozo   = 0.1          # peso nivel mínimo de pozo
lambda_on_time = 0.8         # escala
lambda_bin    = 800           # anti-0.5
lambda_energy = 2
lambda_wear   = 1.6

# Referencias
hT_ref = [10.0 for _ in range(n_t)]
h_ref  = [40, 30, 60]

# MPC setup
setup_mpc = {
    'n_horizon': 60,
    't_step': 0.1,
    'n_robust': 0,
    'store_full_solution': True,
}

# rterm
r_u = 280

# Bounds
h_min = [0.0]*n_p
h_max = [40, 30, 60]

hT_min = [0.0]*n_t
hT_max = [10.0]*n_t

u_min = [0.0]*n_p
u_max = [1, 1, 1]

# TVP: demanda y lluvia
QDEM_MIN = 5
QDEM_MAX = 110
T_HOLD   = 3  # horas

# =========================
# Utilidades
# =========================

def _to_scalar(t):
    """Convierte t (float / np.array / casadi.DM) a float escalar."""
    try:
        return float(t)
    except Exception:
        return float(np.array(t).squeeze())

def Qdem_forecast(t, j=0):
    t = _to_scalar(t)
    k = int(np.floor(t / T_HOLD))
    r = np.random.default_rng(seed=22 + 37*j + k).uniform(QDEM_MIN, QDEM_MAX)
    return float(r)

def rain_forecast(t):
    return 0.0

def ute_tariff(t):
    t = _to_scalar(t)
    if 0 <= t < 7 or 24 <= t < 31:
        return 2.6   # valle
    elif 7 <= t < 18 or 22 <= t < 24 or 31 <= t < 42 or 46 <= t < 48:
        return 5.8   # llano
    else:
        return 13.2   # punta

# =========================
# Construcción del modelo
# =========================
def build_model():
    model = do_mpc.model.Model(model_type)

    # Estados: nivel de pozos
    h = [model.set_variable(var_type='_x', var_name=f'h_{i}') for i in range(n_p)]
    # Estados: nivel de pozos
    haux = [model.set_variable(var_type='_x', var_name=f'haux_{i}') for i in range(n_p)]
    # Estados: nivel de tanque
    hT = [model.set_variable(var_type='_x', var_name=f'hT_{j}') for j in range(n_t)]
    # Estados: tiempo continuo encendida
    t_on = [model.set_variable(var_type='_x', var_name=f't_on_{i}') for i in range(n_p)]
    # Estados: horas acumuladas encendida
    t_on_acum = [model.set_variable(var_type='_x', var_name=f't_on_acum_{i}') for i in range(n_p)]

    # Controles
    u = [model.set_variable(var_type='_u', var_name=f'u_{i}') for i in range(n_p)]

    # TVP
    R = model.set_variable('_tvp', 'R')
    Qdem = [model.set_variable('_tvp', f'Qdem_{j}') for j in range(n_t)]
    Ce = model.set_variable('_tvp', 'Ce')

    # Caudales de salida de cada pozo
    Qout = [None]*n_p

    # Dinámica de pozos
    for i in range(n_p):
        # Qin_i  = 2*pi*T*log(fmax(ha[i] - h[i], 1e-3))/log(2) + alpha[i]*R
        Qin_i  = T*(ha[i] - h[i]) + alpha[i]*R
        Qout[i] = u[i]*q[i]
        dh_dt  = (Qin_i - Qout[i]) / (2*pi*(Rp[i]**2))
        model.set_rhs(f'h_{i}', dh_dt)

    # Dinámica de pozos aux
    for i in range(n_p):
        # Qin_i  = 2*pi*T*log(fmax(ha[i] - h[i], 1e-3))/log(2) + alpha[i]*R
        Qin_i  = T*(ha[i] - haux[i])
        Qout[i] = u[i]*q[i]
        dhaux_dt  = (Qin_i - Qout[i]) / (20*pi*(Rp[i]**2))
        model.set_rhs(f'haux_{i}', dhaux_dt)

    # Dinámica de tanque
    for j in range(n_t):
        Qt_in_j = SX(0)
        for i in range(n_p):
            Qt_in_j += Qout[i]
        dhT_dt = (Qt_in_j - Qdem[j]) / (2*pi*(Rt[j]**2))
        model.set_rhs(f'hT_{j}', dhT_dt)

    # t_on: tiempo continuo encendida (misma dinámica original)
    k = 10  # pendiente de la sigmoide (ajustable)
    for i in range(n_p):
        
        sigma = 1 / (1 + exp(-k * (u[i] - 0.5)))
        t_on_dot = sigma * 1 + (1 - sigma) * (-0.8 * t_on[i])
        model.set_rhs(f't_on_{i}', t_on_dot)

    # t_on_acum: acumulado (misma dinámica original)
    for i in range(n_p):
        model.set_rhs(f't_on_acum_{i}', u[i])

    model.setup()
    return model, h, hT, t_on, t_on_acum, u, R, Qdem, Ce, haux

# =========================
# Construcción del MPC
# =========================
def build_mpc(model, h, hT, t_on, t_on_acum, u, R, Qdem, Ce, haux):
    mpc = do_mpc.controller.MPC(model)
    mpc.set_param(**setup_mpc)

    # 1) Energía
    energy_sum = SX(0)
    for i in range(n_p):
        energy_sum += u[i]*q[i]
    C_energy = Ce * energy_sum * lambda_energy

    # 2) Demanda / tanque bajo
    tank_pen = SX(0)
    for j in range(n_t):
        tank_pen += (hT_ref[j] - hT[j])**2
    C_dem = lambda_dem * tank_pen

    # 3) Pozo bajo
    well_pen = SX(0)
    for i in range(n_p):
        well_pen += (h_ref[i] - h[i])**2
    C_pozo = lambda_pozo * well_pen

    # 4) Tiempo encendida (continua)
    C_on_time = SX(0)
    for i in range(n_p):
        C_on_time += (t_on[i])**2
    C_on_time = lambda_on_time * C_on_time

    # 5) Anti-0.5
    C_binario = SX(0)
    for i in range(n_p):
        C_binario += lambda_bin * (u[i])*(1-u[i])

    # 6) Balanceo desgaste sobre acumulado
    t_vec  = vertcat(*[model.x[f't_on_acum_{i}'] for i in range(n_p)])
    t_mean = sum1(t_vec)/n_p
    C_wear = lambda_wear * sum1((t_vec - t_mean)**2)

    lterm = C_energy + C_dem + C_pozo + C_binario + C_wear + C_on_time

    # Terminal term (igual, 0)
    mterm = SX(0)
    mpc.set_objective(mterm=mterm, lterm=lterm)

    # rterm
    mpc.set_rterm(**{f'u_{i}': r_u for i in range(n_p)})

    # Bounds estados
    for i in range(n_p):
        mpc.bounds['lower', '_x', f'h_{i}'] = h_min[i]
        mpc.bounds['upper', '_x', f'h_{i}'] = h_max[i]
        mpc.bounds['lower', '_x', f't_on_{i}'] = 0.0
        mpc.bounds['upper', '_x', f't_on_{i}'] = 18.0

    for j in range(n_t):
        mpc.bounds['lower', '_x', f'hT_{j}'] = hT_min[j]
        mpc.bounds['upper', '_x', f'hT_{j}'] = hT_max[j]

    # Bounds inputs
    for i in range(n_p):
        mpc.bounds['lower', '_u', f'u_{i}'] = u_min[i]
        mpc.bounds['upper', '_u', f'u_{i}'] = u_max[i]

    # TVP function del MPC (misma lógica original, con caso nested)
    def tvp_fun_mpc(t_now):
        t_now = _to_scalar(t_now)
        Ts = mpc.settings.t_step
        N  = mpc.settings.n_horizon
        tvp_template = mpc.get_tvp_template()

        for k in range(N + 1):
            t_k = t_now + k*Ts
            Ce_k = ute_tariff(t_k)
            R_k  = rain_forecast(t_k)

            if '_tvp' in tvp_template.keys():
                tvp_template['_tvp', k, 'Ce'] = Ce_k
                tvp_template['_tvp', k, 'R']  = R_k
                for j in range(n_t):
                    tvp_template['_tvp', k, f'Qdem_{j}'] = Qdem_forecast(t_k, j)
            else:
                def _set(name, kk, val):
                    try:
                        tvp_template[name, kk] = val
                    except Exception:
                        tvp_template[kk, name] = val
                _set('Ce', k, Ce_k)
                _set('R',  k, R_k)
                for j in range(n_t):
                    _set(f'Qdem_{j}', k, Qdem_forecast(t_k, j))

        return tvp_template

    mpc.set_tvp_fun(tvp_fun_mpc)
    mpc.setup()
    return mpc

# =========================
# Construcción del simulador
# =========================
def build_simulator(model):
    simulator = do_mpc.simulator.Simulator(model)
    simulator.set_param(t_step=setup_mpc['t_step'])

    tvp_template = simulator.get_tvp_template()

    def tvp_fun_sim(t_now):
        tvp_template['R'] = float(rain_forecast(t_now))
        tvp_template['Ce'] = float(ute_tariff(t_now))
        qd = Qdem_forecast(t_now)
        tvp_template['Qdem_0'] = float(qd)
        return tvp_template

    simulator.set_tvp_fun(tvp_fun_sim)
    simulator.setup()
    return simulator

# =========================
# Gráficas
# =========================
def setup_graphics(mpc, simulator):
    import matplotlib.pyplot as plt
    import matplotlib as mpl

    mpl.rcParams['font.size'] = 15
    mpl.rcParams['lines.linewidth'] = 2
    mpl.rcParams['axes.grid'] = True

    mpc_graphics = do_mpc.graphics.Graphics(mpc.data)
    sim_graphics = do_mpc.graphics.Graphics(simulator.data)

    # ==========================================================
    # Ventana 1:
    # Nivel de pozos | Nivel de tanque | Acciones | Demanda
    # ==========================================================
    fig1, ax1 = plt.subplots(4, 1, sharex=True, figsize=(12, 8))
    fig1.align_ylabels()

    for g in [sim_graphics, mpc_graphics]:
        # Nivel de pozos
        g.add_line(var_type='_x', var_name='haux_0', axis=ax1[0])
        g.add_line(var_type='_x', var_name='haux_1', axis=ax1[0])
        g.add_line(var_type='_x', var_name='haux_2', axis=ax1[0])

        # Nivel de tanque
        g.add_line(var_type='_x', var_name='hT_0', axis=ax1[1])

        # Acciones de control
        g.add_line(var_type='_u', var_name='u_0', axis=ax1[2])
        g.add_line(var_type='_u', var_name='u_1', axis=ax1[2])
        g.add_line(var_type='_u', var_name='u_2', axis=ax1[2])

        # Demanda
        g.add_line(var_type='_tvp', var_name='Qdem_0', axis=ax1[3])

    ax1[0].set_ylabel('Nivel [m]')
    ax1[1].set_ylabel('Nivel [m]')
    ax1[2].set_ylabel('Acción [-]')
    ax1[3].set_ylabel('Demanda [m³/h]')
    ax1[3].set_xlabel('Tiempo [h]')

    ax1[0].set_title('Nivel de pozos')
    ax1[1].set_title('Nivel de tanque')
    ax1[2].set_title('Acciones de control')
    ax1[3].set_title('Demanda')

    for axi in ax1:
        axi.grid(True, alpha=0.3)

    fig1.tight_layout()

    # ==========================================================
    # Ventana 2:
    # t_on continuo | t_on acumulado | Tarifa
    # ==========================================================
    fig2, ax2 = plt.subplots(3, 1, sharex=True, figsize=(12, 7))
    fig2.align_ylabels()

    for g in [sim_graphics, mpc_graphics]:
        # Tiempo ON continuo
        g.add_line(var_type='_x', var_name='t_on_0', axis=ax2[0])
        g.add_line(var_type='_x', var_name='t_on_1', axis=ax2[0])
        g.add_line(var_type='_x', var_name='t_on_2', axis=ax2[0])

        # Tiempo ON acumulado
        g.add_line(var_type='_x', var_name='t_on_acum_0', axis=ax2[1])
        g.add_line(var_type='_x', var_name='t_on_acum_1', axis=ax2[1])
        g.add_line(var_type='_x', var_name='t_on_acum_2', axis=ax2[1])

        # Tarifa eléctrica
        g.add_line(var_type='_tvp', var_name='Ce', axis=ax2[2])

    ax2[0].set_ylabel('t_on [h]')
    ax2[1].set_ylabel('t_on_acum [h]')
    ax2[2].set_ylabel('Ce [-]')
    ax2[2].set_xlabel('Tiempo [h]')

    ax2[0].set_title('Tiempo ON continuo')
    ax2[1].set_title('Tiempo ON acumulado')
    ax2[2].set_title('Tarifa eléctrica')

    for axi in ax2:
        axi.grid(True, alpha=0.3)

    fig2.tight_layout()

    # Limpieza estándar do-mpc
    sim_graphics.clear()

    return mpc_graphics, sim_graphics, fig1, fig2

# =========================
# Inicialización y simulación
# =========================
def init_state(simulator):
    x0 = simulator.x0
    x0['h_0'] = 10.0
    x0['h_1'] = 8.2
    x0['h_2'] = 34.0
    x0['haux_0'] = 10.0
    x0['haux_1'] = 8.2
    x0['haux_2'] = 34.0
    x0['t_on_0'] = 0
    x0['t_on_1'] = 0
    x0['t_on_2'] = 0
    x0['t_on_acum_0'] = 0
    x0['t_on_acum_1'] = 0
    x0['t_on_acum_2'] = 0
    x0['hT_0'] = 5
    return x0


def run_closed_loop(mpc, simulator, x0, sim_steps):
    simulator.reset_history()
    simulator.x0 = x0
    mpc.reset_history()
    mpc.x0 = x0
    mpc.set_initial_guess()

    for _ in range(sim_steps):
        u0 = mpc.make_step(x0)
        x0 = simulator.make_step(u0)

    return x0


def export_selected_variables(mpc, simulator, filename):
    data = simulator.data   # usar simulator.data es lo correcto para resultados
    export_dict = {}

    # Tiempo
    export_dict['time'] = np.squeeze(data['_time'])

    # Acciones de control (u)
    export_dict['u_0'] = np.squeeze(data['_u', 'u_0'])
    export_dict['u_1'] = np.squeeze(data['_u', 'u_1'])
    export_dict['u_2'] = np.squeeze(data['_u', 'u_2'])

    # Guardar CSV
    df = pd.DataFrame(export_dict)
    df.to_csv(filename, index=False)


# =========================
# Main
# =========================
def main(sim_steps=480, export_filename='mpc_dos_en_uno_results.csv'):
    model, h, hT, t_on, t_on_acum, u, R, Qdem, Ce, haux = build_model()
    mpc = build_mpc(model, h, hT, t_on, t_on_acum, u, R, Qdem, Ce, haux)
    simulator = build_simulator(model)

    mpc_graphics, sim_graphics, fig1, fig2 = setup_graphics(mpc, simulator)

    x0 = init_state(simulator)
    run_closed_loop(mpc, simulator, x0, sim_steps=sim_steps)

    # Plot results
    sim_graphics.plot_results()
    sim_graphics.reset_axes()

    import matplotlib.pyplot as plt
    plt.show()

    export_selected_variables(mpc, simulator, filename="resultados_mpc.csv")


if __name__ == '__main__':
    main()