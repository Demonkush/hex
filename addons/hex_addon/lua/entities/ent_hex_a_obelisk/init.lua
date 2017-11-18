AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetUseType( SIMPLE_USE )
	self:SetModel( "models/hex/obelisk.mdl" )
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetColor( Color( 255, 255, 255 ) )
	self:DrawShadow( false )

	timer.Simple(0.1,function()
		if IsValid(self) then
			self:SetPos(self:GetPos()+Vector(0,0,80))
		end
	end)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end

	if HEX.Gametype == "Mountain Man" then
		self.MountainMan = nil
		self.Contested = false
		self.CapturePower = 0
		self.CapturePowerMax = 50
		self.ResetDelay = 0 -- time before it reverts to no owner
	end
	
	if HEX.Gametype == "Conquest" then
		self.PlyTable = {}
		self.Contested = false
		self.OwningTeam = -1
		self.CapturingTeam = -1
		self.CapturePower = 0
		self.CapturePowerMax = 250
		self.CaptureRate = 1

		self.FriendlyNum = 0
		self.EnemyNum = 0
	end

	self.ThinkTick = 0
end

function ENT:Think()
	if HEX.Round.RoundState == 1 then

		if self.ThinkTick < CurTime() then

			if HEX.Gametype == "Mountain Man" then
				self:DoMountainManThink()
			end

			if HEX.Gametype == "Conquest" then
				self:DoConquestThink()

				if self.CapturingTeam != -1 then
					self.CapturePower = self.CapturePower + ( self.CaptureRate + math.Clamp( ( self.EnemyNum - self.FriendlyNum ), 0, 20 ) )
				end

			end

			self.ThinkTick = CurTime() + 1
		end

	end
end

local mountainmantable = {}
function ENT:DoMountainManThink()
	mountainmantable = {}
	for k, v in pairs(ents.FindInSphere(self:GetPos(),300)) do
		if v:IsPlayer() && v:Alive() then
			table.insert(mountainmantable,v)
		end
	end
	if #mountainmantable > 1 then
		self:SetContested(true)
		self:SetMountainMan(nil)
		self:SetStatusColor(Vector(255,55,55))
	else
		self:SetContested(false)
		self:SetStatusColor(Vector(255,255,255))
		if #mountainmantable == 1 then
			self:SetStatusColor(Vector(155,215,255))
			self:SetMountainMan(mountainmantable[1])
			if self:GetMountainMan():IsPlayer() then
				self:GetMountainMan():SetNWInt("Score",self:GetMountainMan():GetNWInt("Score")+1)
			end
		else
			self:SetMountainMan(nil)
		end
	end
end


function ENT:DoConquestThink()

	local friendly,hostile = false,false

	self.FriendlyNum = 0
	self.EnemyNum = 0

	if HEX.Teamplay == true then

		self.PlyTable = {}

		for a, b in pairs(ents.FindInSphere(self:GetPos(),512)) do
			if !table.HasValue(self.PlyTable,b) then
				table.insert(self.PlyTable,b)
			end
		end

		for c, d in pairs(self.PlyTable) do
			if d:Team() == self.OwningTeam then self.FriendlyNum = self.FriendlyNum + 1 friendly = true end
			if d:Team() != self.OwningTeam then self.EnemyNum = self.EnemyNum + 1 hostile = true end

			-- Contested Check
			if friendly == true && hostile == true then
				self.Contested = true
				self.CapturingTeam = -1
			else
				self.Contested = false
			end

			if hostile == true && self.Contested == false then
				if d:Team() != self.OwningTeam then
					self.CapturingTeam = d:Team()
				end
			end
		end

		if self.CapturePower >= self.CapturePowerMax then
			self:Capture(self.CapturingTeam)
		end


	end

end

function ENT:Use(activator,caller)

end

function ENT:Capture(team)

end