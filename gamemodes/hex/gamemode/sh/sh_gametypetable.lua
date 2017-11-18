--[[ 	team.SetUp( 2, "Order of the Red Star", Color(255,55,55) ) 
		team.SetUp( 3, "Magistrate of Venus", Color(55,155,215) ) 
		team.SetUp( 4, "The Black Cult", Color(85,85,85) ) 
		team.SetUp( 5, "Grand Ministry", Color(215,215,215) ) ]]

HEX.GametypeTable = {}
HEX.GametypeTable[1] = { 
	name = "Skirmish",
	desc = "FFA. Deathmatch, loadout is purchased from F2 shop. Requires 3 people to start.", 
	goal = "Kill",
	settings = function()
		HEX.Teamplay = false
		HEX.TeamSpawnToggle = false
		HEX.Round.MaxRounds = 2
		HEX.Round.TimeLimit = 10
		HEX.MOD.PlayerLimit = 3
		HEX.MOD.StartingGold = 50
		HEX.MOD.GoalKills 	= 50
		HEX.MOD.PaydayToggle 			= true
		HEX.MOD.PlayerHPMPDropToggle 	= true
		HEX.MOD.PlayerGoldDropToggle 	= true
		HEX.MOD.PlayerHPRegenToggle 	= true
		HEX.MOD.PlayerMPRegenToggle 	= true
		HEX.MOD.LootCrateToggle 		= true
		HEX.MOD.LootSpawnTick 			= 10
		HEX.MOD.LoadoutCrestToggle 		= true
		HEX.MOD.CrestToggle 			= true
		HEX.MOD.SkirmishShopToggle 		= true
		HEX.MOD.MilestoneToggle 		= true
		HEX.MOD.KillstreakToggle 		= true
		HEX.Objective = "Collect Souls"
		HEX.ObjectiveDesc = "(Free for All) Kill to obtain souls. Collect 50 to win."
	end,
	teamsettings = function()
		team.SetColor( 11, Color(255,215,155) )
	end
}
HEX.GametypeTable[2] = { 
	name = "Team Skirmish",
	desc = "Teamplay. Team Deathmatch, loadout is purchased from F2 shop. Requires 4 people to start.", 
	goal = "Kill",
	settings = function()
		HEX.Teamplay = true
		HEX.TeamSpawnToggle = true
		HEX.Round.MaxRounds = 2
		HEX.Round.TimeLimit = 10
		HEX.MOD.PlayerLimit = 4
		HEX.MOD.StartingGold = 75
		HEX.MOD.GoalKills 	= 100
		HEX.MOD.PaydayToggle 			= true
		HEX.MOD.PlayerHPMPDropToggle 	= true
		HEX.MOD.PlayerGoldDropToggle 	= true
		HEX.MOD.PlayerHPRegenToggle 	= true
		HEX.MOD.PlayerMPRegenToggle 	= true
		HEX.MOD.LootCrateToggle 		= true
		HEX.MOD.LootSpawnTick 			= 10
		HEX.MOD.LoadoutCrestToggle 		= true
		HEX.MOD.CrestToggle 			= true
		HEX.MOD.SkirmishShopToggle 		= true
		HEX.MOD.MilestoneToggle 		= true
		HEX.MOD.KillstreakToggle 		= true
		HEX.Objective = "Collect Souls"
		HEX.ObjectiveDesc = "(Teamplay) Kill to obtain souls. Collect 100 to win."
	end,
	teamsettings = function()
		team.SetUp( 1, "Order of the Red Star", Color(255,55,55) ) 
		team.SetColor( 1, Color(255,55,55) )
		team.SetUp( 2, "Magistrate of Venus", Color(55,155,215) ) 
		team.SetColor( 2, Color(55,155,215) )
		team.SetColor( 11, Color(255,215,155) )
	end
}
HEX.GametypeTable[3] = { 
	name = "Elder",
	desc = "Teamplay. Elder vs. All. Requires 4 people to start.", 
	goal = "Kill the Elder",
	settings = function()
		HEX.Teamplay = true
		HEX.TeamSpawnToggle = false	
		HEX.Round.MaxRounds = 2
		HEX.Round.TimeLimit = 10
		HEX.MOD.GoalKills 	= 50
		HEX.MOD.PlayerLimit = 4
		HEX.MOD.StartingGold = 100
		HEX.MOD.PaydayToggle 			= false
		HEX.MOD.PlayerHPMPDropToggle 	= true
		HEX.MOD.PlayerGoldDropToggle 	= true
		HEX.MOD.PlayerHPRegenToggle		= true
		HEX.MOD.PlayerMPRegenToggle 	= true
		HEX.MOD.LootCrateToggle 		= true
		HEX.MOD.LootSpawnTick 			= 10
		HEX.MOD.LoadoutCrestToggle 		= true
		HEX.MOD.CrestToggle 			= true
		HEX.MOD.SkirmishShopToggle 		= true
		HEX.MOD.MilestoneToggle 		= false
		HEX.MOD.KillstreakToggle 		= false
		HEX.Objective = "Elder vs. All"
		HEX.ObjectiveDesc = "Kill the Elder before the timer runs out!"
	end,
	teamsettings = function()
		team.SetUp( 1, "The Elder", Color(255,115,115) ) 
		team.SetColor( 1, Color(255,115,115) )
		team.SetColor( 11, Color(255,215,155) )
	end
}
HEX.GametypeTable[4] = { 
	name = "Greed",
	desc = "FFA Gold hoarding. Overall score is total gold. Requires 3 people to start.", 
	goal = "Collect Gold (Skirmish Shop Available)",
	settings = function()
		HEX.Teamplay = false
		HEX.TeamSpawnToggle = false
		HEX.Round.MaxRounds = 1
		HEX.Round.TimeLimit = 10
		HEX.MOD.GoalGold 	= 1000
		HEX.MOD.PlayerLimit = 3
		HEX.MOD.StartingGold = 100
		HEX.MOD.PaydayToggle 			= false
		HEX.MOD.PlayerHPMPDropToggle 	= true
		HEX.MOD.PlayerGoldDropToggle 	= true
		HEX.MOD.PlayerHPRegenToggle 	= true
		HEX.MOD.PlayerMPRegenToggle 	= true
		HEX.MOD.LootCrateToggle 		= true
		HEX.MOD.LootSpawnTick 			= 10
		HEX.MOD.LoadoutCrestToggle 		= true
		HEX.MOD.CrestToggle 			= true
		HEX.MOD.SkirmishShopToggle 		= true
		HEX.MOD.MilestoneToggle 		= true
		HEX.MOD.KillstreakToggle 		= true
		HEX.Objective = "Collect Gold"
		HEX.ObjectiveDesc = "Collect 1000 Gold to win. (Weapons and Items purchased from Skirmish Shop)"
	end,
	teamsettings = function()
		team.SetColor( 11, Color(255,215,155) )
	end
}
HEX.GametypeTable[5] = { 
	name = "Scavenger",
	desc = "FFA Gold hoarding. Overall score is total gold. Requires 3 people to start.", 
	goal = "Collect Gold (No Skirmish Shop)",
	settings = function()
		HEX.Teamplay = false
		HEX.TeamSpawnToggle = false
		HEX.Round.MaxRounds = 1
		HEX.Round.TimeLimit = 10
		HEX.MOD.GoalGold 	= 1000
		HEX.MOD.PlayerLimit = 3
		HEX.MOD.StartingGold = 100
		HEX.MOD.LootDropWeapons 		= true
		HEX.MOD.LootDropItems 			= true
		HEX.MOD.PaydayToggle 			= false
		HEX.MOD.PlayerHPMPDropToggle 	= true
		HEX.MOD.PlayerGoldDropToggle 	= true
		HEX.MOD.PlayerDeathDropWeapon   = true
		HEX.MOD.PlayerDeathDropItem     = true
		HEX.MOD.PlayerHPRegenToggle 	= true
		HEX.MOD.PlayerMPRegenToggle 	= true
		HEX.MOD.LootCrateToggle 		= true
		HEX.MOD.LootSpawnTick 			= 10
		HEX.MOD.LoadoutCrestToggle 		= true
		HEX.MOD.CrestToggle 			= true
		HEX.MOD.SkirmishShopToggle 		= false
		HEX.MOD.MilestoneToggle 		= true
		HEX.MOD.KillstreakToggle 		= true
		HEX.Objective = "Collect Gold"
		HEX.ObjectiveDesc = "Collect 1000 Gold to win. (Weapons and Items picked up from loot crates)"
	end,
	teamsettings = function()
		team.SetColor( 11, Color(255,215,155) )
	end
}
HEX.GametypeTable[6] = { 
	name = "Mountain Man",
	desc = "FFA. King of the Hill, loadout is purchased from F2 shop. Requires 3 people to start.", 
	goal = "Capture the Obelisk",
	settings = function()
		HEX.Teamplay = false
		HEX.TeamSpawnToggle = false
		HEX.Round.MaxRounds = 2
		HEX.Round.TimeLimit = 10
		HEX.MOD.PlayerLimit = 3
		HEX.MOD.StartingGold = 50
		HEX.MOD.GoalScore = 100
		HEX.MOD.ObeliskToggle 			= true
		HEX.MOD.PaydayToggle 			= true
		HEX.MOD.PlayerHPMPDropToggle 	= true
		HEX.MOD.PlayerGoldDropToggle 	= true
		HEX.MOD.PlayerHPRegenToggle 	= true
		HEX.MOD.PlayerMPRegenToggle 	= true
		HEX.MOD.LootCrateToggle 		= true
		HEX.MOD.LootSpawnTick 			= 10
		HEX.MOD.LoadoutCrestToggle 		= true
		HEX.MOD.CrestToggle 			= true
		HEX.MOD.SkirmishShopToggle 		= true
		HEX.MOD.MilestoneToggle 		= true
		HEX.MOD.KillstreakToggle 		= true
		HEX.Objective = "Capture the Obelisk"
		HEX.ObjectiveDesc = "(Free for All) Increase score by capturing the Obelisk."
	end,
	teamsettings = function()
		team.SetColor( 11, Color(255,215,155) )
	end
}
HEX.GametypeTable[7] = { 
	name = "Voidwalker",
	desc = "FFA Death race. Make it to the end of the map to win. Requires 3 people to start.", 
	goal = "Run and Survive",
	settings = function()
		HEX.Teamplay = false
		HEX.TeamSpawnToggle = false
		HEX.Round.MaxRounds = 1
		HEX.Round.TimeLimit = 10
		HEX.MOD.PlayerLimit = 3
		HEX.MOD.StartingGold = 100
		HEX.MOD.RespawnPenalty = 0
		HEX.MOD.LootDropWeapons 		= true
		HEX.MOD.LootDropItems 			= true
		HEX.MOD.PaydayToggle 			= false
		HEX.MOD.PlayerHPMPDropToggle 	= true
		HEX.MOD.PlayerGoldDropToggle 	= true
		HEX.MOD.PlayerHPRegenToggle 	= true
		HEX.MOD.PlayerMPRegenToggle 	= true
		HEX.MOD.LootCrateToggle 		= true
		HEX.MOD.LootSpawnTick 			= 10
		HEX.MOD.LoadoutCrestToggle 		= true
		HEX.MOD.CrestToggle 			= true
		HEX.MOD.SkirmishShopToggle 		= false
		HEX.MOD.MilestoneToggle 		= true
		HEX.MOD.KillstreakToggle 		= true
		HEX.Objective = "Run and Survive"
		HEX.ObjectiveDesc = "Make it to the end of the map to win. (Weapons and Items picked up from loot crates)"
	end,
	teamsettings = function()
		team.SetColor( 11, Color(255,215,155) )
	end
}

--HEX.GameTypeInfo[5] = {game="Dungeon",desc="FFA. Raid a dungeon, choose classes and level up. Requires 4 people to start.",goal="Grind"}
