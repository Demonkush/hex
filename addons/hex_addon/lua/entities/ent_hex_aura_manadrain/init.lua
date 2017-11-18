AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_junk/rock001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_NONE )

	self.DrainTick = 1

	timer.Simple(7,function() if IsValid(self) then self:Remove() end end)
end

function ENT:Think()
	if self.DrainTick < CurTime() then
		self:DoDrain()
		self.DrainTick = self.DrainTick + 1
	end
end

function ENT:DrainEffect(a)
	if HEX.Teamplay == true then
		if a:Team() != self:GetOwner():Team() then
			self:GetOwner():AddMana(1)
			a:SubtractMana(1)
		end
	else
		if a != self:GetOwner() then
			self:GetOwner():AddMana(1)
			a:SubtractMana(1)
		end
	end
end

function ENT:DoDrain()
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), 155)) do
		if v:IsPlayer() then
			self:DrainEffect(v)
		end
	end
end

function ENT:OnRemove()

end