#!/bin/bash
echo Starting julia with $1 processors
nohup julia -p $1 main_parallel.jl > ~/experiment_out.txt &
