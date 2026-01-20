#!/usr/bin/env perl
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Affichage des cliques dans une liste de mots
# Displaying the cliques in a word list
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

my ($length, $filepath, $histo, $size);

GetOptions("length=i" => \$length,
           "file=s"   => \$filepath,
           "histo"    => \$histo,
           "size=i"   => \$size,
  ) or die "Problem with options";

unless (defined $size) {
  $histo = 1;
}

my %cliques;

open my $f1, '<', $filepath
  or die "opening $filepath: $!";
while (my $word = <$f1>) {
  chomp $word;
  unless (defined $length) {
    $length = length($word);
  }
  if (length($word) == $length) {
    for my $i  (0 .. $length - 1) {
      my $re = $word;
      substr($re, $i, 1) = '.';
      push @{$cliques{$re}}, $word;
    }
  }
}
close $f1
  or die "closing $filepath: $!";

my @histo;
if ($histo) {
  my $max = 0;
  for (keys %cliques) {
    my $nb = 0 + @{$cliques{$_}};
    $histo[$nb]++;
    if ($max < $nb) {
      $max = $nb;
    }
  }
  for my $i (0..$max) {
    printf("%2i %5i\n", $i, $histo[$i] // 0);
  }
}

if ($size) {
  for my $re (sort keys %cliques) {
    my $nb = 0 + @{$cliques{$re}};
    if ($nb >= $size) {
      print join ' ', $re, ':', @{$cliques{$re}}, "\n";
    }
  }
}


=encoding utf8

=head1 NAME

list-cliques.pl -- displaying the cliques in a word list

=head1 VERSION

Version 0.01

=head1 USAGE

  perl list-cliques.pl -l 5 -f ../word-list/liste_francais_asc.txt --histo --size=8

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

=over 4

=item histogram

The program displays  the histogram of the number of  cliques for each
clique size.

=item size

The program displays each clique with  a size greater than or equal to
this parameter.

=back

=head1 DESCRIPTION

The program loads  the words from the file given  in parameters. Words
are filtered according  to their lengths. The  program dispatches each
word into the various cliques it belongs to.

After all words  have been loaded, the program  displays the histogram
of cliques (how many cliques for  such and such size) and the contents
of all cliques with a size above a threshold.

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
