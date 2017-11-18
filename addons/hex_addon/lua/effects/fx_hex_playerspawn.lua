function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 25 do
		local part = emit:Add ("Sprites/glow04_noz", data:GetOrigin())
		part:SetVelocity(Vector(0,0,math.random(-255,255)))
		part:SetStartAlpha(50)
		part:SetDieTime(0.5)
		part:SetStartSize(256)
		part:SetColor( 55, 155, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 15 do
		local part = emit:Add ("Sprites/glow04_noz", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -155, 155 ), math.Rand( -155, 155 ), 155 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(5)
		part:SetStartSize(math.random(5,15))
		part:SetColor( 155, 215, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 255))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end