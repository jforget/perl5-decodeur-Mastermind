-*- encoding: utf-8; indent-tabs-mode: nil -*-

# MANUAL PAGE

When I wrote the `decodeur-mm`  program, I used French variable names,
French  keywords  for  command-line parameters,  French  comments  and
French documentation. To  ease the use of my program  for users who do
not  read French,  but understand  the English  language, here  is the
manpage translated  into English. On  the first reading,  some notions
may puzzle you, but they are explained later in the
[chapter DESCRIPTION](#user-content-description).

## Name

`decodeur-mm` -- a program which plays Mastermind as a codebreaker

## Usage

Autonomous run:

```
  perl decodeur-mm -r BEEF
```

The program attempts  to find a 4-slot code using  6 possible colours.
It does not stop  to ask you to evaluate such  and such possible code,
since the answer is `BEEF`. Yet, the program does not cheat.

Interactive run:

```
  perl decodeur-mm
```

With no parameters  at all, the program solves a  problem with 4 slots
and 6 colours. Each turn, it  asks you to evaluate some proposal. Here
is an example with comments:

```
  $ perl decodeur-mm            command line from the human user
  ABCD                          first proposal by the program
  0 2                           the user answers: 0 black mark and 2 white marks
  EFAB                          second proposal by the program
  XO                            the user answers: 1 black mark and 1 white mark
  CFBF                          third proposal by the program
  rien                          the user answers: 0 black mark and 0 white mark (*)
  EDEA                          fourth proposal by the program
  0 3                           the user answers: 0 black mark and 3 white marks
  DAAE                          fifth proposal by the program
  XXXX                          the user answers: 4 black marks
  Gagné en 5 coups !            final message: "I won in 5 turns!"
```

(*) to  prevent entry typos, the  user must type the  string `rien` or
`(rien)` ("nothing"  in French). An  empty answer, meaning  zero black
marks `X` and  zero white marks `O` is most  certainly an entry error.
Another possible answer is `0 0`.

Variants:

Super Mastermind is played with 5 slots and 8 colours. Here is the command line:

```
            $ perl decodeur-mm -t 5 -c 8 -r DEADB
  (or else) $ perl decodeur-mm --trous 5 --couleurs 8 --reponse DEADB
```

Here  is the  same game,  using Knuth's  minimax instead  of Shannon's
entropy, and in verbose  mode, displaying many additional informations
(yet, lists of possible codes are truncated to 50 elements):

```
            $ perl decodeur-mm -t 5 -c 8 -r DEADB -m -v -l 50
  (or else) $ perl decodeur-mm --trous 5 --couleurs 8 --reponse DEADB --minimax --verbeux --longueur 50
```

A game of Word Mastermind, using a dictionary in which all words have the same length:

```
            $ perl decodeur-mm -d word-list/sgb-words.txt
  (or else) $ perl decodeur-mm --dict word-list/sgb-words.txt
```

A game of Word Mastermind, using a dictionary in which the words have different lengths:

```
            $ perl decodeur-mm -t 5 -d word-list/liste_francais_asc.txt
  (or else) $ perl decodeur-mm --trous 5 --dict word-list/liste_francais_asc.txt
```

## Call Parameters

* couleurs

  The number of  colours available for the code  and the propositions.
  This  number must  be  in  the 3..26  range.  Actually, colours  are
  implemented as  letters. If using  3 colours, these colours  will be
  `'A'`, `'B'` and  `'C'`. If using 26 colours, all  the letters `'A'`
  to `'Z'` are available.

* trous

  The number of slots.  In other words, the length of  the code and of
  the various propositions. This number must be in the range 2..5.

* dict

  The pathname for  a dictionary. The file corresponding  to this path
  must contain  a list of words,  one word per line,  and nothing else
  (no whitespace except for the linefeeds, no punctuation).

  If  all words  in the  dictionary  have the  same length,  parameter
  `trous` (slots) is optional and is automatically filled with what is
  in  the  dictionary.  If  the file  contains  words  with  different
  lengths, parameter `trous` is mandatory.

* reponse

  The final  answer, that is, the  code the program must  find. But we
  promise, the  program will  not use these  values when  choosing its
  successive propositions. If  the command line does  not include this
  parameter, the  program will  stop with each  proposition, prompting
  the user for the number of black and white marks.

* entropie | minimax

  The tactic used in the  endgame: either Shannon's entropy or Knuth's
  minimax. Defaults to Shannon's entropy.

* verbeux

  Verbose mode.  The program  displays several informations  about the
  game, such  as the list  of compatible codes,  or the values  of the
  minimax and of the entropy when playing a proposition.

* longueur

  The maximum length  of lists in verbose mode. From  time to time, in
  verbose mode,  the program displays  the list of  remaining possible
  codes. This  list can be very  long. So the `longueur`  parameter is
  used to  truncate this  list when printed.  Internally, the  list is
  still stored  in totality. If you  do not want list  truncation, you
  can give value `0` to this parameter.

## Program Description

See [below](#user-content-description).

## Configuration and Environment

None.

## Requirements

YAML: some debugging statements, usually commented-out with `#`.

v5.10: for statement `say` and operator "defined-or" (`//`).

## Incompatibilities

No known incompatibilities.

## Bugs and Limitations

Entropy values are displayed with an outrageous number of digits after
the decimal point.

When there remains  many compatible codes (for example  when there are
many allowed  colours), choosing  the best proposition  can be  a very
long process.

## Author

Jean Forget, J2N-FORGET (at) orange (dot) fr

## License and Copyright

Copyright (C) Jean Forget, 2011, 2023, 2025, 2026 all rights reserved.

The  script is  licensed  under the  same terms  as  Perl: GNU  Public
License version 1 or later and Perl Artistic License.

# DESCRIPTION

## Foreword

The purpose of this program is to play Mastermind as codebreaker, with
a nearly  optimal strategy. The  absolutely perfect strategy  would be
obtained by building  the tree of all possible plays,  like it is done
for tic-tac-toe and, theoretically,
for chess, and by analysing this tree to find the sequence of plays in
the fewest turns, no matter which is the code to find. Since this is a
tree-search, it can  require an outrageous duration  and an outrageous
amount of memory, even with  alpha-beta pruning. Instead of that, this
program  uses  algorithms  with  low  memory  requirements  and  short
execution times, which  lead to the solution with a  rather low number
of turns, even if this number is not the minimum number of turns.

From time  to time, the  description below mentions  a French-speaking
book,  _Le  Mastermind  en  10 leçons_,  written  by  Marco  Meirovitz
(creator  of Mastermind)  and Jean  Tricot, published  by Hachette  in
1979, ISBN 2.01.005031.2. On Internet,  the first name of Meirovitz is
sometimes given  as Mordechai. Anyhow, I  still call him Marco  in the
text below.

Warning for math-haters:  if you feel nauseous each time  you hear the
word "sinus" or  "cosine", stop reading now. Actually,  this text does
not  deal with  trigonometry, but  with probabilities  and logarithms,
which affect your mind in the same way as trigonometry.

## Game Rules Summary

Mastermind  is  played  by  two   players,  the  _codemaker_  and  the
_codebreaker_. The  codemaker secretly  chooses a combination  of four
colours  within  six possible  colours,  with  duplicates allowed.  He
inserts  the   coloured  pegs  in   four  holes,  screened   from  the
codebreaker's view. Then the codebreaker attempts to guess the code by
choosing  a combination.  He inserts  the  four pegs  into four  holes
visible  from both  players. The  codemaker compares  this combination
with his secret code and announces to the codebreaker how many colours
are located  at the right positions  (using black marks) and  how many
colours are present  in the code, but at other  positions (using white
marks). If the codebreaker has not  found the secret code, he executes
another  turn  by  choosing  another combination  and  by  asking  the
codemaker how  many black and  white marks this new  combination gets.
The codebreaker's aim is to find the  secret code with as few turns as
possible.

For  a balanced  competitive game,  the players  switch roles  and the
former codemaker  attempts to  find a  new code  chosen by  the former
codebreaker. At the  end of this second game, the  players compare the
number of  game turns  of their  respective games to  find who  is the
winner. This is irrelevant in my program.

While the physical game uses coloured pegs, many programs prefer using
simple ASCII  letters, `A` to `F`.  The text you are  reading uses the
same convention,  so you can  read it in  black characters on  a white
background  and browsers  with  speech synthesis  will  give a  useful
rendition of my explanations. Yet,  the text still calls these symbols
"_colours_".  Likewise, black  marks are  displayed as  `X` and  white
marks as `O`.

Example. The codemaker chooses

```
  C F E D
```

and the codebreaker displays

```
  A B C D
```

There is a black mark for `D` in  the fourth slot and a white mark for
`C` in the  code's first slot, but in the  proposal's third slot. Yet,
the codebreaker  does not  know which  colour or  which slot  has been
marked by a black or white mark.

If there  are duplicate colours,  a single  peg can generate  only one
mark, with black marks preempting white marks. Example:

```
  secret code   D A A D
  proposition   A B C D
```

The result is a black mark and a white mark. The `A` in the first slot
of the  propsition matches either  the `A` in  the second slot  of the
code, or the  `A` in the third slot, but  not both simultaneously. The
`D` in the fourth slot of the  proposition can match either the `D` in
the code  first slot,  giving a  white mark,  or with  the `D`  in the
fourth  slot, giving  a  black  mark. In  this  case,  the black  mark
preempts the white  mark. And the final  result is a black  mark and a
white mark.

While  the codemaker  must  choose  his code  within  the six  allowed
colours,  the  codebreaker  may  use a  deliberately  invalid  colour.
Usually, the  codebreaker leaves a  slot empty. Of course,  this empty
slot cannot match any slot in the secret code and it generates neither
a  black  mark  nor  a  white  one. The  program  does  not  use  this
possibility.

Several variants exist for Mastermind.  Basic variants use a different
number of  colours, a  different number  of slots,  or both.  They are
implemented (within reasonable limits) in the program.

Other variants  are meant to  alleviate the codebreaker's task  and do
not require  any additional  equipment. For  example, the  secret code
must contain four different colours, duplicate are not allowed. Or the
codemaker must tell the codebreaker which slot is associated with each
black  or  white mark.  These  variants  are  not implemented  in  the
program.

Lastly,  other variants  alter  the game  mechanisms:
[using not  only colours but also shapes](https://boardgamegeek.com/boardgame/3664/grand-mastermind),
[using letters](https://boardgamegeek.com/boardgame/5662/word-mastermind)
and requiring  that the code  is a valid  word in the  players' native
language,
[etc](https://boardgamegeek.com/boardgamefamily/142/game-mastermind).
These variants are not implemented in the program.

## Timeline of a Typical Game

A game  with a human  codebreaker is  usually divided in  three parts:
overture, middle game and endgame.

During the  overture, the  codebreaker has no  ideas about  the secret
code.  He plays  quite  randomly, yet  taking care  of  using a  broad
approach instead of a detrimentally narrow focus.

During  the middle  game, the  codebreaker  has some  ideas about  the
secret  code. He  builds  a few  hypotheses and  checks them: "Is  red
duplicated or single?", or "Does the black mark from turn 1 match blue
in the first slot or yellow in the third one?".

During the  endgame, the codebreaker  has precise ideas on  the secret
code and there remain only a  few codes compatible with the game until
now. The  codebreaker is  able to  build an  exhaustive list  of these
compatible codes.  His purpose is now  to prune this list  in the most
efficient  way, that  is, using  as few  game turns  as possible.  For
example, the  remaining possibilities are: `ABCD`,  `ABDC` and `BACD`.
If the codebreaker plays `ABCD`, the codemaker will reply with:

* `XXXX` if the secret code is `ABCD`
* `XXOO` if the secret code is `ABDC` ou `BACD`.

On the other hand, if the codebreaker plays `BACD`, the codemaker will
reply with:

* `XXXX` if the secret code is `BACD`,
* `XXOO` if the secret code is `ABCD`,
* `OOOO` if the secret code is `ABDC`.

As you can see, `BACD` (and `ABDC` as well) will give the final result
in at most  2 game turns, while  there is a 1-in-3  chance that `ABCD`
will need a third game turn.

In  the program,  the  middle game  does not  exist.  The program  can
memorise a list of several thousands possible codes, a  feat that a human
player cannot  do. So when  the opening is  over, the program  runs an
interlude (from  "inter" meaning "between" and  "lude" meaning "game")
and builds the  list of codes compatible with the  opening game turns.
Then the program starts the endgame.

Another difference between my program and a game between human players
is that  my program considers  that all  possible codes have  the same
probability. In  their book, Tricot  and Meirovitz tell  their readers
that  a   human  codemaker  will  unconsciously   reject  some  colour
combinations and prefer other combinations. Also, a single-colour code
has  a  theoretical probability  of  6-in-1296,  or 1-in-216,  with  a
cybernetic  codemaker,  but a  much  lower  probability with  a  human
codemaker.

Note: because of  tradition, an old charter or something,  a full game
is usually  displayed with the first  turn at the bottom  and the last
turn at  the top. This  is the way games  are printed in  Tricot's and
Meirovitz' book. I do the same in this documentation.

Second note: when typing the  program parameters, the user can specify
the path  for a text file  containing words. With this  parameter, the
program acts as a codebreaker for
[Word Mastermind](https://boardgamegeek.com/boardgame/5662/word-mastermind).
In this case, there are neither  overture nor interlude, but a prelude
which reads  the text files and  stores into its memory  the available
words.  If the  user  has typed  a "number  of  slots" parameter,  the
program filters  the text file  to keep only  the words with  a length
matching this  parameter. If the  use has  typed no "number  of slots"
parameter, the program checks that all words in the text file have the
same  length  (which will  give  a  value  to  the "number  of  slots"
parameter).

## Overture

The  book from  Tricot  and Meirovitz  examines  the various  starting
propositions from the game with 4 pegs  and 6 colours and for the game
with 4 pegs and 7 colours.  For the 6-colour game, the openings `ABCD`
and `ABCC` have  more or less the same efficiency.  On the other hand,
for the 7-colour  game, the best opening is `ABCD`.  Using the rule of
the thumb, I  think that the best opening for  a _n_-colour game, with
$n \ge  4$ is  `ABCD` on the  first turn, `EFGH`  on the  second turn,
`IJKL` on the  third, and so on.  If we reach the last  colour, we may
roll over to the first colours  to generate a full length proposition.
For example, with the 6-colour game,  the rollover would happen on the
second turn with `EFAB`, that is the  last two colours `E` and `F` and
a rollover with the first two colours `A` and `B`.

During the opening phase, each time a proposition gets zero marks, the
colours  are  removed from  the  list  of  possible colours.  Thus,  a
20-colour game can become a simpler 16-colour game or even a 12-colour
game. The interlude will be accordingly faster.

Important remark:  during the opening, the  various propositions never
share colours, except for the first  proposition and the last (the one
with rollover). For example, with the 26-colour game, the propositions
are `ABCD`,  `EFGH`, `IJKL`, `MNOP`,  `QRST`, `UVWX` and  `YZAB`. Only
`ABCD` and `YZAB`  share some colours. The reason why  it is important
will be given later.

The program leaves the overture in any of the following cases:

<ul>

<li>
When a proposition is marked with 4 blacks, that is, when it has found
the secret code.  This victory owes everything to luck  and nothing to
skill, but you have to take this possibility into account.
</li>

<li>
When all the  colours have been tried, that is,  when rollover occurs.
We think  that the game  turns already  played will give  a sufficient
amount of information so the list  of all possible codes will not have
an enormous size.
</li>

<li>
When all the  game turns already played have a  cumulative result of 4
marks (no matter black or white). Example

<pre>
    IJKL OO
    EFGH X
    ABCD O
</pre>

It is  obvious that  the next propositions  `MNOP`, `QRST`  and `UVWX`
will each get zero marks. Playing them is a waste of time. The program
runs the interlude and builds the list of compatible codes.
</li>

<li>
When all the  game turns already played have a  cumulative result of 3
marks (no matter black or white). Example:

<pre>
    IJKL O
    EFGH X
    ABCD O
</pre>

The  propositions `MNOP`,  `QRST` and  `UVWX` can  only receive  a low
rating: `X`, `O` or nothing. Playing  them until getting `X` or `O` is
most certainly  a waste of  time. The  program runs the  interlude and
builds the  list of compatible  codes. This  list will be  much bigger
than  in the  case above,  but hopefully  still manageable.  Then, the
program  can go  on with  a wider  range of  markings and  therefore a
faster solution.
</li>

</ul>

The  cumulative result  is  computed with  a "synthetic"  proposition,
which is  the concatenation of  all game  turns that have  received at
least one  marking, no  matter black  or white. Why  do we  build this
synthetic proposition instead of just adding the `$nb` results? (`$nb`
is the program variable counting all black and white marks.) This will
be explained in the description of the interlude.

### Example

If the way the `@coul`  and `%coup_synthetique` variables are used
is not clear, here is an example  that will explain the "how" (but not
yet the "why") in a game with 4 slots and 26 colours.

Variable `%coup_synthetique` (synthetic game turn) is a hashtable with
key `code` for  the proposition, key `n` (for _noir_  = black) for the
number of black marks, key `b` (for _blanc_ = white) giving the number
of white marks  and key `nb` for  the total number of  black and white
marks. It is initialised with:

```
  %coup_synthetique = (code => '', n => 0, b => 0, nb => 0 )
```

Variable `@coul` (for  _couleurs_ = "colours") is a  plain char array,
containing all possible colours in the current game. It is initialised
with:

```
  @coul = qw<A B C D E F G H I J K L M N O P Q R S T U V W X Y Z>
```

First game turn is `ABCD`, which gets no marks. The game is simplified
to a 22-colour game:

```
  @coul = qw<E F G H I J K L M N O P Q R S T U V W X Y Z>
  %coup_synthetique = (code => '', n => 0, b => 0, nb => 0 )
```

Second game turn is `EFGH`, which gets a black mark and a white mark.

```
  @coul = qw<E F G H I J K L M N O P Q R S T U V W X Y Z>
  %coup_synthetique = (code => 'EFGH', n => 1, b => 1, nb => 2 )
```

Third game turn is `IJKL`, which gets no marks:

```
  @coul = qw<E F G H M N O P Q R S T U V W X Y Z>
  %coup_synthetique = (code => 'EFGH', n => 1, b => 1, nb => 2 )
```

Fourth game turn is `MNOP`, which gets  a black mark and a white mark.
Because the  synthetic game turn is  no longer empty, these  marks are
registered in the synthetic game turn as white marks:

```
  @coul = qw<E F G H M N O P Q R S T U V W X Y Z>
  %coup_synthetique = (code => 'EFGHMNOP', n => 1, b => 3, nb => 4 )
```

## Interlude

In the interlude, the program builds  the list of all codes compatible
with the  already played game turns.  The codes are built  and checked
step-by-step: first  incomplete codes  with a  single peg,  then codes
with two  pegs, then codes with  three pegs and lastly  complete codes
with four pegs.

At each step, the incomplete code is matched against all played
game turns, to check if the result (number of black marks and
number of white marks) are compatible. Keep in mind that the
candidate code is incomplete. When adding a new peg, we can

* keep the current marking,
* get an additional black mark,
* get an additional white mark,
* replace a white mark with a black mark.

For a code with 3 filled slots and 1 empty slot, the current number of
black marks must  be equal to the  final number of black  marks, or to
the final  number minus one.  Instead of  testing the number  of white
marks, we test the sum black marks + white marks (`$nb` because of the
French-speaking mnemonics: `n`  for _noir_ = black, `b`  for _blanc_ =
white).  The current  `$nb` value  must be  equal to  the final  `$nb`
value, or to the final value minus 1.

For a code with 2 filled slots and 2 empty slots, the current value of
`$n` (the  number of  black marks)  must be in  the interval  from the
final `$n` value back to the final  `$n` value minus 2. Same thing for
the `$nb` values.

And for a code with 1 filled slot and 3 empty slots, the current value
of `$n` (the number  of black marks) must be in  the interval from the
final `$n` value back  to the final `$n` value minus  3. And as above,
this is the same thing for the `$nb` values.

In this way, by building 1-slot  codes, then 2-slot codes, then 3-slot
codes and the  4-slot codes, we do  not need to walk the  full tree of
propositions,  we  can prune  it  on  the  go.  Building the  list  of
compatible codes takes less time.

Examples: one game  turn used code `ABCD` with marking  `X` (one black
mark). Partial code  `AE..` gets marking `X`, which  is compatible. On
the other hand,  partial code `AD..` gets marking `XO`  which shows it
is not  compatible. No  matter which  colours are  added to  the still
empty slots, we cannot  get back to a marking `X`.  Code `CE..` gets a
marking `O`. Although there is a  white mark for this partial code and
none for the  already played gameturn, this is  compatible because the
white mark can be  later replaced with a black one,  when we will test
`CEC.` and then `CECC` and `CECE` (among others).

Now suppose that the proposition `ABCD` got a marking `XOO` (one black
mark and  two white marks).  Code `AE..`  receives marking `X`  and is
compatible. There are still two empty slots and these slots can be the
places  generating  the  missing  white  marks.  On  the  other  hand,
proposition `EF..`  receives an empty  marking and is  not compatible.
The  two empty  slots are  not enough  to generate  the three  missing
marks.

Remark:  because   it  leads  to   a  simpler  program,   the  partial
propositions are  filled right-to-left: `...A`,  `...B` and so  on for
the first generation, then `..AA`, `..AB` ... `..BA`, `..BB` and so on
for the second generation.

### Use of the Synthetic Game Turn

Another remark.  This is an  example with a game  with 4 slots  and 26
colours. Let us suppose that the first three turns are:

```
    IJKL X
    EFGH X
    ABCD X
```

In the  first generation,  you will  have 26  partial codes  with each
letter in  the alphabet:  `...A` to  `...Z`. So far,  so good.  In the
second generation, we  have among others partial codes  such as `..MN`
or `..NO`.  These partial codes  are compatible with the  three played
turns, when  considered separately. But  they are not  compatible with
the three played turns when considered as  a whole. It is OK to have a
proposition with one  colour among `M` .. `Z`, but  we cannot have two
such colours. A human can see immediately that a proposition must have
one `A` .. `D` colour, plus one `E` .. `H` colour, plus one `I` .. `L`
colour, which gives no longer room for  two colours in `M` .. `Z`. The
program  is not  able to  make  this analysis.  Fortunately, with  the
synthetic game turn

```
  %coup_synthetique = (code => 'ABCDEFGHIJKL', n => 1, b => 2, nb => 3 )
```

the program  will be able  to determine  that a proposition  must have
three colours  among `A` ..  `L`, and  a partial proposition  with two
empy slots must have at least one colour among `A` .. `L`. Thus `..MN`
and `..NO` are incompatible. The  synthetic turn cannot reject `..AB`,
but this proposition has already been rejected when compared with game
turn `ABCD` and its single black mark.

The synthetic turn cannot contain the  game turn in which the rollover
occurs. We  must stop immediately  before this  game turn. Here  is an
example with  a 6-colour game.  The solution  is `ABEE` and  the first
game turns are

```
EFAB OOO
ABCD XX
```

Let us suppose that the synthetic code contains the rolling-over game turn:

```
  %coup_synthetique = (code => 'ABCDEFAB', n => 2, b => 3, nb => 5 )
```

How can  we have  five marks  (black +  white) in  a 4-slot  game? The
reason of this  failure is that the `A`  in slot 1 in game  turn 1 and
the `A` in slot 3  in game turn 2 both match the `A`  in slot 1 in the
solution. Likewise, the  `B` in slot 2  of game turn 1 and  the `B` in
slot 4 of  game turn 2 both match  the `B` in slot 2  of the solution.
Thus, the  synthetic code must  not contain duplicate colours  and the
rolling-over game  turn must  be avoided  when building  the synthetic
game turn.

Then  a new  difficulty arises,  with  a special  case which,  however
special, is  still valid. The first  _n_ - 1 game  turns received zero
black  marks and  zero  white marks  and  only the  _n_  th game  turn
receives marks. Example with a 10-colour game:

```
IJIJ XOO
EFGH -
ABCD -
```

In this case the synthetic game turn still has its initial value:

```
  %coup_synthetique = (code => '', n => 0, b => 0, nb => 0 )
```

The interlude process must not use the synthetic turn, which would
trigger a warning `substr outside of string`.

Anyhow, with the `IJIJ` game turn and with variable `@coul` containing
`qw<I  J>`   and  nothing  more,   the  building  of   the  compatible
propositions will be very fast.

When the list of possible codes is built, the program matchs each code
with each  other and stores  the markings  in a hashtable  with 2-tier
keys. As you will see during  the endgame, the program needs all these
markings at least once, but usually several times, so we compute these
markings once for all.

Actually,  this was  the way  a previous  version of  the program  was
working. A better  way is to cache the various  results of the `noter`
subroutine. The cache is emptied at  the end of the interlude, because
the interlude  has filled this cache  with partial codes and  with the
synthetic code in addition to valid 4-slot propositions.

## Endgame

During the endgame, a game turn looks like:

* The program chooses the most selective proposition among the list of
possible ones.

* The program plays this code.

* If the program gets `XXXX`, the game ends here and now.

* Else, the program filters the list  of possible codes to select only
those which are compatible with the new result.

* If the  hashtable `%notes`  has not  been generated  yet and  if the
number of  compatible codes  is below  the limit  `$limite_notes`, the
program generates this  hashtable, which will speed up  the next calls
to the choice function `choisir`.

Playing a  code and  filtering the list  need no  additional comments.
Choosing  the most  selective  proposition is  much more  interesting.
There are at least two methods. The  one I have read about in Tricot's
and Meirovitz'  book uses  a formula  which, as I  learned later  in a
course about  transmission of data,  is called "the  Shannon entropy".
The second one, which I discovered only in late 2011, when reading the
documentation for
[Algorithm::MasterMind](https://metacpan.org/pod/Algorithm::MasterMind)
has been described by Donald Knuth and uses minimax (yet, now in 2025,
I no longer find any mention of minimax in this module).

### Code Sampling

Choosing the  most selective proposition  requires a double  loop over
the list of  compatible propositions. If the list is  a little big, it
may take a looooooong time. To avoid this, the program will sample the
list of compatible  propositions and it will run the  double loop over
this sample. We are not sure to  find the minimax or the best entropy,
but we can hope we will find something not far from it.

The program defines a limit on  the number of propositions to process,
stored in  the variable `$limite_notes`.  If the number  of compatible
propositions is  lower than or equal  to this limit, the  program uses
the whole list.

Now suppose  that the limit is  100 and that there  are 234 compatible
propositions. The sampling will take  1 proposition out of every 2.34.
In other words, the program will take:

* the proposition at index 0,

* the proposition at index 2.34, rounded down to 2,

* the proposition at index 2 × 2.34 = 4.68, rounded down to 4,

* the proposition at index 3 × 2.34 = 7.02, rounded down to 7,

* the proposition at index 4 × 2.34 = 9.36, rounded down to 9,

and so on. The sample is stored into `@echantillon_poss`.

The following 26-colour game

```
  IJKL O
  EFGH O
  ABCD O
```

yields a  list of 9270 compatible  propositions. With a limit  of 2000
codes, the program  runs 4 million iterations instead  of 85 millions.
On my computer, this represents about 20 seconds.

Beware of this pitfall. In the following 26-colour game

```
  IJKL O
  EFGH O
  ABCD O
```

the end of the interlude and the first lines of the endgame are:

```
9720 codes
07:35:13 début du choix
Liste des possibilités échantillonnée (1 sur 4.86)
meilleure entropie RAJG avec 2.33432868885235 (max : 782)
son histogramme : XXXX: 1, XXX: 4, XXO: 10, XX: 56, XOOO: 1, XOO: 24, XO: 133, X: 272, OOO: 12, OO: 182, O: 523, (rien): 782
minimax FRBJ avec 725 (entropie 2.25283449338101)
son histogramme : XXXX: 1, XXX: 2, XXOO: 2, XXO: 5, XX: 52, XOOO: 1, XOO: 9, XO: 112, X: 313, OOO: 9, OO: 157, O: 612, (rien): 725
07:35:33 fin du choix
4 : je joue RAJG
```

this translates to

```
9720 codes
07:35:13 start choosing
The list of compatible codes is sampled (1 for every 4.86)
best entropy RAJG with 2.33432868885235 (max : 782)
histogram : XXXX: 1, XXX: 4, XXO: 10, XX: 56, XOOO: 1, XOO: 24, XO: 133, X: 272, OOO: 12, OO: 182, O: 523, (nothing): 782
minimax FRBJ with 725 (entropy 2.25283449338101)
histogramme : XXXX: 1, XXX: 2, XXOO: 2, XXO: 5, XX: 52, XOOO: 1, XOO: 9, XO: 112, X: 313, OOO: 9, OO: 157, O: 612, (nothing): 725
07:35:33 stop choosing
4 : I play RAJG
```

The histogram for `RAJG` applies only  to the 2000-code sample, not to
the full  9720-code list. If  you answer `XX`  (or `2 0`),  the filter
will yield  218 propositions instead of  56. If you answer  `0 0`, you
will not have just 782 remaining propositions, but 3883 propositions.

### The Shannon Entropy

At the beginning, entropy was  a concept in physics, more specifically
thermodynamics. Entropy  was brought  in by Clausius  (1822--1888) and
was computed  by dividing the  heat by the absolute  temperature. This
concept  has  been developped  by  Ludwig  Boltzmann (1844--1906)  who
described it as the number of microstates for each macrostate. Shannon
(1916--2001) has reused this concept in mathematics, when studying how
to encode  a message  to transmit  it through a  data channel  with or
without noise. The formula from Shannon is:

$$
S = - \sum p_i \times \log_2(p_i)
$$

Jean Tricot  and Marco Meirovitz  applied this concept  to Mastermind,
without giving any details and  even without using the word "entropy".
Here  is a  description of  the mathematical  entropy. This  is not  a
strict mathematical lesson using  formal reasoning and demonstrations,
this  is rather  a naive  approach  targetting an  audience using  its
intuition.

Let  us  put aside  Mastermind  and  examine  another game,  based  on
questions and answers: number guessing. The codemaker secretly chooses
a number  between 1 and 100.  The codebreaker gives a  number, e.g. 50
and the codemaker must  answer if this is the right  number, or if the
code is  greater than  50, or  lower than  50. Now  we alter  the game
rules. First the interval is 0..255  instead of 1..100, and second the
questions are more diverse.

The codebreaker first asks "Is the number in the 0..127 interval or in
the 128..255 interval?". In one  case, the codebreaker learns that the
high-order bit is  0, in the other case he  learns that the high-order
bit is 1. Both answers has  a probability 1/2 and both answers provide
1 bit.

We suppose now that the codebreaker asks "Is the number odd or even?".
In this  case, both answers  have a  probability 1/2 and  both answers
provide 1  bit, the difference  being that they provide  the low-order
bit.

The codebreaker  asks "Is the number  in the 0..63 interval?".  If the
answer is  yes, the codebreaker has  found two bits at  once. But this
"yes" answer has a probability 1/4.  The codebreaker can even asks "Is
the number equal to 23?" and  a "yes" answer, probability 1/256, would
provide all 8 bits at once.

And now,  the question is  "Is the number  in the 0..84  interval?". A
"yes" answer  would give  the exact  value of  the high-order  bit and
would give strong hints on the value of the next-to-high-order bit. We
are sure that  the number begins with "0" and,  without being certain,
we are very  confident it begins with "00". The  codebreaker has found
more than 1 bit,  but less than 2. We will  consider that this answer,
with a  probability 1/3, provides  1.58 bit. This gives  the following
table:

  | probability of answer | received information |
  |:----------:|:----------:|
  |    1/2     |   1 bit    |
  |    1/4     |   2 bits   |
  |    1/256   |   8 bits   |
  |    1/3     | 1.58 bit   |
  |    p_i     | -Log_2(p_i)|

A question can be considered as a range of answers, each with a higher
or  lower  probability.  Suppose  that   the  first  question  of  the
codebreaker is "Is the number in the 0..63 interval, or in the 64..127
interval  or in  the 128..255  interval?".  The answer  "0..63" has  a
probability  1/4  and  gives  2  bits.  The  answer  "64..127"  has  a
probability  1/4  and  gives  2  bits. The  answer  "128..255"  has  a
probability 1/2 and gives only 1 bit. On average, the codebreaker will
receive 1/4 x 2 + 1/4 x 2 +  1/2 x 1 = 1,5 bit. More generally, if the
probabilities  of  the  various  answers  are  $p_i$,  the  amount  of
information received after the question is:

$$
S = - \sum p_i \times \log_2(p_i)
$$

If I may use pedantry, I would add that we can use Neperian logarithms
instead  of binary  logarithms. The  result  can no  longer be  called
"bits", but,  if I remember  correctly, "shannons". Yet, this  unit of
measure is rarely if ever used, including in theoretical papers on the
subject.

Back to Mastermind.  When the codebreaker plays a  possible code, this
is  similar to  a  question  in the  number  guessing  game. When  the
codebreaker  "asks" `ABCD`  or  `BACD`, the  codemaker "answers"  with
markings such as  `XXXX`, `XXOO`, `XXX` and so on.  The probability of
each  answer is  proportional to  the  number of  codes matching  this
marking. With these probabilities, we can compute an entropy.

Suppose that  the list of  possible codes contains `ABCD`,  `ABDC` and
`BACD`.  Depending  on  the codebreaker's  question,  the  codemaker's
answers will be

```
  +----------+---------+--------------+-------------+------------+
  | Question | Answers | Codes        | Probability | Entropy    |
  +----------+---------+--------------+-------------+------------+
  |   ABCD   |   XXXX  | ABCD         |    1/3      |            |
  |          +---------+--------------+-------------+            |
  |          |   XXOO  | ABDC /  BACD |    2/3      |  0,92 bit  |
  +----------+---------+--------------+-------------+------------+
  |   BACD   |   XXXX  | BACD         |    1/3      |            |
  |          +---------+--------------+-------------+            |
  |          |   XXOO  | ABCD         |    1/3      |            |
  |          +---------+--------------+-------------+            |
  |          |   OOOO  | ABDC         |    1/3      |  1,58 bit  |
  +----------+---------+--------------+-------------+------------+
  |   ABDC   |   XXXX  | ABDC         |    1/3      |            |
  |          +---------+--------------+-------------+            |
  |          |   XXOO  | ABCD         |    1/3      |            |
  |          +---------+--------------+-------------+            |
  |          |   OOOO  | BACD         |    1/3      |  1,58 bit  |
  +----------+---------+--------------+-------------+------------+
```

We can see that codes `BACD`  and `ABDC` provide more information than
`ABCD`. So the decoding program will play `BACD` or `ABDC`.

If the probabilities apply to a  set with $N$ elements, partitioned in
classes with $n_i$ elements each, that is, if
$p_i = \frac{n_i}{N}$ with $N = \sum n_i$,
then after a few elementary algebraic transformations, the entropy can
be computed with

$$
S = \log_2 \left( N \right) - \frac{ \sum n_i \times \log_2\left(n_i\right)}{N}
$$

### Knuth's Minimax

This method  is much simpler (and  much less fun to  explain). When we
tally how many markings of each  kind are generated for each remaining
possibility, we note the maximal number we find. Then we compare these
remaining  possibilities according  to  these maximal  numbers and  we
select the possibility  with the lowest maximal number.  With the same
example as above, we have:

```
  +----------+----------+--------------+--------+---------+
  | Question | Answers  | Codes        | Number | Maximum |
  +----------+----------+--------------+--------+---------+
  |   ABCD   |   XXXX   | ABCD         |    1   |         |
  |          +----------+--------------+--------+         |
  |          |   XXOO   | ABDC /  BACD |    2   |    2    |
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

As  with Shannon's  entropy, we  must avoid  playing `ABCD`,  and play
either `BACD` or `ABDC` instead.

With  this very  simple case,  the entropy  criterion and  the minimax
criterion  have  the  same  result. In  more  complicated  cases,  the
criteria can differ.  In an annex in their book,  Tricot and Meirovitz
give an  analysis for the first  game turn in a  4-slot 6-colour game.
Code `ABCD` has the best entropy,  3.05 bits, but with a minimax equal
to 312  with marking `OO`.  On the other  hand, code `ABCC`  is better
with Knuth's  criterion, the  `O` marking  giving only  276 compatible
codes,  while its  Shannon entropy  is a  little lower,  3.04 bits.  A
hundredth of a bit  is very small, but it proves  that the criteria do
not always agree.

What is the best  criterion? I do not know. I think  it depends on the
circumstances. In some cases, entropy  will be better than minimax and
in other  cases, minimax  will be  better than entropy.  If we  take a
comparison with sports or wargames, Shannon plays to grab the victory,
while Knuth plays to avoid defeat.  Note that a player can use minimax
on one  game turn and entropy  on the next  turn in the same  game. My
program sticks with one criterion, though.

Actually, my  program uses both  criteria. One is the  main criterion,
the other is  the tie-breaking criterion. This can be  useful when the
main criterion is minimax. If two compatible codes have the same value
for the  minimax criterion, the  program compares their  entropies. On
the other hand, the entropies are  computed with 10 decimal digits. So
if the  main criterion is  entropy, if  two compatible codes  have the
same entropy within  one ten-billionth bit, that means  that they have
the same histogram of markings, therefore the same minimax value.

## Remark

When designing  this program, I posited  that the search for  the most
selective proposition  could be  restricted to  the list  of remaining
possibilities. I was ready to admit that an incompatible code could be
more selective than any compatible code, but only with a narrow margin.
I was wrong. Here is an example with 4 slots and 26 colours. The first
turn is:

```
  ABCD XXX
```

The program cancels  codes `EFGH`, `IJKL`, `MNOP`,  `QRST`, `UVWX` and
`YZAB`, leaves  the overture, switches  to the interlude and  builds a
list of 100 compatible codes. Using the regexp syntax, these 100 codes
are `ABC[^D]` (25), `AB[^C]D` (25), `A[^B]CD` (25) and `[^A]BCD` (25).
Among these 100  codes, the 88 codes without repetition  have the same
markings histogram:

```
  XXXX: 1, XXX: 24, XXO: 3, XX: 72
```

and thefore the name entropy (1.05 bit) and the same minimax (72). The
program plays `ABCE` and gets `XXX`.  There are now only 24 compatible
codes, `ABC[A-CF-Z]`. All have the same histogram,

```
  XXXX: 1, XXX: 23
```

With  the method  consisting in  finding  a selective  code among  the
possible ones, we will have to try all 23 codes in turn, until we find
the solution.  On the  other hand,  if we  use a  code like  `FGHI` or
`JKLM`, we can remove 4 codes each turn (or with a little luck, remove
all but three, or even remove all but one).

So we  must include some incompatible  codes in the list  of candidate
propositions. To keep the computation short,  we do not try all $26^4$
possible  codes, but  only  those that  would have  been  used in  the
overture, if it had not been interrupted after game turn 1.

Does it mean that the decision to end the overture when we have have a
cumulative result  of 3 black and  white marks is wrong  and should be
removed?  No.  The  `EFGH`,  `IJKL`  and  other  codes  are  still  in
competition with  the compatible  codes (`ABC[A-CF-Z]` in  the example
above).

### More About the Cache

The basic way of work of the  cache is the following. When the program
calls the  `noter` function to  match propositions `ABCD`  and `BDEF`,
the `noter` function  first searchs the `%notes` hashtable  to find an
element  `$notes{ABCD}{BDEF}`.  Failing  that, it  looks  for  element
`$notes{BDEF}{ABCD}`. Failing  that, it  computes the number  of black
and white marks and stores them into `$notes{ABCD}{BDEF}`.

First  special  case. During  the  interlude,  the program  calls  the
`noter` subroutine with partial codes and with the synthetic code. The
results  are stored  into  the cache,  but they  are  useless for  the
endgame. For example, the cache may contain:

```
$notes{ABCD}{'...A'}
$notes{ABCD}{'..AA'}
$notes{ABCD}{'...B'}
$notes{ABCDEFGHIJKL}{'...A'}
$notes{ABCDEFGHIJKL}{'..AA'}
```

Other  elements involve  a  real code  which has  been  played in  the
overture (`ABCD`,  `EFGH`, ...) with  a full proposition that  will be
added  to variable  `@poss`. Even  these cache  elements are  useless,
because  the overture  codes will  never be  used after  the interlude
ends.  For these  reasons, the  cache  is emptied  at the  end of  the
interlude.

Second  special  case.  During  the  endgame,  the  list  of  possible
propositions is  regularly filtered,  to remove propositions  which do
not match the  most recent game turn. Theoretically,  we should remove
these  filtered-out  propositions from  the  cache.  Suppose that  the
filtered-out code is `BCBF`. This code  may appear as a level-1 key or
as a level-2 key in the cache:

```
$notes{BCBF}{AEDF}
$notes{BCBF}{BADE}
$notes{CDAF}{BCBF}
$notes{AADF}{BCBF}
```

The `filter` subroutine  deletes the elements in  which `BCBF` appears
at level 1, because we need a single

```
delete $notes{BCBF};
```

to   remove  in   a  single   strike  elements   `$notes{BCBF}{AEDF}`,
`$notes{BCBF}{BADE}` and  the like. On the  other hand, if we  want to
remove `$notes{CDAF}{BCBF}`, `$notes{AADF}{BCBF}` and similar, we need
to  loop over  the cache,  which wastes  time. So  we prefer  to waste
memory.  Anyway,  these  elements  will be  deleted  and  their  space
recovered when `CADF` and `AADF` are filtered out.

In  the same  way,  once the  filtering is  done,  the cache  elements
containing the most recently played code are useless, so the `filtrer`
subroutine deletes the  cache elements in which the played  code is at
key level 1.

## Annex 1: Entropy or not Entropy?

In _Science  of Discworld II the  Globe_, by T. Pratchett,  I. Stewart
and J.  Cohen, the authors  say that  Shannon called the  new quantity
"entropy" because  the formula  for the  information quantity  was the
same as the formula for Boltzmann's  entropy, except for a minus sign.
According to them,  the information quantity and the  entropy are used
in different contexts, therefore they  cannot be the same quantity and
the use  of "entropy" by  Shannon is not valid.  You can find  this on
page  192, chapter  "bit  from it"  in _Science  of  Discworld II  the
Globe_, ISBN 009 188273 7, published by Ebury Press.

You may agree,  you may disagree. I disagree. Some  words have several
meanings, depending on the context. For example, I have been told that
the  English word  "set" has  many  many different  meanings. Being  a
native French-speaker  and not a  native English-speaker, I  will give
the example of the French word _tension_. This word can mean:

1. blood pressure in a medical context (_tension artérielle_),

2. tensile strength of a I-beam or of a rope in a mechanical context,

3. in an hydrostatic context, something which I do not understand very
well,  but which  allows  the existence  of water  drops  and of  soap
bubbles (_tension superficielle_),

4. electric voltage (_tension électrique_),

5. in a psychological context, hidden hostility or unresolved insecurity,

6. in  an economical context,  a threat  of shortage (e.g.  _métier en
tension_, possible shortage of manpower in a profession),

and most certainly many other meanings...

So if the  word _tension_ has several different  meanings depending on
the context, why  not use the word "entropy" in  different contexts to
designate different concepts?

## Annex 2: Mastermind with understandable words

In this repo, codes are nothing  more than lumps of 5 letters, without
any meaning in any language. On the other hand, Mastermind has a
[variant](https://boardgamegeek.com/boardgame/5662/word-mastermind)
in which the hidden code and  the various propositions must be present
in some dictionary.

I made an experiment, using the
[word list](https://github.com/ascherer/sgb/blob/master/words.dat)
from [Stanford GraphBase](https://www-cs-faculty.stanford.edu/~knuth/sgb.html),
the list of words used in the game "Master Mot" from the French magazine Télé 7 Jeux.
(see [another project](https://github.com/jforget/apl-Master-Mot/blob/master/master.en.md))
and the list of French words from
[Freelang.com](https://www.freelang.com/).

The  word list  from  Stanford GraphBase  includes  5757 words,  which
corresponds to 12.5 bits. For a  game with both black and white marks,
the  best word  is  "tares" giving  3.39 bits  or  "tales" giving  the
924-word minimax. For a game with only black marks without white ones,
the  best word  is  "cares" providing  1.69 bit  or  "bares" with  the
2331-word minimax.

The  list of  words  from the  various Master  Mot  problems from  T7J
includes 1569 words, which gives 10.6 bits. For a game with both black
and white  marks, the best  word is "serie"  giving 3.22 bits  and the
277-word minimax. For a game with only black marks without white ones,
the best word is "panee" providing  1.60 bit and the 665-word minimax.
But unless you  have copied (for personal purposes) the  very same T7J
problems as me, you cannot reproduce this test.

For the 930 4-letter words in  the Freeland.com word list, the entropy
is 9.86  bits. The  best word is  "raie" with 2.92  bits and  with the
199-word minimax (B&W marks), or "pare"  with 1.54 bit and "soie" with
the 421-word minimax  (black marks only). For the  1939 5-letter words
(10.92 bits),  the best words are  "serie" with 3.33 bits  and "porte"
with the 801-word minimax (B&W  marks) or "carte", "perte" and "porte"
with  1.69 bit  and "caire"  with  the 770-word  minimax (black  marks
only).

# License and Copyright

Copyright (c) Jean Forget, 2025, 2026, all rights reserved.

This  text is  licensed  under  the terms  of  Creative Commons,  with
attribution and share-alike (CC-BY-SA).

The accompanying script is licensed under the same terms as Perl: GNU
Public License version 1 or later and Perl Artistic License.
