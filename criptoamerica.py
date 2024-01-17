# -*- coding: utf-8 -*-
"""
Created on Sat Apr 22 19:54:37 2023

@author: user
"""

# Criptoaritmética
def casoResLargo(diccionarioPal,diccionarioLetras):
    diccionarioLetras[diccionarioPal['res'][0]][0]=1
    print(diccionarioLetras)
  
def acomodaDiccionario(diccionarioLetras,maxRep,claveMax):
    print(diccionarioLetras)
    diccionarioAux={}
    it=0
    while len(diccionarioLetras)>0:
        print('iteracion '+str(it)+': \n'+str(diccionarioLetras))
        for k,v in diccionarioLetras.items():
            if v[1]>=maxRep:
                claveMax=k
                maxRep=v[1]
        it+=1
        diccionarioAux[claveMax]=diccionarioLetras.pop(claveMax)
    print('Elementos en diccionarioLetras: '+str(len(diccionarioLetras)))
    print(diccionarioAux)
    while len(diccionarioAux)>0:
        obj=diccionarioAux.popitem()
        diccionarioLetras[obj[0]]=obj[1]
    print(diccionarioLetras)
    return diccionarioLetras

def casoSuma(diccionarioPal):
    lp1=len(diccionarioPal['sum1'])
    lp2=len(diccionarioPal['sum2'])
    lr=len(diccionarioPal['res'])
    if lr>max(lp1,lp2)+1:
        raise Exception('Esta suma no es valida.')
    diccionarioLetras={}
    for valor in diccionarioPal.values():
        for a in range(len(valor)):
            diccionarioLetras[valor[a]]=[None,0,0]
    maxRep=0
    for valor in diccionarioPal.values():
        for a in range(len(valor)):
            diccionarioLetras[valor[a]][1]+=1
            if diccionarioLetras[valor[a]][1]>maxRep:
                maxRep=diccionarioLetras[valor[a]][1]
                claveMax=valor[a]
    if len(diccionarioLetras)>10:
        raise Exception('Hay más letras que dígitos, tendría que haber repeticiones.')
    diccionarioLetras=acomodaDiccionario(diccionarioLetras, maxRep, claveMax)
    if lr==max(lp1,lp2)+1:
        casoResLargo(diccionarioPal,diccionarioLetras)

pal1='SEND'
pal2='MORE'
resI='MONEY'
"""
print('Inserte la primer palabra: ')
pal1=input().upper().strip()
print('\nSegunda palabra: ')
pal2=input().upper().strip()
print('\nAhora inserte el resultado: ')
resI=input().upper().strip()
"""
print("\nSu ecuación queda:\n")
print(' '*len(resI)+pal1)
print('+'+' '*(len(resI)-1)+pal2)
print('-'*(len(resI)+max(len(pal1),len(pal2))))
print(' '*max(len(pal1),len(pal2))+resI+'\n')
palabras={'sum1':pal1,'sum2':pal2,'res':resI}
casoSuma(palabras)

