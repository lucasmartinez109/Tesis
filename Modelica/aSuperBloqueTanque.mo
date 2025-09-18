model tanque

  parameter Real h_inicial = 0;
  parameter Real areaTanque(unit="m2") = 1;
  parameter Real q_demanda = 1;

  Modelica.Blocks.Math.Gain Qdemanda(k = q_demanda) annotation(
    Placement(transformation(origin = {-48, -75}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {14, -69}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add111(k2 = -1) annotation(
    Placement(transformation(origin = {-19, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Exp exp annotation(
    Placement(transformation(origin = {-90, -11}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain CoedExp(k = -5) annotation(
    Placement(transformation(origin = {-136, 57}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const2(k = 1) annotation(
    Placement(transformation(origin = {-90, 23}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain UnoSobreAt(k = 1/areaTanque) annotation(
    Placement(transformation(origin = {80, 94}, extent = {{-13, -13}, {13, 13}}, rotation = 180)));
  Modelica.Blocks.Continuous.LimIntegrator TANQUE(initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1, outMax = 40, outMin = 0, y_start = h_inicial) annotation(
    Placement(transformation(origin = {12, 95}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Sum sum1(nin = 2) annotation(
    Placement(transformation(origin = {82, -135}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput in_u_demanda annotation(
    Placement(transformation(origin = {-117, -74}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-134, 58}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Gain negativo(k = -1) annotation(
    Placement(transformation(origin = {45, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput in_q_bomba annotation(
    Placement(transformation(origin = {-94, -134}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-134, -30}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(Qdemanda.y, product.u2) annotation(
    Line(points = {{-37, -75}, {1, -75}}, color = {0, 0, 127}));
  connect(add111.y, product.u1) annotation(
    Line(points = {{-8, -4}, {-6, -4}, {-6, -64}, {2, -64}}, color = {0, 0, 127}));
  connect(exp.y, add111.u2) annotation(
    Line(points = {{-79, -11}, {-31, -11}, {-31, -9}}, color = {0, 0, 127}));
  connect(const2.y, add111.u1) annotation(
    Line(points = {{-79, 23}, {-44, 23}, {-44, 3}, {-30, 3}}, color = {0, 0, 127}));
  connect(CoedExp.y, exp.u) annotation(
    Line(points = {{-136, 46}, {-136, -12}, {-102, -12}}, color = {0, 0, 127}));
  connect(UnoSobreAt.y, TANQUE.u) annotation(
    Line(points = {{66, 94}, {23.7, 94}}, color = {0, 0, 127}));
  connect(TANQUE.y, CoedExp.u) annotation(
    Line(points = {{1, 95}, {-137, 95}, {-137, 69}}, color = {0, 0, 127}));
  connect(sum1.y, UnoSobreAt.u) annotation(
    Line(points = {{93, -135}, {113, -135}, {113, 94}, {96, 94}}, color = {0, 0, 127}));
  connect(in_u_demanda, Qdemanda.u) annotation(
    Line(points = {{-117, -74}, {-60, -74}}, color = {0, 0, 127}));
  connect(product.y, negativo.u) annotation(
    Line(points = {{26, -68}, {34, -68}, {34, -70}}, color = {0, 0, 127}));
  connect(negativo.y, sum1.u[1]) annotation(
    Line(points = {{56, -70}, {70, -70}, {70, -134}}, color = {0, 0, 127}));
  connect(in_q_bomba, sum1.u[2]) annotation(
    Line(points = {{-92, -130}, {70, -130}, {70, -134}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-160, 120}, {120, -160}})),
    version = "",
    uses(Modelica(version = "4.0.0")));
end tanque;
