% libro(título, autor, edición)
contenido(amazingzone, host1, 0.1, libro(lordOfTheRings, jrrTolkien, 4)).
contenido(g00gle, ggle1, 0.04, libro(foundation, asimov, 3)).
contenido(g00gle, ggle1, 0.015, libro(estudioEnEscarlata, conanDoyle, 3)).

% musica(título, género, banda/artista)
contenido(spotify, spot1, 0.3, musica(theLastHero, hardRock, alterBridge)).
contenido(pandora, pand1, 0.3, musica(burn, hardRock, deepPurple)).
contenido(spotify, spot1, 0.3, musica(2, hardRock, blackCountryCommunion)).
contenido(spotify, spot2, 0.233, musica(squareUp, kpop, blackPink)).
contenido(pandora, pand1, 0.21, musica(exAct, kpop, exo)).
contenido(pandora, pand1, 0.28, musica(powerslave, heavyMetal, ironMaiden)).
contenido(spotify, spot4, 0.18, musica(whiteWind, kpop, mamamoo)).
contenido(spotify, spot2, 0.203, musica(shatterMe, dubstep, lindseyStirling)).
contenido(spotify, spot4, 0.22, musica(redMoon, kpop, mamamoo)).
contenido(g00gle, ggle1, 0.31, musica(braveNewWorld, heavyMetal, ironMaiden)).
contenido(pandora, pand1, 0.212, musica(loveYourself, kpop, bts)).
contenido(spotify, spot2, 0.1999, musica(aloneInTheCity, kpop, dreamcatcher)).

% serie(título, géneros)
contenido(netflix, netf1, 30, serie(strangerThings, [thriller, fantasia])).
contenido(fox, fox2, 500, serie(xfiles, [scifi])).
contenido(netflix, netf2, 50, serie(dark, [thriller, drama])).
contenido(fox, fox3, 127, serie(theMentalist, [drama, misterio])).
contenido(amazon, amz1, 12, serie(goodOmens, [comedia,scifi])).
contenido(netflix, netf1, 810, serie(doctorWho, [scifi, drama])).

% pelicula(título, género, año)
contenido(netflix, netf1, 2, pelicula(veronica, terror, 2017)).
contenido(netflix, netf1, 3, pelicula(infinityWar, accion, 2018)).
contenido(netflix, netf1, 3, pelicula(spidermanFarFromHome, accion, 2019)).

descarga(mati1009, strangerThings).
descarga(mati1009, infinityWar).
descarga(leoOoOok, dark).
descarga(leoOoOok, powerslave).



% ------------------- Punto 1 -------------------
/*
La vida es más fácil cuando hablamos solo de los títulos de las cosas...

    i. titulo/2. Relacionar un contenido con su título.
    ii.descargaContenido/2. Relaciona a un usuario con un contenido descargado, es decir toda la información completa del mismo.
*/

% i -------------------
titulo(Contenido, Titulo):-
    contenido(_, _, _, Contenido),
    tituloFunctor(Contenido, Titulo).

tituloFunctor(libro(Titulo, _, _), Titulo).
tituloFunctor(musica(Titulo, _, _), Titulo).
tituloFunctor(serie(Titulo, _), Titulo).
tituloFunctor(pelicula(Titulo, _, _), Titulo).

% ii -------------------
descargaContenido(Usuario, Contenido):-
    descarga(Usuario, Titulo),
    titulo(Contenido, Titulo).

% ------------------- Punto 2 -------------------
/*
contenidoPopular/1. Un contenido es popular si lo descargan más de 10 usuarios.
*/

contenidoPopular(Contenido):-
    contenidoTotalUsuarios(Contenido, TotalDescargas),
    TotalDescargas >= 0.
    
contenidoTotalUsuarios(Contenido, TotalDescargas):-
    descargaContenido(_, Contenido),
    findall(Contenido, descargaContenido(_, Contenido), Descargas),
    length(Descargas, TotalDescargas).

% ------------------- Punto 3 -------------------
/*
cinefilo/1 Un usuario es cinéfilo si solo descarga contenido audiovisual (series y películas)
*/
contenidoAudiovisual(pelicula(_, _, _)).
contenidoAudiovisual(serie(_, _)).

cinefilo(Usuario):-
    descarga(Usuario, _),
    forall(descargaContenido(Usuario, Contenido), contenidoAudiovisual(Contenido)).

