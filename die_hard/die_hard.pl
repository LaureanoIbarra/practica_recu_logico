% irA(lugar, barrio)) /  irA(calle1, calle2, barrio)) / hacer(accion, barrio)
simonDice(irA(calle138, amsterdam, harlem), [mcClane]). 
simonDice(hacer(vestirCartel, harlem), [mcClane]).
simonDice(irA(west72nd, broadway, upperWestSide), [mcClane, zeus]).
simonDice(hacer(resolverAcertijo, upperWestSide), [mcClane, zeus]).
simonDice(irA(wallStreetStation, worldTradeCenter), [mcClane, zeus]).
simonDice(hacer(atenderTelefono, worldTradeCenter), [zeus]).
simonDice(irA(tompkinsSquarePark, eastVillage), [mcClane, zeus]).
simonDice(hacer(desarmarBomba, eastVillage), [mcClane, zeus]).
simonDice(irA(yankeeStadium, bronx), [zeus]).

% Agregado para test
simonDice(irA(calle138, amsterdam, chascomus), [mcClane]). 
simonDice(hacer(resolverAcertijo, pp), [laucha]).
explosion(chascomus).
amenaza(pp, 9).
explosion(pp).

explosion(sextaAvenida).
explosion(worldTradeCenter).
explosion(bote).
amenaza(chinatown, 5).
amenaza(upperWestSide, 2).
amenaza(escuelaDeArthur, 3).


% -------------------- Punto 1 --------------------
/* Barrios y personas
    a. Relacionar a la persona y al barrio si esa persona estuvo en ese barrio.
    pasoPor(Persona, Barrio).
    Persona = mcClane
    Barrio = harlem
    b. Relacionar a una persona con todos los barrios por los que pasó, sin repetir.
*/

% a -------------------
pasoPor(Persona, Barrio):-
    simonDice(irA(_, _, Barrio), Personas),
    member(Persona, Personas).
    
pasoPor(Persona, Barrio):-
    simonDice(irA(_, Barrio), Personas),
    member(Persona, Personas).

pasoPor(Persona, Barrio):-
    simonDice(hacer(_, Barrio), Personas),
    member(Persona, Personas).

pasoPor2(Persona, Barrio):-
    simonDice(Accion, Personas),
    lugar(Accion, Barrio),
    member(Persona, Personas).

lugar(irA(_,_, Barrio), Barrio).
lugar(irA(_, Barrio), Barrio).
lugar(hacer(_, Barrio), Barrio).

% b -------------------
barriosDondePaso(Persona, Barrios):-
    pasoPor(Persona, _),
    findall(Barrio, pasoPor(Persona, Barrio), ListaBarrios),
    list_to_set(ListaBarrios, Barrios).
    
% -------------------- Punto 2 --------------------
/*
Conocer:
    a- A un posible culpable de atentado en un barrio, que es una persona que estuvo en un barrio en el cual hubo una explosión.
    b- Si un barrio dado explotó por culpa de McClane, que se cumple cuando ese barrio explotó y McClane fue el único que estuvo ahí.
*/

% a -------------------
posibleCulpable(Sospechoso, Barrio):-
    explosion(Barrio),
    pasoPor(Sospechoso, Barrio).

% b -------------------
explotoPorCulpaDeMcClane(Lugar):-
    posibleCulpable(mcClane, Lugar),
    not((posibleCulpable(Persona, Lugar), Persona \= mcClane)).

explotoPorCulpaDeMcClane2(Barrio):-
    explosion(Barrio),
    findall(Persona, posibleCulpable(Persona, Barrio), Personas),
    list_to_set(Personas, [mcClane]).

% -------------------- Punto 3 --------------------
/*
Quién es afortunado, que es aquel que estuvo en barrios amenazados por un total de al menos 8 horas 
(entre todos los barrios), pero en ninguno que haya explotado.
*/
tiempoAmenaza(Persona, TiempoTotal):-
    findall(Duracion, (pasoPor(Persona, Barrio), amenaza(Barrio, Duracion)), Duraciones),
    sum_list(Duraciones, TiempoTotal).

afortunado(Persona):-
    pasoPor(Persona, _),
    not(posibleCulpable(Persona, _)),
    tiempoAmenaza(Persona, TiempoTotal),
    TiempoTotal > 8.

% -------------------- Punto 4 --------------------

