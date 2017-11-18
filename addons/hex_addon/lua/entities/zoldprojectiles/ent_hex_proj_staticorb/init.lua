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
		util.SpriteTrail(self.Entity, 0, Color(100, 155, 255, 215), false, 10, 2, 0.25, 15, "trails/laser.vmt")
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

function ENT:Think()
	self:DoTesla("low")
end

function ENT:ExplodeNormal()
	self:DoTesla("normal")
	self:DoFX("normal")
	self.Entity:EmitSound( "wc3sound/exp/PurgeTarget1.wav", 100, 100 )
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 135 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(25,35) )
			dmginfo:SetDamageElement("physical")
			v:TakeDamageInfo( dmginfo )
		end
		if v:IsPlayer() then
			v:SetVelocity((v:GetPos()-self:GetPos())*3)
		end
	end

	self:Remove()
end
function ENT:ExplodeHigh()
	self:DoTesla("high")
	self:DoFX("high")
	self.Entity:EmitSound( "wc3sound/exp/PurgeTarget1.wav", 100, 85 )
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 165 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(35,45) )
			dmginfo:SetDamageElement("storm")
			v:TakeDamageInfo( dmginfo )
		end
		local cts = math.random(1,10)	
		if cts >= 3 then
			if v:IsPlayer() then
				v:BuffStun(self:GetOwner(),math.random(2,3))
			end
		end
		if v:IsPlayer() then
			v:SetVelocity((v:GetPos()-self:GetPos())*3)
		end
	end

	self:Remove()
end

function ENT:DoTesla(power)
	local radius = 200
	local color = "100 185 215"

	if power == "high" then
		radius = 350
		color = "55 55 55"
	end

	self.tes = ents.Create( "point_tesla" )
	self.tes:SetPos( self:GetPos() )
	self.tes:SetKeyValue( "m_SoundName", "" )
	self.tes:SetKeyValue( "texture", "sprites/bluelaser1.spr" )
	self.tes:SetKeyValue( "m_Color", color )
	self.tes:SetKeyValue( "m_flRadius", radius )
	self.tes:SetKeyValue( "beamcount_min", "2" )
	self.tes:SetKeyValue( "beamcount_max", "3" )
	self.tes:SetKeyValue( "thick_min", "16" )
	self.tes:SetKeyValue( "thick_max", "32" )
	self.tes:SetKeyValue( "lifetime_min", "0.3" )
	self.tes:SetKeyValue( "lifetime_max", "0.5" )
	self.tes:SetKeyValue( "interval_min", "0.1" )
	self.tes:SetKeyValue( "interval_max", "0.3" )
	self.tes:Spawn()
	self.tes:Fire( "DoSpark", "", 0 )
	if power != "low" then
		self.tes:Fire( "DoSpark", "", 0.3 )
		self.tes:Fire( "DoSpark", "", 0.5 )
	end
	self.tes:Fire( "kill", "", 0.6 )

end

function ENT:DoFX(power)
	if power == "normal" then
		local fx = EffectData() fx:SetOrigin( self:GetPos() )
		util.Effect( "fx_hex_stormblast01", fx )
		local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(1)	
		fx2:SetAngles(Angle(100,150,255))
		util.Effect( "fx_hex_model_blast", fx2 )
	elseif power == "high" then
		local fx = EffectData() fx:SetOrigin( self:GetPos() )
		util.Effect( "fx_hex_stormblast01", fx )
		local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(2)	
		fx2:SetAngles(Angle(55,55,55))
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