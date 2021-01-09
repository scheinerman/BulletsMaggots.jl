using Counters
export jonah_solver, score_guess, best_guess, filter_space

"""
`score_guess(g::Int, search_space::Vector{Int}`: Given a code guess `g` and 
a list of code `search_space` partition `search_space` based on the score of
`(g,c)` and return the size of the largest part.
"""
function score_guess(g::Int, search_space::Vector{Int})
    if length(search_space) <= 1
        return length(search_space)
    end

    count = Counter{Tuple{Int,Int}}()

    for c in search_space
        bm = bm_count(g, c)
        count[bm] += 1
    end

    return sum(t * t for t in values(count))
    # return maximum(values(count))
end

"""
`best_guess(search_space::Vector{Int}` chooses a code from `search_space`
that minimizes the score returned by `score_guess`.
"""
function best_guess(search_space::Vector{Int}, full_list::Bool = false)
    if length(search_space) == 1
        return search_space[1]
    end

    best_score = length(search_space)^2
    best_g = search_space[1]

    candidates = search_space
    if full_list
        candidates = collect(0:9999)
    end
    shuffle!(candidates)

    ## DEBUG ##
    # println("\tConsidering $(length(candidates)) candidates")


    for g in candidates
        score = score_guess(g, search_space)
        if score < best_score
            best_score = score
            best_g = g
            ## DEBUG ##
            # println("\t\tImproved guess to $(string4(g)) with score $best_score")
        end
    end

    ## DEBUG ##
    # if !in(best_g,search_space)
    #     println("\t\tNot in the search space!\n")
    # else
    #     println()
    # end

    return best_g
end

"""
`filter_space(g::Int, bm::Tuple{Int,Int}, search_space::Vector{Int})` 
returns a shortened copy of `search_space` of codes `c` such that 
`bm_count(g,c)==bm`.
"""
function filter_space(g::Int, bm::Tuple{Int,Int}, search_space::Vector{Int})
    [c for c in search_space if bm_count(g, c) == bm]
end


"""
`jonah_solver(code::Int, verbose::Bool=true, full_list_limit=0)` implements another solving 
strategy proposed by my son.
"""
function jonah_solver(code::Int, verbose::Bool = true, full_list_limit::Int = 0)
    ss = collect(0:9999)
    shuffle!(ss)
    steps = 0

    while true
        if steps == 0
            g = random_code()
        elseif steps <= full_list_limit
            g = best_guess(ss, true)
        else
            g = best_guess(ss, false)
        end
        steps += 1
        bm = bm_count(g, code)
        ss = filter_space(g, bm, ss)

        if verbose
            print("Guess $steps:\t", string4(g), "\t", bm)
            println("\tsearch space size is now ", length(ss))
        end

        if bm == (4, 0)
            if verbose
                println("Solved! Code is $(string4(g))")
            end
            return steps
        end
    end
end
