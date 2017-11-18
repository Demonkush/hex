include("shared.lua")
function ENT:Initialize()
	self:DrawShadow(false)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 48)

	self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
	self.NextEmit = 0
end

function ENT:Draw()

	self:DrawModel()

	local vPos = self:GetPos() 

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.2

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos() + Vector(math.random(-35,35),math.random(-35,35),math.random(-35,35)) )
	particle:SetVelocity( (VectorRand() * 5)+Vector(0,0,55) )
	particle:SetDieTime(1)
	particle:SetStartAlpha(0)
	particle:SetEndAlpha(155)
	particle:SetStartSize(math.random(2,3))
	particle:SetEndSize(0.1)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetGravity(Vector(0,0,-55))
	particle:SetAirResistance(0)
	particle:SetColor( 255, 185, 55 )

end