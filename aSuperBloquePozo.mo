model a
  Modelica.Blocks.Sources.Pulse entrada annotation(
    Placement(transformation(origin = {-152, 154}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch Selector annotation(
    Placement(transformation(origin = {-36, 146}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-154, 122}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis annotation(
    Placement(transformation(origin = {-72, 84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(transformation(origin = {-92, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(transformation(origin = {-32, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain K(k = 0.8) annotation(
    Placement(transformation(origin = {40, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(transformation(origin = {102, -18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain invAP(k = 0.5) annotation(
    Placement(transformation(origin = {82, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain K1(k = 1) annotation(
    Placement(transformation(origin = {72, 71}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1, outMax = 50, outMin = 0, y_start = 0) annotation(
    Placement(transformation(origin = {6, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(transformation(origin = {-180, -18}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-174, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(transformation(origin = {161, 39}, extent = {{-21, -21}, {21, 21}}), iconTransformation(origin = {186, 2}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(hysteresis.y, Selector.u2) annotation(
    Line(points = {{-61, 84}, {-57, 84}, {-57, 146}, {-49, 146}}, color = {255, 0, 255}));
  connect(entrada.y, Selector.u1) annotation(
    Line(points = {{-141, 154}, {-49, 154}}, color = {0, 0, 127}));
  connect(const.y, Selector.u3) annotation(
    Line(points = {{-143, 122}, {-65, 122}, {-65, 138}, {-49, 138}}, color = {0, 0, 127}));
  connect(Selector.y, K1.u) annotation(
    Line(points = {{-25, 146}, {71, 146}, {71, 84}}, color = {0, 0, 127}));
  connect(add.y, sqrt1.u) annotation(
    Line(points = {{-81, -24}, {-45, -24}}, color = {0, 0, 127}));
  connect(sqrt1.y, K.u) annotation(
    Line(points = {{-21, -24}, {27, -24}}, color = {0, 0, 127}));
  connect(K.y, add1.u2) annotation(
    Line(points = {{51, -24}, {89, -24}}, color = {0, 0, 127}));
  connect(K1.y, add1.u1) annotation(
    Line(points = {{72, 60}, {72, -12}, {90, -12}}, color = {0, 0, 127}));
  connect(add1.y, invAP.u) annotation(
    Line(points = {{113, -18}, {123, -18}, {123, -86}, {93, -86}}, color = {0, 0, 127}));
  connect(invAP.y, limIntegrator.u) annotation(
    Line(points = {{71, -86}, {31, -86}, {31, -50}, {17, -50}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add.u2) annotation(
    Line(points = {{-5, -50}, {-117, -50}, {-117, -30}, {-105, -30}}, color = {0, 0, 127}));
  connect(limIntegrator.y, hysteresis.u) annotation(
    Line(points = {{-5, -50}, {-123, -50}, {-123, 84}, {-85, 84}}, color = {0, 0, 127}));
  connect(add.u1, u) annotation(
    Line(points = {{-104, -18}, {-180, -18}}, color = {0, 0, 127}));
  connect(K1.y, y) annotation(
    Line(points = {{72, 60}, {122, 60}, {122, 40}, {162, 40}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    version = "",
    uses(Modelica(version = "4.0.0")));
end a;
