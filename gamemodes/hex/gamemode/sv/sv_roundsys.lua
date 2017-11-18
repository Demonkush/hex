function HEX.CheckRound()
	local roundstate = HEX.Round.RoundState
	local playerlimit = HEX.MOD.PlayerLimit

	if roundstate == 0 then
		--print("Round not active")
	end
	if roundstate == 1 then
		--print("Round is active")
	end
	if roundstate == 2 then
		--print("Round is over")
	end
	if #player.GetAll() < playerlimit then
		--print("Not enough players")
	end

	if roundstate == 0 then
		if HEX.Gametype == "Skirmish" or HEX.Gametype == "Greed" or HEX.Gametype == "Scavenger" then
			if #player.GetAll() >= playerlimit then
				HEX.StartRound()
			end
		end

		if HEX.Gametype == "Team Skirmish" then
			if #player.GetAll() >= playerlimit then
				HEX.StartRound()
			end
		end

		if HEX.Gametype == "Elder" then
			if #player.GetAll() >= playerlimit then
				HEX.StartRound()
			end
		end

		if HEX.Gametype == "Mountain Man" then
			if #player.GetAll() >= playerlimit then
				HEX.StartRound()
			end
		end

		if HEX.Gametype == "Voidwalker" then
			if #player.GetAll() >= playerlimit then
				HEX.StartRound()
			end
		end
	end

	if roundstate == 1 then
		if #player.GetAll() < playerlimit then
			HEX.EndRound(3,0)
		end
	end
end

function HEX.BeginRoundTimer()
	if HEX.Round.TimeLimit <= 0 then return end
	HEX.Round.Timer = (HEX.Round.TimeLimit*60)
	timer.Create("HexRoundTimer",1,0,function()
		HEX.Round.Timer = HEX.Round.Timer - 1
		if HEX.Round.Timer <= 0 then
			HEX.DestroyRoundTimer()
			HEX.EndRound(1,0)
		end
		for k, v in pairs(player.GetAll()) do
			if HEX.MOD.GoalScore > 0 && v:GetNWInt("Score") >= HEX.MOD.GoalScore then
				HEX.EndRound(1,0)
			end
		end
		HEX.UpdateRoundTimer()
	end)
	timer.Create("HexTimerGreed",3,0,function()
		for k, v in pairs(player.GetAll()) do
			if HEX.MOD.GoalGold > 0 && v:GetNWInt("Gold") >= HEX.MOD.GoalGold then
				HEX.EndRound(1,0)
			end
		end
	end)
end

function HEX.UpdateRoundTimer()
	net.Start("updateroundtimer")
		net.WriteInt(HEX.Round.Timer,12)
	net.Broadcast()
end

function HEX.DestroyRoundTimer()
	if HEX.Gametype == "Greed" then
		if timer.Exists("HexTimerGreed") then
			timer.Destroy("HexTimerGreed")
		end
	end
	if timer.Exists("HexRoundTimer") then
		timer.Destroy("HexRoundTimer")
	end
	if timer.Exists("HexRoundTimerSync") then
		net.Start("updateroundtimer")
			net.WriteInt(0,10)
		net.Broadcast()
		timer.Destroy("HexRoundTimerSync")
	end
end

function HEX.CheckTeamVictory()
	if HEX.Teamplay == false then return end
	HEX.Team.TeamScore1 = 0
	HEX.Team.TeamScore2 = 0
	HEX.Team.TeamScore3 = 0
	HEX.Team.TeamScore4 = 0	
	for k, v in pairs(player.GetAll()) do
		if v:Team() == 2 then
			HEX.Team.TeamScore1 = HEX.Team.TeamScore1 + v:GetNWInt("Score")
			if HEX.MOD.GoalKills > 0 && HEX.Team.TeamScore1 >= HEX.MOD.GoalKills then
				HEX.EndRound(1,2)
			end
		end
		if v:Team() == 3 then
			HEX.Team.TeamScore2 = HEX.Team.TeamScore2 + v:GetNWInt("Score")		
			if HEX.MOD.GoalKills > 0 && HEX.Team.TeamScore2 >= HEX.MOD.GoalKills then
				HEX.EndRound(1,3)
			end
		end
		if v:Team() == 4 then
			HEX.Team.TeamScore3 = HEX.Team.TeamScore3 + v:GetNWInt("Score")	
			if HEX.MOD.GoalKills > 0 && HEX.Team.TeamScore3 >= HEX.MOD.GoalKills then
				HEX.EndRound(1,4)
			end
		end
		if v:Team() == 5 then
			HEX.Team.TeamScore4 = HEX.Team.TeamScore4 + v:GetNWInt("Score")	
			if HEX.MOD.GoalKills > 0 && HEX.Team.TeamScore4 >= HEX.MOD.GoalKills then
				HEX.EndRound(1,5)
			end	
		end
	end
	print("Team 1 Score: "..HEX.Team.TeamScore1)
	print("Team 2 Score: "..HEX.Team.TeamScore2)
	print("Team 3 Score: "..HEX.Team.TeamScore3)
	print("Team 4 Score: "..HEX.Team.TeamScore4)
