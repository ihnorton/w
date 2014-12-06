function hamming_pair(s1, s2)
    d = 0
    length(s1) == length(s2) || error("Strings must be same length")
    for i in 1:length(s1)
        s1[i] == s2[i] || (d += 1)
    end
    return d
end

input = readlines(open(ARGS[1]))
println(hamming_pair(input[1], input[2]))
