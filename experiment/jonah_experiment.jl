using BulletsMaggots, ProgressMeter, Statistics

build_table() 
function experiment(reps::Int = 1000,delay::Int=0)
    println("Playing $reps games")
    t = zeros(Int,reps)
    PM = Progress(reps)
    for i=1:reps
        t[i] = jonah_solver(random_code(),false)
        next!(PM)
    end 
    println("Average steps to solve:   ", mean(t))
    println("Median steps to solve:    ", median(t))
    println("Standard deviation:       ", std(t))
    println("Range in number of steps: ", minimum(t), "-", maximum(t))
end
