HEX = {}
HEX.Version = "v2.0a"
HEX.DebugSQL = true

HEX.Gametype = "Skirmish"

HEX.Objective = "None"
HEX.ObjectiveDesc = "No description"

HEX.EntSpawnTable = {} -- Structure in sv_spawns.lua

HEX.Team = {}
HEX.Teamplay = false
HEX.TeamSpawnToggle = false -- Whether to use normal spawns or team spawns
HEX.Team.Team1 = 0
HEX.Team.Team2 = 0
HEX.Team.Team3 = 0
HEX.Team.Team4 = 0
HEX.Team.TeamScore1 = 0
HEX.Team.TeamScore2 = 0
HEX.Team.TeamScore3 = 0
HEX.Team.TeamScore4 = 0

HEX.Round = {}
HEX.Round.RoundState = 0 -- 0 = pre, 1 = active, 2 = post
HEX.Round.RoundOver = false
HEX.Round.TimeLimit = 30
HEX.Round.Timer = 0
HEX.Round.RoundNumber = 1
HEX.Round.MaxRounds = 1
HEX.Round.TeamVictory = 0 -- team number or 0 for draw
HEX.Round.Winner = nil -- player who initialized the win


HEX.MOD = {}
--Gametype
HEX.MOD.RespawnTime = 5
HEX.MOD.RespawnPenalty = 5
HEX.MOD.GoalScore = 0
HEX.MOD.GoalKills = 0
HEX.MOD.GoalGold = 0
HEX.MOD.PlayerLimit = 2 -- gametype player limit
HEX.MOD.StartingGold = 50
HEX.MOD.SkirmishShopToggle 	= true
HEX.MOD.MilestoneToggle 	= true
HEX.MOD.KillstreakToggle 	= true
HEX.MOD.PaydayToggle 		= true

--Player
HEX.MOD.PlayerHPMPDropToggle 	= true
HEX.MOD.HealthDropAmount 		= 25
HEX.MOD.ManaDropAmount 			= 25
HEX.MOD.PlayerGoldDropToggle 	= true
HEX.MOD.GoldDropRatio 			= 0.25
HEX.MOD.PlayerHPRegenToggle 	= true
HEX.MOD.PlayerMPRegenToggle 	= true
HEX.MOD.FullManaOvercharge 		= true
HEX.MOD.LowManaAttackAmount 	= 20
HEX.MOD.ToggleOverpower 		= true
HEX.MOD.ToggleMagesoul 			= true
HEX.MOD.DefaultWalkSpeed 		= 150
HEX.MOD.DefaultRunSpeed 		= 300
HEX.MOD.DefaultCrouchSpeed 		= 50
HEX.MOD.DefaultJumpPower 		= 250

--Entities
HEX.MOD.PowerupsToggle 			= true
HEX.MOD.PowerupSpawnTick 		= 10
HEX.MOD.LootCrateToggle 		= true
HEX.MOD.LootSpawnTick 			= 10
HEX.MOD.LootDropWeapons 		= false -- if weapons will drop from crates
HEX.MOD.LootDropItems 			= false
HEX.MOD.LoadoutCrestToggle 		= true
HEX.MOD.ObeliskToggle 			= false
HEX.MOD.CrestToggle 			= true

--Equipment
HEX.MOD.WeaponPowerLock 		= false -- forces weapons to always use a certain power output
HEX.MOD.WeaponPowerLockMode 	= "low"
HEX.MOD.DefaultWeapon 			= "wep_hex_wonderbranch"
HEX.MOD.DefaultItem 			= "none"
HEX.MOD.PlayerDeathDropWeapon   = false
HEX.MOD.PlayerDeathDropItem     = false


-- Map Vote

HEX.MapVote = {}
HEX.MapVote.GameTypes = {"Skirmish","Team Skirmish","Elder","Greed","Scavenger","Mountain Man"}

HEX.MapVote.Maps = {}
HEX.MapVote.Maps[1] = { name = "Ziggurat", 	map = "hex_ziggurat", 	gametypes = {"Skirmish","Team Skirmish","Elder","Scavenger","Greed","Mountain Man"}, size = "medium" }
HEX.MapVote.Maps[2] = { name = "Jodkar", 	map = "swd_jodkar_a1", 	gametypes = {"Skirmish","Scavenger","Greed","Mountain Man"}, size = "large" }
HEX.MapVote.Maps[3] = { name = "Zheem", 	map = "swd_zheem", 		gametypes = {"Skirmish","Scavenger","Greed","Mountain Man"}, size = "medium" }
HEX.MapVote.Maps[4] = { name = "Morkar", 	map = "hex_morkar", 	gametypes = {"Skirmish","Elder","Scavenger","Greed","Mountain Man"}, size = "medium" }
HEX.MapVote.Maps[5] = { name = "Vaggard", 	map = "hex_vaggard", 	gametypes = {"Skirmish","Team Skirmish","Elder","Scavenger","Greed"}, size = "medium" }
HEX.MapVote.Maps[6] = { name = "Magmar", 	map = "swd_magmar", 	gametypes = {"Skirmish","Scavenger","Greed","Mountain Man"}, size = "medium" }
HEX.MapVote.Maps[7] = { name = "Sunkir", 	map = "swd_sunkir", 	gametypes = {"Skirmish","Greed","Mountain Man"}, size = "small" }
HEX.MapVote.Maps[8] = { name = "Karsus", 	map = "swd_karsus", 	gametypes = {"Skirmish","Greed","Mountain Man"}, size = "small" }
HEX.MapVote.Maps[9] = { name = "Sky Temple", 	map = "hex_skytemple_a1", 	gametypes = {"Skirmish","Elder","Scavenger","Greed","Mountain Man"}, size = "medium" }

--HEX.MapVote.Maps[10] = { name = "Dundoro", 	map = "lmt_dundoro_b1", 	gametypes = {"Team Skirmish"}, size = "large" }
--HEX.MapVote.Maps[11] = { name = "Moria", 	map = "lmt_moria_a1", 	gametypes = {"Team Skirmish"}, size = "large" }
--HEX.MapVote.Maps[12] = { name = "Orion", 	map = "lmt_orion_a1", 	gametypes = {"Team Skirmish"}, size = "medium" }
HEX.MapVote.Maps[10] = { name = "Sudo", 	map = "hex_sudo", 	gametypes = {"Skirmish","Team Skirmish","Elder","Scavenger","Greed","Mountain Man"}, size = "small" }
HEX.MapVote.Maps[11] = { name = "Crag", 	map = "hex_crag_a1", 		gametypes = {"Skirmish","Team Skirmish","Elder","Scavenger","Greed","Mountain Man"}, size = "small" }
--HEX.MapVote.Maps[14] = { name = "Vashen", 	map = "lmt_vashen_b1", 	gametypes = {"Team Skirmish"}, size = "medium" }

--HEX.MapVote.Maps[12] = { name = "Voidwalker", 	map = "hex_voidwalker", 	gametypes = {"Voidwalker"}, size = "large" }


HEX.MapVote.GameList = {}
HEX.MapVote.MapList = {}

HEX.NextMapInfoTable = { name = "", map = "", game = "" }
HEX.NextMapInfoValidated = false

HEX.MapVote.WinningGame = "Skirmish"
HEX.MapVote.WinningMap = ""

HEX.MapVote.CurrentRTV = 0
HEX.MapVote.RTVRatio = 0.5

HEX.MapVote.Active = 0
HEX.MapVote.RTVActive = 0
HEX.MapVote.NextRTV = 0
HEX.MapVote.NextRTVDelay = 300
HEX.MapVote.RTVTime = 0