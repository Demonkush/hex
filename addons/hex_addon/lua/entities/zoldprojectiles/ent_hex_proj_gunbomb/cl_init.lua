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

function ENT:Draw()
	local powermode = "normal"

	self:DrawModel()

	if self:GetNWString("ProjectilePower") == "high" then
		powermode = "high"
	end

	if powermode == "normal" then
		self:DrawNormalParts()
	elseif powermode == "high" then
		self:DrawHighParts()
	end

end

function ENT:DrawNormalParts()
	local rt = RealTime()
	local vPos = self:GetPos() + Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))
	if rt > self.NextEmit then
		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos()  )
		particle:SetVelocity( VectorRand() * 55 )
		particle:SetDieTime(0.35)
		particle:SetStartAlpha(25)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(55,65))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-32))
		particle:SetAirResistance(0)
		particle:SetColor( 55, 55, 55, 255 )
		self.NextEmit = rt + 0.025
	end
	if rt > self.NextEmit2 then
		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos()  )
		particle:SetVelocity( VectorRand() * 155 )
		particle:SetDieTime(0.2)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.random(15,25))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-32))
		particle:SetAirResistance(0)
		particle:SetColor( 55, 55, 55, 255 )
		self.NextEmit2 = rt + 0.01
	end
end

function ENT:DrawHighParts()
	local rt = RealTime()
	local vPos = self:GetPos() + Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))
	if rt > self.NextEmit then
		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos()  )
		particle:SetVelocity( VectorRand() * 55 )
		particle:SetDieTime(0.75)
		particle:SetStartAlpha(25)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(65,75))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-32))
		particle:SetAirResistance(0)
		particle:SetColor( 55, 55, 55, 255 )
		self.NextEmit = rt + 0.025
	end
	if rt > self.NextEmit2 then
		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos()  )
		particle:SetVelocity( VectorRand() * 155 )
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.random(20,30))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-32))
		particle:SetAirResistance(0)
		particle:SetColor( 55, 55, 55, 255 )
		self.NextEmit2 = rt + 0.01
	end
end