fib(n,k) = begin
    if n == 1 return 1 
    elseif n == 2 return 1
    else return fib(n-1,k) + k * fib(n-2,k)
    end
end

n,k = int(split(chomp(readline(open(ARGS[1])))))
println("n: ", n, " k: ", k)
println(fib(n,k))
