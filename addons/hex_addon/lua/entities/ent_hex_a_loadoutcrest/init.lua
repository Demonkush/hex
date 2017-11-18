AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )


function ENT:Use(activator,caller)
	if activator:Alive() then
		activator:ReEquip()
	end
end

function ENT:OnRemove()

end