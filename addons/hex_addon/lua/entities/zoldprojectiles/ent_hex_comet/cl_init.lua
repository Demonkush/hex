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

local matFire = Material("hexgm/sprites/hexbit03")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

	local rt = RealTime()

	local vPos = self:GetPos()

	if RealTime() > self.NextEmit then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit08", self:GetPos() + VectorRand()*25 )
		particle:SetVelocity( ( VectorRand() * 55 ) + Vector(0,0,255) )
		particle:SetDieTime(1)
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(5,25))
		particle:SetEndSize(1)
		particle:SetRoll(0)
		particle:SetRollDelta(0)
		particle:SetGravity(Vector(0,0,0))
		particle:SetAirResistance(100)
		particle:SetColor( math.random(155,215), math.random(125,185), math.random(185,255), 100 )
		self.NextEmit = RealTime() + 0.01
	end

	if RealTime() > self.NextEmit2 then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit02", self:GetPos() )
		particle:SetVelocity( ( VectorRand() * 55 ) + Vector(0,0,50) )
		particle:SetDieTime(0.2)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(65,75))
		particle:SetEndSize(1)
		particle:SetRoll(0)
		particle:SetRollDelta(math.random(-5,5))
		particle:SetGravity(Vector(0,0,0))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(185,215), math.random(155,185), math.random(185,255), 100 )
		self.NextEmit2 = RealTime() + 0.01
	end
end