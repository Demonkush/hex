AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_junk/rock001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 175, 55, 255 ))
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

	self.Gold = self.Gold or 5
	self.Sent = false

	self.Bounce = 3

	timer.Simple(20,function() if IsValid(self) then self:Remove() end end)
end

function ENT:Think()
end

function ENT:PhysicsCollide( data, phys )
	 if data.HitEntity:IsWorld() then
	 	local vel = phys:GetVelocity()
		if self.Bounce >= 1 then
	 		phys:SetVelocity( vel + Vector( 0, 0, math.random(100,155) ) )
	 		self.Bounce = self.Bounce - 1
		end
	 end
end

function ENT:Touch(act)
	if !act:IsPlayer() then return end
	if self.Sent == true then return end
	self.Sent = true
	
	self:EmitSound("wc3sound/exp/ReceiveGold.wav",100,115)
	act:AddGold(self.Gold)
	if SERVER then
		--HexMsg(act,"Pickup","+" .. self.Gold .. " Gold",Vector(215,185,115),false)
		HEX.SendNotification(act,Color(215,185,115),255,"+" .. self.Gold .. " Gold",false)
	end
	self:Remove()
end

function ENT:OnRemove()

end