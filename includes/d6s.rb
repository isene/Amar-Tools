# Dice-rolling for NPCg

def dX (x)
  result = rand(x) + 1
  result = result.to_i
  return result
end

def d6
  result = rand(6) + 1
  result = result.to_i
  return result
end

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

def aD6
  result = ( d6 + oD6 ) / 2
  result = result.to_i
  return result
end


