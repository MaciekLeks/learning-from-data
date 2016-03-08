#Adaline (Adaline Linear Neuron)

using Gadfly

build_dataset(target_function::Function, n::Int, dims::Int, space_range::Range) = begin
	#create variables
	X = ones(n,dims+1) #dims+1 for x0 column
	y = zeros(n) #labels
	
	#build dataset
	for i=1:n 
		#random datapoint
		dp = rand(RNG, dims)
		X[i,2:end] = dp
		y[i] = target_function(X[i,:])
	end

	return X, y
end


build_testset(n::Int, dims::Int, space_range::Range) = begin
	Xtest = ones(n,dims+1) #dims+1 for x0 column
	for i=1:n 
		#random datapoint
		dp = rand(RNG, dims)
		Xtest[i,2:end] = dp		
	end

	return Xtest
end

verify(classifier::Function, Xtest::Array, wg::Vector, comment="") = begin
	successes = mapreduce(id -> classify(Xtest[id,:]) == sign(dot(wg,Xtest[id,:])), +, 1:size(Xtest,1))
	println("$comment>Adaline Eout is $(successes/size(Xtest,1))")
end


run_adaline(X::Array, y::Array, 𝝶::Float64, max_iterations=MAX_ITERATIONS, comment="") = begin
	w = zeros(dims+1) #weigths

	t = 1
	while t <= MAX_ITERATIONS
		
		id = rand(1:length(y)) #random index
		s = dot(X[id,:], w) #`signal`
		if y[id]*s <= 1.0 #if s(t) agrees with y(t) well then their product is > 1 
			w = w + 𝝶*(y[id] - s)*X[id,:]
		end
		
		t += 1
	end

	# if !convergent
	# 	println("$comment>Adaline for $n samples in the ℝ^$(size(X,2)-1) space cannot converge for the given data set in $MAX_ITERATIONS iterations! Problematic data points: X=$(X[idx,:]) => y=$(y[idx])")
	# else 
	# 	println("$comment>Adaline for $n samples in the ℝ^$(size(X,2)-1) space converged in $t iterations!")
	# end

	return w, t
end


plot_adaline(fname::AbstractString, X::Array, y::Array, gln::Function, fln::Function) = begin
	neg = y .== -1.0
	pos = y .== 1.0


	xs = collect(RNG)
	draw(PNG(fname, 18cm, 18cm), plot(
		layer(x=xs, y=map(fln, xs), Geom.line, Theme(default_color=colorant"black")), 
		layer(x=xs, y=map(gln, xs), Geom.line, Theme(default_color=colorant"blue")), 
		layer(x=X[pos,2],y=X[pos,3], Geom.point, Theme(default_color=colorant"green")),
		layer(x=X[neg,2],y=X[neg,3], Geom.point, Theme(default_color=colorant"red")),	
		Guide.manual_color_key("Legend", ["+", "-", "g - target hypothesis", "f - target function"], ["green", "red", "blue", "black"]),
		Guide.ylabel("x2"),
	    Guide.xlabel("x1"),
	    Guide.title("LFD:: Problem 1.4")
))

end

#/hyperplane function
# dims: space dimensionality
# rng: subspace to get random points
create_target_function(dims::Int, rng::Range) = begin
	factors = rand(RNG, dims+1) #hyperplane factors, we need +1 to have e.g. a0 + a1*x1 + a2*x2 = 0 for two dimmensional space
	return (v::Array) -> sign(dot(factors,v)) >= 0.0 ? 1.0 : -1.0, #let's assume that 0 means 1 in our two-class classification problem
		factors
end
#hyperplane function/

#2D line functions
line(w) = (x) -> -w[2]/w[3]*x - w[1]/w[3] #w2*x2 + w1*x1 + w0*x0 = 0 => x2 = -w1/w2*x1 + w0/w2*x0





#/common constants
const MAX_ITERATIONS = 1000
const RNG = -10.0:10.0 #input space (X) range
#common constants/

#Solutions
#(a)  
n = 100
ntest = 10000
𝝶 = 100.0
dims = 2 #two dimmensional perceptron
classify, wf = create_target_function(dims,RNG) #tuple: (classifier, target function weights needed to plot f)
X, y = build_dataset(classify, n, dims, RNG)
Xtest = build_testset(ntest, dims, RNG)
wg, t = run_adaline(X, y, 𝝶, MAX_ITERATIONS, "(a)") 
plot_adaline("problem-1_5_a.png", X, y, line(wg), line(wf))
verify(classify, Xtest, wg, "𝝶=$𝝶")


#(b)
𝝶 = 1.0
wg, t = run_adaline(X, y, 𝝶, MAX_ITERATIONS,"(b)") 
plot_adaline("problem-1_5_b.png", X, y, line(wg), line(wf))
verify(classify, Xtest, wg, "𝝶=$𝝶")

#(c)
𝝶 = 0.01
wg, t = run_adaline(X, y, 𝝶, MAX_ITERATIONS,"(c)") 
plot_adaline("problem-1_5_c.png", X, y, line(wg), line(wf))
verify(classify, Xtest, wg, "𝝶=$𝝶")

#(d)
𝝶 = 0.0001
wg, t = run_adaline(X, y, 𝝶, MAX_ITERATIONS,"(d)") 
plot_adaline("problem-1_5_d.png", X, y, line(wg), line(wf))
verify(classify, Xtest, wg, "𝝶=$𝝶")

