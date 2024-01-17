%Proyecto 2 Juego de Domino.
%Ricardo Illescas 197809
%Miguel Méndez 203702.

%Método empezarJuego inicializa las listas de las fichas del usuario y las que no son del usuario.
% Tambien llama al metodo para empezar a jugar.
empezarJuego:-
	nb_setval(ocultas,[[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[2,2],[2,3],[2,4],[2,5],[2,6],[3,3],[3,4],[3,5],[3,6],[4,4],[4,5],[4,6],[5,5],[5,6],[6,6]]),
	nb_setval(cantManoJug,7),
	nb_setval(cantManoOpo,7),
	nb_setval(tablero,[]),
	write("Ingresa tus fichas como lista de listas: [[A,B],[C,D],...]"),nl,
	read(ManoInicial),nl,
	nb_setval(mano,ManoInicial),
	nb_getval(ocultas,NuevaOcultas),
	eliminarLista(ManoInicial,NuevaOcultas,NuevaNO),
	nb_setval(ocultas,NuevaNO),
	write("Si inicias tu escribe y, si inicia el oponente escribe n"),nl,
	read(TuPrimero),
	primerPaso(TuPrimero,Turno),
	jugada(Turno).

%Metodo primerPaso(i,o) unicamente realiza el primer movimiento y llama a la siguiente jugada.
% La entrada puede ser y o n dependiendo de quien empiece el juego.

primerPaso(n,Turno):-
	write("Ingresa la ficha de tu oponente: "),nl,
	read(Ficha),
	nb_setval(tablero,[Ficha,Ficha]),
	nb_setval(cantManoOpo,6),
	nb_getval(ocultas,Ocultas),
	eliminarFicha(Ficha,Ocultas,NuevaOcultas),
	nb_setval(ocultas,NuevaOcultas),
	Turno is 1.

primerPaso(y,Turno):-
	write("Ingresa la ficha a colocar: "),nl,
	read(Ficha),
	nb_setval(tablero,[Ficha,Ficha]),
	nb_setval(cantManoJug,6),
	nb_getval(mano,Mano),
	eliminarFicha(Ficha,Mano,NuevaMano),
	nb_setval(mano,NuevaMano),
	Turno is 0.

%Metodo jugada(i), este metodo revisa si ya acabó el juego, imprime el tablero y llama al turno del oponente

jugada(0):-
	nb_getval(cantManoJug,Cant),
	((Cant<1,write("JUEGO TERMINADO========GANASTE========"),nl,!);
	(nb_getval(tablero,Tablero),
	write("Tablero: "),nl,write(Tablero),nl,
	nl,write("Cuantas fichas roba el otro?"),nl,
	read(Robadas),
	write("Donde tira?"),nl,
	write("-1: Tira arriba"),nl,
	write("0: Pasó o robó"),nl,
	write("1: Tira abajo"),nl,nl,
	read(Donde),
	jugadaOponente(Robadas,Donde),nl,
	jugada(1))).

jugada(1):-
	nb_getval(cantManoOpo,Cant),
	write("Fichas del oponente:"),write(Cant),nl,
	((Cant<1,write("JUEGO TERMINADO========PERDISTE========"),nl,!);
	(nb_getval(tablero,Tablero),
	write("Tablero: "),nl,write(Tablero),nl,
	nb_getval(mano,Mano),
	nl,write("Mano jugador:"),write(Mano),nl,
	hacerMovimiento,
	jugada(0))).

%Metodo jugadaOponente(i,i) pone la ficha en el tablero y actualiza el numero de fichas del oponente.
jugadaOponente(Robadas,0):-
	checarEmpate(empate),
	nb_getval(cantManoOpo,Cant),
	NuevaCant is Cant+Robadas,
	nb_setval(cantManoOpo,NuevaCant),
	nb_setval(empate,1).

jugadaOponente(Robadas,Donde):-
	write("Que ficha colocó? Forma de lista"),nl,
	read(Ficha),
	cambiarFicha(Ficha,Donde,NuevaFicha),
	ponerEnTablero(Donde,NuevaFicha),
	nb_getval(ocultas,Ocultas),
	eliminarFicha(NuevaFicha,Ocultas,NuevaOcultas),
	nb_setval(ocultas,NuevaOcultas),
	nb_getval(cantManoOpo,Cant),
	NuevaCant is (Robadas+Cant-1),
	nb_setval(empate,0),
	nb_setval(cantManoOpo,NuevaCant).

%Metodo cambiarFicha(i,i,o) es para acomodar en orden en el tablero
cambiarFicha(Ficha,1,NuevaFicha):-
	cabeza(Ficha,CabFicha),last(Ficha,ColaFicha),
	nb_getval(tablero,Tablero),
	last(Tablero,ColaTablero),last(ColaTablero,UltimaTablero),
	((CabFicha=:=UltimaTablero,NuevaFicha=Ficha);
	(NuevaFicha=[ColaFicha,CabFicha])).

cambiarFicha(Ficha,-1,NuevaFicha):-
	cabeza(Ficha,CabFicha),last(Ficha,ColaFicha),
	nb_getval(tablero,Tablero),
	cabeza(Tablero,CabTablero),cabeza(CabTablero,PrimeraTab),
	((ColaFicha=:=PrimeraTab,NuevaFicha=Ficha);
	(NuevaFicha=[ColaFicha,CabFicha])).

%Metodo ponerEnTablero(i,i) agrega la ficha al tablero en el lado que corresponde
ponerEnTablero(-1,Ficha):-
	nb_getval(tablero,Tablero),
	nb_setval(tablero,[Ficha|Tablero]).

ponerEnTablero(1,Ficha):-
	nb_getval(tablero,Tablero),
	union(Tablero,[Ficha],NuevoTablero),
	nb_setval(tablero,NuevoTablero).

ponerEnTablero(2,Ficha):-
	nb_getval(tablero,[[CabTablero|_]|ColaTablero]),
	cabeza(Ficha,CabFicha),last(Ficha,ColaFicha),
	last(ColaTablero,UltimaTablero),last(UltimaTablero,UltimoNumero),
	((CabFicha=:=CabTablero,ponerEnTablero(-1,[ColaFicha,CabFicha]));
	(ColaFicha=:=CabTablero, ponerEnTablero(-1,Ficha));
	(CabFicha=:=UltimoNumero, ponerEnTablero(1,Ficha));
	(ColaFicha=:=UltimoNumero, ponerEnTablero(1,[ColaFicha,CabFicha])),!).

%Metodo hacerMovimiento realiza toda la jugada.
hacerMovimiento:-
	nb_getval(mano,Mano),
	nb_getval(tablero,[[CabTablero,_]|ColaTablero]),
	nb_getval(cantManoJug, Cant),
	NuevaCant is Cant-1,
	buscarOpcion(Mano,CabTablero,[],Disponibles),
	last(ColaTablero,UltimaTablero),
	last(UltimaTablero,UltimoNumero),
	buscarOpcion(Mano,UltimoNumero,Disponibles,PosiblesFichas),
	((PosiblesFichas==[],write("No hay que jugar"),nl,
	  robarFicha(Mano,Cant));
	(length(PosiblesFichas,1),
		write("Posibles movimientos: "), write(PosiblesFichas), nl,
		cabeza(PosiblesFichas,Ficha),
		eliminarFicha(Ficha,Mano,NuevaMano),
	        nb_setval(mano,NuevaMano),
		nb_getval(mano,ManoMuestra1),
		nl,write("Mano después de jugar: "),write(ManoMuestra1),nl),
		ponerEnTablero(2,Ficha),
		nb_setval(empate,0),
		nb_setval(cantManoJug,NuevaCant),
		nl,write("Mejor movimiento: "),write(Ficha),nl;
	(write("Posible(s) movimientos: "), write(PosiblesFichas),nl,
		nb_getval(tablero,Tablero),
		nb_getval(ocultas,Ocultas),
		alphabeta(Tablero,3,Ocultas,Mano,Mano,1,-10000,10000,MejorMovimiento,Valor),
		write("Valor: "),write(Valor),nl,
		nl,write("Mejor movimiento: "),
		write(MejorMovimiento),nl,
		eliminarFicha(MejorMovimiento,Mano,NuevaMano),
		nb_setval(mano,NuevaMano),	        % Aqui modifique
		nb_getval(mano,ManoMuestra2),
		nl,write("Mano después de jugar: "),write(ManoMuestra2),
		nb_setval(empate,0),
		nb_setval(cantManoJug,NuevaCant),
		ponerEnTablero(2,MejorMovimiento),!)).

%Metodo robarFicha tomar una ficha y agregarla
robarFicha(Mano,Cant):-
	nb_getval(cantManoOpo,CantOpo),
	nb_getval(ocultas,Ocultas),
	length(Ocultas,Sobrantes),
	Valor is Sobrantes-CantOpo,
	((Valor =:= 0,write("PASO"),nl,
	nb_getval(empate,Empate),
	checarEmpate(Empate));
	(write("Agrega nueva ficha: "),nl,
	read(Ficha),
	nb_setval(mano,[Ficha|Mano]),
	nb_getval(ocultas,Ocultas),
	eliminarFicha(Ficha,Ocultas,NuevaOcultas),
	nb_setval(ocultas,NuevaOcultas),
	CantNueva is (Cant+1),
	nb_setval(cantManoJug,CantNueva),
	nl,write("# Fichas que tienes "),write(CantNueva),nl,
	hacerMovimiento)).

%Metodo checarEmpate(i) permite o no seguir jugando
checarEmpate(0):-
	nb_setval(empate,1),
	jugada(0).

checarEmpate(1):-
	write("========== E M P A T E ========"),nl,fail.

%=====================================================
%      Algoritmo minimax y función heurística
%=====================================================

%Metodo ponerFicha(i,i,i,o,o) pone ficha en tablero y quita de la mano.
ponerFicha(Mano,Ficha,Tablero,NuevaMano,NuevoTablero):-
	completaTablero(Ficha,Tablero,NuevoTablero),
	eliminarFicha(Ficha,Mano,NuevaMano).

completaTablero(Ficha,Tablero,NuevoTablero):-
	nb_setval(tab,Tablero),
	nb_getval(tab,[[CabTablero|_]|ColaTab]),
	cabeza(Ficha,CabFicha),last(Ficha,ColaFicha),
	last(ColaTab,UltimaTab),last(UltimaTab,UltimoNumero),
	((CabFicha=:=CabTablero,ajustar(-1,[ColaFicha,CabFicha],Tablero,NuevoTablero));
	(ColaFicha=:=CabTablero,ajustar(-1,Ficha,Tablero,NuevoTablero));
	(CabFicha=:=UltimoNumero,ajustar(1,Ficha,Tablero,NuevoTablero));
	(ColaFicha=:=UltimoNumero,ajustar(1,[ColaFicha,CabFicha],Tablero,NuevoTablero)),
	!).

%Metodo ajustar(i,i,i,o) pone fichas en el tablero
ajustar(-1,Ficha,Tablero,NuevoTablero):-
	union([Ficha],Tablero,NuevoTablero).

ajustar(1,Ficha,Tablero,NuevoTablero):-
	union(Tablero,[Ficha],NuevoTablero).

%=====================================================
%              Alphabeta
%=====================================================
%Metodo alphabeta(i,i,i,i,i,i,i,i,o,o) que implementa minimax con la poda para encontrar el mejor movimiento
%Con mano jugador vacia
alphabeta(_,_,Ocultas,[],_,_,_,_,_,Valor):-
	length(Ocultas,LongOcultas),
	Valor is LongOcultas,!.

%La ficha no se puede poner/ robar o pasar
alphabeta(MaxMin,_,Ocultas,Mano,[],_,_,_,_,Valor):-
	length(Ocultas,LongOcultas),length(Mano,LonMano),
	Valor is (LongOcultas-LonMano)*(-MaxMin),!.

%Se alcanza la profundidad maxima
alphabeta(_,0,Ocultas,Mano,_,_,_,_,_,Valor):-
	length(Ocultas,NumOcultas),length(Mano,NumMano),
	Valor is (NumOcultas-NumMano),!.
%Ocultas esta vacia
alphabeta(_,_,[],Mano,_,_,_,_,_,Valor):-
	length(Mano,NumMano),
	Valor is -NumMano,!.

%Busqueda general
alphabeta(Tablero,Profundidad,Ocultas,Mano,Busqueda,MaxMin,Alpha,Beta,Movimiento,Valor):-
	Profundidad>0,
	nb_setval(tableroAB,Tablero),
	nb_getval(tableroAB,[[CabTablero,_]|ColaTablero]),
	buscarOpcion(Busqueda,CabTablero,[],D),
	last(ColaTablero,UltimaFicha),
	last(UltimaFicha,UltimoNumero),
	buscarOpcion(Busqueda,UltimoNumero,D,Posibilidad),
	Alpha1 is -Beta,
	Beta1 is -Alpha,
	NuevaProf is Profundidad - 1,
	movimiento(MaxMin,Posibilidad,Tablero,Ocultas,Mano,Busqueda,NuevaProf,Alpha1,Beta1,_,(Movimiento,Valor)),!.

%Metoso movimiento(i,i,i,i,i,i,i,i,i,i,o) que regresa el mejor movimiento
movimiento(_,[],_,_,_,_,_,Alpha,_,Ficha,(Ficha,Alpha)).

movimiento(MaxMin,[Ficha|Izq],Tablero,Ocultas,Mano,Busqueda,Profundidad,Alpha,Beta,Record,MejorMovimiento):-
	ponerFicha(Busqueda,Ficha,Tablero,NuevaMano,NuevoTablero),
	cambiarJugador(MaxMin,MaxMin2),
	ponerNuevaFicha(Ficha,Izq,MaxMin2,NuevoTablero,Profundidad,Ocultas,Mano,NuevaMano,Alpha,Beta,Record,MejorMovimiento,_),!.

%Metodo ponerFichaNueva que ve de que lado poner la ficha
ponerNuevaFicha(Ficha,Izq,1,Tablero,Profundidad,_,Mano,NuevaMano,Alpha,Beta,Record,MejorMovimiento,Valor):-
	alphabeta(Tablero,Profundidad,NuevaMano,Mano,Mano,1,Alpha,Beta,MejorMovimiento,Valor),
	Valor1 is -Valor,
	poda(1,Ficha,Valor1,Profundidad,Alpha,Beta,Izq,Tablero,NuevaMano,Mano,Mano,Record,MejorMovimiento).

ponerNuevaFicha(Ficha,Izq,-1,Tablero,Profundidad,Ocultas,_,NuevaMano,Alpha,Beta,Record,MejorMovimiento,Valor):-
	alphabeta(Tablero,Profundidad,Ocultas,NuevaMano,Ocultas,-1,Alpha,Beta,MejorMovimiento,Valor),
	Valor1 is -Valor,
	poda(-1,Ficha,Valor1,Profundidad,Alpha,Beta,Izq,Tablero,Ocultas,NuevaMano,Ocultas,Record,MejorMovimiento).

%Metodo poda que realiza la poda del arbol
poda(_,Ficha,Valor,_,_,Beta,_,_,_,_,_,_,(Ficha,Valor)):-
	Valor >= Beta, !.

poda(MaxMin,Ficha,Valor,Profundidad,Alpha,Beta,Izq,Tablero,Ocultas,Mano,Busqueda,_,MejorMovimiento):-
	Alpha < Valor, Valor < Beta, !,
	movimiento(MaxMin,Izq,Tablero,Ocultas,Mano,Busqueda,Profundidad,Valor,Beta,Ficha,MejorMovimiento).

poda(MaxMin,_,Valor,Profundidad,Alpha,Beta,Izq,Tablero,Ocultas,Mano,Busqueda,Record,MejorMovimiento):-
	Valor =< Alpha, !,
	movimiento(MaxMin,Izq,Tablero,Ocultas,Mano,Busqueda,Profundidad,Alpha,Beta,Record,MejorMovimiento).

cambiarJugador(1,-1).
cambiarJugador(-1,1).

%=====================================================
%              Metodos generales
%=====================================================

%Metodo buscarOpcion(i,i,i,o) se usa para buscar valores iguales a la cabeza o cola
buscarOpcion([],_,PF,PF):- !.

buscarOpcion([[CabTablero|ColaCab]|ColaTablero],NumFicha,Conjunto,PF):-
	((CabTablero =:= NumFicha; ColaCab =:= NumFicha),
	union(Conjunto,[[CabTablero|ColaCab]],NuevoConjunto),
        buscarOpcion(ColaTablero,NumFicha,NuevoConjunto,PF));
	buscarOpcion(ColaTablero,NumFicha,Conjunto,PF).

%Metodo eliminarFicha(i,i,o) se usa para quitar una ficha de la mano o de las ocultas
eliminarFicha(Ficha,Lista1,Lista):-
	(cabeza(Ficha,CabFicha),
	last(Ficha,ColaFicha),
	ColaFicha<CabFicha,
	%delete(Lista1,[ColaFicha,CabFicha],Lista),!);
	delete(Lista1,Ficha,Lista),!);
	delete(Lista1,Ficha,Lista).

