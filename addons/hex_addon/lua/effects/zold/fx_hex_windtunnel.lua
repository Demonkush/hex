function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin() + Vector( math.random(-155,155), math.random(-155,155), 0 ) )
		part:SetVelocity(Vector(0,0,756))
		part:SetLifeTime(math.random(0,1))
		part:SetDieTime(math.random(0.5,1.5))
		part:SetStartSize(math.random(45,65))
		part:SetStartAlpha(math.random(75,155))
		part:SetColor( 155, 155, 155 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, math.random(-255,-55) ))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end