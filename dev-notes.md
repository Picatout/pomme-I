### TinyKernel et termios 

J'ai pris la décision de créer un [mini noyau](tinyKernel.asm) pour permettre l'accès aux fonctions du [terminal](termios.asm) via un system call **(TRAP)**. Ceci afin de permettre aux programmes qui seront chargés dynamiquement d'avoir accès à ces fonctions sans avoir à connaître l'adresse des routines. Ces fonctions seront accesssible via le code machine  **TRAP** qui est une interruption logicielle. L'interface des **syscall** sera évidemment documentée.

La deuxième décision que j'ai prise est de modifier le **Wozmon** pour qu'il utilise les fonctions du [terminal](termios.asm). Ainsi la sous-routine 
**ECHO** du **Wozmon**  sera remplacée par la routine **putchar** le BASIC utilisera aussi les fonctions du **termios**. De même lorsque le **Wozmon** 
fait une lecture du clavier le code sera modifié pour faire un appel a **getchar**. Je peux me permettre de faire
ces changements car je ne suis pas limité par la taille de la mémoire comme l'était Steve Wozniak.

###  Fréquence du cpu
La troisième décision est d'utiliser l'oscillateur interne HSI du STM8S207K8 à sa fréquence maximale de 16Mhz comme **Fmaster** et le UART sera configuré à **115200 BAUD 8N1.**  L'initialisation du UART sera transférée dans [terminal](termios.asm).

##  Clavier du Apple I et jeu de caractères

Le Apple I utilisait un jeu de caractères qui lui était unique situé dans la plage de code {128..223 (0x80..0xdf)}. Il s'agit de 2 transpositions du jeu de caractères ASCII {0..127 (0x00..0x7f)}. 

1. Pour les codes qui se trouve normalement dans la plage ASCII {96..127 (0x60..0x7f)} le bit 5 était forcé à **0** les transposants dans la plage {64..96 (0x40..0x5f)}. Limitant la plage dans l'intervalle {0..95 (0x00..0x5f)}. Donc Apple I n'utilisait que des lettres majuscules. 

1. Le bit 7 était forcé à **1** forçant la transposition des caractères   **{0..95 (0x00..0x5f)}** vers **{128..223 (0x80..0xdf)}**.

Pour cette raison dans le fichier [a1basic.asm](Apple-1-refs/a1basic-master/a1basic.asm) Eric Smith utilise ASCII+$80 pour comparer le charactère lu avec un charactère ASCII.  Ainsi l'espace (ASCII 0x20) devient:
```
Se011:	lda	#' '+$80
		sta	p2
		jmp	cout
```

Quatrième décision, Je vais m'en tenir au jeu de code ASCII. Le BASIC se chargera lui-même de transposer les lettres minuscules en majuscules comme je l'ai fait pour le Wozmon:
```
NEXTCHAR:
    call getchar 
    cp a,#BS  
    jreq BACKSPACE 
    cp a,#ESC 
    jreq GETLINE ; rejected characters cancel input, start over  
    cp a,#'` 
    jrmi UPPER ; already uppercase 
; uppercase character
; all characters from 0x60..0x7f 
; are folded to 0x40..0x5f     
    and a,#0XDF  
