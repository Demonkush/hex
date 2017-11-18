function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 5 do
		local part = emit:Add ("hexgm/sprites/hexbit12", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.2)
		part:SetStartSize(1)
		part:SetStartAlpha(math.random(5,15))
		part:SetColor( 55, 215, 255 ) 
		part:SetEndSize(math.random(100,300))
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbitstorm", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.4)
		part:SetStartSize(1)
		part:SetStartAlpha(15)
		part:SetColor( 155, 215, 255 ) 
		part:SetEndSize(math.random(95,115))
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 5 do
		local part = emit:Add ("hexgm/sprites/hexbitstatic", data:GetOrigin()+VectorRand()*115)
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(1)
		part:SetStartSize(200)
		part:SetStartAlpha(55)
		part:SetColor( 215, 235, 255 ) 
		part:SetEndSize(200)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=1, 359, 4 do
		local sini = math.sin(i)
		local cosi = math.cos(i)
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin() )
		part:SetVelocity(Vector(756 * sini, 756 * cosi, 0))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(0.5)
		part:SetStartSize(math.random(65,75))
		part:SetColor( 215, 235, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(math.random(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 25 do
		local part = emit:Add ("hexgm/sprites/hexbit08", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -755, 755 ), math.Rand( -755, 755 ), 455 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartLength(55)
		part:SetEndLength(1)
		part:SetDieTime(1)
		part:SetStartSize(math.random(15,25))
		part:SetColor( 215, 235, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -155))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end