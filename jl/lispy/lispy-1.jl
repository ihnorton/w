using Base.Test
import Base.(==)

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
        catch return symbol(token) end
    end
end

macro s_str(s) :(symbol($s)) end

Env = Dict{Symbol, Any}
function standard_env()
#    env = Env([Symbol(string(s)) => Base.(s) for s in
#              filter(x->isa(string(x),ASCIIString),names(Base))])
    env = Env()
    merge!(env, Dict(
        :abs        => abs,
        :append     => push!,
        :apply      => apply,
        :begin      => x -> x[end],
        :car        => x -> x[1],
        :cdr        => x -> x[2:end],
        :cons       => (x,y) -> push!(Any[x], y),
        s"eq?"      => isa,
        s"equal?"   => isequal,
        :length     => length,
        :list       => x -> [x],
        s"list?"    => x -> isa(x, Vector),
        :map        => map,
        :max        => max,
        :min        => min,
        :not        => !,
        s"null?"    => isempty,
        s"number?"  => x -> isa(x, Number),
        s"procedure?" => x -> isa(x, Base.Callable),
        :round      => round,
        s"symbol?"  => x -> isa(x, Symbol),
        :*          => *,
        :+          => +,
        :-          => -,
        :pi         => pi
        ))
end

global_env = standard_env()

function evak(x, env = global_env)
    # Evaluate an expression in an environment
    if isa(x, Symbol)
        return env[x]
    elseif !isa(x, Vector)
        return x
    elseif x[1] == :quote
        (_, exp) = x
        return exp
    elseif x[1] == :if
        (_, test, conseq, alt) = x
        exp = (if evak(test,env) conseq else alt end)
        return evak(exp, env)
    elseif x[1] == :define
        (_, var, exp) = x
        env[var] = evak(exp, env)
    else
        proc = evak(x[1], env)
        args = [evak(arg,env) for arg in x[2:end]]
        #println("F: ", proc, " r: ", args)
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
