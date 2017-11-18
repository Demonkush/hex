function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit07", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.6)
		part:SetStartSize(5)
		part:SetColor( 155, 215, 255 ) 
		part:SetEndSize(100)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit07", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(4)
		part:SetStartSize(100)
		part:SetStartAlpha(55)
		part:SetColor( 25, 55, 75 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 35 do
		local part = emit:Add ("hexgm/sprites/hexbit07", data:GetOrigin() + Vector( math.Rand( -155, 155 ), math.Rand( -155, 155 ), math.Rand( -155, 155 ) ))
		part:SetVelocity(VectorRand()* Vector( math.Rand( -55, 55 ), math.Rand( -55, 55 ), 55 ))
		part:SetStartAlpha(35)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(3,4))
		part:SetStartSize(math.random(5,15))
		part:SetColor( math.random(55,155), math.random(155,215), 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(55)
		part:SetGravity(Vector(0, 0, -55))
		part:SetCollide(false)
	end
	for i=0, 35 do
		local part = emit:Add ("hexgm/sprites/hexbit07", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -755, 755 ), math.Rand( -755, 755 ), 355 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartLength(50)
		part:SetEndLength(1)
		part:SetDieTime(2)
		part:SetStartSize(math.random(15,25))
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