HEX.ItemTable = {}
HEX.ItemTable[1] = { 
	name = "Mage Armor",
	id = "magearmor", 
	desc = "Woven with magic thread, this light armor fluxuates incoming damage.", 
	itemrarity = "magic",
	itemtype = "passive", 
	itemability = "Magic Resistance",
	itemabilitydesc = "Magic Resist +3",
	cooldown = 0,
	price = 175,
	icon = "hexgm/ui/hex_item_magearmor.png",
	func = function(ply)
		-- do nothing
	end
}
HEX.ItemTable[2] = { 
	name = "Thorniken", 
	id = "thorniken",
	desc = "A tribal charm that grants the chance to reflect damage to attackers.",  
	itemrarity = "magic",
	itemtype = "passive", 
	itemability = "Thorns",
	itemabilitydesc = "Reflect 1/2 damage.",
	cooldown = 0,
	price = 215,
	icon = "hexgm/ui/hex_item_thorniken.png",
	func = function(ply)
		-- do nothing
	end 
}
HEX.ItemTable[3] = { 
	name = "Ruby Flask", 
	id = "rubyflask",
	desc = "A weak herbal healing potion, but should still heal most wounds quickly.",  
	itemrarity = "common",
	itemtype = "activated", 
	itemability = "Health Potion",
	itemabilitydesc = "Health +25",
	cooldown = 15,
	price = 100,
	icon = "hexgm/ui/hex_item_rubyflask.png",
	func = function(ply)
		ply:AddHP(25)

		ply:EmitSound("wc3sound/exp/Submerge1.wav",75,135)

		ply:AbolishBuffs("poison")
		ply:AbolishBuffs("bleed")
	end 
}
HEX.ItemTable[4] = { 
	name = "Hermes Stone", 
	id = "hermesstone",
	desc = "An ancient talisman that grants the wielder enhanced acrobatics.",  
	itemrarity = "magic",
	itemtype = "passive", 
	itemability = "Agility",
	itemabilitydesc = "Walk, Run and Jump speed up.",
	cooldown = 0,
	price = 300,
	icon = "hexgm/ui/hex_item_hermesstone.png",
	func = function(ply)
		-- do nothing
	end
}
HEX.ItemTable[5] = { 
	name = "Hellstone", 
	id = "hellstone",
	desc = "A demonic stone which grants powerful fire effects.",  
	itemrarity = "rare",
	itemtype = "passive", 
	itemability = "Fire Affinity",
	itemabilitydesc = "Fire Resist +5",
	cooldown = 0,
	price = 400,
	icon = "hexgm/ui/hex_item_hellstone.png",
	func = function(ply)
		-- do nothing
	end 
}
HEX.ItemTable[6] = { 
	name = "Star Sapphire", 
	id = "starsapphire",
	desc = "A celestial stone which grants powerful astral and frost effects.",  
	itemrarity = "rare",
	itemtype = "passive", 
	itemability = "Frost Affinity",
	itemabilitydesc = "Frost Resist +5",
	cooldown = 0,
	price = 450,
	icon = "hexgm/ui/hex_item_starsapphire.png",
	func = function(ply)
		-- do nothing
	end
}
HEX.ItemTable[7] = { 
	name = "Amulet of Power",
	id = "amuletofpower", 
	desc = "Summons a large magical circle that enhances friendly regen effects.",  
	itemrarity = "rare",
	itemtype = "activated", 
	itemability = "Support Circle",
	itemabilitydesc = "Summon a support circle.",
	cooldown = 60,
	price = 400,
	icon = "hexgm/ui/hex_item_amuletofpower.png",
	func = function(ply)
		if ply:IsOnGround() then
			ply:EmitSound("wc3sound/exp/ManaShieldCaster1.wav",75,85)

			if IsValid(ply.HEXCircle) then
				ply.HEXCircle:Remove()
			end

            ply.HEXCircle = ents.Create( "ent_hex_supportcircle" )
            ply.HEXCircle:SetPos(ply:GetPos())
            ply.HEXCircle:SetOwner( ply )
            ply.HEXCircle:SetAngles(Angle(0,0,1))
            ply.HEXCircle:Spawn()
        end
	end 
}
HEX.ItemTable[8] = { 
	name = "Dracula Fang", 
	id = "draculafang",
	desc = "Unholy fang that drains the life of foes on into you.",  
	itemrarity = "magic",
	itemtype = "passive", 
	itemability = "Vampirism",
	itemabilitydesc = "Chance to steal health on hit.",
	cooldown = 0,
	price = 200,
	icon = "hexgm/ui/hex_item_draculafang.png",
	func = function(ply)
		-- do nothing
	end 
}
HEX.ItemTable[9] = { 
	name = "Ironskin Potion", 
	id = "ironskinpotion",
	desc = "Hardens the skin like rough unbreakable stone.",  
	itemrarity = "common",
	itemtype = "activated", 
	itemability = "Resist Potion",
	itemabilitydesc = "Damage Resist +5 for 10 seconds.",
	cooldown = 35,
	price = 275,
	icon = "hexgm/ui/hex_item_ironskinpotion.png",
	func = function(ply)
		ply:BuffDamageResist( ply, 10, 5 )

		ply:EmitSound("wc3sound/exp/Submerge1.wav",75,135)
	end
}
HEX.ItemTable[10] = { 
	name = "Incendiary Trap", 
	id = "incendiarytrap",
	desc = "Drops a fire trap that activates in enemy proximity.",  
	itemrarity = "magic",
	itemtype = "activated", 
	itemability = "Lay Trap",
	itemabilitydesc = "Summon an incendiary trap.",
	cooldown = 15,
	price = 255,
	icon = "hexgm/ui/hex_item_incendiarytrap.png",
	func = function(ply)
		if ply:IsOnGround() then
			ply:EmitSound("weapons/club/morrowind_club_deploy1.wav",75,115)

			if IsValid(ply.HEXTrap) then
				ply.HEXTrap:Remove()
			end

            ply.HEXTrap = ents.Create( "ent_hex_trapfire" )
            ply.HEXTrap:SetPos(ply:GetPos())
            ply.HEXTrap:SetOwner( ply )
            ply.HEXTrap:SetAngles(Angle(0,0,1))
            ply.HEXTrap:Spawn()
        end
	end 
}
HEX.ItemTable[11] = { 
	name = "Sapphire Flask", 
	id = "sapphireflask",
	desc = "A weak magical potion to replenish mana reserves.",  
	itemrarity = "common",
	itemtype = "activated", 
	itemability = "Mana Potion",
	itemabilitydesc = "Mana +25",
	cooldown = 15,
	price = 125,
	icon = "hexgm/ui/hex_item_sapphireflask.png",
	func = function(ply)
		ply:AddMana(25)

		ply:EmitSound("wc3sound/exp/Submerge1.wav",75,135)

		ply:AbolishBuffs("manadrain")
	end 
}
HEX.ItemTable[12] = { 
	name = "Blackpowder Bomb", 
	id = "blackpowderbomb",
	desc = "A highly explosive throwable bomb.",  
	itemrarity = "common",
	itemtype = "activated", 
	itemability = "Toss Bomb",
	itemabilitydesc = "Throw a highly explosive bomb.",
	cooldown = 25,
	price = 175,
	icon = "hexgm/ui/hex_item_blackpowderbomb.png",
	func = function(ply)
		ply:EmitSound("weapons/knife/morrowind_knife_slash.wav",75,85)

        local tr = ply:GetEyeTrace()
        local ent = ents.Create( "ent_hex_blackpowderbomb" )

        ent:SetPos(ply:GetShootPos())
        ent:SetOwner( ply )
        ent:SetAngles(ply:EyeAngles())
        ent:Spawn()

        local phys = ent:GetPhysicsObject()
        if phys:IsValid() then
            phys:ApplyForceCenter( ( ply:GetAimVector() +  ply:GetForward() ) * 5000)
            phys:SetVelocity( phys:GetVelocity() + Vector(0,0,50) )
            phys:EnableGravity(true)	
        end
	end 
}
HEX.ItemTable[13] = { 
	name = "Frost Trap", 
	id = "frosttrap",
	desc = "Drops a frost trap that activates in enemy proximity.",  
	itemrarity = "magic",
	itemtype = "activated", 
	itemability = "Lay Trap",
	itemabilitydesc = "Summon a frost trap.",
	cooldown = 15,
	price = 275,
	icon = "hexgm/ui/hex_item_frosttrap.png",
	func = function(ply)
		if ply:IsOnGround() then
			ply:EmitSound("weapons/club/morrowind_club_deploy1.wav",75,115)

			if IsValid(ply.HEXTrap) then
				ply.HEXTrap:Remove()
			end

            ply.HEXTrap = ents.Create( "ent_hex_trapfrost" )
            ply.HEXTrap:SetPos(ply:GetPos())
            ply.HEXTrap:SetOwner( ply )
            ply.HEXTrap:SetAngles(Angle(0,0,1))
            ply.HEXTrap:Spawn()
        end
	end 
}
HEX.ItemTable[14] = { 
	name = "Venom Trap", 
	id = "venomtrap",
	desc = "Drops a venom trap that activates in enemy proximity.",  
	itemrarity = "magic",
	itemtype = "activated", 
	itemability = "Lay Trap",
	itemabilitydesc = "Summon a venom trap.",
	cooldown = 15,
	price = 270,
	icon = "hexgm/ui/hex_item_venomtrap.png",
	func = function(ply)
		if ply:IsOnGround() then
			ply:EmitSound("weapons/club/morrowind_club_deploy1.wav",75,115)

			if IsValid(ply.HEXTrap) then
				ply.HEXTrap:Remove()
			end

            ply.HEXTrap = ents.Create( "ent_hex_trapvenom" )
            ply.HEXTrap:SetPos(ply:GetPos())
            ply.HEXTrap:SetOwner( ply )
            ply.HEXTrap:SetAngles(Angle(0,0,1))
            ply.HEXTrap:Spawn()
        end
	end 
}
HEX.ItemTable[15] = { 
	name = "Shock Trap", 
	id = "shocktrap",
	desc = "Drops a shock trap that activates in enemy proximity.",  
	itemrarity = "magic",
	itemtype = "activated", 
	itemability = "Lay Trap",
	itemabilitydesc = "Summon a shock trap.",
	cooldown = 15,
	price = 285,
	icon = "hexgm/ui/hex_item_shocktrap.png",
	func = function(ply)
		if ply:IsOnGround() then
			ply:EmitSound("weapons/club/morrowind_club_deploy1.wav",75,115)

			if IsValid(ply.HEXTrap) then
				ply.HEXTrap:Remove()
			end

            ply.HEXTrap = ents.Create( "ent_hex_trapshock" )
            ply.HEXTrap:SetPos(ply:GetPos())
            ply.HEXTrap:SetOwner( ply )
            ply.HEXTrap:SetAngles(Angle(0,0,1))
            ply.HEXTrap:Spawn()
        end
	end 
}

