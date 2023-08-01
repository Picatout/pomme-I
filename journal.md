### 2023-08-01

* Ajouter la function BASIC **CHAT(y,x)** pour obtenir le caractère à la position ligne,colonne.
* Modifier routine *let_string* pour permettre var$(expr)=\letter et var$(expr)=expr

* Modifié routine *readln* du fichier [terminal.asm](terminal.asm) 
    * **CTRL+L** pour passer en mode lower/upper case.
    * **CTRL+U** pour passer en mode upper case seulement. 
    * **FLÈCHE GAUCHE** permet de déplacer le curseur vers la gauche.
    * **FLÈCHE DROITE** permet de déplacer le curseur vers la droite.

Les mouvements gauche droite du curseur permettent de modifier un caractère à l'intérieur de la ligne sans avaoir à effacer la fin de ligne.


### 2023-07-22

* Corrigé bogue dans décompilateur, le guillemet de droite des chaînes était manquant.

* Ajout du programme BASIC [rnd.walk.bas](BASIC/rnd.walk.bas).

### 2023-07-21

* Ajout de la commande **LOCATE ligne, colonne** pour positionner le curseur. 

* Retravailler le décompilateur pour supprimer les espaces inutiles entre les unités lexicales.

* Ajouter un message de copyright au moniteur.

* Ajout de démos dans dossier BASIC.

### 2023-07-20 

* Corrigé bogue dans routine *search_free*. 

* Bogue de la commande **AUTO** réparé.

* Ajout de la commande **CTRL_D** à la routine *readln* pour désactiver la commande **AUTO**.

* Corrigé bogue dans routine *next_file*, comparaison avec la signature **ERASED** était erronnée.

* Corrigé bogue dans routine *basic_load_file*. Ne testait pas la valeur de A avant de faire **jrne**. 

* Corrigé bogue dans [files.asm](files.asm)  la constante ERASED était mal définie.

* Ajout de la commande BASIC **CLS** pour envoyer une commande d'effacement d'écran au terminal.

* Corrigé bogue dans la fonction **SGN** 

* Ajouter l'option "fichier" à la commande **RUN** pour charger et exécuter un programme en une seule commande.

### 2023-07-19

* Corrigé bogue dans la commande **RUN** qui ne vérifiait pas s'il y avait un programme en mémoire avant de lancer l'exécution.

* Assemblage du POMME I dans son boitier complété. 

![assemblage dans boitier](docs/pomme-I_intérieur-boitier.jpg)


### 2023-07-17

* Modification au fichier [terminal.asm](terminal.asm) pour que POMME-I puisse fonctionner avec [STM8_terminal] qui ne reconnaît pas les séquence de contrôle ANSI. 
    * Réduire la vitesse du UART à 38400 BAUD 
    * Écriture d'une version simplifiée de la routine **readln**.

### 2023-07-12

* Révision des routines *let_string* et *get_string_slice*. 

### 2023-07-11 

* Corrigé bogue dans routine *get_string_slice*. Lors d'une affectation à une chaîne si l'indice dépasse la longueur de la chaîne de 1 cette 
valeur doit-être acceptée pour effectuer une concaténation.

* Modification au readme.md 

* Corrigé bogue dans routine *set_seed* du  fichier [p1Kernel.asm](p1Kernel.asm). 
 
* Travail sur [files.asm](files.asm). Ajout des commandes  
    * "SAVE "file name" 
    * "LOAD "file name" 
    * "ERASE "file name" || \F 
    * "DIR" 

Les fichiers sont sauvegardés dans la mémoire SPI EEPROM 25LC1024 de 128KO. La taille de l'unité d'allocation des fichiers étant de 256 octets un maximum de 512 fichiers peuvent-être sauvegardés et un minimum de 21 à supposé que chacun de ses programme occupe toute la mémoire RAM disponible (5504 octests),


* Corrigé bogue dans *and_factor*. 

* Ajout de la fonction **KEY**.

* Ajout de la commande **BYE**. 

### 2023-07-09

* Travail sur [spi.asm](spi.asm).

### 2023-07-08

* Travail sur [spi.asm](spi.asm).

### 2023-07-06

* Modification du compilateur pour vérifier que l'appariement des parenthèse. Signale une erreur de syntaxe lorsque les parenthèses ne sont pas apparriées.

