-*- encoding: utf-8; indent-tabs-mode: nil -*-

# DESCRIPTION

## Avant-propos

Le  but  de ce  programme  est  de jouer  au  Mastermind  en tant  que
décodeur, avec un fonctionnement relativement proche de l'optimum.  Le
fonctionnement optimal  s'obtient par  la construction de  l'arbre des
coups possibles, un peu comme  aux échecs, puis en analysant cet arbre
pour en  extraire la  suite de coups  qui permettra d'arriver  le plus
rapidement  à  la  découverte  du   code  secret,  quel  que  soit  ce
code. Comme il s'agit  d'une recherche arborescente, cela peut prendre
un temps et un espace  mémoire énormes, même en utilisant des méthodes
comme   l'élagage  alpha-béta.   Ce  programme   utilise   plutôt  des
algorithmes  relativement  économes en  mémoire  et  en  temps et  qui
conduisent à  un résultat en  un nombre de coups  relativement réduit,
même si ce nombre n'est pas minimal.

La description qui suit fait  référence à plusieurs occasions au livre
_Le Mastermind en  10 leçons_, écrit par Marco  Meirovitz (le créateur
du  Mastermind)  et  Jean  Tricot,   publié  par  Hachette  et  achevé
d'imprimer le  15 février 1979,  ISBN 2.01.005031.2. Sur  Internet, on
trouve parfois M. Meirovitz avec le prénom Mordechai au lieu de Marco.
Remarquez  que dans  les  deux  cas, les  initiales  restent "MM".  Je
continuerai à l'appeler  Marco, puisque c'est ce qui est  écrit sur le
livre.

Avertissement pour les mathophobes. Si la simple mention d'un sinus ou
d'un cosinus vous  donne des boutons, arrêtez de lire  ce texte. Il ne
sera  pas  question  de  trigonométrie,  mais de  probabilités  et  de
logarithmes,   ce   qui  est   tout   aussi   nocif   à  votre   santé
psychosomatique.

## Rappel sur les règles du jeu

Le Mastermind  se joue à  deux joueurs, le  codeur et le  décodeur. Le
codeur  choisit un  code secret,  une combinaison  de  quatre couleurs
prises  parmi six,  les  répétitions étant  autorisées.   Il pose  les
quatre  pions correspondant dans  quatre trous,  masqués du  regard du
décodeur par un écran amovible.  Puis le décodeur essaie de deviner le
code secret  en proposant une combinaison  de son choix.   Il pose les
quatre  pions colorés  de sa  proposition dans  quatre  trous alignés,
visibles par  les deux joueurs.   Le codeur compare  cette combinaison
avec son code secret et révèle  au décodeur combien de couleurs sont à
la  bonne place  (ce qui  se matérialise  par des  marques  noires) et
combien de couleurs sont correctes,  mais à une mauvaise place (ce qui
donne des  marques blanches).  Si le décodeur  n'a pas trouvé  le code
secret,  il  effectue un  nouveau  tour,  avec  le choix  d'une  autre
combinaison et  le codeur répond  de même. Le  but du décodeur  est de
trouver le code  secret, ce qui se traduit  par quatre marques noires,
avec le minimum de coups.

Exemple : le codeur a choisi

```
  C F E D
```

et le décodeur propose

```
  A B C D
```

La  note se  constitue  d'une  marque noire  (pour  `D` en  quatrième
position) et d'une marque blanche (pour `C` en première position dans
le  code  et en  troisième  position  dans  la proposition).  Mais  le
décodeur  ne sait pas  quelle couleur  ou quelle  position a  donné la
marque noire ni la marque blanche.

S'il y  a répétition de  couleur, un même  pion ne peut  donner qu'une
seule   marque,   en  privilégiant   les   marques   noires  sur   les
blanches. Exemple :

```
  code secret   D A A D
  proposition   A B C D
```

Le résultat sera une marque noire et  une marque blanche. Le `A` de la
proposition, en position 1, peut être  apparié au `A` en position 2 du
code secret ou à celui qui se trouve en position 3. Dans les deux cas,
cela donne une  marque blanche. Mais cela n'en donne  qu'une seule, le
`A` de la  proposition ne pouvant servir qu'une seule  fois. Le `D` de
la  proposition, en  position  4, peut  être apparié  avec  le `D`  en
position 1  du code secret,  ce qui  donnerait une marque  blanche, ou
avec le `D` en position 4 du  code secret, ce qui donnerait une marque
noire. Dans ce cas, c'est la  marque noire qui l'emporte sur la marque
blanche. Le résultat  complet est donc une marque noire  et une marque
blanche.

