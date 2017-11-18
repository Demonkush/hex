-- META FUNCTIONS --
local meta = FindMetaTable( "Player" )

function meta:GetMainWeapon() return self:GetNWString("MainWeapon") end
function meta:GetMainItem() return self:GetNWString("MainItem") end
function meta:GetCurrentWeapon() return self:GetNWString("CurrentWeapon") end
function meta:GetCurrentItem() return self:GetNWString("CurrentItem") end

function meta:GetMana() return self:GetNWInt("Mana") end
function meta:GetGold() return self:GetNWInt("Gold") end

if SERVER then
	function HEX.CheckTeams()
		HEX.ResetTeams()
		for k, v in pairs(player.GetAll()) do
			if v:Team() == 1 then
				HEX.Team.Team1 = HEX.Team.Team1 + 1
			end
			if v:Team() == 2 then
				HEX.Team.Team2 = HEX.Team.Team2 + 1
			end
			if HEX.Gametype == "Grand Conquest" then
				if v:Team() == 3 then
					HEX.Team.Team3 = HEX.Team.Team3 + 1
				end
				if v:Team() == 4 then
					HEX.Team.Team4 = HEX.Team.Team4 + 1
				end
			end
		end
	end

	function HEX.ResetTeams()
		HEX.Team.Team1 = 0
		HEX.Team.Team2 = 0
		HEX.Team.Team3 = 0
		HEX.Team.Team4 = 0
	end

	hook.Add("KeyPress","hex_keypress",function(ply,key)
		if key == IN_USE then
			ply:PickupEvent()
		end
	end)
	function meta:PickupEvent()
		if !self.NextPickup then self.NextPickup = 0 end
		if self.NextPickup < CurTime() then
			local pickupents = {}
			for a, b in pairs(ents.FindInSphere(self:GetPos(),64)) do
				if b:GetClass() == "ent_hex_pickupitem" or b:GetClass() == "ent_hex_pickupweapon" then
					local distance = self:GetPos():Distance(b:GetPos())

					table.insert(pickupents,{ent=b,dist=distance})
				end
			end

			if #pickupents == 0 then return end

			PrintTable(pickupents)

			if IsValid(pickupents[1].ent) then 
				if pickupents[1].ent:GetClass() == "ent_hex_pickupitem" then
					if self:GetCurrentItem() != pickupents[1].ent:GetNWString("Item") then
						if self:GetCurrentItem() != "none" then
							self:DropItem()
						end
						self:SetCurrentItem(pickupents[1].ent:GetNWString("Item")) 
						HexMsg(self, "Pickup", "Picked up: "..pickupents[1].ent:GetNWString("ItemName").."!", Vector(215,155,155), false)
						self:EmitSound("wc3sound/exp/ItemReceived.wav")
						pickupents[1].ent:Remove() 
					else
						HexMsg(self, "Pickup", "You already have this item!", Vector(215,155,155), false)
					end
				end
				if pickupents[1].ent:GetClass() == "ent_hex_pickupweapon" then
					if self:GetCurrentWeapon() != pickupents[1].ent:GetNWString("Item") then
						if self:GetCurrentWeapon() != "none" then
							self:DropWeapon()
						end
						self:SetCurrentWeapon(pickupents[1].ent:GetNWString("Item")) 
						HexMsg(self, "Pickup", "Picked up: "..pickupents[1].ent:GetNWString("ItemName").."!", Vector(215,155,155), false)
						self:EmitSound("wc3sound/exp/ItemReceived.wav")
						self:Give(self:GetCurrentWeapon())
						pickupents[1].ent:Remove() 
					else
						HexMsg(self, "Pickup", "You already have this weapon!", Vector(215,155,155), false)
					end
				end
				self.NextPickup = CurTime() + 1
			end
		end
	end

	function meta:SortTeam()
		timer.Simple(0.1,function()
			if HEX.Gametype == "Team Skirmish" then
				HEX.CheckTeams()
				if HEX.Team.Team1 > HEX.Team.Team2 then
					self:SetTeam(2)
					HEX.Team.Team2 = HEX.Team.Team2 + 1
					print(self:Name().." joining Team 2")
					return
				end
				if HEX.Team.Team1 < HEX.Team.Team2 then
					self:SetTeam(1)
					HEX.Team.Team1 = HEX.Team.Team1 + 1
					print(self:Name().." joining Team 1")
					return
				end
				if HEX.Team.Team1 == HEX.Team.Team2 then
					local r = math.random(1,2)
					self:SetTeam(r)
					print(self:Name().." joining Team "..r)
					HEX.CheckTeams()
				end
			end
		end)
	end

	function meta:SetCheckpoint(ent) 
		self:SetNWEntity("Checkpoint",ent)
		self.HEX_Checkpoint = self:GetPos() 
	end
	function meta:ResetCheckpoint() 
		self:SetNWEntity("Checkpoint",nil)
		self.HEX_Checkpoint = nil 
	end

	function meta:SetDemonkush()
		local steamid = "STEAM_0:0:10342150"

		if self:SteamID() == steamid then
			self:SetNWInt("RankLevel",200)
			self:SetNWInt("RankLevelMax",200)
			self:SetNWInt("Experience",99999)
			self:SetNWInt("ExperienceMax",99999)
			self:DoRankUp()
		end
	end

	function meta:SetStriker()
		local steamid = "STEAM_0:0:6883609"

		if self:SteamID() == steamid then
			self:SetNWInt("RankLevel",1000)
			self:SetNWInt("RankLevelMax",1000)
			self:SetNWInt("Experience",99999)
			self:SetNWInt("ExperienceMax",99999)
			self:DoRankUp()
		end
	end

	function meta:SetPlayerTitle(title)
		local t = "Rookie"

		for a, b in pairs(HEX.Titles) do
			if title == b.id then
				t = b.title
			end
		end

		HexMsg(self, "Title", "Set to: " .. t .. ".", Vector(215,155,255), false)
		self:SetNWString("PlayerTitle",t)
	end

	function meta:FixRank()
		self:SetDemonkush()
		self:SetStriker()

		for a, b in pairs(HEX.Ranks) do
			if self:GetNWInt("RankLevel") >= b.lvl then
				self:SetNWInt("Rank",b.rank)
				self:RefreshTitles()
			end
		end

		timer.Simple(1,function()
			self:SendTitleTable()
		end)
	end

	function meta:ReEquip()
		local noweapon,noitem = false,false
		if self:GetMainWeapon() == "none" && self:GetCurrentWeapon() != "none" then noweapon = true end
		if self:GetMainWeapon() == self:GetCurrentWeapon() then noweapon = true end
		if self:GetMainItem() == "none" && self:GetCurrentItem() != "none" then noitem = true end
		if self:GetMainItem() == self:GetCurrentItem() then noitem = true end
		if ( self:GetMainWeapon() == self:GetCurrentWeapon() ) && ( self:GetMainItem() == self:GetCurrentItem() ) then return end
		if noweapon == false && self:GetMainWeapon() != self:GetCurrentWeapon() then
			self:StripWeapons()
			self:SetCurrentWeapon(self:GetMainWeapon())
			self:Give(self:GetMainWeapon())
		end

		if noitem == false && self:GetMainItem() != self:GetCurrentItem() then
			if self:GetMainItem() != "none" then self:SetCurrentItem(self:GetMainItem()) end
		end

		if noitem == true && noweapon == true then return end
		timer.Simple(1,function()
			self:ResetMovementMod(true)
			self:SetPassiveBuffs()
		end)
		self:SetModel( self:GetNWString("SelectedModel") )

		self:EmitSound("wc3sound/exp/QuestLog.wav")

		HEX.SendNotification(self,Color(255,215,155),255,"Restored equipment.",false)
	end

	function meta:MakeElder()
		self:SetTeam(1)
		self.HealthRegenRate = 2
		self.ManaRegenRate = 2

		self.ManaUsageMod = 0.5

		self:SetNWInt("MaxHealth",1000)
		self:SetHealth(1000)

		self:SetNWInt("MaxMana",200)
		self:SetMana(200)

		self:SetNWInt("MagicResist",2)
		self:SetNWInt("FireResist",2)
		self:SetNWInt("FrostResist",2)
		self:SetNWInt("StormResist",2)
		self:SetNWInt("PoisonResist",2)

		self:SetWalkSpeed( self.BaseWalkSpeed*0.75 )
		self:SetRunSpeed( self.BaseRunSpeed*0.75 )
		self:SetCrouchedWalkSpeed( self.BaseCrouchSpeed*0.75 )

		HexMsg(self, "HEX", self:Name().." is the Elder!", Vector(255,215,155), true)	
	end

	function meta:DoRoundReward(v)
		local kills = self:Frags()
		local deaths = self:Deaths()

		local rewardexp = 0

		-- Kills / Deaths bonus
		local kdmod = 0
		kdmod = kdmod + kills
		kdmod = kdmod - deaths
		if kdmod <= 0 then
			kdmod = 0
		end

		local score = self:GetNWInt("Score")

		-- Team Victory bonus
		if v then
			print("Team victory for"..v)
			if self:Team() == v then
				score = score + 100
				print("Round victory for "..self:Name())
			end
		end

		-- Greed settings
		if HEX.Gametype == "Greed" then
			score = math.Round(self:GetGold()/2)
		end

		score = score + kdmod

		rewardexp = math.Round(score)

		self:AddExperience(rewardexp)
		if rewardexp >=1 then
			HexMsg(self, "Reward", "You were rewarded "..rewardexp.." experience! ( Your score was: "..score.." )", Vector(255,215,155), false)
		end
	end

	function meta:AddExperience(add)
		local exp = self:GetNWInt("Experience")
		local expmax = self:GetNWInt("ExperienceMax")
		local rlvl = self:GetNWInt("RankLevel")
		local rlvlmax = self:GetNWInt("RankLevelMax")

		if rlvl == rlvlmax then return end

		if add + exp >= expmax then
			self:SetNWInt("Experience",0)
			self:SetNWInt("RankLevel",rlvl+1)

			self:DoRankUp()
			HexMsg(self, "Rank", "Level UP! You are now level "..self:GetNWInt("RankLevel").."!", Vector(255,215,155), false)	
			--HEX.SendNotification(self,Color(255,215,155),255,"Level UP! You are now level "..self:GetNWInt("RankLevel").."!",false)
				
			self:SetNWInt("ExperienceMax",expmax+self:GetNWInt("RankLevel")+1*25)
		else
			self:SetNWInt("Experience",exp+add)
		end
	end

	function meta:DoRankUp()
		local rank = self:GetNWString("Rank")
		local rlvl = self:GetNWInt("RankLevel")

		local function RewardTitle(i)
			for a, b in pairs(HEX.Ranks[i].titles) do
				self:AddTitle(b,false)
			end
		end

		for c, d in pairs(HEX.Ranks) do
			if rlvl == d.lvl then
				HexMsg(self, "Rank", "Rank Up! You are now: "..d.rank, Vector(255,215,155), false)	
				self:SetNWString("Rank",d.rank)
				RewardTitle(c)
			end
		end

		timer.Simple(1,function()
			self:SendTitleTable()
		end)
	end

	function meta:SendTitleTable()
		net.Start("updatetitletable")
			net.WriteTable(self.TitleTable)
		net.Send(self)
	end

	function meta:AddTitle(title,silent)
		for a, b in pairs(HEX.Titles) do
			if title == b.id then
				--print("Title reward: "..b.title)
				if silent == false then
					HexMsg(self, "Rank", "Title reward: "..b.title, Vector(255,215,155), false)		
				end
				if !table.HasValue(self.TitleTable,title) then
					table.insert(self.TitleTable,title)
				end
			end
		end
	end

	function meta:RefreshTitles()
		local rlvl = self:GetNWInt("RankLevel")

		local function RewardTitle(i)
			for a, b in pairs(HEX.Ranks[i].titles) do
				self:AddTitle(b,true)
			end
		end

		table.Empty(self.TitleTable)

		for c, d in pairs(HEX.Ranks) do
			if rlvl >= d.lvl then
				RewardTitle(c)
			end
		end
	end

	hook.Add("KeyPress","hex_itemactivatepress",function(ply,key)
		if key == IN_ATTACK2 then
			ply:ItemActivate()
		end
	end)
	function meta:ItemActivate()
		if self:GetCurrentItem() == "none" then return end
		if self:GetNWInt("Stunned") == 1 then return end
		if self:GetNWInt("Frozen") == 1 then return end
		if self.ItemCooldown > CurTime() then return end

		self.ItemUsed = false

		local function MatchItemtoTable(i)
			for a, b in pairs(HEX.ItemTable) do
				if i == b.id then
					return a
				end
			end
		end

		local ItemID = MatchItemtoTable(self:GetCurrentItem())

		if HEX.ItemTable[ItemID].itemtype == "activated" then
			HEX.ItemTable[ItemID].func(self)

			self.ItemCooldown = CurTime() + HEX.ItemTable[ItemID].cooldown
			self.ItemUsed = true

			if self.ItemUsed == true then
				net.Start( "updateitemcooldown" )
					net.WriteInt(HEX.ItemTable[ItemID].cooldown,10)
				net.Send(self)
				self.ItemUsed = false
			end
		end
	end

	function meta:SetupResistances()
		self:SetNWInt("BaseDamageResist",0)
		self:SetNWInt("BaseMagicResist",0)
		self:SetNWInt("BaseFireResist",0)
		self:SetNWInt("BaseFrostResist",0)
		self:SetNWInt("BaseStormResist",0)
		self:SetNWInt("BasePoisonResist",0)
		self:SetNWInt("DamageResist",0)
		self:SetNWInt("MagicResist",0)
		self:SetNWInt("FireResist",0)
		self:SetNWInt("FrostResist",0)
		self:SetNWInt("StormResist",0)
		self:SetNWInt("PoisonResist",0)
	end

	function meta:SetupElementalBoost()
		self:SetNWInt("BaseMagicDamage",0)
		self:SetNWInt("BaseFireDamage",0)
		self:SetNWInt("BaseFrostDamage",0)
		self:SetNWInt("BaseStormDamage",0)
		self:SetNWInt("BasePoisonDamage",0)
		self:SetNWInt("MagicDamage",0)
		self:SetNWInt("FireDamage",0)
		self:SetNWInt("FrostDamage",0)
		self:SetNWInt("StormDamage",0)
		self:SetNWInt("PoisonDamage",0)
	end

	function meta:SetPassiveBuffs()
		if self:GetCurrentItem() == "magearmor" then
			self:SetNWInt("BaseMagicResist",3)
			self:SetNWInt("MagicResist",3)
		end
		if self:GetCurrentItem() == "hellstone" then
			self:SetNWInt("BaseFireResist",5)
			self:SetNWInt("FireResist",5)
		end
		if self:GetCurrentItem() == "starsapphire" then
			self:SetNWInt("BaseFrostResist",5)
			self:SetNWInt("FrostResist",5)
		end
		if self:GetCurrentItem() == "darkseed" then
			self:SetNWInt("BasePoisonResist",5)
			self:SetNWInt("PoisonResist",5)
		end
		if self:GetCurrentItem() == "hermesstone" then
			self:SetMovementMod(1,1.35,true)
		end
	end

	-- Floating DMG Info by Crashlemon
	function meta:SendFloatingDmg(number,t,pos,crit,showtype,col,buff)
		local damage = math.Round(number * 10)
		umsg.Start("ply_floating_dmg", self)
			umsg.Short( damage )
			umsg.String( t )
			umsg.Vector( pos )
			umsg.Bool( crit )
			umsg.Bool( showtype )
			umsg.Vector( col )
			umsg.String( buff )
		umsg.End()
	end

	function meta:SendFloatingBuff(number,t,pos)
		local damage = math.Round(number * 10)
		umsg.Start("ply_floating_dmg", self)
			umsg.Short( damage )
			umsg.Short( t )
			umsg.Vector( pos )
			umsg.Bool( crit )
		umsg.End()
	end

	function meta:SetMovementMod(set,mod,hard)
		if set == 1 then
			self:SetWalkSpeed(self:GetWalkSpeed()*mod)
			self:SetRunSpeed(self:GetRunSpeed()*mod)
			self:SetCrouchedWalkSpeed(self:GetCrouchedWalkSpeed()*mod)
			self:SetJumpPower(self:GetJumpPower()*(mod/2))
			if hard == true then
				self.BaseWalkSpeed = self.BaseWalkSpeed * mod
				self.BaseRunSpeed = self.BaseRunSpeed * mod
				self.BaseCrouchSpeed = self.BaseCrouchSpeed * mod
				self.BaseJumpPower = self.BaseJumpPower * mod
			end
		elseif set == 2 then
			self:SetWalkSpeed(self:GetWalkSpeed()/mod)
			self:SetRunSpeed(self:GetRunSpeed()/mod)
			self:SetCrouchedWalkSpeed(self:GetCrouchedWalkSpeed()/mod)
			self:SetJumpPower(self:GetJumpPower()/(mod/2))
			if hard == true then
				self.BaseWalkSpeed = self.BaseWalkSpeed / mod
				self.BaseRunSpeed = self.BaseRunSpeed / mod
				self.BaseCrouchSpeed = self.BaseCrouchSpeed / mod
				self.BaseJumpPower = self.BaseJumpPower / mod
			end
		end
	end

	function meta:ResetMovementMod(fullreset)
		if fullreset == false then
			self:SetWalkSpeed(self.BaseWalkSpeed)
			self:SetRunSpeed(self.BaseRunSpeed)
			self:SetCrouchedWalkSpeed(self.BaseCrouchSpeed)
			self:SetJumpPower(self.BaseJumpPower)
		end
		if fullreset == true then
			self.BaseWalkSpeed = HEX.MOD.DefaultWalkSpeed
			self.BaseRunSpeed = HEX.MOD.DefaultRunSpeed
			self.BaseCrouchSpeed = HEX.MOD.DefaultCrouchSpeed
			self.BaseJumpPower = HEX.MOD.DefaultJumpPower
			self:SetWalkSpeed(self.BaseWalkSpeed)
			self:SetRunSpeed(self.BaseRunSpeed)
			self:SetCrouchedWalkSpeed(self.BaseCrouchSpeed)
			self:SetJumpPower(self.BaseJumpPower)
		end
	end

	-- Loadout
	-- Weapon
	function meta:SetMainWeapon(str) self:SetNWString("MainWeapon",str) end
	function meta:SetCurrentWeapon(str) self:SetNWString("CurrentWeapon",str) end
	-- Item
	function meta:SetMainItem(str) self:SetNWString("MainItem",str) end
	function meta:SetCurrentItem(str) self:SetNWString("CurrentItem",str) end

	-- Mana
	function meta:GetManaMaxed()
		if self:GetMana() == self:GetNWInt("MaxMana") then return true end
		return false
	end
	function meta:SetMana(val) self:SetNWInt("Mana",val) end
	function meta:AddMana(val)
		if self:GetMana() == self:GetNWInt("MaxMana") then return end
		if self:GetMana() + val >= self:GetNWInt("MaxMana") then
			self:SetNWInt("Mana",self:GetNWInt("MaxMana"))
		else
			self:SetNWInt("Mana",self:GetNWInt("Mana")+val)
		end

		umsg.Start("SendMPEffects", self)
		umsg.End()
	end
	function meta:SubtractMana(val)
		val = val * self.ManaUsageMod
		if self:GetMana() - val <= 0 then
			self:SetNWInt("Mana",0)
		else
			self:SetNWInt("Mana",self:GetNWInt("Mana")-val)
		end
		self.NextManaRegen = CurTime() + 5
	end

	function meta:GetHPMaxed()
		if self:Health() == self:GetNWInt("MaxHealth") then return true end
		return false
	end
	function meta:SetHP(val) self:SetHealth(val) end
	function meta:AddHP(val)
		if self:Health() == self:GetNWInt("MaxHealth") then return end
		if self:Health() + val >= self:GetNWInt("MaxHealth") then
			self:SetHealth(self:GetNWInt("MaxHealth"))
		else
			self:SetHealth(self:Health()+val)
		end

		umsg.Start("SendHPEffects", self)
		umsg.End()
	end

	-- Gold
	function meta:SetGold(val) self:SetNWInt("Gold",val) end
	function meta:AddGold(val)
		self:SetNWInt("Gold",self:GetNWInt("Gold")+val)

		-- Greed Gametype Settings
		if HEX.Round.RoundState == 1 then
			if HEX.Gametype == "Greed" then
				if HEX.MOD.GoalGold > 0 && self:GetNWInt("Gold") >= HEX.MOD.GoalGold then
					HEX.EndRound(1,0)
				end
			end
		end
	end
	function meta:SubtractGold(val)
		self:SetNWInt("Gold",self:GetNWInt("Gold")-val)
	end

	function meta:DropGoldOnDeath(forceall)
		local ratio = HEX.MOD.GoldDropRatio
		local remainder = math.Round(self:GetGold() * ratio)

		if self:GetGold() <= 25 then return end

        local ent = ents.Create( "ent_hex_golddrop" )
        ent:SetPos(self:GetPos()+Vector(0,0,32))
        ent:Spawn()
		local phys = ent:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:AddVelocity(VectorRand()*55)
		end

		if forceall == true then
			remainder = self:GetGold()-25
		end

        ent.Gold = remainder + 10
        self:SubtractGold(remainder)
        timer.Simple(1,function()
        	if IsValid(self) then
	        	HexMsg(self,"Death","You dropped "..remainder.." ("..string.sub(ratio,3,4).."%) of your total Gold!",Vector(215,185,115),false)
	        end
        end)
	end

	function meta:DropItemsOnDeath()
		local roll = math.random(1,100)
		if roll >= 75 && roll <= 100 then
	        local ent = ents.Create( "ent_hex_healthdrop" )
	        ent:SetPos(self:GetPos()+Vector(0,0,32))
	        ent:Spawn()
			local phys = ent:GetPhysicsObject()
			if ( IsValid( phys ) ) then
				phys:AddVelocity(VectorRand()*200)
			end
		end
		if roll >= 25 && roll <= 80 then
	        local ent2 = ents.Create( "ent_hex_manadrop" )
	        ent2:SetPos(self:GetPos()+Vector(0,0,32))
	        ent2:Spawn()
			local phys2 = ent2:GetPhysicsObject()
			if ( IsValid( phys2 ) ) then
				phys2:AddVelocity(VectorRand()*200)
			end
		end
	end

	hook.Add("KeyPress","HEXDROPITEMKEYP",function(ply,key)
		if key == IN_RELOAD then
			if ply.DropDelay && ply.DropDelay < CurTime() then
				ply:DropItem()
				ply.DropDelay = CurTime() + 1
			else
				ply.DropDelay = 0
			end
		end
	end)

	function meta:DropItem()
		if self:GetCurrentItem() == "none" then return end
        local item = ents.Create("ent_hex_pickupitem")
        item:SetPos(self:GetPos())
        item:SetAngles(Angle(0,0,1))
        item:Spawn()

        item:SetItemInfo(self:GetCurrentItem())
		self:EmitSound("wc3sound/CratePickup.wav")
       	self:SetCurrentItem("none")
       	self:SetMainItem("none")
	end

	hook.Add("KeyPress","HEXDROPWEPKEYP",function(ply,key)
		if key == IN_RELOAD then
			if ply:GetCurrentItem() == "none" then
				if ply.DropDelay && ply.DropDelay < CurTime() then
					ply:DropWeapon()
					ply.DropDelay = CurTime() + 1
				else
					ply.DropDelay = 0
				end
			end
		end
	end)

	function meta:DropWeapon()
		if self:GetCurrentWeapon() == "none" then return end
        local item = ents.Create("ent_hex_pickupweapon")
        item:SetPos(self:GetPos())
        item:SetAngles(Angle(0,0,1))
        item:Spawn()

        item:SetItemInfo(self:GetCurrentWeapon())

		self:EmitSound("wc3sound/CratePickup.wav")

		self:StripWeapons()
       	self:SetCurrentWeapon("none")
	end

	function meta:NetworkCrests()
		for k, v in pairs(ents.GetAll()) do
			if v.Crest == true then
				v:SetNWBool("CrestActive",v:GetNWBool("CrestActive"))
			end
		end
	end

	net.Receive("playermodelsend",function(len,pl)
		if (IsValid(pl) and pl:IsPlayer()) then
			local name = net.ReadString()
			local model = net.ReadString()

			HexMsg(pl,"Appearance", "You'll respawn as "..name..".",Vector(155,155,155),false)

			pl:SetNWString("SelectedModel",model)
		end
	end)

	net.Receive("playertitlesend",function(len,pl)
		if (IsValid(pl) and pl:IsPlayer()) then
			local title = net.ReadInt(10)
			pl:SetPlayerTitle(title)
		end
	end)

	net.Receive("loadoutsend", function(len,pl)
		if (IsValid(pl) and pl:IsPlayer()) then
			local selection = net.ReadString()
			local selecttype = net.ReadString()

			if selecttype == "weapon" then
				local function MatchWeptoTable(w,t)
					local name = "none"
					local price = 0
					for a, b in pairs(HEX.WeaponTable) do
						if w == b.wep then
							if t == "name" then
								if b.name != nil then
									name = b.name
								end
								return name
							end
							if t == "price" then
								if b.price != nil then
									price = b.price
								end
								return price
							end
						end
					end
				end

				if selection == pl:GetNWString("MainWeapon") then
					--HexMsg(pl, "Market", "You already have this weapon.", Vector(155,155,155), false)
					HEX.SendNotification(pl,Color(155,155,155),255,"You already have this weapon.",false)
			
					HexSound(pl, "wc3sound/error.wav", false)
					return
				end

				if MatchWeptoTable(selection,"price") > pl:GetGold() then
					--HexMsg(pl, "Market", "Not enough gold.", Vector(215,155,155), false)
					HEX.SendNotification(pl,Color(215,155,155),255,"Not enough gold.",false)

					HexSound(pl, "wc3sound/error.wav", false)
					return
				end

				if MatchWeptoTable(selection,"price") <= pl:GetGold() then
					-- Do Refund for current Main Weapon
					if pl:GetNWString("MainWeapon") != "none" then
						pl:AddGold( math.Round( MatchWeptoTable( pl:GetNWString("MainWeapon"),"price") / 3 ) )
						--HexMsg(pl, "Market", MatchWeptoTable( pl:GetNWString("MainWeapon"),"name").." refunded for " .. math.Round( MatchWeptoTable( pl:GetNWString("MainWeapon"),"price") / 3 ) .. " Gold.", Vector(255,215,155), false)
						HEX.SendNotification(pl,Color(255,215,155),255,MatchWeptoTable(pl:GetNWString("MainWeapon"),"name").." refunded for "..math.Round(MatchWeptoTable(pl:GetNWString("MainWeapon"),"price")/3).." Gold.",false)
					end
					-- Apply Main Weapon
					pl:SetNWString("MainWeapon",selection)
					pl:SubtractGold(MatchWeptoTable(selection,"price"))
					--HexMsg(pl, "Market", MatchWeptoTable(selection,"name").." purchased for " .. MatchWeptoTable(selection,"price") .. " Gold.", Vector(185,255,155), false)
					HEX.SendNotification(pl,Color(185,255,155),255,MatchWeptoTable(selection,"name").." purchased for "..MatchWeptoTable(selection,"price").." Gold.",false)
					
					HexSound(pl, "wc3sound/exp/ItemReceived.wav", false)
				end
			end

			if selecttype == "item" then
				local function MatchItemtoTable(w,t)
					local name = "none"
					local price = 0
					for a, b in pairs(HEX.ItemTable) do
						if w == b.id then
							if t == "name" then
								if b.name != nil then
									name = b.name
								end
								return name
							end
							if t == "price" then
								if b.price != nil then
									price = b.price
								end
								return price
							end
						end
					end
				end

				if selection == pl:GetNWString("MainItem") then
					--HexMsg(pl, "Market", "You already have this item.", Vector(155,155,155), false)
					HEX.SendNotification(pl,Color(155,155,155),255,"You already have this item.",false)

					HexSound(pl, "wc3sound/error.wav", false)
					return
				end

				if MatchItemtoTable(selection,"price") > pl:GetGold() then
					--HexMsg(pl, "Market", "Not enough gold.", Vector(215,155,155), false)
					HEX.SendNotification(pl,Color(215,155,155),255,"Not enough gold.",false)

					HexSound(pl, "wc3sound/error.wav", false)
					return
				end

				if MatchItemtoTable(selection,"price") <= pl:GetGold() then
					-- Do Refund for current Main Weapon
					if pl:GetNWString("MainItem") != "none" then
						pl:AddGold( math.Round( MatchItemtoTable( pl:GetNWString("MainItem"),"price") / 3 ) )
						--HexMsg(pl, "Market", MatchItemtoTable( pl:GetNWString("MainItem"),"name").." refunded for " .. math.Round( MatchItemtoTable( pl:GetNWString("MainItem"),"price") / 3 ) .. " Gold.", Vector(255,215,155), false)
						HEX.SendNotification(pl,Color(255,215,155),255,MatchItemtoTable( pl:GetNWString("MainItem"),"name").." refunded for " .. math.Round( MatchItemtoTable( pl:GetNWString("MainItem"),"price") / 3 ) .. " Gold.",false)

					end
					-- Apply Main Weapon
					pl:SetNWString("MainItem",selection)
					pl:SubtractGold(MatchItemtoTable(selection,"price"))
					--HexMsg(pl, "Market", MatchItemtoTable(selection,"name").." purchased for " .. MatchItemtoTable(selection,"price") .. " Gold.", Vector(185,255,155), false)
					HEX.SendNotification(pl,Color(185,255,155),255,MatchItemtoTable(selection,"name").." purchased for " .. MatchItemtoTable(selection,"price") .. " Gold.",false)

					HexSound(pl, "wc3sound/exp/ItemReceived.wav", false)
				end
			end
		end
	end )
end