%Metodo eliminarLista(i,i,o) es similar a eliminar una lista, pero paso a paso.
eliminarLista([CabLista|ColaLista],Lista,NuevaLista):-
	eliminarFicha(CabLista,Lista,ListaAuxiliar),
	eliminarLista(ColaLista,ListaAuxiliar,NuevaLista).

eliminarLista([],Lista,Lista):-!.

%Metodo cabeza(i,o) unicamente regresa la cabeza de una lista
cabeza([Cab|_],Cab).

%Metodo relacionDeMulas(i,o) cuenta las mulas
relacionDeMulas(Mano,Res):-
	mulas(Mano,Contadas),
	Contadas>=2,
	Res is -1;
	Res is 1.

%Metodo mulas(i,o) revisa las mulas en una lista
mulas([CabIn|ColaIn],[CabRes|ColaRes]):-
	esMula(CabIn,EsMula),
	CabRes is 0+EsMula,
	mulas(ColaIn,ColaRes).

mulas([],[]):-!.

%Metodo esMula(i,o) revisa si una ficha es mula
esMula([Cabeza|Cola],Res):-
	esMulaCola(Cola,NumCola),
	Cabeza=:=NumCola,
	Res is 1;
	Res is 0.

esMulaCola([Cabeza|_],NumCola):-
	NumCola is Cabeza.

