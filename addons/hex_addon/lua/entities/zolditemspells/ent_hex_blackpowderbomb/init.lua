AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/weapons/w_bomb.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 255, 255, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:SetMass(10)
		end
	end

	timer.Simple(math.random(2,3),function()
		if IsValid(self) then
			self:Explode()
		end
	end)

	self.Exploded = 0
end

function ENT:OnTakeDamage(dmg)
	if dmg:GetInflictor() != self then
		if dmg:GetDamageElement() == "fire" then
			self:Explode()
		end
	end
end

function ENT:Think()
	self:SetVelocity(self:GetVelocity()*100)
end

function ENT:Explode()
	if self.Exploded == 1 then self:Remove() return end
	self.Exploded = 0

	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "fx_hex_bombblast01", fx )
	local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(2)
	fx2:SetAngles(Angle(135,100,65))
	util.Effect( "fx_hex_model_blast", fx2 )
	self.Entity:EmitSound( "blackpowder.Boom", 100, 85 )

	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 255 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(25,30) )
			dmginfo:SetDamageElement("fire")
			v:TakeDamageInfo( dmginfo )

			local cts = math.random(1,10)	
			if cts >= 5 then
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
		end

		-- Rocket-jumpish
		if v:IsPlayer() then
			v:SetVelocity((v:GetPos()-self:GetPos())*3)
		end
	end


	self:Remove()

end

function ENT:PhysicsCollide()


end

function ENT:OnRemove()

end