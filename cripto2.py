#==============================================================================
#Función analizaPalabras(pal1,pal2,palRes,dicc):
#==============================================================================
"""
La funcion analizaPalabras tiene la funcion (como sugiere su nombre) de verificar si la operacion es valida.
Es decir, que el tamaño de la palabra resultado sea igual o mayor solo por una letra al maximo tamaño de los sumandos.
Recibe las palabras y un diccionario el cual contiene todas las letras asociadas con una lista de todos los digitos.
Si no es valido imprime un mensaje y termina la ejecución.
Si es valido, continuamos guardamos en variables el tamaño de las palabras.
Dependiendo de las caracteristicas de la suma, podemos empezar a eliminar digitos.
Una vez eliminada la mayor cantidad de digitos posibles por letra llamamos a la funcion heuristica.
"""

def analizaPalabras(pal1,pal2,palRes,dicc):
  #Para facilitar su uso despues, ponemos en variables el tamaño de las palabras
  n1 = len(pal1) 
  n2 = len(pal2)
  nR = len(palRes)
  acc = False #Guardamos en una variable si hay hay un acarrero final para cuando chequemos la suma se cumpla este requerimiento también
  if nR == max(n1, n2) + 1 or nR == max(n1, n2): #Verificamos que la operacion sea valida
    #Restricción 1 (Si las letras de la 1era palabra y de el resultado son iguales y la 1era palabra es más grande que la 2da)
    if nR == n1 and n2 != n1:
      if pal1[0] != palRes[0]:
        dicc[pal1[0]] = [0,1,2,3,4,5,6,7,8]
        dicc[palRes[0]] = [1,2,3,4,5,6,7,8,9]
    #Restricción 2 (Si en una de las sumas parciales todas las letras son iguales)
    for d in range(min(n1,n2)):
      if pal1[d] == palRes[d] and pal2[d] == palRes[d]:
        dicc[palRes[d]] = [0,9]
    #Restricción 3 (Si 1 letra de la suma parcial es igual a la letra de el reultado y la otra no)
    for s in range(min(n1,n2)):
      if pal1[n1-(s+1)] == palRes[nR-(s+1)]:
        for k in dicc.keys():
          dicc[k] = [1,2,3,4,5,6,7,8,9]
        dicc[pal2[n2-(s+1)]] = [0,9]
      elif pal2[n2-(s+1)] == palRes[nR-(s+1)]:
        for k in dicc.keys():
          dicc[k] = [1,2,3,4,5,6,7,8,9]
        dicc[pal1[n1-(s+1)]] = [0,9]
    #Restricción 4 (Si el resultado contiene una letra mas que el maximo de los sumandos)
    if nR == max(n1, n2) + 1:
      for k in dicc.keys():
        dicc[k] = [0,2,3,4,5,6,7,8,9]
      dicc[palRes[0]] = [1]
      acc = True
    #Restricción 5 (Si el resultado es mas grande que el maximo de los sumandos y 1era palabra es mayor a 2da palabra)
    if nR == max(n1, n2) + 1 and n1 != n2:
      for t in dicc.keys():
        dicc[t] = [2,3,4,5,6,7,8]
      dicc[palRes[1]] = [0]
      dicc[palRes[0]] = [1]
      dicc[pal1[0]] = [9]
      acc = True
    #Llamada a funcion heuristica
    boole = heuristica(pal1,pal2,palRes,dicc,n1,n2,nR,acc)

  elif nR > max(n1,n2)+1:
    print('COMBINACION DE PALABRAS INVALIDAS') #Mensaje de error
    return False

#==============================================================================
#Función heuristica(pal1,pal2,palRes,dicc,n1,n2,nR,acc):
#==============================================================================
"""
La funcion heuristica hace uso de el diccionario para ir verificando posibles respuestas
que mandara a verificar si es respuesta. Utiliza el diccionario que se le paso para
ir creando posibles combianciones con la lista reestringida individual de cada letra.
Se crea un diccionario y una lista auxiliar para ir modificando estos elementos y asi
poder pasarlos a la llamada recursiva sin modificar los originales (utilizamos la función
copy()). Para verificar que las combinaciones puedan ser soluciones comprobamos que
todos los valores de las letras sean diferentes, que ninguna esta vacia y que contengan
un solo elemento. Si se cumple con estas restricciones se llama a la funcion analizaSuma
y en caso de si ser solucion se llama a imprimeSolucion.
"""