Si le codeur  est obligé de choisir ses quatre  couleurs parmi les six
possibles, le  décodeur a le  droit d'insérer dans sa  proposition une
couleur  dont il sait  qu'elle est  invalide. Matériellement,  cela se
traduit par une place laissée vide, sans pion de couleur.

Dans le cas d'un texte en noir sur blanc (ce fichier POD ou un livre),
on représente traditionnellement les marques noires avec un `X` et les
marques   blanches  avec   un  `O`.   Les  pions   de  couleurs   sont
habituellement  représentés  par l'initiale  de  la  couleur, mais  je
préfère ici  utiliser les lettres de  `A` à `F`, puisque  le programme
permet l'utilisation d'un nombre de couleurs allant jusqu'à 26.

Il  existe des  variantes  du Mastermind.  Des variantes  élémentaires
consistent à faire varier le nombre de trous et le nombre de couleurs.
Elles  sont traitées (dans  des limites  raisonnables) par  le présent
programme.

D'autres variantes sont destinées à simplifier la tâche du décodeur et
ne  requièrent aucun  matériel  supplémentaire. Par  exemple, le  code
secret  doit  contenir quatre  couleurs  différentes, les  répétitions
étant interdites. Ou bien le codeur doit indiquer au décodeur à quelle
position  correspond chaque marque  noire ou  blanche qu'il  pose. Ces
variantes ne sont pas prises en compte dans le présent programme.

Enfin, d'autres variantes changent les mécanismes du jeu : utilisation
de formes en plus des couleurs, utilisation de lettres, le code secret
devant être  un mot intelligible  en français, etc.  Ces  variantes ne
sont pas prises en considération dans le présent programme.

## Déroulement d'une partie

Une partie  avec un décodeur  humain se déroule  en trois étapes  : le
début de partie, le milieu de partie et la fin de partie.

Pendant le  début de partie, le  décodeur n'a aucune idée  sur le code
secret à  trouver. Il joue donc  des propositions en  grande partie au
hasard, de manière à « ratisser large ».

En milieu de  partie, le décodeur commence à  avoir quelques idées sur
le code secret,  il formule des hypothèses et  les teste. Par exemple,
il peut  formuler des hypothèses comme  : « Le rouge  est-il répété ou
n'apparaît-il qu'une fois  ? » ou bien : « La  marque noire du premier
tour  correspond-elle au  bleu en  première  position ou  au jaune  en
troisième ? ».

En fin de partie, le décodeur  a des idées précises sur le code secret
et il ne  reste plus que quelques codes compatibles avec  ce qui a été
joué jusque-là.   Le décodeur est  capable d'énumérer la liste  de ces
codes. Son but est alors de  minimiser le nombre de coups à jouer pour
obtenir le  résultat, donc de  choisir dans la  liste le code  le plus
discriminant.  Exemple, les codes  restants sont : `ABCD`, `ABDC` et
`BACD`. Si le décodeur joue `ABCD`, le codeur répondra :

* `XXXX` si le code secret est `ABCD`
* `XXOO` si le code secret est `ABDC` ou `BACD`.

Si en revanche, le décodeur joue `BACD`, le codeur répondra :

* `XXXX` si le code secret est `BACD`,
* `XXOO` si le code secret est `BADC`,
* `OOOO` si le code secret est `BACD`.

On voit donc  que `BACD` mène à un gain en  deux coups maximum, alors
que dans  un tiers  des cas, `ABCD`  conduit à  une fin de  partie en
trois coups.

Dans le  cas de mon  programme, le milieu  de partie n'existe  pas. Le
programme est capable de mémoriser  une liste de plusieurs dizaines de
codes autorisés, ce  que ne peut pas faire un  humain normal.  Donc, à
l'issue  du  début  de   partie,  pendant  un  interlude  (de  "inter"
signifiant "entre" et "lude" signifiant "jeu") le programme établit la
liste  des codes  compatibles avec  ce qui  a déjà  été joué,  puis il
entame la fin de la partie.

Une autre différence entre mon programme et le jeu avec un humain.  Le
programme  considère   que  tous  les   codes  secrets  ont   la  même
probabilité.   Ainsi que  le signalent  les  auteurs du  livre, si  le
codeur est un humain, il évitera inconsciemment certaines combinaisons
de  couleurs  et  en   privilégiera  d'autres.  Également,  les  codes
monochromes sont censés survenir 6 fois sur 1296, ou 1 fois sur 216 si
le codeur est un programme  correctement codé, alors que la proportion
sera nettement moins importante si le codeur est un humain.

## Début de partie

