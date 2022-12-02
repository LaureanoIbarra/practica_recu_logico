% parcial(Tema, [Puntos]).
temaCopado(chocobos).
temaCopado(inversiones).
temaCopado(harryPotter).
temaCopado(carpinchos).
temaCopado(bidones).
temaCopado(piratas).
temaCopado(tierraMedia).
temaCopado(kraken).

punto(primerOrden).
punto(ordenSuperior).
punto(polimorfismo).
punto(listas).
punto(relleno).
punto(modelado).
punto(diagramado).

% Punto 1
/*
Se pide:
Hacer parcialEvalua/2 que relaciona un parcial con un punto que evalúa. No requiere ser inversible para el parcial.
*/
parcialEvalua(parcial(_, [Puntos]), Punto):-
    punto(Punto),
    member(Punto, Puntos).

% Punto 2
/*
Hacer esParcialListo/1 que resulta verdadero para un parcial que cumple todas las reglas de los parciales (tiene entre 7 y 10 
puntos, tiene un tema copado y evalúa todos los puntos al menos una vez). No requiere ser inversible para el parcial.
*/
esParcialListo(parcial(Tema, Puntos)):-
    temaCopado(Tema),
    cantidadDePuntosValidos(Puntos),
    forall(punto(Punto), parcialEvalua(parcial(Tema, Puntos), Punto)).

cantidadDePuntosValidos(Puntos):-
    length(Puntos, CantPuntos),
    between(7, 10, CantPuntos).
    
% Punto 3
/*
Hacer puntosInventados/1, que genera una lista de puntos de cantidad válida.
*/
puntosInvetados(Puntos):-
    between(7, 10, N),
    inventarNPuntos(N, Puntos).

inventarNPuntos(0, []).
inventarNPuntos(N, [P | Ps]):-
    NN is N - 1,
    inventarNPuntos(NN, Ps),
    punto(P).
% Punto 4
/*
Hacer nuevoParcial/1, que debe generar un parcial nuevo que esté listo.
*/
nuevoParcial(parcial(Tema, Puntos)):-
    puntosInvetados(Puntos),
    esParcialListo(parcial(Tema, Puntos)).

% Punto 5
/*
Ya que nos están haciendo los parciales, vamos a tratar de predecir quienes van a aprobar. 
Agregar a la base de conocimiento un predicado que relacione el nombre de un estudiante y 
un punto que sabe, con ejemplos.
*/
sabe(fede, ordenSuperior).
sabe(ale, polimorfismo).

% Punto 6
/*
Hacer aprueba/2, que relaciona a un estudiante con un parcial, siempre y cuando sepa todos los temas que este último abarca. No requiere ser inversible para el parcial.
*/
aprueba(Alumno, parcial(_, Puntos)):-
    sabe(Alumno, _),
    forall(member(Punto, Puntos), sabe(Alumno, Punto)).

% Punto 7
/*
Hacer una consulta que unifique la variable Aprobados con una lista de todos los estudiantes que aprueban este parcial:

parcial(chocobos, [primerOrden, primerOrden, ordenSuperior, polimorfismo, listas, relleno, modelado, diagramado]).

findall(ALumno, aprueba(Alumno, parcial(chocobos, [primerOrden, primerOrden, ordenSuperior,
     polimorfismo, listas, relleno, modelado, diagramado])), Alumnos).
*/
% Punto 8
/*
Saber si un parcial es sólo para elegidos, que es cuando sólo un alumno puede aprobarlo. No requiere ser inversible para el parcial.
*/
soloParaElegidos(parcial(Tema, Puntos)):-
    aprueba(Alumno, parcial(Tema, Puntos)),
    not((aprueba(OtroAlumno, parcial(Tema, Puntos)), OtroAlumno \= Alumno)).