# The engine for NPC Generation 0.4
#
# When the class is initialized, the npc is generated
# using data from the imported tables (hashes and arrays)
# The initialization can be done via "inputform.rb" or a
# web application or otherwise.


class Npc

  attr_reader :type, :level, :name, :area, :sex, :age
  attr_reader :height, :weight, :description, :spamount
  attr_reader :SIZE, :BP, :DB, :MD, :ENC, :STATUS
  attr_writer :name, :area, :sex, :age, :height, :weight, :description
  attr_writer :ENC

  def initialize(name, type, level, area, sex, age, height, weight, description)
  
    @name = name.to_s
    @type = type.to_s
    @level = level.to_i
    @area = area.to_s
    @sex = sex.to_s
    @age = age.to_i
    @height = height.to_i
    @weight = weight.to_i
    @description = description.to_s

    @spamount = 0

# Randomize omitted values, starting with a (primitive) name generator

  if @name == ""
    namecount = d6
    case namecount
      when 1..2
        namecount = 1
      when 3..5
        namecount = 2
      when 6
        namecount = 3
    end
    namecount.times do
      namelength = aD6 + 2
      namelength = 2 if namelength < 2
      c = 0
      w = 0
      namelength.times do |letternumber|
        l = rand(2).to_i
        if c == 2
          l = 0
          c = 0
        end
        if w == 2
          l = 1
          w = 0
        end
        case l
          when 0
            letter = randomizer(
            "a" => 5,
            "e" => 5,
            "i" => 4,
            "o" => 4,
            "u" => 2,
            "y" => 1)
            w += 1
            w += rand(2).to_i if w == 1
          when 1
            letter = randomizer(
            "b" => 4,
            "c" => 4,
            "d" => 5,
            "f" => 3,
            "g" => 3,
            "h" => 1,
            "j" => 2,
            "k" => 3,
            "l" => 5,
            "m" => 5,
            "n" => 5,
            "p" => 4,
            "q" => 1,
            "s" => 6,
            "t" => 6,
            "v" => 3,
            "w" => 1,
            "x" => 1,
            "z" => 1)
            c += 1
            c += rand(2).to_i if c == 1
        end
        letter = letter.upcase if letternumber == 0
        @name += letter
      end
      @name += " "
    end
  end

  unless $Chartype.has_key?(@type)
    @type = ""
  end
  
  if @type == ""
    i = 1
    tmp = Array.new
    $Chartype.each_key do |key|
      tmp[i] = key
      i += 1
    end
    t = (rand(tmp.length - 1) + 1).to_i
    @type = tmp[t]
  end

  if @level == 0
    @level = (rand(5) + 1).to_i
  end

  if @area == ""
    @area = randomizer(
      "Amaronir"  => 4,
      "Merisir"   => 2,
      "Calaronir" => 2,
      "Feronir"   => 2,
      "Aleresir"  => 2,
      "Rauinir"   => 3,
      "Outskirts" => 1,
      "Other"     => 1)
  end

  if @sex == ""
    var = rand(2).to_i
    case var
      when 0
        @sex = "F"
      else
        @sex = "M"
    end
  end

  @age = @level * 5 + oD6.abs * 3 + rand(10) if @age == 0
          
  if @height == 0
    @height = 160 + oD6 * 2 + oD6 + rand(10) 
    @height -= 5 if @sex == "F"
    @height -= (3 * (16 - @age)) if @age < 17
  end

  @weight = @height - 120 + aD6 * 4 + rand(10) if @weight == 0


# Then start working with the type array

    @npc = $Chartype[@type].dup


# Then generate the individual attributes

    @npc["attr"].each_key do |key|
      tmp = @npc["attr"][key]
      tmp = (tmp * (@level + 1)) / 3 - 2 + aD6
      tmp = 0 if tmp < 0
      tmp = 1 if tmp < 1 and key != "MAGAP"
      @npc["attr"][key] = tmp
    end

# Adjust the weight based on the STRNG

    @weight += @npc["attr"]["STRNG"] * 2 - 6


# Adjust female strength

    @npc["attr"]["STRNG"] = ((@npc["attr"]["STRNG"] * 0.8) + 1).to_i if @sex == "F"

