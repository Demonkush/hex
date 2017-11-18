function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local angle = data:GetNormal()
	local pos = data:GetOrigin()

	pos = pos - angle * 2

	for i=0, 35 do
		local part = emit:Add ("hexgm/sprites/hexbit14", data:GetOrigin() + (VectorRand()*100) )
		part:SetVelocity(angle*2048)
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartAlpha(25)
		part:SetDieTime(1)
		part:SetStartSize(math.random(55,95))
		part:SetColor( 155, 155, 155 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(100)
		part:SetGravity(Vector(0, 0, 0))
		part:SetCollide(true)
		part:SetBounce(1)
	end

	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end