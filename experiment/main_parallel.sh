#!/bin/bash
#
# ./main_parallel.sh nprocs nreps limit
echo Running with $1 processors with $2 repetitions with delays up to $3 >  ~/experiment_out.txt
nohup julia -p $1 main_parallel.jl $2 $3 >> ~/experiment_out.txt &