# Generate the SIZE attribute

    case @weight
      when 0..19
        @SIZE = 1
      when 20..49
        @SIZE = 2
      when 50..99
        @SIZE = 3
      when 100..149
        @SIZE = 4
      when 150..224
        @SIZE = 5
      when 225..299
        @SIZE = 6
      when 300..399
        @SIZE = 7
      when 400..499
        @SIZE = 8
      when 500..599
        @SIZE = 9
      when 600..724
        @SIZE = 10
      when 725..849
        @SIZE = 11
      when 850..999
        @SIZE = 12
      when 1000..1149
        @SIZE = 13
      when 1150..1299
        @SIZE = 14
      when 1300..1449
        @SIZE = 15
      when 1450..1599
        @SIZE = 16
      else
        @SIZE = 16 + ((@weight - 1600) / 200).to_i
    end

# Then generate the individual skills

    @npc["c_skill"].each_key do |key|
      tmp = @npc["c_skill"][key]
      tmp = (tmp * (@level + 1)) / 3 - 2 + aD6 + (@npc["attr"]["COORD"] / 3)
      tmp = (tmp + @npc["attr"]["COORD"]) / 2 if tmp > @npc["attr"]["COORD"]
      tmp = 0 if tmp < 0
      @npc["c_skill"][key] = tmp.to_i
    end

    @npc["a_skill"].each_key do |key|
      tmp = @npc["a_skill"][key]
      tmp = (tmp * (@level + 1)) / 3 - 2 + aD6 + (@npc["attr"]["AWARE"] / 3)
      tmp = (tmp + @npc["attr"]["AWARE"]) / 2 if tmp > @npc["attr"]["AWARE"]
      tmp = 0 if tmp < 0
      @npc["a_skill"][key] = tmp.to_i
    end

    @npc["l_skill"].each_key do |key|
      tmp = @npc["l_skill"][key]
      tmp = (tmp * (@level + 1)) / 3 - 2 + aD6
      tmp = (tmp + @npc["attr"]["LEARN"]) / 2 if tmp > @npc["attr"]["LEARN"]
      tmp = 0 if tmp < 0
      @npc["l_skill"][key] = tmp
    end


# Calculate Body Points, Damage Bonus and Magick Defense

    @BP = 2 * @SIZE + (@npc["attr"]["ENDUR"] / 3).to_i
    @DB = ((@SIZE + @npc["attr"]["STRNG"]) / 3).to_i
    @MD = ((@npc["attr"]["MAGAP"] + @npc["attr"]["ENDUR"]) / 3).to_i


# Calculate modhide and modmvqt

    @modhide = @npc["c_skill"]["Hide"].to_i + @npc["items"]["Armour"][3].to_i
    @modmvqt = @npc["c_skill"]["Mvqt"].to_i + @npc["items"]["Armour"][2].to_i


# Adjust Weapon, Missile and Armour level if strength is to low

    case @npc["attr"]["STRNG"]
      when 1..2
        tmp = 1
      when 3
        tmp = 2
      when 4
        tmp = 3
      when 5
        tmp = 5
      when 6
        tmp = 6
      when 7
        tmp = 7
      else
        tmp = 8
    end

    if tmp <  @npc["specials"]["Arm-level"]
      @npc["specials"]["Arm-level"] = tmp
    end

    case @npc["attr"]["STRNG"]
      when 1
        tmp = 2
      when 2
        tmp = 4
      when 3
        tmp = 11
      when 4
        tmp = 18
      when 5
        tmp = 22
      when 7..8
        tmp = 28
      else
        tmp = 30
    end

    if tmp <  @npc["specials"]["Wpn-level"]
      @npc["specials"]["Wpn-level"] = tmp
    end

    case @npc["attr"]["STRNG"]
      when 1
        tmp = 2
      when 2
        tmp = 5
      when 3
        tmp = 7
      when 4..5
        tmp = 9
      when 6..7
        tmp = 10
      when 8..9
        tmp = 11
      else
        tmp = 12
    end

    if tmp <  @npc["specials"]["Msl-level"]
      @npc["specials"]["Msl-level"] = tmp
    end


