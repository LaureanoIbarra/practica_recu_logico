% Punto 1
/*
Queremos reflejar que: 
    - Gabriel cree en Campanita, el Mago de Oz y Cavenaghi
    - Juan cree en el Conejo de Pascua
    - Macarena cree en los Reyes Magos, el Mago Capria y Campanita
    - Diego no cree en nadie

Conocemos tres tipos de sueño:
    - ser un cantante y vender una cierta cantidad de “discos” (≅ bajadas)
    - ser un futbolista y jugar en algún equipo
    - ganar la lotería apostando una serie de números

Queremos reflejar entonces que:
    - Gabriel quiere ganar la lotería apostando al 5 y al 9, y también quiere ser un futbolista de Arsenal
    - Juan quiere ser un cantante que venda 100.000 “discos”
    - Macarena no quiere ganar la lotería, sí ser cantante estilo “Eruca Sativa” y vender 10.000 discos

a. Generar la base de conocimientos inicial
b. Indicar qué conceptos entraron en juego para cada punto.
*/
cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).

cree(juan, conejoDePascua).

cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

% suenio(cantante).
% suenio(futbolista, Equipo).
% suenio(ganarLoteria, Numeros).

suenio(gabriel, ganarLoteria, [5, 9]).
suenio(juan, cantante, 100000).
suenio(macarena, cantante, 10000).
suenio(gabriel, futbolista, arsenal).

persona(Persona):- suenio(Persona, _, _).
persona(Persona):- cree(Persona, _).
% Punto 2
/*
Queremos saber si una persona es ambiciosa, esto ocurre cuando la suma de dificultades de los sueños es mayor a 20. La dificultad de cada sueño se calcula como
    - 6 para ser un cantante que vende más de 500.000 ó 4 en caso contrario
    - ganar la lotería implica una dificultad de 10 * la cantidad de los números apostados
    - lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y Aldosivi son equipos chicos.
Puede agregar los predicados que sean necesarios. El predicado debe ser inversible para todos sus argumentos. 
Gabriel es ambicioso, porque quiere ganar a la lotería con 2 números (20 puntos de dificultad) y quiere ser futbolista de Arsenal (3 puntos) = 23 que es mayor a 20. 
En cambio Juan y Macarena tienen 4 puntos de dificultad (cantantes con menos de 500.000 discos)
*/

ambiciosa(Persona):-
    suenio(Persona, Suenio, _),
    findall(Dificultad, dificultadSuenios(Persona, Suenio, Dificultad), Dificultades),
    sum_list(Dificultades, DificultadesFinal),
    DificultadesFinal > 20.

dificultadSuenios(Persona, _, Dificultad):-
    suenio(Persona, cantante, Cantidad),
    Cantidad > 500000,
    Dificultad is 6.

dificultadSuenios(Persona, _, Dificultad):-
    suenio(Persona, cantante, Cantidad),
    Cantidad =< 500000,
    Dificultad is 4.

dificultadSuenios(Persona, _, Dificultad):-
    suenio(Persona, ganarLoteria, Numeros),
    length(Numeros, CantNumeros),
    Dificultad is 10 * CantNumeros.

dificultadSuenios(Persona, _, Dificultad):-
    suenio(Persona, futbolista, Equipo),
    equipoChico(Equipo),
    Dificultad is 3.

dificultadSuenios(Persona, _, Dificultad):-
    suenio(Persona, futbolista, Equipo),
    not(equipoChico(Equipo)),
    Dificultad is 16.

equipoChico(arsenal).
equipoChico(aldosivi).

% Punto 3
/*
Queremos saber si un personaje tiene química con una persona. Esto se da
    - si la persona cree en el personaje y...
        - para Campanita, la persona debe tener al menos un sueño de dificultad menor a 5.
        - para el resto, 
            - todos los sueños deben ser puros (ser futbolista o cantante de menos de 200.000 discos)
            - y la persona no debe ser ambiciosa
No puede utilizar findall en este punto.
El predicado debe ser inversible para todos sus argumentos.
Campanita tiene química con Gabriel (porque tiene como sueño ser futbolista de Arsenal, que es un sueño de dificultad 3 - menor a 5), y 
los Reyes Magos, el Mago Capria y Campanita tienen química con Macarena porque no es ambiciosa.
*/
tieneQuimica(Persona, Personaje):- 
    persona(Persona), 
    personaje(Personaje), 
    cree(Persona, Personaje), 
    condicionQuimica(Persona, Personaje).

personaje(Personaje):- 
    cree(_, Personaje).

condicionQuimica(Persona, campanita):- 
    suenio(Persona, Suenio, _),
    dificultadSuenios(Persona, Suenio, Dificultad),
    Dificultad < 5.

condicionQuimica(Persona, _):- 
    not(ambiciosa(Persona)).

condicionQuimica(Persona, _):- 
    forall(suenio(Persona, Suenio, _), suenioPuro(Suenio)).

suenioPuro(suenio(_, futbolista, _)).
suenioPuro(suenio(_, cantante, Discos)):- 
    Discos < 200000.

% Punto 4 MIRAR EL OTRO ARCHIVO
