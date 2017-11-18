AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_junk/rock001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 55, 55, 255 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(1)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )
	self:SetUseType( SIMPLE_USE )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end
	end

	self:SetMaterial("hexgm/shaders/hexshiny")
	
	self.Sent = false

	timer.Simple(20,function() if IsValid(self) then self:Remove() end end)
end

function ENT:Think()
end

function ENT:Touch(act)
	if !act:IsPlayer() then return end
	if self.Sent == true then return end
	self.Sent = true

	local hp = HEX.MOD.HealthDropAmount

	self:EmitSound("wc3sound/exp/WandOfIllusionTarget1.wav",65,math.random(115,125))

	act:AddHP(hp)
	
	if SERVER then
		--HexMsg(act,"Pickup","+"..hp.." Health",Vector(215,115,115),false)
		HEX.SendNotification(act,Color(215,115,115),255,"+"..hp.." Health",false)
	end
	self:Remove()
end

function ENT:OnRemove()

end