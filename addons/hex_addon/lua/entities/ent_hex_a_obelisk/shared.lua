ENT.Type = "anim"
ENT.PrintName		= "Obelisk"
ENT.Author			= "Demonkush"

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 4, "Contested" )
	self:NetworkVar( "Bool", 3, "CapturedTeam" )
	self:NetworkVar( "Float", 2, "ObeliskTeam" )
	self:NetworkVar( "Entity", 1, "MountainMan" )
	self:NetworkVar( "Vector", 0, "StatusColor" )

	if SERVER then
		self:SetObeliskTeam( 1 )
		self:SetMountainMan( nil )
		self:SetContested( false )
		self:SetCapturedTeam( 11 )
		self:SetStatusColor(Vector(255,255,255))
	end
end