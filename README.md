# Pandemia

Nos piden armar, usando lo que aprendimos en Objetos 1, un modelo que permita simular, y visualizar, la evolución de una pandemia en un entorno urbano (ponele, un barrio).  
Vamos a usar Wollok Game para la visualización.

La simulación va avanzando por días. Arranca en el día 0. No nos importan las fechas (p.ej. 5 de mayo, 6 de mayo, 7 de mayo), sino los días desde el inicio de la simulación (día 0, día 1, día 2).

En este modelo simplificado, el barrio se compone de manzanas de forma cuadrada, o sea tiene la misma forma de una hoja cuadriculada.  
Para graficar, y para saber quiénes son las manzanas vecinas de una manzana, nos va a convenir asignarle una `position` a cada manzana.  
Vamos a armar barrios de forma rectangular ... que después vamos a poder representar fácilmente en un game. P.ej. un barrio de 4 filas por 6 columnas, va a tener manzanas en las posiciones (0,0), (0,1), ..., (0,5), (1,0), (1,1), ..., (1,5), ..., (3,4), (3,5), en total 24 manzanas. Es incorrecto que haya dos manzanas con la misma posición.

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


## Estado inicial, simulación de un día
En el estado inicial de la simulación, en cada manzana viven 10 personas, ninguna infectada, ninguna aislada, ninguna hace cuarentena. La simulación arranca en el día 0. 

Cada día que pasa, vamos a simular dos cosas: el movimiento de gente, y la posibilidad de contagio de quienes no estén infectades.

### Movimiento
La acción que nos conviene pensar es que una manzana puede _transladar_ a uno de sus habitantes. ¿Qué quiere decir esto? Que se toma un habitante al azar de la manzana _que no esté aislado_, y se lo "muda" a otra manzana, también al azar. Eso quiere decir simplemente que la persona se va de una manzana y pasa a estar en la otra.  
Para que no quede ninguna manzana vacía, ejecutar el translado solamente si hay más de dos personas en condiciones de transladarse (o sea, no aisladas).  
En lo posible, hacer que la manzana a la que se "muda" a la persona sea vecina de su residencia actual.  

### Contagio
Una persona se puede contagiar, solamente, de otra persona que viva **en su misma manzana**, que esté infectada y no esté aislada.  
Pero pero pero ... si dijimos que no hay ninguna persona infectada ¿cómo hace alguien para contagiarse? Ya vamos a ver que una de las acciones del juego es agregar una persona infectada, la idea es que no hay nadie infectado hasta que llegan "casos importados", y esos son los que van a poder contagiar.  
A su vez, los movimientos de población pueden provocar que la infección se expanda, sin necesidad de que haya contagios entre manzanas. Por eso en esta simulación, los contagios se dan nada más entre personas que viven en una misma manzana.

La probabilidad de contagio de una persona infectada a una no infectada, es del 2\% si la no infectada respeta la cuarentena, y del 25\% si no la respeta.  
O sea, hay que generar un número al azar entre 0 y 99. Si el no infectado respeta la cuarentena y el número es menor a 2, entonces se infecta. Si el no infectado _no_ respecta la cuarentena, se infecta si el número es menor a 25, o sea, tiene **mucha** más chance de infectarse.  
En cualquier caso, si la persona se infecta, tiene un 30\% de tener síntomas. O sea, otro número al azar, si es menor a 30 la persona tiene síntomas, si no no.

Entonces, para cada persona no infectada en una manzana debe realizarse este proceso, una vez para cada persona infectada y no aislada que viva en la misma manzana. Si una manzana
- no tiene ninguna persona infectada, entonces no hay que hacer nada.
- tiene una persona infectada, entonces para cada persona no infectada en la manzana hay que realizar el proceso recién descripto (generar el número al azar, y que se infecte si es menor al valor que corresponde según si respeta o no la cuarentena) una vez.
- tiene 4 personas infectadas, entonces para cada persona no infectada en la manzana hay que realizar el proceso recién descripto _cuatro veces_. Una forma es hacer lo siguiente: generar _cuatro_ números al azar, si al menos uno está en el "rango de infección", entonces la persona se infecta.

Hasta acá se puede probar creando una simulación, agregando personas infectadas, ejecutando la simulación de paso de día, y viendo cómo queda. 

