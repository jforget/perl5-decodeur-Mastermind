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
</li>

<li>
</li>

<li>
</li>

</ul>


# License and Copyright

(c) Jean Forget, 2025, all rights reserved.

This  text is  licensed  under  the terms  of  Creative Commons,  with
attribution and share-alike (CC-BY-SA).

The accompanying script is licensed under the same terms as Perl: GNU
Public License version 1 or later and Perl Artistic License.
