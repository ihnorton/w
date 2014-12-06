count_gc(string) = count( x-> (x == 'G' || x == 'C'), string)

function parse_file(fname)
    strings = map(chomp, readlines(open(fname)))
    data = Dict{String, (Int,Int)}()
    orks = [] 
    for line in strings
        if beginswith(line, ">Rosalind")
            gcs = len = 0
            key = line[2:end]
            push!(orks, key)
        else
            gcs = count_gc(line)
            len = length(line)
            tmp = get(data, key, (0,0))
            gcs += tmp[1]
            len += tmp[2]
            data[key] = (gcs, len)
        end
    end
    println(data)
    for key in orks
        println(key)
        println(round(data[key][1] / data[key][2] * 100, 6))
    end
end

parse_file(ARGS[1])
