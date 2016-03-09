workspace()
#Combinations
C(k,n) = factorial(n)/(factorial(k)*factorial(n-k))

#We are computing probability of getting no red marbles (v=0)
#Let X be a random variable of number of red marbles

#P(X=k) =>
binomial_probdist(; k=0, n=0, μ=0.0) = C(k,n)*μ^k*(1-μ)^(n-k) 

#P(X<=k) =>
binomial_distfun(; k=0, n=0, μ=0.0) = begin 
	s = 0.0
	for x=0:k
		s += binomial_probdist(k=x,n=n,μ=μ)
	end
	return s
end

#(a) We draw only one such sample
const N = 10 #sample size
println("problem 1.6\n(a): We draw only one such sample")
@show binomial_probdist(k=0, n=N, μ=0.05)
@show binomial_probdist(k=0, n=N, μ=0.5)
@show binomial_probdist(k=0, n=N, μ=0.8) 

#(b) We draw 1,000 independent samples
println("(b): We draw 1,000 independent samples")
samples = 1000
@show 1 - (binomial_distfun(k=N, n=N, μ=0.05) - binomial_distfun(k=0, n=N, μ=0.05)) ^ samples #1 - (probability of at least one marble in a sample)^samples
@show 1 - (binomial_distfun(k=N, n=N, μ=0.5) - binomial_distfun(k=0, n=N, μ=0.5)) ^ samples
@show 1 - (binomial_distfun(k=N, n=N, μ=0.8) - binomial_distfun(k=0, n=N, μ=0.8)) ^ samples

#(c) We draw 1,000,000 independent samples
println("(c): We draw 1,000,000 independent samples")
samples = 1000000
@show 1 - (binomial_distfun(k=N, n=N, μ=0.05) - binomial_distfun(k=0, n=N, μ=0.05)) ^ samples 
@show 1 - (binomial_distfun(k=N, n=N, μ=0.5) - binomial_distfun(k=0, n=N, μ=0.5)) ^ samples
@show 1 - (binomial_distfun(k=N, n=N, μ=0.8) - binomial_distfun(k=0, n=N, μ=0.8)) ^ samples
