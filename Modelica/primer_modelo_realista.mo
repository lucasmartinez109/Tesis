model pozos_modelo_realista_completo
  inner Modelica.Fluid.System system(p_ambient=101325, T_ambient=293.15, g=9.81)
    annotation(Placement(transformation(extent={{-80,60},{-60,80}})));

  // Recarga artificial de acuíferos
  Modelica.Fluid.Sources.MassFlowSource_T recarga1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow = 0.02, T = 293.15, nPorts = 1)
    annotation(Placement(transformation(extent={{-220,-70},{-200,-50}})));

  Modelica.Fluid.Sources.MassFlowSource_T recarga2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow = 0.02, T = 293.15, nPorts = 1)
    annotation(Placement(transformation(extent={{-20,-70},{0,-50}})));

  // Acuíferos
  Modelica.Fluid.Vessels.OpenTank acuifero1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height = 50, crossArea = 1, level_start = 30, use_portsData = true, nPorts = 2,
    portsData = {
      Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.02),
      Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.02)},
    massDynamics = Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation(Placement(transformation(extent={{-190,-50},{-170,-30}})));

  Modelica.Fluid.Vessels.OpenTank acuifero2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height = 50, crossArea = 1, level_start = 30, use_portsData = true, nPorts = 2,
    portsData = {
      Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.02),
      Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.02)},
    massDynamics = Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation(Placement(transformation(extent={{10,-50},{30,-30}})));

  // Válvulas
  Modelica.Fluid.Valves.ValveLinear valvula1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_nominal = 0.05, dp_nominal = 1000, opening = 0.9)
    annotation(Placement(transformation(extent={{-170,-20},{-150,0}})));

  Modelica.Fluid.Valves.ValveLinear valvula2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_nominal = 0.05, dp_nominal = 1000, opening = 0.9)
    annotation(Placement(transformation(extent={{30,-20},{50,0}})));

  // Pozos
  Modelica.Fluid.Vessels.OpenTank pozo1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height = 10, crossArea = 2, level_start = 2, use_portsData = true, nPorts = 2,
    portsData = {
      Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.05),
      Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.05)},
    massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation(Placement(transformation(extent={{-150,-50},{-130,-30}})));

  Modelica.Fluid.Vessels.OpenTank pozo2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height = 10, crossArea = 2, level_start = 2, use_portsData = true, nPorts = 2,
    portsData = {
      Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.05),
      Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.05)},
    massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation(Placement(transformation(extent={{50,-50},{70,-30}})));

  // Bombas
  Modelica.Fluid.Machines.PrescribedPump bomba1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    use_N_in = true, N_nominal = 1200,
    redeclare function flowCharacteristic =
      Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(
        V_flow_nominal = {0,0.25,0.5}, head_nominal = {100,60,0}))
    annotation(Placement(transformation(extent={{-120,-10},{-100,10}})));

  Modelica.Fluid.Machines.PrescribedPump bomba2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    use_N_in = true, N_nominal = 1200,
    redeclare function flowCharacteristic =
      Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(
        V_flow_nominal = {0,0.25,0.5}, head_nominal = {100,60,0}))
    annotation(Placement(transformation(extent={{80,-10},{100,10}})));

  // Tuberías y Unión
  Modelica.Fluid.Pipes.StaticPipe cano1(redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater, length = 50, diameter = 0.1)
    annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));

  Modelica.Fluid.Pipes.StaticPipe cano2(redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater, length = 50, diameter = 0.1)
    annotation(Placement(transformation(extent={{110,-10},{130,10}})));

  Modelica.Fluid.Pipes.StaticPipe union(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater, length = 30, diameter = 0.1)
    annotation(Placement(transformation(extent={{-10,20},{10,40}})));

  // Tanque Final
  Modelica.Fluid.Vessels.OpenTank tanqueFinal(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height = 10, crossArea = 1, level_start = 0.5, use_portsData = true, nPorts = 2,
    portsData = {
      Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.1),
      Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.1)},
    massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation(Placement(transformation(extent={{30,20},{50,40}})));

  // Controladores
  Modelica.Blocks.Sources.Constant constN1(k = 1200)
    annotation(Placement(transformation(extent={{-120,30},{-100,50}})));

  Modelica.Blocks.Sources.Constant constN2(k = 1200)
    annotation(Placement(transformation(extent={{80,30},{100,50}})));

equation
  connect(recarga1.ports[1], acuifero1.ports[1]);
  connect(recarga2.ports[1], acuifero2.ports[1]);
  connect(acuifero1.ports[2], valvula1.port_a);
  connect(valvula1.port_b, pozo1.ports[1]);
  connect(pozo1.ports[2], bomba1.port_a);
  connect(bomba1.port_b, cano1.port_a);
  connect(cano1.port_b, union.port_a);
  connect(acuifero2.ports[2], valvula2.port_a);
  connect(valvula2.port_b, pozo2.ports[1]);
  connect(pozo2.ports[2], bomba2.port_a);
  connect(bomba2.port_b, cano2.port_a);
  connect(cano2.port_b, union.port_b);
  connect(union.port_b, tanqueFinal.ports[1]);
  connect(constN1.y, bomba1.N_in);
  connect(constN2.y, bomba2.N_in);

annotation(
  uses(Modelica(version="4.0.0")),
  experiment(StartTime=0, StopTime=10, Tolerance=1e-6, Interval=0.01),
  Diagram(coordinateSystem(extent={{-240,-100},{240,100}})));
end pozos_modelo_realista_completo;