--[[New Items
HEX.ItemTable[16] = { 
	name = "Magiserelate", 
	id = "magiserelate",
	desc = "Toughens the skin and cells against magical attacks.",  
	itemrarity = "common",
	itemtype = "activated", 
	itemability = "Magic Resist Potion",
	itemabilitydesc = "Magic Resist +10 for 15 seconds.",
	cooldown = 35,
	price = 275,
	icon = "hexgm/ui/hex_item_magiserelate.png",
	func = function(ply)
		ply:BuffMagicResist( ply, 10, 5 )

		ply:EmitSound("wc3sound/exp/Submerge1.wav",75,135)
	end
}
HEX.ItemTable[17] = { 
	name = "Quartz Flask", 
	id = "quartzflask",
	desc = "Rejuvination potion.",  
	itemrarity = "common",
	itemtype = "activated", 
	itemability = "Rejuvination Potion",
	itemabilitydesc = "Health and Mana +25",
	cooldown = 15,
	price = 100,
	icon = "hexgm/ui/hex_item_quartzflask.png",
	func = function(ply)
		ply:AddHP(25)
		ply:AddMana(25)
		ply:EmitSound("wc3sound/exp/Submerge1.wav",75,135)

		ply:AbolishBuffs("poison")
		ply:AbolishBuffs("bleed")
	end 
}
HEX.ItemTable[18] = { 
	name = "Dark Seed", 
	id = "darkseed",
	desc = "Protects from poison.",  
	itemrarity = "rare",
	itemtype = "passive", 
	itemability = "Poison Affinity",
	itemabilitydesc = "Poison Resist +5",
	cooldown = 0,
	price = 450,
	icon = "hexgm/ui/hex_item_darkseed.png",
	func = function(ply)
		-- do nothing
	end
}
HEX.ItemTable[19] = { 
	name = "Lava Shackles", 
	id = "lavashackles",
	desc = "Reflects damage with a chance to cast burning on attacker.",  
	itemrarity = "magic",
	itemtype = "passive", 
	itemability = "Fire Thorns",
	itemabilitydesc = "Reflect 1/2 damage.",
	cooldown = 0,
	price = 215,
	icon = "hexgm/ui/hex_item_lavashackles.png",
	func = function(ply)
		-- do nothing
	end 
}]]