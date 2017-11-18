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

local matFire = Material("hexgm/sprites/hexbit04")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

	local rt = RealTime()

	local vPos = self:GetPos() + Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))

	if RealTime() > self.NextEmit then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos() + ( VectorRand() * 5 )  )
		particle:SetVelocity( VectorRand() * 85 )
		particle:SetDieTime(0.7)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(5,15))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-64))
		particle:SetAirResistance(0)
		particle:SetColor( 215, 215, 255, 255 )
		self.NextEmit = RealTime() + 0.02
	end

	if RealTime() > self.NextEmit2 then

		local emitter = self.Emitter
		emitter:SetPos(vPos)

		local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos() + ( VectorRand() * 5 )  )
		particle:SetVelocity( VectorRand() * 25 )
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(185)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(15,25))
		particle:SetEndSize(1)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-41, 41))
		particle:SetGravity(Vector(0,0,-64))
		particle:SetAirResistance(0)
		particle:SetColor( 175, 175, 255, 255 )
		self.NextEmit2 = RealTime() + 0.01
	end

end