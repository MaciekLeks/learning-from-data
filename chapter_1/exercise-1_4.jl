# Create an f target function crossing two points (x1,x2) and (x2,y2)
create_classifier(x1::Float64, y1::Float64, x2::Float64, y2::Float64) = begin
	a = y1 - y2
	b = x2 - x1
	c = x1*y2 - x2*y1
	return (x::Float64, y::Float64) -> sign(a*x + b*y + c), [a,b,c]
end

const D = 2 #perceptron in two dimmension 
const N = 20 #number of samples
const RNG = -10.0:10.0 #input space (X) range
const MAX_ITERATIONS = 1000

#random line points
points = rand(RNG, 2,2)
classify, wf = create_classifier(points[1,1],points[1,2], points[2,1], points[2,2]) #tuple: (classifier, target function weights needed to plot f)

#create variables
X = ones(N,D+1) #D+1 for x0 column
y = zeros(N) #labels
w = zeros(D+1) #weigths

#build dataset
for i=1:N 
	#random datapoint
	dp = rand(RNG, 2)
	X[i,2:end] = dp
	y[i] = classify(dp[1], dp[2])
end


#run perceptron 
t = 1
while t <= MAX_ITERATIONS
	h = sign(X*w) #compute current h values
		
	idx = find(_ -> _, y .!= h) #indices of the misclassified training example
	if length(idx) == 0 
		convergent = true
		break
	end
	id = idx[rand(1:length(idx))] #random indx
	
	w = w + y[id] * X[id,:]
	
	t += 1
end

if t > MAX_ITERATIONS
	println("mlk>PLA cannot converge for the given data set in $MAX_ITERATIONS iterations!")
else 
	println("mlk>PLA converged in $t iterations!")
end


neg = y .== -1.0
pos = y .== 1.0
gln(x) = -w[2]/w[3]*x - w[1]/w[3] #w2*x2 + w1*x1 + w0*x0 = 0 => x2 = -w1/w2*x1 + w0/w2*x0
fln(x) = -wf[1]/wf[2]*x - wf[3]/wf[2] #see create_classifier function to associate weights and params from the tuple

#plot results
using Gadfly
set_default_plot_size(24cm, 24cm)
xs = collect(RNG)
plot(
	layer(x=X[pos,2],y=X[pos,3], Geom.point, Theme(default_color=colorant"green")),
	layer(x=X[neg,2],y=X[neg,3], Geom.point, Theme(default_color=colorant"red")),
	layer(x=xs, y=map(gln, xs), Geom.line, Theme(default_color=colorant"orange")), 
	layer(x=xs, y=map(fln, xs), Geom.line, Theme(default_color=colorant"black")), 
	Guide.manual_color_key("Legend", ["+", "-", "target hypothesis", "target function"], ["green", "red", "orange", "black"]),
	Guide.ylabel("x2"),
    Guide.xlabel("x1"),
    Guide.title("LFD:: Exercise 1.4")
)