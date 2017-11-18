AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.Crest = "ent_hex_a_lifecrest"
ENT.RandomCrest = false

function ENT:Initialize()
	if self.RandomCrest == true then
		self.Crest = table.Random(HEX.CrestTableLite)
	end

	timer.Simple(1,function()
		self:CreateCrest(self.Crest)
	end)
end

function ENT:RespawnCrest()
	self:CreateCrest(self.Crest)
end

function ENT:CreateCrest(ent)
	local crest = ents.Create(ent)
	crest:SetPos(self:GetPos()+Vector(0,0,-16))
	crest:Spawn()

	self:Remove()
end

function ENT:KeyValue(key, value)
	if key == "crest" then self.Crest = value
	elseif key == "randomcrest" then 	self.RandomCrest = value
	end
end