AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_junk/rock001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 255, 255, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(0.1)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end
	end


    local tr = {}
    tr.start = self:GetPos()
    tr.endpos = self:GetPos()+Vector(0,0,750)
    tr.mask = MASK_SOLID_BRUSHONLY
    local trace = util.TraceLine(tr)

    self:SetPos(trace.HitPos)

	timer.Simple(0.01,function()
		if IsValid(self) then
			local fx = EffectData()
			fx:SetOrigin( self:GetPos() )
			util.Effect( "fx_hex_staffblast04", fx )

			if SERVER then
				util.SpriteTrail(self.Entity, 0, Color(255, 255, 255, 55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
			end
		end
	end)
		

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
	util.Effect( "fx_hex_cometblast", fx )
	self.Entity:EmitSound( "wc3sound/exp/PandarenUltimate.wav", 95, math.random(125,135) )



	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 195 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(24,28) )
			dmginfo:SetDamageElement("light")
			v:TakeDamageInfo( dmginfo )
		end
	end


	self:Remove()

end

function ENT:PhysicsCollide( data, phys )
	self:Explode()
end

function ENT:OnRemove()

end