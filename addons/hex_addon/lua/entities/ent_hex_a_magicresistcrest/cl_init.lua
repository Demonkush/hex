include( "shared.lua" )

function ENT:Initialize()
	self.prop_a1 = ClientsideModel("models/hex/crest.mdl",RENDERGROUP_TRANSLUCENT)
	self.prop_a1:SetPos(self:GetPos())
	self.prop_a1:SetAngles(Angle(0,0,0))
	self.prop_a1:SetModelScale(0.75)
	self.prop_a1:SetColor(Color(155,215,255))

	self.prop_a2 = ClientsideModel("models/hex/crest.mdl",RENDERGROUP_TRANSLUCENT)
	self.prop_a2:SetPos(self:GetPos())
	self.prop_a2:SetAngles(Angle(180,0,0))
	self.prop_a2:SetModelScale(0.75)
	self.prop_a2:SetColor(Color(155,215,255))

	self:DrawShadow(false)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 48)

	self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
	self.NextEmit = 0

	self.ang = 0
end

function ENT:Think()
	self.ang = self.ang + 0.25
	if self.ang >= 360 then
		self.ang = 0
	end
	self.prop_a1:SetAngles(Angle(0,self.ang,0))
	self.prop_a2:SetAngles(Angle(180,-self.ang,0))

	self.Emitter:SetPos(self:GetPos())
	return true
end

function ENT:Draw()
	local rt = RealTime()
	local siz = math.abs(math.sin(rt * 0.5)) * 8
	self.prop_a1:SetPos(self:GetPos()+Vector(0,0,40+siz))
	self.prop_a2:SetPos(self:GetPos()+Vector(0,0,-20+siz))

	if self:GetNWBool("CrestActive") == false then return end
	render.SetMaterial(Material("sprites/glow04_noz"))
	render.DrawSprite(self:GetPos()+Vector(0,0,15), siz*24, siz*24, Color( 155, 215, 255, 185 ))

	if RealTime() > self.NextEmit then

		local emitter = self.Emitter
		emitter:SetPos(self:GetPos())

		local particle = emitter:Add("sprites/glow04_noz", self:GetPos()+Vector(0,0,15) )
		particle:SetVelocity( (VectorRand()*45)+(VectorRand()*math.random(-75,75)) )
		particle:SetDieTime(2)
		particle:SetStartAlpha(25)
		particle:SetEndAlpha(0)
		particle:SetStartSize(30)
		particle:SetEndSize(30)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetGravity(Vector(0,0,math.random(-150,150)))
		particle:SetAirResistance(155)
		particle:SetColor( 155, 215, 255, math.random(15,215) )
		self.NextEmit = RealTime() + 0.01
	end
end

function ENT:OnRemove()
	self.prop_a1:Remove()
	self.prop_a2:Remove()
end