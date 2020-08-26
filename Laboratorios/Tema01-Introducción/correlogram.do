/*=======================================================================
correlogram.do: Cálculando el autocorrelograma para el IMAE de Costa Rica.

Universidad de Costa Rica
Escuela de Economía
Curso: EC4301 Macroeconometría
Profesor: Randall Romero Aguilar, PhD
2020-03-05
========================================================================*/

* Ajustes varios
graph drop _all
set autotabgraphs on


* Leemos datos del IMAE de Costa Rica (original y tendencia-ciclo)
import delimited "data\log_imae.csv", clear

* Indexamos datos como series de tiempo
gen mes = monthly(v1, "YM")
tsset mes, monthly
drop v1

* Graficamos las dos series
twoway (tsline original) (tsline tendenciaciclo), name(niveles) xtitle(" ") ///
	 title("IMAE, evolución histórica")


	 
* OPCION 1> Gráficos sencillos================================================ 
	 
* Hacemos los autocorrelogramas

ac original, name(ac_or) 
ac tendenciaciclo, name(ac_tc)

ac D.original, name(ac_d_or)  
ac D.tendenciaciclo, name(ac_d_tc) 

ac S12.original, name(ac_s12_or) 
ac S12.tendenciaciclo, name(ac_s12_tc)

* Combinar los gráficos
graph combine ac_or ac_tc ac_d_or ac_d_tc ac_s12_or ac_s12_tc, xcommon ycommon ///
	name(autoc1) title("Autocorrelograma del IMAE en Costa Rica") cols(2) imargin(tiny)

graph drop ac_or ac_tc ac_d_or ac_d_tc ac_s12_or ac_s12_tc


* Hacemos los autocorrelogramas parciales

pac original, name(pac_or) 
pac tendenciaciclo, name(pac_tc)

pac D.original, name(pac_d_or)
pac D.tendenciaciclo, name(pac_d_tc) 

pac S12.original, name(pac_s12_or)
pac S12.tendenciaciclo, name(pac_s12_tc) 

* Combinar los gráficos
graph combine pac_or pac_tc pac_d_or pac_d_tc pac_s12_or pac_s12_tc, xcommon ycommon ///
	name(pautoc1) title("Autocorrelograma parcial del IMAE en Costa Rica") cols(2) imargin(tiny)

graph drop pac_or pac_tc pac_d_or pac_d_tc pac_s12_or pac_s12_tc



* OPCION 2> Gráficos más elaborados================================================ 
	 
* Opciones comunes para los gráficos
local opciones title("") xtitle(" ") ytitle("") note("") xlabel(none) ylabel(none)
local xticks xlabel(0(12)36) 
local yticks ylabel(-1(1)1, format(%1.0f)) 
	 
* Hacemos los autocorrelogramas

ac original, name(ac_or) `opciones'   `yticks' ytitle("log(IMAE)") title("Original") 
ac tendenciaciclo, name(ac_tc) `opciones' title("Tendencia-ciclo") 

ac D.original, name(ac_d_or) `opciones' `yticks' ytitle("D.log(IMAE)") 
ac D.tendenciaciclo, name(ac_d_tc) `opciones' 

ac S12.original, name(ac_s12_or) `opciones' `xticks' `yticks' ytitle("S12.log(IMAE)") // note("Bartlett's formula for MA(q) 95% confidence bands")
ac S12.tendenciaciclo, name(ac_s12_tc) `opciones' `xticks'

* Combinar los gráficos
graph combine ac_or ac_tc ac_d_or ac_d_tc ac_s12_or ac_s12_tc, xcommon ycommon ///
	name(autoc) title("Autocorrelograma del IMAE en Costa Rica") cols(2) imargin(tiny)

graph drop ac_or ac_tc ac_d_or ac_d_tc ac_s12_or ac_s12_tc


* Hacemos los autocorrelogramas parciales

pac original, name(pac_or)  `opciones' `yticks' ytitle("log(IMAE)") title("Original")
pac tendenciaciclo, name(pac_tc)  `opciones'  title("Tendencia-ciclo")

pac D.original, name(pac_d_or)  `opciones' `yticks' ytitle("D. log(IMAE)")
pac D.tendenciaciclo, name(pac_d_tc)  `opciones' 

pac S12.original, name(pac_s12_or) `opciones' `xticks' `yticks' ytitle("S12.log(IMAE)") //note("95% Confidence bands [se = 1/sqrt(n)]")
pac S12.tendenciaciclo, name(pac_s12_tc)  `opciones' `xticks' 

* Combinar los gráficos
graph combine pac_or pac_tc pac_d_or pac_d_tc pac_s12_or pac_s12_tc, xcommon ycommon ///
	name(pautoc) title("Autocorrelograma parcial del IMAE en Costa Rica") cols(2) imargin(tiny)

graph drop pac_or pac_tc pac_d_or pac_d_tc pac_s12_or pac_s12_tc


*=================================================================================
*=================================================================================
* ¿Es el crecimiento del IMAE ruido blanco?
* Pruebas de Ljung-Box
corrgram D.tendenciaciclo, lags(7)
