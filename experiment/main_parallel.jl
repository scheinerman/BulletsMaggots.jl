include("experiment_parallel.jl")
n = 10_000

println(jonah_parallel(n,false))
println(jonah_parallel(n,true))