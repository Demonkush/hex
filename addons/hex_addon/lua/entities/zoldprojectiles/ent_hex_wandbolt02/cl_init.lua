include( "shared.lua" )

function ENT:Initialize()
	self:DrawShadow(false)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 48)

	self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
	self.NextEmit = 0
	self.NextEmit2 = 0
end

function ENT:Think()

	self.Emitter:SetPos(self:GetPos())
return true
end

local matFire = Material("hexgm/sprites/hexbit13")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

	local rt = RealTime()

	local vPos = self:GetPos() + Vector(math.random(-5,5),math.random(-5,5),math.random(-5,5))

	if RealTime() > self.NextEmit then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit12", self:GetPos() + Vector(math.random(-15,15),math.random(-15,15),math.random(-15,15)) )
		particle:SetVelocity( VectorRand() * 5 )
		particle:SetDieTime(0.2)
		particle:SetStartAlpha(55)
		particle:SetEndAlpha(0)
		particle:SetStartSize(1)
		particle:SetEndSize(math.random(15,25))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-16, 16))
		particle:SetGravity(Vector(0,0,0))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(155,215), math.random(215,255), 155, 255 )
		self.NextEmit = RealTime() + 0.025
	end

	if RealTime() > self.NextEmit2 then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit13", self:GetPos() )
		particle:SetVelocity( VectorRand() * 25 )
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(215)
		particle:SetEndAlpha(0)
		particle:SetStartSize(15)
		particle:SetEndSize(1)
		particle:SetRoll(0)
		particle:SetRollDelta(math.Rand(-16, 16))
		particle:SetGravity(Vector(0,0,0))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(105,155), math.random(215,255), 100, 255 )
		self.NextEmit2 = RealTime() + 0.01
	end
end