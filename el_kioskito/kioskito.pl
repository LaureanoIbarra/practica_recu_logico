atienda(dodain, lunes, 9, 15).
atienda(dodain, miercoles, 9, 15).
atienda(dodain, viernes, 9, 15).
atienda(lucas, martes, 10, 20).
atienda(juanC, sabado, 18, 22).
atienda(juanC, domingo, 18, 22).
atienda(juanFdS, jueves, 10, 20).
atienda(juanFdS, viernes, 12, 24).
atienda(leoC, lunes, 14, 18).
atienda(leoC, miercoles, 14, 18).
atienda(martu, miercoles, 23, 24).

/** Punto 1 */
atienda(vale, Dia, HorarioInicio, HorarioFinal):-
    atienda(dodain, Dia, HorarioInicio, HorarioFinal).

atienda(vale, Dia, HorarioInicio, HorarioFinal):-
    atienda(juanC, Dia, HorarioInicio, HorarioFinal).

% - nadie hace el mismo horario que leoC
% por principio de universo cerrado, no agregamos a la base de conocimiento aquello que no tiene sentido agregar
% - maiu está pensando si hace el horario de 0 a 8 los martes y miércoles
% por principio de universo cerrado, lo desconocido se presume falso


/* Punto 2 */
quienAtiende(Persona, Dia, HorarioPuntual):-
    atienda(Persona, Dia, HorarioInicio, HorarioFinal),
    between(HorarioInicio, HorarioFinal, HorarioPuntual).
    
/* Punto 3 */
foreverAlone(Persona, Dia, HorarioPuntual):-
    quienAtiende(Persona, Dia, HorarioPuntual),
    not((quienAtiende(OtraPersona, Dia, HorarioPuntual), OtraPersona \= Persona)).


/* Punto 4*/
posiblesAtencion(Dia, Personas):-
    findall(Persona, quienAtiende(Persona, Dia, _), PersonasPosibles),
    list_to_set(PersonasPosibles, PersonasPosiblesSinRepetir),
    combinar(PersonasPosiblesSinRepetir, Personas).

combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]):-
    combinar(PersonasPosibles, Personas).
combinar([_|PersonasPosibles], Personas):-
    combinar(PersonasPosibles, Personas).

% Qué conceptos en conjunto resuelven este requerimiento
% - findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
% - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles  
    
/* Punto 5*/
vendedora(Persona):-venta(Persona, _, _).

venta(dodain, fecha(10, 8), [golosinas(1200), cigarillos(jockey), golosinas(50)]).
venta(dodain, fecha(12, 8), [bebidas(true, 8), bebidas(false, 1), golosinas(10)]).
venta(martu, fecha(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas, fecha(11, 8), [golosinas(600)]). % no es un vendedor
venta(lucas, fecha(18, 8), [bebidas(false, 2), cigarrillos([derby])]).

fueSuertudo(Persona):-
    vendedora(Persona),
    forall(venta(Persona, _, [Venta | _]), ventaImportante(Venta)).

ventaImportante(golosinas(Precio)):-
    Precio > 100.
ventaImportante(cigarillos(Marcas)):-
    length(Marcas, Cantidad),
    Cantidad >= 2.
ventaImportante(bebidas(true, _)).
ventaImportante(bebidas(_, Cantidad)):-
    Cantidad > 5.


:-begin_tests(kioskito).

test(atienden_los_viernes, set(Persona = [vale, dodain, juanFdS])):-
  atienda(Persona, viernes, _, _).

test(personas_que_atienden_un_dia_puntual_y_hora_puntual, set(Persona = [vale, dodain, leoC])):-
  quienAtiende(Persona, lunes, 14).

test(dias_que_atiende_una_persona_en_un_horario_puntual, set(Dia = [lunes, miercoles, viernes])):-
  quienAtiende(vale, Dia, 10).

test(una_persona_esta_forever_alone_porque_atiende_sola, set(Persona=[lucas])):-
  foreverAlone(Persona, martes, 19).

test(persona_que_no_cumple_un_horario_no_puede_estar_forever_alone, fail):-
  foreverAlone(martu, miercoles, 22).

test(posibilidades_de_atencion_en_un_dia_muestra_todas_las_variantes_posibles, set(Personas=[[],[dodain],[dodain,leoC],[dodain,leoC,martu],[dodain,leoC,martu,vale],[dodain,leoC,vale],[dodain,martu],[dodain,martu,vale],[dodain,vale],[leoC],[leoC,martu],[leoC,martu,vale],[leoC,vale],[martu],[martu,vale],[vale]])):-
    posiblesAtencion(miercoles, Personas).

test(personas_suertudas, set(Persona = [martu, dodain])):-
    fueSuertudo(Persona).

:-end_tests(kioskito).