/*
El jefe quiere poder hacer la siguiente consulta:
?- puedoEcharA(mcClane).
Y, si no lo puede echar, quiere poder volver a preguntar para saber a quién puede echar.
El jefe puede echar a cualquiera que, en todos los barrios que estuvo, o bien hubo explosiones o bien el barrio estuvo amenazado por al menos 3 horas.
*/
puedeEcharA(Persona):-
    barriosDondePaso(Persona, Barrios),
    forall(member(Barrio, Barrios), explosion(Barrio)).

puedeEcharA(Persona):-
    barriosDondePaso(Persona, Barrios),
    forall(member(Barrio, Barrios), amenazadoAlMenos3Horas(Barrio)).

amenazadoAlMenos3Horas(Barrio):-
    tiempoAmenazaPorBarrio(Barrio, TiempoTotal),
    TiempoTotal >= 3.

tiempoAmenazaPorBarrio(Barrio, TiempoTotal):-
    pasoPor(_, Barrio),
    findall(Duracion, amenaza(Barrio, Duracion), Duraciones),
    sum_list(Duraciones, TiempoTotal).

% -------------------- Punto 5 --------------------

/*
Ahora están en pleno Manhattan con una bomba en sus manos, la cual McClane activó sin querer, y un problema lógico que sirve para desactivarla. 
Sólo tiene el tiempo de medio parcial para resolverlo. El problema consiste en responder la siguiente pregunta: 
¿Cómo obtener exactamente 4 litros de agua con un bidón de 5 litros y otro de 3 litros?

Existen distintas acciones a realizar con cada bidón y las representamos de la siguiente manera:
accion(llenarChico).
accion(llenarGrande).
accion(vaciarChico).
accion(vaciarGrande).
accion(ponerChicoEnGrande).
accion(ponerGrandeEnChico).	

Para resolver esto tener en cuenta:
    a- Un modelo el cual me permita manejar el estado de ambos bidones. El estado es la cantidad de litros de agua que tiene.
    b- Realizar un predicado que relacione una acción (o paso) con un estado de bidones anterior y un estado de bidones posterior a realizar dicha acción: 
        i- Ejemplo 1: si tengo los bidones vacíos y la acción que debo realizar es llenar el bidón chico, lo que debe pasar es que el estado del bidón chico debe “cambiar”, 
        mientras que el grande queda igual. Por otro lado, teniendo en cuenta el enunciado, no sería posible realizar esa misma acción si el bidón chico ya esta lleno
        ii- Si tengo el grande lleno y el chico vacío y la acción es de pasar del grande al chico, entonces el chico queda lleno, y el grande queda con el resto del agua que 
        no cupo en el chico.
    PRO-TIP: Existen operadores min y max. Por ejemplo: N is min(4, 5)
    Este predicado solo requiere ser inversible para el estado posterior.
    c- Pensar un predicado que relacione un estado de bidones, con una cantidad de litros como objetivo. Dicho predicado debe ser verdadero cuando se alcanza cierto objetivo 
    (el objetivo debe ser genérico, no necesariamente es 4 litros). Este predicado no requiere ser inversible.
    d- Implementar el predicado resolverBidones/3 que resuelva el problema, teniendo en cuenta que siempre se comienza con los bidones vacíos. Ejemplo:
    ?- resolverBidones(4, 9, Acciones).
    Acciones = [llenarChico, ponerChicoEnGrande, llenarChico, ponerChicoEnGrande, vaciarGrande, ponerChicoEnGrande, llenarChico, ponerChicoEnGrande]
    En el ejemplo, 4 es la cantidad de litros a obtener en cualquiera de los 2 bidones, y 9 es un límite máximo de acciones a realizar (hay 8 en nuestra lista de ejemplo).
    Otro ejemplo válido:
    ?- resolverBidones(3, 1, Acciones)
    Acciones = [llenarChico]
    Este predicado solo requiere ser inversible para el tercer argumento.
*/

accion(llenarChico).
accion(llenarGrande).
accion(vaciarChico).
accion(vaciarGrande).
accion(ponerChicoEnGrande).
accion(ponerGrandeEnChico).	

% Punto 5.a

% Elegimos hacer un functor: estado(LitrosDelChico, LitrosDelGrande)

% Punto 5.b

