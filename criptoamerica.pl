% M�TODO PRINCIPAL QUE REALIZN LA SUMA
% Recibe las tres palabras que conforman la suma y llama a m�todos
% auxiliares para obtener los valores de las letras
/*
 * Caso base / caso �nico:
 * suma(i,i,i)
 * Recibe los dos sumandos y el resulatdo en forma de listas, cuyos
 * elementos son las letras en may�sculas
 *
 */

main(Factor1, Factor2, Resultado):-
  buscaLetras(Factor1, Factor2, Resultado, 0, 0, [0,1,2,3,4,5,6,7,8,9],_).

% M�TODOS QUE RECORREN TODA LA LISTA DE LETRAS Y BUSCAN LOS VALORES
% Recibe las listas de las palabras, el acarreamiento de las sumas, la
% lista de n�meros disponibles y reglesa la lista de letras disponibles


/*
 * Caso base (listas vac�as):
 * sumaAux(i,i,i,i,i,i,o)
 * Si las listas de los n�mero est�n vac�as, entonces se termina la
 * b�squeda, pues ya no hay letras sin valores asignados
 *
 */
buscaLetras([], [], [], Pasada, Pasada, Disponibles, Disponibles).

/*
 * Caso general:
 * sumaAux(i,i,i,i,i,i,o)    sumaAux(i,i,i,i,o,i,o)
 * Se toman los restangtes de cada lista y se hace una llamada recursiva
 * para obtener los valores acarreados y la lista de vlaores usados
 *
 */
%          i        i       i       i   o    i        o
buscaLetras([Cab1|Col1],[Cab2|Col2], [Cab3|Col3], Pasada1, Pasada, Disponibles, NumResultados):-
   buscaLetras( Col1, Col2, Col3, Pasada1, Pasada2, Disponibles, Nums2), %llamada recursiva a s� mismo para revisar la cola de las listas
   asignaVal( Cab1, Cab2, Pasada2, Cab3, Pasada, Nums2, NumResultados). %llamada al m�todo que le asignar� un valor a cada letra


% M�TODO QUE ASIGNA VALORES A LAS LETRAS
% Elimina los valores de la lista de valores disponibles en caso de que
% una letra ya tenga ese valor, o se lo asigna


/*
 * Caso �nico:
 * valores(i,i,i,i,o,i,o)
 * recibe las letras que se deben sumar y el valor acarreado de la suma,
 * y la lista de los valores a�n disponibles; regresa el siguiente
 * acarreado (para la siguiente suma) y la lista de valores ya asignados
 *
 */
asignaVal(Num1,Num2, Pasada1, Num3, Pasada, Disponibles, NumResultado)  :-
  checaVal( Num1, Disponibles, Letras),        % selecciona un valor para S1
  checaVal( Num2, Letras, Letras2),        % selecciona un valor para S2
  checaVal( Num3, Letras2, NumResultado),          % selecciona un valor para S3
  S  is Num1 + Num2 + Pasada1,   %Realiza la suma total de los valores
  Num3  is  S mod 10,                   % El valor de la letra en el resultado es el m�dulo de la suma
  Pasada  is  S // 10.                    % El nuevo acarreado es la divisi�n entera entre 10


% M�TODOS QUE ASIGNAN UN VALOR / QUITAN DE LA LISTA DE VALORES
/*
 * Caso base (la variable ya tiene un valor asignado):
 * quitaValores(i,i,o)
 * Si la variable ya tiene un valor, simplemente se realiza un corte
 */
checaVal( Var, Lista, Lista) :-
  nonvar(Var), !.

/*
 * Caso en el que se encuentre el valor
 * quitaValores(i,i,o)
 * Si no est� instanciada, entonces se busca un valor
 */
checaVal( Var, [Var|Cola], Cola). %Si no est� instanciada, entonces la quita de la lista de disponibles

/*
 * Caso en el que se busca el valor
 * quitaValores(i,i,o)
 * Se busca el valor de la lista y lo borra de los disponibles
 */

checaVal( Var, [Cab|Cola], [Cab|ColaRes])  :- %Buscar el valor de A en la lista para poder borrarlo y dejar los dem�s valores igual
  checaVal(Var, Cola, ColaRes).
