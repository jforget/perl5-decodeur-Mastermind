-*- encoding: utf-8; indent-tabs-mode: nil -*-

Ce répertoire permet de stocker quelques  listes de mots, de façon que
le décodeur  Mastermind du répertoire principal  puisse fonctionner en
tant que décodeur pour le Mastermind des mots.

Les termes de  licence des programmes de ce répertoire  sont les mêmes
termes que  pour Perl :  GNU General  Public License (GPL)  version et
Perl Artistic License.

Les textes  documentant ces programmes  sont diffusés sous  la licence
CC-BY-SA  : Creative  Commons, Attribution  - Partage  dans les  Mêmes
Conditions (CC BY-SA).

Les différents fichiers contenant des  listes de mots peuvent utiliser
d'autres licences.

Stanford Graphbase
==================

Le project [Stanford Graphbase](https://github.com/ascherer/sgb)
propose une  liste de 5757 mots  anglais de 5 lettres.  Comme tous les
fichiers  de  ce projet,  il  est  dans  le  domaine public,  avec  un
copyright  (c) 1993  Stanford University.  Vous pouvez  le télécharger
avec

```
curl -o sgb-words.txt https://www-cs-faculty.stanford.edu/~knuth/sgb-words.txt
```

ou avec

```
wget https://www-cs-faculty.stanford.edu/~knuth/sgb-words.txt
```

La [version disponible](https://github.com/ascherer/sgb/blob/master/words.dat)
dans  le  dépôt  Github  ne  convient  pas,  elle  comporte  plusieurs
indications techniques et administratives en plus des mots. C'est dans
ce fichier qu'est mentionné le copyright (c) 1993 Stanford University.
Il est également mentionné que la  copie de ce fichier est libre, mais
qu'il ne faut pas le modifier.

Freelang.com
============

Le site [Freelang.com](https://www.freelang.com/) propose plusieurs
[dictionnaires gratuits](https://www.freelang.com/dictionnaire/dic-features.php)
(exécutables Windows), des
[dictionnaires en ligne](https://www.freelang.com/enligne/index.php)
plus une
[liste de mots français](https://www.freelang.com/dictionnaire/dic-francais.php),
apparemment libre de droits. Avec la suite de commandes

```
wget https://www.freelang.com/download/misc/liste_francais.rar
unrar-free -x liste_francais.rar
iconv --from-code=windows-1252 --to-code=utf-8 liste_francais.txt | perl -p -e 's/\cM//' > liste_francais_utf.txt
```

vous obtenez un fichier UTF-8 contenant 22735 mots de longueurs diverses.
Pour adapter ce fichier aux besoins du décodeur Mastermind, lancez

```
perl adapt-freelang.pl
```
