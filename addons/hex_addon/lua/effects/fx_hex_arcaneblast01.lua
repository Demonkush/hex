function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local scale = data:GetScale()
	for i=0, 10 do
		local part = emit:Add ("hexgm/sprites/hexbit04",data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.25*scale)
		part:SetStartSize(math.random(55,75)*scale)
		part:SetColor(185,85,255) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0,0,0))
	end
	for i=0, 16 do
		local part = emit:Add ("hexgm/sprites/hexbit04",data:GetOrigin())
		part:SetVelocity(VectorRand()*25)
		part:SetDieTime(0.6*scale)
		part:SetStartSize(55*scale)
		part:SetStartAlpha(55)
		part:SetColor(55,25,75) 
		part:SetEndSize(45)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0,0,0))
	end
	for i=0, 25+scale do
		local part = emit:Add ("hexgm/sprites/hexbit08",data:GetOrigin())
		part:SetVelocity(VectorRand()*Vector(math.Rand(-755,755),math.Rand(-755,755),355))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartLength(15)
		part:SetEndLength(1)
		part:SetDieTime(1+scale)
		part:SetStartSize(math.random(5,15)*scale)
		part:SetColor(155,55,215) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0,0,-255))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end