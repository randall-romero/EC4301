cls
/*====================================================================
arch-simulaciones.do: Simulaciones de modelos ARCH

Código basado en el capítulo 9 de 
Levendis 2019 Time Series Econometrics: Learning Through Replication

Universidad de Costa Rica
Escuela de Economía
Curso EC4301 Macroeconometría
Randall Romero Aguilar
2020-04-26
======================================================================*/


* Ajustes varios
clear
graph drop _all
set autotabgraphs on
set more off

* Fijar parámetros de las simulaciones
set obs 1000
set seed 12345
gen time = _n
tsset time
gen u = rnormal(0,1)


*======Modelo ARCH(1)============================
local c = 10
local alpha0 = 0.4
local alpha1 = 0.5

gen ex = .
replace ex =0  in 1
replace ex = u*(`alpha0' + `alpha1'*(L.ex^2))^(1/2) in 2/L

gen x = `c' + ex
tsline x, name(arch1) aspectratio(0.2)
arch x, arch(1)


*======Modelo AR(1)-ARCH(1)============================
local c = 1
local phi1 = 0.9
local alpha0 = 0.4
local alpha1 = 0.5

gen ey = .
replace ey = 0 in 1
replace ey = u*(`alpha0' + `alpha1'*(L.ey^2))^(1/2) in 2/L

gen y = .
replace y = 11 in 1
replace y = `c' + `phi1'*L.y + ey in 2/L
tsline y, name(ar1arch1) aspectratio(0.2)
arch y L.y, arch(1)


*======Modelo ARCH(2)============================
local c = 10
local alpha0 = 0.2
local alpha1 = 0.3
local alpha2 = 0.4

gen ez = .
replace ez =0  in 1/2
replace ez = u*(`alpha0' + `alpha1'*(L.ez^2) + `alpha2'*(L.ez^2))^(1/2) in 2/L

gen z = `c' + ez
tsline z, name(arch2) aspectratio(0.2)
arch z, arch(2)


*======Modelo GARCH(1,1)============================
local c = 10
local alpha0 = 0.2
local alpha1 = 0.4
local beta1 = 0.6

gen ew = 0
gen sigma2 = 1

forvalues i=2/`=_N'{
  quietly replace sigma2 = `alpha0' + `alpha1'*(L.ew^2) + `beta1'*(L.sigma2) in `i'
  quietly replace ew = u*sqrt(sigma2) in `i'
}  

gen w = `c' + ew
tsline w, name(garch11) aspectratio(0.2)
arch w, arch(1) garch(1)



*==============================================================================
* Exportar los gráficos
graph export stata-arch1-simulado.pdf, name(arch1) replace
graph export stata-ar1arch1-simulado.pdf, name(ar1arch1) replace
graph export stata-arch2-simulado.pdf, name(arch2) replace
graph export stata-garch11-simulado.pdf, name(garch11) replace
