function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(3)
		part:SetStartSize(45)
		part:SetStartAlpha(55)
		part:SetColor( 75, 95, 25 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 10 do
		local part = emit:Add ("hexgm/sprites/hexbit07", data:GetOrigin() + Vector(0,0,math.random(-32,32)) )
		part:SetVelocity(VectorRand()* Vector( math.Rand( -75, 75 ), math.Rand( -75, 75 ), 75 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(1,1.5))
		part:SetStartSize(math.random(3,7))
		part:SetColor( 185, 255, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(math.random(-1,1))
		part:SetAirResistance(0)
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