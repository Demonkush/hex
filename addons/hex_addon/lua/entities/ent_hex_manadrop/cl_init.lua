include( "shared.lua" )

--function ENT:Draw()
--	render.SetMaterial( Material( "Sprites/light_glow02_add" ) )
--	render.DrawSprite( self:GetPos(), 25, 25, Color(255,255,255,255))
--end

include("shared.lua")
function ENT:Initialize()
	self:DrawShadow(false)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 48)

	self.Emitter2 = ParticleEmitter(self:GetPos())
	self.Emitter2:SetNearClip(24, 48)

	self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
	self.NextEmit = 0
	self.NextEmit2 = 0
end

function ENT:Think()
	if GetConVar("hex_cl_togglepickuplight"):GetInt() == 0 then return end
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.pos = self:GetPos()
        dlight.Size              = 64
        dlight.Decay             = 800
        dlight.R                 = 55
        dlight.G                 = 155
        dlight.B                 = 255
        dlight.Brightness        = 3
        dlight.DieTime           = CurTime() + 0.35
	end
	self.Emitter:SetPos(self:GetPos())
return true
end

local matFire = Material("Sprites/light_glow02")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

	self:DrawModel()

	local vPos = self:GetPos() 

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.2

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos() + Vector(math.random(-15,15),math.random(-15,15),math.random(-15,15)) )
	particle:SetVelocity( (VectorRand() * 5)+Vector(0,0,55) )
	particle:SetDieTime(1)
	particle:SetStartAlpha(0)
	particle:SetEndAlpha(255)
	particle:SetStartSize(math.random(2,3))
	particle:SetEndSize(0.1)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetGravity(Vector(0,0,-55))
	particle:SetAirResistance(0)
	particle:SetColor( 55, 155, 255 )

	if RealTime() < self.NextEmit2 then return end
	self.NextEmit2 = RealTime() + 0.25

	local emitter2 = self.Emitter2
	emitter2:SetPos(vPos)

	local particle2 = emitter2:Add("hexgm/sprites/hexbit01", self:GetPos() )
	particle2:SetVelocity( (VectorRand() * 5) )
	particle2:SetDieTime(1)
	particle2:SetStartAlpha(0)
	particle2:SetEndAlpha(100)
	particle2:SetStartSize(math.random(15,25))
	particle2:SetEndSize(0.1)
	particle2:SetRoll(math.Rand(0, 360))
	particle2:SetGravity(Vector(0,0,25))
	particle2:SetAirResistance(0)
	particle2:SetColor( 55, 155, 255 )
end