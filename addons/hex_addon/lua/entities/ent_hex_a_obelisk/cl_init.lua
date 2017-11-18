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
	self:DrawModel()
	local rt = RealTime()
	local vPos = self:GetPos() + Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))
	local colv = self:GetStatusColor()
	local col = Color(colv.x,colv.y,colv.z)

    local iny,inx = "hexgm/ui/hexvortex.png","hexgm/ui/hexvortex_reverse.png"
    cam.Start3D2D( self:GetPos()+Vector(0,0,65), Angle(0,0,0), 1 )
        surface.SetDrawColor( Color(col.r,col.g,col.b,25) )
        surface.SetMaterial( Material(iny) )
        surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*2) * 4 + 180, math.sin(RealTime()*2) * 4 + 180,(CurTime()*-64) % 360)
    cam.End3D2D()
    cam.Start3D2D( self:GetPos()+Vector(0,0,65), Angle(0,0,180), 1 )
        surface.SetDrawColor( Color(col.r,col.g,col.b,25) )
        surface.SetMaterial( Material(inx) )
        surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*2) * 4 + 180, math.sin(RealTime()*2) * 4 + 180,(CurTime()*64) % 360)
    cam.End3D2D()

	if RealTime() > self.NextEmit then
		local emitter = self.Emitter
		emitter:SetPos(vPos)
		local particle = emitter:Add("sprites/glow04_noz",self:GetPos()+Vector(0,0,65))
		particle:SetVelocity(VectorRand()*3)
		particle:SetDieTime(0.8)
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.random(95,115))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0,360))
		particle:SetGravity(Vector(0,0,0))
		particle:SetAirResistance(0)
		particle:SetColor(col.r,col.g,col.b)
		self.NextEmit = RealTime()+0.1
	end

	if RealTime() > self.NextEmit2 then
		local emitter = self.Emitter
		emitter:SetPos(vPos)
		local particle = emitter:Add("sprites/glow04_noz",self:GetPos()+Vector(math.random(-64,64),math.random(-64,64),65))
		particle:SetVelocity(Vector(math.random(-512,512),math.random(-512,512),0))
		particle:SetDieTime(1.5)
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(255)
		particle:SetStartSize(25)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetGravity(Vector(0,0,0))
		particle:SetAirResistance(75)
		particle:SetColor(col.r,col.g,col.b)
		particle:SetNextThink( CurTime()+0.01 )
		particle:SetThinkFunction( function(pa) 
			if IsValid(self) then
				local posdiff = (pa:GetPos() - self:GetPos()):Angle():Right()
				pa:SetVelocity(posdiff:GetNormal()*128)
				pa:SetNextThink( CurTime()+0.01 )
			end
		end )
		self.NextEmit2 = RealTime()+0.04
	end
end