def heuristica(pal1,pal2,palRes,dicc,n1,n2,nR,acc):

  booly = False #Inicializamos variable booleana en falso que verifica si esa
  for k in dicc.keys(): #Para cada letra se empieza el proceso de eliminar
    backupDicc = dicc.copy() #Utilizamos copy() para que no se modifique el diccionario original
    lista = dicc[k] #La lista de el diccionario asociado a la letra guardada en lavariable "k"
    if len(lista) > 1: #Si la lista contiene mas de un elemento, hacer el proceso para todos los elementos
      backupList = lista.copy()
      for e in lista:
        if(len(backupList) > 0): #Para asegurar que no se añadan valores vacios
          backupDicc[k] = [e] #Asociamos solamente un valor de la lista a una letra
          backupList.remove(e) #Eliminamos ese valor de la lista
          for t in backupDicc.keys(): #Eliminamos ese valor de las posibilidades de otras letras
            if len(backupDicc[t]) > 1: #Siempre y cuando esa letra no contenga ya solo un valor
              backupDicc[t] = backupList
          heuristica(pal1,pal2,palRes,backupDicc,n1,n2,nR,acc) #Llamada recursiva con nueva lista y diccionario

  do = True #Variable booleana para ver si la combinacion de valores es valida para verificar si es solución
  tht = []
  for h in dicc.values():
    if len(h) > 1 or len(h) == 0: #Verificamos que cada letra tenga asociado solamente un valor
      do = False #Con que una sola letra no tenga asociado un solo valor nos detenemos y no buscamos si es solución
      break
    else:
      tht.append(h[0])
  if do and len(tht) == len(set(tht)): #Verificamos que todos los elementos sean diferentes
    booly = analizaSuma(pal1,pal2,palRes,dicc,n1,n2,nR,acc) #Mandamos a verificar la solución
    if booly: #En caso de si ser solución, la mandamos a imprimir
      imprimeSolucion(pal1,pal2,palRes,dicc)
  else:
    booly = False
  return booly

#==============================================================================
#Función analizaSuma(pal1,pal2,palRes,dicc,n1,n2,nR,acc):
#==============================================================================
"""
La heuristica, al encontrar una posible solución, llama a analizaSuma para verificarlo
Utilizamos un diccionario para ver que cada suma parcial sea cumpla
En caso de que la palabra 1 sea mayor a la palabra 2, agregamos un simbolo con valor 0 
para poder hacer la suma, se elimina despues. Si la variable acc es True tenemos que sumarle 1 
al valor donde empezamos sumar la palabra resultado. El chequeo correcto del acarreo se hace 
al final. Se crea un for loop para checar todas las sumas parciales, se checa 2 
posibilidades, de 2 posibilidades. Se dividen en 2 categorias: 

  Sí el valor de la palabra 1 en la posicion j mas el valor de la palabra 2 en la posicion j es 
  igual a el valor de la palabraresultado en la misma posicion sumando un +10 o +0

  O sí en la suma anterior hubo un acarreo, se hace la misma pregunta, pero sumandole "1" a la
  suma de valores de la palabra 1 y la palabra 2

Si en algun momento no se cumple una de las sumas parciales, la funcion regresa false, sin
checar las otras sumas. Si todo se cumple, la funcion regresa True, implicando que esta 
combinacion es una solucion para el problema.
"""

