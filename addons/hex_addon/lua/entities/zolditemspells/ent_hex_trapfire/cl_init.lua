include( "shared.lua" )

function ENT:Initialize()
	self:DrawShadow(false)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 48)

	self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
	self.NextEmit = 0
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
	return true
end

local matFire = Material("hexgm/sprites/hexbit05")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()

	-- Underglow
	local tr = util.TraceLine( {
		start = self:GetPos(),
		endpos = self:GetPos() + Vector(0,0,-50),
		filter = self
	} )
	
    local trace = util.TraceLine(tr)
    local angle = trace.HitNormal:Angle()

    local ind = "hexgm/ui/aura_fire.png"

    if tr.Hit then
        cam.Start3D2D( tr.HitPos+Vector(0,0,1), Angle(0,0,0), 1 )
            surface.SetDrawColor( Color(255,155,55,10) )
            surface.SetMaterial( Material(ind) )
            surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*2) * 4 + 32, math.sin(RealTime()*2) * 4 + 32,(CurTime()*25) % 360)
        cam.End3D2D()
    end
    -- End Underglow

	local rt = RealTime()

	local vPos = self:GetPos()

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.25

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local particle = emitter:Add("hexgm/sprites/hexbit01", self:GetPos() + Vector(math.random(-5,5),math.random(-5,5),math.random(0,25)) )
		particle:SetVelocity(Vector(0,0,64))
		particle:SetDieTime(math.random(0.5,1.5))
		particle:SetStartSize(math.random(3,5))
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(math.random(55,155))
		particle:SetColor( 255, math.random(105,155), 55 ) 
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0,360))
		particle:SetRollDelta(0)
		particle:SetAirResistance(0)
		particle:SetGravity(Vector(0, 0, math.random(-255,-55) ))


end