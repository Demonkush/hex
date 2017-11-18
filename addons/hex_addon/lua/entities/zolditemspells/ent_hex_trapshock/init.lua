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
	dmginfo:SetDamageElement("storm")
	a:TakeDamageInfo( dmginfo )

	local cts = math.random(1,10)
	if cts >= 8 then
		if a:IsPlayer() then
			a:BuffStun(self:GetOwner(),math.random(1,2))
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
		util.Effect( "fx_hex_staffblast01", fx )
		self.Entity:EmitSound( "wc3sound/exp/LightningShieldTarget.wav", 85, math.random(95,115) )

		self.tes = ents.Create( "point_tesla" )
		self.tes:SetPos( self:GetPos() )
		self.tes:SetKeyValue( "m_SoundName", "" )
		self.tes:SetKeyValue( "texture", "sprites/bluelaser1.spr" )
		self.tes:SetKeyValue( "m_Color", "100 100 100" )
		self.tes:SetKeyValue( "m_flRadius", "200" )
		self.tes:SetKeyValue( "beamcount_min", "2" )
		self.tes:SetKeyValue( "beamcount_max", "3" )
		self.tes:SetKeyValue( "thick_min", "16" )
		self.tes:SetKeyValue( "thick_max", "32" )
		self.tes:SetKeyValue( "lifetime_min", "0.3" )
		self.tes:SetKeyValue( "lifetime_max", "0.5" )
		self.tes:SetKeyValue( "interval_min", "0.1" )
		self.tes:SetKeyValue( "interval_max", "0.3" )
		self.tes:Spawn()
		self.tes:Fire( "DoSpark", "", 0.1 )
		self.tes:Fire( "DoSpark", "", 0.3 )
		self.tes:Fire( "DoSpark", "", 0.5 )
		self.tes:Fire( "kill", "", 0.6 )

		self:Remove()
	end
end

function ENT:OnRemove()

end