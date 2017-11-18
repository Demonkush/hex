AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/Gibs/HGIBS.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 255, 255, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
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
	self:SetVelocity(self:GetVelocity()*100)
end

function ENT:Explode()

	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "fx_hex_bowblast02", fx )
	self.Entity:EmitSound( "wc3sound/FrostImpact.wav", 100, math.random(85,95) )

	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 85 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(15,20) )
			dmginfo:SetDamageElement("frost")
			v:TakeDamageInfo( dmginfo )

			local cts = math.random(1,10)	
			if v:IsPlayer() then
				if cts >= 6 then
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

		-- Rocket-jumpish
		if v:IsPlayer() then
			v:SetVelocity((v:GetPos()-self:GetPos())*7)
		end
	end


	self:Remove()

end



function ENT:PhysicsCollide( data, phys )
	self:Explode()
end

function ENT:OnRemove()

end