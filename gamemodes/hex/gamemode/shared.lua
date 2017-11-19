GM.Name = "Hex"
GM.Author = "Demonkush"
GM.Website = "http://www.xmpstudios.com"

function GM:Initialize()
	local function MatchGametypetoTable(t)
		for a, b in pairs(HEX.GametypeTable) do
			if t == b.name then
				return a
			end
		end
	end
	local GametypeID = MatchGametypetoTable(HEX.Gametype)

	if SERVER then
		perf = {} perf.MaxVelocity = 5000 physenv.SetPerformanceSettings(perf)

		gamemode.CrestRefreshTick = 5
		gamemode.GoldTick = 3
		gamemode.ManaTick = 3
		gamemode.RegenTick = 3
		gamemode.LastHitTick = 3
		gamemode.RoundTick = 3
		gamemode.MilestoneTick = 60
		gamemode.LootSpawnTick = 10
		gamemode.PowerupSpawnTick = 15

		HEX_LoadNextMapInfo()
		HEX.LoadMapSpawns()

		if HEX.NextMapInfoTable.game == "" then
			HEX.Gametype = "Skirmish"
		else
			HEX.Gametype = HEX.NextMapInfoTable.game
		end

		timer.Simple(5,function()
			HEX.LoadGametypeSettings()
		end)

		HEX.MapVote.NextRTV = CurTime() + HEX.MapVote.NextRTVDelay

		print("[HEX] Hex Server-side initialized!")
	end

	-- Team Setup
	team.SetUp( 11, "Casters", Color(255,215,155) ) 
	timer.Simple(1,function()
		HEX.GametypeTable[GametypeID].teamsettings()
		team.SetUp( 12, "Spectators", Color(155,155,155) ) 
	end)
end

util.PrecacheModel("models/whdow2/cultist_plr.mdl")
util.PrecacheModel("models/player/skeleton.mdl")
util.PrecacheModel("models/player/theonlykingthatmatters.mdl")
util.PrecacheModel("models/player/ffx/auron.mdl")
util.PrecacheModel("models/player/gow3_zeus.mdl")
util.PrecacheModel("models/player/hots/sylvana_highelf.mdl")
util.PrecacheModel("models/player/hots/sylvana_base.mdl")