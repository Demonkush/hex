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

local matFire = Material("hexgm/sprites/hexbit14")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

	local rt = RealTime()

	local vPos = self:GetPos()

	if RealTime() > self.NextEmit then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit14", self:GetPos() )
		particle:SetVelocity( VectorRand() * 5 )
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(20,25))
		particle:SetEndSize(1)
		particle:SetRoll(0)
		particle:SetRollDelta(math.random(-15,15))
		particle:SetGravity(Vector(0,0,-512))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(25,115), math.random(55,75), 255, 100 )
		self.NextEmit = RealTime() + 0.025
	end

	if RealTime() > self.NextEmit2 then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit14", self:GetPos() )
		particle:SetVelocity( VectorRand() * 5 )
		particle:SetDieTime(0.1)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(25,35))
		particle:SetEndSize(1)
		particle:SetRoll(0)
		particle:SetRollDelta(math.random(-15,15))
		particle:SetGravity(Vector(0,0,-255))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(25,115), math.random(55,75), 255, 100 )
		self.NextEmit2 = RealTime() + 0.01
	end
end