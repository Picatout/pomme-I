# pomme I 

Après le projet [stm8_wozmon](https://github.com/picatout/stm8_wozmon) j'ai décidé de poursuivre sur ma lancé en traduisant le code source assembleur du **Integer BASIC** de Steve Wozniak dans le but de l'assembler pour la carte NUCLEO-8s207k8.  Une fois le projet complété on aura donc sur la carte **NUCLEO-8S207K8** le **Wozmon** et **l'Integer BASIC**. Cet ordinateur **pomme I** communiquera avec l'utilisateur via un émulateur de terminal sur le PC.



<hr>
J'ai trouvé sur [github](https://github.com) le projet [a1basic](https://github.com/brouhaha/a1basic/). Le code source est pour le 6502 et pour un assembleur différent de celui que j'utilise. Cependant je vais l'adapter pour le **STM8** et l'assembleur **sdasstm8**. 

Le dossier **Apple-1-refs** contient toutes les informations que j'ai rassemblé sur le **Apple I**  ainsi que le sous module du projet [a1basic](https://github.com/brouhaha/a1basic/) avec le fichier [a1basic.asm](Apple-1-refs/a1basic-master/a1basic.asm) que je vais utiliser comme référence pour mon adaptation. Même s'il s'agit d'une réécriture complète le code source ainsi que le programme tokenisé doit-être conforme à la version originale.

J'ai nommé le fichier principal de ce projet [stm8_WozBASIC.asm](stm8_WozBASIC.asm) en l'honneur de son créateur original. Steve Wozniak a créé ce programme de 4KO sans les outils modernes dont nous disposons, avec beaucoup de patience et de <s>compétence</s>, je veux dire débrouillardise.

Le nom que j'ai choisi pour ce projet révèle un certain penchant pour l'humour absurde. 

## 2023-07-19 

Le POMME I  est maintenant complété et installlé dans son boitier. 

 ![intérieur boitier](docs/pomme-I_intérieur-boitier.jpg)

Vue panneau arrière, une sortie 120VAC permet de brancher directement l'adapteur qui alimente le moniteur LCD. Cette sortie est commutée par le commutateur principal donc le moniteur s'allume et s'éteint avec l'ordinateur. 

Les commutateurs **ECHO** et **BAUD** ne sont pas utililisés dans cette application car l'ordaniteur POMME I  est préconfiguré à 115200 BAUD et sans écho locale.

![panneau arrière](docs/pomme-I_vue-arrière-sans-couvert.jpg)

Vue avant avec le mini clavier MCSaite. Ce clavier a été choisie pour sa petite taille et parce qu'il supporte aussi le protocole PS/2 en plus du protocole USB. 

![au démarrage](docs/pomme-I-éteint.jpg)

À l'allumage c'est l'application **POMME MONITOR** qui est active. Il s'agit d'un clone du WOZMON. Pour aller dans le **POMME BASIC** il faut faire **CTRL+B**. Sur cette photo on voie l'affichage de la commande  **WORDS** qui affiche les 50 mots réservés du BASIC. Le **POMME BASIC** est compatible avec le Apple I BASIC au niveau du code source mais comprends plus de commandes et fonctions. Les commandes **DIR**, **LOAD**, **SAVE** et **ERASE** permettent d'accéder les programmes sauvegardés dans une mémoire EEPROM externe au MCU.

![POMME BASIC](docs/pomme-I_cmd_WORDS.jpg)

La combinaison de touche **CTRL_X** permet de réinitialiser l'ordinateur. 

## 2023-07-17 

L'intégration du [STM8_terminal](https://github.com/Picatout/stm8_terminal) avec l'ordinateur **POMME-I** a nécessité des modifications aux 2 projets. Durant certaines opérations du terminal ce dernier perdait des caractères envoyés par l'ordinateur. Le problème a été corrigé par l'ajout d'un contrôle de flux matériel appellé **DTR** *(Data Terminal Ready)*. L'ordinateur n'envoie des caractères au terminal que lorsque ce signal est à **0** volt.

### Modification aux cartes NUCLEO-8S207K8 

Il y a sur les cartes NUCLEO-8S207K8 des *solder bridge* . Certains sont ouverts d'autre sont fermés avec des résistances de 0 ohm. Il faut en ouvrir certains et en fermer d'autres pour que les 2 cartes communiquent en utilisant leur UART respectif. Normalement le UART est branché au programmeur ST-LINK-V2 qui sur la face inférieur de la carte.

1.  Dessoudez les résistances sur **SB3** et **SB4**
1.  Fermez **SB7** et **SB9**. Pour ce faire vous pouvez utilisez les résistances enlevées à l'étape 1 ou simplement faire un pont avec de l'étain comme j'ai fait. 
1.  Si **SB5** est fermé il faut l'ouvrir sur la carte du terminal car celle-ci utilise un crystal externe. Car le pont **SB5** amène le singal **CCO** de 8Mhz en provenance du ST-LINK vers **OSCIN** ce qui entre en conflit avec l'installation du crystal.

### NOTE

La mémoire RAM 23LC1024 n'est pas utilisée dans cette première version du POMME-I mais elle doit néanmoins être installée pour que l'ordinateur réussisse son initialisation.

### Montage sur carte de prototypage

L'ordinateur et le terminal sont montés sur la même carte de 63 colonnes. Notez que les **OPTION SWITCHES** ne sont pas utilisées dans cette application du terminal. Mais un *jumper* doit-être installé entre les broches **D2** et **GND** du terminal. Ce *jumper*  est fournie et installé à l'achat de la carte. Ce *jumper* annulle l'option écho local. Sans lui les caractères saisis au clavier du terminal apparaîssent en double a l'écran. 

![pomme-I-board-assembly.png](docs/pomme-I-board-assembly.png)

## 2023-08-01
* Le vocubulaire s'est enrichie de 3 mots supplémentaires
    * **LOCATE ligne,colonne** pour positionner le curseur 
    * **CHAT(ligne,colonne)** pour obtenir le caractère à la position donnée 
    * **CLS** pour effacer l'écran 

* Il est maintenant possible de remplacer un charactère dans une chaîne en faisant:

**var$(expr)=CHR$(expr)**

sans affecter le reste de la chaîne.

* L'éditeur de ligne permet maintenant de se déplacer à l'intérieur de la ligne avec les flèches gauche et droite pour remplacer 1 ou plusieurs caractères sans avoir à effacer la fin de la ligne.


## 2023-07-11

La version 1.0 de POMME BASIC est maintenant complétée. Elle comprend 50 mots réservés.
```
>WORDS
ABS       AND       AUTO      BYE
CALL      CHR$      CLR       CON
DEL       DIM       DIR       END
FOR       ERASE     GOSUB     GOTO
HIMEM     IF        INPUT     KEY
LEN       LET       LIST      LOAD
LOMEM     MOD       NEXT      NEW
NOT       OR        PEEK      POKE
PRINT     REM       RETURN    RANDOMIZE
RND       RUN       SAVE      SCR
SGN       SLEEP     STEP      STOP
TAB       THEN      TICKS     TO
TONE      WORDS     
50  words in dictionary
```

Les programme BASIC sont sauvegardés dans une mémoire EEPROM externe de **128K** **25LC1024**. Les commandes de fichiers sont les suivantes:
    * __SAVE__ "file name"   pour sauvegarder un programme.
    * __LOAD__ "file name"   pour charger un fichier programme en mémoire RAM.
    * __ERASE__ "file name" || \F  pour effacer un fichier ou bien la mémoire EEPROM au complet avec l'option __\F__.
    * __DIR__    pour afficher la liste des programmes sauvegardés.

L'unité d'allocation de fichier étant de 256 octets, un maximum de 512 programmes peuvent-être sauvegardés et un minimum de 23 dépendant de la taille des programmes. Un fichier occupe un minimum de 1 secteur et un maximum de 22 secteurs. 

## 2023-06-14

Inclusion des fichiers du projet [STM8_tbi](https://github.com/Picatout/stm8_tbi) et début de la modification. inclusion du fichier [monitor.asm](monitor.asm). Maintenant le programme démarre dans le moniteur. On doit faire **CTRL+B** pour entrer dans le BASIC. la commande **BYE** réinitialise le MCU et donc revient au moniteur.

Maintenant reste à faire la modification du BASIC pour le rende conforme à Apple BASIC au niveau du code source. Aucune tentative de compatibilité au niveau des programmes *tonenizés* ne sera faite. 


## 2023-06-12 Spaghetti!! 

Après avoir passé quelques heures à essayer de comprendre le code source du fichier [a1basic](https://github.com/brouhaha/a1basic/) j'en suis venu à la conclusion qu'il m'en faudrait encore beaucoup plus pour le comprendre,  malgré les commentaires ajoutés par Eric Smith.  C'est du spaghetti ce code.

Il faut dire à la décharge de Woz que les outils et les contraintes de l'époque n'étaient pas les même que celles d'aujourd'hui. La mémoire coûtait cher et le Apple I n'en possédait que 4Ko. Mon interpréteur STM8 TinyBASIC nécessite plus de 8Ko. À l'époque le code spaghetti était coutumier. Question de sauver le plus d'octets possible les programmeurs faisaient toutes sortes de pirouettes, comme des sauts au milieu d'une sous-routine d'un point extérieur à la sous-routine, des *fallthrough* d'une routine à l'autre, etc. Saut avant, saut arrière à peu près n'importe où du moment qu'un morceau de code pouvait-être réutilisé. 

Un peu découragé par ce spaghetti, j'a pris une pause pour faire des recherches supplémentaires et voilà que je suis tombé sur un [article de Gizmodo](https://gizmodo.com/how-steve-wozniak-wrote-basic-for-the-original-apple-fr-1570573636) dans lequel Steve Wozniak lui-même explique sa totale ignorance des compilateurs. Il ne conaîssait que la première partie, celle qu'on apprend au tout début du cours sur les compilateurs, ç'est à dire la construction de  l'arbre syntaxique du langage. Pour le reste il a imaginé ses propres solutions. C'est pourquoi çi-haut j'ai rayé le mot *compétence* pour le remplacer par le mot débrouillardise.


J'ai donc décidé que le plus simple est de cloner [STM8_tbi](https://github.com/Picatout/stm8_tbi) et de le modifier en Apple BASIC. Apple BASIC utilise 
l'arithmétique sur entier de 16 bits alors que STM8_tbi utilise l'arithmétique sur entiers de 24 bits. Mais il y a déjà un fihcier [arithm16.asm](arithm16.asm) dans le projet [STM8_tbi](https://github.com/Picatout/stm8_tbi).