Le  livre de  Jean Tricot  et Marco  Meirovitz analyse  les différents
coups de départ pour le jeu à 4 trous et 6 couleurs et pour le jeu à 4
trous  et 7  couleurs.  Pour le  jeu  à  4 trous  et  6 couleurs,  les
propositions  `ABCD`   et  `ABCC`  sont  quasiment   équivalentes.  En
revanche, pour le  jeu à 4 trous  et 7 couleurs, c'est  le code `ABCD`
qui  est  le  meilleur.   Donc,  par  extrapolation  pifométrique,  je
considère que la meilleure tactique  pour le début de partie lorsqu'il
y a  beaucoup de couleurs consiste  à jouer `ABCD`, puis  `EFGH`, puis
`IJKL` et  ainsi de  suite. Et s'il  n'y a pas  assez de  couleurs, on
boucle. Par exemple, pour  le jeu à 4 trous et  6 couleurs, le premier
coup  est  `ABCD`,  le  deuxième est  `EFAB`,  c'est-à-dire  les  deux
dernières couleurs  `E` et `F`, puis  on reprend au début  avec `A` et
`B` pour compléter le code.

Tout  au long  du début  de partie,  si l'on  tombe sur  un  nombre de
marques à zéro, on supprime  carrément de la liste des couleurs celles
qui apparaissent dans la proposition. Cela accélérera l'interlude.

Il est  important de remarquer  que les codes  joués dans le  début de
partie  n'ont jamais  de  couleur commune,  à  part le  premier et  le
dernier  coup  (celui qui  boucle  sur  la  liste des  couleurs).  Par
exemple, pour  le jeu à 4  trous et 26 couleurs,  les tours successifs
sont `ABCD`, `EFGH`, `IJKL`,  `MNOP`, `QRST`, `UVWX` et `YZAB`.
Seuls `ABCD` et `YZAB` ont des couleurs en commun.

Le programme  décide de quitter le  début de partie dans  l'un des cas
suivants :

<ul>

<li>
Lorsqu'il  a otenu  une note  avec 4  noirs, c'est-à-dire  lorsqu'il a
trouvé le code secret. C'est une  victoire due au hasard, certes, mais
il faut la prévoir.
</li>

<li>
Lorsqu'il a  passé en  revue toutes  les couleurs.  On estime  que les
notes des  coups passés apportera suffisamment  d'information pour que
la liste de codes compatibles ne soit pas trop longue.
</li>

<li>
Lorsque tous les  codes joués jusque-là ont abouti à  une note cumulée
de 4 marques noires ou blanches. Par exemple :

<pre>
    IJKL OO
    EFGH X
    ABCD O
</pre>

On sait pertinemment  que les codes suivants `MNOP`,  `QRST` et `UVWX`
auront  une note  nulle. Inutile  donc de  les jouer.  On peut  passer
directement à l'interlude, avec la  constitution de la liste des codes
compatibles.
</li>

<li>
Lorsque tous les  codes joués jusque-là ont abouti à  une note cumulée
de 3 marques noires ou blanches. Par exemple :

<pre>
    IJKL O
    EFGH X
    ABCD O
</pre>

Les  codes suivants  `MNOP`, `QRST`  et `UVWX`  ne pourront  avoir que
trois notes possibles : `X`, `O` ou rien du tout. C'est donc une perte
de temps. On passe donc à l'interlude et à la constitution de la liste
des codes compatibles.  Celle-ci sera plus importante que  dans le cas
précédent, mais au moins, on pourra reprendre la fin de partie avec un
éventail  de  notes plus  important,  donc  permettant d'aboutir  plus
rapidement.
</li>

</ul>

La note cumulée s'évalue en créant un « coup synthétique », qui est la
concaténation de  tous les  coups réels ayant  eu au moins  une marque
noire ou  blanche. Pourquoi  prend-on la peine  de constituer  ce coup
synthétique, au lieu de cumuler simplement les résultats `$nb` ? Cela
sera expliqué dans l'interlude.

## Interlude

Dans l'interlude,  le programme construit  la liste de tous  les codes
compatibles avec les coups joués pendant le début de partie.  La liste
est construite progressivement avec des  codes incomplets à 1, puis 2,
puis 3 pions, avant d'arriver aux codes complets à 4 pions.

À chaque  étape, on  compare le code  incomplet avec  les propositions
jouées dans le début de partie,  pour voir si les résultats (nombre de
marques noires et nombre de marques blanches) correspondent.  On garde
à l'esprit que le code est incomplet et qu'en ajoutant une couleur, on
peut :

