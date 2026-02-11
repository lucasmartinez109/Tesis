import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

# Ruta del CSV
log_path = Path(__file__).resolve().parent / "hist_mpc.csv"

if not log_path.exists():
    print("No existe hist_mpc.csv todavía.")
    exit()

# Leer datos
df = pd.read_csv(log_path)

# Convertir tiempo
df["ts_iso"] = pd.to_datetime(df["ts_iso"])

# Convertir ON/OFF a 1/0
df["cmd0_num"] = df["cmd0"].map({"ON": 1, "OFF": 0})

# ==========================
# Crear gráfico
# ==========================
fig, ax1 = plt.subplots(figsize=(10,5))

# Sensor
ax1.plot(df["ts_iso"], df["sensor_value"], label="Nivel sensor", linewidth=2)
ax1.set_ylabel("Nivel")
ax1.set_xlabel("Tiempo")

# Segundo eje para ON/OFF
ax2 = ax1.twinx()
ax2.step(df["ts_iso"], df["cmd0_num"], where="post", linestyle="--", label="Bomba ON/OFF")
ax2.set_ylabel("Bomba (1=ON, 0=OFF)")
ax2.set_ylim(-0.1, 1.1)

# Leyenda combinada
lines1, labels1 = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()
ax1.legend(lines1 + lines2, labels1 + labels2)

plt.title("Histórico MPC - Sensor y Estado Bomba")
plt.tight_layout()
plt.show()
