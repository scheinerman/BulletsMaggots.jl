# Bullets and Maggots


[![Build Status](https://travis-ci.com/scheinerman/BulletsMaggots.jl.svg?branch=master)](https://travis-ci.com/scheinerman/BulletsMaggots.jl)


## The Game

*Bullets and Maggots* is a guessing game that is a number version of 
[Mastermind](https://en.wikipedia.org/wiki/Mastermind_(board_game)). (This game is also known as
[*Bulls and Cows*](https://en.wikipedia.org/wiki/Bulls_and_Cows) but that's not what my friends and I called it back in the day.)

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
Guess 1:        0851    (0, 1)  ⟹        search space size is now 3048
Guess 2:        8486    (1, 0)  ⟹        search space size is now 494
Guess 3:        4475    (1, 0)  ⟹        search space size is now 74
Guess 4:        1376    (0, 1)  ⟹        search space size is now 15
Guess 5:        9430    (2, 1)  ⟹        search space size is now 2
Guess 6:        3420    (4, 0)  ⟹        search space size is now 1
Solved! Code is 3420
6

julia> bm_solver(55)
Trying to find secret code 0055
Guess 1:        0810    (1, 1)  ⟹        search space size is now 1030
Guess 2:        1852    (1, 0)  ⟹        search space size is now 97
Guess 3:        6808    (0, 1)  ⟹        search space size is now 40
Guess 4:        1470    (0, 1)  ⟹        search space size is now 6
Guess 5:        0055    (4, 0)  ⟹        search space size is now 1
Solved! Code is 0055
5
```

## Play

### Play as code breaker

The function `play_breaker()` allows interactive play of the game in which the user 
is the code breaker. Enter a negative number to force the game to end and have the
code revealed.


### Play as code maker

The function `play_maker()` allows interacive play of the game in which 
the computer is the code breaker. In this example the user's code is `1234`:
```
julia> play_maker()
I guess the code is 4408
Enter the number of bullets: 0
Enter the number of maggots: 1

I guess the code is 0966
Enter the number of bullets: 0
Enter the number of maggots: 0

I guess the code is 8252
Enter the number of bullets: 1
Enter the number of maggots: 0

I guess the code is 7247
Enter the number of bullets: 1
Enter the number of maggots: 1

I guess the code is 7154
Enter the number of bullets: 1
Enter the number of maggots: 1

I guess the code is 1234
Enter the number of bullets: 4
Enter the number of maggots: 0

Solved in 6 steps
```



If the user gives incorrect information, this 
will be revealed. Here we illustrate with the code `1234`.


```
julia> play_maker()
I guess the code is 7147
Enter the number of bullets: 0
Enter the number of maggots: 2

I guess the code is 4881
Enter the number of bullets: 0
Enter the number of maggots: 2

I guess the code is 1496
Enter the number of bullets: 0   # this is wrong; should be 1
Enter the number of maggots: 2   # this is wrong; should be 1

I guess the code is 5214
Enter the number of bullets: 2
Enter the number of maggots: 1

I guess the code is 3514
Enter the number of bullets: 1
Enter the number of maggots: 2

I give up. What was you code? 1234
You say your code is 1234
When I guessed 1496
you replied it's 0 bullets & 2 maggots
but in fact it's 1 bullets & 1 maggots
```

## Method

The solver's algorithm works as follows. There are 10,000 possible codes (from 0000 to 9999). The solver shuffles these and queries the code maker for the first guess on the list. The information returned is saved. From here, the solver scans down the list of guesses stopping when if finds a guess that is consistent with all the responses from the code maker, and then guesses that code. The response is saved and, if the guess is not the true code, the process continues until the correct code is found.

## Speeding Up

The function `bm_count` is used calculate the number of bullets and maggots for a pair of code numbers. It is reasonably speedy for casual use, but it can be made much faster by first precomputing all possible values of `bm_count` and saving them in a look-up table. Invoking the function `build_table` builds the look-up table and from that point on, `bm_count` uses the table instead of computing the number of bullets and maggots at each invocation.
```julia
julia> using BenchmarkTools

julia> @btime bm_count(1212, 2132)
  234.745 ns (5 allocations: 448 bytes)
(1, 2)

julia> build_table()
[ Info: Building lookup table
Progress: 100%|███████████████████████████████████████| Time: 0:00:25

julia> @btime bm_count(1212, 2132)
  56.942 ns (2 allocations: 64 bytes)
(1, 2)
```


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