* obtenir une marque noire supplémentaire,
* obtenir une marque blanche supplémentaire,
* remplacer une marque blanche par une marque noire.

Pour un code à trois couleurs  et un vide, le nombre de marques noires
doit  donc être  le nombre  final, ou  bien le  nombre final  moins 1.
Quant à  tester les  marques blanches, il  est préférable de  faire la
somme noirs+blancs. Ainsi, le nombre  de marques noires et blanches du
code à trois couleurs et un  vide doit être le nombre final de marques
noires et blanches, ou bien ce nombre moins 1.

Pour  un code  à deux  couleurs et  deux vides,  le nombre  de marques
noires  doit être compris  entre le  nombre final  et le  nombre final
moins 2.  Idem pour la somme marques noires + marques blanches.

Et pour  un code  à une seule  couleur  et  trois vides, le  nombre de
marques noires  doit être compris entre  le nombre final  et le nombre
final moins 3.  Et encore une fois, c'est pareil pour le nombre cumulé
de marques noires et blanches.

Ainsi, en commençant  par déterminer les codes à un  seul pion, puis à
deux pions, puis 3 puis 4, on ne parcourt pas l'arbre entier des codes
possibles, on  l'élague au fur  et à mesure,  ce qui permet  de perdre
moins de temps.

Exemples :  l'un des coups  joués était  `ABCD`, noté `X`  (une marque
noire). Le code `AE..` obtient une note `X` et est donc compatible. Le
code  `AD..` obtient  une note  `XO`  et est  incompatible. En  effet,
quelles  que soient  les couleurs  placées en  troisième et  quatrième
positions, on  ne pourra pas  revenir à une  note `X`. Le  code `CE..`
obtient une  note `O` et est  compatible. Bien qu'il y  ait une marque
blanche en  trop, cette  marque pourra être  remplacée par  une marque
noire,  lorsque  l'on testera  `CEC.`  puis  `CECC` et  `CECE`  (entre
autres).

Maintenant, supposons que  le coup `ABCD` ait reçu la  note `XOO` (une
marque noire et  deux blanches). Le code `AE..` reçoit  la note `X` et
est compatible.  En effet, il reste  deux trous à remplir  et ces deux
trous  peuvent  fournir  les  deux  marques  blanches  manquantes.  En
revanche, le code `EF..` reçoit une note nulle et est incompatible. En
effet,  ce n'est  pas  les deux  trous à  remplir  qui permettront  de
fournir les trois marques manquantes.

Remarque : pour des raisons  de simplification du code, le remplissage
se fait par la fin, `...A`  et `...B` etc pour la première génération,
puis `..AA`, `..AB` pour la deuxième génération et ainsi de suite.

Autre remarque. Prenons le jeu à  4 trous et 26 couleurs, et supposons
que le début de partie soit le suivant :

```
    IJKL X
    EFGH X
    ABCD X
```

La liste  de premier niveau,  c'est-à-dire de codes avec  trois vides,
comporte  toutes  les lettres  de  l'alphabet  `...A` jusqu'à  `...Z`.
Normal.  La liste  de deuxième  niveau comportera,  entre autres,  des
codes  partiels du  genre `..MN`  ou `..NO`.  Ces codes  partiels sont
compatibles séparément avec  les trois coups joués, mais  pas avec les
trois coups dans  leur globalité. D'accord pour avoir  une couleur `M`
ou au-delà, mais pas deux, car un humain a tout de suite compris qu'il
faut une  couleur parmi  `A`..`D`, une couleur  parmi `E`..`H`  et une
couleur parmi `I`..`L`.  Mais le programme n'est pas  capable de faire
ce   raisonnement.    Heureusement,   grâce   au    coup   synthétique
`ABCDEFGHIJKL`, qui a comme note `XOO`, le programme pourra déterminer
qu'il  faut  trois   de  ces  douze  couleurs  dans   le  code  final,
c'est-à-dire au moins une de ces  douze couleurs dans chacun des codes
partiels à deux  vides. Cela permet donc de rejeter  `..MN` et `..NO`.
Mais surtout, cela permet de ne  pas prendre en considération tous les
coups à un seul vide générés à  partir de `..MN` et de `..NO`. Cela ne
permet pas  de rejeter `..AB`, mais  n'importe comment, ce code  a été
rejeté lorsqu'il  a été confronté au  coup `ABCD` qui avait  une seule
marque (noire).

À noter que  si les _n_ - 1  premiers coups ont eu chacun 0  noir et 0
blanc et que le _n_ ième coup a  eu 3 ou 4 marques noires et blanches,
alors le coup  synthétique est vide. On ne l'utilise  pas, car avec le
seul  _n_ ième  coup, la  constitution  de la  liste est  suffisamment
rapide.

