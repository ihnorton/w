using Base.Test

ops = ['+' '-' '*' '/' '^']

function tokenize(expr::String)
    tokens = Any[]
    for c in expr
        if isspace(c)
          continue
        elseif c == '('
          push!(tokens, :bs)
        elseif c == ')'
          push!(tokens, :be)
        elseif c in ops
          push!(tokens, symbol(c))
        elseif isinteger(c)
          push!(tokens, parseint(c))
        end
    end
    tokens
end

checkdone(tokens) = (isempty(tokens) || error("Unexpected argument"))

function tkparse(tokens)
    stack = Any[]
    exp = Any[]
    for tk in tokens
        println("tk: $tk   exp: $exp")
        if tk == :bs
            push!(stack, exp)
            exp = Any[]
        elseif tk == :be
            last_exp = pop!(stack)
            println("    lastexp: $last_exp")
            isempty(last_exp) || begin
                push!(last_exp, exp)
                exp = last_exp
            end
        else
            push!(exp, tk)
        end
    end
    exp
end

function tkeval(expr)
    println("expr: $expr")
    op = shift!(expr)
    
    a2 = pop!(expr)
    a1 = pop!(expr)
    
    if isa(a1, Array)
        a1 = tkeval(a1)
    end
    if isa(a2, Array)
        a2 = tkeval(a2)
    end
    println("op: $op  a1: $a1  a2: $a2")
    if op == :+
        return a1 + a2
    elseif op == :-
        return a1 - a2
    elseif op == :*
        return a1 * a2
    elseif op == :/
        return a1 / a2
    elseif op == :^
        return a1 ^ a2
    end
end

ex1 = {"(+ 1 2)", {:bs, :+, 1, 2, :be}}
ex2 = {"(+ (^ 2 2) 3", {:bs, :+, :bs, :^, 2, 2, :be, 3}}
ex3 = {"(* 3 (+ 1 4))", {:bs, :*, 3, :bs, :+, 1, 4, :be, :be}}

@test tokenize(ex1[1]) == ex1[2]
@test tokenize(ex2[1]) == ex2[2]
@test tokenize(ex3[1]) == ex3[2]
