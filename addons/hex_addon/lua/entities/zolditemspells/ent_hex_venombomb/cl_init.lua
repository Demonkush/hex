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

	local vPos = self:GetPos() + Vector(math.random(-5,5),math.random(-5,5),math.random(-5,5))
	local siz = math.abs(math.sin(rt * 5)) * 32 + 16
	render.SetMaterial(matFire)
	render.DrawSprite(vPos, siz, siz, Color( 155, 255, 55 ))

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.05

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local particle = emitter:Add("hexgm/sprites/hexbit07", self:GetPos() )
	particle:SetVelocity( VectorRand() * 5 )
	particle:SetDieTime(0.7)
	particle:SetStartAlpha(55)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.random(6,12))
	particle:SetEndSize(1)
	particle:SetRoll(0)
	particle:SetRollDelta(0)
	particle:SetGravity(Vector(0,0,-312))
	particle:SetAirResistance(5)
	particle:SetColor( math.random(115,155), math.random(215,255), 55, 55 )
end