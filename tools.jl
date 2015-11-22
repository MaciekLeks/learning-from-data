answer{T}(answers::Vector{T},result::T) = begin
	val,aindx = findmin(abs(answers - result))
	result, convert(Char,aindx+96),answers[aindx] #adds 96 to transform number to letter
end

answer_min{T}(answers::Vector{T}) = begin
	val,aindx = findmin(answers)
	val, convert(Char,aindx+96) #adds 96 to transform number to letter
end