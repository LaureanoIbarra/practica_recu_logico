herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

% Punto 1
/*
Agregar a la base de conocimientos la siguiente información:
a. Egon tiene una aspiradora de 200 de potencia.
b. Egon y Peter tienen un trapeador, Ray y Winston no.
c. Sólo Winston tiene una varita de neutrones.
d. Nadie tiene una bordeadora.
*/

tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

% Punto 2
/*
Definir un predicado que determine si un integrante satisface la necesidad de una herramienta requerida. 
Esto será cierto si tiene dicha herramienta, teniendo en cuenta que si la herramienta requerida es una aspiradora, 
el integrante debe tener una con potencia igual o superior a la requerida.
Nota: No se pretende que sea inversible respecto a la herramienta requerida.
*/
satisfaceNecesidad(Integrante, Herramienta):-
    tiene(Integrante, Herramienta).

satisfaceNecesidad(Integrante, aspiradora(PotenciaNecesaria)):-
    tiene(Integrante, aspiradora(Potencia)),
    between(0, Potencia, PotenciaNecesaria). %inversible
	%Potencia >= PotenciaRequerida. -- No inversible hacia PotenciaRequerida
    
% Punto 3
/*
Queremos saber si una persona puede realizar una tarea, que dependerá de las herramientas que tenga. Sabemos que:
- Quien tenga una varita de neutrones puede hacer cualquier tarea, independientemente de qué herramientas requiera dicha tarea.
- Alternativamente alguien puede hacer una tarea si puede satisfacer la necesidad de todas las herramientas requeridas para dicha tarea.
*/
puedeRealizarTarea(Integrante   , Tarea):-
    tiene(Integrante, varitaDeNeutrones),
    herramientasRequeridas(Tarea, _).

puedeRealizarTarea(Integrante, Tarea):-
    tiene(Integrante, _),
    forall(requiereHerramienta(Tarea, Herramienta), satisfaceNecesidad(Tarea, Herramienta)).

requiereHerramienta(Tarea, Herramienta):-
	herramientasRequeridas(Tarea, ListaDeHerramientas),
	member(Herramienta, ListaDeHerramientas).

% Punto 4
/*
Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido (que son las tareas que pide). Para ellos 
disponemos de la siguiente información en la base de conocimientos:
- tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros cuadrados sobre los cuales hay que realizar esa tarea.
- precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al cliente.
Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea, multiplicando el precio por los metros cuadrados de la tarea.
*/
precioACobrar(Cliente, PrecioACobrar):-
	tareaPedida(Cliente, _, _),
	findall(Precio, precioPorTareaPedida(Cliente, _, Precio),
		ListaPrecios),
	sumlist(ListaPrecios, PrecioACobrar).

precioPorTareaPedida(Cliente, Tarea, Precio):-
	tareaPedida(Cliente, Tarea, Metros),
	precio(Tarea, PrecioPorMetro),
	Precio is PrecioPorMetro * Metros.

% Punto 5
/*
Finalmente necesitamos saber quiénes aceptarían el pedido de un cliente. Un integrante acepta el pedido cuando puede 
realizar todas las tareas del pedido y además está dispuesto a aceptarlo.
Sabemos que Ray sólo acepta pedidos que no incluyan limpiar techos, Winston sólo acepta pedidos que paguen más de $500, 
Egon está dispuesto a aceptar pedidos que no tengan tareas complejas y Peter está dispuesto a aceptar cualquier pedido.
Decimos que una tarea es compleja si requiere más de dos herramientas. Además la limpieza de techos siempre es compleja.
*/

tareaCompleja(limpiarTecho).

tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea, Herramiantas),
    length(Herramiantas, CantHerramiantas),
    CantHerramiantas > 2.

dispuestoAceptar(ray, Cliente):-
    tareaPedida(Cliente, Tarea, _),
    Tarea \= limpiarTecho.

dispuestoAceptar(winston, Cliente):-
    precioACobrar(Cliente, PrecioACobrar),
    PrecioACobrar > 500.

dispuestoAceptar(winston, Cliente):-
    not((tareaPedida(Cliente, Tarea, _),
		tareaCompleja(Tarea))).

dispuestoAceptar(peter, Cliente):-
    tareaPedida(Cliente, _, _).



