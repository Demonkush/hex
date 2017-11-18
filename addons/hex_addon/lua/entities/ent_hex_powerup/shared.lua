ENT.Type = "anim"
ENT.PrintName	= "Item Pickup"
ENT.Author		= "Demonkush"

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube075x2x075.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_NONE)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)

	if CLIENT then
		local vOffset = self:LocalToWorld(Vector(0,0,self:OBBMins().z))
		self.Emitter = ParticleEmitter(vOffset)
	end
end
