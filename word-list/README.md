-*- encoding: utf-8; indent-tabs-mode: nil -*-

This directory stores a few  word lists, so the Mastermind codebreaker
program  in   the  main  directory   works  as  a   "Word  Mastermind"
codebreaker.

The programs  in this directory are  licensed under the same  terms as
Perl: GNU General Public License version 1 or Perl Artistic License.

The texts documenting  these programs are licensed under  the terms of
Creative Commons, with attribution and share-alike (CC-BY-SA).

The word list files may use other licenses.

Stanford Graphbase
==================

The [Stanford Graphbase](https://github.com/ascherer/sgb)
project provides a list of 5757 English words, all 5-letter long. This
file, as all the files in this  project, is in the public domain, with
a copyright (c) 1993 Stanford University. It can be downloaded with

```
curl -o sgb-words.txt https://www-cs-faculty.stanford.edu/~knuth/sgb-words.txt
```

or with

```
wget https://www-cs-faculty.stanford.edu/~knuth/sgb-words.txt
```

The [version](https://github.com/ascherer/sgb/blob/master/words.dat)
available  in the  Github  repository is  not  convenient, because  it
includes several  technical additions and a  few administrative lines.
The  copyright notice  can  be found  in this  file.  The author  also
explains that copying the file is allowed, but not modifying it.

Freelang.com
============

The [Freelang.com](https://www.freelang.com/) website offers several
[free dictionnaries](https://www.freelang.com/dictionnaire/dic-features.php)
(Windows programs),
[online dictionnaries](https://www.freelang.com/enligne/index.php)
and a
[French word list](https://www.freelang.com/dictionnaire/dic-francais.php),
seemingly free. By running the following commands,

```
wget https://www.freelang.com/download/misc/liste_francais.rar
unrar-free -x liste_francais.rar
iconv --from-code=windows-1252 --to-code=utf-8 liste_francais.txt | perl -p -e 's/\cM//' > liste_francais_utf.txt
```

you obtain a file containing 22735 French words, encoded in UTF-8. The
words  have  varying lengths.  The  file  needs  some tweaking  to  be
compatible with the Mastermind codebreaker `decodeur-mm`, so run

```
perl adapt-freelang.pl
```
