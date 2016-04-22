include("./commons.jl")

mh(N) = N + 2^(floor(N/2))
@show k = breakpoint(mh)
@show when_theorem_2_4_breaks(is_theorem2_4_strong_satisfied, mh, k)
@show when_theorem_2_4_breaks(is_theorem2_4_weak_satisfied, mh, k)

#mh2(N)= 1+N+(N*(N-1)*(N-2))/6
#@show k2 = breakpoint(mh2)
#@show when_theorem_2_4_breaks(is_theorem2_4_strong_satisfied, mh2, k2)
#@show when_theorem_2_4_breaks(is_theorem2_4_weak_satisfied, mh2, k2)
