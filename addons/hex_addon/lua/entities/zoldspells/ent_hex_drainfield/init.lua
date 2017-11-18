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
	self:EmitSound("wc3sound/exp/SoulPreservation.wav",85,55)
end

function ENT:Think()

	if self.PuffTick < CurTime() then
		self:DoPuff()
		self.PuffTick = self.PuffTick + 1
	end

end

function ENT:DoPuffDMG(a)
	if a != self:GetOwner() then
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 1 )
		dmginfo:SetDamageElement("magic")
		a:TakeDamageInfo( dmginfo )
		if a:IsPlayer() && a:Alive() then
			local r = math.random(1,10)
			a:SubtractMana(3)
			if r > 5 then
				self:GetOwner():AddMana(1)
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