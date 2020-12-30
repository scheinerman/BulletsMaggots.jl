using BulletsMaggots, Statistics


function run_exp(c::Int, reps::Int = 1000)
    println("Solving for code $(string4(c)) for $reps iterations")
    t = [bm_solver(c, false) for _ = 1:reps]
    println("Average steps to solve:   ", mean(t))
    println("Median steps to solve:    ", median(t))
    println("Standard deviation:       ", std(t))
    println("Range in number of steps: ", minimum(t), "-", maximum(t))
end


"""
`run_all(reps::Int=1000)` runs the solver repeatedly on the five possible
digit patterns for Bullets and Maggots.
"""
function run_all(reps::Int = 1000)
    codes = [0000, 0001, 0011, 0012, 0123]
    for c in codes
        run_exp(c, reps)
        println()
    end
end
