AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/Gibs/HGIBS.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 0, 0, 0, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(0.2)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	
	-- Sprite Trail Effect
	if SERVER then
		util.SpriteTrail(self.Entity, 0, Color(155, 155, 155, 55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
	end

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end
	end

	timer.Simple(2,function()
		if IsValid(self) then
			if self:GetPower() == "low" or self:GetPower() == "normal" then
				self:ExplodeNormal()
			elseif self:GetPower() == "high" then
				self:ExplodeHigh()
			end
		end
	end)

	self:SetNWString("ProjectilePower","normal")
end

function ENT:SetPower(output)
	self:SetNWString("ProjectilePower",output)
end
function ENT:GetPower()
	return self:GetNWString("ProjectilePower")
end

function ENT:ExplodeNormal()
	self:DoFX("normal")
	self.Entity:EmitSound( "blackpowder.Boom", 100, 85 )
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 128 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(18,22) )
			dmginfo:SetDamageElement("physical")
			v:TakeDamageInfo( dmginfo )
		end
		if v:IsPlayer() then
			local dist = v:GetPos()-self:GetPos()
			v:SetVelocity(dist*3)
		end
	end

	self:Remove()
end
function ENT:ExplodeHigh()
	self:DoFX("high")
	self.Entity:EmitSound( "blackpowder.Boom", 100, 135 )
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 155 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(24,28) )
			dmginfo:SetDamageElement("fire")
			v:TakeDamageInfo( dmginfo )
		end
		local cts = math.random(1,5)	
		if cts >= 3 then
			if v:IsPlayer() then
				v:BuffFire(self:GetOwner(),0.5,5)
			end
		end
		if v:IsNPC() then
			v:Ignite(3)
		end
		if v:GetClass() == "prop_physics" then
			v:Ignite(3)
		end
		if v:IsPlayer() then
			v:SetVelocity((v:GetPos()-self:GetPos())*4)
		end
	end

	-- Fragmentation
	for i=1, 25 do
	    local frag = {}
	    frag.Num      = 1
	    frag.Src      = self:GetPos()
	    frag.Dir      = AngleRand()
	    frag.Spread   = Vector(1, 1, 1)
	    frag.Tracer   = 1
	    frag.TracerName = "fx_hex_tracergun"
	    frag.Force    = 50
	    frag.Damage   = 25
	    frag.Callback = function(ent,tr,dmg)
	        self:ImpactEffect(tr)
	    end
	    self:FireBullets(frag)
	end
	self:Remove()
end

function ENT:ImpactEffect(trace)
    local hitpos = trace.HitPos
    local scale = 0.5

    local fx = EffectData()
    fx:SetOrigin( hitpos )
    fx:SetScale( scale )
    util.Effect( "fx_hex_gunpoof01", fx )
end

function ENT:DoFX(power)
	if power == "normal" then
		local fx = EffectData() fx:SetOrigin( self:GetPos() ) fx:SetScale(1.5)	
		util.Effect( "fx_hex_gunpoof01", fx )
		local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(1)	
		fx2:SetAngles(Angle(155,125,125))
		util.Effect( "fx_hex_model_blast", fx2 )
	elseif power == "high" then
		local fx = EffectData() fx:SetOrigin( self:GetPos() ) fx:SetScale(2)	
		util.Effect( "fx_hex_gunpoof01", fx )
		util.Effect( "fx_hex_fireblast01", fx )
		local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(1.5)
		fx2:SetAngles(Angle(155,125,125))
		util.Effect( "fx_hex_model_blast", fx2 )
	end
end

function ENT:PhysicsCollide( data, phys )
	phys:SetVelocity(self:GetVelocity()+Vector(0,0,150))
	if self:GetPower() == "low" or self:GetPower() == "normal" then
		self:ExplodeNormal()
	elseif self:GetPower() == "high" then
		self:ExplodeHigh()
	end
end

function ENT:OnRemove()

end