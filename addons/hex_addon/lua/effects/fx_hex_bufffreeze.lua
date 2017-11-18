function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit06", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(3)
		part:SetStartSize(100)
		part:SetStartAlpha(55)
		part:SetColor( 55, 65, 75 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 25 do
		local part = emit:Add ("hexgm/sprites/hexbit06", data:GetOrigin() + Vector(0,0,math.random(-64,64)) )
		part:SetVelocity(VectorRand()* Vector( math.Rand( -55, 55 ), math.Rand( -55, 55 ), 75 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(1,1.5))
		part:SetStartSize(math.random(10,15))
		part:SetColor( 185, 215, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(math.random(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(5)
		part:SetGravity(Vector(0, 0, -256))
		part:SetCollide(true)
	end
	for i=0, 15 do
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin() + Vector(0,0,math.random(-32,32)) )
		part:SetVelocity(VectorRand()* Vector( math.Rand( -255, 255 ), math.Rand( -255, 255 ), 255 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(1,1.5))
		part:SetStartSize(math.random(5,35))
		part:SetColor( 185, 215, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(5)
		part:SetGravity(Vector(0, 0, -256))
		part:SetCollide(true)
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end