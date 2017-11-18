function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 15 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin())
		part:SetVelocity(VectorRand()*555+Vector(0,0,255))
		part:SetDieTime(0.3)
		part:SetStartSize(250)
		part:SetColor( 255, 125, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 255))
	end
	for i=0, 3 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(3)
		part:SetStartSize(120)
		part:SetStartAlpha(55)
		part:SetColor( 75, 55, 25 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 25 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin() + (VectorRand()*55))
		part:SetVelocity(VectorRand()* Vector( math.Rand( -755, 755 ), math.Rand( -755, 755 ), 555 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(1,2))
		part:SetStartSize(math.random(25,55))
		part:SetColor( 255, 95, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(75)
		part:SetGravity(Vector(0, 0, -512))
		part:SetCollide(true)
	end
	for i=0, 55 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin() + (VectorRand()*55))
		part:SetVelocity(VectorRand()* Vector( math.Rand( -1555, 1555 ), math.Rand( -1555, 1555 ), 755 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(0.7,1))
		part:SetStartSize(math.random(55,85))
		part:SetColor( 255, 125, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(math.random(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(75)
		part:SetGravity(Vector(0, 0, -256))
		part:SetCollide(false)
	end
	for i=0, 25 do
		local part = emit:Add ("hexgm/sprites/hexbit08", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -1755, 1755 ), math.Rand( -1755, 1755 ), 1000 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartLength(35)
		part:SetEndLength(1)
		part:SetDieTime(2)
		part:SetStartSize(math.random(45,55))
		part:SetColor( 215, 155, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(75)
		part:SetGravity(Vector(0, 0, -512))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end