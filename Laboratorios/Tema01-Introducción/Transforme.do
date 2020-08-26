/*====================================================================
Transforme.do: Cálculo de transformaciones de la serie del PIB de 
Costa Rica.

Universidad de Costa Rica
Escuela de Economía
Curso: EC4301 Macroeconometría
Profesor: Randall Romero Aguilar, PhD
2020-01-22
======================================================================*/
* Ajustes varios
graph drop _all
set autotabgraphs on

* Leer datos del PIB trimestral de Costa Rica
import delimited data/CR-PIB.csv, clear

* Indexar datos como serie de tiempo
generate t = quarterly(periodo, "YQ")
tsset t, quarterly
order t, first
drop periodo

* Datos originales
tsline pib, xtitle(" ") ytitle(billones de colones constantes) ///
    title(Producto Interno Bruto de Costa Rica) name(pib)

* Primera diferencia	
tsline D.pib, xtitle(" ") ytitle(billones de colones constantes) ///
    title(Cambio trimestral en el PIB de Costa Rica) name(d_pib)

* Tasa de variación
generate growth =  100* D.pib / L.pib
tsline growth, xtitle(" ") ytitle(por ciento) ///
    title(Tasa de crecimiento trimestral del PIB de Costa Rica) name(dpc_pib)

* Tasa de variación continua
generate lpib = log(pib)
generate growth2 = 100 * D.lpib
tsline growth2, xtitle(" ") ytitle(por ciento) ///
    title(Tasa de crecimiento trimestral del PIB de Costa Rica) name(dlog_pib)

* Cambio interanual
tsline S4.pib, xtitle(" ") ytitle(billones de colones constantes) ///
    title(Cambio interanual en el PIB de Costa Rica) name(d4_pib)
	
* Tasa de variación interanual
generate growth3 =  100* S4.lpib
tsline growth3, xtitle(" ") ytitle(por ciento) ///
    title(Tasa de crecimiento interanual del PIB de Costa Rica) name(d4pc_pib)	
	
* Serie suavizada
tssmooth ma pib_ma = pib, window(3 1 0)
tsline pib pib_ma, xtitle(" ") ytitle(billones de colones constantes) ///
    title(Producto Interno Bruto de Costa Rica) name(pib_ma)
