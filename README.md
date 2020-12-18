# Análisis de datos: experimento de Franck-Hertz.
Aquí se pueden encontrar el script y los datos numéricos tomados en el laboratorio durante la experiencia de Franck-Hertz. También están disponibles las figuras generados por el script. El script está escrito en R, y lleva a cabo el análisis descrito en el informe de la práctica correspondiente:

1. Se importan los quince archivos obtenidos, graficándose los datos.
2. Dado que los datos muestran una cierta cantidad de ruido, se lleva a cabo una regresión local (LOESS) con un parámetro de suavizado que podemos cambiar (Cleveland & Devlin, 1988).
3. Utilizando esta regresión, determinamos las posiciones de los mínimos y los máximos de cada set de datos de forma automática. (Esto elimina la arbitrariedad que se introduciría si el proceso se llevase a cabo manualmente). El algoritmo utiliza la derivada numérica para determinar en qué punto se da un extremo, pudiendo establecerse la condición de que la derivada deba mantener el signo para un cierto número de puntos, asegurándonos así que no estamos detectando mínimos debidos a los efectos del ruido.
4. Se extraen las posiciones de los puntos extremos detectados (mínimos y máximos locales), y se tabula el valor de $\Delta E_a$ junto al orden que le corresponde a cada uno. (Máximos y mínimos se estudian por separado). Se grafica el resultado.
5. Se realizan automáticamente los ajustes sobre cada serie de datos de $\Delta E_a$ vs. $n$ obtenida, extrayéndose el valor de los parámetros de ajuste junto a su desviación típica.
6. Utilizando un paquete de análisis de incertidumbres (*errors*, véase Úcar et al., 2018), se utilizan los resultados de los ajustes anteriores para calcular $\lambda$ y $E_a$.
