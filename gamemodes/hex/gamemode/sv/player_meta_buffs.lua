-- META FUNCTIONS --
local meta = FindMetaTable( "Player" )

if SERVER then
	function meta:TakeAllBuffs()
		self:BuffSlow(self,5,5)
		self:BuffStun(self,3)
		self:BuffFreeze(self,4)
		self:BuffManaDrain(self,1,5,2)
		self:BuffFire(self,1,5)
		self:BuffHeal(self,1,5,2)
		self:BuffIce(self,2,6)
		self:BuffPoison(self,3,7)
		self:BuffSoaked(self,6)		
		self:BuffBleed(self,2,10)
		self:BuffAttackSpeed(self,5)
		self:BuffDamageResist(self,5,5)
	end

	function meta:TakeThornsDamage(att,dmg)
		if !self:Alive() then return end
		if self == att then return end
		local chance = math.random(1,10)
		if chance > 5 then
			local thornsdmg = DamageInfo()
			thornsdmg:SetAttacker( att )
			thornsdmg:SetInflictor( att )
			thornsdmg:SetDamage( dmg )
			thornsdmg:SetDamageElement("nature")
			self:TakeDamageInfo( thornsdmg )
		end
	end

	function meta:BuffOverpowered(att,time)
		if !self:Alive() then return end
		if HEX.MOD.ToggleOverpower == false then return end
		local id = "hex_overpowered"..self:UniqueID()
		HEX.SendNotification(self,Color(215,215,215),255,"Overpowered for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(215,215,215),"Overpowered") end
		self:SetNWInt("Overpowered",1)
		if timer.Exists(id) then timer.Remove(id) end
		timer.Create(id,time,1,function() self:SetNWInt("Overpowered",0) end)
	end

	function meta:BuffMagesoul(att,time)
		if !self:Alive() then return end
		if HEX.MOD.ToggleMagesoul == false then return end
		local id = "hex_magesoul"..self:UniqueID()
		HEX.SendNotification(self,Color(215,215,215),255,"Magesoul buff for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(215,215,215),"Magesoul") end
		self:SetNWInt("Magesoul",1)
		if timer.Exists(id) then timer.Remove(id) end
		timer.Create(id,time,1,function() self:SetNWInt("Magesoul",0) end)
	end

	function meta:BuffEnraged(att,time)
		if !self:Alive() then return end
		if self:GetNWInt("Enraged") == 1 then return end
		local id = "hex_enraged"..self:UniqueID()
		HEX.SendNotification(self,Color(255,155,115),255,"Enraged for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(255,155,115),"Enraged") end
		local chance = math.random(1,100)
		if chance >= 75 then self:BuffOverpowered(att,10) end
		if chance <= 25 then self:BuffMagesoul(att,10) end
		self:BuffDamageResist(att,10,5)
		self:SetNWInt("Enraged",1)
		if timer.Exists(id) then timer.Remove(id) end
		timer.Create(id,time,1,function() self:SetNWInt("Enraged",0) end)
	end

	function meta:BuffFire(att,time,charges)
		if !self:Alive() then return end
		if self == att then return end
		if HEX.Teamplay == true then if att:Team() == self:Team() then return end end
		if self:GetNWInt("Burning") == 1 then return end
		-- Chance to resist burning
		if self:GetCurrentItem() == "hellstone" then
			local c = math.random(1,10)
			if c > 7 then return end
		end
		local id = "hex_buff_fire"..tostring(self)
		HEX.SendNotification(self,Color(185,135,115),255,"Burning for "..time+charges.." seconds!",false)
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(255,155,55),"Burning") end
		if timer.Exists(id) then timer.Destroy(id)
			self:DoFireBuff(id,att,time,charges+1)
		else
			self:DoFireBuff(id,att,time,charges)
		end
		self:SetNWInt("Burning",1)
		local id2 = "hex_buff_firestatus"..tostring(self)
		timer.Create(id2,time*charges,1,function() self:SetNWInt("Burning",0) end)
	end
	function meta:DoFireBuff(id,att,time,charges)
		timer.Create(id,time,charges,function()
			if IsValid(self) && self:Alive() then
				local firedmg = DamageInfo()
				firedmg:SetAttacker(att)
				firedmg:SetInflictor(att)
				firedmg:SetDamage(math.random(1,3))
				firedmg:SetDamageElement("fire")
				self:TakeDamageInfo(firedmg)
				local fx = EffectData() fx:SetOrigin(self:GetPos()+Vector(0,0,32))
				util.Effect("fx_hex_dmgfire",fx)
			else timer.Destroy(id) end
		end)
	end

	function meta:BuffPoison(att,time,charges)
		if !self:Alive() then return end
		if self == att then return end
		if HEX.Teamplay == true then if att:Team() == self:Team() then return end end
		if self:GetNWInt("Poisoned") == 1 then return end
		-- Chance to resist poison
		if self:GetCurrentItem() == "darkseed" then
			local c = math.random(1,10)
			if c > 7 then return end
		end
		local id = "hex_buff_poison"..tostring(self)
		HEX.SendNotification(self,Color(145,215,115),255,"Poisoned for "..time+charges.." seconds!",false)
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(145,215,115),"Poisoned") end
		if timer.Exists(id) then timer.Destroy(id)
			self:DoPoisonBuff(id,att,time,charges+1)
		else
			self:DoPoisonBuff(id,att,time,charges)
		end
		self:SetNWInt("Poisoned",1)
		local id2 = "hex_buff_poisonstatus"..tostring(self)
		timer.Create(id2,time*charges,1,function() self:SetNWInt("Poisoned",0) end)
	end
	function meta:DoPoisonBuff(id,att,time,charges)
		timer.Create(id,time,charges,function()
			if IsValid(self) && self:Alive() then
				local poisondmg = DamageInfo()
				poisondmg:SetAttacker(att)
				poisondmg:SetInflictor(att)
				poisondmg:SetDamage(math.random(1,2))
				poisondmg:SetDamageElement("poison")
				self:TakeDamageInfo(poisondmg)
				local fx = EffectData() fx:SetOrigin(self:GetPos()+Vector(0,0,32))
				util.Effect("fx_hex_dmgpoison",fx)
			else timer.Destroy(id) end
		end)
	end

	function meta:BuffBleed(att,time,charges)
		if !self:Alive() then return end
		if self == att then return end
		if HEX.Teamplay == true then if att:Team() == self:Team() then return end end
		if self:GetNWInt("Bleeding") == 1 then return end
		local id = "hex_buff_bleed"..tostring(self)
		HEX.SendNotification(self,Color(215,115,115),255,"Bleeding for "..time+charges.." seconds!",false)
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(215,115,115),"Bleeding") end
		if timer.Exists(id) then timer.Destroy(id)
			self:DoBleedBuff(id,att,time,charges+1)
		else
			self:DoBleedBuff(id,att,time,charges)
		end
		self:SetNWInt("Bleeding",1)
		local id2 = "hex_buff_bleedstatus"..tostring(self)
		timer.Create(id2,time*charges,1,function() self:SetNWInt("Bleeding",0) end)
	end
	function meta:DoBleedBuff(id,att,time,charges)
		timer.Create(id,time,charges,function()
			if IsValid(self) && self:Alive() then
				local bleeddmg = DamageInfo()
				bleeddmg:SetAttacker(att)
				bleeddmg:SetInflictor(att)
				bleeddmg:SetDamage(math.random(2,3))
				bleeddmg:SetDamageElement("bleed")
				self:TakeDamageInfo(bleeddmg)
				local fx = EffectData() fx:SetOrigin(self:GetPos()+Vector(0,0,32))
				util.Effect("fx_hex_dmgblood",fx)
			else timer.Destroy(id) end
		end)
	end

	function meta:BuffManaDrain(att,time,charges,drain)
		if !self:Alive() then return end
		if self == att then return end
		if HEX.Teamplay == true then if att:Team() == self:Team() then return end end
		if self:GetNWInt("Draining") == 1 then return end
		local id = "hex_buff_manadrain"..tostring(self)
		HEX.SendNotification(self,Color(115,115,255),255,"Mana Drain for "..time+charges.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(155,155,255),"Mana Drain") end
		if timer.Exists(id) then timer.Destroy(id)
			self:DoManaDrainBuff(id,att,time,charges+1,drain)
		else
			self:DoManaDrainBuff(id,att,time,charges,drain)
		end
		self:SetNWInt("Draining",1)
		local id2 = "hex_buff_drainstatus"..tostring(self)
		timer.Create(id2,time*charges,1,function() self:SetNWInt("Draining",0) end)
	end
	function meta:DoManaDrainBuff(id,att,time,charges,drain)
		timer.Create(id,time,charges,function()
			if IsValid(self) && self:Alive() then
				self:SubtractMana(drain)
				local fx = EffectData() fx:SetOrigin(self:GetPos()+Vector(0,0,32))
				util.Effect("fx_hex_dmgmanadrain",fx)
			else timer.Destroy(id) end
		end)
	end


	function meta:BuffIce(att,time,charges)
		if !self:Alive() then return end
		if self == att then return end
		if HEX.Teamplay == true then if att:Team() == self:Team() then return end end
		if self:GetNWInt("Chilled") == 1 then return end
		-- Chance to resist ice buff
		if self:GetCurrentItem() == "starsapphire" then
			local c = math.random(1,10)
			if c > 7 then return end
		end
		local id = "hex_buff_ice"..tostring(self)
		HEX.SendNotification(self,Color(115,155,255),255,"Chilled for "..time+charges.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(115,155,215),"Chilled") end
		if timer.Exists(id) then timer.Destroy(id)
			self:DoIceBuff(id,att,time,charges+1)
		else
			self:DoIceBuff(id,att,time,charges)
		end
		self:SetNWInt("Chilled",1)
		local id2 = "hex_buff_icestatus"..tostring(self)
		timer.Create(id2,time*charges,1,function() self:SetNWInt("Chilled",0) end)
	end
	function meta:DoIceBuff(id,att,time,charges)
		timer.Create(id,time,charges,function()
			if IsValid(self) && self:Alive() then
				local icedmg = DamageInfo()
				icedmg:SetAttacker(att)
				icedmg:SetInflictor(att)
				icedmg:SetDamage(math.random(1,2))
				icedmg:SetDamageElement("frost")
				self:TakeDamageInfo(icedmg)
				local fx = EffectData() fx:SetOrigin(self:GetPos()+Vector(0,0,32))
				util.Effect("fx_hex_dmgice",fx)
			else timer.Destroy(id) end
		end)
	end

	function meta:BuffHeal(att,time,charges,healpower)
		if !self:Alive() then return end
		if self:GetNWInt("Healing") == 1 then return end
		if HEX.Teamplay == false then if att != self then return end end
		local id = "hex_buff_heal"..tostring(self)
		HEX.SendNotification(self,Color(255,125,125),255,"Healing for "..time+charges.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(255,125,125),"Healing") end
		if timer.Exists(id) then timer.Destroy(id)
			self:DoHealBuff(id,att,time,charges+1,healpower)
		else
			self:DoHealBuff(id,att,time,charges,healpower)
		end
		self:SetNWInt("Healing",1)
		local id2 = "hex_buff_healstatus"..tostring(self)
		timer.Create(id2,time*charges,1,function() self:SetNWInt("Healing",0) end)
	end
	function meta:DoHealBuff(id,att,time,charges,healpower)
		timer.Create(id,time,charges,function()
			if IsValid(self) && self:Alive() then
				self:AddHP(healpower)
				self:EmitSound("wc3sound/HealTarget.wav",75,75)
				local fx = EffectData() fx:SetOrigin(self:GetPos()+Vector(0,0,32))
				util.Effect("fx_hex_dmgheal",fx)
			else timer.Destroy(id) end
		end)
	end

	function meta:BuffManaHeal(att,time,charges,manapower)
		if !self:Alive() then return end
		if self:GetNWInt("ManaHealing") == 1 then return end
		if HEX.Teamplay == false then if att != self then return end end
		local id = "hex_buff_manaheal"..tostring(self)
		HEX.SendNotification(self,Color(255,125,125),255,"Mana Up +"..manapower.." for "..time+charges.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(155,165,255),"Mana Up") end
		if timer.Exists(id) then timer.Destroy(id)
			self:DoManaHealBuff(id,att,time,charges+1,manapower)
		else
			self:DoManaHealBuff(id,att,time,charges,manapower)
		end
		self:SetNWInt("ManaHealing",1)
		local id2 = "hex_buff_manahealstatus"..tostring(self)
		timer.Create(id2,time*charges,1,function() self:SetNWInt("ManaHealing",0) end)
	end
	function meta:DoManaHealBuff(id,att,time,charges,manapower)
		timer.Create(id,time,charges,function()
			if IsValid(self) && self:Alive() then
				self:AddMana(manapower)
				self:EmitSound("wc3sound/HealTarget.wav",75,75)
				local fx = EffectData() fx:SetOrigin(self:GetPos()+Vector(0,0,32))
				util.Effect("fx_hex_dmgheal",fx)
			else timer.Destroy(id) end
		end)
	end

	function meta:BuffFreeze(att,time)
		if !self:Alive() then return end
		if self == att then return end
		if HEX.Teamplay == true then if att:Team() == self:Team() then return end end
		if self:GetNWInt("Frozen") == 1 then return end
		-- Chance to resist freeze
		if self:GetCurrentItem() == "starsapphire" then
			local c = math.random(1,10)
			if c > 7 then return end
		end
		HEX.SendNotification(self,Color(155,215,255),255,"Frozen for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(155,215,255),"Frozen") end
		local fx = EffectData() fx:SetOrigin(self:GetPos())
		util.Effect("fx_hex_bufffreeze",fx)
		self:SetNWInt("Frozen",1)
		self:SetWalkSpeed(1) self:SetRunSpeed(1)
		self:SetCrouchedWalkSpeed(1) self:SetWalkSpeed(1) self:SetJumpPower(1)
		self:GetActiveWeapon():SetNextPrimaryFire(CurTime()+(time)) self:GetActiveWeapon():SetNextSecondaryFire(CurTime()+(time))
		local id = "hex_freeze"..tostring(self)
		timer.Create(id,time,1,function()
			self:SetNWInt("Frozen",0)
			if self:GetNWInt("Stunned") == 1 then return end
			self:ResetMovementMod(false)
		end)
	end

	function meta:BuffSlow(att,time,power)
		if !self:Alive() then return end
		if self == att then return end
		if HEX.Teamplay == true then if att:Team() == self:Team() then return end end
		if self:GetNWInt("Slowed") == 1 then return end
		if self:GetNWInt("Frozen") == 1 then return end
		if self:GetNWInt("Stunned") == 1 then return end
		HEX.SendNotification(self,Color(155,215,155),255,"Slowed for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(185,215,155),"Slowed") end
		self:SetNWInt("Slowed",1)
		self:SetMovementMod(2,power,false)
		local id = "hex_slow"..tostring(self)
		timer.Create(id,time,1,function()
			self:SetNWInt("Slowed",0)
			if self:GetNWInt("Frozen") == 1 then return end
			if self:GetNWInt("Stunned") == 1 then return end
			self:ResetMovementMod(false)
		end)
	end

	function meta:BuffMoveSpeedUp(att,time,power)
		if !self:Alive() then return end
		if self:GetNWInt("Slowed") == 1 then return end
		if self:GetNWInt("Frozen") == 1 then return end
		if self:GetNWInt("Stunned") == 1 then return end
		HEX.SendNotification(self,Color(155,215,155),255,"Haste for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(255,225,155),"Haste") end
		self:SetNWInt("MoveSpeedUp",1)
		self:SetMovementMod(1,power,false)
		local id = "hex_movespeedup"..tostring(self)
		timer.Create(id,time,1,function()
			self:SetNWInt("MoveSpeedUp",0)
			if self:GetNWInt("Slowed") == 1 then return end
			if self:GetNWInt("Frozen") == 1 then return end
			if self:GetNWInt("Stunned") == 1 then return end
			self:ResetMovementMod(false)
		end)
	end

	function meta:BuffStun(att,time)
		if !self:Alive() then return end
		if self == att then return end
		if HEX.Teamplay == true then if att:Team() == self:Team() then return end end
		if self:GetNWInt("Stunned") == 1 then return end
		HEX.SendNotification(self,Color(155,185,115),255,"Stunned for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(155,185,115),"Stunned") end
		local fx = EffectData() fx:SetOrigin(self:GetPos()) util.Effect("fx_hex_buffstun",fx)
		self:SetNWInt("Stunned",1)
		self:SetWalkSpeed(1) self:SetRunSpeed(1)
		self:SetCrouchedWalkSpeed(1) self:SetWalkSpeed(1) self:SetJumpPower(1)
		self:GetActiveWeapon():SetNextPrimaryFire(CurTime()+(time))
		self:GetActiveWeapon():SetNextSecondaryFire(CurTime()+(time))
		local id = "hex_stun"..tostring(self)
		timer.Create(id,time,1,function()
			self:SetNWInt("Stunned",0)
			if self:GetNWInt("Frozen") == 1 then return end
			self:ResetMovementMod(false)
		end)
	end

	function meta:BuffSoaked(att,time)
		if !self:Alive() then return end
		if self == att then return end
		if HEX.Teamplay == true then if att:Team() == self:Team() then return end end
		if self:GetNWInt("Soaked") == 1 then return end
		HEX.SendNotification(self,Color(155,155,215),255,"Soaked for "..time.." seconds!",false)			 
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(155,155,215),"Soaked") end
		local fx = EffectData() fx:SetOrigin(self:GetPos())
		util.Effect("fx_hex_buffstun",fx)
		self:SetNWInt("Soaked",1)
		local id = "hex_soaked"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("Soaked",0) end)
	end

	function meta:BuffAttackSpeed(att,time)
		if !self:Alive() then return end
		if self:GetNWInt("AtkSpdUp") == 1 then return end
		HEX.SendNotification(self,Color(255,215,215),255,"Attack Speed Up for "..time.." seconds!",false)		
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(255,215,155),"Atk Spd +") end
		self:SetNWInt("AtkSpdUp",1)
		self:GetActiveWeapon().Primary.AtkSpdMod = 0.75 self:GetActiveWeapon().Secondary.AtkSpdMod = 0.75
		local id = "hex_atkspdup"..tostring(self)
		timer.Create(id,time,1,function()
			if !self:Alive() then return end
			self:SetNWInt("AtkSpdUp",0)
			self:GetActiveWeapon().Primary.AtkSpdMod = 1 self:GetActiveWeapon().Secondary.AtkSpdMod = 1
		end)
	end

	function meta:BuffDamageResist(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(255,215,155),255,"Damage Resist +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(255,215,155),"Damage Resist +"..power) end			
		self:SetNWInt("DamageResist",self:GetNWInt("DamageResist")+power)
		local id = "hex_damageresist"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("DamageResist",self:GetNWInt("BaseDamageResist")) end)
	end

	function meta:BuffFireResist(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(255,155,55),255,"Fire Resist +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(255,155,55),"Fire Resist +"..power) end			
		self:SetNWInt("FireResist",self:GetNWInt("FireResist")+power)
		local id = "hex_fireresist"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("FireResist",self:GetNWInt("BaseFireResist")) end)
	end

	function meta:BuffFrostResist(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(125,185,255),255,"Frost Resist +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(125,185,255),"Frost Resist +"..power) end		
		self:SetNWInt("FrostResist",self:GetNWInt("FrostResist")+power)
		local id = "hex_frostresist"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("FrostResist",self:GetNWInt("BaseFrostResist")) end)
	end

	function meta:BuffMagicResist(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(215,155,255),255,"Magic Resist +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(215,155,255),"Magic Resist +"..power) end	
		self:SetNWInt("MagicResist",self:GetNWInt("MagicResist")+power)
		local id = "hex_magicresist"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("MagicResist",self:GetNWInt("BaseMagicResist")) end)
	end

	function meta:BuffPoisonResist(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(215,255,155),255,"Poison Resist +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(215,255,155),"Poison Resist +"..power) end		
		self:SetNWInt("PoisonResist",self:GetNWInt("PoisonResist")+power)
		local id = "hex_poisonresist"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("PoisonResist",self:GetNWInt("BasePoisonResist")) end)
	end

	function meta:BuffStormResist(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(185,215,255),255,"Storm Resist +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(185,215,255),"Storm Resist +"..power) end		
		self:SetNWInt("StormResist",self:GetNWInt("StormResist")+power)
		local id = "hex_stormresist"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("StormResist",self:GetNWInt("BaseStormResist")) end)
	end

	function meta:BuffFireDamageBoost(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(255,155,55),255,"Fire Damage +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(255,155,55),"Fire Damage +"..power) end		
		self:SetNWInt("FireDamage",self:GetNWInt("FireDamage")+power)
		local id = "hex_firedamageboost"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("FireDamage",self:GetNWInt("BaseFireDamage")) end)
	end

	function meta:BuffFrostDamageBoost(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(125,185,255),255,"Frost Damage +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(125,185,255),"Frost Damage +"..power) end			
		self:SetNWInt("FrostDamage",self:GetNWInt("FrostDamage")+power)
		local id = "hex_frostdamageboost"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("FrostDamage",self:GetNWInt("BaseFrostDamage")) end)
	end

	function meta:BuffMagicDamageBoost(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(215,155,255),255,"Magic Damage +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(215,155,255),"Magic Damage +"..power) end			
		self:SetNWInt("MagicDamage",self:GetNWInt("MagicDamage")+power)
		local id = "hex_magicdamageboost"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("MagicDamage",self:GetNWInt("BaseMagicDamage")) end)
	end

	function meta:BuffPoisonDamageBoost(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(215,255,155),255,"Poison Damage +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(215,255,155),"Poison Damage +"..power) end		
		self:SetNWInt("PoisonDamage",self:GetNWInt("PoisonDamage")+power)
		local id = "hex_poisondamageboost"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("PoisonDamage",self:GetNWInt("BasePoisonDamage")) end)
	end

	function meta:BuffStormDamageBoost(att,time,power)
		if !self:Alive() then return end
		HEX.SendNotification(self,Color(185,215,255),255,"Storm Damage +"..power.." for "..time.." seconds!",false)			
		if att:IsPlayer() then att:SendFloatingDmg(1,1,self:GetPos(),false,false,Vector(185,215,255),"Storm Damage +"..power) end	
		self:SetNWInt("StormDamage",self:GetNWInt("StormDamage")+power)
		local id = "hex_stormdamageboost"..tostring(self)
		timer.Create(id,time,1,function() self:SetNWInt("StormDamage",self:GetNWInt("BaseStormDamage")) end)
	end

	function meta:AbolishBuffs(a)
		if a == "fire" or a == "all" or a == "negative" then
			self:SetNWInt("Burning",0)
			if timer.Exists("hex_buff_fire"..tostring(self)) then timer.Destroy("hex_buff_fire"..tostring(self)) end
		end
		if a == "ice" or a == "all" or a == "negative" then
			self:SetNWInt("Chilled",0)
			if timer.Exists("hex_buff_ice"..tostring(self)) then timer.Destroy("hex_buff_ice"..tostring(self)) end
		end
		if a == "poison" or a == "all" or a == "negative" then
			self:SetNWInt("Poisoned",0)
			if timer.Exists("hex_buff_poison"..tostring(self)) then timer.Destroy("hex_buff_poison"..tostring(self)) end
		end
		if a == "bleed" or a == "all" or a == "negative" then
			self:SetNWInt("Bleeding",0)
			if timer.Exists("hex_buff_bleed"..tostring(self)) then timer.Destroy("hex_buff_bleed"..tostring(self)) end
		end
		if a == "heal" or a == "all" then
			self:SetNWInt("Healing",0)
			if timer.Exists("hex_buff_heal"..tostring(self)) then timer.Destroy("hex_buff_heal"..tostring(self)) end
		end
		if a == "manaheal" or a == "all" then
			self:SetNWInt("ManaHealing",0)
			if timer.Exists("hex_buff_manaheal"..tostring(self)) then timer.Destroy("hex_buff_manaheal"..tostring(self)) end
		end
		if a == "manadrain" or a == "all" or a == "negative" then
			self:SetNWInt("Draining",0)
			if timer.Exists("hex_buff_manadrain"..tostring(self)) then timer.Destroy("hex_buff_manadrain"..tostring(self)) end
		end
		if a == "slow" or a == "all" or a == "negative" then
			self:SetNWInt("Slowed",0)
			self:ResetMovementMod(false)
			if timer.Exists("hex_buff_slow"..tostring(self)) then timer.Destroy("hex_buff_slow"..tostring(self)) end
		end
		if a == "freeze" or a == "all" or a == "negative" then
			self:SetNWInt("Frozen",0)
			self:ResetMovementMod(false)
			if timer.Exists("hex_freeze"..tostring(self)) then timer.Destroy("hex_freeze"..tostring(self)) end
		end
		if a == "stun" or a == "all" or a == "negative" then
			self:SetNWInt("Stunned",0)
			self:ResetMovementMod(false)
			if timer.Exists("hex_stun"..tostring(self)) then timer.Destroy("hex_stun"..tostring(self)) end
		end
		if a == "water" or a == "all" or a == "negative" then
			self:SetNWInt("Soaked",0)
			if timer.Exists("hex_soaked"..tostring(self)) then timer.Destroy("hex_soaked"..tostring(self)) end
		end
		if a == "atkspdup" or a == "all" then
			self:SetNWInt("AtkSpdUp",0)
			if IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon().Primary.AtkSpdMod = 1
				self:GetActiveWeapon().Secondary.AtkSpdMod = 1
			end
			if timer.Exists("hex_atkspdup"..tostring(self)) then timer.Destroy("hex_atkspdup"..tostring(self)) end
		end
		if a == "damageresist" or a == "resist" or a == "all" then
			self:SetNWInt("DamageResist",self:GetNWInt("BaseDamageResist"))
			if timer.Exists("hex_damageresist"..tostring(self)) then timer.Destroy("hex_damageresist"..tostring(self)) end
		end
		if a == "fireresist" or a == "resist" or a == "all" then
			self:SetNWInt("FireResist",self:GetNWInt("BaseFireResist"))
			if timer.Exists("hex_fireresist"..tostring(self)) then timer.Destroy("hex_fireresist"..tostring(self)) end
		end
		if a == "frostresist" or a == "resist" or a == "all" then
			self:SetNWInt("FrostResist",self:GetNWInt("BaseFrostResist"))
			if timer.Exists("hex_frostresist"..tostring(self)) then timer.Destroy("hex_frostresist"..tostring(self)) end
		end
		if a == "magicresist" or a == "resist" or a == "all" then
			self:SetNWInt("MagicResist",self:GetNWInt("BaseMagicResist"))
			if timer.Exists("hex_magicresist"..tostring(self)) then timer.Destroy("hex_magicresist"..tostring(self)) end
		end
		if a == "poisonresist" or a == "resist" or a == "all" then
			self:SetNWInt("PoisonResist",self:GetNWInt("BasePoisonResist"))
			if timer.Exists("hex_poisonresist"..tostring(self)) then timer.Destroy("hex_poisonresist"..tostring(self)) end
		end
		if a == "stormresist" or a == "resist" or a == "all" then
			self:SetNWInt("StormResist",self:GetNWInt("BaseStormResist"))
			if timer.Exists("hex_stormresist"..tostring(self)) then timer.Destroy("hex_stormresist"..tostring(self)) end
		end
		if a == "firedamageboost" or a == "damageboost" or a == "all" then
			self:SetNWInt("FireDamage",self:GetNWInt("BaseFireDamage"))
			if timer.Exists("hex_firedamageboost"..tostring(self)) then timer.Destroy("hex_firedamageboost"..tostring(self)) end
		end
		if a == "frostdamageboost" or a == "damageboost" or a == "all" then
			self:SetNWInt("FrostDamage",self:GetNWInt("BaseFrostDamage"))
			if timer.Exists("hex_frostdamageboost"..tostring(self)) then timer.Destroy("hex_frostdamageboost"..tostring(self)) end
		end
		if a == "magicdamageboost" or a == "damageboost" or a == "all" then
			self:SetNWInt("MagicDamage",self:GetNWInt("BaseMagicDamage"))
			if timer.Exists("hex_magicdamageboost"..tostring(self)) then timer.Destroy("hex_magicdamageboost"..tostring(self)) end
		end
		if a == "poisondamageboost" or a == "damageboost" or a == "all" then
			self:SetNWInt("PoisonDamage",self:GetNWInt("BasePoisonDamage"))
			if timer.Exists("hex_poisondamageboost"..tostring(self)) then timer.Destroy("hex_poisondamageboost"..tostring(self)) end
		end
		if a == "stormdamageboost" or a == "damageboost" or a == "all" then
			self:SetNWInt("StormDamage",self:GetNWInt("BaseStormDamage"))
			if timer.Exists("hex_stormdamageboost"..tostring(self)) then timer.Destroy("hex_stormdamageboost"..tostring(self)) end
		end
		if a == "movespeedup" or a == "all" then
			self:SetNWInt("MoveSpeedUp",0)
			self:ResetMovementMod(false)
			if timer.Exists("hex_movespeedup"..tostring(self)) then timer.Destroy("hex_movespeedup"..tostring(self)) end
		end
		if a == "overpowered" or a =="all" then
			self:SetNWInt("Overpowered",0)
			if timer.Exists("hex_overpowered"..tostring(self)) then timer.Destroy("hex_overpowered"..tostring(self)) end
		end
		if a == "magesoul" or a =="all" then
			self:SetNWInt("Magesoul",0)
			if timer.Exists("hex_magesoul"..tostring(self)) then timer.Destroy("hex_magesoul"..tostring(self)) end
		end
		if a == "powerups" or a =="all" then
			self:SetNWInt("PowerupVampirism",0)
			self:SetNWInt("PowerupInferno",0)
			self:SetNWInt("PowerupFrostbite",0)
			self:SetNWInt("PowerupLife",0)
			self:SetNWInt("PowerupNature",0)
			self:SetNWInt("PowerupPoison",0)
			self:SetNWInt("PowerupShield",0)
			self:SetNWInt("PowerupStorm",0)
			if timer.Exists("hex_powerup_vamp"..tostring(self)) then timer.Destroy("hex_powerup_vamp"..tostring(self)) end
			if timer.Exists("hex_powerup_fire"..tostring(self)) then timer.Destroy("hex_powerup_fire"..tostring(self)) end
			if timer.Exists("hex_powerup_ice"..tostring(self)) then timer.Destroy("hex_powerup_ice"..tostring(self)) end
			if timer.Exists("hex_powerup_life"..tostring(self)) then timer.Destroy("hex_powerup_life"..tostring(self)) end
			if timer.Exists("hex_powerup_nature"..tostring(self)) then timer.Destroy("hex_powerup_nature"..tostring(self)) end
			if timer.Exists("hex_powerup_poison"..tostring(self)) then timer.Destroy("hex_powerup_poison"..tostring(self)) end
			if timer.Exists("hex_powerup_shield"..tostring(self)) then timer.Destroy("hex_powerup_shield"..tostring(self)) end
			if timer.Exists("hex_powerup_storm"..tostring(self)) then timer.Destroy("hex_powerup_storm"..tostring(self)) end
		end
	end
end