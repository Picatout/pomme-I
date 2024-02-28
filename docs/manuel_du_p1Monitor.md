# p1Monitor 

Le moniteur du **POMME-I** est inspiré du **Wozmon**, c'est à dire le moniteur du Apple I créé par Steeve Wozniak en 1974. Ses fonctionnalités et son fonctionnement de base sont identique au **Wozmon** mais il comporte des ajouts. 

## Au démarrage 

Le moniteur est l'application qui est lancée automatiquement au démarrage du **POMME-I**. La version du moniteur est indiquée à la suite de la version du **firmware du noyau**. Ensuite s'affiche le symbole **#** pour indiquer que le moniteur est prêt à recevoir une commande.
```
pomme I version 1.3R0 Copyright Jacques Deschenes, (c) 2023,24
Fcpu= 16Mhz

pomme I monitor version 1.3R0  Jacques Deschenes (c) 2023,24

#
```

## Fonctions de bases 

D'abord il faut savoir que toutes les entrées et sorties numériques sont en hexadécimal. Il n'y a cependant aucun préfixe comme on le voit dans certains langages comme **h**, **0x** ou **$** pour indiquer qu'il s'agit d'entiers hexadécimaux. 

Pour connaître la valeur de l'octet à une adresse donnée il suffit d'entrer l'adresse suivit de la touche **ENTER**. 
```
#8000

8000: 82
#
```

Pour afficher le contenu d'une plage mémoire il faut indiquer l'adresse début et l'adresse fin de la plage séparées par un point. 8 octets sont affichés par ligne.
```
#6000.607F

6000: 9B AD 0C 25 19 CE 48 7E
6008: A3 55 AA 27 11 20 16 C6
6010: 80 00 A1 82 27 06 A1 AC
6018: 27 02 99 81 98 81 C6 48
6020: 00 A1 AA 26 09 5F 4F 4B
6028: 28 86 AC 00 80 00 AD 5A
6030: 72 10 50 C0 4F C7 50 C6
6038: B7 97 72 10 50 C1 AE 75
6040: 30 5A 27 10 72 03 50 C1
6048: F8 35 01 00 97 AE 8F 23
6050: BF 95 AD 47 72 18 50 03
6058: 72 1C 50 12 3F 8E A6 01
6060: B7 99 B7 9A CD 61 7A 72
6068: 06 00 8E 02 20 B7 35 56
6070: 50 62 35 AE 50 62 35 AE
6078: 50 64 35 56 50 64 A6 79
#
```

Pour modifier le contenu de la mémoire RAM, il faut indiquer l'adresse de début suivit d'un double point **:**. On peut indiquer plusieurs valeurs sur la même ligne de saisie, elles seront enregistrées à des adresses successives. Après le **ENTER** le moniteur affiche toujours le contenu original de l'adresse indiquée dans la commande.
```
#100: A6 9 AE 3C 80 83 81 

0100: 00
#100.107

0100: A6 09 AE 3C 80 83 81 00
#
```

Si un programme a été chargé en mémoire RAM et qu'on veut l'exécuter il faut saisir l'adresse d'entrée du programme suivit de la lettre **R**. On peut relancer le programme une autre fois simplement en tapant la lettre **R** suivit de **ENTER** car l'adresse est conservée. Cependant si cette adresse est modifiée par une autre commande elle devra être saisie à nouveau. Les programmes exécutés par cette commande doivent se terminer par une instruction machine **RET**, de code hexadécimal **81** de sorte qu'à la sortie on revient dans le moniteur.
```
0100: A6 09 AE 3C 80 83 81 00
#100R

0100: A6
15488 
pomme I monitor version 1.3R0  Jacques Deschenes (c) 2023,24

#R

15488 
pomme I monitor version 1.3R0  Jacques Deschenes (c) 2023,24

#
```

## Fonctions supplémentaires.

**CTRL+X** redémarre l'ordinateur. 

**CTRL+B** lance **p1BASIC**.
```
#
pomme BASIC version 1.2R0  Jacques Deschenes (c)2023,24
5504 bytes free
>

```
**CTRL+F** lance **p1Forth**.
```
#
p1Forth version 5.1R3  Jacques Deschenes (c) 2023,24

```

**p1BASIC** et **p1Forth** peuvent-être quittés avec **CTRL+X** ou bien la commande **BYE** ce qui a pour effet de redémarrer l'ordinateur.
