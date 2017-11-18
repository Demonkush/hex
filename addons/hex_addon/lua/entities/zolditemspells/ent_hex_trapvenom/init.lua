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

	self.CheckTick = 1
	self.Triggered = 0
	self.Armed = 0

	timer.Simple(2,function() if IsValid(self) then self.Armed = 1 end end)
	timer.Simple(60,function() if IsValid(self) then self:Remove() end end)
end

function ENT:Think()

	if self.CheckTick < CurTime() then
		self:CheckforPlayers()
		self.CheckTick = self.CheckTick + 0.5
	end

end

function ENT:TriggerTrap(a)

	local dmginfo = DamageInfo()
	dmginfo:SetAttacker( self:GetOwner() )
	dmginfo:SetInflictor( self )
	dmginfo:SetDamage( math.random(20,25) )
	dmginfo:SetDamageElement("poison")
	a:TakeDamageInfo( dmginfo )

	local cts = math.random(1,10)	
	if cts >= 5 then
		if a:IsPlayer() then
			a:BuffPoison(self:GetOwner(),1,7)
		end
	end

end

function ENT:CheckforPlayers()
	if self.Armed == 0 then return end
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), 75)) do
		if v:IsPlayer() && v != self:GetOwner() then
			if HEX.Teamplay == true then
				if self:GetOwner():Team() != v:Team() then
					self:TriggerTrap(v)
					self.Triggered = true
				end
			else
				self:TriggerTrap(v)
				self.Triggered = true
			end
		end
	end

	if self.Triggered == true then
		local fx = EffectData()
		fx:SetOrigin( self:GetPos() )
		util.Effect( "fx_hex_bowblast03", fx )
		self.Entity:EmitSound( "wc3sound/PoisonImpact.wav", 85, 100 )

		self:Remove()
	end
end

function ENT:OnRemove()

end