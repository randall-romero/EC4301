cls
/*=======================================================================
wntestq.do: Pruebas de ruido blanco.

Universidad de Costa Rica
Escuela de Economía
Curso: EC4301 Macroeconometría
Profesor: Randall Romero Aguilar, PhD
2020-03-07
========================================================================*/

* Ajustes varios
graph drop _all
set autotabgraphs on



*///////////////////////////////////////////////////////////////////////////////
*=========EJEMPLO 1> Crecimiento del IMAE de Costa Rica, serie tendencia-ciclo

* Leemos datos del IMAE de Costa Rica (original y tendencia-ciclo)
import delimited "data\log_imae.csv", clear

* Indexamos datos como series de tiempo
gen mes = monthly(v1, "YM")
tsset mes, monthly
drop v1

* Calculamos el crecimiento
generate crecimiento = D.tendenciaciclo

* Graficamos la serie
tsline crecimiento, name(imae) xtitle(" ") title("Crecimiento del IMAE")

* Calculamos correlograma, con pruebas Q de Ljung-Box
corrgram crecimiento, lags(12) noplot
ac crecimiento, name(rho_imae) 

* Estadístico de Durbin-Watson
regress crecimiento
estat dwatson







*///////////////////////////////////////////////////////////////////////////////
*=========EJEMPLO 2> Crecimiento del tipo de cambio Euro/USD

* Leemos datos de tipo de cambio dólar/euro
import delimited "data/euro.csv", clear

* Generamos serie de fechas diarias
generate t = date(fecha,"YMD")
tsset t, daily
drop fecha

* Generamos serie de días hábiles (no hay datos para fin de semana)
bcal create euro, from(t) replace
generate fecha = bofd("euro", t)
format fecha %tbeuro
tsset fecha
drop t

* Calculamos el crecimiento diario
generate leuro = log(euro)
generate depreciacion = D.leuro

* Graficamos la serie
tsline depreciacion, name(euro) xtitle(" ") title("Crecimiento diario del tipo de cambio Euro/USD")

* Calculamos correlograma, con pruebas Q de Ljung-Box
corrgram depreciacion, lags(12) noplot
ac depreciacion, name(rho_euro) 

* Estadístico de Durbin-Watson
regress depreciacion
estat dwatson

