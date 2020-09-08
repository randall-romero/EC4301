cls

/*====================================================================
arch-tipo-cambio.do: Estimación de un modelo ARCH para el tipo de cambio
del colón contra el dolar


Datos tomados de 
BCCR, ServicioWeb, indicador = 317

Universidad de Costa Rica
Escuela de Economía
Curso EC4301 Macroeconometría
Randall Romero Aguilar
2020-04-26
======================================================================*/

* Ajustes varios
graph drop _all
set autotabgraphs on
set more off

* Leer datos de tipo de cambio colones/dólar
import delimited "tipo-cambio.csv", encoding(UTF-8) clear

* Generar serie de fechas diarias
generate t = date(v1, "YMD")


* Generar serie de días hábiles (no hay datos para fin de semana)
bcal create tcambiocal, from(t) replace
generate fecha = bofd("tcambiocal", t)
format fecha %tbtcambiocal
tsset fecha

* Cambiar nombre de serie de tipo de cambio, y graficarla
rename tipodecambio tc
tsline tc, name(tipocambio) aspectratio(0.2)

* Obtener los cuadrados de los residuos de la ecuación de la media
quietly regress tc /*ecuación de la media del proceso (solo un intercepto) */
predict e, resid /* residuos*/
gen e2 = e^2  /* cuadrados de los residuos */

* Mostrar el autocorrelograma de los cuadrados de los residuos
ac e2, name(acplot) aspectratio(0.2)


* Determinar si hay efectos ARCH, test de multiplicador de lagrange
estat archlm, lags(1/15)


*==================AJUSTE DE UN MODELO ARCH=====================================

* Obtener número óptimo de rezagos para el modelo ARCH
forvalues lags=1/11{
	quietly arch tc, arch(1/`lags')  /* estimar un ARCH con un número creciente de rezagos*/
	quietly estat ic   /* obtener AIC y BIC */
	matrix temp = r(S) /* guardar datos en matriz para poder mostrarlos abajo */
	display "lags = " `lags' "    AIC = " temp[1,5] "    BIC = " temp[1,6]
}

* En el óptimo el rezago es 10, estimamos el modelo respectivo
arch tc, arch(1/10)


* Pronosticamos la varianza

tsappend, add(20)  /* ampliamos la muestra un mes*/

replace t = 7 + L5.t in -20/l
bcal create tcambiocal, from(t) replace
replace fecha = bofd("tcambiocal", t) in -20/l


predict varhat, variance /* pronóstico de la varianza */
tsline e2 varhat in -40/l, name(varfcast) aspectratio(0.2) /* Gráfico del pronóstico, dos meses*/
list in -40/l /* mostrar esos valores */



*==================AJUSTE DE UN MODELO GARCH====================================
* Obtener número óptimo de rezagos para el modelo GARCH
forvalues p=0/2{
forvalues q=1/4{
  if `p'==0{
    quietly arch tc, arch(1/`q')  
  } 
  else {
    quietly arch tc, arch(1/`q') garch(1/`p') 
  }	
  quietly estat ic   /* obtener AIC y BIC */
  matrix temp = r(S) /* guardar datos en matriz para poder mostrarlos abajo */
  display "p = " `p' " q = " `q' " AIC = " temp[1,5] " BIC = " temp[1,6]
}
}


* En el óptimo el rezago es (2, 3), estimamos el modelo respectivo
arch tc, arch(1/3) garch(1/2)

* Pronosticamos la varianza

predict varhat2, variance /* pronóstico de la varianza */
tsline e2 varhat2 in -40/l, name(varfcast2) aspectratio(0.2) /* Gráfico del pronóstico, dos meses*/
list in -40/l /* mostrar esos valores */


*==================AJUSTE DE UN MODELO AR(1)-GARCH==============================
* Obtener número óptimo de rezagos para el modelo GARCH
forvalues p=0/2{
forvalues q=1/4{
  if `p'==0{
    quietly arch tc L.tc, arch(1/`q')  
  } 
  else {
    quietly arch tc L.tc, arch(1/`q') garch(1/`p') 
  }	
  quietly estat ic   /* obtener AIC y BIC */
  matrix temp = r(S) /* guardar datos en matriz para poder mostrarlos abajo */
  display "p = " `p' " q = " `q' " AIC = " temp[1,5] " BIC = " temp[1,6]
}
}


*===============================================================================
* Exportar los gráficos
graph export stata-tc-original.pdf, name(tipocambio) replace
graph export stata-tc-acfplot.pdf, name(acplot) replace
graph export stata-tc-varforecast.pdf, name(varfcast) replace
graph export stata-tc-varforecast2.pdf, name(varfcast2) replace
