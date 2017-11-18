function GM:PlayerInitialSpawn(ply)
	--ply:SetTeam(0) -- Spectator

	-- Set initial base stats
	ply:SetJumpPower(250)

	ply.BaseWalkSpeed = HEX.MOD.DefaultWalkSpeed
	ply:SetWalkSpeed( ply.BaseWalkSpeed )

	ply.BaseRunSpeed = HEX.MOD.DefaultRunSpeed
	ply:SetRunSpeed( ply.BaseRunSpeed )

	ply.BaseCrouchSpeed = HEX.MOD.DefaultCrouchSpeed
	ply:SetCrouchedWalkSpeed( ply.BaseCrouchSpeed )

	ply.BaseJumpPower = HEX.MOD.DefaultJumpPower
	ply:SetJumpPower( ply.BaseJumpPower )

	ply.MovementMod = 1 -- Use this to modify movement speed variables. 1 is normal speed/power.

	ply:SetGold(50)
	ply:SetMana(100)

	ply:SetNWInt("MaxHealth",100)
	ply:SetNWInt("MaxMana",100)

	ply.HealthRegenRate = 1
	ply.ManaRegenRate = 1
	ply.ManaUsageMod = 1

	ply.DropDelay = 0
	ply.RTVInit = false

	ply:SetupResistances()
	ply:SetupElementalBoost()

	ply.NextHealthRegen = 5
	ply.NextManaRegen = 5
	ply.NextPayday = 120

	ply.ItemCooldown = 0

	ply.Killstreak = 0
	ply.LastKilled = nil

	ply.LastHit = nil
	ply.LastHitDelay = 0
	ply.LastHitDamage = 0

	ply.HEX_Checkpoint = nil

	ply:NetworkCrests()


	ply:SetNWString("PreparingAttack",false)

	ply.VotedMap = 0
	ply.VotedGameType = 0
	if HEX.NextMapInfoValidated == true then
		HexMsg(ply,"HEX","Welcome to HEX! You are playing "..HEX.NextMapInfoTable.game.." on "..HEX.NextMapInfoTable.name..".",Vector(215,185,115),false)
	else
		--HexMsg(ply,"HEX","Welcome to HEX! Game settings appear to be broken, type !rtv to begin a game vote!",Vector(215,185,115),false)
	end		
	ply:SetNWInt("Score",0)

	ply.TitleTable = {}
	ply:SetNWString("PlayerTitle","Rookie")

	ply:SetNWString("Rank","Rookie")
	ply:SetNWInt("RankLevel",1)
	ply:SetNWInt("RankLevelMax",100)
	ply:SetNWInt("Experience",0)
	ply:SetNWInt("ExperienceMax",100)
	-- Load data here ( when save/load system is implemented )

	if HEX.DebugSQL == false then
		ply:LoadData()
	end
	timer.Simple(1,function()
		ply:FixRank()
	end)

	ply:SetTeam(11) -- Caster

	if HEX.Teamplay == true then
		ply:SortTeam()
	end

	if HEX.Gametype == "Elder" then
		ply.ElderDamage = 0
	end

	ply:SetNWInt("ResourceWood",0)		-- Repairing things, general crafting.
	ply:SetNWInt("ResourceMetal",0)		-- Building construction, general crafting.
	ply:SetNWInt("ResourceRuby",0)			-- For fire type.
	ply:SetNWInt("ResourceSapphire",0)		-- For frost and water type.
	ply:SetNWInt("ResourceTopaz",0)			-- For storm type.
	ply:SetNWInt("ResourceEmerald",0)		-- For poison and nature type.
	ply:SetNWInt("ResourceAmethyst",0)		-- For magic type weapons and items.
	ply:SetNWInt("ResourceOpal",0)			-- For unique types, can also be used as any other gemstone.

	ply:SetNWString("SelectedModel","models/whdow2/cultist_plr.mdl")

	ply:SetMainWeapon(HEX.MOD.DefaultWeapon)
	ply:SetCurrentWeapon(HEX.MOD.DefaultWeapon)

	ply:SetMainItem(HEX.MOD.DefaultItem)
	ply:SetCurrentItem(HEX.MOD.DefaultItem)

	HexSplash(ply)
