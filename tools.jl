answer{T}(answers::Vector{T},result::T) = begin
	val,aindx = findmin(abs(answers - result))
	result, convert(Char,aindx+96),answers[aindx] #add 96 t
end

answer_min{T}(answers::Vector{T}) = begin
	val,aindx = findmin(answers)
	val, convert(Char,aindx+96) #add 96 t
end