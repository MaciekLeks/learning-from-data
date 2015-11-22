#Solution for questions: 4, 5, 6, 7,
workspace()

include("../tools.jl")

#target function
target(x) = sin(π*x)

#returns Ein, Eout, wbar (parameters for gbar), bias, variance
function analyze(dist::Range, n::Int, d::Int, target::Function, in_map::Function, out_map, experiments::Int)
	eins = zeros(experiments,1) #in-sample errors
	eouts = zeros(experiments,1) #out-of-sample errors
	ws = zeros(EXPERIMENTS,d) #weigths
	#compute Ein, Eout, gbar
	for k=1:experiments
		X_train = rand(dist, n, d) 
		y_train = map(target, X_train) 
				
		X_train = in_map(X_train)
		 
		w = ((pinv(X_train'*X_train))*(X_train'))*y_train
		ws[k] = mean(w) #add to weigths
		pred = X_train*w
		eins[k] =  mean((pred - y_train).^2)
		
		X_test = rand(dist, 1, d)
		y_test = map(target, X_test)
		X_test = out_map(X_test) #dodajemy 1.0 albo nie dodajemy
		pred = X_test*w
		 
		eouts[k] =  mean((pred .- y_test).^2)  
	end
	wbar = mean(ws) #wieghts for gbar

	#compute bias-variance
	biases = zeros(experiments,1)
	variances = zeros(experiments,1)
	for k=1:experiments
		X_test = rand(dist, 1, d)
		y_test = map(target,X_test)
		pred = X_test*wbar
		biases[k] = mean((pred - y_test).^2)

		g = X_test*ws[k]
		gbar = X_test*wbar
		variances[k] = mean((g - gbar).^2)
	end

	mean(eins), mean(eouts), wbar, mean(biases), mean(variances)
end

const N = 2 #training examples 
const D = 1 #sample x dimensionality 
const DIST = -1.0:0.0001:1.0 #X instances
const EXPERIMENTS = 10000 #number of experiments

q456 = analyze(DIST, N, D, target, (X) -> X, (X) -> X, EXPERIMENTS)
q4 = answer([0.0;0.79;1.07;1.58;1.43], q456[3]) #1.43 for e position added on purpose
println("q4: $q4")
q5 = answer([0.1;0.3;0.5;0.7;1.0], q456[4])
println("q5: $q5")
q6 = answer([0.2;0.4;0.6;0.8;1.0], q456[5])
println("q6: $q6")

q7a = analyze(DIST, N, D, target, (X) -> [ones(size(X,1)) zeros(size(X,1))], (X) -> [ones(size(X,1)) X], EXPERIMENTS)
q7b = analyze(DIST, N, D, target, (X) -> X, (X) -> X, EXPERIMENTS)
q7c = analyze(DIST, N, D, target, (X) -> [ones(size(X,1)) X], (X) -> [ones(size(X,1)) X], EXPERIMENTS)
q7d = analyze(DIST, N, D, target, (X) -> X.^2, (X) -> X, EXPERIMENTS)
q7e = analyze(DIST, N, D, target, (X) -> [ones(size(X,1)) X.^2], (X) -> [ones(size(X,1)) X], EXPERIMENTS)
#println("q7: a:$q7a; b:$q7b; c:$q7c; d:$q7d; e:$q7e")
q7_min_eout = answer_min([q7a[2];q7b[2];q7c[2];q7d[2];q7e[2]])
println("q7: min_eout:$q7_min_eout")

#Eout should be equal sum of bias and variance
tolerance = 0.02
is_eout_eq_bias_plus_variance = abs(q456[2] - (q456[4]+q456[5])) <= tolerance
println("\nIs Eout:$(q456[2]) for h(x)=ax close to to bias:$(q456[4]) + variance:$(q456[5]) with tolerance:$tolerance? Ans: $is_eout_eq_bias_plus_variance" )