# Calculate Social status and money

    tmp = @npc["specials"]["Status"]
    tmp = (4 * tmp + @level + aD6) / 5
    tmp = 0 if tmp < 0
    @npc["specials"]["Status"] = tmp.to_i

    tmp = @npc["items"]["Money"]
    tmp = ((tmp * oD6).abs / 3.5).to_i
    @npc["items"]["Money"] = tmp


# Get religion and status within the religion along with CS (Cultstanding)
# First determine the off chance of a totally different cult than usual

    tmp = rand(12)
    @npc["specials"]["Cult"] = ["any"] if tmp == 0

    tmp = rand(@npc["specials"]["Cult"].length).to_i
    @npc["specials"]["Cult"] = @npc["specials"]["Cult"][tmp]
    if @npc["specials"]["Cult"] == "any"
      @npc["specials"]["Cult"] = randomizer(
        "Alesia"      => 4,
        "Anashina"    => 3,
        "Cal Amae"    => 2,
        "Elesi"       => 1,
        "(evil god)"  => 1,
        "Fal Munir"   => 2,
        "Gewillyn"    => 2,
        "Ielina"      => 3,
        "Ikalio"      => 3,
        "Juba"        => 3,
        "Kraagh"      => 2,
        "(lesser god)"=> 4,
        "Maleko"      => 2,
        "Man Peggon"  => 1,
        "Mestronorpha"=> 1,
        "Moltan"      => 3,
        "nobility"    => 6,
        "Recolar"     => 3,
        "Shalissa"    => 3,
        "Taroc"       => 5,
        "Timelords"   => 1,
        "Tsankili"    => 2,
        "Walmaer"     => 5,
        "None"        => 6)
    end

    if @npc["specials"]["Cult"] == "nobility"
      @npc["specials"]["Cult"] = "MacGillan" if @sex == "M"
      @npc["specials"]["Cult"] = "Gwendyll" if @sex == "F"
      nobility = true
    end

    tmp = @npc["specials"]["Cultstat1"] + @level + (d6 + d6 + d6)/3
    case tmp
    when 0...8
      @npc["specials"]["Cultstat1"] = "Interested"
      @npc["specials"]["CS"] = 0
    when 8...10
      @npc["specials"]["Cultstat1"] = "Lay member"
      @npc["specials"]["CS"] = (@npc["specials"]["CS"] / 5).to_i 
    when 10...13
      @npc["specials"]["Cultstat1"] = "Initiated"
      if nobility
        @npc["specials"]["Status"] = 4 if @npc["specials"]["Status"] < 4 
      end
    else
      @npc["specials"]["Cultstat1"] = "Protector/Priest"
      if nobility
        @npc["specials"]["Status"] = 5 if @npc["specials"]["Status"] < 5 
      end
    end

    if @npc["specials"]["Cult"] == ["None"]
      @npc["specials"]["Cultstat1"] = "" 
      @npc["specials"]["Status"] = 5
    end

    tmp = @npc["specials"]["CS"]
    tmp = (2 * tmp) + @level + (3 * aD6) - 15
    tmp = 0 if tmp < 0
    @npc["specials"]["CS"] = tmp


# Transform Social status to words

    case @npc["specials"]["Status"]
    when 0
      @npc["specials"]["Status"] = "S"
    when 1
      @npc["specials"]["Status"] = "LC"
    when 2
      @npc["specials"]["Status"] = "LMC"
    when 3
      @npc["specials"]["Status"] = "MC"
    when 4
      @npc["specials"]["Status"] = "UC"
    else
      @npc["specials"]["Status"] = "N"
    end