aceptanPedido(Cliente, Integrante):-
    puedeHacerPedido(Trabajador, Cliente),
    dispuestoAceptar(Trabajador, Cliente).

puedeHacerPedido(Trabajador, Cliente):-
    tareaPedida(Cliente, _, _),
	tiene(Trabajador, _),
	forall(tareaPedida(Cliente, Tarea, _),
        puedeRealizarTarea(Trabajador, Tarea)).

% Punto 6




/*
Necesitamos agregar la posibilidad de tener herramientas reemplazables, que incluyan 2 herramientas de las que pueden tener 
los integrantes como alternativas, para que puedan usarse como un requerimiento para poder llevar a cabo una tarea.
    a. Mostrar cómo modelarías este nuevo tipo de información modificando el hecho de herramientasRequeridas/2 para que ordenar 
    un cuarto pueda realizarse tanto con una aspiradora de 100 de potencia como con una escoba, además del trapeador y el plumero que ya eran necesarios.
    b. Realizar los cambios/agregados necesarios a los predicados definidos en los puntos anteriores para que se soporten estos nuevos
    requerimientos de herramientas para poder llevar a cabo una tarea, teniendo en cuenta que para las herramientas reemplazables alcanza con 
    que el integrante satisfaga la necesidad de alguna de las herramientas indicadas para cumplir dicho requerimiento.
    c. Explicar a qué se debe que esto sea difícil o fácil de incorporar.
*/
herramientasRequeridas(ordenarCuarto, [[escoba, aspiradora(100)], trapeador, plumero]).

satisfaceNecesidad(Persona, ListaRemplazables):-
	member(Herramienta, ListaRemplazables),
	satisfaceNecesidad(Persona, Herramienta).
/*
Para el punto 6 agregamos una definición de satisfaceNecesidad
que contemplara la posibilidad de listas de herramientas remplazables
aprovechando el predicado para hacer uso de polimorfismo, y evitando
tener que modificar el resto de la solución ya planteada para
contemplar este nuevo caso. Mayor explicación al final.
*/
/*

Por qué para este punto no bastaba sólo con agregar un nuevo 
hecho?
Con nuestra definición de puedeHacerTarea verificabamos con un 
forall que una persona posea todas las herramientas que requería
una tarea; pero sólo ligabamos la tarea. Entonces Prolog hubiera
matcheado con ambos hechos que encontraba, y nos hubiera devuelto
las herramientas requeridas presentes en ambos hechos.
Una posible solución era, dentro de puedeHacerTarea, también ligar
las herramientasRequeridas antes del forall, y así asegurarnos que
el predicado matcheara con una única tarea a la vez.
Cual es la desventaja de esto? Para cada nueva herramienta remplazable
deberíamos contemplar todos los nuevos hechos a generar para que 
esta solución siga funcionando como queremos.
Se puede hacer? En este caso sí, pero con el tiempo se volvería costosa.
La alternativa que planteamos en esta solución es agrupar en una lista
las herramientas remplazables, y agregar una nueva definición a 
satisfaceNecesidad, que era el predicado que usabamos para tratar
directamente con las herramientas, que trate polimorficamente tanto
a nuestros hechos sin herramientas remplazables, como a aquellos que 
sí las tienen. También se podría haber planteado con un functor en vez
de lista.
Cual es la ventaja? Cada vez que aparezca una nueva herramienta
remplazable, bastará sólo con agregarla a la lista de herramientas
remplazables, y no deberá modificarse el resto de la solución.
*/
/*
Notas importantes:
I) Este enunciado pedía que todos los predicados fueran inversibles
Recordemos que un predicado es inversible cuando 
no necesitás pasar el parámetro resuelto (un individuo concreto), 
sino que podés pasar una incógnita (variable sin unificar).
Así podemos hacer tanto consultas individuales como existenciales.
II) No siempre es conveniente trabajar con listas, no abusar de su uso.
	En general las listas son útiles sólo para contar o sumar muchas cosas
	que están juntas.
III) Para usar findall es importante saber que está compuesto por 3 cosas:
		1. Qué quiero encontrar
		2. Qué predicado voy a usar para encontrarlo
		3. Donde voy a poner lo que encontré
IV) Todo lo que se hace con forall podría también hacerse usando not.
*/