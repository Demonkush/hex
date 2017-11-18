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
		util.SpriteTrail(self.Entity, 0, Color(215, 115, 255, 55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
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
	util.Effect( "fx_hex_staffblast02", fx )
	self.Entity:EmitSound( "wc3sound/exp/WandOfIllusionTarget1.wav", 85, math.random(75,85) )



	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 100 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(10,15) )
			dmginfo:SetDamageElement("magic")
			v:TakeDamageInfo( dmginfo )

			local cts = math.random(1,10)
			if cts >= 7 then
				if v:IsPlayer() then
					self:EmitSound("wc3sound/exp/SoulBurn1.wav")
					v:BuffManaDrain( self:GetOwner(), 1, 5, 2 )
				end
			end
		end
	end


	self:Remove()

end

function ENT:PhysicsCollide( data, phys )
	self:Explode()
end

function ENT:OnRemove()

end