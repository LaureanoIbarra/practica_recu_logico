/*
Los parciales tienen una lista de puntos que se deberán resolver, que suelen ser 
entre 7 y 10 puntos. Cada uno de esos puntos evalúa algún tema... y si o si tienen 
que ser evaluados todos los temas, como por ejemplo primer orden.
*/

punto(primerOrden).
punto(ordenSuperior).
punto(polimorfismo).
punto(listas).
punto(relleno).
punto(modelado).
punto(diagramado).


/*
Hacer puntosInventados/1, que genera una lista de puntos de cantidad válida.
*/

puntosInventados(Puntos):-
    between(7, 10, CantidadDePuntos),
    inventarNPuntos(CantidadDePuntos, Puntos).

inventarNPuntos(0, []).

inventarNPuntos(CantidadDePuntos, [Punto | Puntos]):-
    NuevaCantidadDePuntos is CantidadDePuntos - 1,
    inventarNPuntos(NuevaCantidadDePuntos, Puntos),
    punto(Punto).

