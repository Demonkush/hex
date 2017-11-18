AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/weapons/W_missile_launch.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 255, 255, 0 ))
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

	timer.Simple(10,function()
		if IsValid(self) then
			self:Remove()
		end
	end)

	self.Target = nil
	self.TargetTick = 0
end
--[[
function ENT:Think()
	if self.TargetTick < CurTime() then
		if self.Target == nil then
			self:FindTargets()
			self.TargetTick = CurTime() + 0.2
		end
	end
	if self.Target != nil && self.Target:Alive() then
		if SERVER then
			local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				local targetpos = self.Target:GetPos() + Vector(0,0,64)
				phys:SetVelocity( (targetpos-self:GetPos()) * 4 )
			end
		end
	end
end

function ENT:FindTargets()
	if self.Target == nil then
		for _, v in ipairs(ents.FindInSphere( self:GetPos(), 256 )) do
			if v != self:GetOwner() && v:IsPlayer() && v:Alive() then
				self.Target = v
			end
		end
	end
end]]

function ENT:Explode()

	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "fx_hex_wandblast01", fx )
	self.Entity:EmitSound( "wc3sound/NecromancerMissileHit3.wav", 75, math.random(125,130) )

	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 75 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(9,12) )
			dmginfo:SetDamageElement("magic")
			v:TakeDamageInfo( dmginfo )
		end
	end
	self:Remove()

end

function ENT:PhysicsCollide( data, phys )
	self:Explode()
end

function ENT:OnRemove()

end