/*====================================================================
simulate_eq2.do: Simulación de ecuaciones en diferencia de segundo orden.

Universidad de Costa Rica
Escuela de Economía
Curso: EC4301 Macroeconometría
Profesor: Randall Romero Aguilar, PhD
2025-08-15, UPDATED 2025-08-15

Este script es para Stata 17 o superior
======================================================================*/


graph drop _all
set autotabgraphs on

clear
set more off
cls

* Ajustes de parámetros para simulaciones
clear
set obs 120
generate int t = _n
tsset t


mata

A = (0.9, -0.2 \ 1, 0)
L = eigenvalues(A)
L
end



*///////////////////////////////////////////////////////////////////////////////
*=========EJEMPLO 4> Proceso AR(2), phi=0.9, -0.1


capture program drop simulate_eq2
program simulate_eq2
    args y_t c ɸ1 ɸ2 y_1 y_2
    
    local end_mata end
    
    generate `y_t' = `y_1'
    quietly replace `y_t' = `y_2' in 2/2
    quietly replace `y_t' = `c' + `ɸ1'*L1.`y_t' + `ɸ2'*L2.`y_t' in 3/l
    tsline `y_t', name(g`y_t') title("y_[t] = `c' + `ɸ1'y_[t-1]+ `ɸ2'y_[t-2]")
    
    matrix define mymatrix = (`ɸ1', `ɸ2' \ 1, 0)
    
    mata:
    A = st_matrix("mymatrix") // Loads the Stata matrix "mymatrix" into Mata variable A
    eig = eigenvalues(A)
    display("LOS VALORES PROPIOS SON:")

    eig
    
    display("Y SUS RESPECTIVOS MÓDULOS SON:")

    abs(eig)
    `end_mata'
    
    
    
end

simulate_eq2  "y" 3.0 0.9 -0.20 13.0 11.3
simulate_eq2 "y1" 0.0 0.9 -0.90  1.0  0.9
simulate_eq2 "y2" 0.0 0.2  0.35  1.0  0.2
simulate_eq2 "y3" 0.0 1.6 -0.64  1.0  1.6
simulate_eq2 "y4" 0.0 0.5  0.50  1.0  0.5

