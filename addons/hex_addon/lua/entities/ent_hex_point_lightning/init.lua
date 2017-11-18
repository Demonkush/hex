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

	self:Explode()

	timer.Simple(10,function() if IsValid(self) then self:Remove() end end)
	self:SetNWString("ProjectilePower","normal")
end

function ENT:SetPower(output)
	self:SetNWString("ProjectilePower",output)
end
function ENT:GetPower()
	return self:GetNWString("ProjectilePower")
end

function ENT:Explode()
	if self:GetPower() == "low" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(1.5)	
		util.Effect("fx_hex_stormblast01",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(1)
		fx2:SetAngles(Angle(155,215,255))
		util.Effect("fx_hex_model_blast",fx2)
	end
	if self:GetPower() == "normal" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(2)	
		util.Effect("fx_hex_stormblast01",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(1.5)
		fx2:SetAngles(Angle(155,215,255))
		util.Effect("fx_hex_model_blast",fx2)
	end
	if self:GetPower() == "high" then
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(2.5)	
		util.Effect("fx_hex_stormblast01",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(2)
		fx2:SetAngles(Angle(155,215,255))
		util.Effect("fx_hex_model_blast",fx2)
	end
	self:Remove()
end

function ENT:OnRemove()

end