AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/Gibs/HGIBS.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 0, 0, 0, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(0.2)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	
	-- Sprite Trail Effect
	if SERVER then
		util.SpriteTrail(self.Entity, 0, Color(155, 100, 255, 55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
	end

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end
	end

	timer.Simple(2,function()
		if IsValid(self) then
			if self:GetPower() == "low" or self:GetPower() == "normal" then
				self:ExplodeNormal()
			elseif self:GetPower() == "high" then
				self:ExplodeHigh()
			end
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

function ENT:ExplodeNormal()
	-- Gun Bomb
	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	fx:SetScale(2)
	util.Effect( "fx_hex_gunpoof01", fx )
	self.Entity:EmitSound( "blackpowder.Boom", 100, 85 )
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 135 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(25,35) )
			dmginfo:SetDamageElement("physical")
			v:TakeDamageInfo( dmginfo )
		end
		if v:IsPlayer() then
			v:SetVelocity((v:GetPos()-self:GetPos())*3)
		end
	end

	self:Remove()
end
function ENT:ExplodeHigh()
	-- Fragmentation Bomb
	-- todo: add random elemental projectile with gravity
	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	fx:SetScale(2)
	util.Effect( "fx_hex_gunpoof01", fx )
	util.Effect( "fx_hex_fireblast02", fx )
	self.Entity:EmitSound( "blackpowder.Boom", 100, 135 )
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 165 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(35,45) )
			dmginfo:SetDamageElement("fire")
			v:TakeDamageInfo( dmginfo )
		end
		local cts = math.random(1,5)	
		if cts >= 3 then
			if v:IsPlayer() then
				v:BuffFire(self:GetOwner(),0.5,5)
			end
		end
		if v:IsPlayer() then
			v:SetVelocity((v:GetPos()-self:GetPos())*3)
		end
	end

	self:Remove()
end

function ENT:PhysicsCollide( data, phys )
	phys:SetVelocity(self:GetVelocity()+Vector(0,0,150))
	if self:GetPower() == "low" or self:GetPower() == "normal" then
		self:ExplodeNormal()
	elseif self:GetPower() == "high" then
		self:ExplodeHigh()
	end
end

function ENT:OnRemove()

end