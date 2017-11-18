EFFECT.LaserMat = Material("trails/plasma")
EFFECT.EndSprMat = Material("hexgm/sprites/particles/mor_glow02")

function EFFECT:Init(data)
	self.Position = data:GetStart()
	self.Weapon = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.StartPos = self:GetTracerShootPos(self.Position,self.Weapon,self.Attachment)
	self.EndPos = data:GetOrigin()
	self.Length = (self.StartPos - self.EndPos):Length()
	
	if not IsValid(self.Weapon) then return false end

		if LocalPlayer() == self.Weapon.Owner and LocalPlayer():GetFOV() < 75 then
		self.StartPos = LocalPlayer():GetShootPos() + Vector(0,0,-10)
		
	end	
	self.Alpha = 255
	self.Width = 10
	self.Entity:SetRenderBoundsWS(self.StartPos,self.EndPos)
end

function EFFECT:Think()
	if not self.Alpha then return false end
	self.Alpha = self.Alpha - FrameTime() * 2000
	
	if self.Alpha < 0 then return false end
	return true
end

function EFFECT:Render()
	if self.Alpha < 1 then return end
	
	local alpha = self.Alpha + ((self.Alpha/2) * math.sin(CurTime()*((255-self.Alpha)*0.08))) 
   
	render.SetMaterial(self.LaserMat)
	render.DrawBeam(self.StartPos,
					self.EndPos,
					self.Width,
					CurTime()*15 + (self.Length*0.01),
					CurTime()*15,
					Color(255,100,100,155))
	
	render.SetMaterial(self.EndSprMat)
	render.DrawSprite(self.StartPos, self.Width*2, self.Width*2,Color(255,100,100,155))
	render.DrawSprite(self.EndPos, self.Width*2, self.Width*2,Color(255,100,100,155))
end
