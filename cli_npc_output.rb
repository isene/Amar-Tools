# This is the CLI module for Amar Tools
# where the characters are saved to a file
#
# This function outputs the character n to screen, 
# then to a file named "temp.npc",
# and a file named after the NPC, "<FirstLast>.npc

def npc_output(n, cli) 

  mag = n.spell0(0) + n.spell1(0) + n.spell2(0) + n.spell3(0) + n.spell4(0)
  mag += n.spell5(0) + n.spell6(0) + n.spell7(0) + n.spell8(0)
 
	f  = ""
	f += " (You may want to bookmark this URL for future references to this NPC)\n\n" unless cli == "cli"
  f += "############################<By Amar Tools>############################\n\n"
  f += "Created: #{Date.today.to_s}".rjust(71) + "\n"
  f += "Name:".ljust(9) + n.name 
  f += "\n"
  f += "Type:".ljust(9) + (n.type + " (" + n.level.to_s + ")").ljust(23)
  f += "Sex:".ljust(5) + n.sex.ljust(18)
  f += "Height:".ljust(8) + n.height.to_s
  f += "\n"
  f += "Area:".ljust(9) + n.area.ljust(23)
  f += "Age:".ljust(5) + n.age.to_s.ljust(18)
  f += "Weight:".ljust(8) + n.weight.to_s
  f += "\n"
  f += "-----------------------------------------------------------------------\n"
  f += "Description:".ljust(14) + n.description
  f += "\n"
  f += "-----------------------------------------------------------------------\n"
  f += "SIZE:".ljust(9) + n.size.to_s.ljust(11)
  f += "Balance:".ljust(17) + n.balance.to_s.ljust(9)
  f += "Detect Traps:".ljust(17) + n.dtraps.to_s.ljust(9)
  f += "\n"
  f += "STRNG:".ljust(9) + n.strng.to_s.ljust(11)
  f += "Climb:".ljust(17) + n.climb.to_s.ljust(9)
  f += "Reaction Speed:".ljust(17) + n.react.to_s.ljust(9)
  f += "\n"
  f += "ENDUR:".ljust(9) + n.endur.to_s.ljust(11)
  f += "Dodge:".ljust(17) + n.dodge.to_s.ljust(9)
  f += "Tracking:".ljust(17) + n.tracking.to_s.ljust(9)
  f += "\n"
  f += "COORD:".ljust(9) + n.coord.to_s.ljust(11)
  f += "Hide:".ljust(17) + (n.hide.to_s + "/" + n.modhide.to_s).ljust(9)
  f += "*" + (n.percept1 + ":").ljust(16) + n.percept1s.to_s.ljust(9)
  f += "\n"
  f += "LEARN:".ljust(9) + n.learn.to_s.ljust(11)
  f += "Mvqt:".ljust(17) + (n.mvqt.to_s + "/" + n.modmvqt.to_s).ljust(9)
  f += "\n"
  f += "AWARE:".ljust(9) + n.aware.to_s.ljust(11)
  f += "Ride:".ljust(17) + n.ride.to_s.ljust(9)
  f += "Medical lore:".ljust(17) + n.medicall.to_s.ljust(9)
  f += "\n"
  f += "MAGAP:".ljust(9) + n.magap.to_s.ljust(11)
  f += "Sleight:".ljust(17) + n.sleight.to_s.ljust(9)
  f += "Read/write:".ljust(17) + n.readwrite.to_s.ljust(9)
  f += "\n"
  f += " ".ljust(20)
  f += "Swim:".ljust(17) + n.swim.to_s.ljust(9)
  f += "Spoken:".ljust(17) + n.spoken.to_s.ljust(9)
  f += "\n"
  f += "DB:".ljust(9) + n.db.to_s.ljust(11)
  f += "Tumble:".ljust(17) + n.tumble.to_s.ljust(9)
  f += "*" + (n.lore1 + ":").ljust(16) + n.lore1s.to_s.ljust(9)
  f += "\n"
  f += "BP:".ljust(9) + n.bp.to_s.ljust(11)
  f += "*" + (n.physical1 + ":").ljust(16) + n.physical1s.to_s.ljust(9)
  f += "*" + (n.lore2 + ":").ljust(16) + n.lore2s.to_s.ljust(9)
  f += "\n"
  f += "MD:".ljust(9) + n.md.to_s.ljust(11)
  f += "*" + (n.physical2 + ":").ljust(16) + n.physical2s.to_s.ljust(9)
  f += "*" + (n.lore3 + ":").ljust(16) + n.lore3s.to_s.ljust(9)
  f += "\n"
  f += " ".ljust(20)
  f += "*" + (n.physical3 + ":").ljust(16) + n.physical3s.to_s.ljust(9)
  f += "\n"
  f += "-----------------------------------------------------------------------\n"
  f += "Cult:".ljust(9) + n.cult + ", " + n.cultstat1 + " (" + n.cs.to_s + ")"
  f += "\n"
  f += "-----------------------------------------------------------------------\n"
  f += "ENC:".ljust(9) + n.enc.to_s.ljust(11)
  f += "Armour:".ljust(10) + n.armour.ljust(15)
  f += "Social status:".ljust(16) + n.socstatus.ljust(9)
  f += "\n"
  f += "Status:".ljust(9) + n.status.to_s.ljust(11)
  f += "AP:".ljust(10) + n.ap.to_s.ljust(15)
  f += "Money:".ljust(16) + n.money.to_s.ljust(9)
  f += "\n"
  f += "-----------------------------------------------------------------------\n"
  f += "WEAPON             SKILL    INI     OFF    DEF    DAM    HP    RANGE\n"
  f += n.melee1.ljust(21)
  f += n.melee1s.to_s.ljust(8)
  f += n.melee1i.to_s.ljust(8)
  f += n.melee1o.to_s.ljust(7)
  f += n.melee1d.to_s.ljust(7)
  f += n.melee1dam.to_s.ljust(6)
  f += n.melee1hp.to_s.ljust(5)
  if  n.melee2s != 0
    f += "\n"
    f += n.melee2.ljust(21)
    f += n.melee2s.to_s.ljust(8)
    f += n.melee2i.to_s.ljust(8)
    f += n.melee2o.to_s.ljust(7)
    f += n.melee2d.to_s.ljust(7)
    f += n.melee2dam.to_s.ljust(6)
    f += n.melee2hp.to_s.ljust(5)
  end
  if  n.melee3s != 0
    f += "\n"
    f += n.melee3.ljust(21)
    f += n.melee3s.to_s.ljust(8)
    f += n.melee3i.to_s.ljust(8)
    f += n.melee3o.to_s.ljust(7)
    f += n.melee3d.to_s.ljust(7)
    f += n.melee3dam.to_s.ljust(6)
    f += n.melee3hp.to_s.ljust(5)
  end
  f += "\n"
  f += "> "
  f += n.missile1.ljust(19)
  f += n.missile1s.to_s.ljust(8)
  f += n.missile1i.to_s.ljust(8)
  f += n.missile1o.to_s.ljust(7)
  f += "-".ljust(7)
  f += n.missile1dam.to_s.ljust(6)
  f += "-".ljust(6)
  f += n.missile1rng.to_s + "/" + n.missile1rmax.to_s  
  if n.missile2s != 0
    f += "\n"
    f += "> "
    f += n.missile2.ljust(19)
    f += n.missile2s.to_s.ljust(8)
    f += n.missile2i.to_s.ljust(8)
    f += n.missile2o.to_s.ljust(7)
    f += "-".ljust(7)
    f += n.missile2dam.to_s.ljust(6)
    f += "-".ljust(6)
    f += n.missile2rng.to_s + "/" + n.missile2rmax.to_s
  end
  if n.maglore != 0
    f += "\n"
    f += "-----------------------------------------------------------------------\n"
    f += "Magick lore:".ljust(14) + n.maglore.to_s.ljust(6)
    f += "Magick type:".ljust(14) + n.magtype1.ljust(12)
    f += "Spell lore:".ljust(14) + n.splore.to_s.ljust(6)
    f += "\n"
  end
  if mag != 0
    f += "\n"
    f += "SPELL               LEVEL  DR  A?  R?  CT  DUR  RNG  WT    AoE"
  end
  if n.spell0(0) != 0
    f += "\n"
    f += n.spell0(1).ljust(22)
    f += n.spell0(0).to_s.ljust(5)
    f += n.spell0(5).to_s.ljust(4)
    f += n.spell0(2).ljust(4)
    f += n.spell0(3).ljust(4)
    f += n.spell0(4).ljust(4)
    f += n.spell0(6).ljust(5)
    f += n.spell0(7).ljust(5)
    f += n.spell0(8).ljust(6)
    f += n.spell0(9)
  end
  if n.spell1(0) != 0
    f += "\n"
    f += n.spell1(1).ljust(22)
    f += n.spell1(0).to_s.ljust(5)
    f += n.spell1(5).to_s.ljust(4)
    f += n.spell1(2).ljust(4)
    f += n.spell1(3).ljust(4)
    f += n.spell1(4).ljust(4)
    f += n.spell1(6).ljust(5)
    f += n.spell1(7).ljust(5)
    f += n.spell1(8).ljust(6)
    f += n.spell1(9)
  end
  if n.spell2(0) != 0
    f += "\n"
    f += n.spell2(1).ljust(22)
    f += n.spell2(0).to_s.ljust(5)
    f += n.spell2(5).to_s.ljust(4)
    f += n.spell2(2).ljust(4)
    f += n.spell2(3).ljust(4)
    f += n.spell2(4).ljust(4)
    f += n.spell2(6).ljust(5)
    f += n.spell2(7).ljust(5)
    f += n.spell2(8).ljust(6)
    f += n.spell2(9)
  end
  if n.spell3(0) != 0
    f += "\n"
    f += n.spell3(1).ljust(22)
    f += n.spell3(0).to_s.ljust(5)
    f += n.spell3(5).to_s.ljust(4)
    f += n.spell3(2).ljust(4)
    f += n.spell3(3).ljust(4)
    f += n.spell3(4).ljust(4)
    f += n.spell3(6).ljust(5)
    f += n.spell3(7).ljust(5)
    f += n.spell3(8).ljust(6)
    f += n.spell3(9)
  end
  if n.spell4(0) != 0
    f += "\n"
    f += n.spell4(1).ljust(22)
    f += n.spell4(0).to_s.ljust(5)
    f += n.spell4(5).to_s.ljust(4)
    f += n.spell4(2).ljust(4)
    f += n.spell4(3).ljust(4)
    f += n.spell4(4).ljust(4)
    f += n.spell4(6).ljust(5)
    f += n.spell4(7).ljust(5)
    f += n.spell4(8).ljust(6)
    f += n.spell4(9)
  end
  if n.spell5(0) != 0
    f += "\n"
    f += n.spell5(1).ljust(22)
    f += n.spell5(0).to_s.ljust(5)
    f += n.spell5(5).to_s.ljust(4)
    f += n.spell5(2).ljust(4)
    f += n.spell5(3).ljust(4)
    f += n.spell5(4).ljust(4)
    f += n.spell5(6).ljust(5)
    f += n.spell5(7).ljust(5)
    f += n.spell5(8).ljust(6)
    f += n.spell5(9)
  end
  if n.spell6(0) != 0
    f += "\n"
    f += n.spell6(1).ljust(22)
    f += n.spell6(0).to_s.ljust(5)
    f += n.spell6(5).to_s.ljust(4)
    f += n.spell6(2).ljust(4)
    f += n.spell6(3).ljust(4)
    f += n.spell6(4).ljust(4)
    f += n.spell6(6).ljust(5)
    f += n.spell6(7).ljust(5)
    f += n.spell6(8).ljust(6)
    f += n.spell6(9)
  end
  if n.spell7(0) != 0
    f += "\n"
    f += n.spell7(1).ljust(22)
    f += n.spell7(0).to_s.ljust(5)
    f += n.spell7(5).to_s.ljust(4)
    f += n.spell7(2).ljust(4)
    f += n.spell7(3).ljust(4)
    f += n.spell7(4).ljust(4)
    f += n.spell7(6).ljust(5)
    f += n.spell7(7).ljust(5)
    f += n.spell7(8).ljust(6)
    f += n.spell7(9)
  end
  if n.spell8(0) != 0
    f += "\n"
    f += n.spell8(1).ljust(22)
    f += n.spell8(0).to_s.ljust(5)
    f += n.spell8(5).to_s.ljust(4)
    f += n.spell8(2).ljust(4)
    f += n.spell8(3).ljust(4)
    f += n.spell8(4).ljust(4)
    f += n.spell8(6).ljust(5)
    f += n.spell8(7).ljust(5)
    f += n.spell8(8).ljust(6)
    f += n.spell8(9)
  end
  f += "\n\n#######################################################################"

	# from functions.rb - save to temp file and named file
	save_temp_file(f, "temp", cli)
	save_named_file(f, n.name.delete(' '), cli)

end
