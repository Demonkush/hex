function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local scale = data:GetScale()
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbitstorm", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.1*scale)
		part:SetStartSize(55*scale)
		part:SetColor( 155, 215, 255 ) 
		part:SetEndSize(35*scale)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(3+scale)
		part:SetStartSize(100*scale)
		part:SetStartAlpha(55)
		part:SetColor( 25, 55, 75 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 15+scale do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin() + Vector( math.Rand( -55, 55 ), math.Rand( -55, 55 ), math.Rand( -55, 55 ) ))
		part:SetVelocity(VectorRand()* Vector( math.Rand( -55, 55 ), math.Rand( -55, 55 ), 55 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(2,3)+scale)
		part:SetStartSize(math.random(5,15)*scale)
		part:SetColor( math.random(55,155), math.random(155,215), 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(55)
		part:SetGravity(Vector(0, 0, -55))
		part:SetCollide(false)
	end
	for i=0, 15+scale do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -755, 755 ), math.Rand( -755, 755 ), 355 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartLength(50)
		part:SetEndLength(1)
		part:SetDieTime(1+scale)
		part:SetStartSize(math.random(15,25)*scale)
		part:SetColor( 155, 215, 215 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -155))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end