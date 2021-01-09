include("experiment_parallel.jl")

function run(n::Int = 20)
    for k = 0:4
        println()
        println("Running: jonah_parallel($n,$k)")
        println("Average turns per game = ", jonah_parallel(n, k))
    end
end

@time run()