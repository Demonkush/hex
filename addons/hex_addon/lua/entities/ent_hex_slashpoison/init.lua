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

	self.Spikes = 0
	self.MaxSpikes = 7
	self.SpikeDelay = 0
	self.SpikePos = self:GetPos()

	self:SetNWString("ProjectilePower","normal")

	timer.Simple(10,function() if IsValid(self) then self:Remove() end end)
end

function ENT:Think()
	self:Spike()
	self:NextThink(CurTime()+0.025)
	return true
end

function ENT:SetPower(output)
	self:SetNWString("ProjectilePower",output)
end
function ENT:GetPower()
	return self:GetNWString("ProjectilePower")
end

function ENT:Spike()
	self.SpikePos = self.SpikePos + self:GetAngles():Forward()*25

	local ctp = math.random(1,50)
	local buff = false
	local efx = "fx_hex_slashpoisoni"
	local scale = 1
	local damage = math.random(9,12)
	local damagetype = "poison"
	if self:GetPower() == "low" then
		damagetype = "normal"
		damage = damage * 0.7
		ctp = 0
		efx = "fx_hex_slashnormal"
	end
	self.MaxSpikes = 5
	if self:GetPower() == "high" then
		ctp=ctp+15
		self.MaxSpikes = 10
		damage = damage * 1.5
		scale = 0.5
		efx = "fx_hex_slashpoisonx"
	end

	if ctp > 40 then
		buff = true
	end

	for _, v in ipairs(ents.FindInSphere( self.SpikePos, 40 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( damage )
			dmginfo:SetDamageElement( damagetype )
			v:TakeDamageInfo( dmginfo )

			if v:IsPlayer() then
				if buff == true then
					v:BuffPoison(self:GetOwner(),2,3)
				end
			end
		end
	end

	local fx = EffectData()
	fx:SetOrigin(self.SpikePos)
	fx:SetScale(scale)
	fx:SetAngles(self:GetAngles())
	util.Effect(efx,fx)

	self.Spikes = self.Spikes + 1
	if self.Spikes == self.MaxSpikes then
		self:Remove()
		return
	end
end

function ENT:OnRemove()
end