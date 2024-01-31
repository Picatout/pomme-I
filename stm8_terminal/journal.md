### 2023-07-05

* Continuation du travail sur [ps2.asm](ps2.asm). 
    * installation de la police de caractères [font_6x8](font.asm) en mémoire RAM. Ceci permet de sauver 2µsec par scan line dans l'interruption d'affichage vidéo **ntsc_video_interrupt**.

    * Ajout du traitement pour les altérations de caractères du aux touches **CTRL** et **ALT**. Les touches de gauche et de droite sont traitées de la même façon.

    * Ajout de la commande **CTLR+E** pour commuter (toggle) l'écho local sur stm8_terminal. 

* mise à jour du [readme.md](readme.md).

### 2023-07-04

* Avancement du travail sur [ps2.asm](ps2.asm), traite les touches **Ver. maj.** et  **Maj.** correctement. Reste à implémentater le traitement des touches **CTRL** et **ALT**. 

* Travail sur [ps2.asm](ps2.asm).

### 2023-07-03 

* Début du travail sur [ps2.asm](ps2.asm).

* Corrigé bogue dans *tv_cursor_right*. 

* Corrigé bogue dans *tv_disable_cursor*. 

*  Travail sur [tvout.asm](tvout.asm), j'ai trouvé une méthode pour permettre d'afficher 40 caractères par ligne. Le tampon vidéo contient l'adresse du caractère dans la table de la police, plutôt que le caractère lui-même. De cette façon cette adresse n'a pas besoin d'être calculé au moment de l'affichage. On sauve ainsi plusieurs cycles machines par caractère. De plus l'espace entre chaque caractère est plus étroit ce qui améliore l'apparence.

### 2023-07-02

* Travail sur [tvout.asm](tvout.asm), amélioration au prix de la réduction du nombre de caractère par ligne 34 au lieu de 40. 

 * Abandon de l'utilisation du périphérique SPI. 

 * les pixels sont sérialisés avec déroulement des boucles en utilisant des macros. C'est la seule façon de réduire le nombre de cycles machine par pixel. Avec cette méthode j'obtient 28 cycles par pixel. 7 pixels par caractères sont envoyés.

### 2023-07-01

 * Ajout de [tv_term.asm](tv_term.asm). Encore un problème avec la qualité de l'affichage sur la tV.

 * Travail sur [tvout.asm](tvout.asm), maintenant affiche les caractères presque correctement sauf qu'il en affiche 41 par ligne au lieu d 40. 
 l'affichage ne semble pas tenir compte des scan_lines!!.

### 2023-06-29

* Travail sur [tvout.asm](tvout.asm)

### 2023-06-28

* Démarrage du projet. 

