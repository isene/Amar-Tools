import random
randomize()

proc D(x: int): int = result = random(x) + 1

var
  m = true
  mark = ""
  d = D(6)
  t = D(6)

if d == 1:
  while t < 4:
    if t == 1 and m == false: m = true
    elif t == 1 and m == true: mark = " fumble"
    else: m = false
    dec(d)
    t = D(6)

if d == 6:
  while t > 3:
    if t == 6 and m == false: m = true
    elif t == 6 and m == true: mark = " critical"
    else: m = false
    inc(d)
    t = D(6)

echo d, mark