### 2023-07-05

* Modification du circuit du terminal pour ajouter des commuateurs externes pour les  options utilisateur.

### 2023-06-27 

* Réécriture de la commande **INPUT** 

* Ajout des commandes **STOP** et **CON**.

* Modifié code pour afficher l'erreur **END ERROR**  si le programme se termine autrement que par un **END**. 

* Modifié la routine *readln* pour accepter les lettres minuscules par **CTRL+L**  

* Ajouter le code pour limiter le niveau d'imbrication des **FOR...NEXT** et **GOSUB...RETURN** à 8 niveaux.

* Ajouter code pour les erreurs d'overflow et de division par zéro dans [arithm16.asm](arithm16.asm).

* Modifié routine *atoi16* pour accepter les nombres hexadécimal débutant par le caractère ASCII **$**. 

* Modifier le compilateur pour permettre la saisie des entiers en format hexadécimal. Le caractère **$** sert à indiquer le format hexadécimal.

* Modifié la commande **CALL** afin d'offrir la possibilité de passer un paramètre à la fonction appellée dans le registre **X**.
    * **CALL expr1 [, expr2] ** 
    * **expr1** est l'adresse de la fonction.
    * **expr2** est le paramètre optionnel.

### 2023-06-26

* Corrigé bogue dans **SLEEP** qui n'utilisait pas la bonne consstante. Suppression de la constante **FTIMER** dans app_macros.inc 

* Corrigé bogue dans routine *relation*. 

* Dessiné schématique de l'ordinateur **pomme-I**.


* Moidifié la valeur de **free_ram** à 0x100 plutôt que 0x200. 

### 2023-06-25

* Déboguage du code de gestion des chaînes de caractères.

* Modifié *let_var_adr* pour gérer les variables scalaire de la forme var(1).

* Corrigé bogue dans *get_array_adr* qui rapporte maintenant l'adresse des variables scalaire comme si c'était var(1). Modificaition à *factor*.


* Modifié la routine *ctrl_c_stop*, maintenant affiche un message et saute à *cmd_line* sans passer par *warm_init*.

* Modifié commande **GOTO** pour lancer un programme à une ligne spécifiée à partr de la ligne de commande.

* Travail sur les chaînes. Débogué routine *let_string*.

### 2023-06-24

* Travail sur les chaînes.

* Ajout du type **\char**. 

* Modification de la commande **WORDS**. 

### 2023-06-23

* Ajout code dans la commande **PRINT** pour imprimer les variables chaînes complète. Le code doit-être complété pour l'impession des sous-chaîne.

* Déboguer fonction **RND**. 

* Ajouter les fonctions **TICKS**,**SLEEP** et **CHR$**  

* Ajouter commandes **TONE** et **WORDS**.

* Implémentation de la commande  **INPUT** pour les entiers. 

### 2023-06-22

* Implémenté  **LOMEM** et **HIMEM**. 

* Modifié commande **RUN** pour accepté paramètre no de ligne. 

* Implémentation de la commande **DEL**.

* Implémentation de la commande **AUTO**. 

* Corrigé bogue dans routine *search_var*.

* Modfiication du compilateur pour ajouter un contrôle de la syntaxe sur les structure **FOR...NEXT** et **IF...THEN**.

* Implémentation de la commande **CLR** .

### 2023-06-21

* Débogué **DIM**. 

* Modifié code pour accepter **LET** implicit.

* Débogué boucles FOR...NEXT 

* Pour une raison non élucidée les variables définies dans [arithm16.asm](arithm16.asm) étaient déplacée dans la mémoire flash par le linker. Le problème est résolu en assemblant [arithm16.asm](arithm16.asm) après [p1Kernal.asm](p1Kernel.asm). Pour ce faire j'ai du extraire les macros de [arithm16.asm](arithm16.asm) pour les mettre dans le fichier [arithm16_macros.inc](arithm16_macros.inc) pour qu'elles soient déjà définie lorsque [p1Kernal.asm](p1Kernel.asm) est assemblé.

### 2023-06-20

* Travail sur l'allocation des variables. 

* Continuation du travail sur [p1BASIC](p1Basic.asm).