% Realizar un predicado que relacione una acción (o paso) con un estado de bidones anterior y un 
% estado de bidones posterior a realizar dicha acción: 

% - Ejemplo 1: si tengo los bidones vacíos y la acción que debo realizar es llenar el bidón chico, 
% lo que debe pasar es que el estado del bidón chico debe “cambiar”, mientras que el grande queda igual. 
% Por otro lado, teniendo en cuenta el enunciado, no sería posible realizar esa misma acción si el bidón 
% chico ya esta lleno.
% - Si tengo el grande lleno y el chico vacío y la acción es de pasar del grande al chico, entonces el chico 
% queda lleno, y el grande queda con el resto del agua que no cupo en el chico.

% PRO-TIP: Existen operadores min y max. Por ejemplo: N is min(4, 5)
% Este predicado solo requiere ser inversible para el estado posterior.

hacer(llenarChico, estado(LitrosDelChico, LitrosDelGrande), estado(3, LitrosDelGrande)):-
    LitrosDelChico < 3.
hacer(llenarGrande, estado(LitrosDelChico, LitrosDelGrande), estado(LitrosDelChico, 5)):-
    LitrosDelGrande < 5.
hacer(vaciarChico, estado(LitrosDelChico, LitrosDelGrande), estado(0, LitrosDelGrande)):-
    LitrosDelChico > 0.
hacer(vaciarGrande, estado(LitrosDelChico, LitrosDelGrande), estado(LitrosDelChico, 0)):-
    LitrosDelGrande > 0.
hacer(ponerChicoEnGrande, estado(InicialDelChico, InicialDelGrande), estado(FinalDelChico, FinalDelGrande)):-
    InicialDelChico > 0,
    InicialDelGrande < 5,
    FinalDelGrande is min(5, InicialDelGrande + InicialDelChico),
    FinalDelChico is InicialDelChico - (FinalDelGrande - InicialDelGrande).

hacer(ponerGrandeEnChico, estado(InicialDelChico, InicialDelGrande), estado(FinalDelChico, FinalDelGrande)):-
    InicialDelGrande > 0,
    InicialDelChico < 3,
    FinalDelChico is min(3, InicialDelGrande + InicialDelChico),
    FinalDelGrande is InicialDelGrande - (FinalDelChico - InicialDelChico).

% Punto 5.c

% Pensar un predicado que relacione un estado de bidones, con una cantidad de litros como objetivo. 
% Dicho predicado debe ser verdadero cuando se alcanza cierto objetivo (el objetivo debe ser genérico, 
% no necesariamente es 4 litros). Este predicado no requiere ser inversible.

cumpleObjetivo(estado(Objetivo, _), Objetivo).
cumpleObjetivo(estado(_, Objetivo), Objetivo).
% Punto 5.d

% Implementar el predicado resolverBidones/3 que resuelva el problema, teniendo en cuenta que siempre se 
% comienza con los bidones vacíos. 
% Ejemplo:
% ?- resolverBidones(4, 9, Acciones).
% Acciones = [llenarChico, ponerChicoEnGrande, llenarChico, ponerChicoEnGrande, 
% vaciarGrande, ponerChicoEnGrande, llenarChico, ponerChicoEnGrande]
% En el ejemplo, 4 es la cantidad de litros a obtener en cualquiera de los 2 bidones, y 9 es un límite máximo de acciones a realizar (hay 8 en nuestra lista de ejemplo).

% Otro ejemplo válido:
% ?- resolverBidones(3, 1, Acciones)
% Acciones = [llenarChico]
% Este predicado solo requiere ser inversible para el tercer argumento.

resolverBidones(Objetivo, CantidadAcciones, Acciones):-
    resolverBidones(Objetivo, estado(0, 0), CantidadAcciones, Acciones).

resolverBidones(Objetivo, Estado, _, [ ]):-
    cumpleObjetivo(Estado, Objetivo).
resolverBidones(Objetivo, EstadoAnterior, CantidadAcciones, [Accion | Acciones]):- 
    CantidadAcciones > 0, 
    not(cumpleObjetivo(EstadoAnterior, Objetivo)),
    accion(Accion), 
    hacer(Accion, EstadoAnterior, EstadoPosterior), 
    NuevaCantidad is CantidadAcciones - 1,
    resolverBidones(Objetivo, EstadoPosterior, NuevaCantidad, Acciones).
