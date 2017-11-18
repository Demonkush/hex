function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.2)
		part:SetStartSize(155)
		part:SetColor( 255, 235, 215 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit12", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.5)
		part:SetStartSize(155)
		part:SetStartAlpha(55)
		part:SetColor( 155, 75, 135 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=1, 360, 7 do
		local sini = math.sin(i)
		local cosi = math.cos(i)
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin())
		part:SetVelocity(Vector(256 * sini, 256 * cosi, 0))
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(1,2))
		part:SetStartSize(math.random(15,25))
		part:SetColor( 235, 185, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 55))
		part:SetCollide(false)
	end
	for i=0, 25 do
		local part = emit:Add ("hexgm/sprites/hexbit08", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -555, 555 ), math.Rand( -555, 555 ), 555 ))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetStartLength(50)
		part:SetEndLength(1)
		part:SetDieTime(1)
		part:SetStartSize(math.random(15,25))
		part:SetColor( 215, 155, 255 ) 
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