%Metodo relacion(i,i,o) metodo que ayuda para la funcion heuristica calculando el mayor numero y el numero con mayor repeticiones
relacion(Contar,Mayor,Relacion):-
	Contar/Mayor > 2,
	Relacion is -1;
	Contar/Mayor =< 2,
	Relacion is 1.

%Metodo repetidos(i,o) Revisa las repetidas de numeros y regresa la relacion
repetidos(Mano,Repetidos):-
	Num is 0,
	contarNum(Mano,Num,Arr),
	numRepetidos(Arr,Mayor),
	tamano(Mano,Contar),
	relacion(Contar,Mayor,Repetidos).

%Metodo tamanio(i,o) regresa el tamano de una lista
tamano([_|Cola],Contar):-
	tamano(Cola,ContarAux),
	Contar is ContarAux+1.

tamano([],Contar):-
	Contar is 0,!.

%Metodo numRepetidos(i,o) regresa la cantidad de repetidos
numRepetidos([Cabeza|Cola],Mayor):-
	numRepetidosAux(Mayor,Cabeza,Cola).

numRepetidosAux(Num,Comparable,[Cabeza|Cola]):-
	Cabeza>=Comparable,!,
	numRepetidosAux(Num,Cabeza,Cola);
	Cabeza<Comparable,
	numRepetidosAux(Cabeza,Comparable,Cola).

