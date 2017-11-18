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

	local vPos = self:GetPos()

	if RealTime() > self.NextEmit then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit11", self:GetPos() )
		particle:SetVelocity( VectorRand() * 25 )
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(25)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(5,10))
		particle:SetEndSize(15)
		particle:SetRoll(math.random(0,360))
		particle:SetRollDelta(-5)
		particle:SetGravity(Vector(0,0,0))
		particle:SetAirResistance(255)
		particle:SetColor( math.random(185,215), math.random(155,185), math.random(185,255), 100 )
		self.NextEmit = RealTime() + 0.05
	end

	if RealTime() > self.NextEmit2 then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit02", self:GetPos() )
		particle:SetVelocity( VectorRand() * 155 )
		particle:SetDieTime(0.2)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(30,40))
		particle:SetEndSize(1)
		particle:SetRoll(0)
		particle:SetRollDelta(0)
		particle:SetGravity(Vector(0,0,0))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(185,215), math.random(155,185), math.random(125,215), 100 )
		self.NextEmit2 = RealTime() + 0.01
	end
end