-*- encoding: utf-8; indent-tabs-mode: nil -*-

# DESCRIPTION

## Foreword

The purpose of this program is to play Mastermind as codebreaker, with
a nearly  optimal strategy. The  absolutely perfect strategy  would be
obtained by building  the tree of all possible plays,  like it is done
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
a black mark nor a white one.

Several variants exist for Mastermind.  Basic variants use a different
number of  colours, a  different number  of slots,  or both.  They are
implemented (within reasonable limits) in the program.

Other variants  are meant to  alleviate the codebreaker's task  and do
not require  any additional  equipment. For  example, the  secret code
must contain four different colours, duplicate are not allowed. Or the
codemaker must tell the codebreaker which slot is associated with each
black  or  white mark.  These  variants  are  not implemented  in  the
program.

Lastly,  other variants  alter  the game  mechanisms:  using not  only
colours but also shapes, using letters  and requiring that the code is
a valid word in the players'  native language, etc. These variants are
not implemented in the program.

## Timeline of a Typical Game

A game  with a human  codebreaker is  usually divided in  three parts:
overture, middle game and endgame.

During the  overture, the  codebreaker has no  ideas about  the secret
code.  He plays  quite  randomly, yet  taking care  of  using a  broad
approach instead of a detrimentally narrow focus.

During  the middle  game, the  codebreaker  has some  ideas about  the
secret  code. He  builds  a few  hypotheses and  check  them: "Is  red
duplicated or single?", or "Does the black mark from turn 1 match blue
in the first slot or yellow in the third one?".

During the  endgame, the codebreaker  has precise ideas on  the secret
code and there remain only a  few codes compatible with the game until
now. The  codebreaker in  able to  build an  exhaustive list  of these
compatible codes.  His purpose is now  to prune this list  in the most
efficient  way, that  is, using  as few  game turns  as possible.  For
example, the  remaining possibilities are: `ABCD`,  `ABDC` and `BACD`.
If the codebreaker plays `ABCD`, the codemaker will reply with:

* `XXXX` if the secret code is `ABCD`
* `XXOO` if the secret code is `ABDC` ou `BACD`.

On the other hand, if the codebreaker plays `BACD`, the codemaker will
reply with:

* `XXXX` if the secret code is `BACD`,
* `XXOO` if the secret code is `BADC`,
* `OOOO` if the secret code is `BACD`.

As you can see, `BACD` (and `BADC` as well) will give the final result
in at most  2 game turns, while  there is a 1-in-3  chance that `ABCD`
will need a third game turn.

In  the program,  the  middle game  does not  exist.  The program  can
memorise a list  of several dozen possible codes, a  feat that a human
player cannot  do. So when  the opening is  over, the program  runs an
interlude (from  "inter" meaning "between" and  "lude" meaning "game")
and builds the  list of codes compatible with the  opening game turns.
Then the program starts the endgame.

Another difference between my program and a game between human ylayers
is that  my program considers  that all  possible codes have  the same
probability. In  their book, Tricot  and Meirovitz tell  their readers
that  a   human  codemaker  will  unconsciously   reject  some  colour
combinations  and prefer  other combiinations.  Also, a  single-colour
code has  a theoretical probability  of 6-in-1296, or 1-in-216  with a
cybernetic  codemaker,  but a  much  lower  probability with  a  human
codemaker.

## Openings

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
`ABCD` and `YZAB` share some colours.

The program leaves the opening phase in any of the following cases:

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

## Interlude

In the interlude, the program builds  the list of all codes compatible
with the  already played game turns.  The codes are built  and checked
step-by-step: first  incomplete codes  with a  single peg,  then codes
with two  pegs, then codes with  three pegs and lastly  complete codes
wuhh four pegs.

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
white mark can be replaced with a  black one, when we will test `CEC.`
and then `CECC` and `CECE` (among others).

Now suppose that the proposition `ABCD` got a marking `XOO` (one black
mark and  two white marks).  Code `AE..`  receives marking `X`  and is
compatible. There are still two empty slots and these slots can be the
places  generating  the  missing  white  marks.  On  the  other  hand,
proposition `EF..`  receives an empty  marking and is  not compatible.
The  two empty  slots are  not enough  to generate  the three  missing
marks.

# License and Copyright

(c) Jean Forget, 2025, all rights reserved.

This  text is  licensed  under  the terms  of  Creative Commons,  with
attribution and share-alike (CC-BY-SA).

The accompanying script is licensed under the same terms as Perl: GNU
Public License version 1 or later and Perl Artistic License.
