function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local scale = data:GetScale()
	for i=0, 35+scale do
		local part = emit:Add ("hexgm/sprites/hexbit09", data:GetOrigin()+(VectorRand()* Vector( math.Rand( -255, 255 ), math.Rand( -255, 255 ), 255 )))
		part:SetVelocity(VectorRand()*25)
		part:SetStartAlpha(15)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(1,2)+scale)
		part:SetStartSize(math.random(25,35)*scale)
		part:SetColor( 135, 255, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -55))
		part:SetCollide(true)
	end
	for i=0, 25+scale do
		local part = emit:Add ("hexgm/sprites/hexbit09", data:GetOrigin()+(VectorRand()* Vector( math.Rand( -255, 255 ), math.Rand( -255, 255 ), 255 )))
		part:SetVelocity(VectorRand()*5)
		part:SetStartAlpha(15)
		part:SetEndAlpha(0)
		part:SetStartLength(35)
		part:SetEndLength(1)
		part:SetDieTime(1+scale)
		part:SetStartSize(math.random(25,35)*scale)
		part:SetColor( 135, 215, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -55))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end