# ============================================================================
#   correlogram.do: Cálculando el autocorrelograma para el IMAE de Costa Rica.
# 
# Universidad de Costa Rica
# Escuela de Economía
# Curso: EC4301 Macroeconometría
# Profesor: Randall Romero Aguilar, PhD
# 2020-03-05
# ============================================================================
   
# Importar las librerías
library(readr)
library(fpp3)


# Leemos datos del IMAE de Costa Rica (original y tendencia-ciclo), 
# indexamos datos como series de tiempo
datos <- read.csv("data/log_imae.csv", stringsAsFactors=FALSE) %>% 
  mutate(mes = yearmonth(X)) %>%
  as_tsibble(index=mes) %>%
  select(mes, Original, Tendencia.ciclo)
 

# Graficamos las dos series
datos %>% gather() %>% autoplot() 

 
 # Hacemos los autocorrelogramas
datos %>% ACF(Original) %>% autoplot() + xlab(" ") -> fig1a
datos %>% ACF(Tendencia.ciclo) %>% autoplot() + xlab(" ") -> fig1b

datos %>% mutate(temp = difference(Original)) %>% ACF(temp) %>% autoplot() + xlab(" ") -> fig2a
datos %>% mutate(temp = difference(Tendencia.ciclo)) %>% ACF(temp) %>% autoplot() + xlab(" ") -> fig2b
 
datos %>% mutate(temp = difference(Original, lag=12)) %>% ACF(temp) %>% autoplot() + xlab(" ") -> fig3a
datos %>% mutate(temp = difference(Tendencia.ciclo, lag=12)) %>% ACF(temp) %>% autoplot() + xlab(" ") -> fig3b


 
# * Hacemos los autocorrelogramas parciales
datos %>% ACF(Original, type="partial") %>% autoplot() + xlab(" ") -> figP1a
datos %>% ACF(Tendencia.ciclo, type="partial") %>% autoplot() + xlab(" ") -> figP1b

datos %>% mutate(temp = difference(Original)) %>% ACF(temp, type="partial") %>% autoplot() + xlab(" ") -> figP2a
datos %>% mutate(temp = difference(Tendencia.ciclo)) %>% ACF(temp, type="partial") %>% autoplot() + xlab(" ") -> figP2b

datos %>% mutate(temp = difference(Original, lag=12)) %>% ACF(temp, type="partial") %>% autoplot() + xlab(" ") -> figP3a
datos %>% mutate(temp = difference(Tendencia.ciclo, lag=12)) %>% ACF(temp, type="partial") %>% autoplot() + xlab(" ") -> figP3b

