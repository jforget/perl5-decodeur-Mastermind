#!/usr/bin/env perl
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Adapte la liste de mots obtenue de www.freelang.com pour le décodeur Mastermind
# Tweaks the word list from www.freelang.com for use with a Word Mastermind codebreaker
#
# Copyright (c) 2026 Jean Forget
#
# See the license in the embedded documentation below
#

use v5.10;
use utf8;
use strict;
use warnings;
use open ':encoding(utf8)';
use open ':std';

my $file1 = 'liste_francais_utf.txt';
my $file2 = 'liste_francais_asc.txt';

my %words;

open my $f1, '<', $file1
  or die "opening $file1: $!";
while (my $word = <$f1>) {
  chomp $word;
  $word =~ tr/ÀÂÄÇÈÉÊËÎÏÔÙÛÜ/AAACEEEEIIOUUU/;
  $word =~ tr/àâäçèéêëîïôùûü/aaaceeeeiiouuu/;
  $word =~ s/œ/oe/g;
  $word =~ s/[- '.]//g;
  $word = uc($word);
  unless ($word =~ /^[A-Z]+$/) {
    # I really mean [A-Z] and not \w. I want to reject diacritics.
    # anyhow, this branch should not run
    die "Still chars to replace in $word"
  }
  $words{$word}++;
}
close $f1
  or die "closing $file1: $!";

open my $f2, '>', $file2
  or die "opening $file2: $!";
for my $word (sort keys %words) {
  say $f2 $word;
  if ($words{$word} >= 3) {
    say "$words{$word} × $word";
  }
}
close $f2
  or die "closing $file2: $!";

=encoding utf8

=head1 NAME

adapt-freelang.pl -- tweaking the word list from www.freelang.com

=head1 VERSION

Version 0.01

=head1 USAGE

  wget https://www.freelang.com/download/misc/liste_francais.rar
  unrar-free -x liste_francais.rar
  iconv --from-code=windows-1252 --to-code=utf-8 liste_francais.txt | perl -p -e 's/\cM//' > liste_francais_utf.txt
  perl adapt-freelang.pl

=head1 REQUIRED ARGUMENTS

None.

=head1 OPTIONS

None.

=head1 DESCRIPTION

The  website  L<https://www.freelang.com/>  gives  a  RAR  file  which
contains a list of French words. The procedure written above downloads
this  archive, extracts  a W-1252-encoded  file and  converts it  to a
UTF-8-encoded file, with LF line endings.

Note: the encoding is I<not>  ISO-8859-1, but really Windows-1252. The
difference lies in the 37 entries containing a "œ" (C<oelig>).

Actually, a  few entries are  not proper  words, but phrases,  such as
"agir en maître" (to act like a master). There are inconsitencies with
masculine/feminine and singular/plural. For example, the list contains
"abonné" (MS), "abonnée"  (FS) and "abonnés" (MP),  but not "abonnées"
(FP). Yet, the main advantage of the list is its availibility.

The  Mastermind  codebreaker  does  not  work  with  diacritics,  with
punctuation and  with case differences. This  program eliminates these
problems, while  avoiding duplications  which would be  generated from
"chasse"  / "chassé"  /  "châsse  (= hunt  /  hunted  / reliquary)  or
"U.S.A." /  "usa" (U.S.A. / used).  The result is stored  into another
file.

=head1 DEPENDENCIES

This Perl program requires Perl 5.10 or greater.

The whole procedure requires:

=over 4

=item * C<wget> (or equivalent, such as C<curl>)

=item * C<unrar-free> (or equivalent, such as C<unrar>)

=item * C<iconv> (or maybe some similar utility such as C<recode>)

=back

=head1 CONFIGURATION

None.

=head1 BUGS AND LIMITATIONS

The filenames are hard-coded in the program.

=head1 AUTHOR

Jean Forget (jforget on Github).

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2026 Jean Forget

This program is  free software: you can redistribute  it and/or modify
it  under the  terms  of  the GNU  Affero  General  Public License  as
published by  the Free  Software Foundation, either  version 3  of the
License, or (at your option) any later version.

This program  is distributed in the  hope that it will  be useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR  A PARTICULAR  PURPOSE.  See the  GNU
Affero General Public License for more details.

You should  have received  a copy  of the  GNU General  Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
