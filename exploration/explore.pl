#!/usr/bin/perl
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Exploration systématique du décodeur mastermind
# Systematic exploration of the Mastermind codebreaker
#
# Copyright 2026 Jean Forget, tous droits réservés
#


use v5.10;
use strict;
use warnings;
use Getopt::Long;
use DBI;
use DateTime;
use YAML;

my ($dbname, $config, $duration);
GetOptions("database=s" => \$dbname
         , "config=s"   => \$config
         , "duration=i" => \$duration
  ) or die "Problem with the options";

unless ($dbname) {
  die "Database name is mandatory";
}

unless ($config) {
  die "Configuration name is mandatory";
}

my @command = qw(perl ../decodeur-mm);
my $end_time        = DateTime->now + DateTime::Duration->new(minutes => $duration);
my $commit_length   = 50;
my $commit_duration = DateTime::Duration->new(minutes => 5);
my $next_commit_dt  = DateTime->now + $commit_duration;
my $next_commit_nb  = $commit_length;

say $end_time;

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbname");
$dbh->begin_work;

my $read_config  = $dbh->prepare(<<'SQL');
select slots, colours, dictionary
from   Config
where  config = ?
SQL

my $result = $read_config->execute($config);
my $param  = $read_config->fetchrow_hashref;
unless ($param) {
  die "Unknown configuration $config";
}

if ($param->{slots}) {
  push @command, "-t", $param->{slots};
}
if ($param->{colours}) {
  push @command, "-c", $param->{colours};
}
if ($param->{dictionary}) {
  push @command, "-d", $param->{dictionary};
}

say join ' ', @command;

my $upd_code   = $dbh->prepare(<<'SQL');
update Code
   set entropy  = ?
     , minimax  = ?
     , datetime = ?
where  config = ?
and    code   = ?
SQL
my $read_codes  = $dbh->prepare(<<'SQL');
select code
from   Code
where  config = ?
and    datetime is null
SQL
$result = $read_codes->execute($config);
my $nb = 0;
while (my $hash = $read_codes->fetchrow_hashref) {
  my $code = $hash->{code};
  my $entropy = 0;
  my $minimax = 0;
  my @out = qx(@command -r $code);
  if ($out[-1] =~ /Gagné en (\d+) coup/) {
    $entropy = $1;
  }
  else {
    die "Problem while solving $code (Shannon's entropy)";
  }
  @out = qx(@command -m -r $code);
  if ($out[-1] =~ /Gagné en (\d+) coup/) {
    $minimax = $1;
  }
  else {
    die "Problem while solving $code (Knuth's minimax)";
  }

  my $now = DateTime->now;
  $upd_code->execute($entropy, $minimax, $now->strftime("%Y-%m-%dT%H:%M:%S"), $config, $code);
  $nb++;

  if ($nb >= $next_commit_nb or $now > $next_commit_dt) {
    $dbh->commit;
    $next_commit_nb = $nb  + $commit_length;
    $next_commit_dt = $now + $commit_duration;
    say  $now->strftime("%Y-%m-%dT%H:%M:%S"), ", commit after $code, next commit at ", $next_commit_dt->strftime("%Y-%m-%dT%H:%M:%S");
    $dbh->begin_work;
  }
  if ($now > $end_time) {
    say "Timed-out at ", $now;
    last;
  }
}

$dbh->commit;

=encoding utf8

=head1 NOM

explore.pl --Systematic exploration of the Mastermind codebreaker

=head1 UTILISATION

Exploring standard Mastermind (4 slots, 6 colours) for 5 minutes

  explore.pl --database=master.db --config=s4c6 --duration=5

=head1 COMMAND LINE PARAMETERS

=over 4

=item * database

Pathname of the SQLite database storing the results of the exploration.

=item * config

Key used in  the database, to tell apart records  coming e.g. from the
Stanford Graph  Base from records  coming from standard  Mastermind (4
slots, 6 colours).

=item * duration

Duration in minutes during which the program will run.

=back

=head1 DESCRIPTION

This program  explores each code  not yet  explored, to find  how many
turns a game would spend if using  the entropy method and if using the
minimax method. The results are stored into the database.

When some  configurations have been  completely explored, you  can run
the following SQL statements to compare entropy and minimax.

  select config, max(entropy) as max_ent
               , max(minimax) as max_mm
               , avg(entropy) as avg_ent
               , avg(minimax) as avg_mm
  from Code
  group by config

  select   config, count(*)
                 , 'minimax faster' as 'which is faster'
                 , avg(entropy)     as avg_ent
                 , avg(minimax)     as avg_mm
  from     Code
  where    entropy > minimax
  group by config
  union
  select   config, count(*)
                 , 'entropy faster'
                 , avg(entropy)
                 , avg(minimax)
  from     Code
  where    entropy < minimax
  group by config
  order by config

=head1 CONFIGURATION AND ENVIRONMENT

Nothing.

=head1 DEPENDENCIES

DateTime and DateTime::Duration

DBI and DBD::SQLite

v5.10

=head1 INCOMPATIBILITIES

No known incompatibilities.

=head1 BUGS AND LIMITS

Exploring a  configuration with  a dictionary  is rather  lengthy. For
example, on my computer, the 930 words with 4 letters from the list of
French words  need around 8 seconds  per code and the  5757 words from
the Stanford Graph Base need about one minute each. The reason is that
the text  file containing  the list  of words is  read twice  per code
(once for  a game with  the entropy method, once  for a game  with the
minimax method).

=head1 AUTHOR

Jean Forget, J2N-FORGET (à) orange.fr

=head1 LICENSE AND COPYRIGHT

Copyright (C) Jean Forget, 2026 all rights reserved.

The  script is  licensed  under the  same terms  as  Perl: GNU  Public
License version 1 or later and Perl Artistic License.


