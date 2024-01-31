# Manuel du développeur pour l'ordinateur **pomme I**. 

## structure logicielle du pomme I 

    * [p1Kernel.asm](p1Kernel.asm), couche d'abstraction matérielle qui offre des fonctions système via un syscall, i.e. l'instructions machine **TRAP**. L'interface du syscall sera documentée.  
    * [hardware_init.asm](hardware_init.asm) responsable de l'initialisation matérielle. 
    * [terminal.asm](terminal.asm) fonctions de base pour la communication avec le terminal. Les fonctions du terminal peuvent-être accédées directement par les applications qui sont liées avec le système, i.e. monitor et BASIC. Les applications chargées dynamiquement doivent utilier un syscall.

## Initialisation du système 

Lors de la mise sous tension La routine **cold_start** du fichier [hardware_init.asm](hardware_init.asm)  est invoquée, celle-ci effectue les opérations suivantes:
* Met à zéro toute la mémoire RAM.
* Initialize l'oscillateur principal du MCU à 16Mhz en utilisant l'oscillateur interne HSI. 
* Initialize la minuterie TIMER4 pour une interruption à toute les millisecondes. Cette interruption maintient les variables systèmes *ticks* et *timer*
* Initialize la minuerie TIMER2 pour qu'elle fonctionne en mode PWM. Cette minuterie est utilisée pour générer des tonalités audio.
* Initialize le UART responsable de la communication avec le terminal. 
* Lorsque l'initialisation est complétée l'application *monitor* est invoquée.

## variables utilisées par le système et qui ne doivent pas être modifiées par les application. 
* *pad*: 0x1700, 128 octets réservés, tampon qui peut être utilisé par les applications. situé sous la pile matérielle, adresse 0x1700 
* *tib*: 0x1680,  128 octets réservés, tampon utilisé par la fonction *readln* du terminal.  

* Adresses __{0x0...0x1f}__ réservées pour le noyau système. Ne devraient pas être modifiées par les applications.

* *ticks*:0x04,  2 octets, compteur de millisecondes maintenue par l'interruption du TIMER4.  
* *timer*:0x06,  2 octets, minuterie à rebours maintenue par l'interruption du TIMER4. Lorsque sa valeur atteint zéro un l'indicateur booléen *F_TIMER* est is à **1**. 
* *tone_ms*:0x8
* *sys_flags*:0x0A  , 1 octet, indicateurs booléens maintenu par le système. 
    * FSYS_TIMER=0 ; indicateur d'expiration de la minuterie
    * FSYS_TONE=1  ; indicateur de tonalité en cours, remis à zéro par l'interruption TIMER4
    * FSYS_UPPER=2 ; cet indicateur lorsqu'il est mis à **1** indique à la routine **getc** de mettre les lettres en majuscules
* *seedx*:0x0b ; 2 octets ; bits 31..16 du générateur pseudo aléatoire.
* *seedy*:0x0d ; 2 octets ; bits 15..0 du générateur pseudo aléatoire. 
* *base*:0x0f ; 1 octet ; base numérique utilisée par 'print_int' 
* *fmstr*:0x10 ; Fmaster frequency in Mhz



## Interface syscall

L'instruction machine **TRAP** du STM8  est utilisée pour effectuer les appels système. Cette instruction déclenche une interruption logicielle et est non masquable.

### Utilisation des registres:

* en entrée:
    * **A**    contient le code de la fonction.
    * **X,Y**    peuvent-être utilisés pour passer des paramètres
* en sortie:
    * **CC, A, X, Y** peuvent-être utilisés pour retourner des valeurs.

### Interface des appels système. 

code|description|paramètres d'entrée| valeurs de sortie
----|--------------------|-------------------|-------------------
  0 | réinitialisation de l'ordinateur | aucun | aucun 
  1




## applications incluse en mémoire flash

    * [p1Monitor.asm](p1Monitor.asm)
    * [p1Basic.asm](p1Basic.asm)
