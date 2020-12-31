export build_table


bm_table = Matrix{Tuple{Int,Int}}(undef, 2, 2)

"""
`build_table()` creates a lookup table for `fast_bm_count()`
"""
function build_table()
    @info "Building lookup table"
    global bm_table = Matrix{Tuple{Int,Int}}(undef, 10_000, 10_000)
    PM = Progress(10_000)
    for a = 0:9999
        for b = a:9999
            @inbounds bm_table[a+1, b+1] = slow_bm_count(a, b)
            @inbounds bm_table[b+1, a+1] = bm_table[a+1, b+1]
        end
        next!(PM)
    end
end

"""
`fast_bm_count(c,d)` is a much faster version of `bm_count`
but requires a slow (roughly 15 second) ramp up.
"""
@inline function fast_bm_count(c::Int, d::Int)::Tuple{Int,Int}
    @inbounds bm_table[c+1, d+1]
end
