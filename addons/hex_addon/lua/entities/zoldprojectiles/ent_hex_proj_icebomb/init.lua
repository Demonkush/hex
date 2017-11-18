AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/Gibs/HGIBS.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 255, 255, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(0.2)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	
	if SERVER then
		util.SpriteTrail(self.Entity, 0, Color(55, 155, 255, 55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
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
			if self:GetPower() == "normal" then
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
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 155 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(20,30) )
			dmginfo:SetDamageElement("frost")
			v:TakeDamageInfo( dmginfo )
		end
		local cts = math.random(1,5)	
		if v:IsPlayer() then
			if cts >= 3 then
				v:BuffIce(self:GetOwner(),1,4)
			end
			if cts > 2 && cts < 3 then
				v:BuffSlow(self:GetOwner(), 3, 2 )
			end
			if cts <= 2 then
				v:BuffFreeze(self:GetOwner(), 3 )
			end
		end
	end
	self:Remove()
end
function ENT:ExplodeHigh()
	self:DoFX("high")
	self.Entity:EmitSound( "blackpowder.Boom", 100, 135 )
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 165 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(25,35) )
			dmginfo:SetDamageElement("frost")
			v:TakeDamageInfo( dmginfo )
		end
		local cts = math.random(1,5)	
		if v:IsPlayer() then
			if cts >= 3 then
				v:BuffIce(self:GetOwner(),1,4)
			end
			if cts > 2 && cts < 3 then
				v:BuffSlow(self:GetOwner(), 3, 2 )
			end
			if cts <= 2 then
				v:BuffFreeze(self:GetOwner(), 3 )
			end
		end
	end

	local randomshot = {"ent_hex_proj_frostbolt"}
	for i=1, 3 do
		local extra = ents.Create(table.Random(randomshot))
		extra:SetPos(self:GetPos())
		extra:SetOwner( self.Owner )
		extra:Spawn()

	    extra.Weapon = self.Weapon
	    extra:SetPower("normal")

	    local phys = extra:GetPhysicsObject()
	    phys:ApplyForceCenter(Vector(math.random(-255,255), math.random(-255,255), 255) * 10)
	    phys:EnableGravity(true)
	end

	self:Remove()
end

function ENT:DoFX(power)
	if power == "normal" then
		local fx = EffectData() fx:SetOrigin( self:GetPos() )	
		util.Effect( "fx_hex_frostblast02", fx )
		local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(2)	
		fx2:SetAngles(Angle(100,150,200))
		util.Effect( "fx_hex_model_blast", fx2 )
	elseif power == "high" then
		local fx = EffectData() fx:SetOrigin( self:GetPos() )
		util.Effect( "fx_hex_frostblast02", fx )
		local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(2)	
		fx2:SetAngles(Angle(100,150,200))
		util.Effect( "fx_hex_model_blast", fx2 )
	end
end

function ENT:PhysicsCollide( data, phys )
	phys:SetVelocity(self:GetVelocity()+Vector(0,0,150))
	if data.HitEntity:IsPlayer() then
		if self:GetPower() == "normal" then
			self:ExplodeNormal()
		elseif self:GetPower() == "high" then
			self:ExplodeHigh()
		end
	end
end

function ENT:OnRemove()

end