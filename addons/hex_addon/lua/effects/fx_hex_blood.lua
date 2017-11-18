function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 25 do
		local part = emit:Add ("hexgm/sprites/hexbit09", data:GetOrigin())
		part:SetVelocity(VectorRand()*100+Vector(0,0,55))
		part:SetDieTime(5)
		part:SetStartSize(15)
		part:SetColor( 255, 55, 55 ) 
		part:SetEndSize(5)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -555))
		part:SetCollide(true)
	end
	for i=0, 15 do
		local part = emit:Add ("hexgm/sprites/hexbit09", data:GetOrigin())
		part:SetVelocity(VectorRand()*55+Vector(0,0,55))
		part:SetDieTime(7)
		part:SetStartSize(15)
		part:SetColor( 75, 25, 25 ) 
		part:SetEndSize(10)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -555))
		part:SetCollide(true)
	end

	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end