numRepetidosAux(Mayor,Mayor,[]):-!.

%Metodo contarNum, revisa las repeticiones de un numero, mula cuenta como uno
contarNum(Mano,Num,Frecuencia):-
	Num=:=7,Frecuencia=[];
	suma(Mano,Num,Suma),
	NumAux is Num+1,
	contarNum(Mano,NumAux,Cola),
	Frecuencia=[Suma|Cola].

%Metodo suma(i,i,o)
suma([Cabeza|Cola],Num,Contados):-
	suma(Cola,Num,ContadosAux),
	verificar(Cabeza,Num),
	Contados is ContadosAux+1;
	suma(Cola,Num,ContadosAux),
	Contados is ContadosAux.

suma([],_,Contados):-
	Contados is 0.

%Metodo verificar(i,o) revisa si el numero es igual a la cabeza de una ficha
verificar([Cabeza|Cola],Num):-
	Cabeza=:=Num;
	verificarAux(Cola,Num).

verificarAux([Cabeza|_],Num):-
	Cabeza=:=Num.

sumaFicha([CabFicha|ColaFicha],Res):-
	Res is CabFicha+ColaFicha.

sumaLista([],[]):-!.

sumaLista([Cab|Cola],Res):-
	sumaFicha(Cab,CabRes),
	sumaLista(Cola,ColaRes),
	Res is [CabRes|ColaRes].




