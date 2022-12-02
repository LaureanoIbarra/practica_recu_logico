/*
Ahora están en pleno Manhattan con una bomba en sus manos, la cual McClane activó sin querer, y un 
problema lógico que sirve para desactivarla. Sólo tiene el tiempo de medio parcial para resolverlo. 
El problema consiste en responder la siguiente pregunta: ¿Cómo obtener exactamente 4 litros de agua 
con un bidón de 5 litros y otro de 3 litros?

Existen distintas acciones a realizar con cada bidón y las representamos de la siguiente manera:
accion(llenarChico).
accion(llenarGrande).
accion(vaciarChico).
accion(vaciarGrande).
accion(ponerChicoEnGrande).
accion(ponerGrandeEnChico).	

Para resolver esto tener en cuenta:

a. Un modelo el cual me permita manejar el estado de ambos bidones. El estado es la cantidad de litros 
de agua que tiene.
b. Realizar un predicado que relacione una acción (o paso) con un estado de bidones anterior y un estado de bidones posterior a realizar dicha acción: 
    i. Ejemplo 1: si tengo los bidones vacíos y la acción que debo realizar es llenar el bidón chico, lo que debe pasar es que el estado del bidón chico 
    debe “cambiar”, mientras que el grande queda igual. Por otro lado, teniendo en cuenta el enunciado, no sería posible realizar esa misma acción si 
    el bidón chico ya esta lleno
    ii. Si tengo el grande lleno y el chico vacío y la acción es de pasar del grande al chico, entonces el chico queda lleno, y el grande queda con el 
    resto del agua que no cupo en el chico.
PRO-TIP: Existen operadores min y max. Por ejemplo: N is min(4, 5)
Este predicado solo requiere ser inversible para el estado posterior.
c. Pensar un predicado que relacione un estado de bidones, con una cantidad de litros como objetivo. Dicho predicado debe ser verdadero 
cuando se alcanza cierto objetivo (el objetivo debe ser genérico, no necesariamente es 4 litros). Este predicado no requiere ser inversible.
d. Implementar el predicado resolverBidones/3 que resuelva el problema, teniendo en cuenta que siempre se comienza con los bidones vacíos. Ejemplo:
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

hacer(llenarChico, estado(LitrosChico, LitrosGrande), estado(3, LitrosGrande)):-
    LitrosChico < 3.
hacer(llenarGrande, estado(LitrosChico, LitrosGrande), estado(LitrosChico, 5)):-
    LitrosGrande < 5.
hacer(vaciarChico, estado(LitrosChico, LitrosGrande), estado(0, LitrosGrande)):-
    LitrosChico > 0.
hacer(vaciarGrande, estado(LitrosChico, LitrosGrande), estado(LitrosChico, 0)):-
    LitrosGrande> 0.
hacer(ponerChicoEnGrande, estado(LitrosChico, LitrosGrande), estado(LitrosChicoFin, LitrosGrandeFin)):-
    LitrosChico > 0,
    LitrosGrande < 5,
    LitrosGrandeFin is min(5, LitrosGrande + LitrosChico),
    LitrosChicoFin is LitrosChico - (LitrosGrandeFin - LitrosGrande).
hacer(ponerGrandeEnChico, estado(LitrosChico, LitrosGrande), estado(LitrosChicoFin, LitrosGrandeFin)):-
    LitrosGrande > 0,
    LitrosChico < 3,
    LitrosChicoFin is min(3, LitrosGrande + LitrosChico),
    LitrosGrandeFin is LitrosGrande - (LitrosChicoFin - LitrosChico).

cumpleObjetivo(estado(Objetivo, _), Objetivo).
cumpleObjetivo(estado(_, Objetivo), Objetivo).

resolverBidones(Objetivo, CantidadDeAcciones, Acciones):-
    resolverBidones(Objetivo, estado(0,0), CantidadDeAcciones, Acciones).


resolverBidones(Objetivo, Estado, _, [ ]):-
    cumpleObjetivo(Estado, Objetivo).

resolverBidones(Objetivo, EstadoAnterior, CantidadAcciones, [Accion | Acciones]):- 
    CantidadAcciones > 0, 
    not(cumpleObjetivo(EstadoAnterior, Objetivo)),
    accion(Accion), 
    hacer(Accion, EstadoAnterior, EstadoPosterior), 
    NuevaCantidad is CantidadAcciones - 1,
    resolverBidones(Objetivo, EstadoPosterior, NuevaCantidad, Acciones).