# Pick armour and weapons for the character (and drop duplicates)

    tmp = rand(@npc["specials"]["Arm-level"]) + 1
    tmp.to_i
    @npc["items"]["Armour"] = $Armour[tmp].dup    

    tmp = rand(@npc["specials"]["Wpn-level"]) + 1
    tmp.to_i
    @npc["items"]["Melee1"] = $Melee[tmp].dup
    @npc["items"]["Melee1"][3] += @DB
    @npc["items"]["Melee1"][5] += @npc["c_skill"]["Melee1s"]
    @npc["items"]["Melee1"][6] += @npc["c_skill"]["Melee1s"]
    @npc["items"]["Melee1"][6] += (@npc["c_skill"]["Dodge"] / 5).to_i
    
    tmp2 = rand(@npc["specials"]["Wpn-level"]) + 1
    tmp2.to_i
    if tmp2 != tmp
      @npc["items"]["Melee2"] = $Melee[tmp2].dup
      @npc["items"]["Melee2"][3] += @DB
      @npc["items"]["Melee2"][5] += @npc["c_skill"]["Melee2s"]
      @npc["items"]["Melee2"][6] += @npc["c_skill"]["Melee2s"]
      @npc["items"]["Melee2"][6] += (@npc["c_skill"]["Dodge"] / 5).to_i
    else
      @npc["items"]["Melee2"] = ""
      @npc["c_skill"]["Melee2s"] = 0
    end

    tmp3 = rand(@npc["specials"]["Wpn-level"]) + 1
    tmp3.to_i
    if tmp3 != tmp && tmp3 != tmp2
      @npc["items"]["Melee3"] = $Melee[tmp3].dup
      @npc["items"]["Melee3"][3] += @DB
      @npc["items"]["Melee3"][5] += @npc["c_skill"]["Melee3s"]
      @npc["items"]["Melee3"][6] += @npc["c_skill"]["Melee3s"]
      @npc["items"]["Melee3"][6] += (@npc["c_skill"]["Dodge"] / 5).to_i
    else
      @npc["items"]["Melee3"] = ""
      @npc["c_skill"]["Melee3s"] = 0
    end

    tmp = rand(@npc["specials"]["Msl-level"]) + 1
    tmp.to_i
    @npc["items"]["Missile1"] = $Missile[tmp].dup
    if @npc["items"]["Missile1"][1] != "Crossbow" && @npc["items"]["Missile1"][1] != "Bow"  
      @npc["items"]["Missile1"][3] += (@npc["attr"]["STRNG"] / 5).to_i
    end
    @npc["items"]["Missile1"][4] += @npc["c_skill"]["Missile1s"]

    tmp2 = rand(@npc["specials"]["Msl-level"]) + 1
    tmp2.to_i
    if tmp2 != tmp
      @npc["items"]["Missile2"] = $Missile[tmp2].dup
      if @npc["items"]["Missile2"][1] != "Crossbow" && @npc["items"]["Missile2"][1] != "Bow"  
        @npc["items"]["Missile2"][3] += (@npc["attr"]["STRNG"] / 5).to_i
      end
      @npc["items"]["Missile2"][4] += @npc["c_skill"]["Missile2s"]
    else
      @npc["items"]["Missile2"] = ""
      @npc["c_skill"]["Missile2s"] = 0
    end
    if @npc["items"]["Missile2"][1] == @npc["items"]["Missile1"][1]
      @npc["items"]["Missile2"] = ""
      @npc["c_skill"]["Missile2s"] = 0
    end
    

# Calculate encumberance (in kilograms) and susequently the STATUS

    @ENC =  @npc["items"]["Armour"][4] 
    @ENC += @npc["items"]["Melee1"][8] 
    @ENC += @npc["items"]["Melee2"][8] if @npc["items"]["Melee2"][8].to_i != 0
    @ENC += @npc["items"]["Missile1"][8]
    @ENC += 3
		@ENC = @ENC.to_i
    
    case @ENC
      when 0...(2 * @npc["attr"]["STRNG"])
        @STATUS = 0
      when (2 * @npc["attr"]["STRNG"])...(5 * @npc["attr"]["STRNG"])
        @STATUS = -1
      when (5 * @npc["attr"]["STRNG"])...(10 * @npc["attr"]["STRNG"])
        @STATUS = -3
      when (10 * @npc["attr"]["STRNG"])...(20 * @npc["attr"]["STRNG"])
        @STATUS = -5
    end  


# Fill the array "spells" with "0"-values

    @npc["magick"]["spells"] = [
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                               ]
        
