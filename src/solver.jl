export bm_solver

"""
`history_check(hist::Dict, g::Int)` sees if the guess `g` is consistent 
with the previous answers stored in `hist`.
"""
function history_check(history::Dict{Int,Tuple{Int,Int}}, g::Int)::Bool
    for d in keys(history)
        if history[d] != bm_count(g, d)
            return false
        end
    end
    return true
end


"""
`bm_solver(c::Int, verbose::Bool=true)` playes Bullets and Maggots to try 
to find code `c`. Returns the number of guesses. It doesn't cheat!
"""
function bm_solver(c::Int, verbose::Bool = true)::Int
    code_check(c)
    if verbose
        println("Trying to find secret code $(string4(c))")
    end

    all_codes = collect(0:9999)            # randomized list of possible answers
    shuffle!(all_codes)

    history = Dict{Int,Tuple{Int,Int}}()   # place to hold past guesses/results
    steps = 0

    for g in all_codes  # current guess (g) code
        cnt = bm_count(g, c)
        if !history_check(history, g)
            continue
        end
        steps += 1
        if verbose
            println(steps, "\t", string4(g), "\t", cnt)
        end
        history[g] = cnt
        if cnt == (4, 0)
            if verbose
                println("Solved! Code is $(string4(g))")
            end
            break
        end
    end
    return steps
end
