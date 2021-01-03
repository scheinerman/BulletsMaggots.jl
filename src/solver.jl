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
`history_count(h)` returns the number of possible codes that 
are consistent with the history dictionary `h`.
"""
function history_count(history::Dict{Int,Tuple{Int,Int}})::Int
    length([c for c in 0:9999 if history_check(history, c)])
end


"""
`bm_solver(c::Int, verbose::Bool=true, delay::Int=0)` playes Bullets and Maggots to try 
to find code `c`. Returns the number of guesses. It doesn't cheat!

* `verbose` controls printing during execution.
* `delay` indicates how many steps we should wait before using the history; `0` means no delay
"""
function bm_solver(c::Int, verbose::Bool = true, first_guess = guess_any)::Int
    if !code_check(c)
        throw(bad_code_message(c))
        return 0
    end
    if verbose
        println("Trying to find secret code $(string4(c))")
    end

    history = Dict{Int,Tuple{Int,Int}}()   # place to hold past guesses/results
    result_server(g::Int) = bm_count(g, c)
    bm_solver_engine(result_server, verbose, history, first_guess)
end

function bm_solver_engine(
    result_server::Function,
    verbose::Bool,
    history::Dict{Int,Tuple{Int,Int}},
    first_guess::Function = guess_any,
)::Int
    all_codes = collect(0:9999)            # randomized list of possible answers
    shuffle!(all_codes)

    steps = 0


    g = first_guess()
    cnt = result_server(g)
    history[g] = cnt
    steps += 1
    if verbose
        println(
            "Guess $steps:\t",
            string4(g),
            "\t",
            cnt,
            "\tsearch space size is now ",
            history_count(history),
        )
    end


    if cnt == (4, 0)
        if verbose
            println("Solved! Code is $(string4(g))")
        end
        return steps
    end

    for g in all_codes  # current guess (g) code

        if !history_check(history, g)
            continue
        end


        cnt = result_server(g)

        steps += 1
        history[g] = cnt

        if verbose
            println(
                "Guess $steps:\t",
                string4(g),
                "\t",
                cnt,
                "\tsearch space size is now ",
                history_count(history),
            )
        end

        if cnt == (4, 0)
            if verbose
                println("Solved! Code is $(string4(g))")
            end
            return steps
        end
    end
    return -1  # signal failure
end
