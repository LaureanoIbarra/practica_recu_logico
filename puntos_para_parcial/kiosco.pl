atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).

atiende(lucas, martes, 10, 20).

atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).

atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).

atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).

atiende(martu, miercoles, 23, 24).

atiende(vale, Dias, HorarioDeArranque, HorarioDeCierre):-
    atiende(dodain, Dias, HorarioDeArranque, HorarioDeCierre).
atiende(vale, Dias, HorarioDeArranque, HorarioDeCierre):-
    atiende(juanC, Dias, HorarioDeArranque, HorarioDeCierre).

quienAtiende(Persona, Dia, Hora):-
    atiende(Persona, Dia, HoraInicio, HoraFinal),
    between(HoraInicio, HoraFinal, Hora).

/* PUNTO 4
Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día. 
Por ejemplo, si preguntamos por el miércoles, tiene que darnos esta combinatoria:
nadie
dodain solo
dodain y leoC
dodain, vale, martu y leoC
vale y martu
etc.

Queremos saber todas las posibilidades de atención de ese día. La única restricción es que la persona 
atienda ese día (no puede aparecer lucas, por ejemplo, porque no atiende el miércoles).
*/
posibilidadesAtencion(Dia, Personas):-
    findall(Persona, quienAtiende(Persona, Dia, _), PersonasPosibles),
    list_to_set(PersonasPosibles, PersonasPosiblesSinRepetir),
    combinar(PersonasPosiblesSinRepetir, Personas).
    
combinar([], []).
combinar([Persona | PersonasPosibles], [Persona | Personas]):-
    combinar(PersonasPosibles, Personas).

combinar([_| PersonasPosibles], Personas):-
    combinar(PersonasPosibles, Personas).