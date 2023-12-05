Ejercicio 3: El lenguaje PARALLEL++ y la verificación de programas escritos en él

[Q1] Sigue todos los pasos necesarios para utilizar el model checker de Maude para verificar la exclusión mútua del algoritmo de Dekker escrito en el lenguaje PARALLEL. (Todos: comprobación de que el espacio de búsqueda es finito, comprobaciones de confluencia, terminación, protección de booleanos, definición de proposiciones atómicas, . . . )

[Q2] Define la semántica del lenguaje PARALLEL++. Se creará un fichero parallel++.maude con tantos módulos como se considere necesario, que extenderán los módulos en el parallel.maude. 

[Q3] Utiliza el comando search para verificar la exclusión mutua y la ausencia de bloqueos para el algoritmo de Dekker en su implementación original usando las definiciones de PARALLEL++. (El código está en el fichero dekker++.maude.)

[Q4] Modifica la implementación del algoritmo de Dekker en el fichero dekker++.maude (crea una copia en un fichero dekker++-modificado.maude) de forma que tengamos un programa con el que podemos crear las hebras correspondientes. Tendremos un programa main:
op main : -> Program .
eq main = new(0, p(0)) ; new(1, p(1)) .
De forma que el estado inicial de nuestro sistema pueda ser simplemente:
eq initial = { [2, main], [wants-to-enter, false false] [turn, 0] } .

[Q5] Comprueba utilizando el comando search la ausencia de bloqueo y la exclusión mutua de esa versión del algoritmo.

[Q6] Escribe el algoritmo de la panadería de Lamport (el original) utilizando el lenguaje PARALLEL++ y utiliza su semántica de reescritura para comprobar la ausencia de bloqueo y la exclusión mutua.

[Q7] Utiliza el model checker para probar la exclusión mutua y la viveza débil. Al tener un espacio de búsqueda infinito necesitaremos realizar una abstracción