Une fois  la liste  des codes construite,  le programme  évalue chaque
code avec  chaque autre, pour stocker  la note dans  un hachage indexé
par ces deux codes. Comme cela sera montré dans la suite, le programme
aura besoin de toutes ces notes  au moins une fois, mais assez souvent
plusieurs fois. À cause de cette étape, on souhaite avoir une liste de
codes  suffisamment  petite.   Il   aurait  été  possible  de  stocker
plusieurs centaines de codes possible dans la liste, mais pour l'étape
présente,  cela  aurait  impliqué  une  boucle avec  des  dizaines  de
milliers  d'itérations.   On préfère  donc,  autant  que possible,  se
limiter à quelques dizaines de codes possibles.

À titre de précaution, si le nombre de possibilités dépasse une limite
(codée en dur dans le programme), le tableau à double entrée n'est pas
généré. Lors de la fin de  partie, il faudra calculer au coup par coup
les notes, sans les récupérer dans le tableau.

Par exemple, avant  de mettre en place ce test,  j'ai essayé la partie
suivante, avec un jeu à 4 trous et 26 couleurs :

```
  IJKL O
  EFGH O
  ABCD O
```

Avec ce début de partie,  la liste des codes compatibles comporte 9720
codes. Lors du  calcul du tableau à double entrée  sur ces 9720 codes,
ma  machine a  complètement rempli  ses 3,9  Go de  mémoire vive  et a
commencé à alimenter son fichier swap, avant que je stoppe l'exécution
du programme.

## Fin de partie

Un coup de la fin de la partie prend l'allure suivante :

* Le programme  choisit le code  le plus discriminant parmi  les codes
restants,

* Le programme joue ce code,

* Si la note est `XXXX`, fin de la partie

* Sinon, le programme reçoit la note  du codeur et filtre la liste des
codes restants pour éliminer les codes incompatibles avec cette note.

* Si le  tableau à double entrée  `%notes` n'a pas été  généré lors de
l'interlude et si le nombre de  possibilités est retombé en-deçà de la
limite, alors on le génère  maintenant, pour permettre d'accélérer les
appels ultérieurs à la fonction de choix.

L'action de jouer un code et l'action de filtrer les codes restants ne
présentent pas de mystère. Le choix du code le plus discriminant parmi
les  codes restants  est plus  intéressant. Il  y  principalement deux
méthodes. Celle que j'ai connue la première pendant les années 1980 et
qui est  mentionnée dans  le livre de  Jean Tricot et  Marco Meirovitz
repose sur  l'entropie de Shannon. La  seconde, dont j'ai  eu vent fin
2011 en  lisant la doc  de `Algorithm::Mastermind` a été  décrite par
Donald Knuth et utilise le minimax.

### L'entropie de Shannon

Au début, l'entropie a été un concept en physique, plus précisément en
thermodynamique.    L'entropie   a   été   introduite   par   Clausius
(1822--1888)  comme étant  le quotient  de la  quantité de  chaleur du
système  considéré par  sa température  absolue.  Cette  notion  a été
développée  par Ludwig  Boltzmann (1844--1906)  qui l'a  décrite comme
étant le  nombre de micro-états définissant le  macro-état du système.
Shannon  (1916--2001)  a repris  cette  notion  en mathématiques  pour
étudier le codage  optimal d'un message transmis par  un canal avec ou
sans parasites. La formule qu'il donne est

$$
E = - \sum p_i \times \log_2(p_i)
$$

Jean Tricot et Marco Meirovitz  ont appliqué ce concept au Mastermind,
mais sans  vraiment donner  de détails.  Voici  une explication  de la
notion  d'entropie mathématique.  Cela ne  constitue pas  un  cours de
mathématiques en bonne et due  forme, c'est plutôt une présentation de
mathématiques expérimentales faisant  appel à l'intuition plutôt qu'au
raisonnement.

Laissons de côté le Mastermind et prenons un autre jeu sur le principe
des  questions-réponses, le  jeu consistant  à deviner  un  nombre. Le
codeur choisit secrètement un nombre entre 1 et 100 et le décodeur lui
propose un  nombre, par exemple 50.  Le codeur doit  alors répondre si
c'est  ce nombre,  ou bien  un nombre  plus petit,  ou bien  encore un
nombre plus  grand. Maintenant, modifions légèrement les  règles de ce
jeu. D'une  part, le  nombre à deviner  est dans  l'intervalle 0..255,
d'autre part les questions sont en format libre.