# Get Magick lore, Spell lore

    if @npc["magick"]["maglore"] < 1
      @npc["magick"]["maglore"] = 0
      @npc["magick"]["splore"] = 0
    else
      tmp = @npc["magick"]["maglore"]
      tmp = (tmp * (@level + 1)) / 3 - 2 + aD6
      tmp = (tmp + @npc["attr"]["LEARN"]) / 2 if tmp > @npc["attr"]["LEARN"]
      tmp = 0 if tmp < 0
      @npc["magick"]["maglore"] = tmp.to_i

      tmp2 = @npc["magick"]["splore"]
      tmp2 = (tmp2 * (@level + 1)) / 3 - 2 + aD6
      tmp2 = (tmp2 + @npc["attr"]["LEARN"]) / 2 if tmp2 > @npc["attr"]["LEARN"]
      tmp2 = tmp if tmp2 > tmp
      tmp2 = 0 if tmp2 < 0
      @npc["magick"]["splore"] = tmp2.to_i

      if @npc["magick"]["splore"] < 2
        @npc["magick"]["magtype1"] = "(none)" 
      else
        if @npc["magick"]["magtype1"] == "any" or @npc["magick"]["magtype1"] == ""
           @npc["magick"]["magtype1"] = randomizer(
            "air"       => 2,
            "black"     => 1,
            "earth"     => 3,
            "fire"      => 2,
            "life"      => 3,
            "magic"     => 1,
            "perception"=> 3,
            "protection"=> 3,
            "summoning" => 2,
            "water"     => 3)
        end

# Then get the spells
        
        spamount = self.splore + aD6 - 3
        spamount = 1 if spamount < 1
        spamount = 9 if spamount > 9

        if $Magick.has_key?(self.magtype1)
          spells = $Magick[self.magtype1].dup 
          spamount = spells.length if spamount > spells.length
          spamount.times do |i|
            break if spells.length == 0
            tmp = rand(spells.length).to_i
            spell = spells[tmp]
            spells.delete_at(tmp)
            if spell[5].to_i < self.splore + 7
              @npc["magick"]["spells"][i] = spell
              @npc["magick"]["spells"][i][0] = (rand(self.splore)/2).to_i + 1
	      if @npc["magick"]["spells"][i][0] + @npc["magick"]["spells"][i][5] > self.splore + 6
		@npc["magick"]["spells"][i][0] =  self.splore + 6 - @npc["magick"]["spells"][i][5]
	      end
              @spamount += 1
            else redo
            end
          end
        end
      end
    end
    
  end


# Define non-ordinary readable attributes

  def attr(key)
    @npc["attr"][key]
  end

  def c_skill(key)
    @npc["c_skill"][key]
  end

  def a_skill(key)
    @npc["a_skill"][key]
  end

  def l_skill(key)
    @npc["l_skill"][key]
  end

  def specials(key)
    @npc["specials"][key]
  end

  def items(key)
    @npc["items"][key]
  end

  def magick(key)
    @npc["magick"][key]
  end


# Define non-ordinary writable attributes

  def attr=(key, new)
    @npc["attr"][key] = new
  end

  def c_skill=(key, new)
    @npc["c_skill"][key] = new
  end

  def a_skill=(key, new)
    @npc["a_skill"][key] = new
  end

  def l_skill=(key, new)
    @npc["l_skill"][key] = new
  end

  def specials=(key, new)
    @npc["specials"][key] = new
  end

  def items=(key, new)
    @npc["items"][key] = new
  end

  def magick(key, new)
    @npc["magick"][key] = new
  end


