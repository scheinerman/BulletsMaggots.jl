using Counters
export jonah_solver

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

    return sum(t*t for t in values(count))
    # return maximum(values(count))
end

"""
`best_guess(search_space::Vector{Int}` chooses a code from `search_space`
that minimizes the score returned by `score_guess`.
"""
function best_guess(search_space::Vector{Int})
    if length(search_space) == 1
        return search_space[1]
    end

    best_score = length(search_space)
    best_g = search_space[1]

    for g in search_space
        score = score_guess(g, search_space)
        if score < best_score
            best_score = score
            best_g = g
        end
    end
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
`jonah_solver(code::Int, verbose::Bool=true)` implements another solving 
strategy proposed by my son.
"""
function jonah_solver(code::Int, verbose::Bool = true)
    ss = collect(0:9999)
    shuffle!(ss)
    steps = 0

    while true
        if steps == 0
            g = random_code()
        else
            g = best_guess(ss)
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
