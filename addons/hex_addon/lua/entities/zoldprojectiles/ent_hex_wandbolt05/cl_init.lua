include( "shared.lua" )

function ENT:Initialize()
	self:DrawShadow(false)

	self:SetModelScale(2)

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

local matFire = Material("hexgm/sprites/hexbit04")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

	--self:DrawModel()

	local rt = RealTime()

	local vPos = self:GetPos() + Vector(math.random(-5,5),math.random(-5,5),math.random(-5,5))

	if RealTime() > self.NextEmit then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit07", self:GetPos() + ( VectorRand() * 15 ) )
		particle:SetVelocity( VectorRand() * 5 )
		particle:SetDieTime(0.8)
		particle:SetStartAlpha(55)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(6,8))
		particle:SetEndSize(1)
		particle:SetRoll(0)
		particle:SetRollDelta(0)
		particle:SetGravity(Vector(0,0,-312))
		particle:SetAirResistance(5)
		particle:SetColor( math.random(115,155), math.random(215,255), 55, 55 )
		self.NextEmit = RealTime() + 0.025
	end

	if RealTime() > self.NextEmit2 then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos() + ( VectorRand() * 10 ) )
		particle:SetVelocity( VectorRand() * 55 )
		particle:SetDieTime(0.2)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(16,24))
		particle:SetEndSize(1)
		particle:SetRoll(0)
		particle:SetRollDelta(0)
		particle:SetGravity(Vector(0,0,-312))
		particle:SetAirResistance(5)
		particle:SetColor( math.random(115,155), math.random(215,255), 55, 55 )
		self.NextEmit2 = RealTime() + 0.01
	end
end