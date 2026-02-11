import time
import importlib
import numpy as np

class MPCAdapter:
    def __init__(self, config):
        self.cfg = config
        self.Ts_h = self.cfg["runtime"]["Ts"] / 3600.0
        self.eps_on = self.cfg["runtime"]["eps_on"]

        # importar TU MPC
        self.mpc_mod = importlib.import_module("mpc_dos_en_uno_modular")

        model, h, hT, t_on, t_on_acum, u, R, Qdem, Ce = self.mpc_mod.build_model()
        self.mpc = self.mpc_mod.build_mpc(model, h, hT, t_on, t_on_acum, u, R, Qdem, Ce)

        self.x0 = self.mpc.x0
        for k, v in self.cfg["mpc"]["x0"].items():
            if k in self.x0.keys():
                self.x0[k] = v

        self.mpc.x0 = self.x0
        self.mpc.set_initial_guess()

    def update_state(self, key, value):
        if key in self.x0.keys():
            self.x0[key] = float(value)

    def step(self):
        # Ejecutar MPC
        u = self.mpc.make_step(self.x0)

        # Convertir salida a lista
        n_p = int(self.mpc_mod.n_p)

        try:
            # Intento como dict: u["u_0"]
            u_list = [float(u[f"u_{i}"]) for i in range(n_p)]
        except Exception:
            # Intento como vector (CasADi / numpy)
            if hasattr(u, "full"):
                flat = u.full().ravel().tolist()
            else:
                flat = np.array(u).ravel().tolist()

            u_list = [float(flat[i]) for i in range(n_p)]

        # Actualizar tiempos internos
        for i, ui in enumerate(u_list):
            t_on_key = f"t_on_{i}"
            t_ac_key = f"t_on_acum_{i}"

            t_on = float(self.x0[t_on_key])
            t_ac = float(self.x0[t_ac_key])

            if ui > self.eps_on:
                t_on += self.Ts_h
            else:
                t_on += self.Ts_h * (-0.8 * t_on)
                t_on = max(t_on, 0.0)

            t_ac += self.Ts_h * ui

            self.x0[t_on_key] = t_on
            self.x0[t_ac_key] = t_ac

        u_bin = ["ON" if ui > self.eps_on else "OFF" for ui in u_list]

        return u_list, u_bin
