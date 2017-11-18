AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

-- When spawning Checkpoint Crests in teamplay gametypes, set the color of the team and only allow members of that team to access it.


function ENT:Use(activator,caller)
	if self.NextCrestUse > CurTime() then return end
	if activator:Alive() then
		self.NextCrestUse = CurTime() + 2
	--[[
		if IsValid(activator:GetNWEntity("Checkpoint")) then
			activator:ResetCheckpoint()
			self:EmitSound("wc3sound/CratePickup.wav")
			HEX.SendNotification(activator,Color(215,215,215),255,"Checkpoint reset!",false)
			return
		end
	]]
		activator:ReEquip()

		activator:SetCheckpoint(self.Entity)
		self:EmitSound("wc3sound/CratePickup.wav")
		HEX.SendNotification(activator,Color(155,215,255),255,"Checkpoint set!",false)
	end
end

function ENT:OnRemove()

end