end

function GM:PlayerDisconnected(ply)
	if HEX.MOD.PlayerGoldDropToggle == true then
		ply:DropGoldOnDeath(true)
	end
	if HEX.MOD.PlayerHPMPDropToggle == true then
		ply:DropItemsOnDeath()
	end

	-- Team Handling
	if HEX.Teamplay == true then
		if ply:Team() == 1 then
			HEX.Team.Team1 = HEX.Team.Team1 - 1
		end
		if ply:Team() == 2 then
			HEX.Team.Team2 = HEX.Team.Team2 - 1
		end
		if ply:Team() == 3 then
			HEX.Team.Team3 = HEX.Team.Team3 - 1
		end
		if ply:Team() == 4 then
			HEX.Team.Team4 = HEX.Team.Team4 - 1
		end
	end
end

function GM:PlayerSpawn(ply)
	HEX.DoPlayerSpawnEvent(ply)
end

function HEX.DoPlayerSpawnEvent(ply)
	if HEX.Teamplay == true && HEX.TeamSpawnToggle == true then
		HEX.PlayerSelectSpawn(ply,2)
	elseif HEX.Teamplay == true && HEX.TeamSpawnToggle == false then
		HEX.PlayerSelectSpawn(ply,1)
	end
	if HEX.Teamplay == false then
		HEX.PlayerSelectSpawn(ply,1)
	end

	HEX.SendGamemodeInfo(false,ply)

	ply:ResetMovementMod(true)

	ply:RemoveSuit() -- disable annoying hl2 suit death sounds

	HEX.ResetPowerups(ply)

	-- Remove old ents
	if IsValid(ply.HEXTrap) then
		ply.HEXTrap:Remove()
	end

	if IsValid(ply.HEXCircle) then
		ply.HEXCircle:Remove()
	end

	-- Setup Model
	ply:SetModel( ply:GetNWString("SelectedModel") )
	if ply:GetModel() == "models/player/skeleton.mdl" then
		ply:SetSkin(math.random(0,3))
	end
	if ply:GetModel() == "models/palutena/palutena_body.mdl" then
		ply:SetSkin(math.random(0,5))
		ply:SetBodygroup(2,1)
	end
	ply:SetFOV(75,5) -- Default FOV

	-- Setup Weapon
	ply:SetCurrentWeapon( ply:GetMainWeapon() )
	ply:Give(ply:GetCurrentWeapon())

	-- Setup Item
	ply:SetCurrentItem( ply:GetMainItem() )
	ply.ItemCooldown = CurTime()+5
	net.Start( "updateitemcooldown" )
		net.WriteInt(5,10)
	net.Send(ply)

	-- Setup Stats
	ply:SetupResistances()
	ply:SetHealth(ply:GetNWInt("MaxHealth"))
	ply:SetMana(ply:GetNWInt("MaxMana"))
	ply:AbolishBuffs("all")

	timer.Simple(1,function()
		if IsValid(ply) && ply:Alive() then
			ply:SetPassiveBuffs()
		end
	end)

	-- Respawn Effect
	local fx = EffectData()
	fx:SetOrigin( ply:GetPos() )
	util.Effect( "fx_hex_playerspawn", fx )
	ply:EmitSound( "ambient/levels/labs/electric_explosion1.wav", 75, math.random(125,130) )

	ply.Mines = {}
end

