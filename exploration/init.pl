#!/usr/bin/perl
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Initialisation de l'exploration systématique du décodeur mastermind
# Initialisation for the systematic exploration of the Mastermind codebreaker
#
# Copyright 2026 Jean Forget, tous droits réservés
#


use v5.10;
use strict;
use warnings;
use Getopt::Long;
use DBI;

my ($dbname, $config, $nb_col, $nb_slots, $path_dict);
GetOptions("database=s" => \$dbname
         , "config=s"   => \$config
         , "colours=i"  => \$nb_col
         , "slots=i"    => \$nb_slots
         , "dict=s"     => \$path_dict
  ) or die "Problem with the options";

unless ($dbname) {
  die "Database name is mandatory";
}

unless ($config) {
  die "Configuration name is mandatory";
}

if ($nb_col && $path_dict) {
  die "Cannot use both the number of colours and a dictionary";
}

if ($nb_col && !$nb_slots) {
  die "Number of slots mandatory when using a number of colours";
}

if ($nb_slots && !$nb_col && !$path_dict) {
  die "With the number of slots, you must give either a number of colours or a ditionary";
}

if (!$nb_slots && !$nb_col && !$path_dict) {
  die "Please give at least one parameter describing the configuration : dictionary, number of slots, number of colours";
}

my @codes;
my @colours;
if ($path_dict && $nb_slots) {
  open my $f1, '<', $path_dict
    or die "Ouverture $path_dict $!";
  while (my $word = <$f1>) {
    chomp $word;
    if (length($word) == $nb_slots) {
      push @codes, $word;
    }
  }
  close $f1
    or die "Fermeture $path_dict $!";
}
elsif ($path_dict) {
  my $nb_slots1; # do not use $nb_slots which will be stored (as NULL) in the database
  open my $f1, '<', $path_dict
    or die "Ouverture $path_dict $!";
  while (my $word = <$f1>) {
    $nb_slots1 //= length($word);
    if (length($word) != $nb_slots1) {
      die "Dictionary contains words with varying lengths, you must specify the number of slots";
    }
    chomp $word;
    push @codes, $word;
  }
  close $f1
    or die "Fermeture $path_dict $!";
}
else {
  my $col = 'A';
  for (my $i = 0; $i < $nb_col; $i++) {
    push @colours, $col;
    $col++;
  }
  recursive_fill('', $nb_slots);
}
sub recursive_fill {
  my ($str, $nb) = @_;
  if ($nb == 0) {
    push @codes, $str;
  }
  else {
    for my $col (@colours) {
      recursive_fill("$str$col", $nb - 1);
    }
  }
}

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbname");
$dbh->begin_work;

my $del_config = $dbh->prepare(<<'SQL');
delete from Config where config = ?
SQL
$del_config->execute($config);

my $del_code = $dbh->prepare(<<'SQL');
delete from Code where config = ?
SQL
$del_code->execute($config);

my $ins_config = $dbh->prepare(<<'SQL');
insert into Config (config, slots, colours, dictionary)
       values      (?     , ?    , ?      , ?)
SQL
$ins_config->execute($config, $nb_slots, $nb_col, $path_dict);

my $ins_code = $dbh->prepare(<<'SQL');
insert into Code (config, code)
       values    (?     , ?   )
SQL
for my $code (@codes) {
  $ins_code->execute($config, $code);
}

$dbh->commit;

=encoding utf8

=head1 NOM

init.pl -- Initialisation for the systematic exploration of the Mastermind codebreaker

=head1 UTILISATION

Initialisation for the exploration of standard Mastermind (4 slots, 6 colours)

  init.pl --database=master.db --config=s4c6 --slots=4 --colours=6

Initialisation for the exploration of Word Mastermind (dictionary with words with a single length)

  init.pl --database=master.db --config=sgb --dict=../word-list/sgb-words.txt

Initialisation for the exploration of Word Mastermind (dictionary with words with differents lengths)

  init.pl --database=master.db --config=fr4 --slots=4 --dict=../word-list/liste_francais_asc.txt

=head1 COMMAND LINE PARAMETERS

=over 4

=item * database

Pathname of the SQLite database storing the results of the exploration.

=item * config

Key used in  the database, to tell apart records  coming e.g. from the
Stanford Graph  Base from records  coming from standard  Mastermind (4
slots, 6 colours).

=item * colours

The number  of colours  available for the  code and  the propositions.
This  number  must  be  in  the 3..26  range.  Actually,  colours  are
implemented  as letters.  If using  3 colours,  these colours  will be
`'A'`, `'B'` and `'C'`. If using  26 colours, all the letters `'A'` to
`'Z'` are available.

=item * slots

The number of slots. In other words, the length of the code and of the
various propositions. This number must be in the range 2..5.

=item * dict

The pathname  for a  dictionary. The file  corresponding to  this path
must contain a list of words, one  word per line, and nothing else (no
whitespace except for the linefeeds, no punctuation).

If all words in the dictionary have the same length, parameter `trous`
(slots) is  optional and is automatically  filled with what is  in the
dictionary.  If  the  file  contains  words  with  different  lengths,
parameter `slots` is mandatory.

=back

=head1 DESCRIPTION

This program stores into the database all possible codes applying to a
configuration.

=head1 CONFIGURATION AND ENVIRONMENT

Nothing.

=head1 DEPENDENCIES

DBI and DBD::SQLite

v5.10

=head1 INCOMPATIBILITIES

No known incompatibilities.

=head1 BUGS AND LIMITS

None.

=head1 AUTHOR

Jean Forget, J2N-FORGET (à) orange.fr

=head1 LICENSE AND COPYRIGHT

Copyright (C) Jean Forget, 2026 all rights reserved.

The  script is  licensed  under the  same terms  as  Perl: GNU  Public
License version 1 or later and Perl Artistic License.


