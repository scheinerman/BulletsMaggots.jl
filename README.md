# Bullets and Maggots

## The Game

*Bullets and Maggots* is a guessing game that is a number version of 
[Mastermind](https://en.wikipedia.org/wiki/Mastermind_(board_game)).

One player, the code maker, thinks of a four digit number. The other player, the code breaker, tries to guess the number. Each time the code breaker makes a guess, the code maker reports two results:
* The number of digits in the guess that match the corresponding digits in the secret code; these are called *bullets* (black pegs in Mastermind). 
* The number of digits in the guess that match the secret code, but are not in the correct position; these are called *maggots* (white pegs in Mastermind).

The objective is for the code breaker to deduce the secret code in as few steps as possible.

## Solver

This module's primary function is `bm_solver`. The input to this function is the secret code and then `bm_solver` tries to guess the code (it doesn't cheat). It returns the number of guesses made to find the secret code.
* `bm_code(c)` shows the step-by-step guesses (and bullet/maggot counts) to guess the four-digit number `c`. 
* `bm_code(c,false)` suppresses the verbose output and just returns the number of steps. 

```
julia> bm_solver(3420)
Trying to find secret code 3420
1       1526    (1, 0)
2       1047    (0, 2)
3       0766    (0, 1)
4       8420    (3, 0)
5       4420    (3, 0)
6       2420    (3, 0)
7       3420    (4, 0)
Solved! Code is 3420
7

julia> bm_solver(55)
Trying to find secret code 0055
1       7119    (0, 0)
2       8640    (0, 1)
3       5256    (1, 1)
4       5022    (1, 1)
5       3852    (1, 0)
6       0055    (4, 0)
Solved! Code is 0055
6
```

## Method

The solver's algorithm works as follows. There are 10,000 possible codes (from 0000 to 9999). The solver shuffles these and queries the code maker for the first guess on the list. The information returned is saved. From here, the solver scans down the list of guesses stopping when if finds a guess that is consistent with all the responses from the code maker, and then guesses that code. The response is saved and, if the guess is not the true code, the process continues until the correct code is found.

## Experiment

The code in the `experiment` directory tests this algorithm on various codes to see how many steps the solver typically takes. There are only five different code patterns to consider:
* Four of a kind, e.g. 0000
* Three of a kind, e.g. 0001
* Two pair, e.g. 0011
* One pair, e.g. 0012
* All different, e.g. 0123

See the sample execution of `run_all` below. From this it appears that a code with a single pair is the most difficult for the algorithm (most steps on average).

```
julia> run_all()
Solving for code 0000 for 1000 iterations
Average steps to solve:   5.61
Median steps to solve:    6.0
Standard deviation:       1.0454630519501842
Range in number of steps: 2-10

Solving for code 0001 for 1000 iterations
Average steps to solve:   6.092
Median steps to solve:    6.0
Standard deviation:       1.0586107200745023
Range in number of steps: 2-10

Solving for code 0011 for 1000 iterations
Average steps to solve:   6.127
Median steps to solve:    6.0
Standard deviation:       1.1081963269651725
Range in number of steps: 3-10

Solving for code 0012 for 1000 iterations
Average steps to solve:   6.224
Median steps to solve:    6.0
Standard deviation:       1.1971872273196271
Range in number of steps: 2-10

Solving for code 0123 for 1000 iterations
Average steps to solve:   6.087
Median steps to solve:    6.0
Standard deviation:       1.19702291701699
Range in number of steps: 2-10
```

## Question

The `bm_solver` algorithm never guesses a code that it knows to be incorrect (based on the prior responses). Is there a faster method that knowingly makes some guesses of incorrect codes?