using Distributions, DataFrames, Gadfly;

N = 10.0
Ns = 1:50
αs = linspace(0.001,0.999,40)
εs = linspace(0.001,0.499, 40)
chernoff_rhs(α::Float64, s::Float64) = (0.5*exp(-s*α) + 0.5*exp(s*(1-α)))^N
min_chernoff_rhs(α::Float64) = chernoff_rhs(α, log(α./(1.0 - α)))
#min_chernoff_rhs(α::Float64) = 0.5*((1.0-α)/α)^α + 0.5*((1.0-α)/α)^(α-1) #po wstawaneiu s=log(α./(1.0 - α) do chernoff_rhs
β(ε::Float64) = 1 + (0.5 + ε)*log2(0.5 + ε) + (0.5 - ε)*log2(0.5 - ε)
wanted_min_coin_chernoff_rhs(ε::Float64) = 2.0^(-β(ε)*N) #min to be proven
min_coin_chernoff_rhs(;ε=0.0) = (N::Int) -> 2.0^(-β(ε)*N)


draw(PNG("problem-1_9_c_beta.png", 18cm, 18cm), plot(β, εs[1], εs[length(εs)],
	Guide.ylabel("β"),
	Guide.xlabel("ε"),
	Guide.title("Problem 1.9/c - β(ε) for ε ∈ (0,0.5)")
))


draw(PNG("problem-1_9_c_chernoff-coin-RHS.png", 18cm, 18cm),
	plot(
		layer(x=Ns, y=map(min_coin_chernoff_rhs(ε=0.1),Ns),Geom.point, Geom.line, Theme(default_color=colorant"#000000")),
		layer(x=Ns, y=map(min_coin_chernoff_rhs(ε=0.2),Ns),Geom.point, Geom.line, Theme(default_color=colorant"#005555")),
		layer(x=Ns, y=map(min_coin_chernoff_rhs(ε=0.3),Ns),Geom.point, Geom.line, Theme(default_color=colorant"#22aadd")),
		layer(x=Ns, y=map(min_coin_chernoff_rhs(ε=0.4),Ns),Geom.point, Geom.line, Theme(default_color=colorant"#77cc66")),
		layer(x=Ns, y=map(min_coin_chernoff_rhs(ε=0.5),Ns),Geom.point, Geom.line, Theme(default_color=colorant"#99ffff")),
		Guide.ylabel("P[u ≥ E[u] + ε] ≤ 2^-βN"),
		Guide.xlabel("N"),
		Guide.title("Problem 1.9/c - P[u ≥ E[u] + ε] ≤ 2^-βN"),
		Guide.manual_color_key("Legend", ["ε=0.1","ε=0.2","ε=0.3","ε=0.4","ε=0.5"], ["#000000","#005555","#22aadd","#77cc66","#99ffff"])
))



df=DataFrame(α=αs,
		ε=εs,
		chernoff_rhs=map((α) -> min_chernoff_rhs(α), αs),
		wanted_chernoff_coin_rhs=map((ε) -> wanted_min_coin_chernoff_rhs(ε), εs),
)


draw(PNG("problem-1_9_c-min_rhs_chernoff.png", 18cm, 18cm),
	plot(df,
	layer(x="α", y="chernoff_rhs", Geom.point, Geom.line, Theme(default_color=colorant"red")),
	layer(x="ε", y="wanted_chernoff_coin_rhs", Geom.point, Geom.line, Theme(default_color=colorant"blue")),
	Guide.ylabel("mininized Chernoff RHS with respect to s for the given α"),
	Guide.title("Problem 1.9/c Chernoff for α ∈ (0,1)  and ε ∈ (0,0.5)"),
	Guide.manual_color_key("Legend", ["chernoff_rhs","wanted chernoff rhs for fair coin"], ["red", "blue"])

))