Le décodeur commence par la question : « Le nombre se trouve-t-il dans
l'intervalle 0..127 ou dans l'intervalle  128..255 ? » Dans un cas sur
deux, il  apprendra que le bit  de poids fort  est 0, dans un  cas sur
deux il apprendra  que c'est 1. Avec les  deux réponses de probabilité
1/2, le décodeur gagnera donc 1 bit.

Supposons  maintenant que  sa première  question  soit :  « Le  nombre
est-il pair  ou impair ? ». Là  encore l'une ou l'autre  réponse a une
probabilité de  1/2 et l'une ou  l'autre fait gagner un  bit, sauf que
c'est le bit de poids faible.

Et maintenant, le  décodeur commence la partie par la  question : « Le
nombre se  trouve-t-il dans l'intervalle  0..63 ? ». S'il  obtient une
réponse affirmative, il aura gagné deux bits. Mais cette réponse a une
probabilité de 1/4. Ou bien alors,  il pourrait même commencer par : «
Est-ce 23 ? » et cette réponse, de probabilité 1/256 lui ferait gagner
8 bits d'un seul coup.

Et  s'il demande  maintenant :  « Le  nombre est-il  dans l'intervalle
0..84 ? », une réponse affirmative lui permet de connaître précisément
le bit  de poids  fort et  d'avoir de fortes  présomptions sur  le bit
suivant. En tout état  de cause le nombre commence par `0`  et il y a
de fortes chances qu'il commence par  `00`. Il a donc gagné plus d'un
bit,  mais  pas  tout-à-fait  2.  On  va dire  que  cette  réponse  de
probabilité 1/3  lui a fait gagner  1,58 bit. On en  déduit le tableau
suivant :

  |------------|------------|
  | probabilité de la réponse | information obtenue    |
  |------------|------------|
  |    1/2     |   1 bit    |
  |    1/4     |   2 bits   |
  |    1/256   |   8 bits   |
  |    1/3     | 1,58 bit   |
  |    p_i     | -Log_2(p_i)|

Une question peut  être considérée comme un éventail  de réponses plus
ou  moins probables. Supposons  que la  première question  du décodeur
soit  : «  Le  nombre  se trouve-t-il  dans  l'intervalle 0..63,  dans
l'intervalle 64..127  ou dans l'intervalle  128..255 ? ».  La première
réponse  lui fournit  2 bits  avec  une probabilité  1/4. La  deuxième
réponse  lui fournit  aussi  2 bits  avec  une probabilité  1/4 et  la
troisième  réponse lui  fournit 1  bit  avec une  probabilité 1/2.  Le
décodeur récoltera en moyenne  1/4 x 2 + 1/4 x 2 + 1/2  x 1 = 1,5 bit.
Plus généralement,  si les probabilités des  différentes réponses sont
(p_i), alors la quantité d'information moyenne obtenue par la question
est :

$$
E = - \sum p_i \times \log_2(p_i)
$$

Pour faire  pédant, signalons que  l'on peut utiliser  les logarithmes
népériens dans la formule à la  place des logarithmes à base deux.  On
ne peut plus parler de bits dans ce cas. L'unité est alors appelé le «
shannon ». Cette unité de quantité d'information n'est jamais utilisée
dans  la  réalité,  y  compris  pour  les  études  théoriques  sur  la
transmission de l'information.

Dans _la  Science du Disque-Monde  II le  Globe_, de T.  Pratchett, I.
Steward et J. Cohen, les auteurs font remarquer que Shannon a nommé sa
grandeur   « entropie »  parce   que   la  formule   de  la   quantité
d'information était  identique à celle  de l'entropie de  Boltzmann, à
l'exception du signe moins. Or selon eux, la quantité d'information et
l'entropie sont  utilisés dans  des contextes  différents, donc  il ne
peut  pas  s'agir  d'une  même  grandeur  et  l'utilisation  du  terme
« entropie »  dans les  œuvres  de Shannon  est  injustifiée. Dans  la
version anglaise, cela se trouve  page 192, chapitre « _bit from it_ »
(ISBN 009 188273 7, éditions Ebury Press).

Revenons au Mastermind. Une question consiste à jouer une proposition,
`ABCD` ou `BACD`  par exemple. La réponse est l'une  des notes `XXXX`,
`XXOO`, `XXX.`, `XOO` et ainsi de  suite. La probabilité de chacune de
ces  réponses   est  proportionnelle   au  nombre   de  codes   qui  y
correspondent. On peut ainsi calculer l'entropie de la question.

Reprenons  l'exemple du  début.  Les codes  restants  sont :  `ABCD`,
`ABDC` et `BACD`. Si le décodeur joue `ABCD`, le codeur répondra :

