using Distributed

println("nprocs = ", nprocs())

@everywhere using BulletsMaggots
@everywhere build_table(false)

function jonah_parallel(reps::Int = 1000, full_list::Bool=false)
    if full_list
        println("Experiment with $reps reps and candidates from all 10,000 options")
    else
        println("Experiment with $reps reps and only choosing from search space")
    end

    total = @distributed (+) for i = 1:reps
        jonah_solver(guess_any(), false, full_list)
    end
    return total / reps
end


function bm_parallel(reps::Int = 1000)
    total = @distributed (+) for i = 1:reps
        bm_solver(guess_any(), false)
    end
    return total / reps
end
