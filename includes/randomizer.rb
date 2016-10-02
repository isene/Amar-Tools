def randomizer(params)
	par = {}
	par.merge!(params)
  i = 1
  par.each_key do |key|
    par[key] += i
    i = par[key]
  end
  result = rand(i).to_i
  par.each_value do |value|
    return par.key(value) if value > result
  end
end
