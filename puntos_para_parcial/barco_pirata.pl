cocinero(donato).
cocinero(pietro).
pirata(felipe, 27).
pirata(marcos, 39).
pirata(facundo, 45).
pirata(tomas, 20).
pirata(betina, 26).
pirata(gonzalo, 22).


bravo(tomas).
bravo(felipe).
bravo(marcos).
bravo(betina).
personasPosibles([donato, pietro, felipe, marcos, facundo, tomas, gonzalo, betina]).

/*
Un pirata quiere armar la tripulación para su barco, él solo quiere llevar
-cocineros
-piratas bravos
-piratas de más de 40 años (no pagan impuestos)
*/

tripulacionBarco(Tripulacion):-
    personasPosibles(Personas),
    tripulacion(Personas, Tripulacion).


% Abstraemos en un predicado auxiliar qué personas pueden subir al barco. Los tres casos son similares al ejemplo de las actividades:

/*cuando no hay personas, nadie más sube al barco*/
tripulacion([],[]).

/*puedo subir al barco a una persona si cumple el criterio del pirata*/
tripulacion([Posible|Posibles], [Posible|Tripulantes]):-
	puedeSubirAlBarco(Posible), 
    tripulacion(Posibles, Tripulantes).

/*o puedo decidir que no suba, porque no cumple las condiciones o “porque sí"*/
tripulacion([_|Posibles], Tripulantes):-
	tripulacion(Posibles, Tripulantes).

puedeSubirAlBarco(Persona):- cocinero(Persona).
puedeSubirAlBarco(Persona):- pirata(Persona, _), bravo(Persona).
puedeSubirAlBarco(Persona):- pirata(Persona, Edad), Edad > 40.
