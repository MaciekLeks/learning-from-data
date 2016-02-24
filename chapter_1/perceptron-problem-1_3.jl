#Dataset
X = [
	1.0 2.0
	-1.0 1.0
	-2.0 -1.0
	1.0 -1.0
	2.0 -2.0
];
X = [ones(size(X,1)) X]
X_length = [norm(X[i,:],2) for i=1:size(X,1)]


y = [
	1.0
	1.0
	1.0 
	-1.0
	-1.0
]

#weights for 2D (w0,w1,w2)
w = [
	0.0
	0.0
	0.0
]
ws = []

h = zeros(size(y,1))
t = 1
R = maximum(X_length)

const MAX_ITERATIONS = 10

while t <= MAX_ITERATIONS
	push!(ws, w) #save the last w

	#/(d)
	
	@printf "d. ||w(%d)||^2 <= tR^2 \t=> %d\n" (t-1) norm(w,2)^2 <= (t-1) * R^2   #d part of problem 1.3
	h = sign(X*w) #compute current h values
	#(d)/
		
	idx = find(_ -> _, y .!= h) #indices of the misclassified training example
	length(idx) == 0 && break
	id = idx[rand(1:length(idx))] #random indx
	
	w = w + y[id] * X[id,:]

	#/(c)
	@printf "c. ||w(%d)||^2 <= ||w(%d)||^2 + ||x(%d)||^2 \t=> %d\n" t (t-1) (t-1)  (norm(w,2)^2 <= norm(ws[length(ws)],2)^2 + norm(X[id,:],2)^2)
	#(c)/

	t += 1
end

#/(a)
ρ = minimum(y .* X * w) #a - znamy dopiero po wyliczeniu w*
@printf "a. p=%0.2f\n" ρ
#(a)/
	
#/(b)
for t=1:length(ws) 
	@printf "b. w'(%d)w* >= tρ \t=> %d\n" (t-1) dot(ws[t],w) >= (t-1)*ρ #w(t=0) is at 1 position in ws
end
#(b)/

#/(d)
tbound = R^2*norm(w,2)^2/ρ^2
@printf "e. t <= R^2||w*||^2/ρ^2 where LHS=%d RHS=%0.3f \t=> %d\n" (t-1) (tbound) ((t-1) <= tbound)
#(d)/

#Why PLA convergence
@printf "\nThe inner product between w(t) and the separating weights w* grows fast. See:\n" 
for t=1:length(ws)
	@printf "proof step 1: w(t)'w* = %0.3f\n" dot(ws[t],w)
end
@printf "\n...but, the normalized inner product between w(t) and the separating weights w* is bound by 1:\n" 
for t=1:length(ws)
	@printf "proof step 2: w(t)'w*/||w(t)||||w*|| = %0.3f\n" dot(ws[t],w)/(norm(ws[t],2)*norm(w,2)) #info: a'a/(norm(a,2)*norm(a,2)) equals 1
end
@printf "\nsince the length of w(t) grows slowly:\n" 
for t=1:length(ws)
	@printf "proof step 3: ||w(t)|| = %0.3f\n" norm(ws[t],2) 
end
#treat h as target hypothesis 
g=h

#performance
@printf "\nThe performance of the PLA is:\n" 
@show g .== y
@printf "done in %d iterations starting from t=0\n" (t-1)


