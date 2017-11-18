AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )


function ENT:Use(activator,caller)
	if self.NextCrestUse > CurTime() then return end
	if activator:Alive() then
		if ( activator:GetManaMaxed() == true ) && ( activator:GetHPMaxed() == true ) then return end
		if SERVER then
			HEX.SendNotification(activator,Color(235,185,255),255,"+50 Health and Mana",false)
		end
		activator:AddMana(50)
		activator:AddHP(50)
		self:EmitSound("wc3sound/exp/WandOfIllusionTarget1.wav",75,math.random(75,85))
		self:SetNWBool("CrestActive",false)
		timer.Simple(30,function()
			if IsValid(self) then
				self:SetNWBool("CrestActive",true)
			end
		end)
		self.NextCrestUse = CurTime() + 30
	end
end

function ENT:OnRemove()

end