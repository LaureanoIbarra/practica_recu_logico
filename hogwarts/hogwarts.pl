/*
Parte 1 - Sombrero Seleccionador
Para determinar en qué casa queda una persona cuando ingresa a Hogwarts, el Sombrero Seleccionador 
tiene en cuenta el carácter de la persona, lo que prefiere y en algunos casos su status de sangre.
*/

casa(gryffindor).
casa(slytherin).
casa(hufflepuff).
casa(ravenclaw).

sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).

mago(Mago):-
    sangre(Mago, _).

% tieneCaracteristica(Mago, Caracteristica)
tieneCaracteristica(harry, coraje).
tieneCaracteristica(harry, orgullo).
tieneCaracteristica(harry, amistad).
tieneCaracteristica(harry, inteligencia).

tieneCaracteristica(draco, inteligencia).
tieneCaracteristica(draco, orgullo).

tieneCaracteristica(hermione, inteligencia).
tieneCaracteristica(hermione, orgullo).
tieneCaracteristica(hermione, responsabilidad).

/* Punto 1 
Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto 
en el caso de Slytherin, que no permite entrar a magos de sangre impura.*/
puedeEntrar(Casa, Mago):-
    casa(Casa),
    mago(Mago),
    Casa \= slytherin.

puedeEntrar(slytherin, Mago):-
    sangre(Mago, Sangre),
    Sangre \= impura.

/* Punto 2 Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago 
si sus características incluyen todo lo que se busca para los integrantes de esa casa, independientemente 
de si la casa le permite la entrada.*/

caracteristicaBuscada(gryffindor, coraje).
caracteristicaBuscada(slytherin, orgullo).
caracteristicaBuscada(slytherin, inteligencia).
caracteristicaBuscada(ravenclaw, inteligencia).
caracteristicaBuscada(ravenclaw, responsabilidad).
caracteristicaBuscada(hufflepuff, amistad).

caracterApropiado(Mago, Casa):-
    casa(Casa),
    mago(Mago),
    forall(caracteristicaBuscada(Casa, Caracteristica), tieneCaracteristica(Mago, Caracteristica)).

/* Punto 3 
Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter 
adecuado para la casa, la casa permite su entrada y además el mago no odiaría que lo manden a esa casa. 
Además Hermione puede quedar seleccionada en Gryffindor, porque al parecer encontró una forma de hackear al sombrero.
*/

odiariaEntrar(harry, slytherin).
odiariaEntrar(draco, hufflepuff).

puedeQuedarSeleccionadoPara(Mago, Casa):-
    caracterApropiado(Mago, Casa),
    puedeEntrar(Casa, Mago),
    not(odiariaEntrar(Mago, Casa)).

puedeQuedarSeleccionadoPara(hermione, gryffindor).

/* Punto 4
Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos se 
caracterizan por ser amistosos y cada uno podría estar en la misma casa que el siguiente. 
No hace falta que sea inversible, se consultará de forma individual.*/

cadenaDeAmistades(Magos):-
    todosAmistosos(Magos),
    cadenaDeCasas(Magos).

todosAmistosos(Magos):-
  forall(member(Mago, Magos), amistoso(Mago)).

amistoso(Mago):-
  tieneCaracteristica(Mago, amistad).

cadenaDeCasas([Mago1, Mago2 | MagosSiguientes]):-
    puedeQuedarSeleccionadoPara(Mago1, Casa),
    puedeQuedarSeleccionadoPara(Mago2, Casa),
    cadenaDeCasas([Mago2 | MagosSiguientes]).
  cadenaDeCasas([_]).
  cadenaDeCasas([]).
/*
cadenaDeCasas(Magos):-
    forall(consecutivos(Mago1, Mago2, Magos),
    puedenQuedarEnLaMismaCasa(Mago1, Mago2, _)).    

consecutivos(Anterior, Siguiente, Lista):- % Me relaciona los que son consecutivos, ej consecutivos(Mago1, Mago2, [harry, hermione, draco]).
  nth1(IndiceAnterior, Lista, Anterior),   % me toma mago1 = harry, mago2 = hermione, dsp mago1 = hermione y mago 2 = draco
  IndiceSiguiente is IndiceAnterior + 1,
  nth1(IndiceSiguiente, Lista, Siguiente).

puedenQuedarEnLaMismaCasa(Mago1, Mago2, Casa):-
    puedeQuedarSeleccionadoPara(Mago1, Casa),
    puedeQuedarSeleccionadoPara(Mago2, Casa),
    Mago1 \= Mago2.
*/