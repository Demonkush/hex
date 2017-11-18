AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/morrowind/nordic/hammer/w_nordic_hammer.mdl" )
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
			phys:SetMass(50)
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
	util.Effect( "fx_hex_hammerblast01", fx )
	self.Entity:EmitSound( "wc3sound/exp/LightningShieldTarget.wav", 85, math.random(95,115) )

	self.tes = ents.Create( "point_tesla" )
	self.tes:SetPos( self:GetPos() )
	self.tes:SetKeyValue( "m_SoundName", "" )
	self.tes:SetKeyValue( "texture", "sprites/bluelaser1.spr" )
	self.tes:SetKeyValue( "m_Color", "100 100 100" )
	self.tes:SetKeyValue( "m_flRadius", "200" )
	self.tes:SetKeyValue( "beamcount_min", "2" )
	self.tes:SetKeyValue( "beamcount_max", "3" )
	self.tes:SetKeyValue( "thick_min", "16" )
	self.tes:SetKeyValue( "thick_max", "32" )
	self.tes:SetKeyValue( "lifetime_min", "0.3" )
	self.tes:SetKeyValue( "lifetime_max", "0.5" )
	self.tes:SetKeyValue( "interval_min", "0.1" )
	self.tes:SetKeyValue( "interval_max", "0.3" )
	self.tes:Spawn()
	self.tes:Fire( "DoSpark", "", 0.1 )
	self.tes:Fire( "DoSpark", "", 0.3 )
	self.tes:Fire( "DoSpark", "", 0.5 )
	self.tes:Fire( "kill", "", 0.6 )

	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 175 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(22,26) )
			dmginfo:SetDamageElement("storm")
			v:TakeDamageInfo( dmginfo )

			local cts = math.random(1,10)	
			if cts >= 5 then
				if v:IsPlayer() then
					v:BuffStun(self:GetOwner(),0.5,5)
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