```
  +----------+----------+--------------+-------------+------------+
  | Question | Réponses | Codes        | Probabilité | Entropie   |
  +----------+----------+--------------+-------------+------------+
  |   ABCD   |   XXXX   | ABCD         |    1/3      |            |
  |          +----------+--------------+-------------+            |
  |          |   XXOO   | ABDC et BACD |    2/3      |  0,92 bit  |
  +----------+----------+--------------+-------------+------------+
  |   BACD   |   XXXX   | BACD         |    1/3      |            |
  |          +----------+--------------+-------------+            |
  |          |   XXOO   | ABCD         |    1/3      |            |
  |          +----------+--------------+-------------+            |
  |          |   OOOO   | ABDC         |    1/3      |  1,58 bit  |
  +----------+----------+--------------+-------------+------------+
  |   ABDC   |   XXXX   | ABDC         |    1/3      |            |
  |          +----------+--------------+-------------+            |
  |          |   XXOO   | ABCD         |    1/3      |            |
  |          +----------+--------------+-------------+            |
  |          |   OOOO   | BACD         |    1/3      |  1,58 bit  |
  +----------+----------+--------------+-------------+------------+
```

On voit  donc que le code  `BACD` et le code  `ABDC` rapportent plus
d'information que `ABCD`.  C'est donc ce que le programme de décodage
jouera.

Si  les probabilités  sont calculées  à  partir de  la partition  d'un
ensemble  de  `N`  éléments  en classes  de  `n_i`  éléments  chacune,
c'est-à-dire que $ p_i = \frac{n_i}{N} $ avec $ N = \sum n_i $.

alors, après quelques transformations de niveau terminale scientifique,
l'entropie se calcule avec :

$$
E = \log_2 \left( N \right) - \frac{ \sum n_i \times \log_2\left(n_i\right)}{N}
$$

### Le minimax de Knuth

Ce  critère est  nettement plus  simple  (et beaucoup  moins rigolo  à
expliquer). Lorsque  l'on recense  les différentes notes  obtenues par
les  codes possibles  restants,  on  se contente  de  retenir la  note
correspondant au nombre maximal de codes possibles. Et le code à jouer
est  celui pour  lequel ce  maximum est  le plus  petit. Avec  le même
exemple que ci-dessus, on a :

```
  +----------+----------+--------------+--------+---------+
  | Question | Réponses | Codes        | Nombre | Maximum |
  +----------+----------+--------------+--------+---------+
  |   ABCD   |   XXXX   | ABCD         |    1   |         |
  |          +----------+--------------+--------+         |
  |          |   XXOO   | ABDC et BACD |    2   |    2    |
  +----------+----------+--------------+--------+---------+
  |   BACD   |   XXXX   | BACD         |    1   |         |
  |          +----------+--------------+--------+         |
  |          |   XXOO   | ABCD         |    1   |         |
  |          +----------+--------------+--------+         |
  |          |   OOOO   | ABDC         |    1   |    1    |
  +----------+----------+--------------+--------+---------+
  |   ABDC   |   XXXX   | ABDC         |    1   |         |
  |          +----------+--------------+--------+         |
  |          |   XXOO   | ABCD         |    1   |         |
  |          +----------+--------------+--------+         |
  |          |   OOOO   | BACD         |    1   |    1    |
  +----------+----------+--------------+--------+---------+
```

On voit que  comme avec l'entropie de Shannon, il  ne faut surtout pas
jouer `ABCD`, mais soit `BACD`, soit `ABDC`.

Dans un cas aussi simple, ce  n'est pas étonnant que les deux critères
aboutissent au même résultat. Dans un cas plus compliqué, cela ne sera
pas toujours  le cas. Ainsi, en  annexe de leur livre,  Jean Tricot et
Marco  Meirovitz analysent  le premier  coup  du jeu  à 4  trous et  6
couleurs. Le  coup `ABCD`  possède la  meilleure entropie,  3,05 bits,
mais pour un nombre maximal de 312 codes avec la note `OO`, tandis que
le coup `ABCC` est meilleur pour le critère de Knuth, la note la moins
bonne, `O` donnant 276 possibilités restantes, alors que l'entropie de
Shannon pour  `ABCC` est moins bonne,  3,04 bits. Un centième  de bit,
cela ne va pas  chercher très loin, mais le résultat  est là, ces deux
critères ne sont pas forcément en accord.

