export bm_count

"""
`code_check(c::Int)` checks that `c` is a valid code
(between 0000 and 9999 inclusive). Returns `true` 
if valid and throws an error if not.
"""
@inline function code_check(c::Int)::Bool
    if c < 0 || c > 9999
        throw(error("Code $c is invalid. Must be in the range from 0000 to 9999."))
    end
    return true
end

"""
`string4(c::Int)` renders the code number `c` as a four-digit `String`.
```
julia> string4(17)
"0017"
```
"""
function string4(c::Int)::String
    code_check(c)
    cc = reverse(digits(c, pad = 4))
    result = ""
    for i = 1:4
        result *= "$(cc[i])"
    end
    return result
end

"""
`bm_count(c::Int,d::Int)` counts the number of bullets and maggots 
when comparing the codes `c` and `d`; this is returned as a 
tuple `(b,m)`.
"""
function bm_count(c::Int, d::Int)
    code_check(c) && code_check(d)

    # break codes into an array of digits
    cc = digits(c, pad = 4)
    dd = digits(d, pad = 4)

    # flags to show if that digit is available to be matched
    c_avail = [true, true, true, true]
    d_avail = [true, true, true, true]

    # counts of bullets & maggots
    b = 0
    m = 0

    # count bullets
    for i = 1:4
        if cc[i] == dd[i]  # we have a bullet; mark digits as used
            b += 1
            c_avail[i] = false
            d_avail[i] = false
        end
    end

    # count maggots 
    for i = 1:4
        for j = 1:4
            if i != j && c_avail[i] && d_avail[j] && cc[i] == dd[j]
                m += 1
                c_avail[i] = false
                d_avail[j] = false
            end
        end
    end

    return b, m
end