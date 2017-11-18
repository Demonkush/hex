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

	self.SupTick = 2


	timer.Simple(10,function() if IsValid(self) then self:Remove() end end)
end

function ENT:Think()

	if self.SupTick < CurTime() then
		self:DoSup()
		self.SupTick = self.SupTick + 1
	end

end

function ENT:SupportEffect(a)
	if HEX.Teamplay == true then
		if a:Team() == self:GetOwner():Team() then
			a:AddHP(1)
			a:AddMana(1)
		end
	else
		if a == self:GetOwner() then
			a:AddHP(1)
			a:AddMana(1)
		end
	end
end

function ENT:DoSup()
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), 155)) do
		if v:IsPlayer() then
			self:SupportEffect(v)
		end
	end
end

function ENT:OnRemove()

end