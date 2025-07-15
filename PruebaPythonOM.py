from OMPython import OMCSessionZMQ

# Crear sesión con OMC
omc = OMCSessionZMQ()

# Ruta del archivo .mo (usá doble barra invertida o r"" para que Python lo entienda)
ruta = r"C:\Users\lucas\OneDrive\Escritorio\LUCAS\Proyecto Final Tesis\OpenModelica\dosPozos.mo"

# Cargar el archivo Modelica
print("Cargando modelo...")
resultado = omc.sendExpression(f'loadFile("{ruta}")')
print("Archivo cargado:", resultado)

# Comprobamos si se cargó correctamente
if resultado:
    # Consultamos los nombres de los modelos definidos en el archivo
    modelos = omc.sendExpression("getClassNames()")
    print("Modelos encontrados:", modelos)

    # Elegimos el primero (o el que vos sepas que está en ese archivo)
    modelo = 'prueba1_no_mid_tanks'  # podés cambiarlo si sabés el nombre exacto

    # Simulamos el modelo
    print(f"Simulando {modelo}...")
    simulacion = omc.sendExpression(f"simulate({modelo})")

    print("Resultado de la simulación:")
    print(simulacion)

else:
    print("No se pudo cargar el archivo.")
