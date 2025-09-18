model pruebacambio
  Modelica.Blocks.Sources.Constant const1(k = 40)  annotation(
    Placement(transformation(origin = {-276, 160}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const11(k = 40) annotation(
    Placement(transformation(origin = {-281, 71}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step1(height = 1, startTime = 5)  annotation(
    Placement(transformation(origin = {-276, 196}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step2(height = 1, startTime = 10)  annotation(
    Placement(transformation(origin = {-287, 107}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Sources.Step step11(height = 1, startTime = 5) annotation(
    Placement(transformation(origin = {-158, 208}, extent = {{-10, -10}, {10, 10}})));
  pozo pozo1(qBomba = 0.1, h_inicial = 30, radioP = 0.2, latitud = 40, longitud = 40)  annotation(
    Placement(transformation(origin = {-204, 174}, extent = {{-20, -20}, {20, 20}})));
  pozo pozo2(qBomba = 0.1, h_inicial = 20, radioP = 0.3, latitud = 30, longitud = 30)  annotation(
    Placement(transformation(origin = {-220, 88}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Sum sum1(nin = 2) annotation(
    Placement(transformation(origin = {-118, 114}, extent = {{-10, -10}, {10, 10}})));
  tanque tanque1(h_inicial = 30, areaTanque = 5, q_demanda = 0.2)  annotation(
    Placement(transformation(origin = {-62, 144}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(step1.y, pozo1.u_bomba) annotation(
    Line(points = {{-264, 196}, {-217, 196}, {-217, 180}}, color = {0, 0, 127}));
  connect(const1.y, pozo1.h_acuifero) annotation(
    Line(points = {{-264, 160}, {-217, 160}, {-217, 171}}, color = {0, 0, 127}));
  connect(step2.y, pozo2.u_bomba) annotation(
    Line(points = {{-275, 107}, {-235, 107}, {-235, 94}, {-234, 94}}, color = {0, 0, 127}));
  connect(const11.y, pozo2.h_acuifero) annotation(
    Line(points = {{-270, 72}, {-234, 72}, {-234, 86}}, color = {0, 0, 127}));
  connect(pozo1.u_q_bomba, sum1.u[1]) annotation(
    Line(points = {{-190, 172}, {-130, 172}, {-130, 114}}, color = {0, 0, 127}));
  connect(pozo2.u_q_bomba, sum1.u[2]) annotation(
    Line(points = {{-206, 86}, {-130, 86}, {-130, 114}}, color = {0, 0, 127}));
  connect(sum1.y, tanque1.in_q_bomba) annotation(
    Line(points = {{-106, 114}, {-76, 114}, {-76, 142}}, color = {0, 0, 127}));
  connect(step11.y, tanque1.in_u_demanda) annotation(
    Line(points = {{-146, 208}, {-76, 208}, {-76, 150}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  Diagram(coordinateSystem(extent = {{-500, -500}, {500, 500}})),
  Icon(coordinateSystem(extent = {{-500, -500}, {500, 500}})),
  version = "");
end pruebacambio;
