# RETURNS MACKINNON 2010 CRITICAL VALUES FOR COINTEGRATION TESTS

import numpy as np
import pandas as pd
import seaborn as sn

pd.set_option('precision',5)
get_ipython().magic('matplotlib inline')


# Las tablas de MacKinnon están almacenadas en un archivo de Excel, el cual importamos con Pandas cuando creamos la clase MacKinnon.  Guardar estas tablas en una clase tiene la ventaja de que así no será necesario leer el archivo de Excel cada vez que se quiera obtener nuevos valores críticos.

source_file = r"MacKinnon 2010 Critical values for cointegration tests.xlsx"

class MacKinnon:
    variants = {'nc': 'No constant term',
                'c': 'Constant term',
                'ct': 'Constant and linear trend',
                'ctt': 'Constant, linear trend and quadratic trend'}

    tables = {tt: pd.read_excel(source_file, tt)
              for tt in variants.keys()}

    def get_matrix(self, variant, N, level=None):
        '''
        get_matrix(self, variant, N, level=None)
        
        Retorna la parte relevante de la tabla de MacKinnon para una prueba
        de cointegración de N series, con la variante especificada ('nc', 'c', 
        'ct', o 'ctt'). 
        
        Opcionalmente, si además se especifica el nivel de la prueba ('1%', '5%' 
        o '10%'), se retorna un vector con los betas requeridos.
        
        En ambos casos, los betas están ordenados de mayor orden a menor; esto 
        facilita la evaluación posterior del polinomio usando np.polyval
        '''
        
        dd = self.tables[variant]
        temp = dd[dd.N == N][['Level', 'beta3', 'beta2', 'beta1', 'beta_inf']]
        temp.set_index('Level', drop=True, inplace=True)
        
        return temp.loc[level] if level else temp

    def __call__(self, variant, N, T, level=None):
        '''
        Retorna los valores críticos de MacKinnon para una prueba de cointegración
        de N series, con la variante especificada ('nc', 'c', 'ct', o 'ctt'). 
        
        Opcionalmente, si además se especifica el nivel de la prueba ('1%', '5%' 
        o '10%'), se retorna unícamente el escalar requerido.
        '''
        beta = self.get_matrix(variant, N, level)
        if level:
            return np.polyval(beta, 1/T)
        else:
            values = [np.polyval(k, 1/T) for k in beta.values]
            return pd.Series(values, index=beta.index)