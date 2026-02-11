import time
import yaml
import csv
from pathlib import Path
from datetime import datetime

from mqtt_client import MQTTClient
from mpc_adapter import MPCAdapter

BASE_DIR = Path(__file__).resolve().parent
CFG_PATH = BASE_DIR / "config.yaml"

with open(CFG_PATH, "r", encoding="utf-8") as f:
    cfg = yaml.safe_load(f)

# =========================
# LOG CSV histórico
# =========================
log_path = BASE_DIR / "hist_mpc.csv"

if not log_path.exists():
    with open(log_path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow([
            "ts_iso", "ts_epoch",
            "sensor_value",
            "u0", "u1", "u2",
            "cmd0", "cmd1", "cmd2"
        ])

latest_sensor_value = None

def on_mqtt_message(client, userdata, msg):
    global latest_sensor_value
    try:
        latest_sensor_value = float(msg.payload.decode())
        print(f"[MQTT] Sensor recibido: {latest_sensor_value}")
    except:
        pass

mqtt = MQTTClient(
    cfg["mqtt"]["host"],
    cfg["mqtt"]["port"],
    on_mqtt_message
)

mqtt.subscribe(cfg["topics"]["sensor"])

mpc = MPCAdapter(cfg)

state_key = cfg["mapping"]["sensor_to_state"]
Ts = cfg["runtime"]["Ts"]

print("=== SOCPA MPC RUNNER ACTIVO ===")

while True:
    if latest_sensor_value is not None:
        mpc.update_state(state_key, latest_sensor_value)

        u, u_bin = mpc.step()

        print(f"[MPC] u = {u} → {u_bin}")

        # enviar comando bomba (pozo 1)
        mqtt.publish(cfg["topics"]["command"], u_bin[0])

        # =========================
        # Guardar histórico en CSV
        # =========================
        ts_epoch = time.time()
        ts_iso = datetime.fromtimestamp(ts_epoch).isoformat()

        u0 = u[0] if len(u) > 0 else ""
        u1 = u[1] if len(u) > 1 else ""
        u2 = u[2] if len(u) > 2 else ""

        c0 = u_bin[0] if len(u_bin) > 0 else ""
        c1 = u_bin[1] if len(u_bin) > 1 else ""
        c2 = u_bin[2] if len(u_bin) > 2 else ""

        with open(log_path, "a", newline="", encoding="utf-8") as f:
            w = csv.writer(f)
            w.writerow([ts_iso, ts_epoch, latest_sensor_value, u0, u1, u2, c0, c1, c2])

    time.sleep(Ts)
