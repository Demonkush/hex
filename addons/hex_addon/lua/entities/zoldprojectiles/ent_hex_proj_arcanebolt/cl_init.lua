include( "shared.lua" )

function ENT:Initialize()
	self:DrawShadow(false)

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

	if self:GetNWString("ProjectilePower") == "low" then
		powermode = "low"
	elseif self:GetNWString("ProjectilePower") == "high" then
		powermode = "high"
	end

	if powermode == "low" then
		self:DrawLowParts()
	elseif powermode == "normal" then
		self:DrawNormalParts()
	elseif powermode == "high" then
		self:DrawHighParts()
	end

end

function ENT:DrawLowParts()
	local rt = RealTime()
	local vPos = self:GetPos() + Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))
	if rt > self.NextEmit then
		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos()  )
		particle:SetVelocity( VectorRand() * 5 )
		particle:SetDieTime(0.2)
		particle:SetStartAlpha(25)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(15,25))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-32))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(215,225), math.random(75,115), 255, 255 )
		self.NextEmit = rt + 0.025
	end
	if rt > self.NextEmit2 then
		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos()  )
		particle:SetVelocity( VectorRand() * 45 )
		particle:SetDieTime(0.1)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.random(7,15))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-32))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(215,225), math.random(75,115), 255, 255 )
		self.NextEmit2 = rt + 0.01
	end
end

function ENT:DrawNormalParts()
	local rt = RealTime()
	local vPos = self:GetPos() + Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))
	if rt > self.NextEmit then
		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos()  )
		particle:SetVelocity( VectorRand() * 5 )
		particle:SetDieTime(0.35)
		particle:SetStartAlpha(25)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(25,35))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-32))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(215,225), math.random(75,115), 255, 255 )
		self.NextEmit = rt + 0.025
	end
	if rt > self.NextEmit2 then
		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos()  )
		particle:SetVelocity( VectorRand() * 5 )
		particle:SetDieTime(0.2)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.random(15,25))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-32))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(215,225), math.random(75,115), 255, 255 )
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
		particle:SetVelocity( VectorRand() * 5 )
		particle:SetDieTime(0.75)
		particle:SetStartAlpha(75)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(15,25))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-32))
		particle:SetAirResistance(0)
		particle:SetColor( math.random(215,225), math.random(75,115), 255, 255 )
		self.NextEmit = rt + 0.015
	end
	if rt > self.NextEmit2 then
		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos()  )
		particle:SetVelocity( VectorRand() * 255 )
		particle:SetDieTime(1)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.random(5,10))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-32))
		particle:SetAirResistance(255)
		particle:SetColor( math.random(215,225), math.random(75,115), 255, 255 )
		self.NextEmit2 = rt + 0.01
	end
end