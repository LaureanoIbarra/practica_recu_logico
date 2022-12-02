esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

hizo(harry, fueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione, irA(seccionRestringida)).
hizo(harry, irA(bosque)).
hizo(harry, irA(tercerPiso)).
hizo(draco, irA(mazmorras)).
hizo(ron, buenaAccion(50, ganarAlAjedrezMagico)).
hizo(hermione, buenaAccion(50, salvarASusAmigos)).
hizo(harry, buenaAccion(60, ganarleAVoldemort)).

lugarProhibido(bosque, 50).
lugarProhibido(seccionRestringida, 10).
lugarProhibido(tercerPiso, 75).

/* Punto 1 a

Saber si un mago es buen alumno, que se cumple si hizo alguna acción y 
ninguna de las cosas que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo).*/

esBuenAlumno(Mago):-
    hizoAlgo(Mago),
    not(hizoAlgoMalo(Mago)).

hizoAlgo(Mago):-
    hizo(Mago, _).

hizoAlgoMalo(Mago):-
    hizo(Mago, Accion),
    puntajeQueGenera(Accion, Puntaje),
    Puntaje < 0.

puntajeQueGenera(fueraDeCama, -50).
puntajeQueGenera(irA(Lugar), PuntajeQueResta):-
  lugarProhibido(Lugar, Puntos),
  PuntajeQueResta is Puntos * -1.
puntajeQueGenera(buenaAccion(Puntaje, _), Puntaje).

/* Punto 1 b
Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.*/

esRecurrente(Accion):-
    hizo(Mago, Accion),
    hizo(OtroMago, Accion),
    Mago \= OtroMago.

/* Punto 2 
Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros. */

puntajeTotalDeCasa(Casa, PuntajeTotal):-
    esDe(_, Casa),
    findall(
        Puntos,
        (esDe(Mago, Casa), puntosQueObtuvo(Mago, _, Puntos)),
        ListaPuntos),
    sum_list(ListaPuntos, PuntajeTotal).

puntosQueObtuvo(Mago, Accion, Puntos):-
    hizo(Mago, Accion),
    puntajeQueGenera(Accion, Puntos).

/* Punto 3 
Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una cantidad mayor de puntos que todas las otras.*/

casaGanadora(Casa):-
    puntajeTotalDeCasa(Casa, PuntajeMayor),
    forall((puntajeTotalDeCasa(OtraCasa, PuntajeMenor), Casa \= OtraCasa),
            PuntajeMayor > PuntajeMenor). % Para todos los puntajes de las casas, el puntajeMayor es el mayor

casaGanadora2(Casa):-
    puntajeTotalDeCasa(Casa, PuntajeMayor),
    not((puntajeTotalDeCasa(_, OtroPuntaje), OtroPuntaje > PuntajeMayor)). % No existe otra casa con un puntaje mayor

/* Punto 4
Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. 
La información que nos interesa de las respuestas en clase son: cuál fue la pregunta, cuál es la dificultad de la pregunta y qué profesor la hizo.*/
hizo(hermione, responderPregunta(dondeSeEncuentraUnBezoar, 20, snape)).
hizo(hermione, responderPregunta(comoHacerLevitarUnaPluma, 25, flitwick)).

puntajeQueGenera(responderPregunta(_, Dificultad, snape), Puntos):-
    Puntos is Dificultad // 2.
  puntajeQueGenera(responderPregunta(_, Dificultad, Profesor), Dificultad):- Profesor \= snape.