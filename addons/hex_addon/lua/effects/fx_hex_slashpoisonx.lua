function EFFECT:Init(data)
	local ang = data:GetAngles()
	local pos = data:GetOrigin()
	local emit = ParticleEmitter(data:GetOrigin())

	for i=1, 5 do
		local part = emit:Add ("hexgm/sprites/hexbit04", pos + Vector(math.random(-35,35),math.random(-35,35),math.random(-35,35)))
		part:SetVelocity(Vector(25,25,25))
		part:SetDieTime(3)
		part:SetStartSize(15)
		part:SetStartAlpha(55)
		part:SetColor( 75, 95, 25 ) 
		part:SetEndSize(0)
		part:SetRoll(math.random(0,360))
		part:SetRollDelta(math.random(-1,1))
		part:SetAirResistance(155)
		part:SetGravity(Vector(0, 0, -55))

		local part = emit:Add ("hexgm/sprites/hexbit07", pos + Vector(math.random(-25,25),math.random(-25,25),math.random(-25,25)))
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