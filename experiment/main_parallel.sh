#!/bin/bash
#
# ./main_parallel.sh nprocs nreps limit
echo Starting julia with $1 processors to run $2 repetitions with delays up to $3
nohup julia -p $1 main_parallel.jl $2 $3 > ~/experiment_out.txt &
