AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:SetModel("models/hunter/blocks/cube075x2x075.mdl")
		self:PhysicsInit(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		self:SetColor(Color(255,215,155))
		self:DrawShadow(false)

		self:SetAngles(Angle(0,0,90))
		timer.Simple(0.1,function()
			if IsValid(self) then
				self:SetPos(self:GetPos()+Vector(0,0,32))
			end
		end)
	end

	self:SetCollisionGroup(COLLISION_GROUP_NONE)

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	self.Sent = false

	self.NextScan = 0

	self:SetNWString("Powerup","vampirism")
	self:SetNWString("PowerupName","Vampirism")
	self:SetNWString("PowerupImage","hexgm/ui/elements/blood.png")

	timer.Simple(60,function() if IsValid(self) then self:Remove() end end)
end

function ENT:PowerupPickup(ply)
	local function MatchPoweruptoTable(t)
		for a, b in pairs(HEX.PowerupTable) do
			if t == b.id then
				return a
			end
		end
	end
	self:EmitSound("wc3sound/exp/windwalk.wav",75,150)
	HEX.PowerupTable[MatchPoweruptoTable(self:GetNWString("Powerup"))].init(ply,10)
	self:Remove()
end

function ENT:SetItemInfo(powerup)
	self:SetNWString("Powerup",powerup)

	local function MatchPoweruptoTable(t)
		for a, b in pairs(HEX.PowerupTable) do
			if t == b.id then
				return a
			end
		end
	end
	self:SetNWString("PowerupName",HEX.PowerupTable[MatchPoweruptoTable(powerup)].name)
	self:SetNWString("PowerupImage",HEX.PowerupTable[MatchPoweruptoTable(powerup)].image)
	self:SetColor(HEX.PowerupTable[MatchPoweruptoTable(powerup)].color)
end

function ENT:SetRandomItemInfo()
	local function RandomPowerup(t)
		local rand = math.random(1,#HEX.PowerupTable)
		return rand
	end
	local randitem = RandomPowerup()
	self:SetNWString("Powerup",HEX.PowerupTable[randitem].id)
	self:SetNWString("PowerupName",HEX.PowerupTable[randitem].name)
	self:SetNWString("PowerupImage",HEX.PowerupTable[randitem].image)
	self:SetColor(HEX.PowerupTable[randitem].color)
end

function ENT:Think()
	if self.NextScan < CurTime() then
		for a, b in pairs(ents.FindInSphere(self:GetPos(),64)) do
			if b:IsPlayer() && b:Alive() then
				self:PowerupPickup(b)
				local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(0.5)
				fx2:SetAngles(Angle(85,85,85))
				util.Effect( "fx_hex_model_blast", fx2 )
			end
		end
		self.NextScan = CurTime() + 0.5
	end
end

function ENT:OnRemove()

end