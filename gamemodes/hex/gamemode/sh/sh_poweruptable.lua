HEX.PowerupTable = {}
HEX.PowerupTable[1] = { 
	name = "Vampirism",
	id = "vampirism", 
	desc = "Steal health from targets with a chance to cast Bleeding.",
	resist = 0,
	image = "hexgm/ui/elements/blood.png",
	color = Color(255,125,125),
	init = function(ply,time)
		local id = ply:UniqueID()
		local timerid = "hex_powerup_vamp"..id

		HEX.SendNotification(ply,Color(255,125,125),255,"Vampirism!",false)	

		ply:SetNWInt("PowerupVampirism",1)

		if timer.Exists(timerid) then timer.Remove(timerid) end
		timer.Create(timerid,time,1,function()
			ply:SetNWInt("PowerupVampirism",0)
		end)
	end,
	damage = function(target,attacker,dmg)
		if target:Alive() then
			attacker:AddHP(dmg)

			local chance = math.random(1,100)
			if chance > 75 then
				target:BuffBleed(attacker,5,5)
			end
		end
	end,
	resist = function(dmgtype)
		return false
	end
}
HEX.PowerupTable[2] = { 
	name = "Inferno",
	id = "inferno", 
	desc = "Resist Fire damage with a chance to cast Burning.",
	resist = 3,
	image = "hexgm/ui/elements/fire.png",
	color = Color(255,125,125),
	init = function(ply,time)
		local id = ply:UniqueID()
		local timerid = "hex_powerup_fire"..id

		HEX.SendNotification(ply,Color(255,125,125),255,"Inferno!",false)	

		ply:SetNWInt("PowerupInferno",1)

		if timer.Exists(timerid) then timer.Remove(timerid) end
		timer.Create(timerid,time,1,function()
			ply:SetNWInt("PowerupInferno",0)
		end)
	end,
	damage = function(target,attacker,dmg)
		if target:Alive() then
			local chance = math.random(1,100)
			if chance > 25 then
				target:BuffFire(attacker,3,4)
			end
		end
	end,
	resist = function(dmgtype)
		if dmgtype == "fire" then
			return true
		else
			return false
		end
	end
}
HEX.PowerupTable[3] = { 
	name = "Frostbite",
	id = "frostbite", 
	desc = "Resist Frost with a chance to cast Freezing.",
	resist = 3,
	image = "hexgm/ui/elements/frost.png",
	color = Color(125,155,255),
	init = function(ply,time)
		local id = ply:UniqueID()
		local timerid = "hex_powerup_ice"..id

		HEX.SendNotification(ply,Color(125,155,255),255,"Frostbite!",false)	

		ply:SetNWInt("PowerupFrostbite",1)

		if timer.Exists(timerid) then timer.Remove(timerid) end
		timer.Create(timerid,time,1,function()
			ply:SetNWInt("PowerupFrostbite",0)
		end)
	end,
	damage = function(target,attacker,dmg)
		if target:Alive() then
			local chance = math.random(1,100)
			if chance > 25 then
				target:BuffIce(attacker,7,3)
			end
		end
	end,
	resist = function(dmgtype)
		if dmgtype == "frost" then
			return true
		else
			return false
		end
	end
}
HEX.PowerupTable[4] = { 
	name = "Life",
	id = "life", 
	desc = "Health and Mana regenerate faster, healing effects from and to friends is stronger.",
	resist = 0,
	image = "hexgm/ui/elements/life.png",
	color = Color(215,255,215),
	init = function(ply,time)
		local id = ply:UniqueID()
		local timerid = "hex_powerup_life"..id

		HEX.SendNotification(ply,Color(215,255,215),255,"Life!",false)	

		ply:SetNWInt("PowerupLife",1)

		if timer.Exists(timerid) then timer.Remove(timerid) end
		timer.Create(timerid,time,1,function()
			ply:SetNWInt("PowerupLife",0)
		end)
	end,
	damage = function(target,attacker,dmg)
		-- do nothing
	end,
	resist = function(dmgtype)
		return false
	end
}
HEX.PowerupTable[5] = { 
	name = "Nature",
	id = "nature", 
	desc = "Resist Nature, Earth and Water damage, gain Thorns, with a chance to cast Vine Trap.",
	resist = 2,
	image = "hexgm/ui/elements/nature.png",
	color = Color(125,255,155),
	init = function(ply,time)
		local id = ply:UniqueID()
		local timerid = "hex_powerup_nature"..id

		HEX.SendNotification(ply,Color(125,255,155),255,"Nature!",false)	

		-- todo: setup in damage function to trigger thorns damage if this powerup is active.

		ply:SetNWInt("PowerupNature",1)

		if timer.Exists(timerid) then timer.Remove(timerid) end
		timer.Create(timerid,time,1,function()
			ply:SetNWInt("PowerupNature",0)
		end)
	end,
	damage = function(target,attacker,dmg)
		if target:Alive() then
			local chance = math.random(1,100)
			if chance > 50 then
				-- Cast Vine Trap: stops an enemy in its tracks until the vines let loose or die.
			end
		end
	end,
	resist = function(dmgtype)
		if dmgtype == "nature" or dmgtype == "earth" or dmgtype == "water" then
			return true
		else
			return false
		end
	end
}
HEX.PowerupTable[6] = { 
	name = "Envenomed",
	id = "envenomed", 
	desc = "Resist Poison damage with a chance to cast Poison.",
	resist = 3,
	image = "hexgm/ui/elements/poison.png",
	color = Color(215,255,155),
	init = function(ply,time)
		local id = ply:UniqueID()
		local timerid = "hex_powerup_poison"..id

		HEX.SendNotification(ply,Color(215,255,155),255,"Envenomed!",false)	

		ply:SetNWInt("PowerupPoison",1)

		if timer.Exists(timerid) then timer.Remove(timerid) end
		timer.Create(timerid,time,1,function()
			ply:SetNWInt("PowerupPoison",0)
		end)
	end,
	damage = function(target,attacker,dmg)
		if target:Alive() then
			local chance = math.random(1,100)
			if chance > 25 then
				target:BuffPoison(attacker,8,4)
			end
		end
	end,
	resist = function(dmgtype)
		if dmgtype == "poison" then
			return true
		else
			return false
		end
	end
}
HEX.PowerupTable[7] = { 
	name = "Shield",
	id = "shield", 
	desc = "Become invulnerable for a period of time.",
	image = "hexgm/ui/elements/shield.png",
	color = Color(255,255,165),
	init = function(ply,time)
		local id = ply:UniqueID()
		local timerid = "hex_powerup_shield"..id

		HEX.SendNotification(ply,Color(255,255,165),255,"Shield!",false)	

		ply:SetNWInt("PowerupShield",1)

		if timer.Exists(timerid) then timer.Remove(timerid) end
		timer.Create(timerid,time,1,function()
			ply:SetNWInt("PowerupShield",0)
		end)
	end,
	damage = function(target,attacker,dmg)
		-- Do nothing
	end,
	resist = function(dmgtype)
		return true
	end
}
HEX.PowerupTable[8] = { 
	name = "Storm",
	id = "storm", 
	desc = "Resist Storm damage with a chance to deal stuns.",
	image = "hexgm/ui/elements/storm.png",
	color = Color(155,215,255),
	init = function(ply,time)
		local id = ply:UniqueID()
		local timerid = "hex_powerup_storm"..id

		HEX.SendNotification(ply,Color(155,215,255),255,"Storm!",false)	

		ply:SetNWInt("PowerupStorm",1)

		if timer.Exists(timerid) then timer.Remove(timerid) end
		timer.Create(timerid,time,1,function()
			ply:SetNWInt("PowerupStorm",0)
		end)
	end,
	damage = function(target,attacker,dmg)
		if target:Alive() then
			local chance = math.random(1,100)
			if chance > 25 then
				target:BuffStun(attacker,2)
			end
		end
	end,
	resist = function(dmgtype)
		if dmgtype == "storm" then
			return true
		else
			return false
		end
	end
}