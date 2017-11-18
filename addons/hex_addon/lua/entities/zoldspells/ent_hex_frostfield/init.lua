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

	timer.Simple(5,function() if IsValid(self) then self:Remove() end end)
end

function ENT:Think()

	if self.PuffTick < CurTime() then
		self:DoPuff()
		self.PuffTick = CurTime() + 0.5
	end

end

function ENT:DoPuffDMG(a)
	if a != self:GetOwner() then
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 1 )
		dmginfo:SetDamageElement("frost")
		a:TakeDamageInfo( dmginfo )

		if a:IsPlayer() then
	        local cts = math.random(1,10)   
	        if cts >= 9 then
	            a:BuffIce(self:GetOwner(),1,6)
	        end
	        if cts < 2 then
	            a:BuffSlow(self:GetOwner(), 3, 2 )
	        end
	    end
	end
end

function ENT:DoPuff()
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), 155)) do
		self:DoPuffDMG(v)
	end
end

--function ENT:OnRemove()
--	self:StopSound("coast.wind_01")
--end