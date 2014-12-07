using Base.Test

function tokenize(str)
    split(replace(replace(str, "(", " ( "), ")", " ) "))
end

parse(program) = read_from_tokens(tokenize(program))

function read_from_tokens(tokens)
    if length(tokens) == 0 throw("unexpected EOF while reading") end
    token = shift!(tokens)
    if "(" == token
        L = []
        while tokens[1] != ")"
            push!(L, read_from_tokens(tokens))
        end
        shift!(tokens)
        return L
    elseif ")" == token
        error("unexpected )")
    else
        return atom(token)
    end
end

function atom(token)
    try return int(token)
    catch
        try return float(token)
        catch return token end
    end
end

Env = Dict{String, Function}
function standard_env()
    env = Env()
    merge!(env, Dict(
        "abs"   => abs,
        "append"=> push!,
        "apply" => apply,
        "begin" => x -> x[end],
        "car"   => x -> x[1],
        "cdr"   => x -> x[2:end],
        "cons"  => (x,y) -> push!(Any[x], y),
        "eq?"   => isa,
        "equal?"=> isequal,
        "length"=> length,
        "list"  => x -> [x],
        "list?" => x -> isa(x, Vector),
        "map"   => map,
        "max"   => max,
        "min"   => min,
        "not"   => !,
        "null?" => isempty,
        "number?"=> x -> isa(x, Number),
        "procedure?" => x -> isa(x, Base.Callable),
        "round" => round,
        "symbol?"=> x -> isa(x, Symbol))
    )
end

global_env = standard_env()

# Test cases
program = "(begin (define r 10) (* pi (* r r)))" 
@test tokenize(program) == 
      ["(", "begin", "(", "define", "r", "10", ")", "(", "*", "pi", "(", "*",
       "r", "r", ")", ")", ")"]

@test parse(program) == 
      Any["begin", Any["define", "r", 10], Any["*", "pi", ["*", "r", "r"]]]
