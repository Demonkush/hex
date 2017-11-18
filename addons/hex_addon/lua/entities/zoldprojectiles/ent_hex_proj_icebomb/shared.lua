ENT.Type = "anim"

ENT.PrintName		= "Ice Bomb"
ENT.Author			= "Demonkush"

function ENT:Initialize()
	self:SetModel( "models/Gibs/HGIBS.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end
	if CLIENT then
		local vOffset = self:LocalToWorld( Vector(0, 0, self:OBBMins().z) )
		self.Emitter = ParticleEmitter( vOffset )
	end
end