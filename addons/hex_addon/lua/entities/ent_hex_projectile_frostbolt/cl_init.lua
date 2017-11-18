include( "shared.lua" )

function ENT:Initialize()
	self:DrawShadow(false)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24,48)

	self:SetRenderBounds(Vector(-256,-256,-256),Vector(256,256,256))
	self.NextEmit = 0
	self.NextEmit2 = 0
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
	return true
end

function ENT:Draw()
	local rt = RealTime()
	local vPos = self:GetPos() + Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))

	if RealTime() > self.NextEmit then
		local emitter = self.Emitter
		emitter:SetPos(vPos)
		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos() + Vector(math.random(-5,5),math.random(-5,5),math.random(-5,5)) )
		particle:SetVelocity( VectorRand() * 15 )
		particle:SetDieTime(0.7)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(11,13))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetGravity(Vector(0,0,55))
		particle:SetAirResistance(155)
		particle:SetColor( 115, math.random(115,155), math.random(235,255), 55 )
		self.NextEmit = RealTime()+0.01
	end

	if RealTime() > self.NextEmit2 then
		local emitter = self.Emitter
		emitter:SetPos(vPos)
		local particle = emitter:Add("hexgm/sprites/hexbit06", self:GetPos() + Vector(math.random(-25,25),math.random(-25,25),math.random(-25,25)) )
		particle:SetVelocity( VectorRand() * 35 )
		particle:SetDieTime(1)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(3,5))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetGravity(Vector(0,0,-55))
		particle:SetAirResistance(0)
		particle:SetColor( 115, math.random(115,155), math.random(235,255), 55 )
		self.NextEmit2 = RealTime()+0.03
	end
end