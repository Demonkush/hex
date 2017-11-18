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
		local particle = emitter:Add("hexgm/sprites/hexbit09", self:GetPos() + Vector(math.random(-10,10),math.random(-10,10),math.random(-10,10)) )
		particle:SetVelocity( VectorRand() * 155 )
		particle:SetDieTime(2)
		particle:SetStartAlpha(45)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(12,18))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetGravity(Vector(0,0,55))
		particle:SetAirResistance(155)
		particle:SetColor( math.random(235,255), math.random(55,85), 55, 55 )
		self.NextEmit = RealTime()+0.01
	end

	if RealTime() > self.NextEmit2 then
		local emitter = self.Emitter
		emitter:SetPos(vPos)
		local particle = emitter:Add("hexgm/sprites/hexbit01", self:GetPos() + Vector(math.random(-10,10),math.random(-10,10),math.random(-10,10)) )
		particle:SetVelocity( VectorRand() * 75 )
		particle:SetDieTime(1.2)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(15,25))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetGravity(Vector(0,0,128))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(235,255), math.random(55,125), 55, 55 )
		self.NextEmit2 = RealTime()+0.01
	end
end