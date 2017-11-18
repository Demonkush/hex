AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/weapons/W_missile_launch.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 255, 255, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(0.2)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	
	-- Sprite Trail Effect
	if SERVER then
		util.SpriteTrail(self.Entity, 0, Color(215, 255, 155, 55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
	end

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end
	end

	timer.Simple(10,function()
		if IsValid(self) then
			self:Remove()
		end
	end)

	self.Bounce = 2
	self.Exploded = 0
end

function ENT:Think()
end

function ENT:Explode()
	if self.Exploded == 1 then self:Remove() return end
	self.Exploded = 1
	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "fx_hex_wandblast02", fx )
	self.Entity:EmitSound( "wc3sound/NecromancerMissileHit3.wav", 75, math.random(125,130) )

	self.tes = ents.Create( "point_tesla" )
	self.tes:SetPos( self:GetPos() )
	self.tes:SetKeyValue( "m_SoundName", "" )
	self.tes:SetKeyValue( "texture", "sprites/laserbeam.spr" )
	self.tes:SetKeyValue( "m_Color", "215 255 155" )
	self.tes:SetKeyValue( "m_flRadius", "125" )
	self.tes:SetKeyValue( "beamcount_min", "2" )
	self.tes:SetKeyValue( "beamcount_max", "2" )
	self.tes:SetKeyValue( "thick_min", "16" )
	self.tes:SetKeyValue( "thick_max", "32" )
	self.tes:SetKeyValue( "lifetime_min", "0.3" )
	self.tes:SetKeyValue( "lifetime_max", "0.5" )
	self.tes:SetKeyValue( "interval_min", "0.1" )
	self.tes:SetKeyValue( "interval_max", "0.3" )
	self.tes:Spawn()
	self.tes:Fire( "DoSpark", "", 0.1 )
	self.tes:Fire( "kill", "", 0.6 )

	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 90 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(5,8) )
			dmginfo:SetDamageElement("nature")
			v:TakeDamageInfo( dmginfo )


			local cts = math.random(1,100)	
			if cts >= 80 then
				if v:IsPlayer() then
					v:BuffSlow(self:GetOwner(),math.random(2,3),5)
				end
			end
		end
	end
	self:Remove()

end

function ENT:Touch()
	self:Explode()
end

function ENT:PhysicsCollide( data, phys )
	local rand = math.random(1,3)
	if rand > 2 then
		self:Explode()
	end
	if rand <= 2 then
		if self.Bounce < 1 then
			self:Explode()
		end
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:AddVelocity( Vector( 0,0,150 ) )
		end
		self.Bounce = self.Bounce - 1
	end
end

function ENT:OnRemove()

end