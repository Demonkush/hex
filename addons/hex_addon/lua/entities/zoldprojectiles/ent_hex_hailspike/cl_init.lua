include( "shared.lua" )

function ENT:Initialize()
	self:DrawShadow(false)

	self:SetModelScale(2)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 48)

	self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
	self.NextEmit = 0
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
	local siz = math.abs(math.sin(rt * 20)) * 16 + 16
	render.SetMaterial(matFire)
	render.DrawSprite(vPos, siz, siz, Color( 55, 155, 255 ))

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.01

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local particle = emitter:Add("hexgm/sprites/hexbit06", self:GetPos()  )
	particle:SetVelocity( VectorRand() * 15 )
	particle:SetDieTime(0.6)
	particle:SetStartAlpha(3)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.random(14,17))
	particle:SetEndSize(15)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(0)
	particle:SetGravity(Vector(0,0,0))
	particle:SetAirResistance(0)
	particle:SetColor( 155, math.random(155,215), math.random(215,255), 55 )
end