package UtilPozos "Funciones auxiliares para interferencia entre pozos"
  function haversine "Distancia entre (lat,lon) en [deg]; salida en [m]"
    input Real lat1_deg;
    input Real lon1_deg;
    input Real lat2_deg;
    input Real lon2_deg;
    input Real Re = 6371000 "Radio terrestre [m]";
    output Real d "Distancia [m]";
  protected
    Real lat1 = lat1_deg*Modelica.Constants.pi/180;
    Real lon1 = lon1_deg*Modelica.Constants.pi/180;
    Real lat2 = lat2_deg*Modelica.Constants.pi/180;
    Real lon2 = lon2_deg*Modelica.Constants.pi/180;
    Real dlat = lat2 - lat1;
    Real dlon = lon2 - lon1;
    Real a;
  algorithm
    a := sin(dlat/2)^2 + cos(lat1)*cos(lat2)*sin(dlon/2)^2;
    d := 2*Re*asin(min(1.0, sqrt(a)));
  end haversine;

  function thiemAbatimiento "s(r) = (Q / (2*pi*T)) * ln(R/r), con corte por R"
    input Real Qj "Caudal del pozo j [m3/día]";
    input Real T "Transmisividad [m2/día]";
    input Real R "Radio de influencia [m]";
    input Real r "Distancia entre pozos (o radio del pozo si i=j) [m]";
    output Real s_ij "Abatimiento en i por j [m]";
  algorithm
    if r > R then
      s_ij := 0;
    else
      s_ij := (Qj/(2*Modelica.Constants.pi*T))*log(R/max(1e-6, r));
    end if;
  end thiemAbatimiento;
end UtilPozos;