UPPER: ; there is no lower case letter in buffer 
```

### fonction getline

Le BASIC va utilisé la fonction **getline** de [termios.asm](termios.asm). **getline** ne transpose aucun caractère et contrairement au WozBASIC originial la ligne est terminée par un caractère ASCII **NUL** (0x00) plutôt que par un soulignement transposé (0xdf). Ce caractère transposé correspond en fait au caractère ASCII **DEL** 127 (0x7f). 

Dans WozBASIC le caractère ASCII **DEL** tranposé à 0xdf était utilisé pour effacer le dernier caractère saisi. Dans ma version c'est le caractère ASCII **BS** *back space* (ASCII 8) qui joue le rôle de caractère d'effacement. 

Comme dans Wozmon et WozBASIC le caractère ASCII **ESC** { 27 (0x1b) }, transposé en (0x9b) dans Apple I, est utilisé pour annuler la saisie d'une ligne de texte et a pour effet de retourner une ligne vide.

## studying a1basic.asm 

* Basic entry point label **cold:** 
    * call **mem_init_4k:**, which initialize **lomem** and **himem**, start and end of RAM reserved for BASIC program code. 
    * **mem_init_4k** jump to **new_cmd:** 
    * **new_cmd:**  lsr **auto_flag** variable (clear), and initialize **pp** variable with **himem** then fallthrough **clr_cmd:** subroutine.
    * **clr_cmd:** initialize **pv** with **lomem** and clear **for_nest_count**, **gosub_nest_count**, **synpag** and **Z1d** then return.

* Now at **warm:** 
    * **warm** call **crout**  to print a carriage return 
    * lsr **run_flag**  (clear?)
    * print a **'>'** character as a prompt
    * clear **leadzr** variable 
    * check for **auto_flag** if negative it means automatic line number is active. If so variable **aut_ln** is loaded in X:A and routine 
      **prdec** is called. After what a space is printed.
    * The stack is the initialize at **0x1ff** and a call to **readline** is done. 
    
###  pp and pv 

    * **pp**  pointer to program  initialized at code.end  
    * **pv**  pointer to variables intialized at code.start  
    

### boolean flags 

Apple I integer BASIC utilise 4 indicateurs booléens et chacun utilise une variable octet. Le STM8 grâce à son jeu d'instructions qui permet de manipuler les bits dans un octet me permet d'utiliser 1 seul octet pour les 4 indicateurs **basic.flags** :
    * **F_AUTO** numérotation de ligne automatique 
    * **F_RUN**  programme en cours d'exécution 
    * **F_IF**   déclaration **IF** en cours d'évaluation 
    * **F_CR**   indique si la commande PRINT doit se terminer par CR  
    

<hr>

##  Nouvelle structure

### variables du système BASIC 

*  **lomem**  pointeur indiquant l'adresse du début de l'espace réservé pour les programmes BASIC 
*  **himem**  pointeur iniquant la limite réservé pour les programmes BASIC, i.e. [lomem...himem[
*  **progend** pointeur indiquant la limite actuelle du code BASIC. 
*  **dvar_bgn** pointeur indiquant le début des variables BASIC
* **dvar_end** pointeur indiquant la limite actuelle des variables BASIC, i.e. [dvar_bgn...dvar_end[.  
* **heap_free** pointeur indiquant la dernière addresse allouée sur le **heap**. 

### Allocation des variables BASIC. 

* Les noms de variables sont de 1 ou 2 caractères ASCII. 
    * les noms variables d'entier ou de tableau d'entiers on la forme **LETTER[chiffre]**. S'il s'agit d'un tableau d,entier le bit **7** du premier caractère est mit à **1**. C'est pratique car ce bit n'est pas utilisé par le code ASCII. 

    * Les noms de variables chaînes ont la forme **lettre**'$'.  Le bit 7 de la lettre est toujours à **1**. 

    * Le bit **7** de la lettre du nom de variable est utilisé comme indicateur pour indiqué que le champ donné de la variable est un pointeur vers le **heap** où est réservé l'espace de donné pour cette variable. Si ce bit est à **1** Il s'agit d'un pointeur sinon il s'agit d'une variable scalaire entière dont les 2 octets suivant le nom corresponde à la valeur de cette variable. Ce **heap** n'est pas dynamique une fois que de l'espace pour une variabl y a été alloué cette allocation persiste pour la duré du programme. 

Le pointeur **heap_free** indique l'adresse du **tib** lorsqu'aucun espace n'a été réservé et cette addresse va décroissasnt vers **lomem** lors que de l'espace est allouée. 

Le pointeur **dvar_end** est à la même adresse que **prog_end** lorsqu'aucune variablle n'a étée créée et va croissant vers **himem** à chaque création d'une variable. 

### Lecture et modification d'une variable scalaire

Lorsqu'une valeur scalaire doit-être est lue ou modifiée le bit **7** de son nom est vérifié. si se bit est à **0** le champ donnée de la variable suit directement le nom. Par contre si le bit **7** est à **1** le champ donnée de la variable est indiquée par le pointeur qui suit le nom incrémenté de 2. 
En effet lorsque de l'espace est réservé pour un tableau sur le **heap** un entier de plus que la taille indiqué dans la commande **DIM** est réservé. Par exemple si on déclare **DIM A4(20)** 22 octets seront réservés sur le **heap** en plus des 4 réservés à l'adresse **dvar_end**. Donc après la création de cette variable l'adresse indiquée par **dvar_end** sera incrémentée de 4 et celle indiquée par **heap_free** sera décrémentée de 22 octets. 
Cet entier indique la taille du tableau. Donc la donnée d'indice **(1)** correspond à la deuxième position. Cet arrangement fait en sorte que la valeur de A=A(1) comme indiqué dans le [manuel du Apple I BASIC](Apple-1-refs/apple1_basic_manual.pdf).

### Lecture et modification d'une chaîne de caractère. 

Pour les chaînes de caractères puisqu'elles ont une longueur maximale de 255 caractères 1 seul octet est réservé au début de l'espace allouée sur le **heap** donc le permier caractère de la chaîne correspond au deuxième octet. Mais les chaînes se terminent par un **0**  donc il faut comme pour les tableaux d'entiers réserver 2 octets de plus que la valeur indiquée par la déclaration **DIM**. Par exemple si on déclare **DIM A$(10)** 12 octets seront réservés sur le **heap** en plus des 4 octets réservés à la position **dvar_end** pour un total de 16 octets.  Donc après cette déclaration l'adresse indiquée par **dvar_end** sera augmentée de 4 et celle indiquée par **heap_free** sera diminuée de 12. le caractère **A$(1)** correspond au 2ième octet de l'espace réservée pour cette chaîne sur le **heap**. 
