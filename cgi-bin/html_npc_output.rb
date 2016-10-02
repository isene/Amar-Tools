#!/usr/bin/env ruby

require "cgi"
require "erb"

load "../includes/includes.rb"

cgi = CGI.new
tmpl = File.read("../npc_output.html")

@name   = cgi["name"].to_s
@type   = cgi["type"].to_s
@level  = cgi["level"].to_s.to_i
@area   = cgi["area"].to_s
case     cgi["sex"] .to_s
  when ""       then @sex = ""
  when "male"   then @sex = "M"
  when "female" then @sex = "F"
end
@age    = cgi["age"].to_s.to_i
@height = cgi["height"].to_s.to_i
@weight = cgi["weight"].to_s.to_i
@description = cgi["description"].to_s

@type = "" if @type == "(Type)"
@area = "" if @area == "(Area)" #level is taken care of by .to_i

n = Npc.new(@name, @type, @level, @area, @sex, @age, @height, @weight, @description)

@name = n.name
@type = n.type
@level = n.level
@area = n.area
@sex = n.sex
@age = n.age
@height = n.height
@weight = n.weight
@description = n.description
@size = n.size
@strng = n.strng
@endur = n.endur
@coord = n.coord
@learn = n.learn
@aware = n.aware
@magap = n.magap
@db = n.db
@bp = n.bp
@md = n.md
@cs = n.cs
@cult = n.cult
@cultstat1 = n.cultstat1
@balance = n.balance
@climb = n.climb
@dodge = n.dodge
@hide = n.hide
@modhide = n.modhide
@mvqt = n.mvqt
@modmvqt = n.modmvqt
@ride = n.ride
@sleight = n.sleight
@swim = n.swim
@tumble = n.tumble
@physical1 = n.physical1
@physical1s = n.physical1s
@physical2 = n.physical2
@physical2s = n.physical2s
@physical3 = n.physical3
@physical3s = n.physical3s
@dtraps = n.dtraps
@tracking = n.tracking
@percept1 = n.percept1
@percept1s = n.percept1s
@medicall = n.medicall
@readwrite = n.readwrite
@spoken = n.spoken
@lore1 = n.lore1
@lore1s = n.lore1s
@lore2 = n.lore2
@lore2s = n.lore2s
@lore3 = n.lore3
@lore3s = n.lore3s
@enc = n.enc
@status = n.status
@armour = n.armour
@ap = n.ap
@socstatus = n.socstatus
@money = n.money
@melee1 = n.melee1
@melee1s = n.melee1s
@melee1i = n.melee1i
@melee1o = n.melee1o
@melee1d = n.melee1d
@melee1dam = n.melee1dam
@melee1hp = n.melee1hp

if n.melee2s != 0
	@ml2 = true
	@melee2 = n.melee2
	@melee2s = n.melee2s
	@melee2i = n.melee2i
	@melee2o = n.melee2o
	@melee2d = n.melee2d
	@melee2dam = n.melee2dam
	@melee2hp = n.melee2hp
else
	@ml2 = false
end

if n.melee3s != 0
	@ml3 = true
	@melee3 = n.melee3
	@melee3s = n.melee3s
	@melee3i = n.melee3i
	@melee3o = n.melee3o
	@melee3d = n.melee3d
	@melee3dam = n.melee3dam
	@melee3hp = n.melee3hp
else
	@ml3 = false
end

@missile1 = n.missile1
@missile1s = n.missile1s
@missile1sr = n.missile1sr
@missile1o = n.missile1o
@missile1dam = n.missile1dam
@missile1rng = n.missile1rng
@missile1rmax = n.missile1rmax

if n.missile2s != 0
	@ms2 = true
	@missile2 = n.missile2
	@missile2s = n.missile2s
	@missile2sr = n.missile2sr
	@missile2o = n.missile2o
	@missile2dam = n.missile2dam
	@missile2rng = n.missile2rng
	@missile2rmax = n.missile2rmax
else
	@ms2 = false
end

if n.maglore != 0
	@mg = true
	@maglore = n.maglore
	@splore = n.splore
	@magtype1 = n.magtype1
else
	@mg = false
end

