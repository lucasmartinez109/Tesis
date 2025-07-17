from OMPython import ModelicaSystem
import numpy as np

def simular_tanque(stop_time):
    # Ruta al archivo del modelo y nombre del modelo
    ruta = r"C:\Users\juanf\OneDrive\Escritorio\Tésis\dosPozos.mo"
    modelo = 'prueba1_no_mid_tanks'

    # Creamos una instancia del sistema Modelica
    mod = ModelicaSystem(ruta, modelo)

    # Se setean las opciones de simulación con el stopTime recibido
    opciones = [f"stopTime={stop_time}", "stepSize=0.1"]
    mod.setSimulationOptions(opciones)

    # Se establece el nivel inicial del tanque
    mod.setParameters(["tankFinal.level_start=0.7"])

    # Simulamos el modelo
    mod.simulate()

    # Obtenemos los resultados en formato numpy
    tiempos, nivel = mod.getSolutions(["time", "tankFinal.level"])

    # Imprimimos los resultados
    for t, nivel_actual in zip(tiempos, nivel):
        print(f"Tiempo = {t:.2f} s, Nivel = {nivel_actual:.4f}")

    # Devolver resultados si querés usarlos luego
    return tiempos, nivel

simular_tanque(stop_time=10.0)
