# Práctica 3: La panadería de Lamport  
## Ejercicio 1: La panadería clásica  
El protocolo de la panadería de Lamport es un protocolo que logra la exclusión mutua entre procesos utilizando el sistema habitual en panaderías y otros comercios. El sistema consiste en tener un dispensador de números, de forma que los clientes toman un número al llegar al comercio y son
atendidos secuencialmente de acuerdo con el número que tienen.  

Especifica el protocolo de la panadería de Lamport como una teoría de reescritura en Maude siguiendo las siguientes indicaciones en un módulo BAKERY (en un fichero bakery.maude).

- Modelaremos el sistema como una colección de objetos, que tendremos dentro de un operador
    ```scala
    op [[_]] : Configuration -> GBState .
    ```

- Un proceso puede estar en modo sleep, wait o crit, y cuando entra en la panadería obtiene un número de orden. Los procesos se representarán como objetos de una clase BProcess, con atributos mode y number:
    ```scala 
    class BProcess | mode : Mode, number : Nat .
    ```

- Los números de la panadería estarán gestionados por un dispensador, que tendrá el número que debe ser atendido en un momento determinado (next) y el último número de orden dispensado (last). Para ello definiremos una clase Dispenser.
    ```scala
    class Dispenser | next : Nat, last : Nat .
    ```

- El comportamiento del sistema viene dado por tres posibles acciones:
    - cuando un proceso pasa de estado sleep a estado wait toma el número de orden disponible en el dispensador (last), el cual es incrementado;
    - cuando llega el turno de un proceso (coincide su número con el next del dispensador), este pasa de modo wait a modo crit; y
    - cuando un proceso termina su sección crítica, este pasa a modo sleep, se queda con número de orden 0, y se pasa el turno al siguiente, es decir, se incrementa el next del dispensador.
- Define una operación
    ```scala
    op initial : Nat -> GBState .
    ```

    que permita crear sistemas con un número cualquiera de procesos. Inicialmente, el dispensador tendrá 1 como valores de next y last. 

**[Q1] Analiza la confluencia, terminación y coherencia del sistema definido. (Como siempre, realizamos el análisis de terminación y confluencia por separado para la parte ecuacional y la de reescritura.)**
- Confluencia: La confluencia es una propiedad que garantiza que cualquier término se puede reescribir a cualquier otro término de manera única. Estas reglas son deterministas y no hay ambigüedad en la forma en que se aplican. Por lo tanto, se puede afirmar que el sistema de reescritura es confluyente.
- Terminación: La terminación es una propiedad que garantiza que cualquier proceso de reescritura termina después de un número finito de pasos. En este caso, nuestro sistema no es terminante ya que no se ve reducido en ninguna regla de reescritura.
- Coherencia: La coherencia es una propiedad que garantiza que las definiciones de los símbolos en el sistema de reescritura son consistentes y no conducen a contradicciones. En este caso, las definiciones de los símbolos son coherentes y no hay contradicciones en las reglas de reescritura. Por lo tanto, se puede afirmar que el sistema de reescritura es coherente.

**[Q2] ¿Es el espacio de búsqueda alcanzable a partir de estados definidos con el operador initial finito? Utiliza el comando search para comprobar la exclusión mutua del sistema con 5 procesos.**

El espacio no es finito ya que siempre se van incrementando los tickets de cada proceso, y el next y el last del dispensador, dando lugar a nuevos estados.
El comando search no termina nunca, ya que el espacio de estados es infinito, pero podemos observar también que no va devolviendo ninguna solución porque se va cumpliendo la exclusión mutua, aunque sin la abstracción no podríamos estar seguros aún de que siempre se vaya a cumplir la propiedad. 

**[Q3] Utiliza el comando search para comprobar si hay estados de bloqueo.**
Al ejecutar este comando y no encontrar solución, se verifica que no encuentra estados de bloqueo.

En el mismo fichero **bakery.maude**, crea un módulo **ABSTRACT-BAKERY** en el que se defina una abstracción de la teoría de reescritura definida en el módulo **BAKERY** utilizando la siguiente idea. Conforme el sistema avanza, los números de los procesos en espera están en el rango definido por los valores **next** y **last - 1** del dispensador. En realidad, nos da igual que los valores estén en el rango [next,last) o en [next-1,last-1) siempre que no se cambie el orden entre los procesos. Podemos por tando abstraer el
sistema simplemente decrementando en uno los números de orden de todos los procesos (los que no estén en modo sleep, que tendrán número de orden 0), siempre que el valor de next sea mayor que 1.

Observa que de esta forma identificamos todos aquellos estados que tienen sus procesos en los mismos modos y con el mismo orden entre ellos.

**[Q4] Justifica la validez de la abstracción (protección de los booleanos, confluencia y terminación de la parte ecuacional, coherencia de ecuaciones y reglas).**
Al incluir el módulo NAT, estamos incluyendo también el módulo BOOL. 			
Al igual que antes, existe confluencia, pues se pueden aplicar a términos distintos


Protección de los booleanos
 En todos los módulos se usan los booleanos de forma protegida (protecting), ya que tenemos acceso al módulo BOOL porque protegemos el módulo NAT, que a su vez protege el módulo BOOL .					
Confluencia y terminación de la parte ecuacional
 Las ecuaciones son confluentes porque las nuevas (la de abstracción y las de decremento) solo se pueden aplicar a términos o subtérminos distintos.
						
