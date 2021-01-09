include("experiment_parallel.jl")

reps = parse(Int, ARGS[1])
limit = parse(Int, ARGS[2])

function run(n,lim)
    for k = 0:lim
        println()
        println("Running: jonah_parallel($n,$k)")
        println("Average turns per game = ", jonah_parallel(n, k))
    end
end

@time run(reps,limit)