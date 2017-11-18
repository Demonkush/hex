function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 5 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -512, 512 ), math.Rand( -512, 512 ), 25 ))
		part:SetDieTime(0.5)
		part:SetStartSize(25)
		part:SetStartAlpha(55)
		part:SetColor( 155, 55, 55 ) 
		part:SetEndSize(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 25 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin() + Vector(0,0,math.random(-32,32)) )
		part:SetVelocity(VectorRand()* Vector( math.Rand( -512, 512 ), math.Rand( -512, 512 ), 25 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(0.5)
		part:SetStartSize(math.random(2,3))
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