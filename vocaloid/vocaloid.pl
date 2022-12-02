canta(megurineLuka, nightFever, 4).
canta(megurineLuka, foreverYoung , 5).

canta(hatsuneMiku, tellYourWorld, 4).

canta(gumi, foreverYoung, 4).
canta(gumi, tellYourWorld, 5).

canta(seeU, novemberRain, 6).
canta(seeU, nightFever, 5).

vocaloid(Vocaloid):-
    canta(Vocaloid, _, _).

% Punto 1
/*
Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, por lo que 
necesitamos un predicado para saber si un vocaloid es novedoso cuando saben al menos 2 canciones y el 
tiempo total que duran todas las canciones debería ser menor a 15.
*/
vocaloidNovedoso(Vocaloid):-
    vocaloid(Vocaloid),
    cantidadDeCanciones(Vocaloid, CantidadCanciones),
    CantidadCanciones >= 2,
    tiempoQueDuranCanciones(Vocaloid, TiempoDeCanciones),
    TiempoDeCanciones =< 15.

cantidadDeCanciones(Vocaloid, CantidadCanciones):-
    canciones(Vocaloid, Canciones),
    length(Canciones, CantidadCanciones).

canciones(Vocaloid, Canciones):-
    vocaloid(Vocaloid),
    findall(Cancion, canta(Vocaloid, Cancion, _), Canciones).

tiempoQueDuranCanciones(Vocaloid, TiempoDeCanciones):-
    tiempoCanciones(Vocaloid, ListaTiempoDeCanciones),
    sumlist(ListaTiempoDeCanciones, TiempoDeCanciones).

tiempoCanciones(Vocaloid, ListaTiempoDeCanciones):-
    vocaloid(Vocaloid),
    findall(TiempoCancion, tiempoCancion(Vocaloid, TiempoCancion), ListaTiempoDeCanciones).

tiempoCancion(Vocaloid, TiempoCancion):-
    canta(Vocaloid, _, TiempoCancion).

% Punto 2
/*
Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta, 
es por eso que se pide saber si un cantante es acelerado, condición que se da cuando todas sus 
canciones duran 4 minutos o menos. Resolver sin usar forall/2.
*/
acelerado(Vocaloid):-
    vocaloid(Vocaloid),
    not((tiempoCancion(Vocaloid, TiempoCancion), TiempoCancion > 4)). % No tiene cancion que dure mas de 4 minutos, en lugar de un forall asi:
                                                                      % forall(tiempoCancion(Vocaloid, TiempoCancion), TiempoCancion =< 4).

% Concietos

% Punto 1
/*
Modelar los conciertos y agregar en la base de conocimiento todo lo necesario.
*/

% concieto(nombreConcieto, tipo, famaDada, pais).
% gigante(cantidadMinimaDeCancion, duracionMinimaCanciones).
% median(tiempoMaximo).
% pequenio(tiempoMinimoDeAlgunaCancion).
concierto(mikuExpo, gigante(2, 6), 2000, usa).
concierto(magicalMirai, gigante(3, 10), 3000, japon).
concierto(vocalektVisions, mediano(9), 1000, usa).
concieto(mikuFest, pequenio(4), 100, argentina).

% Punto 2
/*
Se requiere saber si un vocaloid puede participar en un concierto, esto se da cuando cumple los requisitos del tipo de concierto. 
También sabemos que Hatsune Miku puede participar en cualquier concierto.
*/
puedeParticipar(hatsuneMiku,Concierto):-
	concierto(Concierto, _, _, _).

puedeParticipar(Cantante, Concierto):-
	vocaloid(Cantante),
	Cantante \= hatsuneMiku,
	concierto(Concierto, _, _, Requisitos),
    cumpleRequisitos(Cantante, Requisitos).

cumpleRequisitos(Vocaloid, gigante(CantidadMinimaDeCanciones, TiempoMinimo)):-
    cantidadDeCanciones(Vocaloid, CantidadCanciones),
    CantidadCanciones >= CantidadMinimaDeCanciones,
    tiempoQueDuranCanciones(Vocaloid, TiempoDeCanciones),
    TiempoDeCanciones > TiempoMinimo.

cumpleRequisitos(Vocaloid, mediano(TiempoMaximo)):-
    tiempoQueDuranCanciones(Vocaloid, TiempoDeCanciones),
    TiempoDeCanciones < TiempoMaximo.

cumpleRequisitos(Vocaloid, pequenio(TiempoMinimo)):-
    canta(Vocaloid, _, Tiempo),
	Tiempo > TiempoMinimo.

% Punto 3
/*
Conocer el vocaloid más famoso, es decir con mayor nivel de fama. El nivel de fama de un vocaloid se calcula 
como la fama total que le dan los conciertos en los cuales puede participar multiplicado por la cantidad de canciones que sabe cantar.
*/

masFamoso(Vocaloid):-
    nivelFamoso(Vocaloid, NivelMasFamoso),
    forall((nivelFamoso(OtroVocaloid, Nivel), OtroVocaloid \= Vocaloid), NivelMasFamoso > Nivel ).

nivelFamoso(Vocaloid, Nivel):-
    famaTotal(Vocaloid, FamaTotal),
    cantidadDeCanciones(Vocaloid, CantidadDeCanciones),
    Nivel is FamaTotal * CantidadDeCanciones.

famaTotal(Vocaloid, FamaTotal):-
    vocaloid(Vocaloid),
    findall(Fama, famaConcierto(Vocaloid, Fama), ListaFama),
    sumlist(ListaFama, FamaTotal).

famaConcierto(Vocaloid, Fama):-
    puedeParticipar(Vocaloid, Concierto),
    fama(Concierto, Fama).

fama(Concierto, Fama):-
    concierto(Concierto, _, Fama, _).

% Punto 4
/*
Sabemos que:
megurineLuka conoce a hatsuneMiku  y a gumi 
gumi conoce a seeU
seeU conoce a kaito

Queremos verificar si un vocaloid es el único que participa de un concierto, esto se cumple 
si ninguno de sus conocidos ya sea directo o indirectos (en cualquiera de los niveles) 
participa en el mismo concierto.
*/
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

% Conocido directo
conocido(Vocaloid, OtroVocaloid):-
    conoce(Vocaloid, OtroVocaloid).

% Conocido Indirecto
conocido(Vocaloid, OtroVocaloid):-
    conoce(Vocaloid, UnVocaloid),
    conoce(UnVocaloid, OtroVocaloid).

unicoParticipanteEntreConocido(Vocaloid, Concierto):-
    puedeParticipar(Vocaloid, Concierto),
    not((conocido(Vocaloid, OtroVocaloid))),
    puedeParticipar(OtroVocaloid, Concierto).

% Punto 5
/*
Supongamos que aparece un nuevo tipo de concierto y necesitamos tenerlo en cuenta en nuestra solución, 
explique los cambios que habría que realizar para que siga todo funcionando. ¿Qué conceptos facilitaron dicha implementación?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

En la solución planteada habría que agregar una claúsula en el predicado cumpleRequisitos/2  
que tenga en cuenta el nuevo functor con sus respectivos requisitos 

El concepto que facilita los cambios para el nuevo requerimiento es el polimorfismo, que nos permite dar un tratamiento en 
particular a cada uno de los conciertos en la cabeza de la cláusula.
*/