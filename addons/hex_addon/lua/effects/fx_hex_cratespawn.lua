function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit14", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.2)
		part:SetStartSize(75)
		part:SetStartAlpha(55)
		part:SetColor( 255, 155, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 256))
	end
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.5)
		part:SetStartSize(55)
		part:SetStartAlpha(55)
		part:SetColor( 75, 55, 25 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 512))
	end
	for i=0, 5 do
		local part = emit:Add ("hexgm/sprites/hexbit08", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -255, 255 ), math.Rand( -255, 255 ), 100 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartLength(35)
		part:SetEndLength(1)
		part:SetDieTime(0.5)
		part:SetStartSize(math.random(15,25))
		part:SetColor( 215, 155, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 512))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end