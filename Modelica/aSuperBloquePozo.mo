model pozo
  import Modelica.Constants.pi;
 
  parameter Real qBomba = 0;
  parameter Real h_inicial = 0;
  parameter Real radioP(unit="m") = 1 "Radio del pozo";
  parameter Real radioInfluencia = 500;
  parameter Real latitud = 0;
  parameter Real longitud = 0;
  parameter Real T(unit="m2/s") = 4.329e-3 "Transmisividad";
  
  Modelica.Blocks.Logical.Switch Selector annotation(
    Placement(transformation(origin = {-36, 146}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-154, 122}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = 1, uHigh = 2)  annotation(
    Placement(transformation(origin = {-72, 84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(transformation(origin = {-92, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(transformation(origin = {-32, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain Recarga(k = (2*pi*T)/(log(radioInfluencia/radioP))) annotation(
    Placement(transformation(origin = {40, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(transformation(origin = {102, -18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain invAP(k = 1/(2*pi*(radioP)*(radioP))) annotation(
    Placement(transformation(origin = {82, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain K1(k = qBomba) annotation(
    Placement(transformation(origin = {72, 71}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1, outMax = 50, outMin = 0, y_start = h_inicial, limitsAtInit = true, y(fixed = true)) annotation(
    Placement(transformation(origin = {6, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput h_acuifero annotation(
    Placement(transformation(origin = {-180, -18}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-134, -30}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput u_q_bomba annotation(
    Placement(transformation(origin = {194, 63}, extent = {{-21, -21}, {21, 21}}), iconTransformation(origin = {130, -30}, extent = {{-20, -20}, {20, 20}})));
 Modelica.Blocks.Interfaces.RealInput u_bomba annotation(
    Placement(transformation(origin = {-179, 150}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-134, 58}, extent = {{-20, -20}, {20, 20}})));
 Modelica.Blocks.Interfaces.RealOutput h_pozo annotation(
    Placement(transformation(origin = {204, -19}, extent = {{-21, -21}, {21, 21}}), iconTransformation(origin = {130, 58}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(hysteresis.y, Selector.u2) annotation(
    Line(points = {{-61, 84}, {-57, 84}, {-57, 146}, {-49, 146}}, color = {255, 0, 255}));
  connect(const.y, Selector.u3) annotation(
    Line(points = {{-143, 122}, {-65, 122}, {-65, 138}, {-49, 138}}, color = {0, 0, 127}));
  connect(Selector.y, K1.u) annotation(
    Line(points = {{-25, 146}, {71, 146}, {71, 84}}, color = {0, 0, 127}));
  connect(add.y, sqrt1.u) annotation(
    Line(points = {{-81, -24}, {-45, -24}}, color = {0, 0, 127}));
  connect(sqrt1.y, Recarga.u) annotation(
    Line(points = {{-21, -24}, {27, -24}}, color = {0, 0, 127}));
  connect(Recarga.y, add1.u2) annotation(
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
  connect(add.u1, h_acuifero) annotation(
    Line(points = {{-104, -18}, {-180, -18}}, color = {0, 0, 127}));
  connect(K1.y, u_q_bomba) annotation(
    Line(points = {{72, 60}, {122, 60}, {122, 63}, {194, 63}}, color = {0, 0, 127}));
 connect(u_bomba, Selector.u1) annotation(
    Line(points = {{-178, 150}, {-48, 150}, {-48, 154}}, color = {0, 0, 127}));
 connect(limIntegrator.y, h_pozo) annotation(
    Line(points = {{-4, -50}, {-28, -50}, {-28, -118}, {170, -118}, {170, -18}, {204, -18}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    version = "",
    uses(Modelica(version = "4.0.0")));
end pozo;