end

function HEX.StartRound()
	HexMsg(self,"HEX","The round is starting! ( Round: "..HEX.Round.RoundNumber.." )",Vector(155,185,215),true)

	HEX.CleanupRound()
	HEX.LoadGametypeSettings()

	HEX.SetRoundState(1)
	HEX.Round.RoundOver = false

	HEX.ResetTeams()

	if HEX.Gametype == "Team Skirmish" then
		for k, v in pairs(player.GetAll()) do
			v:SortTeam()
		end
	end

	timer.Simple(0.5,function()
		HEX.CreateSpawns()
		HEX.SpawnCrestsforRound(0)
		HEX.SpawnObelisk()
	end)

	if HEX.MOD.PowerupsToggle == true then
		HEX.SpawnPowerup()
	end

	timer.Simple(1, function() 
		HEX.SetupPlayers()
	end)

	-- Round Startup
	timer.Simple(5, function()

		HEX.BeginRoundTimer()

		if HEX.Gametype == "Skirmish" then
			for k, v in pairs(player.GetAll()) do
				v:SetTeam(11)
			end
		end

		if HEX.Gametype == "Greed" then
			for k, v in pairs(player.GetAll()) do
				v:SetTeam(11)
			end
		end

		-- Elder Round Controls
		if HEX.Gametype == "Elder" then
			local pick = math.random(1,#player.GetAll())

			for k, v in pairs(player.GetAll()) do

				v:SetTeam(11)

				if k == pick then
					v:MakeElder()
				end
			end
		end

		for k, v in pairs(player.GetAll()) do
			-- If not enough players, override round start.
			if #player.GetAll() < HEX.MOD.PlayerLimit then
				HexMsg(v,"HEX","Not enough players, round cannot start!",Vector(215,185,155),false)
				HEX.SetRoundState(0)
			else
				HexMsg(v,"HEX","The round has begun!",Vector(215,185,155),false)
			end
			v:Freeze(false)
		end
	end)
end

function HEX.SetupPlayers()
	for k, v in pairs(player.GetAll()) do

		if HEX.Teamplay == true then
			v:SetNoCollideWithTeammates(true)
		else
			v:SetNoCollideWithTeammates(false)
		end
		v:Freeze(true)
		v:SetFrags(0)
		v:SetDeaths(0)

		HEX.DoPlayerSpawnEvent(v)

		v.HealthRegenRate = 1
		v.ManaRegenRate = 1
		v.ManaUsageMod = 1

		v:StripWeapons()

		v.HEX_Checkpoint = nil

		v:SetMainWeapon(HEX.MOD.DefaultWeapon)
		v:SetCurrentWeapon(HEX.MOD.DefaultWeapon)

		v:SetMainItem(HEX.MOD.DefaultItem)
		v:SetCurrentItem(HEX.MOD.DefaultItem)

		v:Give(v:GetMainWeapon())

		v:SetNWInt("MaxHealth",100)
		v:SetNWInt("MaxMana",100)

		v:SetHealth(100)
		v:SetMana(100)

		v:SetNWInt("Score",0)
		v:SetNWInt("Gold",HEX.MOD.StartingGold)
	end
end


function HEX.PlayerSelectSpawn(ply,mode)
	if isvector(ply.HEX_Checkpoint) == true then
		ply:SetPos(ply.HEX_Checkpoint)
		HexMsg(self,"HEX","Respawned at checkpoint!",Vector(155,185,215),true)
		return
	end
	if mode == 1 then
		if #HEX.EntSpawnTable.PlayerSpawns > 1 then
			local spawn = table.Random(HEX.EntSpawnTable.PlayerSpawns)
			ply:SetPos(spawn+Vector(0,0,64))
			timer.Simple(0.1,function()
				local ents = ents.FindInBox( spawn + Vector( -16, -16, 0 ), spawn + Vector( 16, 16, 64 ) )
				for k, v in pairs(ents) do
					if v:IsPlayer() && ply != v then
						ply:SetPos(table.Random(HEX.EntSpawnTable.PlayerSpawns)+Vector(0,0,64))
					end
				end
			end)
			timer.Simple(0.3,function()
				local ents = ents.FindInBox( spawn + Vector( -16, -16, 0 ), spawn + Vector( 16, 16, 64 ) )
				for k, v in pairs(ents) do
					if v:IsPlayer() && ply != v then
						ply:SetPos(table.Random(HEX.EntSpawnTable.PlayerSpawns)+Vector(0,0,64))
					end
				end
			end)
		end
	end
	if mode == 2 then
		for a, b in RandomPairs(HEX.TeamSpawnpoints) do
			if tonumber(ply:Team()) == tonumber(b.Team) then
				ply:SetPos(b:GetPos()+Vector(0,0,64))
			end
		end
	end
end

local rements = {"ent_hex_a_obelisk","ent_hex_lootcrate","ent_hex_pickupitem","ent_hex_pickupweapon","ent_hex_powerup"}
function HEX.CleanupRound()
	HEX.RemoveSpawns()
	for a, b in pairs(ents.GetAll()) do
		if b.Crest == true then
			b:Remove()
		end
		if table.HasValue(rements,b:GetClass()) then
			b:Remove()
		end
	end
end

function HEX.EndRound(mode,teamvictory,winningply)
	if HEX.Round.RoundState == 2 then return end

	HEX.DestroyRoundTimer()

	if mode == 1 then
		local winningteam = 0

		HexSound(nil,"wc3sound/exp/GoodJob.wav",true,false)

		if HEX.Round.RoundNumber <= HEX.Round.MaxRounds then
			HexMsg(self,"HEX","Round "..HEX.Round.RoundNumber.." is over!",Vector(185,185,185),true)
		else
			HexMsg(self,"HEX","The final round is over!",Vector(185,185,185),true)
		end
		
		HEX.SetRoundState(2)

		if HEX.Teamplay == true then
			if teamvictory == 0 then
				HEX.RoundReward()
			else
				HexMsg(self,"HEX","Team victory goes to "..team.GetName(teamvictory).."!",Vector(team.GetColor(teamvictory).r,team.GetColor(teamvictory).g,team.GetColor(teamvictory).b),true)
				HEX.RoundReward(teamvictory)
			end
		else
			HEX.RoundReward()
		end

		HEX.Round.RoundNumber = HEX.Round.RoundNumber + 1

		HEX.Round.RoundOver = true

		timer.Simple(2,function()
			if HEX.Round.RoundNumber > HEX.Round.MaxRounds then
				HEX.EndGame()
			else
				HEX.SetRoundState(0)
				HEX.CheckRound()
			end
		end)
	end

	if mode == 2 then
		HexMsg(self,"HEX","Round ended prematurely.",Vector(155,185,155),true)
		HEX.SetRoundState(0)
	end

	if mode == 3 then
		HexMsg(self,"HEX","Round ending, not enough players to continue.",Vector(185,125,125),true)
		timer.Simple(3,function()
			HEX.SetRoundState(0)
			if #player.GetAll() >= 1 then
				HexMsg(self,"HEX","Rewarded remaining players for their effort.",Vector(185,155,125),true)
				HEX.RoundReward()
			end
		end)
	end
end

function HEX.SetRoundState(state)
	HEX.Round.RoundState = state
	net.Start("hexroundstate")
		net.WriteInt(state,3)
	net.Broadcast()
end

function HEX.EndGame()
	HexMsg(self,"HEX","Game over!",Vector(215,185,115),false)
	HandlePlayerEndGame()
	HEX.DoGameVote()
end

function HEX.RoundReward(a)
	for k, v in pairs(player.GetAll()) do
		v:DoRoundReward(a)
	end
end

function HandlePlayerEndGame()
	for k, v in pairs(player.GetAll()) do 
		v:AbolishBuffs("all")
		v:Freeze(true)
		if HEX.DebugSQL == false then
			timer.Simple(5,function()
				v:SaveData()
				v:PrintMessage(HUD_PRINTTALK,"Your player data has been saved!")
			end)
		end
	end
end