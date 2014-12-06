function count_letters(fname)
    count = Dict{Char, Int}()
    count['A'] = count['C'] = count['G'] = count['T'] = 0
    for l in readlines(open(fname))
        for c in chomp(l)
            count[c] += 1
        end
    end
    println("Count: $(count['A']) $(count['C']) $(count['G']) $(count['T'])")
end

count_letters(ARGS[1])      
