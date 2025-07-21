import time
from fmpy import read_model_description, extract, simulate_fmu
from fmpy.fmi2 import FMU2Slave
import shutil
import os

# Ruta al FMU
fmu_filename = r"C:\Users\juanf\OneDrive\Escritorio\Tésis\prueba1_no_mid_tanks.fmu"


# Paso de simulación (en segundos)
step_size = 1.0

# Tiempo total de simulación (en segundos)
stop_time = 5.0

# Valores iniciales personalizados (ejemplo: nivel de los pozos)
initial_inputs = {
    'tankFinak.level_start': 3.0, 
    'pozo2.level_start': 2.0, 
}

# -----------------------------------
# Preparar entorno y extraer FMU
# -----------------------------------
model_description = read_model_description(fmu_filename)
unzipdir = extract(fmu_filename)

# collect the value references
vrs = {}
for variable in model_description.modelVariables:
    print(f"Variable: {variable.name}, Value Reference: {variable.valueReference}")
    if variable.name == 'tankFinal.level':
        tankFinal_level = variable.valueReference
    if variable.name == 'tankFinal.level_start':
        tankFinal_nivelInicial = variable.valueReference


# Buscar instancia del modelo co-simulation
fmu = FMU2Slave(guid=model_description.guid,
                unzipDirectory=unzipdir,
                modelIdentifier=model_description.coSimulation.modelIdentifier,
                instanceName='instance1')

# Inicializar FMU
fmu.instantiate()
fmu.setupExperiment(startTime=0.0)
fmu.enterInitializationMode()

# Establecer valores iniciales

fmu.setReal([tankFinal_nivelInicial], [3.0])

fmu.exitInitializationMode()

# -----------------------------------
# Bucle de simulación en tiempo real
# -----------------------------------
current_time = 0.0
print("🟢 Comenzando simulación en tiempo real...\n")

while current_time < stop_time:
    start_loop = time.time()

    # Realizar un paso de simulación
    fmu.doStep(currentCommunicationPoint=current_time, communicationStepSize=step_size)

    # Leer salidas relevantes (modificá según tus variables)
    try:
        datos = fmu.getReal([tankFinal_level])
        print(datos)
    except Exception as e:
        print(f"Error obteniendo variables: {e}")
    
    # Esperar para sincronizar con tiempo real
    elapsed = time.time() - start_loop
    sleep_time = step_size - elapsed
    if sleep_time > 0:
        time.sleep(sleep_time)

    current_time += step_size

# Finalizar
fmu.terminate()
fmu.freeInstance()
shutil.rmtree(unzipdir)
print("\n✅ Simulación finalizada.")
