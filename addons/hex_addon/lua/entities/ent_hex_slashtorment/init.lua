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
	self.MaxSpikes = 5
	self.SpikeDelay = 0
	self.SpikePos = self:GetPos()

	self:SetNWString("ProjectilePower","normal")

	timer.Simple(10,function() if IsValid(self) then self:Remove() end end)
end

function ENT:Think()
	self:DualSpike()
	self:NextThink(CurTime()+0.01)
	return true
end

function ENT:SetPower(output)
	self:SetNWString("ProjectilePower",output)
end
function ENT:GetPower()
	return self:GetNWString("ProjectilePower")
end

function ENT:DualSpike()
	self.SpikePos = self.SpikePos + self:GetAngles():Forward()*35

	self:Spike(self.SpikePos,1)

	local tr = util.TraceLine( {
		start = self.SpikePos,
		endpos = self.SpikePos + self:GetAngles():Up() * -256,
		filter = self.Entity
	} )

	self:Spike(tr.HitPos,2)

	self.Spikes = self.Spikes + 1
	if self.Spikes == self.MaxSpikes then
		self:Remove()
		return
	end
end

function ENT:Spike(pos,mode)
	local ctp1,ctp2,ctp3 = math.random(1,25),math.random(1,25),math.random(1,25)
	local buff1,buff2,buff3 = false,false,false
	local efx = "fx_hex_slashtorment_air"
	local scale = 1
	local damage = math.random(4,6)
	local damagetype = "poison"
	if self:GetPower() == "low" then
		damagetype = "normal"
	end
	self.MaxSpikes = 5
	if self:GetPower() == "high" then
		self.MaxSpikes = 10
		scale = 0.5
	end

	if mode == 1 then
		efx = "fx_hex_slashtorment_air"
	elseif mode == 2 then	
		efx = "fx_hex_slashtorment_ground"
	end

	if ctp1 > 15 then
		buff1 = true
	end
	if ctp2 > 15 then
		buff2 = true
	end
	if ctp3 > 20 then
		buff3 = true
	end


	for _, v in ipairs(ents.FindInSphere( pos, 48 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( damage )
			dmginfo:SetDamageElement( damagetype )
			v:TakeDamageInfo( dmginfo )

			if v:IsPlayer() then
				if buff1 == true then
					v:BuffPoison(self:GetOwner(),2,5)
				end
				if buff2 == true then
					v:BuffBleed(self:GetOwner(),2,3)
				end
				if buff3 == true then
					v:BuffStun(self:GetOwner(),2)
				end
			end
		end
	end

	local fx = EffectData()
	fx:SetOrigin(pos)
	fx:SetScale(scale)
	fx:SetAngles(self:GetAngles())
	util.Effect(efx,fx)
end

function ENT:OnRemove()
end