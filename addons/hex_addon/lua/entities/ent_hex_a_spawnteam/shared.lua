ENT.Type = "point"
ENT.PrintName		= "Map Entity: Team Spawn"

if SERVER then
	ENT.Team = 11 -- 11 is Casters (default) team. Valid teams are 1-4.

	function ENT:TeamSet(team)
		self.Team = team
	end
end