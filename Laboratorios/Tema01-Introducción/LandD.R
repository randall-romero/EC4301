# =======================================================================
# LandD.R: Ejemplo numérico para ilustrar el uso de los operadores de
# rezago, diferencia, y diferencia estacional.
# 
# Basado en Levendis 2018 Time Series Econometrics, pp4-5
# 
# 
# Universidad de Costa Rica
# Escuela de Economía
# Curso EC4301 Macroeconometría
# Randall Romero Aguilar
# 2020-03-06
# ========================================================================
   
 
# Importar las librerías necesarias

library(readr)
library(fpp3)

# Leer una serie de tiempo ficticia de data\LandD.csv, declarar los datos
# como serie de tiempo y mostrarlos
datos <- read_csv("data/LandD.csv") %>% 
  mutate(trimestre = yearquarter(trimestre)) %>%
  as_tsibble(index=trimestre) %>%
  select(trimestre, y)

show(datos)

# Operador de rezagos
datos <- datos %>% mutate(
  Lag_y = lag(y),
  Lag2_y = lag(y, 2)
)


# Operador de diferencias
datos <- datos %>% mutate(
  D_y = difference(y),
  D2_y = difference(y, differences = 2)
)

# Operador de diferencia estacional
datos <- datos %>% mutate(
  S_y = difference(y, lag = 4)
)

# Mostrar los resultados
show(datos)