* Découvert et corrigé bogue dans le moniteur. lorsqu'on demandait d'afficher l'adresse **FFFF** il le programme poursuivait à l'adresse zéro. J'ai ajouter une vérification pour arrêter lorque la valeur du registre **X** revient à **0** après un incrément.
```
PRDATA:
    ld a,#SPACE 
    call putc
    ld a,(x)
    call PRBYTE
    incw x
    jreq TONEXTITEM ; ajouter pour corrigé le bogue rollover 
XAMNEXT:
    cpw x,LAST 
    jrugt TONEXTITEM
```

* Puisque dans le BASIC du Apple I la valeur de la variable **A** est la même que la valeur de la variable tableau **A(1)** j'ai modifier la façon dont fonctionne la gestion des variables.  J'ai créer un **heap** qui début sous le **tib** et va en décroissant. L'espace pour les chaînes et les tableau est 
réservé sur le **heap**  en allant vers le début de la mémoire. La variable système **heap_free** pointe sur l'adresse du de la dernière allocation. 
Les variables scalaires sont enregistrées à partir de la fin du programme en allant vers **heap_free** lorsque la valeur du pointeur **dvar_end** croise la valeur de **heap_free** ça signifie que la mémoire est pleine. Les variables scalaire occupe toujours 4 octets. 

* **nom de la variable** 2 octets, si le bit 7 du premier caratère est à **1** Il s'agit d'un tableau ou d'une chaîne. Dans ce cas les 2 octets qui suivent indique l'adresse de la chaîne ou du tableau sur le **heap**. 

* **Valeur**  Si le bit 7 du premier caratère est à **0** il s'agit d'une variable entière scalaire et les 2 octets qui suvient le nom corresponde à la valeur assignée à cette variable. 

### 2023-06-19

* Déboguage  *kword_let* , *get_var_addr*, etc. 

* Travail sur [p1BASIC](p1Basic.asm).

### 2023-06-18

* Réorganisation du code et travail sur [p1Kernle.asm](p1Kernal.asm).

* Test du noyeau avec le programme [ktest.asm](ktest.asm)


### 2023-06-16

* Nettoyage du [p1BASIC](p1Basic.asm) pour supprimé le support des étiquettes cible pour les **GOTO**, **GOSUB**. 

### 2023-06-15

* Remplacement de [arthim24.asm](arithm24.asm) par [arithm16.asm](arithm16.asm) et adaptations nécessaires.

### 2023-06-14 

* Commencé la modification en renommant  le fichier tinyBasic.asm en [p1Basic.asm](p1Basic.asm).

* Suppression des commandes et fonctions non pertimentes.

* Copié les fichiers source du projet [STM8_tbi](https://github.com/Picatout/stm8_tbi) dans le dossier pomme-I

### 2023-06-13 

* Le projet change de direction. Je vais construire un ordinateur en bois ressemblant au Apple I. Le boitier contiendra 3 modules.
    * Un alimentation linéaire de 5V/1A 
    * Une carte terminal gérant un clavier PS/2 ainsi qu'une sortie vidéo VGA  monochrome pouvant afficher 25 lignes de 40 caractères. 
    * Finalement la carte mère sera une carte NUCLÉO-8S208RB. Je remplace la carte NUCLEO-8S207K8 qui n'a pas de sortie SPI. Ainsi je pourrai aumenter la mérmoire RAM en utilisant une mémoire RAM SPI et en implétant un MMU (Memory Management Unit) en software. 


### 2023-06-11

* Travail sur [stm8_WozBASIC.asm](stm8_WozBASIC.asm)

* Modifié *getline* pour accepter  **CTRL_D** qui désactive **F_AUTO**.

* Un **jp** ou **call** ver l'adresse 0 réinitialise le MCU.

### 2023-06-10

* Lecture et annotation du fichier [a1basic.asm](Apple-1-refs/a1basic-master/a1basic.asm).
### 2023-06-09 

* Création du projet 

* Travail sur [tinyKernel.asm](tinyKernel.asm) et [termios.asm](termios.asm). 

* Dans [stm8_wozmon.asm](stm8_wozmon.asm) supprimé la sous-routine **ECHO** et remplacé celle-ci par **putchar** de [termios.asm](termios.asm). Aussi dans la section **BACKSPACE** supprimé du code pour le remplacé par un appel à la routine **delback**. 

