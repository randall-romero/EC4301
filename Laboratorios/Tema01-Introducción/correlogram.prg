'====================================================================
'Transforme.prg: Cálculo de transformaciones de la serie del PIB de 
'Costa Rica.
'
'Universidad de Costa Rica
'Escuela de Economía
'Curso: EC4301 Macroeconometría
'Profesor: Randall Romero Aguilar, PhD
'2020-02-01
'======================================================================

' Ajustes varios
%path = @runpath
cd %path

' Leer datos del PIB trimestral de Costa Rica, Indexar datos como serie de tiempo
import "data\log_imae.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @freq M @id @date(series01) @smpl @all
DELETE series01


' Graficar las series
GROUP datos original tendencia_ciclo
FREEZE(plot0_series) datos.line

' CORRELACION DE LA SERIE ORIGINAL
' Correlación de la serie original
FREEZE(plot1a_nivel) original.correl

' Correlación de la primera diferencia
FREEZE(plot2a_diff) @d(original).correl

' Correlación de la serie original
FREEZE(plot3a_sdiff) @d(original, 0, 12).correl

'======================================================
' CORRELACION DE LA SERIE TENDENCIA CICLO
' Correlación de la serie original
FREEZE(plot1b_nivel) tendencia_ciclo.correl

' Correlación de la primera diferencia
FREEZE(plot2b_diff) @d(tendencia_ciclo).correl

' Correlación de la serie original
FREEZE(plot3b_sdiff) @d(tendencia_ciclo, 0, 12).correl

