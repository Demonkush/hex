include( "shared.lua" )

function ENT:Initialize()
	self:DrawShadow(false)

	self:SetModelScale(1)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 48)

	self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
	self.NextEmit = 0
end

function ENT:Think()

	self.Emitter:SetPos(self:GetPos())
return true
end

local matFire = Material("hexgm/sprites/hexbit01")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

	self:DrawModel()

	local rt = RealTime()

	local vPos = self:GetPos()
	local siz = math.abs(math.sin(rt * 25)) * 16 + 4
	render.SetMaterial(matFire)
	render.DrawSprite(vPos, siz, siz, Color( 255, 125, 25 ))

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.01

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local attach = self:LookupAttachment("sparks")
	local apos = self:GetAttachment( attach )

	local particle = emitter:Add("hexgm/sprites/hexbit01", self:GetPos() )
	particle:SetVelocity( VectorRand() * 25 )
	particle:SetDieTime(0.7)
	particle:SetStartAlpha(55)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.random(3,6))
	particle:SetEndSize(1)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-1, 1))
	particle:SetGravity(Vector(0,0,255))
	particle:SetAirResistance(0)
	particle:SetColor( 255, 125, 55, 55 )
end