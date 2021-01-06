#!/bin/bash
echo Starting julia is $p processors
nohup julia -p $1 main_parallel.jl > ~/experiment_out.txt &