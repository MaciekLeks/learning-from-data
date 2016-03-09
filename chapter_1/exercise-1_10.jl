# See LFD book, page: 23

# forum 1: http://book.caltech.edu/bookforum/showthread.php?t=257
# forum 2: http://book.caltech.edu/bookforum/showthread.php?t=4621
# forum 3: http://book.caltech.edu/bookforum/showthread.php?t=4474
gc()
using DataArrays, DataFrames, Gadfly
const COINS = 1000
const TOSSES = 10
const EXPERIMENTS = 100000
const μ = 0.5
#1 - head, 0 - tail

hoeffding_rhs(n::Int) = (ε::Float64) -> 2.0*exp(-2.0*(ε^2.0)*n) 

simul(experiments::Int) = begin
	c1s = zeros(Int, experiments) #v1
	crands = zeros(Int, experiments) #vrand
	cmins = zeros(Int, experiments) #vmin

	for k=1:experiments
		coins = map(Int, rand(COINS, TOSSES) .>= 0.5) #Flips all coins (1 = heads ; 0 = tails)
		c1 = coins[1,:] #(1,10)tu całe 10 rzutów schodzi
		crand = coins[rand(1:COINS),:]
		cmin = coins[findmin(sum(coins,2))[2],:] #(1,10)
		

		c1s[k] = sum(c1) #/ TOSSES
		crands[k] = sum(crand) #/ TOSSES
		cmins[k] = sum(cmin) #/ TOSSES
	end
	c1s, crands, cmins
end

fraction(arr::Vector{Float64}) = (ε) -> mean(map(Int,(abs(arr .- μ) .>= ε))) #ale to nie prawdopodobieństwo
#Histogram 

#(a) What is mu for the three coins selected?
#We have fair coins, so for every c1, crand, cmin is 0.5. See: http://book.caltech.edu/bookforum/showthread.php?t=4474

#(b)
c1s,crands,cmins = simul(EXPERIMENTS)
v1 = mean(c1s./TOSSES)
vrand = mean(crands./TOSSES)
vmin = mean(cmins./TOSSES)
#vrand = mean(crands./TOSSES)
#vmin = mean(cmins./TOSSES)
println("Experiment 2: run $EXPERIMENTS times: Fraction of heads for v1:$v1, vrand:$vrand and vmin:$vmin")
#Ciekawie pokazuje rozkład dla v1, vrand
# plot(layer(x=v1s, Geom.histogram, Theme(default_color=color("green"))), 
# 	layer(x=vrands, Geom.histogram, Theme(default_color=color("red"))), 
# 	layer(x=vmins, Geom.histogram, Theme(default_color=color("blue"))))

#(c)

epsilons = linspace(0.1,1.0,10)
v1_frac=fraction(c1s./TOSSES)
vrand_frac=fraction(crands./TOSSES)
vmin_frac=fraction(cmins./TOSSES)
hoef = hoeffding_rhs(TOSSES)
df=DataFrame(ε=epsilons, 
		lhs_prob_v1=map((epsi) -> v1_frac(epsi),epsilons),
		lhs_prob_vrand=map((epsi) -> vrand_frac(epsi),epsilons),
		lhs_prob_vmin=map((epsi) -> vmin_frac(epsi),epsilons),
		rhs_hoeffding=map((epsi) -> hoef(epsi),epsilons)
)





set_default_plot_size(28cm, 25cm)
dd =plot(df,
	layer(x="ε", y="lhs_prob_v1", Geom.point, Geom.line, Theme(default_color=color("green"))),
	layer(x="ε", y="lhs_prob_vrand", Geom.point, Geom.line, Theme(default_color=color("orange"))),
	layer(x="ε", y="lhs_prob_vmin", Geom.point, Geom.line, Theme(default_color=color("blue"))),
	layer(x="ε", y="rhs_hoeffding", Geom.point, Geom.line, Theme(default_color=color("red"))),
	Guide.ylabel("Probabilities"),
	Guide.title("Exercise 1.10/c"),
	Guide.manual_color_key("Legend", ["P[|v1-μ|>ε]", "P[|vrand-μ|>ε]", "P[|vmin-μ|>ε]", "hoeffding_rhs(N=10,ε)"], ["green", "orange", "blue", "red"])
)
draw(PNG("excercise-1_10_c.png", 24cm, 25cm) , dd);
draw(SVG("excercise-1_10_c.svg", 24cm, 25cm) , dd);

#odpowiedź d: Rzuty działa dla c1 i crand a nie działa dla cmin. Dlaczego? Dlatego, że HI (hoeffding inequality)
#dziaa tylko dla pojedynczego eksperymentu tj. jedna moneta rzucona 10 razy a nie dla przypadku zmiany wyników eksperymentów
#patrz Lesson 02 od 0.44min tam to jest pokazane. Pokazał. Policz prawdopodobieństwo, że wyrzucisz 10 orłów w 0 rzutach. To jest
#mało prawdopodobne (~0.1%), ale policz prawd., że wyrzucić 10 orłów rzucając 1tys monet - to jest już bardzo wysoka wartość (63%).
#HI działa tylko dla tych pojedynczych eksperymentów (rzutów) a nie na M równoległych eksperymentach (rzutach)
#odpowiedź e: każda moneta (1000) to nic innego jak pojedynczy bin przy czym z każdego ciągniemy 10 moment (binomial distribution - losowanie ze zwrotem)

#uwaga: powtórzenia EXPERIMENTS są po to, żeby usunąć szum a nie mają nic wspólnego z samym eksperymentem gdzie liczy się TOSSES i COINS

