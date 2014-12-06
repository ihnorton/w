compl = Dict{Char,Char}('A' => 'T', 'T' => 'A', 'C' => 'G', 'G' => 'C')
output = ascii( [compl[x]::Char for x in reverse( chomp(readline(open(ARGS[1]))) )] )

println(output)
