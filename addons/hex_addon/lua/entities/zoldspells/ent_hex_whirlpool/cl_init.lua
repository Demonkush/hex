include( "shared.lua" )

function ENT:Initialize()
	self:DrawShadow(false)

	self:SetModelScale(2)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 48)

	self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
	self.NextEmit = 0
	self.RingAlpha = 0
	self.AlphaDir = 0

	timer.Simple(4,function() if IsValid(self) then self.AlphaDir = 1 end end)
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
	if self.AlphaDir == 0 then
		self.RingAlpha = self.RingAlpha + 0.3
	else
		self.RingAlpha = self.RingAlpha - 1
	end
	return true
end

local matFire = Material("hexgm/sprites/hexbit05")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

    local ind = "hexgm/ui/aura_inferno.png"
    cam.Start3D2D( self:GetPos()+Vector(0,0,1), Angle(0,0,0), 1 )
        surface.SetDrawColor( Color(155,155,215,math.Clamp(self.RingAlpha,0,100)) )
        surface.SetMaterial( Material(ind) )
        surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*2) * 8 + 300, math.sin(RealTime()*2) * 8 + 300,(CurTime()*-155) % 360)
    cam.End3D2D()
    cam.Start3D2D( self:GetPos()+Vector(0,0,-1), Angle(0,0,180), 1 )
        surface.SetDrawColor( Color(155,155,215,math.Clamp(self.RingAlpha,0,100)) )
        surface.SetMaterial( Material(ind) )
        surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*2) * 8 + 300, math.sin(RealTime()*2) * 8 + 300,(CurTime()*155) % 360)
    cam.End3D2D()


	local rt = RealTime()

	local vPos = self:GetPos()

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.05

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos() + Vector(math.random(-125,125),math.random(-125,125),math.random(-25,25)) )
		particle:SetVelocity(Vector(0,0,128))
		particle:SetDieTime(math.random(0.5,1.5))
		particle:SetStartSize(math.random(25,75))
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(math.random(55,155))
		particle:SetColor( 155, 155, 215 ) 
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0,360))
		particle:SetRollDelta(0)
		particle:SetAirResistance(0)
		particle:SetGravity(Vector(0, 0, math.random(-255,-55) ))
end