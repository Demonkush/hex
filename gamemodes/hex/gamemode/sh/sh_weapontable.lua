HEX.WeaponTable = {}
HEX.WeaponTable[1] = { 
	name = "Wonderbranch", 
	desc = "A magic wand capable of inflicting decent arcane damage.", 
	rarity = "common",
	price = 75,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_wonderbranch",
	icon = "hexgm/ui/hex_weapon_wonderbranch.png",
	stats = { 
				low = {name="Magic Spark",element="magic"},
				norm = {name="Arcane Bolt",element="magic"},
				high = {name="Magic Missiles",element="magic"},
				super = {name="X- Mana Bomb",element="magic"},
				buffs = {"magic"}
			}
}
HEX.WeaponTable[2] = { 
	name = "Blaster", 
	desc = "Gun that shoots fire beams.", 
	rarity = "rare",
	price = 425,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_blaster",
	icon = "hexgm/ui/hex_weapon_blaster.png",
	stats = { 
				low = {name="Red Beam",element="magic"},
				norm = {name="Fire Beam",element="burning"},
				high = {name="Incinerate",element="burning"},
				super = {name="X- Fury Blaster",element="burning"},
				buffs = {"burning"}
			}
}
HEX.WeaponTable[3] = { 
	name = "Blade of Corruption", 
	desc = "Sword with poison slashes.", 
	rarity = "magic",
	price = 375,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_bladeofcorruption",
	icon = "hexgm/ui/hex_weapon_bladeofcorruption.png",
	stats = { 
				low = {name="Slash",element="damage"},
				norm = {name="Viper Sting",element="poison"},
				high = {name="Acid Slash",element="poison"},
				super = {name="X- Slash of Torment",element="poison"},
				buffs = {"poison"}
			}
}
HEX.WeaponTable[4] = { 
	name = "Ignus Twig", 
	desc = "Fire wand.", 
	rarity = "common",
	price = 175,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_ignustwig",
	icon = "hexgm/ui/hex_weapon_ignustwig.png",
	stats = { 
				low = {name="Red Bolt",element="magic"},
				norm = {name="Fire Bolt",element="burning"},
				high = {name="Magma Bomb",element="burning"},
				super = {name="X- Inferno Missile",element="burning"},
				buffs = {"burning"}
			}
}
HEX.WeaponTable[5] = { 
	name = "Trapper Bow", 
	desc = "Crossbow with poison damage.", 
	rarity = "common",
	price = 200,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_trapperbow",
	icon = "hexgm/ui/hex_weapon_trapperbow.png",
	stats = { 
				low = {name="Venom Arrow",element="poison"},
				norm = {name="Poison Bolt",element="poison"},
				high = {name="Venom Boltbomb",element="poison"},
				super = {name="X- Plague Bomb",element="poison"},
				buffs = {"poison","slow"}
			}
}
HEX.WeaponTable[6] = { 
	name = "Umbra Ray", 
	desc = "Magic gun.", 
	rarity = "rare",
	price = 325,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_umbraray",
	icon = "hexgm/ui/hex_weapon_umbraray.png",
	stats = { 
				low = {name="Beam Bolt",element="magic"},
				norm = {name="Mana Beam",element="magic"},
				high = {name="Beam Blast",element="magic"},
				super = {name="X- Hyper Ray",element="magic"},
				buffs = {"magic"}
			}
}
HEX.WeaponTable[7] = { 
	name = "Magic Wand", 
	desc = "Magic wand.", 
	rarity = "magic",
	price = 120,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_magicwand",
	icon = "hexgm/ui/hex_weapon_magicwand.png",
	stats = { 
				low = {name="Magic Bolt",element="magic"},
				norm = {name="Magic Missile",element="magic"},
				high = {name="Magic Barrage",element="magic"},
				super = {name="X- Super Magic Bomb",element="magic"},
				buffs = {"magic"}
			}
}
--[[
HEX.WeaponTable[5] = { 
	name = "Rod of Lightning", 
	desc = "Staff with the power of Storm.", 
	rarity = "magic",
	price = 275,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_rodoflightning",
	icon = "hexgm/ui/hex_weapon_rodoflightning.png",
	stats = { 
				low = {name="Spark",element="storm"},
				norm = {name="Storm Bolt",element="storm"},
				high = {name="Lightning Bolt",element="storm"},
				super = {name="X- Wrath of the Skies",element="storm"},
				buffs = {"storm","water"}
			}
}
HEX.WeaponTable[6] = { 
	name = "Staff of Deluge", 
	desc = "Staff with the power of Frost and Mana Drain.", 
	rarity = "magic",
	price = 250,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_staffofdeluge",
	icon = "hexgm/ui/hex_weapon_staffofdeluge.png",
	stats = { 
				low = {name="Ice Bolt",element="chilled"},
				norm = {name="Frost Shard",element="chilled"},
				high = {name="Shatter Missile",element="chilled"},
				super = {name="X- Deep Siphon",element="chilled"},
				buffs = {"chilled","frozen","manadrain"}
			}
}
HEX.WeaponTable[4] = { 
	name = "Golem Heart", 
	desc = "Orb weapon with the power of Earth.", 
	rarity = "rare",
	price = 400,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_golemheart",
	icon = "hexgm/ui/hex_weapon_golemheart.png",
	stats = { 
				low = {name="Rock Toss",element="damage"},
				norm = {name="Boulder",element="damage"},
				high = {name="Molten Boulder",element="burning"},
				super = {name="X- Meteor Aegis",element="burning"},
				buffs = {"burning","stun"}
			}
}
HEX.WeaponTable[6] = { 
	name = "Orb of Destruction", 
	desc = "Orb weapon with the power of Fire and Lightning.", 
	rarity = "rare",
	price = 500,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_orbofdestruction",
	icon = "hexgm/ui/hex_weapon_orbofdestruction.png",
	stats = { 
				low = {name="Chaos Spark",element="storm"},
				norm = {name="Chaos Bolt",element="storm"},
				high = {name="Destruction",element="burning"},
				super = {name="X- Doom",element="burning"},
				buffs = {"burning","storm"}
			}
}
]]


