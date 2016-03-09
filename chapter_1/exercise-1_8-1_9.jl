C = (k,n) -> factorial(n)/(factorial(k)*factorial(n-k))

#Exercise 1.8
const N = 10
const μ = 0.9
const υ = 0.1
@show P_X_le_1 = C(0,N)*μ^0*(1-μ)^N + C(1,N)*μ^1*(1-μ)^(N-1)

#Exercise 1.9
#Hoeffding Inequality
hoeffding_rhs(ε,N) = 2*exp(-2*ε^2*N) 
const ε = abs(υ - μ)  



@show P_hoeffding_rhs = 2*exp(-2*ε^2*N) 

@show P_hoeffding_rhs / P_X_le_1 

