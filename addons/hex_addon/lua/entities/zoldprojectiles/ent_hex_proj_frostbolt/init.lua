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
		util.SpriteTrail(self.Entity, 0, Color(55, 215, 255, 55), false, 10, 2, 0.25, 15, "trails/laser.vmt")
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

	self:SetNWString("ProjectilePower","normal")
end

function ENT:SetPower(output)
	self:SetNWString("ProjectilePower",output)
end
function ENT:GetPower()
	return self:GetNWString("ProjectilePower")
end

function ENT:ExplodeLow()
	self:DoFX("low")
	self.Entity:EmitSound( "wc3sound/FrostImpact.wav", 75, math.random(125,130) )
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 85 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(10,14) )
			dmginfo:SetDamageElement("frost")
			v:TakeDamageInfo( dmginfo )
		end
	end
	self:Remove()
end
function ENT:ExplodeNormal()
	self:DoFX("normal")
	self.Entity:EmitSound( "wc3sound/FrostImpact.wav", 75, math.random(115,120) )
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 105 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(12,17) )
			dmginfo:SetDamageElement("frost")
			v:TakeDamageInfo( dmginfo )
		end
		local cts = math.random(1,10)	
		if v:IsPlayer() then
			if cts >= 6 then
				v:BuffIce(self:GetOwner(),1,4)
			end
			if cts > 2 && cts < 6 then
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
	self.Entity:EmitSound( "wc3sound/FrostImpact.wav", 75, math.random(110,115) )
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 125 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( math.random(14,21) )
			dmginfo:SetDamageElement("frost")
			v:TakeDamageInfo( dmginfo )
		end
		local cts = math.random(1,5)	
		if v:IsPlayer() then
			if cts >= 3 then
				v:BuffIce(self:GetOwner(),1,4)
			end
			if cts > 2 && cts < 6 then
				v:BuffSlow(self:GetOwner(), 3, 2 )
			end
			if cts <= 2 then
				v:BuffFreeze(self:GetOwner(), 3 )
			end
		end
	end
	self:Remove()
end

function ENT:DoFX(power)
	if power == "low" then
		local fx = EffectData() fx:SetOrigin( self:GetPos() ) fx:SetScale(0.5)	
		util.Effect( "fx_hex_frostblast01", fx )
	elseif power == "normal" then
		local fx = EffectData() fx:SetOrigin( self:GetPos() ) fx:SetScale(1.5)	
		util.Effect( "fx_hex_frostblast01", fx )
		local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(1)	
		fx2:SetAngles(Angle(100,150,200))
		util.Effect( "fx_hex_model_blast", fx2 )
	elseif power == "high" then
		local fx = EffectData() fx:SetOrigin( self:GetPos() ) fx:SetScale(2)	
		util.Effect( "fx_hex_frostblast01", fx )
		local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(1.5)
		fx2:SetAngles(Angle(100,150,200))
		util.Effect( "fx_hex_model_blast", fx2 )
	end
end

function ENT:PhysicsCollide( data, phys )
	if self:GetPower() == "low" then
		self:ExplodeLow()
	elseif self:GetPower() == "normal" then
		self:ExplodeNormal()
	elseif self:GetPower() == "high" then
		self:ExplodeHigh()
	end
end

function ENT:OnRemove()

end