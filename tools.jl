answer{T}(proposals::Vector{T},result::T) = begin
	val,aindx = findmin(abs(proposals - result))
	result, convert(Char,aindx+96),proposals[aindx] #adds 96 to transform number to letter
end

answer_min{T}(proposals::Vector{T}) = begin
	val,aindx = findmin(proposals)
	val, convert(Char,aindx+96) #adds 96 to transform number to letter
end