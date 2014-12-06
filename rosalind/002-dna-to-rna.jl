transcribe(string) = replace(string, 'T', 'U')

#@test transcribe("GATGGAACTTGACTACGTAAATT") = "GAUGGAACUUGACUACGUAAAUU"

println(transcribe(readlines(open(ARGS[1]))[1]))
