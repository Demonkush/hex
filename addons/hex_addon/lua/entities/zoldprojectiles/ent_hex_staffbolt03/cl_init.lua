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

	local vPos = self:GetPos()

	if RealTime() > self.NextEmit then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit06", self:GetPos() + VectorRand()*25  )
		particle:SetVelocity( VectorRand() * 15 )
		particle:SetDieTime(0.9)
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(155)
		particle:SetStartSize(math.random(2,10))
		particle:SetEndSize(0)
		particle:SetRoll(0)
		particle:SetRollDelta(0)
		particle:SetGravity(Vector(0,0,0))
		particle:SetAirResistance(0)
		particle:SetColor( 155, math.random(155,215), math.random(215,255), 55 )
		self.NextEmit = RealTime() + 0.025
	end

	if RealTime() > self.NextEmit2 then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos()  )
		particle:SetVelocity( VectorRand() * 15 )
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(20,25))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(0)
		particle:SetGravity(Vector(0,0,0))
		particle:SetAirResistance(0)
		particle:SetColor( 155, math.random(155,215), math.random(215,255), 55 )
		self.NextEmit2 = RealTime() + 0.01
	end
end