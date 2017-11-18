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

	self.PuffTick = 2

	for _, v in ipairs(ents.FindInSphere(self:GetPos(), 155)) do
		if v:IsPlayer() then
			v:SetVelocity(Vector(0,0,600))
		end
	end

	timer.Simple(5,function() if IsValid(self) then self:Remove() end end)
	self:EmitSound("coast.wind_01")
end

function ENT:Think()

	if self.PuffTick < CurTime() then
		self:DoPuff()
		self.PuffTick = self.PuffTick + 0.5
	end

end

function ENT:DoPuffDMG(a)
	if a != self:GetOwner() then
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 1 )
		dmginfo:SetDamageElement("none")
		a:TakeDamageInfo( dmginfo )
	end
end

function ENT:DoPuff()
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), 155)) do
		self:DoPuffDMG(v)
		if v:IsPlayer() then
			v:SetVelocity(Vector(0,0,275))
		end
	end
	for _, v in ipairs(ents.FindInSphere(self:GetPos()+Vector(0,0,125), 125)) do
		self:DoPuffDMG(v)
		if v:IsPlayer() then
			v:SetVelocity(Vector(0,0,200))
		end
	end
	for _, v in ipairs(ents.FindInSphere(self:GetPos()+Vector(0,0,250), 125)) do
		self:DoPuffDMG(v)
		if v:IsPlayer() then
			v:SetVelocity(Vector(0,0,155))
		end
	end
end

function ENT:OnRemove()
	self:StopSound("coast.wind_01")
end