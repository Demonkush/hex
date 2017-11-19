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
		util.SpriteTrail(self.Entity, 0, Color(155,100,255,55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
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
	self.Entity:EmitSound( "blackpowder.Boom", 100, 85 )
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),115)) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(math.random(19,22))
			dmginfo:SetDamageElement("magic")
			v:TakeDamageInfo(dmginfo)
		end
	end
	timer.Simple(0,function() self:Remove() end)
end
function ENT:ExplodeNormal()
	self:DoFX("normal")
	self.Entity:EmitSound( "blackpowder.Boom", 100, 85 )
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),135)) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(math.random(23,26))
			dmginfo:SetDamageElement("magic")
			v:TakeDamageInfo(dmginfo)
		end
	end
	timer.Simple(0,function() self:Remove() end)
end
function ENT:ExplodeHigh()
	self:DoFX("high")
	self.Entity:EmitSound( "blackpowder.Boom", 100, 85 )
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),155)) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(math.random(25,30))
			dmginfo:SetDamageElement("magic")
			v:TakeDamageInfo(dmginfo)
		end
	end
	local projs = {"ent_hex_projectile_arcanebolt","ent_hex_projectile_firebolt"}
	for i=1,3 do
		local proj = ents.Create(table.Random(projs))
		proj:SetPos(self:GetPos())
		proj:SetOwner(self:GetOwner())
		proj:Spawn()

		proj:SetPower("normal")

		local phys = proj:GetPhysicsObject()
	    phys:ApplyForceCenter(Vector(math.random(-255,255), math.random(-255,255), 255) * 10)
	    phys:EnableGravity(true)
	end
	timer.Simple(0,function() self:Remove() end)
end

function ENT:DoFX(power)
	if power == "low" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(0.5) fx:SetAngles(Angle(self:GetColor().r,self:GetColor().g,self:GetColor().b))	
		util.Effect("fx_hex_colorblast01",fx)
	elseif power == "normal" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(1.5) fx:SetAngles(Angle(self:GetColor().r,self:GetColor().g,self:GetColor().b))
		util.Effect("fx_hex_colorblast01",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(1)	
		fx2:SetAngles(Angle(self:GetColor().r,self:GetColor().g,self:GetColor().b))
		util.Effect("fx_hex_model_blast",fx2)
	elseif power == "high" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(2) fx:SetAngles(Angle(self:GetColor().r,self:GetColor().g,self:GetColor().b))
		util.Effect("fx_hex_colorblast01",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(1.5)
		fx2:SetAngles(Angle(self:GetColor().r,self:GetColor().g,self:GetColor().b))
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