if n.spell0(0) != 0
	@sp0 = true
	@spell0s = n.spell0(0)
	@spell0n = n.spell0(1)
	@spell0ap = n.spell0(2)
	@spell0r = n.spell0(3)
	@spell0ct = n.spell0(4)
	@spell0dr = n.spell0(5)
	@spell0dur = n.spell0(6)
	@spell0rng = n.spell0(7)
	@spell0wt = n.spell0(8)
	@spell0aoe = n.spell0(9)
else
	@sp0 = false
end

if n.spell1(0) != 0
	@sp1 = true
	@spell1s = n.spell1(0)
	@spell1n = n.spell1(1)
	@spell1ap = n.spell1(2)
	@spell1r = n.spell1(3)
	@spell1ct = n.spell1(4)
	@spell1dr = n.spell1(5)
	@spell1dur = n.spell1(6)
	@spell1rng = n.spell1(7)
	@spell1wt = n.spell1(8)
	@spell1aoe = n.spell1(9)
else
	@sp1 = false
end
if n.spell2(0) != 0
	@sp2 = true
	@spell2s = n.spell2(0)
	@spell2n = n.spell2(1)
	@spell2ap = n.spell2(2)
	@spell2r = n.spell2(3)
	@spell2ct = n.spell2(4)
	@spell2dr = n.spell2(5)
	@spell2dur = n.spell2(6)
	@spell2rng = n.spell2(7)
	@spell2wt = n.spell2(8)
	@spell2aoe = n.spell2(9)
else
	@sp2 = false
end
if n.spell3(0) != 0
	@sp3 = true
	@spell3s = n.spell3(0)
	@spell3n = n.spell3(1)
	@spell3ap = n.spell3(2)
	@spell3r = n.spell3(3)
	@spell3ct = n.spell3(4)
	@spell3dr = n.spell3(5)
	@spell3dur = n.spell3(6)
	@spell3rng = n.spell3(7)
	@spell3wt = n.spell3(8)
	@spell3aoe = n.spell3(9)
else
	@sp3 = false
end
if n.spell4(0) != 0
	@sp4 = true
	@spell4s = n.spell4(0)
	@spell4n = n.spell4(1)
	@spell4ap = n.spell4(2)
	@spell4r = n.spell4(3)
	@spell4ct = n.spell4(4)
	@spell4dr = n.spell4(5)
	@spell4dur = n.spell4(6)
	@spell4rng = n.spell4(7)
	@spell4wt = n.spell4(8)
	@spell4aoe = n.spell4(9)
else
	@sp4 = false
end
if n.spell5(0) != 0
	@sp5 = true
	@spell5s = n.spell5(0)
	@spell5n = n.spell5(1)
	@spell5ap = n.spell5(2)
	@spell5r = n.spell5(3)
	@spell5ct = n.spell5(4)
	@spell5dr = n.spell5(5)
	@spell5dur = n.spell5(6)
	@spell5rng = n.spell5(7)
	@spell5wt = n.spell5(8)
	@spell5aoe = n.spell5(9)
else
	@sp5 = false
end
if n.spell6(0) != 0
	@sp6 = true
	@spell6s = n.spell6(0)
	@spell6n = n.spell6(1)
	@spell6ap = n.spell6(2)
	@spell6r = n.spell6(3)
	@spell6ct = n.spell6(4)
	@spell6dr = n.spell6(5)
	@spell6dur = n.spell6(6)
	@spell6rng = n.spell6(7)
	@spell6wt = n.spell6(8)
	@spell6aoe = n.spell6(9)
else
	@sp6 = false
end
if n.spell7(0) != 0
	@sp7 = true
	@spell7s = n.spell7(0)
	@spell7n = n.spell7(1)
	@spell7ap = n.spell7(2)
	@spell7r = n.spell7(3)
	@spell7ct = n.spell7(4)
	@spell7dr = n.spell7(5)
	@spell7dur = n.spell7(6)
	@spell7rng = n.spell7(7)
	@spell7wt = n.spell7(8)
	@spell7aoe = n.spell7(9)
else
	@sp7 = false
end
if n.spell8(0) != 0
	@sp8 = true
	@spell8s = n.spell8(0)
	@spell8n = n.spell8(1)
	@spell8ap = n.spell8(2)
	@spell8r = n.spell8(3)
	@spell8ct = n.spell8(4)
	@spell8dr = n.spell8(5)
	@spell8dur = n.spell8(6)
	@spell8rng = n.spell8(7)
	@spell8wt = n.spell8(8)
	@spell8aoe = n.spell8(9)
else
	@sp8 = false
end

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
