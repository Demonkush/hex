function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local scale = data:GetScale()
	for i=0, 3 do
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.25*scale)
		part:SetStartSize(math.random(55,75)*scale)
		part:SetColor( 255, 235, 215 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(1+scale)
		part:SetStartSize(55*scale)
		part:SetStartAlpha(55)
		part:SetColor( 75, 55, 25 ) 
		part:SetEndSize(45)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 3+scale do
		local part = emit:Add ("hexgm/sprites/hexbit08", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -755, 755 ), math.Rand( -755, 755 ), 355 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartLength(35)
		part:SetEndLength(1)
		part:SetDieTime(0.7+scale)
		part:SetStartSize(math.random(25,35)*scale)
		part:SetColor( 215, 175, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -255))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end