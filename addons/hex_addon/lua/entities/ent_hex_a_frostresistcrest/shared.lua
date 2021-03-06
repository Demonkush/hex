ENT.Type = "anim"
ENT.PrintName		= "Frost Resist Crest"
ENT.Author			= "Demonkush"
ENT.Crest = true

function ENT:Initialize()
	if SERVER then
		self:SetUseType( SIMPLE_USE )
		self:SetModel( "models/hunter/blocks/cube075x2x075.mdl" )
		self:PhysicsInit( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetColor( Color( 55, 155, 255 ) )
		self:DrawShadow( false )

		self:SetAngles(Angle(0,0,90))
		timer.Simple(0.1,function()
			if IsValid(self) then
				self:SetPos(self:GetPos()+Vector(0,0,64))
			end
		end)
	end

	self.Crest = true

	self:SetNWBool("CrestActive",true)

	self.NextCrestUse = 0
end