combs(k, N) = factorial(N)/(factorial(k)*factorial(N-k))


breakpoint(mh::Function, iters=10) = begin
	k = 1
	while mh(k) == 2^k && k <= iters
	 	k += 1
	end
	k > iters ? NaN : k 
end

is_theorem2_4_strong_satisfied(mh::Function, k::Int, N::Int) = begin 
	rhs = 0
	for i=0:(k-1)
		rhs += combs(i, N)
	end 
	mh(N) <= rhs
end

is_theorem2_4_weak_satisfied(mh::Function, k::Int, N::Int) = begin 
	mh(N) <= N^(k-1)+1
end


when_theorem_2_4_breaks(theorem::Function, mh::Function, k::Int, iters=100) = begin
	for i=k:iters
		if !theorem(mh, k, i)
			return i
		end
	end
	return iters+1 
end

theorem2_4_strong_vs_weak_proof(mh::Function, k::Int, N::Int) = begin 
	strong = 0
	for i=0:(k-1)
		strong += combs(i, N)
	end 
	weak = N^(k-1) + 1
	
	(strong, weak, strong<=weak)
end
