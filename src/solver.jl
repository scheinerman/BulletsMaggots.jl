export bm_solver


function history_check(history::Dict{Int,Tuple{Int,Int}}, bm::Tuple{Int,Int})::Bool
    for d in keys(history)
        if bm_count(d) != bm
            return false
        end
    end
    return true
end


"""
`bm_solver(c::Int, verbose::Bool)` playes Bullets and Maggots to try 
to find code `c`. Returns the number of guesses.
"""
function bm_solver(c::Int, verbose::Bool = true)::Int
    code_check(c)
    if verbose
        println("Trying to find secret code $(string4(c))")
    end

    all = shuffle(collect(0:9999))          # randomized list of possible answers
    history = Dict{Int,Tuple{Int,Int}}()   # place to hold past guesses/results



    return 0
end