% ------------------- Punto 4 -------------------
/*
totalDescargado/2. Relaciona a un usuario con el total del peso del contenido de sus descargas, en GB
*/
totalDescargado(Usuario, TotalDescargas):-
    descarga(Usuario, _),
    findall(Gigas, (descargaContenido(Usuario, Contenido), peso(Contenido, Gigas)), TotalGigas),
    sumlist(TotalGigas, TotalDescargas).

peso(Contenido, Gigas):-
    contenido(_, _, Gigas, Contenido).

% ------------------- Punto 5 -------------------
/*
usuarioCool/1. Un usuario es cool, si solo descarga contenido cool:

 - La música es cool si el género es kpop o hardRock.
 - Las series, si tienen más de un género.
 - Las películas anteriores al 2010 son cool. 
 - Ningún libro es cool. (DISCREPO TOTALMENTE CON ESTO)
*/

contenidoCool(musica(_, kpop, _)).
contenidoCool(series(_, Generos)):-
    length(Generos, CantGeneros),
    CantGeneros > 2.
contenidoCool(pelicula(_, _, Anio)):-
    Anio < 2010.

usuarioCool(Usuario):-
    descarga(Usuario, _),
    forall(descargaContenido(Usuario, Contenido), contenidoCool(Contenido)).

% ------------------- Punto 6 -------------------
/*
empresaHeterogenea/1. Si todo su contenido no es del mismo tipo. Es decir, todo película, o todo serie... etc.
*/
empresaHomogenea(Empresa):-
    contenido(Empresa, _, _, Contenido1),
    forall(contenido(Empresa, _, _, Contenido2), mismoTipo(Contenido1, Contenido2)).

empresaHeterogenea(Empresa):-
    contenido(Empresa, _, _, _),
    not(empresaHomogenea(Empresa)).

empresaHeterogenea2(Empresa):-
    contenido(Empresa, _, _, Contenido1),
    contenido(Empresa, _, _, Contenido2),
    not(mismoTipo(Contenido1, Contenido2)).

mismoTipo(pelicula(_, _, _), pelicula(_, _, _)).
mismoTipo(musica(_, _, _), musica(_, _, _)).
mismoTipo(libro(_, _, _), libro(_, _, _)).
mismoTipo(serie(_, _), serie(_, _)).

% ------------------- Punto 7 -------------------
/*
Existe la sobrecarga de equipos, por lo tanto vamos a querer trabajar sobre los servidores a partir del peso de su contenido:

    I- cargaServidor/3. Relaciona a una empresa con un servidor de dicha empresa y su carga, es decir el peso conjunto de todo su contenido.
    II- tieneMuchaCarga/2. Relaciona una empresa con su servidor que tiene exceso de carga. Esto pasa cuando supera los 1000 GB de información.
    III- servidorMasLiviano/2. Relaciona a la empresa con su servidor más liviano, que es aquel que tiene menor carga, teniendo en cuenta que si 
    es uno solo, no puede tener mucha carga.
    IV- balancearServidor/3. Relaciona una empresa, un servidor que tiene mucha carga y el servidor más liviano de la empresa; de forma tal de 
    planificar una migración de contenido del primero al segundo, los cuales deben ser distintos.
*/ 
% I -------------------
cargaServidor(Empresa, Servidor, Carga):- % Carga es total de descargas
    contenido(Empresa, Servidor, _, _),
    findall(Peso, contenido(Empresa, Servidor, Peso, _), Pesos),
    sumlist(Pesos, Carga).

% II -------------------
tieneMuchaCarga(Empresa, Servidor):-
    cargaServidor(Empresa, Servidor, Carga),
    Carga > 1000.

% III -------------------
servidorMasLiviano(Empresa, ServidorMasLiviano):- % CASO DE SERVIDOR UNICO
    cargaServidor(Empresa, ServidorMasLiviano, _),
    not((cargaServidor(Empresa, OtroServidor, _), ServidorMasLiviano \= OtroServidor)),
    not(tieneMuchaCarga(Empresa, ServidorMasLiviano)).

servidorMasLiviano(Empresa, ServidorLiviano):- % CASO DE MAS DE UN SERVIDOR
    cargaServidor(Empresa, ServidorLiviano, Carga),
    cargaServidor(Empresa, OtroServidor, _), 
    OtroServidor \= ServidorLiviano,
    not((cargaServidor(Empresa, _, OtraCarga), Carga > OtraCarga)).

% IV -------------------
balancearServidor(Empresa, ServidorConMuchaCarga, ServidorMasLiviano):-
    tieneMuchaCarga(Empresa, ServidorConMuchaCarga),
    servidorMasLiviano(Empresa, ServidorMasLiviano).