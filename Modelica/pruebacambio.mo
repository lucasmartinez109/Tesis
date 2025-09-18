model pruebacambio
  Modelica.Blocks.Sources.Pulse entrada annotation(
    Placement(transformation(origin = {-410, 356}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch Selector annotation(
    Placement(transformation(origin = {-294, 348}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0)  annotation(
    Placement(transformation(origin = {-412, 324}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis annotation(
    Placement(transformation(origin = {-330, 286}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = 40)  annotation(
    Placement(transformation(origin = {-418, 182}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(transformation(origin = {-350, 178}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(transformation(origin = {-290, 178}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain K(k = 0.8)  annotation(
    Placement(transformation(origin = {-218, 178}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k1 = -1)  annotation(
    Placement(transformation(origin = {-156, 184}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain invAP(k = 0.5) annotation(
    Placement(transformation(origin = {-176, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain K1(k = 1) annotation(
    Placement(transformation(origin = {-186, 273}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
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
    Placement(transformation(origin = {-44, 400}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain UnoSobreAt(k = 0.1) annotation(
    Placement(transformation(origin = {118, 441}, extent = {{-13, -13}, {13, 13}}, rotation = 180)));
  Modelica.Blocks.Continuous.LimIntegrator dHp__dt(k = 1, outMax = 50, outMin = 0, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0)  annotation(
    Placement(transformation(origin = {-252, 152}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Continuous.LimIntegrator dHp__dt1(initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1, outMax = 10, outMin = 0, y_start = 3) annotation(
    Placement(transformation(origin = {42, 442}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(hysteresis.y, Selector.u2) annotation(
    Line(points = {{-318, 286}, {-314, 286}, {-314, 348}, {-306, 348}}, color = {255, 0, 255}));
  connect(entrada.y, Selector.u1) annotation(
    Line(points = {{-398, 356}, {-306, 356}}, color = {0, 0, 127}));
  connect(const.y, Selector.u3) annotation(
    Line(points = {{-400, 324}, {-322, 324}, {-322, 340}, {-306, 340}}, color = {0, 0, 127}));
  connect(Selector.y, K1.u) annotation(
    Line(points = {{-282, 348}, {-186, 348}, {-186, 286}}, color = {0, 0, 127}));
  connect(const1.y, add.u1) annotation(
    Line(points = {{-406, 182}, {-362, 182}, {-362, 184}}, color = {0, 0, 127}));
  connect(add.y, sqrt1.u) annotation(
    Line(points = {{-338, 178}, {-302, 178}}, color = {0, 0, 127}));
  connect(sqrt1.y, K.u) annotation(
    Line(points = {{-278, 178}, {-230, 178}}, color = {0, 0, 127}));
  connect(K.y, add1.u2) annotation(
    Line(points = {{-206, 178}, {-168, 178}}, color = {0, 0, 127}));
  connect(K1.y, add1.u1) annotation(
    Line(points = {{-186, 262}, {-186, 190}, {-168, 190}}, color = {0, 0, 127}));
  connect(add11.u2, K1.y) annotation(
    Line(points = {{82, 200}, {-146, 200}, {-146, 262}, {-186, 262}}, color = {0, 0, 127}));
  connect(add1.y, invAP.u) annotation(
    Line(points = {{-144, 184}, {-134, 184}, {-134, 116}, {-164, 116}}, color = {0, 0, 127}));
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
    Line(points = {{-32, 400}, {-14, 400}, {-14, 350}, {0, 350}}, color = {0, 0, 127}));
  connect(CoedExp.y, exp.u) annotation(
    Line(points = {{-106, 394}, {-106, 336}, {-72, 336}}, color = {0, 0, 127}));
  connect(add11.y, UnoSobreAt.u) annotation(
    Line(points = {{104, 206}, {156, 206}, {156, 442}, {134, 442}}, color = {0, 0, 127}));
  connect(invAP.y, dHp__dt.u) annotation(
    Line(points = {{-186, 116}, {-226, 116}, {-226, 152}, {-240, 152}}, color = {0, 0, 127}));
  connect(dHp__dt.y, add.u2) annotation(
    Line(points = {{-262, 152}, {-374, 152}, {-374, 172}, {-362, 172}}, color = {0, 0, 127}));
  connect(dHp__dt.y, hysteresis.u) annotation(
    Line(points = {{-262, 152}, {-380, 152}, {-380, 286}, {-342, 286}}, color = {0, 0, 127}));
  connect(UnoSobreAt.y, dHp__dt1.u) annotation(
    Line(points = {{104, 442}, {54, 442}}, color = {0, 0, 127}));
  connect(dHp__dt1.y, CoedExp.u) annotation(
    Line(points = {{32, 442}, {-106, 442}, {-106, 416}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  Diagram(coordinateSystem(extent = {{-500, -500}, {500, 500}})),
  Icon(coordinateSystem(extent = {{-500, -500}, {500, 500}})),
  version = "");
end pruebacambio;
