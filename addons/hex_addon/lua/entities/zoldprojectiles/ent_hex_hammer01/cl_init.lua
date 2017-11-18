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

local matFire = Material("hexgm/sprites/hexbit02")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

	self:DrawModel()

	local rt = RealTime()

	local vPos = self:GetPos() + Vector(math.random(-5,5),math.random(-5,5),math.random(-5,5))
	local siz = math.abs(math.sin(rt * 20)) * 32 + 16
	render.SetMaterial(matFire)
	render.DrawSprite(vPos, siz, siz, Color( 115, 215, 255 ))

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.01

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local particle = emitter:Add("hexgm/sprites/hexbit09", self:GetPos() + Vector(math.random(-10,10),math.random(-10,10),math.random(-10,10)) )
	particle:SetVelocity( VectorRand() * 25 )
	particle:SetDieTime(0.9)
	particle:SetStartAlpha(55)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.random(2,6))
	particle:SetEndSize(1)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-1, 1))
	particle:SetGravity(Vector(0,0,55))
	particle:SetAirResistance(0)
	particle:SetColor( 85, math.random(125,155), math.random(235,255), 55 )
end