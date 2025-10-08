model pruebacambio

import UtilPozos.*;

  Modelica.Blocks.Sources.Constant const1(k = 40)  annotation(
    Placement(transformation(origin = {-276, 160}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const11(k = 40) annotation(
    Placement(transformation(origin = {-281, 71}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step1(height = 1, startTime = 0)  annotation(
    Placement(transformation(origin = {-276, 196}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step2(height = 1, startTime = 0)  annotation(
    Placement(transformation(origin = {-287, 107}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Sources.Step step11(height = 1, startTime = 5) annotation(
    Placement(transformation(origin = {-158, 208}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Sum sum1(nin = 2) annotation(
    Placement(transformation(origin = {-118, 114}, extent = {{-10, -10}, {10, 10}})));
  tanque tanque1(h_inicial = 30, areaTanque = 5, q_demanda = 0.2)  annotation(
    Placement(transformation(origin = {-62, 144}, extent = {{-10, -10}, {10, 10}})));

// === INTERFERENCIA (parámetros) ===
  parameter Integer n = 2 "Cantidad de pozos";
  parameter Real T = 374 "Transmisividad [m2/día]";
  parameter Real R = 10000 "Radio de influencia [m]";
  
  parameter Real lat[n] = {pozo1.latitud, pozo2.latitud} "Latitudes [deg]";
  parameter Real lon[n] = {pozo1.longitud, pozo2.longitud} "Longitudes [deg]";
  
  parameter Real rw[n]  = {pozo1.radioP, pozo2.radioP} "Radios de pozo [m]";

// === INTERFERENCIA (variables) ===
  Real Q[n]       "Caudales por pozo [m3/día]";
  Real r_ij[n,n]  "Distancias entre pozos [m] (diagonal = rw)";
  Real S[n,n]     "Matriz de abatimientos [m]";
  Real s_total[n] "Abatimiento total por pozo [m]";
  pozo pozo1(qBomba = 0.005833, h_inicial = 30, radioP = 0.150, latitud = -34.3885, longitud = -56.5441)  annotation(
    Placement(transformation(origin = {-212, 176}, extent = {{-20, -20}, {20, 20}})));
  pozo pozo2(qBomba = 0.1, h_inicial = 20, radioP = 0.3, latitud = -34.3906, longitud = -56.5463, T = 1)  annotation(
    Placement(transformation(origin = {-220, 94}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(sum1.y, tanque1.in_q_bomba) annotation(
    Line(points = {{-106, 114}, {-76, 114}, {-76, 142}}, color = {0, 0, 127}));
  connect(step11.y, tanque1.in_u_demanda) annotation(
    Line(points = {{-146, 208}, {-76, 208}, {-76, 150}}, color = {0, 0, 127}));
// === Mapear caudales reales de los pozos → Q ===
  Q[1] = pozo1.qBomba*(step1.y);
// caudal de cada bomba multiplicado por la señal de encendido
  Q[2] = pozo2.qBomba*(step2.y);
// <-- CAMBIAR 'Q_out' por el nombre real en tu 'pozo2'
// === PEGAR AQUÍ: Interferencia Thiem (antes del annotation)  ===
  for i in 1:n loop
    for j in 1:n loop
      r_ij[i, j] = if i == j then rw[j] else haversine(lat[i], lon[i], lat[j], lon[j]);
      S[i, j] = thiemAbatimiento(Q[j], T, R, r_ij[i, j]);
    end for;
    s_total[i] = sum(S[i, j] for j in 1:n);
  end for;
// ===  FIN del bloque de interferencia  ===
  connect(step1.y, pozo1.u_bomba) annotation(
    Line(points = {{-264, 196}, {-226, 196}, {-226, 182}}, color = {0, 0, 127}));
  connect(const1.y, pozo1.h_acuifero) annotation(
    Line(points = {{-264, 160}, {-226, 160}, {-226, 174}}, color = {0, 0, 127}));
  connect(pozo1.u_q_bomba, sum1.u[1]) annotation(
    Line(points = {{-198, 174}, {-130, 174}, {-130, 114}}, color = {0, 0, 127}));
  connect(step2.y, pozo2.u_bomba) annotation(
    Line(points = {{-274, 108}, {-234, 108}, {-234, 100}}, color = {0, 0, 127}));
  connect(const11.y, pozo2.h_acuifero) annotation(
    Line(points = {{-270, 72}, {-234, 72}, {-234, 92}}, color = {0, 0, 127}));
  connect(pozo2.u_q_bomba, sum1.u[2]) annotation(
    Line(points = {{-206, 92}, {-130, 92}, {-130, 114}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  Diagram(coordinateSystem(extent = {{-500, -500}, {500, 500}})),
  Icon(coordinateSystem(extent = {{-500, -500}, {500, 500}})),
  version = "");
end pruebacambio;
