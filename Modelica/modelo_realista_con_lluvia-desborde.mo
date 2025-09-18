model pozos_modelo_con_salida
  inner Modelica.Fluid.System system(p_ambient=101325, T_ambient=293.15, g=9.81);

  // === LLUVIA CLIMÁTICA ===
  Modelica.Blocks.Sources.Sine lluvia1(f=1/100, amplitude=0.01, offset=0.01)
    annotation(Placement(transformation(extent={{-300,80},{-280,100}})));
  Modelica.Blocks.Math.Gain escalaLluvia1(k=1)
    annotation(Placement(transformation(extent={{-270,80},{-250,100}})));

  Modelica.Blocks.Sources.Sine lluvia2(f=1/120, amplitude=0.008, offset=0.012)
    annotation(Placement(transformation(extent={{-300,40},{-280,60}})));
  Modelica.Blocks.Math.Gain escalaLluvia2(k=1)
    annotation(Placement(transformation(extent={{-270,40},{-250,60}})));

  // === RECARGA ===
  Modelica.Fluid.Sources.MassFlowSource_T recarga1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    use_m_flow_in = true, T = 293.15, nPorts = 1)
    annotation(Placement(transformation(extent={{-220,-70},{-200,-50}})));

  Modelica.Fluid.Sources.MassFlowSource_T recarga2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    use_m_flow_in = true, T = 293.15, nPorts = 1)
    annotation(Placement(transformation(extent={{-20,-70},{0,-50}})));

  // === ACUÍFEROS ===
  Modelica.Fluid.Vessels.OpenTank acuifero1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height=50, crossArea=1, level_start=30, use_portsData=true, nPorts=2,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.02),
               Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.02)})
    annotation(Placement(transformation(extent={{-190,-50},{-170,-30}})));

  Modelica.Fluid.Vessels.OpenTank acuifero2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height=50, crossArea=1, level_start=30, use_portsData=true, nPorts=2,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.02),
               Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.02)})
    annotation(Placement(transformation(extent={{10,-50},{30,-30}})));

  // === VÁLVULAS ===
  Modelica.Fluid.Valves.ValveLinear valvula1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_nominal=0.05, dp_nominal=1000, opening=0.9)
    annotation(Placement(transformation(extent={{-160,-20},{-140,0}})));

  Modelica.Fluid.Valves.ValveLinear valvula2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_nominal=0.05, dp_nominal=1000, opening=0.9)
    annotation(Placement(transformation(extent={{40,-20},{60,0}})));

  // === POZOS ===
  Modelica.Fluid.Vessels.OpenTank pozo1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height=10, crossArea=2, level_start=2, use_portsData=true, nPorts=2,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.05),
               Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.05)})
    annotation(Placement(transformation(extent = {{-130, -50}, {-110, -30}})));

  Modelica.Fluid.Vessels.OpenTank pozo2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height=10, crossArea=2, level_start=2, use_portsData=true, nPorts=2,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.05),
               Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.05)})
    annotation(Placement(transformation(extent={{70,-50},{90,-30}})));

  // === BOMBAS ===
  Modelica.Fluid.Machines.PrescribedPump bomba1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    use_N_in=true, N_nominal=1200,
    redeclare function flowCharacteristic=
      Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(
        V_flow_nominal={0, 0.25, 0.5}, head_nominal={100, 60, 0}))
    annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));

  Modelica.Fluid.Machines.PrescribedPump bomba2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    use_N_in=true, N_nominal=1200,
    redeclare function flowCharacteristic=
      Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(
        V_flow_nominal={0, 0.25, 0.5}, head_nominal={100, 60, 0}))
    annotation(Placement(transformation(extent={{110,-10},{130,10}})));

  // === TANQUE FINAL ===
  Modelica.Fluid.Vessels.OpenTank tanqueFinal(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height=10, crossArea=1, level_start=0.5, use_portsData=true, nPorts=3,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.05),
               Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.05),
               Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.05)})
    annotation(Placement(transformation(extent={{10,30},{30,50}})));

  // === SALIDA DEL TANQUE FINAL ===
  Modelica.Fluid.Sources.FixedBoundary salida(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=1, p=system.p_ambient, use_T=true, T=system.T_ambient)
    annotation(Placement(transformation(extent={{60,30},{80,50}})));

  // === CONTROL BOMBAS ===
  Modelica.Blocks.Sources.Constant constN1(k=1200);
  Modelica.Blocks.Sources.Constant constN2(k=1200);

equation
  // Lluvia → escala → recarga
  connect(lluvia1.y, escalaLluvia1.u);
  connect(lluvia2.y, escalaLluvia2.u);
  connect(escalaLluvia1.y, recarga1.m_flow_in);
  connect(escalaLluvia2.y, recarga2.m_flow_in);

  // Recarga → acuíferos
  connect(recarga1.ports[1], acuifero1.ports[1]);
  connect(recarga2.ports[1], acuifero2.ports[1]);

  // Acuíferos → válvulas → pozos
  connect(acuifero1.ports[2], valvula1.port_a);
  connect(valvula1.port_b, pozo1.ports[1]);
  connect(acuifero2.ports[2], valvula2.port_a);
  connect(valvula2.port_b, pozo2.ports[1]);

  // Pozos → bombas
  connect(pozo1.ports[2], bomba1.port_a);
  connect(pozo2.ports[2], bomba2.port_a);

  // Bombas → tanque final
  connect(bomba1.port_b, tanqueFinal.ports[1]);
  connect(bomba2.port_b, tanqueFinal.ports[2]);

  // Salida del tanque final
  connect(tanqueFinal.ports[3], salida.ports[1]);

  // Velocidad de bombas
  connect(constN1.y, bomba1.N_in);
  connect(constN2.y, bomba2.N_in);

annotation(
  uses(Modelica(version="4.0.0")),
  experiment(StartTime=0, StopTime=300, Tolerance=1e-6, Interval=1),
  Diagram(coordinateSystem(extent={{-300,-100},{300,120}})));
end pozos_modelo_con_salida;
