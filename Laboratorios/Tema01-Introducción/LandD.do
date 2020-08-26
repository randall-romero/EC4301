/*====================================================================
LandD.do: Ejemplo numérico para ilustrar el uso de los operadores de
rezago, diferencia, y diferencia estacional.

Basado en Levendis 2018 Time Series Econometrics, pp4-5


Universidad de Costa Rica
Escuela de Economía
Curso EC4301 Macroeconometría
Randall Romero Aguilar
2020-01-22
======================================================================*/


* Leer una serie de tiempo ficticia de data\LandD.csv y mostrarlos
import delimited data\LandD.csv, delimiter(comma) clear
list

* Generar una serie trimestral y declarar los datos como serie de tiempo
generate t = quarterly(trimestre,"YQ")
tsset t, quarterly

* Operador de rezagos
gen Lag_y = L.y
gen Lag2_y = L2.y

* Operador de diferencias
gen D_y = D.y
gen D2_y = D2.y

* Operador de diferencia estacional
gen S_y = S4.y

* Mostrar los resultados
list
