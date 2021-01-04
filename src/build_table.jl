export build_table


# bm_table = Matrix{Tuple{Int,Int}}(undef, 2, 2)
bm_table = Vector{Tuple{Int8,Int8}}(undef, 2)

bm_flag = false


@inline function bm_table_save(c::Int, d::Int, bm::Tuple{Int,Int})
    @inbounds bm_table[10_000*c+d+1] = bm
end

@inline function bm_table_fetch(c::Int, d::Int)::Tuple{Int,Int}
    @inbounds bm_table[10_000*c+d+1]
end

"""
`build_table()` creates a lookup table for `fast_bm_count()`
"""
function build_table(verbose::Bool = true)
    if !bm_flag
        global bm_flag = true
    else
        return
    end
    @info "Building lookup table"
    global bm_table = Vector{Tuple{Int8,Int8}}(undef, 10_000 * 10_000)

    if verbose
        PM = Progress(50005000)
    end
    for a = 0:9999
        for b = a:9999
            bm = slow_bm_count(a, b)
            bm_table_save(a, b, bm)
            bm_table_save(b, a, bm)
            if verbose
                next!(PM)
            end
        end
    end
end
