cls 
/*
klein-model.do: Estimación de un sistema de ecuaciones simultáneas

Datos tomados del libro de Greene 2012

Universidad de Costa Rica
Escuela de Economía
Curso EC4301 Macroeconometría
Randall Romero Aguilar
2020-05-26




         El modelo de Klein



En este laboratorio presentamos el Modelo I de Klein (1950), el cual es un ejemplo 
ampliamente utilizado de un modelo de ecuaciones simultáneas.

El modelo es:
	---ecuaciones estocásticas
    * Consumo:   			C_t	= a0 + a1 P_t + a2 P_{t-1} + a3(Wp_t + Wg_t) + e1t
	* Inversión:			I_t = b0 + b1 P_t + b2 P_{t-1} + b3 K_{t-1} + e2t
	* Salarios privados:	Wp_t = g0  + g1 X_t + g2 X_{t-1} + g3 A_t + e3t

	---identidades
	* Equilibrio demanda:  	X_t = C_t + I_t + G_t
	* Utilidades privadas:	P_t = X_t - T_t - Wp_t
	* Stock de capital:		K_t = K_{t-1} + I_{t-1}

Las variables endógenas son las que aparecen del lado izquierdo. Las exógenas son:
	* G_t  = gasto (no salarial) del gobierno
	* T_t  = impuestos indirectos a las empresas + exportaciones netas
	* Wg_t = gastos salarial del gobierno
	* A_t  = tendecia, años desde 1931

Hay tres variables predeterminadas: los rezagos del stock de capital, utilidades
privadas, y demanda total.

El modelo contiene 3 ecuaciones de comportamiento, una condición de equilibrio,
y dos identidades contables.

Referencia: 
Greene 2012 Econometric Analysis. Prentice Hall, 7th edition. Pages 332-333
*/



clear 
forecast clear
set more off

*===============================================================================
* IMPORTAR DATOS Y DECLARARLOS COMO SERIES DE TIEMPO
import delimited "TableF10-3.txt", ///
       delimiter(whitespace, collapse) case(preserve) encoding(UTF-8) clear

tsset Year, yearly 

* Opciones para tablas
local opciones "cformat(%6,2f) pformat(%5,2f) sformat(%6,2f)"

* Generar las variables adicionales
generate K = F.K1      // capital
generate A = _n -12   // tendencia



*===============================================================================
* ESTIMAR EL SISTEMA DE ECUACIONES POR 2SLS, usando reg3

* Describir las ecuaciones
local eq_c "P L.P Wp Wg"
local eq_i "P L.P L.K"
local eq_wp "X L.X A"

* Clasificar las variables
local exog "G T Wg A"
local predet "L.P L.K L.X"
local endog "C I Wp X P K"

* Restringir los parámetros de salarios en la ecuación de consumo
constraint define 1 [consumo]: Wp=Wg

* Estimar el modelo
reg3 (consumo: C = `eq_c') ///
     (inversion: I = `eq_i') ///
	 (salarios: Wp = `eq_wp'), ///
	 2sls constraints(1) inst(`exog' `predet') `opciones'

	 
* ========    USAR EL MODELO PARA PRONOSTICAR

* Guardar resultados de estimación 2SLS
estimates store klein

* Crear un modelo
forecast create kleinmodel

* Añadir las ecuaciones estimadas
forecast estimates klein	 

* Añadir las identidades	 
forecast identity X = C + I + G	 
forecast identity P = X - T - Wp
forecast identity K = L.K + I
	 
* Declarar las exogenas
forecast exogenous G T Wg A
	 
* Resolver el modelo, estático
forecast solve, prefix(s_) begin(1921) static	 
	 
* Resolver el modelo dinámico
forecast solve, prefix(d_) begin(1936)	 
	 
*===============================================================================
* ESTIMAR EL SISTEMA DE ECUACIONES, pero una etapa a la vez

* Etapa 1: Ajustar cada variable endógena por OLS, contra TODAS las exógenas del sistema

foreach y of varlist `endog' {
   quietly reg `y' `exog' `predet'
   predict `y'_ols, xb
}



* Etapa 2: Estimar cada ecuación del sistema por OLS, reemplazando las endógenas
* por los valores ajustados de la etapa 1
	
* Describir las ecuaciones de la segunda etapa
local eq_c2 "P_ols L.P Wp_ols Wg"
local eq_i2 "P_ols L.P L.K"
local eq_wp2 "X_ols L.X A"	
	
constraint 2 Wp_ols=Wg

cnsreg C `eq_c2', constraints(2) `opciones'
reg I `eq_i2', `opciones'
reg Wp `eq_wp', `opciones'
