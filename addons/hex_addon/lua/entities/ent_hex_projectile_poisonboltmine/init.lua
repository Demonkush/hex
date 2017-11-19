AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/Gibs/HGIBS.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetColor(Color(255,255,255,0))
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetGravity(0.2)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	
	if SERVER then
		util.SpriteTrail(self.Entity, 0, Color(155,255,115,55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
	end

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end
	end

	timer.Simple(3,function()
		if IsValid(self) then
			self:ExplodeNormal()
		end
	end)

	self.ToggleGas = false

	self:SetNWString("ProjectilePower","normal")
end

function ENT:SetPower(output)
	self:SetNWString("ProjectilePower",output)
end
function ENT:GetPower()
	return self:GetNWString("ProjectilePower")
end

function ENT:ExplodeLow()
	self:DoFX("low")
	self.Entity:EmitSound("wc3sound/exp/ChimaeraAlternateMissileHit2.wav",75,math.random(115,125))
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),95)) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(math.random(6,11))
			dmginfo:SetDamageElement("poison")
			v:TakeDamageInfo(dmginfo)
			local r = math.random(1,50)
			if r > 25 then
				if v:IsPlayer() then
					v:BuffSlow(self:GetOwner(),5)
				end
			end
		end
	end
	timer.Simple(0,function() self:Remove() end)
end
function ENT:ExplodeNormal()
	self:DoFX("normal")
	self.Entity:EmitSound("wc3sound/exp/ChimaeraAlternateMissileHit2.wav",75,math.random(95,105))
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),125)) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(math.random(8,14))
			dmginfo:SetDamageElement("poison")
			v:TakeDamageInfo(dmginfo)
			local r = math.random(1,50)
			if r > 25 then
				if v:IsPlayer() then
					v:BuffSlow(self:GetOwner(),5)
					v:BuffPoison(self:GetOwner(),2,5)
				end
			end
		end
	end
	timer.Simple(0,function() self:Remove() end)
end
function ENT:ExplodeHigh()
	self:DoFX("high")
	self.Entity:EmitSound("wc3sound/exp/ChimaeraAlternateMissileHit2.wav",75,math.random(75,85))
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),145)) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(math.random(11,16))
			dmginfo:SetDamageElement("poison")
			v:TakeDamageInfo(dmginfo)
			local r = math.random(1,25)
			if r > 10 then
				if v:IsPlayer() then
					v:BuffSlow(self:GetOwner(),5)
					v:BuffPoison(self:GetOwner(),2,5)
				end
			end
		end
	end
	if self.ToggleGas == true then
		local proj = ents.Create("ent_hex_point_poisongas")
		proj:SetPos(self:GetPos())
		proj:SetOwner(self:GetOwner())
		proj:Spawn()	

		proj:Explode(5)
	end
	timer.Simple(0,function() self:Remove() end)
end

function ENT:DoFX(power)
	if power == "low" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(0.5)	
		util.Effect("fx_hex_poisonblast01",fx)
	elseif power == "normal" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(1.5)	
		util.Effect("fx_hex_poisonblast01",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(1)	
		fx2:SetAngles(Angle(155,215,115))
		util.Effect("fx_hex_model_blast",fx2)
	elseif power == "high" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(2)	
		util.Effect("fx_hex_poisonblast01",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(1.5)
		fx2:SetAngles(Angle(155,215,115))
		util.Effect("fx_hex_model_blast",fx2)
	end
end

function ENT:PhysicsCollide(data,phys)
	timer.Simple(2,function()
		if self:GetPower() == "low" then
			self:ExplodeLow()
		elseif self:GetPower() == "normal" then
			self:ExplodeNormal()
		elseif self:GetPower() == "high" then
			self:ExplodeHigh()
		end
	end)
	if IsValid(self:GetParent()) then return end
	if data.HitEntity then
		ent = data.HitEntity
		if ent:IsWorld() then
			self:SetMoveType(MOVETYPE_NONE)
			self:SetPos(data.HitPos - data.HitNormal * 1.2)
			flip = 1
			if data.HitNormal.y > 0 then
				flip = -1
			end
			self:SetAngles(Angle(0,data.HitNormal.y + data.HitNormal.x,-data.HitNormal.z * flip) * 90)
		elseif ent:IsPlayer() and !ent:IsWeapon() then
			self:SetPos(data.HitPos - data.HitNormal )
			flip = 1
			if data.HitNormal.y > 0 then
				flip = -1
			end
			self:SetAngles(Angle(0,data.HitNormal.y + data.HitNormal.x,-data.HitNormal.z * flip) * 90)
			self:SetSolid( SOLID_NONE )
			self:SetParent(ent)
		end
	end
end

function ENT:OnRemove()
end