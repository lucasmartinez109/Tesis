model pruebacambio
  Modelica.Blocks.Sources.Constant const1(k = 40)  annotation(
    Placement(transformation(origin = {-70, 172}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add11(k1 = -1)  annotation(
    Placement(transformation(origin = {93, 206}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step annotation(
    Placement(transformation(origin = {-76, 272}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain Qdemanda(k = 1) annotation(
    Placement(transformation(origin = {-18, 272}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {44, 278}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add111(k2 = -1)  annotation(
    Placement(transformation(origin = {11, 343}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Exp exp annotation(
    Placement(transformation(origin = {-60, 336}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain CoedExp(k = -5)  annotation(
    Placement(transformation(origin = {-106, 404}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const2(k = 1)  annotation(
    Placement(transformation(origin = {-60, 370}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain UnoSobreAt(k = 0.1) annotation(
    Placement(transformation(origin = {118, 441}, extent = {{-13, -13}, {13, 13}}, rotation = 180)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator1(initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1, outMax = 10, outMin = 0, y_start = 3) annotation(
    Placement(transformation(origin = {42, 442}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Pulse entrada(amplitude = 1) annotation(
    Placement(transformation(origin = {-69, 205}, extent = {{-10, -10}, {10, 10}})));
  pozo pozo1(qBomba = 2, areaPozo = 3, const_recarga = 1, h_inicial = 30)  annotation(
    Placement(transformation(origin = {-1, 197}, extent = {{-25, -25}, {25, 25}})));
equation
  connect(step.y, Qdemanda.u) annotation(
    Line(points = {{-64, 272}, {-30, 272}}, color = {0, 0, 127}));
  connect(Qdemanda.y, product.u2) annotation(
    Line(points = {{-6, 272}, {32, 272}}, color = {0, 0, 127}));
  connect(product.y, add11.u1) annotation(
    Line(points = {{56, 278}, {72, 278}, {72, 212}, {82, 212}}, color = {0, 0, 127}));
  connect(add111.y, product.u1) annotation(
    Line(points = {{22, 344}, {24, 344}, {24, 284}, {32, 284}}, color = {0, 0, 127}));
  connect(exp.y, add111.u2) annotation(
    Line(points = {{-48, 336}, {0, 336}, {0, 338}}, color = {0, 0, 127}));
  connect(const2.y, add111.u1) annotation(
    Line(points = {{-49, 370}, {-14, 370}, {-14, 350}, {0, 350}}, color = {0, 0, 127}));
  connect(CoedExp.y, exp.u) annotation(
    Line(points = {{-106, 394}, {-106, 336}, {-72, 336}}, color = {0, 0, 127}));
  connect(add11.y, UnoSobreAt.u) annotation(
    Line(points = {{104, 206}, {156, 206}, {156, 442}, {134, 442}}, color = {0, 0, 127}));
  connect(UnoSobreAt.y, limIntegrator1.u) annotation(
    Line(points = {{104, 442}, {54, 442}}, color = {0, 0, 127}));
  connect(limIntegrator1.y, CoedExp.u) annotation(
    Line(points = {{32, 442}, {-106, 442}, {-106, 416}}, color = {0, 0, 127}));
  connect(entrada.y, pozo1.u_bomba) annotation(
    Line(points = {{-58, 205}, {-50, 205}, {-50, 204}, {-18, 204}}, color = {0, 0, 127}));
  connect(const1.y, pozo1.h_acuifero) annotation(
    Line(points = {{-59, 172}, {-18, 172}, {-18, 193}}, color = {0, 0, 127}));
  connect(pozo1.u_q_bomba, add11.u2) annotation(
    Line(points = {{15, 193}, {82, 193}, {82, 200}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  Diagram(coordinateSystem(extent = {{-500, -500}, {500, 500}})),
  Icon(coordinateSystem(extent = {{-500, -500}, {500, 500}})),
  version = "");
end pruebacambio;
