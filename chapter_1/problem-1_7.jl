using Distributions, DataFrames, Gadfly;  

hoeffding_rhs(n::Int) = (ε::Float64) -> 2.0*exp(-2.0*(ε^2.0)*n) 
fraction(v::Vector{Float64}, μ::Float64) = (ε) -> mean(map(Int,(abs(v .- μ) .>= ε)))

#μ - probability of error (# of heads in this case)
#N - sample size
#samples - # of experiments run at the same time

#(a) Assumptions: n=10, υ=0, three cases: samples=1, samples=1,000, samples=1,000,000

println("(a): Probability that there is no bad event (υ=0) in at least one sample (=for at least one coin) in three cases (experiment with only one coin, experiment with 1,000 coins, experiment with 1,000,000 coins)")
μ = 0.05
println("(a) Let μ = $μ")
samples = [1, 1000, 1000000]
N = 10
d = Binomial(N, μ) #binomial distribution on sample of N tosses
@show 1 - (cdf(d,N) - cdf(d,0)) ^ samples[1]
@show 1 - (cdf(d,N) - cdf(d,0)) ^ samples[2] #1 - (probability of at least one head in a sample)^samples
@show 1 - (cdf(d,N) - cdf(d,0)) ^ samples[3]
μ = 0.8
println("(a) Let μ = $μ")
d = Binomial(N, μ)
@show 1 - (cdf(d,N) - cdf(d,0)) ^ samples[1]
@show 1 - (cdf(d,N) - cdf(d,0)) ^ samples[2] #1 - (probability of at least one head in a sample)^samples
@show 1 - (cdf(d,N) - cdf(d,0)) ^ samples[3]

#(b)
println("(b): Plot the probability P[max_i(|υ_i - μ_i|>ε)] with RHS of the Hoeffding bound")
N = 6 #sample size
μ = 0.5 #probability of bad event (head in this case)
d = Binomial(N, μ) #binomial distribution for samples size N and probability of success μ (bad event in our case)
const ncoin = 2 #number of coins
epsilons = linspace(0.0,1.0,20)
#for the rest of the solution see http://book.caltech.edu/bookforum/showthread.php?t=4414 first 
deviations = abs(rand(d, ncoin, samples[3])./N - μ) #for (C=2) coins flip each one (N=6) times in (samples[2]=1000) experiments
worst_deviations =  maximum(deraviations,1) #the worst deraviations in every experiment between ncoin
prob=fraction(vec(worst_deviations), μ)
hoef = hoeffding_rhs(N)
df=DataFrame(ε=epsilons, 
		prob=map((ε) -> prob(ε),epsilons),
		rhs_hoeffding=map((ε) -> hoef(ε),epsilons)
)
draw(PNG("problem-1_7_b.png", 18cm, 18cm), 
	plot(df,
	layer(x="ε", y="prob", Geom.point, Geom.line, Theme(default_color=colorant"green")),
	layer(x="ε", y="rhs_hoeffding", Geom.point, Geom.line, Theme(default_color=colorant"red")),
	Guide.ylabel("Probabilities"),
	Guide.title("Problem 1.7/b"),
	Guide.manual_color_key("Legend", ["P[max_i|v_i-μ_i|>ε]", "hoeffding_rhs(N=$N,ε)"], ["green", "red"])

))

