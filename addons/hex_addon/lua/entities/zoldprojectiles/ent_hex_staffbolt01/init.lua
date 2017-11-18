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
		util.SpriteTrail(self.Entity, 0, Color(55, 155, 255, 55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
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
end

function ENT:Think()
end

function ENT:Explode()

	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "fx_hex_staffblast01", fx )
	self.Entity:EmitSound( "wc3sound/exp/FarseerMissile.wav", 85, math.random(105,115) )

	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 155 )) do
		if v != self:GetOwner() then
			local dmg = 10
			dmg = math.random(8,16)

			for _, x in ipairs(ents.FindInSphere( self:GetPos(), 55 )) do
				if x == v then
					dmg = dmg*2
				end
			end

			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( dmg )
			dmginfo:SetDamageElement("storm")
			v:TakeDamageInfo( dmginfo )

			local cts = math.random(1,10)
			if cts >= 8 then
				if v:IsPlayer() then
					v:BuffStun(self:GetOwner(),math.random(1,2))
				end
			end
		end

		if v:IsPlayer() then
			v:SetVelocity((v:GetPos()-self:GetPos())+Vector(0,0,55)*7)
		end
	end


	self:Remove()

end

function ENT:PhysicsCollide( data, phys )
	self:Explode()
end

function ENT:OnRemove()

end