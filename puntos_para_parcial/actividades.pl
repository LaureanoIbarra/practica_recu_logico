actividad(cine).
actividad(arjona).
actividad(princesas_on_ice).
actividad(pool).
actividad(bowling).

costo(cine, 400).
costo(arjona, 1750).
costo(princesas_on_ice, 2500).
costo(pool, 350).
costo(bowling, 300).

/*
Se pide definir el predicado
actividades(Plata, ActividadesPosibles)
que relacione una determinada cantidad de plata con la combinación de actividades que podemos hacer.

*/

/*
Cada actividad está definida en predicados individuales, 
para poder trabajar la lista de actividades posibles necesitamos utilizar el predicado findall/3:

*/
actividades(Plata, ActividadesPosibles):-
    findall(Actividad, actividad(Actividad), Actividades),
    actividadesPosibles(Actividades, Plata, ActividadesPosibles).

% Caso 1 | Base: Cuando no tengo actividades, no hay actividades posibles, no importa cuánta plata tenga:

actividadesPosibles([] , _ , []).

/*Caso 2 | Recursivo: Una actividad posible va a formar parte del conjunto 
solución si tengo plata suficiente. El resto de las actividades posibles se 
relacionará con la plata que me quede tras hacer esa actividad: */

actividadesPosibles([Actividad|Actividades], Plata, [Actividad|Posibles]):-
    costo(Actividad, Costo), 
    Plata > Costo, 
    PlataRestante is Plata - Costo,
    actividadesPosibles(Actividades, PlataRestante, Posibles).

/* 
Caso 3 | Recursivo:  Si decido no hacer esa actividad, tendré la misma plata para las actividades restantes:
*/

actividadesPosibles([_|Actividades], Plata, Posibles):-
    actividadesPosibles(Actividades, Plata, Posibles).

/*
En la última cláusula puede pasar que no haga la actividad porque:
1) no tengo plata para hacer esa actividad, o bien
2) tengo plata para hacer esa actividad pero no me interesa. 
*/