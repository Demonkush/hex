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
		util.SpriteTrail(self.Entity, 0, Color(255,155,55,55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
	end

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end
	end

	timer.Simple(10,function()
		if IsValid(self) then
			self:Remove()
		end
	end)

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
	self.Entity:EmitSound("wc3sound/exp/FireBallMissileDeath.wav",75,math.random(125,130))
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),75)) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(math.random(10,15))
			dmginfo:SetDamageElement("fire")
			v:TakeDamageInfo(dmginfo)
		end
	end
	self:Remove()
end
function ENT:ExplodeNormal()
	self:DoFX("normal")
	self.Entity:EmitSound("wc3sound/exp/FireBallMissileDeath.wav",75,math.random(115,120))
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),125)) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(math.random(15,18))
			dmginfo:SetDamageElement("fire")
			v:TakeDamageInfo(dmginfo)
		end
	end
	self:Remove()
end
function ENT:ExplodeHigh()
	self:DoFX("high")
	self.Entity:EmitSound("wc3sound/exp/FireBallMissileDeath.wav",75,math.random(110,115))
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),145)) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(math.random(17,22))
			dmginfo:SetDamageElement("fire")
			v:TakeDamageInfo(dmginfo)
		end
	end
	self:Remove()
end

function ENT:DoFX(power)
	if power == "low" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(0.5)	
		util.Effect("fx_hex_fireblast01",fx)
	elseif power == "normal" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(1.5)	
		util.Effect("fx_hex_fireblast01",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(1)	
		fx2:SetAngles(Angle(215,115,55))
		util.Effect("fx_hex_model_blast",fx2)
	elseif power == "high" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(2)	
		util.Effect("fx_hex_fireblast01",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(1.5)
		fx2:SetAngles(Angle(215,115,55))
		util.Effect("fx_hex_model_blast",fx2)
	end
end

function ENT:PhysicsCollide(data,phys)
	if self:GetPower() == "low" then
		self:ExplodeLow()
	elseif self:GetPower() == "normal" then
		self:ExplodeNormal()
	elseif self:GetPower() == "high" then
		self:ExplodeHigh()
	end
end

function ENT:OnRemove()
end