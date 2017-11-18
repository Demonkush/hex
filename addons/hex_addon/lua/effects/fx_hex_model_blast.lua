function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Scale = data:GetScale()

	self.CZ = data:GetAngles()

	self.Color = Color(self.CZ.p,self.CZ.y,self.CZ.r)

	self.Alpha = 100
	self.AlphaRate = 2 / (self.Scale)	
	self.Size = 7


	self.prop_a1 = ClientsideModel("models/dav0r/hoverball.mdl",RENDERGROUP_TRANSLUCENT)
	self.prop_a1:SetPos(self.Pos)
	self.prop_a1:SetAngles(AngleRand())
	self.prop_a1:SetMaterial("models/debug/debugwhite2")
	self.prop_a1:SetModelScale(self.Size*self.Scale)
	self.prop_a1:SetColor(Color(self.Color.r,self.Color.g,self.Color.b,self.Alpha))

	self.prop_a1:SetRenderMode( RENDERMODE_TRANSALPHA )

	self:DrawShadow(false)
end

function EFFECT:Think()
	if IsValid(self.prop_a1) then
		self.Alpha = self.Alpha - self.AlphaRate
		self.Size = self.Size + 0.05
		if self.Alpha < 1 then
			self.prop_a1:Remove()
			return false
		end
	else
		return false
	end
	return true
end

function EFFECT:Render()

	if IsValid(self.prop_a1) then
		self.prop_a1:SetModelScale(self.Size*self.Scale)
		self.prop_a1:SetColor(Color(self.Color.r,self.Color.g,self.Color.b,self.Alpha))
	end

end