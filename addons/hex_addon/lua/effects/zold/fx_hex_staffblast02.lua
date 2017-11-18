function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.5)
		part:SetStartSize(5)
		part:SetColor( 115, 75, 255 ) 
		part:SetEndSize(85)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(3)
		part:SetStartSize(100)
		part:SetStartAlpha(55)
		part:SetColor( 25, 55, 95 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 35 do
		local part = emit:Add ("hexgm/sprites/hexbit08", data:GetOrigin() + Vector( math.Rand( -55, 115 ), math.Rand( -55, 115 ), math.Rand( -55, 115 ) ))
		part:SetVelocity(VectorRand()* Vector( math.Rand( -100, 100 ), math.Rand( -100, 100 ), -100 ))
		part:SetStartAlpha(0)
		part:SetEndAlpha(50)
		part:SetDieTime(math.random(1,2))
		part:SetStartSize(math.random(5,10))
		part:SetColor( math.random(55,175), 115, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -128))
		part:SetCollide(false)
	end
	for i=0, 15 do
		local part = emit:Add ("hexgm/sprites/hexbit09", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -100, 100 ), math.Rand( -100, 100 ), 100 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(1)
		part:SetStartSize(math.random(35,45))
		part:SetColor( 115, 115, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end