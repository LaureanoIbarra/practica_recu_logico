%1) BASE DE CONOCIMIENTO
%creeEn(Persona, Personaje)
creeEn(gabriel, campanita).
creeEn(gabriel, magoDeOz).
creeEn(gabriel, cavenaghi).
creeEn(juan, conejoDePascua).
creeEn(macarena, reyesMagos).
creeEn(macarena, magoCapria).
creeEn(macarena, campanita).

%suenio(Persona, Suenio)
suenio(gabriel, loteria([5,9])).
suenio(gabriel, futbolista(arsenal)).
suenio(juan, cantante(100000)).
suenio(macarena, cantante(10000)).

%amigo(Personaje1, Personaje2)
amigo(campanita, reyesMagos).
amigo(campanita, conejoDePascua).
amigo(conejoDePascua, cavenaghi).

%2) Ambicioso
ambicioso(Persona):- persona(Persona), cumpleCondicionAmbicioso(Persona).
cumpleCondicionAmbicioso(Persona):- dificultadDeTodosLosSueniosDeAlguien(Persona, ListaSuenios), sumlist(ListaSuenios, Sumatoria), Sumatoria > 20.
dificultadDeTodosLosSueniosDeAlguien(Persona, Lista):- findall(DificultadSuenio, (suenio(Persona, Suenio), dificultad(Suenio, DificultadSuenio)), Lista).

persona(Persona):- suenio(Persona, _).
persona(Persona):- creeEn(Persona, _).

%dificultad(suenio, valor)
dificultad(cantante(Discos), 6):- Discos > 500000.
dificultad(cantante(Discos), 4):- Discos =< 500000.
dificultad(loteria(ListaNros), Valor):- length(ListaNros, CantNros), Valor is (10 * CantNros).
dificultad(futbolista(Equipo), 3):- equipoChico(Equipo).
dificultad(futbolista(Equipo), 16):- not(equipoChico(Equipo)).

equipoChico(arsenal).
equipoChico(aldosivi).

%3) tieneQuimica(Personaje, Persona)
tieneQuimica(Persona, Personaje):- persona(Persona), personaje(Personaje), creeEn(Persona, Personaje), condicionQuimica(Persona, Personaje).

personaje(Personaje):- creeEn(_, Personaje).

condicionQuimica(Persona, campanita):- not(forall(suenio(Persona, Suenio), (dificultad(Suenio, DificultadSuenio), DificultadSuenio > 5))).
condicionQuimica(Persona, _):- not(ambicioso(Persona)), forall(suenio(Persona, Suenio), suenioPuro(Suenio)).

suenioPuro(futbolista(_)).
suenioPuro(cantante(Discos)):- Discos < 200000.

%4) puedeAlegrar(Personaje, Persona)
puedeAlegrar(Personaje, Persona):- persona(Persona), personaje(Personaje), personaTieneSuenios(Persona), tieneQuimica(Persona, Personaje), cumpleCondicionAlegrar(Personaje, Persona).

personaTieneSuenios(Persona):- suenio(Persona, _).

cumpleCondicionAlegrar(Personaje, _):- not(enfermo(Personaje)).
cumpleCondicionAlegrar(Personaje, _):- enfermo(Personaje), sonAmigos(Personaje, PersonajeBackup), not(enfermo(PersonajeBackup)).

%enfermo(Personaje)
enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoDePascua).

%sonAmigos(Personaje1, Personaje2)
sonAmigos(Personaje1, Personaje2):- amigo(Personaje1, Personaje2).
sonAmigos(Personaje1, Personaje2):- amigo(Personaje1, PersonajeIntermedio), amigo(PersonajeIntermedio, Personaje2), PersonajeIntermedio \= Personaje2, PersonajeIntermedio \= Personaje1.

:- begin_tests( suenios ).

	% Punto 1 - base de conocimiento
	test( diegoNoCreeEnNadie , nondet ):- not(creeEn(diego, _)).
	
	% Punto 2 - persona ambiciosa
	test( gabrielEsAmbicioso , nondet ):- ambicioso(gabriel).
	
	test( juanNoEsAmbicioso , nondet ):- not(ambicioso(juan)).
	
	test( macarenaNoEsAmbiciosa , nondet ):- not(ambicioso(macarena)).

	% Punto 3 - tieneQuimica
	test( campanitaTieneQuimicaConGabriel , nondet):- tieneQuimica(gabriel, campanita).
	
	test( reyesMagosMagoCapriaYCampanitaTienenQuimicaConMacarena , set( Personajes == [ reyesMagos, magoCapria, campanita ])):- tieneQuimica(macarena, Personajes ).

	% Punto 4 - puedeAlegrar
	test( elMagroCapriaAlegraAMacarena, nondet):- puedeAlegrar(magoCapria, macarena).

	test( campanitaAlegraAMacarena, nondet):- puedeAlegrar(campanita, macarena).

:- end_tests( suenios ).