--[[
HEX.WeaponTable[11] = { 
	name = "Frostmourne", 
	desc = "Frost Sword.", 
	rarity = "epic",
	price = 1000,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_frostmourne",
	icon = "hexgm/ui/hex_weapon_frostmourne.png",
	stats = { 
				low = {name="Magic Slash",element="chilled"},
				norm = {name="Frost Grip",element="chilled"},
				high = {name="Frozen Fury",element="chilled"},
				super = {name="X- Frozen Apocalypse",element="chilled"},
				buffs = {"chilled","frozen","manadrain"}
			}
}
]]


-- SETS
-- Holy Fire Set ( Not the name but setting it for now )
--[[
HEX.WeaponTable[12] = { 
	name = "Greatsmith's Hammer", 
	desc = "Hammer with fire, holy, storm and earth power.", 
	rarity = "set",
	set = "holyfire",
	price = 500,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_set_greatsmithshammer",
	icon = "hexgm/ui/hex_weapon_greatsmithhammer.png",
	stats = { 
				low = {name="Crush",element="earth"},
				norm = {name="Storm Smash",element="storm"},
				high = {name="Hyper Smash",element="burning"},
				super = {name="X- Star Hammers",element="light"},
				buffs = {"burning","light","storm"}
			}
}
HEX.WeaponTable[13] = { 
	name = "Highpriest Staff", 
	desc = "Staff with holy power.", 
	rarity = "set",
	set = "holyfire",
	price = 500,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_set_highprieststaff",
	icon = "hexgm/ui/hex_weapon_highprieststaff.png",
	stats = { 
				low = {name="Heal",element="light"},
				norm = {name="Holy Light",element="light"},
				high = {name="Holy Wrath",element="burning"},
				super = {name="X- Wrath of God",element="storm"},
				buffs = {"light","burning","storm"}
			}
}
HEX.WeaponTable[14] = { 
	name = "Valkyrie Striker", 
	desc = "Crossbow with fire and holy power.", 
	rarity = "set",
	set = "holyfire",
	price = 500,
	resources = {wood=10,metal=0,ruby=0,sapphire=0,topaz=0,emerald=0,amethyst=1,opal=0},
	wep = "wep_hex_set_valkyriestriker",
	icon = "hexgm/ui/hex_weapon_valkyriestriker.png",
	stats = { 
				low = {name="Fire Arrow",element="burning"},
				norm = {name="Righteous Arrow",element="light"},
				high = {name="Phoenix Fire",element="burning"},
				super = {name="X- Sunstrike",element="light"},
				buffs = {"burning","light","storm"}
			}
}
]]