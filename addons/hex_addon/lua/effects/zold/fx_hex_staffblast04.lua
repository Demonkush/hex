function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.2)
		part:SetStartSize(100)
		part:SetColor( 255, 235, 215 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit12", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.4)
		part:SetStartSize(100)
		part:SetStartAlpha(55)
		part:SetColor( 155, 75, 135 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 5 do
		local part = emit:Add ("hexgm/sprites/hexbit08", data:GetOrigin() + Vector( math.Rand( -5, 5 ), math.Rand( -5, 5 ), math.Rand( -155, 155 ) ))
		part:SetVelocity(Vector( math.Rand( -25, 25 ), math.Rand( -25, 25 ), 355 ))
		part:SetStartAlpha(0)
		part:SetEndAlpha(75)
		part:SetDieTime(1)
		part:SetStartSize(math.random(15,25))
		part:SetStartLength(55)
		part:SetEndLength(1)
		part:SetColor( 255, 235, 215 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 355))
		part:SetCollide(false)
	end
	for i=0, 5 do
		local part = emit:Add ("hexgm/sprites/hexbit08", data:GetOrigin() + Vector( math.Rand( -100, 100 ), math.Rand( -100, 100 ), math.Rand( -135, 135 ) ))
		part:SetVelocity(VectorRand()* Vector( math.Rand( -25, 25 ), math.Rand( -25, 25 ), 255 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(1,2))
		part:SetStartSize(math.random(5,15))
		part:SetColor( 215, 155, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 255))
		part:SetCollide(false)
	end
	for i=0, 5 do
		local part = emit:Add ("hexgm/sprites/hexbit08", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -755, 755 ), math.Rand( -755, 755 ), 755 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartLength(50)
		part:SetEndLength(1)
		part:SetDieTime(1)
		part:SetStartSize(math.random(15,25))
		part:SetColor( 215, 155, 255 ) 
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