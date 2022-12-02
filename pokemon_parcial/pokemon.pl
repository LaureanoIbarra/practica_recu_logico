% camino(GymA, GymB, DuracionViajeMin, CantidadPokeparadas).
camino(plaza_de_mayo, congreso, 9, 15).
camino(plaza_de_mayo, teatro_colon, 11, 15).
camino(plaza_de_mayo, abasto_shopping, 19, 28).
camino(plaza_de_mayo, cementerio_recoleta, 26, 36).
camino(congreso, teatro_colon, 10, 11).
camino(congreso, cementerio_recoleta, 15, 16).
camino(teatro_colon, abasto_shopping, 13, 20).
camino(teatro_colon, cementerio_recoleta, 17, 24).
camino(abasto_shopping, cementerio_recoleta, 27, 32).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Mejor Tour                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% camino(GymA, GymB, DuracionViajeMin, CantidadPokeparadas).
camino(plaza_de_mayo, congreso, 9, 15).
camino(plaza_de_mayo, teatro_colon, 11, 15).
camino(plaza_de_mayo, abasto_shopping, 19, 28).
camino(plaza_de_mayo, cementerio_recoleta, 26, 36).
camino(congreso, teatro_colon, 10, 11).
camino(congreso, cementerio_recoleta, 15, 16).
camino(teatro_colon, abasto_shopping, 13, 20).
camino(teatro_colon, cementerio_recoleta, 17, 24).
camino(abasto_shopping, cementerio_recoleta, 27, 32).


%etapa(UnGimnasio, OtroGimnasio, recorrido(Tiempo,Pokeparadas)).
etapa(UnGimnasio, OtroGimnasio, recorrido(Tiempo,Pokeparadas)):-
    camino(UnGimnasio, OtroGimnasio, Tiempo, Pokeparadas ).
etapa(UnGimnasio, OtroGimnasio, recorrido(Tiempo,Pokeparadas)):-
    camino(OtroGimnasio, UnGimnasio, Tiempo, Pokeparadas).

/*Generar una secuencia de etapas que pasa por todos los gimnasios, sin repetir los mismos y sin exceder el límite de tiempo.
Tip: Puede ser más sencillo primero armar la secuencia y luego controlar el total, pero también puede hacerse todo junto.
Pueden ser útiles los predicados:
permutation/2, el cual relaciona 2 listas cuando la segunda es una permutación de la primera. Este predicado es inversible para la segunda lista.*/

%recorridoPorTodosLosGimnasios(ListaGimnasios)
generarListaGimnasiosNoRepetida(ListaGimnasios):-
    findall(Gimnasio, etapa(Gimnasio,_,_), Gimnasios),
    list_to_set(Gimnasios, ListaGimnasios).

etapasSinExcederTiempo(Gimnasios, TiempoLimite,Pokeparadas):-
    generarListaGimnasiosNoRepetida(ListaGimnasios),
    recorridosPosibles(ListaGimnasios, Gimnasios, TiempoLimite, Pokeparadas).

%recorridosPosibles(Candidatos,Gimnasios,TiempoLimite)
recorridosPosibles([Gimnasio],[Gimnasio],_,0).       
recorridosPosibles(Candidatos,[Gimnasio, OtroGimnasio |Gimnasios],TiempoLimite, SumaPokeparadas):-
    TiempoLimite > 0,
    select(Gimnasio, Candidatos, RestoCandidatos),
    etapa(Gimnasio,OtroGimnasio,recorrido(Tiempo,Pokeparadas)),
    Resto is TiempoLimite - Tiempo,
    Resto >= 0,
    recorridosPosibles(RestoCandidatos, [OtroGimnasio|Gimnasios], Resto, SumaPokeparadasnueva),
    SumaPokeparadas is SumaPokeparadasnueva + Pokeparadas.

 

mejorTour(Etapas, LimiteDeTiempo):-
    etapasSinExcederTiempo(Etapas,LimiteDeTiempo,Pokeparadas),
    not((etapasSinExcederTiempo(OtrasEtapas,LimiteDeTiempo,OtrasPokeparadas), OtrasPokeparadas > Pokeparadas)).
    
    

/*Agregar está información a la base de conocimiento para todos los gimnasios anteriores, sin modificar lo realizado hasta ahora. El shopping tendrá un color, el Congreso otro, y los demás un tercero.
Implementar estaSitiado/2. Un gimnasio está sitiado cuando todos sus vecinos están ocupados por equipos de un mismo color, que no es el mismo del equipo gimnasio. Un gimnasio “vecino” es aquel conectado con un camino directamente, es decir, sin pasar por otros gimnasios en medio.*/    

%%color(Gimnasio, Color).
color(abasto_shopping,rojo).
color(congreso,verde).
color(teatro_colon,violeta).
color(cementerio_recoleta,violeta).
color(plaza_de_mayo,violeta).
    
estaSitiado(Gimnasio):-
    color(Gimnasio,Color),
    color(_,UnColor),
    UnColor \=Color,
    forall(gimnasioVecino(Gimnasio,GimnasioVecino), color(GimnasioVecino,UnColor)).

gimnasioVecino(Gimnasio,GimnasioVecino):-
    etapa(Gimnasio, GimnasioVecino, _).    

    

    

/**
 * mejorTour/2 relaciona un tiempo límite con un tour que se puede hacer dentro del mismo.
 * Debe ser inversible para el tour.
 * */
%mejorTour(TiempoLimite, Tour).


/**
 * estaSitiado/1 se cumple (o no) para un gimnasio. 
 * Debe ser inversible. 
 * */