Las ecuaciones son terminantes, las de decremento siempre llegan a la ecuación del caso base porque se va aplicando de forma recursiva sobre la configuración inicial entera y cada vez sobre una configuración con un elemento menos hasta llegar a none, donde se aplicaría la ecuación para el caso base. La ecuación de la abstracción, al utilizar decremento, que ya sabemos que es terminante, y al ir decrementando de 1 en 1, siempre acaba llegando a un término que no cumple la condición para que no pueda aplicarse más.
						
Coherencia
 Las ecuaciones son coherentes con las reglas. Las partes izquierdas de las reglas están en forma normal y, tal y como están planteadas las reescrituras, es equivalente aplicar las reglas (ya sean wait, enter o exit) y después aplicar la ecuación de la abstracción para disminuir los valores de los números del dispensador y de los procesos que no están en sleep que disminuir primero los valores y luego aplicar cualquiera de las reglas. 

**[Q5] En el módulo ABSTRACT-BAKERY, ¿es finito el espacio de búsqueda alcanzable a partir de estados definidos con el operador initial?**
Con la abstracción se puede reducir el espacio de estados infinito a un espacio finito al reducir los estados infinitos del módulo BAKERY a un conjunto finito con la nueva ecuación. 
**[Q6] Define, en un módulo ABSTRACT-BAKERY-PREDS proposiciones atómicas**
```scala
op mode : Nat Mode -> Prop .
op 2-crit : -> Prop .
```
**de forma que mode(N, M) se satisfaga si el proceso N está en modo M y 2-crit si hay dos procesos cualesquiera en la sección crítica.**

```scala
mod ABSTRACT-BAKERY-PREDS is
    protecting ABSTRACT-BAKERY .
    including SATISFACTION .
    subsort GBState < State .
    
    var MODE : Mode .
    var G : GBState .
    vars N M : Nat .
    vars BPid BPid' : Oid .
    var C : Configuration .
    op mode : Nat Mode -> Prop . 
    eq [[ < BPid : BProcess | mode : MODE, number : N > C ]] |= mode(N, MODE) = true .
    op 2-crit : -> Prop . 
    eq [[ < BPid : BProcess |  mode : crit,  number : N > < BPid' : BProcess |  mode : crit,  number : M > C ]] |= 2-crit = true .
endm
```
**[Q7] Comprueba que la abstracción es consistente con las proposiciones atómicas.**

La abstracción extiende el módulo Bakery, cuyos términos son de la clase BProcess y Dispenser. La ecuación de la abstracción coge como parámetro un objeto de la clase BProcess y devuelve también un objeto de la misma clase decrementando en uno el número. Esto no provoca ni junk ni confusion, ya que no se están agregando nuevos elementos ni se están identificando elementos previamente distintos.

**[Q8] Utiliza el comprobador de modelos de Maude para comprobar la exclusión mutua del sistema con 5 procesos.**
```scala

red modelCheck(initial(5),
      ( ([] ~(mode(1, crit) /\ mode(2, crit)))  /\
      ([] ~(mode(1, crit) /\ mode(3, crit)))  /\
      ([] ~(mode(1, crit) /\ mode(4, crit)))  /\
      ([] ~(mode(1, crit) /\ mode(5, crit)))  /\
      ([] ~(mode(2, crit) /\ mode(3, crit)))  /\
      ([] ~(mode(2, crit) /\ mode(4, crit)))  /\
      ([] ~(mode(2, crit) /\ mode(5, crit)))  /\
      ([] ~(mode(3, crit) /\ mode(4, crit)))  /\
      ([] ~(mode(3, crit) /\ mode(5, crit)))  /\
      ([] ~(mode(4, crit) /\ mode(5, crit))) )) .
```
**[Q9] Utiliza el comprobador de modelos de Maude para comprobar la propiedad de viveza débil y fuerte.**

## Ejercicio 2: La panadería modificada

Contruye un módulo BAKERY+ que extienda el módulo BAKERY y permita que un proceso abandone la espera.
Un proceso en modo wait puede pasar a modo sleep en cualquier momento. Al hacerlo perderá su número de orden, pasando a ser este 0.
Cuando llegue el turno de un proceso que ha abandonado la panadería, no será posible darle paso al siguiente proceso. Para adaptarnos a la nueva situación, el dispensador podrá pasar el turno (incrementar su next) si no hay ningún proceso con dicho número de orden.  

**[Q10] Analiza la confluencia, terminación y coherencia del sistema definido.**

**[Q11] ¿Es finito el espacio de búsqueda alcanzable a partir de estados definidos con el operador initial? Utiliza el comando search para comprobar la exclusión mutua del sistema con 5 procesos.**

**[Q12] La abstracción proporcionada por el módulo ABSTRACT-BAKERY no es suficiente para este sistema modificado, ¿por qué? Especifica una abstracción válida para este nuevo sistema en una módulo ABSTRACT-BAKERY+.**

**[Q13] Utiliza la abstracción anterior para comprobar la no existencia de bloqueos y la exclusión mutua utilizando el comando search.**

**[Q14] Utiliza el comprobador de modelos de Maude para comprobar la exclusión mutua del sistema con 5 procesos** 

**[Q15] Utiliza el comprobador de modelos de Maude para comprobar la propiedad de viveza débil y fuerte.**