# Specific readers (the rest)

  def size 
    self.SIZE
  end
  
  def db 
    self.DB
  end
    
  def bp 
    self.BP
  end
    
  def md 
    self.MD
  end
    
  def enc 
    self.ENC
  end
    
  def status
    self.STATUS
  end
    
  def strng 
    self.attr("STRNG")
  end
  
  def endur 
    self.attr("ENDUR")
  end
  
  def coord
    self.attr("COORD")
  end

  def learn
    self.attr("LEARN")
  end

  def aware
    self.attr("AWARE")
  end

  def magap
    self.attr("MAGAP")
  end

  def cs
    self.specials("CS")
  end

  def balance
    self.c_skill("Balance")
  end

  def climb
    self.c_skill("Climb")
  end

  def dodge
    self.c_skill("Dodge")
  end

  def hide
    self.c_skill("Hide")
  end

  def modhide
    @modhide
  end
  
  def mvqt
    self.c_skill("Mvqt")
  end

  def modmvqt
    @modmvqt
  end
  
  def ride
    self.c_skill("Ride")
  end

  def sleight
    self.c_skill("Sleight")
  end

  def swim
    self.c_skill("Swim")
  end

  def tumble
    self.c_skill("Tumble")
  end

  def physical1
    self.specials("Physical1")
  end

  def physical1s
    self.c_skill("Physical1s")
  end

  def physical2
    self.specials("Physical2")
  end

  def physical2s
    self.c_skill("Physical2s")
  end

  def physical3
    self.specials("Physical3")
  end

  def physical3s
    self.c_skill("Physical3s")
  end

  def dtraps
    self.a_skill("DTraps")
  end

  def tracking
    self.a_skill("Tracking")
  end

  def percept1
    self.specials("Percept1")
  end

  def percept1s
    self.a_skill("Percept1s")
  end

  def medicall
    self.l_skill("MedicalL")
  end

  def readwrite
    self.l_skill("ReadWrite")
  end

  def spoken
    self.l_skill("Spoken")
  end

  def lore1
    self.specials("Lore1")
  end

  def lore1s
    self.l_skill("Lore1s")
  end

  def lore2
    self.specials("Lore2")
  end

  def lore2s
    self.l_skill("Lore2s")
  end

  def lore3
    self.specials("Lore3")
  end

  def lore3s
    self.l_skill("Lore3s")
  end

  def armour
    self.items("Armour")[0]
  end

  def ap
    @npc["items"]["Armour"][1]
  end

  def socstatus
    self.specials("Status")
  end

  def money
    self.items("Money")
  end

  def cult
    self.specials("Cult")
  end

  def cultstat1
    self.specials("Cultstat1")
  end

  def cultstat2
    self.specials("Cultstat2")
  end

  def melee1
    @npc["items"]["Melee1"][0]
  end

  def melee1s
    self.c_skill("Melee1s")
  end

  def melee1i
    @npc["items"]["Melee1"][4]
  end

  def melee1o
    @npc["items"]["Melee1"][5]
  end

  def melee1d
    @npc["items"]["Melee1"][6]
  end

  def melee1dam
    @npc["items"]["Melee1"][3]
  end

  def melee1hp
    @npc["items"]["Melee1"][7]
  end

  def melee2
    @npc["items"]["Melee2"][0]
  end

  def melee2s
    self.c_skill("Melee2s")
  end

  def melee2i
    @npc["items"]["Melee2"][4]
  end

  def melee2o
    @npc["items"]["Melee2"][5]
  end

  def melee2d
    @npc["items"]["Melee2"][6]
  end

  def melee2dam
    @npc["items"]["Melee2"][3]
  end

  def melee2hp
    @npc["items"]["Melee2"][7]
  end

  def melee3
    @npc["items"]["Melee3"][0]
  end

  def melee3s
    self.c_skill("Melee3s")
  end

  def melee3i
    @npc["items"]["Melee3"][4]
  end

  def melee3o
    @npc["items"]["Melee3"][5]
  end

  def melee3d
    @npc["items"]["Melee3"][6]
  end

  def melee3dam
    @npc["items"]["Melee3"][3]
  end

  def melee3hp
    @npc["items"]["Melee3"][7]
  end

  def missile1
    @npc["items"]["Missile1"][0]
  end

  def missile1s
    self.c_skill("Missile1s")
  end

  def missile1sr
    @npc["items"]["Missile1"][7]
  end

  def missile1o
    @npc["items"]["Missile1"][4]
  end

  def missile1dam
    @npc["items"]["Missile1"][3]
  end

  def missile1rng
    @npc["items"]["Missile1"][5]
  end

  def missile1rmax
    @npc["items"]["Missile1"][6]
  end

  def missile2
    @npc["items"]["Missile2"][0]
  end

  def missile2s
    self.c_skill("Missile2s")
  end

  def missile2sr
    @npc["items"]["Missile2"][7]
  end

  def missile2o
    @npc["items"]["Missile2"][4]
  end

  def missile2dam
    @npc["items"]["Missile2"][3]
  end

  def missile2rng
    @npc["items"]["Missile2"][5]
  end

  def missile2rmax
    @npc["items"]["Missile2"][6]
  end

  def maglore
    @npc["magick"]["maglore"]
  end

  def splore
    @npc["magick"]["splore"]
  end

  def magtype1
    @npc["magick"]["magtype1"]
  end

  def spell0(key)
    @npc["magick"]["spells"][0][key]
  end

  def spell1(key)
    @npc["magick"]["spells"][1][key]
  end

  def spell2(key)
    @npc["magick"]["spells"][2][key]
  end

  def spell3(key)
    @npc["magick"]["spells"][3][key]
  end

  def spell4(key)
    @npc["magick"]["spells"][4][key]
  end

  def spell5(key)
    @npc["magick"]["spells"][5][key]
  end

  def spell6(key)
    @npc["magick"]["spells"][6][key]
  end

  def spell7(key)
    @npc["magick"]["spells"][7][key]
  end

  def spell8(key)
    @npc["magick"]["spells"][8][key]
  end


