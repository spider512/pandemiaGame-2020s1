# Pandemia

Nos piden armar, usando lo que aprendimos en Objetos 1, un modelo que permita simular, y visualizar, la evolución de una pandemia en un entorno urbano (ponele, un barrio).  
Vamos a usar Wollok Game para la visualización.

La simulación va avanzando por días. Arranca en el día 0. No nos importan las fechas (p.ej. 5 de mayo, 6 de mayo, 7 de mayo), sino los días desde el inicio de la simulación (día 0, día 1, día 2).

En este modelo simplificado, el barrio se compone de manzanas de forma cuadrada, o sea tiene la misma forma de una hoja cuadriculada.  
Para graficar, y para saber quiénes son las manzanas vecinas de una manzana, nos va a convenir asignarle una `position` a cada manzana.

En cada manzana vive una cantidad de personas. De cada persona se tiene que poder registrar:
- si está infectada o no
- si está infectada, qué día se infectó, y si presenta síntomas o no.
- si está aislada.
- si respeta la cuarentena.

De cada manzana nos van a interesar
- cuánta gente vive.
- cuántas personas están infectadas.
- cuántas personas están infectadas, y además, no están aisladas.

Hasta acá podemos: crear una manzana, agregarle gente con distintas combinaciones de infección, aislamiento y respeto de la cuarentena, y probar que la manzana responda correctamente a las consultas planteadas.


## Estado inicial, simulación de un día, movimiento de gente
En el estado inicial de la simulación, en cada manzana viven 10 personas, ninguna infectada, ninguna aislada, ninguna hace cuarentena. La simulación arranca en el día 0. 

Vamos a definir como **ciclo de infección** al proceso por el cual cada persona que no está aislada, se infecta con una probabilidad del 2\% si respeta la cuarentena, y del 30\% si no la respeta.    
O sea, para cada persona se obtiene un número al azar entre 0 y 99. 
Si la persona _no respeta la cuarentena_, hay que fijarse si el número es menor a 30, si esto se cumple hay que infectar a la persona. 
Si la persona _sí respeta la cuarentena_, entonces lo mismo, pero en lugar de menora a 30, es menor a 2. La idea es que una persona que respeta la cuarentena tiene **mucha** menor probabilidad de infectarse.  
En cualquier caso, si el azar indica que se tiene que infectar y ya está infectada, entonces no pasa nada.
Si resulta que se tiene que infectar, tiene un 20\% de presentar síntomas ... para esto hay que obtener otro número al azar, si es menor a 20 la persona que se está infectando tiene síntomas, si no no.  
No olvidarse de registrar en qué día de la simulación ocurre la infección. 
 

En cada día que pasa, para cada manzana hay que hacer lo siguiente.
1. Ejecutar un ciclo de infección para cada persona infectada que no está aislada. O sea, si hay 4 personas en esa condición, ejecutar 4 veces el ciclo de infección. Si no hay ninguna persona en esa condición, pues no se hace nada.
1. Para todas las personas que están infectadas desde hace más de 14 días, "curarlas". O sea, sacarles la infección. 


Otra acción que nos va a interesar es el **movimiento de gente**. Se le tiene que poder decir a una manzana que "mude" a una persona.  
¿Qué quiere decir eso? Tomar una persona al azar (acá viene bien el `anyOne`) y mudarlo a una manzana vecina, también tomada al azar. Mudar quiere decir: sacarla de la manzana donde está, y agregarlo en la que se eligió como "nuevo domicilio".

Hasta acá se puede probar creando una simulación, agregando personas infectadas, ejecutando la simulación de paso de día, y viendo cómo queda. También mudar una persona. 

## Gráfico
Armar un programa que muestre una simulación en un Wollok Game. Consejo: empezar por una simulación chiquita, p.ej. de 4 filas x 6 columnas.  
Cada manzana está en "su" posición en el game. La imagen va cambiando de acuerdo a la cantidad de personas infectadas. Una opción es:
- blanco si no hay infectados
- amarillo si hay entre 1 y 3.
- naranja si hay entre 4 y 7.
- naranja oscuro si hay más de 7 pero menos del total de las personas de la manzana.
- rojo si están todes infectades.

Que haya teclas para
- consultar el estado general de la simulación, p.ej. algo así: "Día 8, total de personas: 245, infectados: 25, con síntomas 6". Para esto usar `game.say`.
- agregar una persona infectada, sin síntomas, que se agarró la infección en el día actual de la simulación, a una manzana al azar. O sea, no infectar a una persona que ya está, sino agregar una persona nueva. Esto para simular el efecto de las personas que vienen del exterior.
- simular el paso de un día.
- simular que cada manzana realiza la acción de "mudar" a una persona.

Acá se lo puede jugar, y ver la (horrible) velocidad en la que se expande la enfermedad si la gente no cumple la cuarentena.

## Agente de salud
Agregar al juego un agente de salud, que se va moviendo por el barrio. Puede realizar dos acciones: 
1. aislar a todes les infectades **con síntomas**.
1. convencer a todes a que respeten la cuarentena.
Esto lo hace en la manzana correspondiente a su posición actual.

Agregar al agente al Game, lograr que se mueva por el barrio, y habilitar dos teclas, una para cada una de las acciones indicadas.

Con esto se puede apreciar el efecto de convencernos de aislar a quienes presentan síntomas, y sobre todo, de respetar la cuarentena.