def analizaSuma(pal1,pal2,palRes,dicc,n1,n2,nR,acc):
  
  prueba = {} #Diccionario para cada suma parcial
  for i in range(max(n1,n2)):
    num = str(i)
    prueba["Suma " + num] = 0

  if n1 != n2: #Agregamos un elemento si la palabra 1 es mas grande que la palabra 2
    pal2 = '∞' + pal2
    dicc["∞"] = [0]

  #Si hay un acarreo, significa que la palabra resultado es mas grande que el maximo
  #de la palabra 1 o 2, por lo cual se tiene que empezar a sumar desde la posicion j+1
  if acc == True: 
    last = 1
  else:
    last = 0
  
  acarreo = False #En la primera suma nunca hay acarreo
  for j in range(max(n1,n2)-1, -1, -1): #Se empieza a checar las sumas parciales
    if dicc[pal1[j]][0] + dicc[pal2[j]][0] == dicc[palRes[j+last]][0] and acarreo == False:
      num2 = str(j)
      prueba["Suma " + num2] = 1
      acarreo = False
    elif dicc[pal1[j]][0] + dicc[pal2[j]][0] == dicc[palRes[j+last]][0] + 10 and acarreo == False:
      num2 = str(j)
      prueba["Suma " + num2] = 1
      acarreo = True
    elif dicc[pal1[j]][0] + dicc[pal2[j]][0] + 1 == dicc[palRes[j+last]][0] and acarreo == True:
      num2 = str(j)
      prueba["Suma " + num2] = 1
      acarreo = False
    elif dicc[pal1[j]][0] + dicc[pal2[j]][0] + 1 == dicc[palRes[j+last]][0] + 10 and acarreo == True:
      num2 = str(j)
      prueba["Suma " + num2] = 1
      acarreo = True
    else:
      return False

  if n1 != n2: #Se elimina el valor extra que agregamos
    del dicc["∞"]

  #Si existia un accareo en la operacion al final, pero no hubo en esta combinacion, no es una solución
  if acc == True and acarreo == False:
    return False

  return True

#==============================================================================
#Función imprimeSolucion(pal1,pal2,palRes,dicc):
#==============================================================================
"""
Si se encuentra una combinacion como solucion, la imprime en forma de suma y de los valores de las letras
Dependiendo de el tamaño de las palabras, agrega espacios y rayas para darle el formato adecuado
"""

def imprimeSolucion(pal1,pal2,palRes,dicc):
  print("La solucion queda:\n")
  print(dicc) #Imprime el diccionario que contiene la solucion
  print("\n")
  space = 0
  if(len(pal1) != len(pal2)): #El espacio cambia si hay diferencias entre la palabra 1 y la palabra 2
    space = len(pal1)
  strP1 = ' '*len(palRes)
  for char in pal1: 
    strP1 += str(dicc[char]) + ' '
  print(strP1) #Imprime palabra 1
  strP2 = '+' + ' '*space + ' '*((len(palRes))-1)
  for char in pal2:
    strP2 += str(dicc[char]) + ' '
  print(strP2) #Imprime palabra 2
  print('-'*(len(pal1)-1)*(len(palRes)+max(len(pal1),len(pal2)))) #Imprime la linea de
  strRes = ' '*space
  for char in palRes:
    strRes += str(dicc[char])+' '
  print(strRes+'\n') #Imprime palabra resultado



#""" #Preguntamos por las palabras
print('Ingrese la palabra 1')
palabra1=input().upper().strip()
print('Ingrese la palabra 2')
palabra2 = input().upper().strip()
print('Ingrese el resultado de la suma de palabras')
palabraRes = input().upper().strip()
"""
palabra1 = 'PLAYS'
palabra2 = 'WELL'
palabraRes = 'BETTER'
"""

print("\nSu ecuación queda:\n") #Imprimimos en formato de suma la operacion
print(' '*len(palabraRes)+palabra1)
print('+'+' '*(len(palabraRes)-1)+palabra2)
print('-'*(len(palabraRes)+max(len(palabra1),len(palabra2))))
print(' '*max(len(palabra1),len(palabra2))+palabraRes+'\n')

diccionario = {} #Creamos el diccionario con todos los digitos
for char in palabra1:
  diccionario[char] = [0,1,2,3,4,5,6,7,8,9]
for char in palabra2:
  diccionario[char] = [0,1,2,3,4,5,6,7,8,9]
for char in palabraRes:
  diccionario[char] = [0,1,2,3,4,5,6,7,8,9]

if len(palabra2) > len(palabra1): #En caso de que la palabra 2 sea mas larga a la palabra 2, las cambiamos
  palabraAux = palabra1
  palabra1 = palabra2
  palabra2 = palabraAux

boole = analizaPalabras(palabra1,palabra2,palabraRes,diccionario) #Llamamos a analizaPalabras
