include("shared.lua")
function ENT:Initialize()
	self:DrawShadow(false)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24,48)

	self:SetRenderBounds(Vector(-256,-256,-256),Vector(256,256,256))
	self.NextEmit = 0

	self.ang = 0
end

function ENT:Think()
	self.ang = self.ang + 0.25
	if self.ang >= 360 then
		self.ang = 0
	end
	self:SetAngles(Angle(0,self.ang,90))
	if GetConVar("hex_cl_togglepickuplight"):GetInt() == 0 then return end
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.pos = self:GetPos()
        dlight.Size              = 64
        dlight.Decay             = 800
        dlight.R                 = self:GetColor().r
        dlight.G                 = self:GetColor().g
        dlight.B                 = self:GetColor().b
        dlight.Brightness        = 5
        dlight.DieTime           = CurTime() + 0.35
	end
	self.Emitter:SetPos(self:GetPos())
	return true
end

local matFire = Material("Sprites/light_glow02")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw()
	local itemicon = Material(self:GetNWString("PowerupImage"))
	if itemicon != nil then
		local function DrawItemPanel(angles)
			cam.Start3D2D(self:GetPos(),angles,0.75)
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(itemicon)
				surface.DrawTexturedRect(-16,-16,32,32)
			cam.End3D2D()
		end
		DrawItemPanel(self:GetAngles())
		DrawItemPanel(self:GetAngles()+Angle(0,180,0))
	end

	local vPos = self:GetPos() 

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.2

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local particle = emitter:Add("hexgm/sprites/hexbit04", self:GetPos() + Vector(math.random(-15,15),math.random(-15,15),math.random(-15,15)) )
	particle:SetVelocity((VectorRand()*5)+Vector(0,0,55))
	particle:SetDieTime(1)
	particle:SetStartAlpha(0)
	particle:SetEndAlpha(255)
	particle:SetStartSize(math.random(2,3))
	particle:SetEndSize(0.1)
	particle:SetRoll(math.Rand(0,360))
	particle:SetGravity(Vector(0,0,-55))
	particle:SetAirResistance(0)
	particle:SetColor( self:GetColor().r,self:GetColor().g,self:GetColor().b )
end