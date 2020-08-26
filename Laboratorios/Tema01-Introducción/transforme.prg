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
wfopen "data/CR-PIB.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @freq Q @id @date(periodo) @smpl @all
DELETE periodo

' Datos originales
GRAPH plot1.line pib
plot1.addtext(t) "Producto Interno Bruto de Costa Rica"
plot1.addtext(l) "billones de colones constantes"

' Primera diferencia	
GRAPH plot2.line @d(pib)
plot2.addtext(t) "Cambio trimestral en el PIB de Costa Rica"
plot2.addtext(l) "billones de colones constantes"

'
' Tasa de variación
GRAPH plot3.line @pc(pib)
plot3.addtext(t) "Tasa de crecimiento trimestral del PIB de Costa Rica"
plot3.addtext(l) "por ciento"


' Tasa de variación continua
GRAPH plot4.line 100*@dlog(pib)
plot4.addtext(t) "Tasa de crecimiento trimestral del PIB de Costa Rica"
plot4.addtext(l) "por ciento"


' Cambio interanual
GRAPH plot5.line @d(pib, 0 ,4)
plot5.addtext(t) "Cambio interanual en el PIB de Costa Rica"
plot5.addtext(l) "billones de colones constantes"

	
' Tasa de variación interanual
GRAPH plot6.line 100*@dlog(pib,0,4) @pcy(pib)
plot6.addtext(t) "Tasa de crecimiento interanual del PIB de Costa Rica"
plot6.addtext(l) "por ciento"


' Serie suavizada
GRAPH plot7.line pib @movav(pib,4)
plot7.addtext(t) "Producto Interno Bruto de Costa Rica"
plot7.addtext(l) "billones de colones constantes"

