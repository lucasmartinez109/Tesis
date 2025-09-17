import numpy as np
from haversine import haversine, Unit

# --- 1. DATOS DE ENTRADA ---

# Parámetros del acuífero (deben ser constantes para la zona de estudio)
T = 374  # Transmisividad del acuífero (m^2/día)
R = 1000   # Radio de influencia estimado (metros)

# Lista de pozos. Cada pozo es un diccionario con sus propiedades.
pozos = [
    {
        "id": "Pozo A",
        "lat": -34.388,
        "lon": -56.544,
        "Q": 504,  # Caudal de bombeo (m^3/día)
        "rw": 0.15   # Radio del pozo (metros)
    },
    {
        "id": "Pozo B",
        "lat": -34.390,
        "lon": -56.546,
        "Q": 444,  # Caudal de bombeo (m^3/día)
        "rw": 0.15
    },
    {
        "id": "Pozo C",
        "lat": -34.3946,
        "lon": -56.5384,
        "Q": 792,  # Caudal de bombeo (m^3/día)
        "rw": 0.15
    }
]

# --- 2. CÁLCULO AUTOMATIZADO ---

num_pozos = len(pozos)
matriz_abatimientos = np.zeros((num_pozos, num_pozos))

# Extraemos los caudales a un vector para facilitar el cálculo
caudales = np.array([p["Q"] for p in pozos])

# Iteramos para cada pozo "observado" (i)
for i in range(num_pozos):
    # Iteramos para cada pozo "bombeando" (j) que causa la interferencia
    for j in range(num_pozos):
        
        pozo_observado = pozos[i]
        pozo_bombeando = pozos[j]
        
        if i == j:
            # Caso Diagonal: Abatimiento del pozo sobre sí mismo
            # La distancia 'r' es el radio del propio pozo (rw)
            r = pozo_bombeando["rw"]
        else:
            # Caso Interferencia: Abatimiento de un pozo sobre otro
            # Calculamos la distancia entre los dos pozos en metros
            coord_i = (pozo_observado["lat"], pozo_observado["lon"])
            coord_j = (pozo_bombeando["lat"], pozo_bombeando["lon"])
            r = haversine(coord_i, coord_j, unit=Unit.METERS)
        if r > R:
            abatimiento_ij = 0
            matriz_abatimientos[i, j] = abatimiento_ij
        else:
            # Ecuación de Thiem para calcular el abatimiento s(r) = (Q / 2πT) * ln(R / r)
            # s_ij es el abatimiento EN el pozo i, causado POR el pozo j
            Qj = pozo_bombeando["Q"]
            abatimiento_ij = (Qj / (2 * np.pi * T)) * np.log(R / r)
            matriz_abatimientos[i, j] = abatimiento_ij

# El abatimiento total en cada pozo es la suma de su fila correspondiente
abatimiento_total_por_pozo = np.sum(matriz_abatimientos, axis=1)

# --- 3. RESULTADOS ---

print("--- Matriz de Abatimientos (S_ij) ---")
print("Filas: Pozo observado | Columnas: Pozo que causa el abatimiento\n")
header = "\t" + "\t".join([p["id"] for p in pozos])
print(header)
for i, row in enumerate(matriz_abatimientos):
    print(f"{pozos[i]['id']}\t" + "\t".join([f"{val:.2f} m" for val in row]))

print("\n" + "="*50 + "\n")

print("--- Abatimiento Total por Pozo ---")
for i, s_total in enumerate(abatimiento_total_por_pozo):
    s_propio = matriz_abatimientos[i, i]
    s_interferencia = s_total - s_propio
    print(f"Pozo {pozos[i]['id']}:")
    print(f"  - Abatimiento Total:\t{s_total:.2f} m")
    print(f"  - (Abatimiento Propio:\t{s_propio:.2f} m)")
    print(f"  - (Interferencia de otros:\t{s_interferencia:.2f} m)\n")