# Specific writers (the rest)

  def enc=(new)
    self.ENC = new
  end
    
  def strng=(new)
    self.attr("STRNG", new)
  end
  
  def endur=(new)
    self.attr("ENDUR", new)
  end
  
  def coord=(new)
    self.attr("COORD", new)
  end

  def learn=(new)
    self.attr("LEARN", new)
  end

  def aware=(new)
    self.attr("AWARE", new)
  end

  def magap=(new)
    self.attr("MAGAP", new)
  end

  def cs=(new)
    self.specials("CS", new)
  end

  def balance=(new)
    self.c_skill("Balance", new)
  end

  def climb=(new)
    self.c_skill("Climb", new)
  end

  def dodge=(new)
    self.c_skill("Dodge", new)
  end

  def hide=(new)
    self.c_skill("Hide", new)
  end

  def modhide=(new)
    @modhide = new
  end
  
  def mvqt=(new)
    self.c_skill("Mvqt", new)
  end

  def modmvqt=(new)
    @modmvqt = new
  end
  
  def ride=(new)
    self.c_skill("Ride", new)
  end

  def sleight=(new)
    self.c_skill("Sleight", new)
  end

  def swim=(new)
    self.c_skill("Swim", new)
  end

  def tumble=(new)
    self.c_skill("Tumble", new)
  end

  def physical1=(new)
    self.specials("Physical1", new)
  end

  def physical1s=(new)
    self.c_skill("Physical1s", new)
  end

  def physical2=(new)
    self.specials("Physical2", new)
  end

  def physical2s=(new)
    self.c_skill("Physical2s", new)
  end

  def physical3=(new)
    self.specials("Physical3", new)
  end

  def physical3s=(new)
    self.c_skill("Physical3s", new)
  end

  def dtraps=(new)
    self.a_skill("DTraps", new)
  end

  def tracking=(new)
    self.a_skill("Tracking", new)
  end

  def percept1=(new)
    self.specials("Percept1", new)
  end

  def percept1s=(new)
    self.a_skill("Percept1s", new)
  end

  def medicall=(new)
    self.l_skill("MedicalL", new)
  end

  def readwrite=(new)
    self.l_skill("ReadWrite", new)
  end

  def spoken=(new)
    self.l_skill("Spoken", new)
  end

  def lore1=(new)
    self.specials("Lore1", new)
  end

  def lore1s=(new)
    self.l_skill("Lore1s", new)
  end

  def lore2=(new)
    self.specials("Lore2", new)
  end

  def lore2s=(new)
    self.l_skill("Lore2s", new)
  end

  def lore3=(new)
    self.specials("Lore3", new)
  end

  def lore3s=(new)
    self.l_skill("Lore3s", new)
  end

  def armour=(new)
    @npc["items"]["Armour"][0] = new
  end

  def ap=(new)
    @npc["items"]["Armour"][1] = new
  end

  def socstatus=(new)
    self.specials("Status", new)
  end

  def money=(new)
    self.items("Money", new)
  end

  def cult=(new)
    self.specials("Cult", new)
  end

  def cultstat1=(new)
    self.specials("Cultstat1", new)
  end

  def cultstat2=(new)
    self.specials("Cultstat2", new)
  end

  def melee1=(new)
    @npc["items"]["Melee1"][0] = new
  end

  def melee1s=(new)
    self.c_skill("Melee1s", new)
  end

  def melee1i=(new)
    @npc["items"]["Melee1"][4] = new
  end

  def melee1o=(new)
    @npc["items"]["Melee1"][5] = new
  end

  def melee1d=(new)
    @npc["items"]["Melee1"][6] = new
  end

  def melee1dam=(new)
    @npc["items"]["Melee1"][3] = new
  end

  def melee1hp=(new)
    @npc["items"]["Melee1"][7] = new
  end

  def melee2=(new)
    @npc["items"]["Melee2"][0] = new
  end

  def melee2s=(new)
    self.c_skill("Melee2s", new)
  end

  def melee2i=(new)
    @npc["items"]["Melee2"][4] = new
  end

  def melee2o=(new)
    @npc["items"]["Melee2"][5] = new
  end

  def melee2d=(new)
    @npc["items"]["Melee2"][6] = new
  end

  def melee2dam=(new)
    @npc["items"]["Melee2"][3] = new
  end

  def melee2hp=(new)
    @npc["items"]["Melee2"][7] = new
  end

  def melee3=(new)
    @npc["items"]["Melee3"][0] = new
  end

  def melee3s=(new)
    self.c_skill("Melee3s", new)
  end

  def melee3i=(new)
    @npc["items"]["Melee3"][4] = new
  end

  def melee3o=(new)
    @npc["items"]["Melee3"][5] = new
  end

  def melee3d=(new)
    @npc["items"]["Melee3"][6] = new
  end

  def melee3dam=(new)
    @npc["items"]["Melee3"][3] = new
  end

  def melee3hp=(new)
    @npc["items"]["Melee3"][7] = new
  end

  def missile1=(new)
    @npc["items"]["Missile1"][0] = new
  end

  def missile1s=(new)
    self.c_skill("Missile1s", new)
  end

  def missile1sr=(new)
    @npc["items"]["Missile1"][7] = new
  end

  def missile1o=(new)
    @npc["items"]["Missile1"][4] = new
  end

  def missile1dam=(new)
    @npc["items"]["Missile1"][3] = new
  end

  def missile1rng=(new)
    @npc["items"]["Missile1"][5] = new
  end

  def missile1rmax=(new)
    @npc["items"]["Missile1"][6] = new
  end

  def missile2=(new)
    @npc["items"]["Missile2"][0] = new
  end

  def missile2s=(new)
    self.c_skill("Missile2s", new)
  end

  def missile2sr=(new)
    @npc["items"]["Missile2"][7] = new
  end

  def missile2o=(new)
    @npc["items"]["Missile2"][4] = new
  end

  def missile2dam=(new)
    @npc["items"]["Missile2"][3] = new
  end

  def missile2rng=(new)
    @npc["items"]["Missile2"][5] = new
  end

  def missile2rmax=(new)
    @npc["items"]["Missile2"][6] = new
  end

  def maglore=(new)
    @npc["magick"]["maglore"] = new
  end

  def sp_lore=(new)
    @npc["magick"]["splore"] = new
  end

  def magtype1=(new)
    @npc["magick"]["magtype1"] = new
  end

  def spell0=(key, new)
    @npc["magick"]["spells"][0][key] = new
  end

  def spell1=(key, new)
    @npc["magick"]["spells"][1][key] = new
  end

  def spell2=(key, new)
    @npc["magick"]["spells"][2][key] = new
  end

  def spell3=(key, new)
    @npc["magick"]["spells"][3][key] = new
  end

  def spell4=(key, new)
    @npc["magick"]["spells"][4][key] = new
  end

  def spell5=(key, new)
    @npc["magick"]["spells"][5][key] = new
  end

  def spell6=(key, new)
    @npc["magick"]["spells"][6][key] = new
  end

  def spell7=(key, new)
    @npc["magick"]["spells"][7][key] = new
  end

  def spell8=(key, new)
    @npc["magick"]["spells"][8][key] = new
  end


end