function GM:PlayerDeath(vic,inf,att)
	--vic:AddDeaths(1)

	if vic.LastHit != nil then
		-- print(vic.LastHit)
		att = vic.LastHit
		att:AddFrags(1)
		DoGoreFX(vic:GetPos())
		if vic.LastHitDamage >= 100 then
			DoGoreFX(vic:GetPos())
		end
	end

	-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	-- Handle gold / item dropping on death   --
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	if HEX.MOD.PlayerGoldDropToggle == true then
		vic:DropGoldOnDeath(false)
	end
	if HEX.MOD.PlayerHPMPDropToggle == true then
		vic:DropItemsOnDeath()
	end
	if HEX.MOD.PlayerDeathDropWeapon == true then
		vic:DropWeapon()
	end
	if HEX.MOD.PlayerDeathDropItem == true then
		vic:DropItem()
	end
	-- -- -- -- -- -- -- --
	-- Respawn handling  -- 
	-- -- -- -- -- -- -- --
	local count = 5
	if vic == att then
		count = count + HEX.MOD.RespawnTime
	end
	if !att:IsPlayer() then
		count = count + HEX.MOD.RespawnPenalty
	end
	vic.NextSpawn = CurTime() + ( math.Round(count) )
	timer.Simple(1,function()
		if IsValid(vic) then
			HexMsg(vic,"Death","Respawning in " .. (math.Round(count)) .." seconds...",Vector(155,215,155),false)

			umsg.Start("SendHexRespawnTime", vic)
				umsg.Short( count )
			umsg.End()
		end
	end)
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	-- Death Info by Crashlemon, from Lment   --
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	local dinfo_attacker = att:EntIndex()
	local dinfo_victim = vic:EntIndex() 
	local dinfo_weapon = "none"

	if att:IsPlayer() then
		dinfo_attacker = att:EntIndex()
		dinfo_victim = vic:EntIndex()
		dinfo_weapon = att:GetCurrentWeapon()

		umsg.Start( "ply_death_info")
			umsg.Short( dinfo_victim )
			umsg.Short( dinfo_attacker )
			umsg.String( dinfo_weapon )
		umsg.End()
	end
	-- -- -- -- -- -- -- -- -- --
	-- Skirmish Death Handling --
	-- -- -- -- -- -- -- -- -- --
	if HEX.Gametype == "Skirmish" or HEX.Gametype == "Team Skirmish" or HEX.Gametype == "Scavenger" then
		if HEX.Round.RoundState == 1 then
			--vic:SetNWInt("Score",math.Round(vic:GetNWInt("Score")-1))
			if att:IsPlayer() && att != vic then
				att:SetNWInt("Score",math.Round(att:GetNWInt("Score")+2))
				if HEX.Teamplay == true then
					HEX.CheckTeamVictory()
				else
					if HEX.MOD.GoalKills > 0 && att:GetNWInt("Score") >= HEX.MOD.GoalKills then
						HEX.EndRound(1,0)
					end
				end
			end
		end
	end
	-- -- -- -- -- -- -- -- -- --
	-- Elder Death Handling -- --
	-- -- -- -- -- -- -- -- -- --
	if HEX.Gametype == "Elder" then
		if HEX.Round.RoundState == 1 then
			if att:IsPlayer() then
				if vic:Team() == 1 then
					HexMsg(vic,"Elder",att:Name().." killed the Elder, "..vic:Name().."!",Vector(185,155,155),true)
					att:SetNWInt("Score", att:GetNWInt("Score") + 50 )

					HEX.EndRound(1,0)
				end
			else
				if vic:Team() == 1 then
					HexMsg(vic,"Elder","The Elder died from unknown causes!",Vector(185,155,155),true)

					HEX.EndRound(1,0)
				end
			end
		end
	end
	-- -- -- -- -- -- -- -- -- --
	-- Death by NPC Handling   -- 
	-- -- -- -- -- -- -- -- -- --
	if att:IsNPC() then
		--HexMsg(vic,"Death","You were killed by a " .. att:GetClass() .. "!",Vector(185,155,155),false)	
		HEX.SendNotification(vic,Color(185,155,155),255,"You were killed by a " .. att:GetClass() .. "!",false)
		return
	end
	-- -- -- -- -- -- -- --
	-- Suicide / Misc    -- 
	-- -- -- -- -- -- -- --
	if !att:IsPlayer() then
		--HexMsg(vic,"Death","You died!",Vector(155,155,155),false)
		HEX.SendNotification(vic,Color(155,155,155),255,"You died!",false)
		return
	end

	if vic == att then
		--HexMsg(vic,"Death","Suicide!",Vector(155,155,155),false)
		HEX.SendNotification(vic,Color(155,155,155),255,"Suicide!",false)
		return
	end

	--att:AddFrags(1)
	if HEX.MOD.KillstreakToggle == true then
		-- -- -- -- -- -- -- --
		-- Bounty handling   -- 
		-- -- -- -- -- -- -- --
		if vic.Killstreak >= 5 then
			HexMsg(att,"Killstreak",vic:Name() .. "'s killstreak of " .. vic.Killstreak .. " ended by " .. att:Name() .. "!",Vector(215,185,255),true)
			HexMsg(att,"Bounty","Gold bonus: +".. math.Round(#player.GetAll()*vic.Killstreak) .." for " .. vic:Name() .. "'s head!" ,Vector(115,215,115),false)
			att:AddGold(math.Round(#player.GetAll()*vic.Killstreak))
			HexSound(pl, "wc3sound/exp/ArrangedTeamInvitation.wav", true)
		end
		vic.Killstreak = 0
		-- -- -- -- -- -- -- -- --
		-- Killstreak handling  -- 
		-- -- -- -- -- -- -- -- --
		if att.LastKilled != vic then
			att.Killstreak = att.Killstreak + 1
		end
		if att.Killstreak == 5 then
			HexMsg(att,"Killstreak",att:Name() .. " is on a killstreak!",Vector(215,155,155),true)
			HexMsg(att,"Killstreak","Gold bonus: +10",Vector(215,155,115),false)
			att:AddGold(25)
		elseif att.Killstreak == 15 then
			HexMsg(att,"Killstreak",att:Name() .. " is dominating!",Vector(215,155,155),true)
			HexMsg(att,"Killstreak","Gold bonus: +25",Vector(215,155,115),false)
			att:AddGold(50)
		elseif att.Killstreak == 30 then
			HexMsg(att,"Killstreak",att:Name() .. " is godlike!",Vector(215,155,155),true)
			HexMsg(att,"Killstreak","Gold bonus: +50",Vector(215,155,115),false)
			att:AddGold(100)
		end
	end
	-- -- -- -- -- -- - -- -- -- --
	-- Attacker / Victim handling -- 
	-- -- -- -- -- -- -- -- -- -- --
	if att:IsPlayer() then
		-- Attacker Handling
		--HexMsg(att,"Kill","You killed " .. vic:Name() .. "!",Vector(215,155,155),false)
		HEX.SendNotification(att,Color(215,155,155),255,"You killed " .. vic:Name() .. "!",false)
		
		-- Victim Handling
		--HexMsg(vic,"Death","You were killed by " .. att:Name() .. "!",Vector(215,155,155),false)	
		HEX.SendNotification(vic,Color(215,155,155),255,"You were killed by " .. att:Name() .. "!",false)
				
		if vic.LastKilled == att then
			HexMsg(vic,"Death",att:Name() .. " is your nemesis!",Vector(235,155,155),false)
		end
	end
	-- Last Killed for determining nemesis and preventing infinite killstreak on the same person.
	vic.LastHit = nil
	vic.LastKilled = att
	vic.LastHitDamage = 0
end
 
function GM:PlayerDeathThink( ply )
	if !ply.NextSpawn then ply.NextSpawn = 1 end
    if (CurTime()>=ply.NextSpawn) then
        ply:Spawn()
        ply.NextSpawn = math.huge
    end
end

function GM:EntityTakeDamage( target, dmginfo )
	-- Environmental Damage
	if dmginfo:GetAttacker():GetClass() == "trigger_hurt" then
		if dmginfo:GetAttacker():GetName() == "lava_dmg" then
			if target:GetCurrentItem() != "hellstone" then
				target:BuffFire(dmginfo:GetAttacker(),1,3)
			else
				dmginfo:SetDamage(5)
			end
		end
		if dmginfo:GetAttacker():GetName() == "poison_dmg" then
			if target:GetCurrentItem() != "darkseed" then
				target:BuffPoison(dmginfo:GetAttacker(),3,7)
			else
				dmginfo:SetDamage(2)
			end
		end
		if dmginfo:GetAttacker():GetName() == "ice_dmg" then
			if target:GetCurrentItem() != "starsapphire" then
				target:BuffIce(dmginfo:GetAttacker(),2,5)
			else
				dmginfo:SetDamage(1)
			end
		end

	end

	-- Player Damage
	if (target:IsPlayer() && target:Alive() && dmginfo:GetAttacker():IsPlayer()) then
		local scale = 0
		local crit = math.random(0,100)
		local critsuccess = false

		target.LastHit = dmginfo:GetAttacker()
		target.LastHitDelay = CurTime() + 5

		dmginfo:SetDamage(dmginfo:GetDamage()-target:GetNWInt("DamageResist"))

		-- Magic Damage Handling
		if dmginfo:GetDamageElement() == "magic" then
			dmginfo:SetDamage(dmginfo:GetDamage()-target:GetNWInt("MagicResist")+dmginfo:GetAttacker():GetNWInt("MagicDamage")) 
		end

		-- Fire Damage Handling
		if dmginfo:GetDamageElement() == "fire" then 
			if target:GetNWInt("Soaked") == 1 then
				dmginfo:SetDamage(math.Round(dmginfo:GetDamage()/2))
			end
			dmginfo:SetDamage(dmginfo:GetDamage() - target:GetNWInt("FireResist")+dmginfo:GetAttacker():GetNWInt("FireDamage")) 
		end

		-- Frost Damage Handling
		if dmginfo:GetDamageElement() == "frost" then 
			dmginfo:SetDamage(dmginfo:GetDamage()-target:GetNWInt("FrostResist")+dmginfo:GetAttacker():GetNWInt("FrostDamage")) 
		end

		-- Storm Damage Handling
		if dmginfo:GetDamageElement() == "storm" then 
			if target:GetNWInt("Soaked") == 1 then
				dmginfo:SetDamage(math.Round(dmginfo:GetDamage()*2))
			end
			dmginfo:SetDamage(dmginfo:GetDamage()-target:GetNWInt("StormResist")+dmginfo:GetAttacker():GetNWInt("StormDamage")) 
		end

		-- Poison Damage Handling
		if dmginfo:GetDamageElement() == "poison" then 
			dmginfo:SetDamage(dmginfo:GetDamage()-target:GetNWInt("PoisonResist")+dmginfo:GetAttacker():GetNWInt("PoisonDamage")) 
		end

		-- Enraged Critical Enhancement
		if dmginfo:GetAttacker():GetNWInt("Enraged") == 1 then
			crit = math.random(60,100)
		end

		-- Critical Strikes
		if dmginfo:GetDamage() > 4 then
			if (crit > 85 && crit < 100) then
				scale = scale + 2
				critsuccess = true
			end
		end

		if scale <= 1 then scale = 1 end
		dmginfo:ScaleDamage(scale)

		if dmginfo:GetDamage() < 1 then
			dmginfo:SetDamage(1)
		end

		if HEX.Teamplay == true then
			if HEX.Round.RoundState == 1 then
				if target:Team() == dmginfo:GetAttacker():Team() then dmginfo:SetDamage(0) return end
			end
		end

		-- ITEM FUNC: Thorniken
		if target:GetCurrentItem() == "thorniken" then
			dmginfo:GetAttacker():TakeThornsDamage(target,dmginfo:GetDamage()/2)
		end

		-- ITEM FUNC: Lava Shackles
		if target:GetCurrentItem() == "lavashackles" then
			dmginfo:GetAttacker():TakeThornsDamage(target,dmginfo:GetDamage()/2)
			local rand = math.random(1,100)
			if rand > 50 then
				dmginfo:GetAttacker():BuffFire(target,3,3)
			end
		end

		-- ITEM FUNC: Dracula Fang
		if dmginfo:GetAttacker():GetCurrentItem() == "draculafang" then
			local chance = math.random(1,10)
			if chance > 3 then
				dmginfo:GetAttacker():AddHP(1)
			end
		end

		-- GAMEMODE FUNC: Elder Damage
		if HEX.Gametype == "Elder" then
			if target:Team() == 1 then
				dmginfo:GetAttacker().ElderDamage = dmginfo:GetAttacker().ElderDamage + dmginfo:GetDamage()
				if dmginfo:GetAttacker().ElderDamage >= 100 then
					dmginfo:GetAttacker().ElderDamage = 0
					dmginfo:GetAttacker():SetNWInt("Score",dmginfo:GetAttacker():GetNWInt("Score")+1)
				end
			end
		end

		-- Enraging
		if target:Health() <= 25 then
			local enragechance = math.random(1,100)
			if enragechance >= 75 then
				target:BuffEnraged(target,5)
			end
		end

		-- Powerups Handling
		HEX.HandlePowerupResistance(dmginfo:GetDamageElement(),target)
		HEX.HandlePowerupAttacks(target,dmginfo:GetAttacker(),dmginfo:GetDamage())

		target.LastHitDamage = dmginfo:GetDamage()

		-- Health Regen delay
		target.NextHealthRegen = CurTime() + 5

		-- Send Floating Damage Numbers ( by CrashLemon )
		dmginfo:GetAttacker():SendFloatingDmg(dmginfo:GetDamage(),dmginfo:GetDamageElement(),target:GetPos(),critsuccess,true,Vector(0,0,0),"")
	end
end

-- TODO: Better way of checking for and handling powerup statuses
function HEX.CheckPowerups(ply)
	local powerups = false
	if ply:GetNWInt("PowerupVampirism") == 1 then powerups = true end
	if ply:GetNWInt("PowerupInferno") == 1 then powerups = true end
	if ply:GetNWInt("PowerupFrostbite") == 1 then powerups = true end
	if ply:GetNWInt("PowerupLife") == 1 then powerups = true end
	if ply:GetNWInt("PowerupNature") == 1 then powerups = true end
	if ply:GetNWInt("PowerupPoison") == 1 then powerups = true end
	if ply:GetNWInt("PowerupShield") == 1 then powerups = true end
	if ply:GetNWInt("PowerupStorm") == 1 then powerups = true end
	return powerups
end

function HEX.ResetPowerups(ply)
	ply:SetNWInt("PowerupVampirism",0)
	ply:SetNWInt("PowerupInferno",0)
	ply:SetNWInt("PowerupFrostbite",0)
	ply:SetNWInt("PowerupLife",0)
	ply:SetNWInt("PowerupNature",0)
	ply:SetNWInt("PowerupPoison",0)
	ply:SetNWInt("PowerupShield",0)
	ply:SetNWInt("PowerupStorm",0)
end

-- TODO: Better way of handling resistances
function HEX.HandlePowerupResistance(element,vic)
	local resist = false
	if element == "fire" && vic:GetNWInt("PowerupInferno") == 1 then resist = true end
	if element == "frost" && vic:GetNWInt("PowerupFrostbite") == 1 then resist = true end
	if element == "nature" or element == "water" or element == "earth" then
		if vic:GetNWInt("PowerupNature") == 1 then 
			resist = true 
		end
	end
	if element == "poison" && vic:GetNWInt("PowerupPoison") == 1 then resist = true end
	if element == "storm" && vic:GetNWInt("PowerupStorm") == 1 then resist = true end
	return resist
end

-- TODO: Better way of handling powerup damage
function HEX.HandlePowerupAttacks(vic,att,dmg)
	if att:GetNWInt("PowerupVampirism") == 1 then 
		HEX.PowerupTable[1].damage(vic,att,dmg)
	end
	if att:GetNWInt("PowerupInferno") == 1 then
		HEX.PowerupTable[2].damage(vic,att,dmg)
	end
	if att:GetNWInt("PowerupFrostbite") == 1 then
		HEX.PowerupTable[3].damage(vic,att,dmg)
	end
	if att:GetNWInt("PowerupLife") == 1 then
		HEX.PowerupTable[4].damage(vic,att,dmg)
	end
	if att:GetNWInt("PowerupNature") == 1 then
		HEX.PowerupTable[5].damage(vic,att,dmg)
	end
	if att:GetNWInt("PowerupPoison") == 1 then
		HEX.PowerupTable[6].damage(vic,att,dmg)
	end
	if att:GetNWInt("PowerupShield") == 1 then 
		HEX.PowerupTable[7].damage(vic,att,dmg)
	end
	if att:GetNWInt("PowerupStorm") == 1 then 
		HEX.PowerupTable[8].damage(vic,att,dmg)
	end
end

function DoGoreFX(pos)
	local fx = EffectData()
	fx:SetOrigin(pos+Vector(0,0,32))
	util.Effect("fx_hex_blood",fx)
end

function GM:GetFallDamage( ply, speed )
	return ( 0 )
end

function GM:PlayerCanPickupWeapon( ply, wep )
	return ( wep:GetClass() == ply:GetCurrentWeapon() )
end