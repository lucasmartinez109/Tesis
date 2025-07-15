model prueba1_no_mid_tanks
  inner Modelica.Fluid.System system(p_ambient = 101325, T_ambient = 293.15, g = 9.81)
    annotation(Placement(transformation(extent={{-80,60},{-60,80}})));

  Modelica.Fluid.Sources.FixedBoundary aquifer1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    p=system.p_ambient, use_T=true, T=system.T_ambient, nPorts=1)
    annotation(Placement(transformation(extent={{-180,-50},{-160,-30}})));

  Modelica.Fluid.Vessels.OpenTank pozo1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height=10, crossArea=1, level_start=2,
    nPorts=2, use_portsData=true,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1),
               Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1)},
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation(Placement(transformation(extent={{-150,-50},{-130,-30}})));

  Modelica.Fluid.Sources.FixedBoundary aquifer2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    p=system.p_ambient, use_T=true, T=system.T_ambient, nPorts=1)
    annotation(Placement(transformation(extent={{20,-50},{40,-30}})));

  Modelica.Fluid.Vessels.OpenTank pozo2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height=10, crossArea=1, level_start=2,
    nPorts=2, use_portsData=true,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1),
               Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1)},
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation(Placement(transformation(extent={{50,-50},{70,-30}})));

  Modelica.Fluid.Machines.PrescribedPump pump(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    use_N_in=true, N_nominal=1200,
    N_in(start=1200, fixed=true),
    redeclare function flowCharacteristic =
      Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(
        V_flow_nominal={0,0.25,0.5}, head_nominal={100,60,0}))
    annotation(Placement(transformation(extent={{-120,-10},{-100,10}})));

  Modelica.Fluid.Pipes.StaticPipe pipe(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=50, diameter=0.1, height_ab=5)
    annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));

  Modelica.Fluid.Machines.PrescribedPump pump2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    use_N_in=true, N_nominal=1200,
    N_in(start=1200, fixed=true),
    redeclare function flowCharacteristic =
      Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(
        V_flow_nominal={0,0.25,0.5}, head_nominal={100,60,0}))
    annotation(Placement(transformation(extent={{80,-10},{100,10}})));

  Modelica.Fluid.Pipes.StaticPipe pipe2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=50, diameter=0.1, height_ab=5)
    annotation(Placement(transformation(extent={{110,-10},{130,10}})));

  Modelica.Fluid.Pipes.StaticPipe mergePipe(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=30, diameter=0.1, height_ab=0)
    annotation(Placement(transformation(extent={{-10,20},{10,40}})));

  Modelica.Fluid.Vessels.OpenTank tankFinal(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    height=10, crossArea=1, level_start=0.5,
    nPorts=2, use_portsData=true,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1),
               Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1)},
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation(Placement(transformation(extent={{30,20},{50,40}})));

  Modelica.Blocks.Sources.Constant constN1(k=1200)
    annotation(Placement(transformation(extent={{-120,30},{-100,50}})));

  Modelica.Blocks.Sources.Constant constN2(k=1200)
    annotation(Placement(transformation(extent={{80,30},{100,50}})));

equation
  connect(aquifer1.ports[1], pozo1.ports[1]) 
    annotation(Line(points={{-160,-40},{-150,-40}}, color={0,127,255}));
  connect(pozo1.ports[2], pump.port_a) 
    annotation(Line(points={{-130,-40},{-130,0},{-120,0}}, color={0,127,255}));
  connect(pump.port_b, pipe.port_a) 
    annotation(Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(pipe.port_b, mergePipe.port_a) 
    annotation(Line(points={{-70,0},{-10,0},{0,20}}, color={0,127,255}));
  connect(aquifer2.ports[1], pozo2.ports[1]) 
    annotation(Line(points={{40,-40},{50,-40}}, color={0,127,255}));
  connect(pozo2.ports[2], pump2.port_a) 
    annotation(Line(points={{70,-40},{70,0},{80,0}}, color={0,127,255}));
  connect(pump2.port_b, pipe2.port_a) 
    annotation(Line(points={{100,0},{110,0}}, color={0,127,255}));
  connect(pipe2.port_b, mergePipe.port_b) 
    annotation(Line(points={{130,0},{10,0},{0,20}}, color={0,127,255}));
  connect(mergePipe.port_b, tankFinal.ports[1]) 
    annotation(Line(points={{10,30},{30,30}}, color={0,127,255}));
  connect(constN1.y, pump.N_in) 
    annotation(Line(points={{-100,40},{-100,20},{-110,20},{-110,10}}, color={0,0,127}));
  connect(constN2.y, pump2.N_in) 
    annotation(Line(points={{100,40},{100,20},{90,20},{90,10}}, color={0,0,127}));

annotation(
  uses(Modelica(version="4.0.0")),
  experiment(StartTime=0, StopTime=5, Tolerance=1e-6, Interval=0.01),
  Diagram(coordinateSystem(extent={{-200,-100},{200,100}})),
  Icon(coordinateSystem(extent={{-200,-100},{200,100}})));
end prueba1_no_mid_tanks;