Quel est  le meilleur critère  ?  Je ne  sais pas.  Je pense  que cela
dépend des  circonstances et que l'entropie se  révèlera meilleure que
le  minimax  dans certains  cas  tandis  que  le minimax  se  révèlera
meilleur que l'entropie dans  d'autres cas. Pour prendre une métaphore
sportive ou wargamesque, on peut  dire que Shannon joue pour remporter
la victoire, tandis que Knuth  joue pour éviter la défaite. Notons que
l'on n'est  pas obligé d'utiliser la  même méthode tout  au long d'une
même partie. On peut jouer un  coup avec le minimax et le suivant avec
l'entropie.

En fait, j'utilise  les deux critères. L'un est  le critère principal,
l'autre sert à  départager les ex-aequo.  Cela ne  sert vraiment pas à
grand-chose lorsque le critère  principal est l'entropie calculée avec
une  dizaine de  décimales ou  plus (soit  largement plus  que  ce qui
serait  significatif).   Si  deux   codes  ont  la  même  entropie  au
dix-milliardième  de  bit  près,  il  est  quasiment  certain  que  la
répartition  des notes sera  identique pour  ces deux  propositions et
donc, a fortiori,  la classe la plus peuplée  pour les partitions aura
le même nombre d'éléments.   En revanche, lorsque le critère principal
est  le  minimax,  l'utilisation  de l'entropie  pour  départager  les
ex-aequo se révèle utile.

### Remarque

L'une des hypothèses que j'ai faites était que l'on pouvait limiter la
recherche  des codes  les  plus  discriminants à  la  liste des  codes
compatibles avec  le début de  la partie. Je  ne doutais pas  que l'on
pouvait avoir une meilleure discrimination  avec un code qui ne figure
pas  dans  la  liste des  codes  possibles,  mais  je croyais  que  la
différence  n'était  jamais  très  grande  entre  le  code  obtenu  en
cherchant uniquement parmi les codes  compatibles et le code obtenu en
cherchant  dans   la  liste  complète  des  codes   autorisés.  Je  me
trompais.  Prenons l'exemple d'un  jeu à  4 trous  et 26  couleurs. Le
premier tour est :

```
  ABCD XXX
```

Le  programme abandonne  les  codes suivants  `EFGH`, `IJKL`,  `MNOP`,
`QRST`, `UVWX` et `YZAB`, passe à  l'interlude et obtient une liste de
100 codes.  Avec une  notation semblables aux  expressions régulières,
ces 100 codes  sont `ABC[^D]` (25), `AB[^C]D` (25),  `A[^B]CD` (25) et
`[^A]BCD`  (25).  Parmi  ces  100  codes, les  88  qui  n'ont  pas  de
répétitions sont tous identiques pour la répartition des notes

```
  XXXX: 1, XXX: 24, XXO: 3, XX: 72
```

et donc pour la valeur en bits  (1.05) et pour la valeur minimax (72).
Le  programme joue  donc `ABCE`  et supposons  qu'il obtienne  la note
`XXX`. Les codes  compatibles ne sont plus que  24, `ABC[A-CF-Z]`. Ils
sont tous équivalents, avec une répartition

```
  XXXX: 1, XXX: 23
```

Avec  la méthode  consistant à  prendre le  code le  plus discriminant
parmi les codes  possibles, il faudra essayer les 23  codes un par un,
jusqu'à obtenir le code secret. Alors qu'avec d'autres codes, tels que
`FGHI` ou `IJKL`,  on peut éliminer quatre codes de  la liste à chaque
fois (ou, avec un peu de chance, éliminer tous les codes sauf quatre ;
mieux, comme le résultat peut être  `X` ou `O`, la liste résultante ne
comportera pas 4 codes, mais 1 ou 3).

Il faut donc admettre des codes  invalides. Pour ne pas tomber dans un
calcul très long,  on ne va pas admettre les  `26**4` codes possibles,
mais on  va se contenter des  codes qui auraient été  utilisés lors du
début de partie, s'il n'avait  pas été interrompu subitement. Mais ces
codes restent quand  même en compétition avec  les codes `ABC[A-CF-Z]`
de  la  liste des  codes  possibles  et on  prendra  le  code le  plus
discriminant. Qui sera `IJKL`, ex-aequo avec `MNOP`, `QRST` et `UVWX`.

# LICENCE ET COPYRIGHT

(C) Jean Forget, 2011, 2023, 2025, tous droits réservés.

Texte diffusé sous la licence CC-BY-SA : Creative Commons, Attribution -
Partage dans les Mêmes Conditions (CC BY-SA).

Les termes  de licence  du script  associé à ce  texte sont  les mêmes
termes que  pour Perl : GNU  General Public License (GPL)  et Artistic
License.
