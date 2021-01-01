export play_breaker

"""
`ask(prompt::String)` asks the user to enter an integer and returns that integer.
"""
function ask(prompt::String = "Please enter an integer: ")::Int
    valid::Bool = false
    val::Int = 0
    while !valid
        print(prompt)
        reply = readline()
        try
            val = parse(Int, reply)
            valid = true
        catch
            println("Your reply \"$reply\" is not a valid integer, please try again.")
        end
    end
    return val
end


"""
`play_breaker()` allows the user to play Bullets and Maggots as the code
breaker. Enter `-1` to reveal the secret code and end the game. 
"""
function play_breaker(code::Int)
    if !code_check(code)
        throw(error("$code is not a valid secret code"))
    end

    steps = 0
    while true
        guess = ask("Please enter your guess (4-digit number): ")
        if guess < 0
            println("Give up? The code was $(string4(code))")
            return
        end
        if !code_check(guess)
            println("Your guess $guess is not between 0000 and 9999")
            continue
        end
        steps += 1
        b, m = bm_count(code, guess)
        println("Your guess $(string4(guess)) has $b bullets and $m maggots\n")
        if b == 4
            break
        end
    end
    println("You won after $steps steps")
end

function play_breaker()
    code = random_code()
    play_breaker(code)
end
