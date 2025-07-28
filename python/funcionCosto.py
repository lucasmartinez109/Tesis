import numpy as np
from dataclasses import dataclass
from typing import Sequence, Union, Tuple, Dict

Number = Union[int, float]

@dataclass
class Pesos:
    """Pesos de cada término del costo."""
    w_track: float = 100   # Peso del término de seguimiento de la demanda
    w_horas: float = 20  # Peso por cantidad de horas encendido
    w_dyn:   float = 50   # Peso de la diferencia nivel dinámico - nivel estático
    w_cambio:   float = 10   # Peso por cambio de estado (encendido/apagado)


def costo_step(
    x: Sequence[Number],          # oferta de cada pozo (vector de tamaño M)
    u: Sequence[Number],          # horas que lleva encendido cada pozo (vector de tamaño M)
    h_dyn: Sequence[Number],      # nivel dinámico de cada pozo (vector de tamaño M)
    h_stat: Sequence[Number],     # nivel estático de cada pozo (vector de tamaño M, NO único)
    b: Sequence[int],             # variable binaria por pozo (vector de tamaño M, 0/1)
    b_ant: Sequence[int],         # estado anterior de cada pozo (vector de tamaño M, 0/1)
    r: Number,                    # demanda total (escalar)
    w: Pesos = Pesos(),           # pesos
    return_terms: bool = False    # devolver términos parciales
) -> Union[Number, Tuple[Number, Dict[str, Number]]]:
    """
    Calcula el costo de un único instante:

        J = w_track ( Σ_i b_i x_i - r )^2 + Σ_i b_i ( w_horas u_i^2 + w_dyn (h_dyn_i - h_stat_i)^2 ) + w_cambio Σ_i |b_i - b_ant_i|

    Parámetros
    ----------
    x, u, h_dyn, h_stat, b : arrays de largo M
    r : escalar
    w : Pesos, contiene w_track, w_horas, w_dyn, w_cambio
    return_terms : si True, devuelve también un dict con los términos parciales

    Retorna
    -------
    J : float
        Valor total del costo.
    (J, terms) : tuple
        Si return_terms=True, devuelve también un dict con cada término parcial.
    """

    # Convertir a numpy
    x = np.asarray(x, dtype=float)
    u = np.asarray(u, dtype=float)
    h_dyn = np.asarray(h_dyn, dtype=float)
    h_stat = np.asarray(h_stat, dtype=float)
    b = np.asarray(b, dtype=int)
    b_ant = np.asarray(b, dtype=int)

    # --- Validaciones ---
    if not (x.shape == u.shape == h_dyn.shape == h_stat.shape == b.shape == b_ant.shape):
        raise ValueError("x, u, h_dyn, h_stat, b y b_ant deben tener la misma forma (M,).")
    if not np.all((b == 0) | (b == 1)):
        raise ValueError("b debe ser binaria (0/1).")
    if not np.all((b_ant == 0) | (b_ant == 1)):
        raise ValueError("b_ant debe ser binaria (0/1).")

    # --- Cálculo de términos ---
    oferta_total = np.sum(b * x)  # sólo suman las ofertas de pozos encendidos
    term_track = w.w_track * (oferta_total - r) ** 2

    term_horas = w.w_horas * np.sum(b * (u ** 2))
    term_dyn = w.w_dyn * np.sum(b * (h_dyn - h_stat) ** 2)

    term_cambio = w.w_cambio * np.sum(np.abs(b - b_ant))

    J = term_track + term_horas + term_dyn + term_cambio

    if return_terms:
        terms = {
            "track": term_track,
            "horas": term_horas,
            "dyn": term_dyn,
            "cambio": term_cambio
        }
        return J, terms

    return J


# ----------------- Ejemplo de uso -----------------
if __name__ == "__main__":
    # Supongamos M = 3 pozos
    x      = [0.8, 0.5, 0.8]   # ofertas
    u      = [0.3, 0.1, 0.8]   # horas que llevan encendidos
    h_dyn  = [5.1, 4.9, 5.0]   # niveles dinámicos
    h_stat = [5.0, 5.0, 5.0]   # niveles estáticos (distintos si querés)
    b      = [1, 1, 0]         # estado actual
    b_ant  = [1, 1, 0]         # estado anterior
    r      = 1.2               # demanda total

    J, terms = costo_step(x, u, h_dyn, h_stat, b, b_ant, r, return_terms=True)
    print(f"Costo total = {J:.4f}")
    print("Detalle por término:", terms)
