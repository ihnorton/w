using Base.Test
import Base.(==)

type Simbol
    s::String
end
(==)(x::Simbol, s::Simbol) = s.s == x.s
#(==)(x::WeakRef, s::Simbol) = s.s == x
(==)(s::Simbol, x::WeakRef) = s.s == x
(==)(s::Simbol, x::Any) = s.s == x
#(==)(x::Any, s::Simbol) = s.s == x
macro s_str(s) Simbol(s) end

function tokenize(str)
    split(replace(replace(str, "(", " ( "), ")", " ) "))
end

karse(program) = read_from_tokens(tokenize(program))

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
        catch return Simbol(token) end
    end
end

Env = Dict{Simbol, Any}
function standard_env()
#    env = Env([Simbol(string(s)) => Base.(s) for s in
#              filter(x->isa(string(x),ASCIIString),names(Base))])
    env = Env()
    merge!(env, Dict(
        s"abs"   => abs,
        s"append"=> push!,
        s"apply" => apply,
        s"begin" => x -> x[end],
        s"car"   => x -> x[1],
        s"cdr"   => x -> x[2:end],
        s"cons"  => (x,y) -> push!(Any[x], y),
        s"eq?"   => isa,
        s"equal?"=> isequal,
        s"length"=> length,
        s"list"  => x -> [x],
        s"list?" => x -> isa(x, Vector),
        s"map"   => map,
        s"max"   => max,
        s"min"   => min,
        s"not"   => !,
        s"null?" => isempty,
        s"number?"=> x -> isa(x, Number),
        s"procedure?" => x -> isa(x, Base.Callable),
        s"round" => round,
        s"symbol?"=> x -> isa(x, Symbol),
        s"*"     => *,
        s"+"     => +,
        s"-"     => -
        ))
end

global_env = standard_env()

function evak(x, env = global_env)
    println(x)
    # Evaluate an expression in an environment
    if isa(x, Simbol)
        return env[x]
    elseif !isa(x, Vector)
        return x
    elseif x[1] == "quote"
        (_, exp) = x
        return exp
    elseif x[1] == "if"
        (_, test, conseq, alt) = x
        exp = (if evak(test,env) conseq else alt end)
        return evak(exp, env)
    elseif x[1] == "define"
        (_, var, exp) = x
        env[var] = evak(exp, env)
    else
        proc = evak(x[1], env)
        args = [evak(arg,env) for arg in x[1:end]]
        return proc(args...)
    end
end


# Test cases
program = "(begin (define r 10) (* pi (* r r)))" 
@test tokenize(program) == 
      ["(", "begin", "(", "define", "r", "10", ")", "(", "*", "pi", "(", "*",
       "r", "r", ")", ")", ")"]

@test karse(program) == 
      Any[s"begin", Any[s"define", s"r", 10], Any[s"*", s"pi", [s"*", s"r", s"r"]]]

@test begin
    evak(karse("(define r 10)"))
    evak(karse("(* pi (* r r))")) == 314.1592653589793
end
