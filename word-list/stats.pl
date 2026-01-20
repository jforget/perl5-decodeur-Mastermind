#!/usr/bin/env perl
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Calcul des statistiques sur les mots d'une liste : entropie, minimax
# Computing the Mastermind-related stats on a word list: entropy, minimax
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
use Getopt::Long;

my ($length, $filepath);

GetOptions("length=i" => \$length,
           "file=s"   => \$filepath,
  ) or die "Problem with options";

my @words;

open my $f1, '<', $filepath
  or die "opening $filepath: $!";
while (my $word = <$f1>) {
  chomp $word;
  unless (defined $length) {
    $length = length($word);
  }
  if (length($word) == $length) {
    push @words, $word;
  }
}
close $f1
  or die "closing $filepath: $!";

my $nb = 0 + @words;
my $l1 = $length + 1;
my @init_b  = (0) x  $l1;
my @init_bw = (0) x ($l1 * $l1);

for my $w1 (@words) {
  my @histo_b  = @init_b;
  my @histo_bw = @init_bw;
  for my $w2 (@words) {
    my ($b, $w) = bw($w1, $w2);
    $histo_b[$b]++;
    $histo_bw[$b * $l1 + $w]++;
  }
  my $entr_b  = log2($nb);
  my $entr_bw = log2($nb);
  my $minimax_b  = 0;
  my $minimax_bw = 0;

  for my $n (@histo_b) {
    if ($minimax_b < $n) {
      $minimax_b = $n;
    }
    if ($n) {
      $entr_b -= $n * log2($n) / $nb;
    }
  }

  my $i = 0;
  for my $n (@histo_bw) {
    if ($minimax_bw < $n) {
      $minimax_bw = $n;
    }
    if ($n) {
      $entr_bw -= $n * log2($n) / $nb;
    }
    $i++;
  }

  printf("%s %5.2f %5d %5.2f %5d\n", $w1, $entr_bw, $minimax_bw, $entr_b, $minimax_b);
}

sub log2 {
  my ($x) = @_;
  return log($x) / log(2);
}
sub bw {
  my ($w1, $w2) = @_;
  my $l = length($w1);
  my $b = 0;
  my $w = 0;
  for (my $i = 0; $i < $l; $i++) {
    if (substr($w1, $i, 1) eq substr($w2, $i, 1)) {
      $b++;
      substr($w1, $i, 1) = '!';
      substr($w2, $i, 1) = '?';
    }
  }
  for (my $i = 0; $i < $l; $i++) {
    for (my $j = 0; $j < $l; $j++) {
      if (substr($w1, $i, 1) eq substr($w2, $j, 1)) {
        $w++;
        substr($w1, $i, 1) = '!';
        substr($w2, $j, 1) = '?';
      }
    }
  }
  return ($b, $w);
}

=encoding utf8

=head1 NAME

stats.pl -- computing the Mastermind-related stats on a word list: entropy, minimax

=head1 VERSION

Version 0.01

=head1 USAGE

  perl stats.pl -l 5 -f liste_francais_asc.txt

=head1 REQUIRED PARAMETERS

=over 4

=item filepath

The filepath of the text file containing the word list.

=item length

If the file  contains words with different lengths,  this parameter is
mandatory. It allows the program to  filter the list and keep only the
words matching this length.

=back

=head1 OPTIONS

None.

=head1 DESCRIPTION

The program loads  the words from the file given  in parameters. Words
are filtered according to their lengths.

For each  word, the  program computes the  Mastermind score  with each
other word.  Then it summarises  these score by computing  the Shannon
entopy and the class with most words. These computations are made both
with the  "Black and white markings"  rule and the "Black  marks only"
rule. Then the program prints these data:

=over 4

=item 1 the word

=item 2 the Shannon entropy (B&W)

=item 3 the size of the class with most words (B&W)

=item 4 the Shannon entropy (B only)

=item 5 the size of the class with most words (B only)

=back

By storing this output  in a file and sorting this  file, the user can
find the  best Shannon  entropy or  the minimax. Use  C<sort -k  2> or
C<sort -k 4>  for the entropy and C<sort  -k 3 -n> or C<sort  -k 5 -n>
for the minimax.

=head1 DEPENDENCIES

This Perl program requires Perl 5.10 or greater.

=head1 CONFIGURATION

None.

=head1 BUGS AND LIMITATIONS

None.

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
