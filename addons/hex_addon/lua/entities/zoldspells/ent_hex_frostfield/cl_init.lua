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
		self.RingAlpha = self.RingAlpha + 0.1
	else
		self.RingAlpha = self.RingAlpha - 0.5
	end
	return true
end

local matFire = Material("hexgm/sprites/hexbit05")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

    local ind = "hexgm/ui/aura_inferno.png"
    cam.Start3D2D( self:GetPos()+Vector(0,0,1), Angle(0,0,0), 1 )
        surface.SetDrawColor( Color(155,215,255,math.Clamp(self.RingAlpha,0,35)) )
        surface.SetMaterial( Material(ind) )
        surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*2) * 8 + 300, math.sin(RealTime()*2) * 8 + 300,(CurTime()*25) % 360)
    cam.End3D2D()
    cam.Start3D2D( self:GetPos()+Vector(0,0,-1), Angle(0,0,180), 1 )
        surface.SetDrawColor( Color(155,215,255,math.Clamp(self.RingAlpha,0,35)) )
        surface.SetMaterial( Material(ind) )
        surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*2) * 8 + 300, math.sin(RealTime()*2) * 8 + 300,(CurTime()*25) % 360)
    cam.End3D2D()


	local rt = RealTime()

	local vPos = self:GetPos()

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.1

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local particle = emitter:Add("hexgm/sprites/hexbit06", self:GetPos() + Vector(math.random(-155,155),math.random(-155,155),math.random(0,45)) )
		particle:SetVelocity(Vector(0,0,math.random(55,155)))
		particle:SetDieTime(math.random(0.5,1))
		particle:SetStartSize(10)
		particle:SetStartAlpha(155)
		particle:SetEndAlpha(0)
		particle:SetColor( 55, math.random(115,215), math.random(175,255) ) 
		particle:SetEndSize(10)
		particle:SetRoll(0)
		particle:SetRollDelta(0)
		particle:SetAirResistance(100)
		particle:SetGravity(Vector(0, 0, math.random(-155,-55) ))


end