function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit08", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.5)
		part:SetStartSize(35)
		part:SetStartAlpha(75)
		part:SetColor( 155, 55, 55 ) 
		part:SetEndSize(0)
		local r = math.random(1,2)
		if r == 2 then
			part:SetStartSize(15)
			part:SetDieTime(1)
			part:SetRollDelta(math.random(-2,2))
			part:SetVelocity(Vector(math.random(-128,128),math.random(-128,128),math.random(-128,128)))
		end
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 5 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin() + Vector(0,0,math.random(-32,32)) )
		part:SetVelocity(VectorRand()* Vector( math.Rand( -175, 175 ), math.Rand( -175, 175 ), 75 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(0.5)
		part:SetStartSize(math.random(25,35))
		part:SetColor( 185, 55, 55 ) 
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