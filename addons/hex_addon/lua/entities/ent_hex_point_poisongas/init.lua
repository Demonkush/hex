AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_junk/rock001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_NONE )
end

function ENT:Explode(time)
	self.Enabled = true
	timer.Simple(time,function()
		self:Remove()
	end)
end

function ENT:Gas()
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),175)) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(math.random(2,4))
			dmginfo:SetDamageElement("poison")
			v:TakeDamageInfo(dmginfo)
		end
		local r = math.random(1,50)
		if r > 25 then
			if v:IsPlayer() then
				v:BuffPoison(self:GetOwner(),2,5)
			end
		end
	end
	local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(1)	
	util.Effect("fx_hex_poisoncloud",fx)
end

function ENT:Think()
	if self.Enabled == true then
		self:Gas()
	end
	self:NextThink(CurTime()+1)
	return true
end

function ENT:OnRemove()
end