## Gráfico
Armar un programa que muestre una simulación en un Wollok Game. Consejo: empezar por una simulación chiquita, p.ej. de 4 filas x 6 columnas. Mucho más no, porque ya les va a tardar mucho.   
En cada casillero del game va una manzana, la que corresponde a la posición del casillero. P.ej. en el casillero (3,4) del game, se dibuja la manzana cuya posición es (3,4).  
La imagen va cambiando de acuerdo a la cantidad de personas infectadas. Una opción es, en este orden:
- rojo si están todes infectades.
- naranja oscuro si hay más de 7 pero menos del total de las personas de la manzana.
- naranja si hay entre 4 y 7.
- amarillo si hay entre 1 y 3.
- blanco si no hay infectados

Que haya teclas para
- consultar el estado general de la simulación, p.ej. algo así: "Día 8, total de personas: 245, infectados: 25, con síntomas 6". Para esto usar `game.say`. Si no se ve bien, usar la alternativa `console.prinln(<string>)`, que muestra un texto en la consola.
- agregar una persona infectada, sin síntomas, que se agarró la infección en el día actual de la simulación, a una manzana al azar. O sea, no infectar a una persona que ya está, sino agregar una persona nueva. Esto para simular el efecto de las personas que vienen del exterior.
- simular el paso de un día, que realice para cada manzana, las tres acciones: movimiento, contagio, y curación. Que mande un mensaje a consola (p.ej. `console.prinln("terminó el día")`), para que sepan que terminó.

Acá se lo puede jugar, y ver la (horrible) velocidad en la que se expande la enfermedad si la gente no cumple la cuarentena.

## Agente de salud
Agregar al juego un agente de salud, que se va moviendo por el barrio. Puede realizar dos acciones: 
1. aislar a todes les infectades con síntomas.
1. convencer a todes a que respeten la cuarentena.
Esto lo hace en la manzana correspondiente a su posición actual.

Agregar al agente al Game, lograr que se mueva por el barrio, y habilitar dos teclas, una para cada una de las acciones indicadas, que se ejecutan en la manzana en la que está el agente.

Con esto se puede apreciar el efecto de convencernos de aislar a quienes presentan síntomas, y sobre todo, de respetar la cuarentena.  
Para esto, después de agregar algunos infectados iniciales, se puede hacer pasear al agente por todo el tablero mandando a todo el mundo a cuarentena, y ver cómo evoluciona.  
Una alternativa es que mande a cuarentena a la mitad del tablero. En este caso, repetir el "mandar a cuarentena" cada p.ej. 4 días. Debería verse que en la mitad por la que nunca pasa el agente, la infección avanza más rápido



## Curación
Supongamos que la infección dura 20 días, o sea, todas las personas que tienen una infección que empezó hace más de 20 días, dejan de tenerla.

Agregar la posible curación de todes les infectades a la simulación del paso de un día.

## Código inicial
Se provee bastante código inicial, que debe ser respetado, salvo pedido a los docentes. La idea es que aprovechemos este TP para aprender a trabajar sobre código que nos dan, que tenemos que entender y completar.

Lo que está alcanza para levantar un juego de 6x4 manzanas. Se incluye:
- la configuración del juego, incluyendo ancho, alto y manzanas. Esto está en `pandemiaGame.wpgm`, que tiene un objeto `pandemiaGameConfig` que se encarga de eso, así el `program` queda bien chiquito. 
- un objeto que representa a la simulación, en el archivo `simulacion.wlk`. La simulación maneja a las manzanas. Tiene un método para crear una manzana, a ese método le falta la parte que agrega las personas en la manzana, eso lo tienen que hacer ustedes. También define todos los parámetros de la simulación. Incluye un método que genera un número al azar y se fija si es menor a un porcentaje que les dan, ver el comentario, es el método `tomarChance(porcentaje)`. Finalmente, define un método que dada una persona y una cantidad de contagiadores, calcula si la persona se tiene que infectar o no de acuerdo a las reglas de simulación de un día.
- una clase que modela a las manzanas. Esta clase ya tiene implementado el paso del día con dos partes: translado de un habitante, y simulación de contagios, hay que agregarle la parte de curación. El translado lo tienen que implementar ustedes. De la simulación de contagio está la estructura, ustedes tienen que implementar los métodos `cantidadContagiadores()` y `noInfectades()`, más lo que falta en Persona.
- una clase que modela a la persona. De esta les damos un `var property`, y dos métodos que hay que implementar para que ande la simulación de contagio.

Del agente de salud no hay nada.