# The town table - all the various house types

$Town = Array.new

$Town[0]  = [ "Type",          "shop?", "%", "min", "Seniors", "Adults", "Young"]
$Town[1]  = [ "Unhoused residents", 0,   1,     1,         1,        3,       1]
$Town[2]  = [ "Stronghold",         0,   1,     1,         3,        6,       4]
$Town[3]  = [ "Soldier/Guards",     0,   3,     1,         0,        4,       0]
$Town[4]  = [ "Stable",             1,   2,     1,         2,        2,       2]
$Town[5]  = [ "Inn",                0,   6,     1,         2,        2,       2]
$Town[6]  = [ "Farm/Fishery",       1,   6,     3,         2,        2,       2]
$Town[7]  = [ "General store",      1,   2,     1,         2,        2,       2]
$Town[8]  = [ "Blacksmith",         1,   2,     1,         2,        2,       2]
$Town[9]  = [ "Butcher",            1,   2,     1,         2,        2,       2]
$Town[10] = [ "Temple",             0,   5,     1,         2,        2,       2]
$Town[11] = [ "Horse trader",       1,   3,     0,         2,        2,       2]
$Town[12] = [ "Mill",               0,   2,     0,         2,        2,       2]
$Town[13] = [ "Baker",              1,   2,     0,         2,        2,       2]
$Town[14] = [ "Merchant",           1,   3,     0,         2,        2,       2]
$Town[15] = [ "Barber",             1,   2,     0,         2,        2,       2]
$Town[16] = [ "Leatherworker",      1,   3,     0,         2,        2,       2]
$Town[17] = [ "Grocery store",      1,   4,     0,         2,        2,       2]
$Town[18] = [ "Dyer/Tanner",        1,   2,     0,         2,        2,       2]
$Town[19] = [ "Mason",              1,   2,     0,         2,        2,       2]
$Town[20] = [ "Tailor",             1,   2,     0,         2,        2,       2]
$Town[21] = [ "Weapon smith",       1,   2,     0,         2,        2,       2]
$Town[22] = [ "Armourer",           1,   2,     0,         2,        2,       2]
$Town[23] = [ "Carpenter",          1,   3,     0,         2,        2,       2]
$Town[24] = [ "Cartwright",         1,   3,     0,         2,        2,       2]
$Town[25] = [ "Potter",             1,   2,     0,         2,        2,       2]
$Town[26] = [ "Worker",             0,   6,     1,         2,        2,       2]
$Town[27] = [ "Boatwright",         1,   2,     0,         2,        2,       2]
$Town[28] = [ "Noble",              0,   4,     0,         2,        2,       2]
$Town[29] = [ "Laundry",            1,   2,     0,         2,        2,       2]
$Town[30] = [ "Storage",            1,   3,     0,         2,        2,       2]
$Town[31] = [ "Slum",               0,   7,     0,         2,        2,       2]
$Town[32] = [ "Carpet maker",       1,   2,     0,         2,        2,       2]
$Town[33] = [ "Rope-/Netmaker",     1,   2,     0,         2,        2,       2]
$Town[34] = [ "Doctor",             1,   2,     0,         2,        2,       2]
$Town[35] = [ "Brothel",            1,   2,     0,         2,        2,       2]
$Town[36] = [ "Sailmaker",          1,   2,     0,         2,        2,       2]
$Town[37] = [ "Bowyer/Fletcher",    1,   2,     0,         2,        2,       2]
$Town[38] = [ "Weaver/spinner",     1,   2,     0,         2,        2,       2]
$Town[39] = [ "Veterinarian",       1,   2,     0,         2,        2,       2]
$Town[40] = [ "Animal trainer",     1,   2,     0,         2,        2,       2]
$Town[41] = [ "Furrier",            1,   2,     0,         2,        2,       2]
$Town[42] = [ "Brewer",             1,   2,     0,         2,        2,       2]
$Town[43] = [ "Cobbler",            1,   2,     0,         2,        2,       2]
$Town[44] = [ "Builder",            0,   2,     0,         2,        2,       2]
$Town[45] = [ "Farm worker",        0,   3,     0,         2,        2,       2]
$Town[46] = [ "Woodcarver/Engraver",1,   2,     0,         2,        2,       2]
$Town[47] = [ "Pawnshop",           1,   2,     0,         2,        2,       2]
$Town[48] = [ "Shoe maker",         1,   2,     0,         2,        2,       2]
$Town[49] = [ "Outfitter",          1,   2,     0,         2,        2,       2]
$Town[50] = [ "Public bath",        1,   2,     0,         2,        2,       2]
$Town[51] = [ "Alchemist",          1,   2,     0,         2,        2,       2]
$Town[52] = [ "Artist",             1,   3,     0,         2,        2,       2]
$Town[53] = [ "Diplomat",           0,   2,     0,         2,        2,       2]
$Town[54] = [ "Silver/goldsmith",   1,   2,     0,         2,        2,       2]
$Town[55] = [ "Jeweller",           1,   2,     0,         2,        2,       2]
$Town[56] = [ "Winery",             1,   2,     0,         2,        2,       2]
$Town[57] = [ "Destiller",          1,   1,     0,         2,        2,       2]
$Town[58] = [ "Teacher",            1,   3,     0,         2,        2,       2]
$Town[59] = [ "Scribe",             1,   2,     0,         2,        2,       2]
$Town[60] = [ "Tinker",             1,   2,     0,         2,        2,       2]
$Town[61] = [ "Illuminator",        1,   2,     0,         2,        2,       2]
$Town[62] = [ "Glassblower",        1,   2,     0,         2,        2,       2]
$Town[63] = [ "Artist/Cartographer",1,   2,     0,         2,        2,       2]
$Town[64] = [ "Perfumer",           1,   1,     0,         2,        2,       2]
$Town[65] = [ "Farm",               1, 100,     3,         2,        2,       2]

