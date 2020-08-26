'====================================================================
'LandD.prg:  Ejemplo numérico para ilustrar el uso de los operadores de
'rezago, diferencia, y diferencia estacional.
'
'Basado en Levendis 2018 Time Series Econometrics, pp4-5
'
'
'Universidad de Costa Rica
'Escuela de Economía
'Curso: EC4301 Macroeconometría
'Profesor: Randall Romero Aguilar, PhD
'2020-02-01
'======================================================================

' Empezamos fijando la ruta predeterminada de los archivos
%path = @runpath
cd %path

' Leer una serie de tiempo ficticia de data\LandD.csv,  declarar los datos como serie de tiempo, y mostrarlos
WFOPEN "data/LandD.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @freq Q @id @date(trimestre) @smpl @all
y.sheet

' Operador de rezagos
SERIES lag_y = y(-1)
SERIES lag2_y = y(-2)

' Operador de diferencias
SERIES d_y = @D(y)
SERIES d2_y =  @D(y,2)

' Operador de diferencia estacional
SERIES S_y = @d(y, 0, 4)

' Mostrar los resultados
GROUP resultados y lag_y lag2_y d_y d2_y s_y
resultados.sheet
