# turing
Implementation of a single infinite tape Turing machine.

## Machines
There are 6 machines descriptions (in the `machines` directory):
- unary_add.json: A machine able to compute an unary addition.
- unary_sub.json: A machine able to compute an unary substraction.
- palindrome.json: A machine able to decide whether its input is a palindrome or not. Before halting, write the result on the tape as a ’n’ or a ’y’ at the right of the rightmost character of the tape.
- word0n1n.json: A machine able to decide if the input is a word of the language 0n1n, for instance the words 000111 or 0000011111. Before halting, write the result on the tape as a ’n’ or a ’y’ at the right of the rightmost character of the tape.
- word02n.json: A machine able to decide if the input is a word of the language 02n, for instance the words 00 or 0000, but not the words 000 or 00000. Before halting, write the result on the tape as a ’n’ or a ’y’ at the right of the rightmost character of the tape.
- meta_unary_add.json: A machine able to run the first machine of this list, the one computing an unary addition. The machine alphabet, states, transitions and input are the input of the machine.

## How to run
```
usage: ./ft_turing [-h] jsonfile input

positional arguments:
  jsonfile                  json description of the machine
  input                     input of the machine

optional arguments:
  -h, --help                show this help message and exit
```

## Examples
```
$ ./ft_turing machines/unary_add.json 1111+111
*****************************************************************************
Name : unary_add
Alphabet : [ 1, ., + ]
Blank : .
States : [ erasefirst1, replace+, HALT ]
Initial : erasefirst1
Finals : [ HALT ]
(erasefirst1, 1) -> (replace+, ., RIGHT)
(replace+, 1) -> (replace+, 1, RIGHT)
(replace+, +) -> (HALT, 1, RIGHT)
*****************************************************************************
[<1>111+111.............] -> (erasefirst1, 1) -> (replace+, ., RIGHT)
[.<1>11+111.............] -> (replace+, 1) -> (replace+, 1, RIGHT)
[.1<1>1+111.............] -> (replace+, 1) -> (replace+, 1, RIGHT)
[.11<1>+111.............] -> (replace+, 1) -> (replace+, 1, RIGHT)
[.111<+>111.............] -> (replace+, +) -> (HALT, 1, RIGHT)
[.1111111.............]
Time complexity: 5

$ ./ft_turing machines/word0n1n.json 000111
*****************************************************************************
Name : word0n1n
Alphabet : [ 0, 1, X, Y, y, n, . ]
Blank : .
States : [ erasefirst0, scanright, scanleft, scanrighty, scanrightn, WORD0N1N, NOT WORD0N1N ]
Initial : erasefirst0
Finals : [ WORD0N1N, NOT WORD0N1N ]
(erasefirst0, 0) -> (scanright, X, RIGHT)
(erasefirst0, 1) -> (scanrightn, 1, RIGHT)
(erasefirst0, Y) -> (scanrighty, Y, RIGHT)
(scanright, 0) -> (scanright, 0, RIGHT)
(scanright, Y) -> (scanright, Y, RIGHT)
(scanright, 1) -> (scanleft, Y, LEFT)
(scanright, .) -> (NOT WORD0N1N, n, RIGHT)
(scanleft, 0) -> (scanleft, 0, LEFT)
(scanleft, Y) -> (scanleft, Y, LEFT)
(scanleft, X) -> (erasefirst0, X, RIGHT)
(scanrighty, 0) -> (scanrightn, 0, RIGHT)
(scanrighty, 1) -> (scanrightn, 1, RIGHT)
(scanrighty, Y) -> (scanrighty, Y, RIGHT)
(scanrighty, .) -> (WORD0N1N, y, RIGHT)
(scanrightn, 0) -> (scanrightn, 0, RIGHT)
(scanrightn, 1) -> (scanrightn, 1, RIGHT)
(scanrightn, Y) -> (scanrightn, Y, RIGHT)
(scanrightn, .) -> (NOT WORD0N1N, n, RIGHT)
*****************************************************************************
[<0>00111.............] -> (erasefirst0, 0) -> (scanright, X, RIGHT)
[X<0>0111.............] -> (scanright, 0) -> (scanright, 0, RIGHT)
[X0<0>111.............] -> (scanright, 0) -> (scanright, 0, RIGHT)
[X00<1>11.............] -> (scanright, 1) -> (scanleft, Y, LEFT)
[X0<0>Y11.............] -> (scanleft, 0) -> (scanleft, 0, LEFT)
[X<0>0Y11.............] -> (scanleft, 0) -> (scanleft, 0, LEFT)
[<X>00Y11.............] -> (scanleft, X) -> (erasefirst0, X, RIGHT)
[X<0>0Y11.............] -> (erasefirst0, 0) -> (scanright, X, RIGHT)
[XX<0>Y11.............] -> (scanright, 0) -> (scanright, 0, RIGHT)
[XX0<Y>11.............] -> (scanright, Y) -> (scanright, Y, RIGHT)
[XX0Y<1>1.............] -> (scanright, 1) -> (scanleft, Y, LEFT)
[XX0<Y>Y1.............] -> (scanleft, Y) -> (scanleft, Y, LEFT)
[XX<0>YY1.............] -> (scanleft, 0) -> (scanleft, 0, LEFT)
[X<X>0YY1.............] -> (scanleft, X) -> (erasefirst0, X, RIGHT)
[XX<0>YY1.............] -> (erasefirst0, 0) -> (scanright, X, RIGHT)
[XXX<Y>Y1.............] -> (scanright, Y) -> (scanright, Y, RIGHT)
[XXXY<Y>1.............] -> (scanright, Y) -> (scanright, Y, RIGHT)
[XXXYY<1>.............] -> (scanright, 1) -> (scanleft, Y, LEFT)
[XXXY<Y>Y.............] -> (scanleft, Y) -> (scanleft, Y, LEFT)
[XXX<Y>YY.............] -> (scanleft, Y) -> (scanleft, Y, LEFT)
[XX<X>YYY.............] -> (scanleft, X) -> (erasefirst0, X, RIGHT)
[XXX<Y>YY.............] -> (erasefirst0, Y) -> (scanrighty, Y, RIGHT)
[XXXY<Y>Y.............] -> (scanrighty, Y) -> (scanrighty, Y, RIGHT)
[XXXYY<Y>.............] -> (scanrighty, Y) -> (scanrighty, Y, RIGHT)
[XXXYYY<.>............] -> (scanrighty, .) -> (WORD0N1N, y, RIGHT)
[XXXYYYy............]
Time complexity: 25
```
