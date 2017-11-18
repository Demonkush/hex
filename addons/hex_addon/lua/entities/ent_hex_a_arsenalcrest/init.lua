AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Use(activator,caller)
	if self.NextCrestUse > CurTime() then return end
	local r = math.random(1,2)
	local randweap = math.random(1,#HEX.WeaponTable)
	local randitem = math.random(1,#HEX.ItemTable)
	if activator:Alive() then
		if r == 1 then
			-- weapon
			activator:SetCurrentWeapon(HEX.WeaponTable[randweap].wep)
			activator:SetMainWeapon(HEX.WeaponTable[randweap].wep)
			activator:StripWeapons()
			activator:Give(activator:GetCurrentWeapon())
			HEX.SendNotification(activator,Color(215,215,215),255,"Equipped Weapon: "..HEX.WeaponTable[randweap].name.." !",false)
		end
		if r == 2 then
			-- item
			activator:SetCurrentItem(HEX.ItemTable[randitem].id)
			activator:SetMainItem(HEX.ItemTable[randitem].id)			
			HEX.SendNotification(activator,Color(215,215,215),255,"Equipped Item: "..HEX.ItemTable[randitem].name.." !",false)
		end
		self:EmitSound("wc3sound/exp/WandOfIllusionTarget1.wav",75,math.random(75,85))
		self:SetNWBool("CrestActive",false)
		timer.Simple(15,function()
			if IsValid(self) then
				self:SetNWBool("CrestActive",true)
			end
		end)
		self.NextCrestUse = CurTime() + 15
	end
end

function ENT:OnRemove() end