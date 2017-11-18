function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 1 do
		local part = emit:Add ("hexgm/sprites/hexbit01", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.2)
		part:SetStartSize(100)
		part:SetColor( 155, 215, 255 ) 
		part:SetEndSize(0)
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
		part:SetColor( 25, 55, 75 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=1, 359, 15 do
		local sini = math.sin(i)
		local cosi = math.cos(i)
		local part = emit:Add ("hexgm/sprites/hexbit06", data:GetOrigin() )
		part:SetVelocity(Vector(256 * sini, 256 * cosi, 0))
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(1,2))
		part:SetStartSize(math.random(35,45))
		part:SetColor( 155, 215, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(15)
		part:SetGravity(Vector(0, 0, 15))
		part:SetCollide(false)
	end
	for i=0, 25 do
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin() )
		part:SetVelocity(Vector(math.random(-100,100), math.random(-100,100), 0)*3)
		part:SetStartAlpha(50)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(3,4))
		part:SetStartSize(math.random(35,45))
		part:SetColor( 155, 215, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(55)
		part:SetGravity(Vector(0, 0, 15))
		part:SetCollide(false)
	end
	for i=1, 359, 2 do
		local sini = math.sin(i)
		local cosi = math.cos(i)
		local part = emit:Add ("hexgm/sprites/hexbit04", data:GetOrigin() )
		part:SetVelocity(Vector(256 * sini, 256 * cosi, 0))
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetDieTime(math.random(0.5,1))
		part:SetStartSize(math.random(35,45))
		part:SetColor( 155, 215, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(15)
		part:SetGravity(Vector(0, 0, 15))
		part:SetCollide(false)
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end