# Dice-rolling for NPCg

# Simple multisided dice
def dX (x)
	return rand(1..x)
end

# The normal d6
def d6
	return rand(1..6)
end

# The open-ended d6
def oD6
  result = d6
  return result if result === (2..5)
    if result == 1
      down = d6
      while down <= 3
        down = d6
        result -= 1
      end
    elsif result == 6
      up = d6
      while up >= 4
        up = d6
        result += 1
      end
    end
  return result
end

# An average of two d6's
def aD6
  result = ( d6 + oD6 ) / 2
  result = result.to_i
  return result
end


