function HEX.DoMapVote()
	HEX.TempMapTable = {}

	HEX.MapTableCopy = {}
	for a, b in pairs(HEX.MapVote.Maps) do
		if table.HasValue(b.gametypes, HEX.MapVote.WinningGame) then
			print(b.name.." accepted to map vote list with gametype: "..HEX.MapVote.WinningGame)
			table.insert(HEX.MapTableCopy,b.map)
		else
			print(b.name.." rejected from map vote list.")
		end
	end

	local function PickRandomMap()
		local a = math.random(1,#HEX.MapTableCopy)
		for b, c in pairs(HEX.MapTableCopy) do
			if b == a then
				table.insert(HEX.TempMapTable,{map=c,votes=0})
				table.remove(HEX.MapTableCopy,b)
			end
		end
	end

	for i=1,3 do
		PickRandomMap()
	end

	HEX.MapVote.MapList = table.Copy(HEX.TempMapTable)

	HexMsg(self,"Map Vote","Next game will be: "..HEX.MapVote.WinningGame..". Map vote starting...",Vector(185,215,115),true)
	HexSound(self,"wc3sound/exp/ArrangedTeamInvitation.wav",true)

	HEX.MapVote.Active = 1

	timer.Simple(5,function()
		HEX.SendMapVote()
	end)
end

function HEX.DoGameVote()
	HEX.TempGameTable = {}

	HEX.GameTableCopy = {}
	for a, b in pairs(HEX.MapVote.GameTypes) do
		table.insert(HEX.GameTableCopy,b)
	end

	HexMsg(self,"Map Vote","A vote for the next game is starting!",Vector(185,215,115),true)
	HexSound(self,"wc3sound/exp/ArrangedTeamInvitation.wav",true)
	
	HEX.MapVote.Active = 1

	for b, c in pairs(HEX.GameTableCopy) do
		table.insert(HEX.TempGameTable,{game=c,votes=0})
	end

	HEX.MapVote.GameList = table.Copy(HEX.TempGameTable)

	timer.Simple(5,function()
		net.Start("gamevotesend")
			net.WriteTable(HEX.MapVote.GameList)
		net.Broadcast()
	end)

	timer.Simple(20,function()
		table.sort(HEX.MapVote.GameList, function(a,b) return a.votes > b.votes end)
		for a, b in pairs(HEX.MapVote.GameList) do
			if a == 1 then
				HEX.MapVote.WinningGame = b.game
				HEX.DoMapVote()
			end
		end
	end)
end

function HEX.SendMapVote()
	net.Start("mapvotesend")
		net.WriteTable(HEX.MapVote.MapList)
	net.Broadcast()

    local function MatchMapToTable(m)
        for a, b in pairs(HEX.MapVote.Maps) do
            if m == b.map then
                return b.name
            end
        end
    end

    -- Default Settings, uses if nobody participates in vote
	HEX.NextMapInfoTable.name = "Ziggurat"
	HEX.NextMapInfoTable.map = "hex_ziggurat"
	HEX.NextMapInfoTable.game = "Skirmish"

	timer.Simple(30,function()
		table.sort(HEX.MapVote.MapList, function(a,b) return a.votes > b.votes end)
		for a, b in pairs(HEX.MapVote.MapList) do
			if a == 1 then
				HEX.NextMapInfoTable.name = MatchMapToTable(b.map)
				HEX.NextMapInfoTable.map = b.map
				HEX.NextMapInfoTable.game = HEX.MapVote.WinningGame

				HEX.DoMapChange()
			end
		end
	end)
end

-- RTV
function HEX.AddRTV()
	if HEX.MapVote.RTVActive == 0 then
		HEX.StartRTV()
	end

	HEX.MapVote.CurrentRTV = HEX.MapVote.CurrentRTV + 1

	HexSound(player,"wc3sound/exp/QuestActivateWhat1.wav",true)

	net.Start("rtvsend")
		net.WriteInt(1,3)
	net.Broadcast()

	HEX.CheckRTV()
end

function HEX.StartRTV()
	HEX.MapVote.RTVActive = 1
	timer.Simple(30,function()
		if HEX.MapVote.Active == 0 then
			HexMsg(self,"RTV","Vote for RTV failed. Wait to RTV for "..string.NiceTime(HEX.MapVote.NextRTVDelay)..".",Vector(215,215,215),true)
			HEX.ResetRTV()
			HEX.MapVote.NextRTV = CurTime()+HEX.MapVote.NextRTVDelay
		end
	end)
end

function HEX.CheckRTV()
	local ply = #player.GetAll()
	local rat = ply*HEX.MapVote.RTVRatio

	if HEX.MapVote.Active == 1 then HEX.MapVote.RTVActive = 0 return end

	if ply == 1 then
		HEX.DoGameVote()
		HEX.MapVote.RTVActive = 0
		return
	end

	if HEX.MapVote.CurrentRTV >= rat then
		if HEX.MapVote.Active == 0 then
			HEX.DoGameVote()
			HEX.MapVote.RTVActive = 0
		end
	end
end

function HEX.ResetRTV()
	for a, b in pairs(player.GetAll()) do
		b.RTVInit = false
	end

	net.Start("rtvsend")
		net.WriteInt(2,3)
	net.Broadcast()

	HEX.MapVote.RTVActive = 0
	HEX.MapVote.CurrentRTV = 0
end


function HEX.DoMapChange()
	local name = HEX.NextMapInfoTable.name
	local map = HEX.NextMapInfoTable.map
	local game = HEX.NextMapInfoTable.game

	HexMsg(self,"Map Vote","Changing to "..game..", playing on "..name.."!",Vector(185,215,115),true)

	HEX_SaveNextMapInfo()

	timer.Simple(5,function()
		RunConsoleCommand("changelevel",map)
	end)

end

-- Game Info IO
function HEX_SaveNextMapInfo()
	local path = "hex/nextmapinfo.txt"

	local info = util.TableToJSON(HEX.NextMapInfoTable)

	if !file.Exists("hex","DATA") then
		file.CreateDir("hex")
	end

	file.Write(path,info)
	PrintTable(HEX.NextMapInfoTable)
	print(info)
end

function HEX_LoadNextMapInfo()
	local map = game.GetMap()
	local path = "hex/nextmapinfo.txt"

	if file.Exists(path,"DATA") then

		local load = file.Read(path,"DATA")
		local info = util.JSONToTable(load)

		table.Empty(HEX.NextMapInfoTable)
		HEX.NextMapInfoTable = table.Copy(info)

		-- Inconsistencies with next map data, fix.
		if HEX.NextMapInfoTable.map != game.GetMap() then
			--file.Delete(path)
			HEX.NextMapInfoTable.game = ""
			HEX.NextMapInfoTable.map = ""
			HEX.NextMapInfoTable.name = ""

			HEX.NextMapInfoValidated = false

			HEX.MapVote.NextRTV = 0

			print("[HEX] Game info config failed to load properly! Resetting next map info...")
			return
		end

		HEX.NextMapInfoValidated = true
		print("[HEX] Game info loaded!")
	else
		HEX.NextMapInfoTable.game = "Skirmish"
		HEX.NextMapInfoTable.map = game.GetMap()
		HEX.NextMapInfoTable.name = game.GetMap()
		print("[HEX] Game info config is missing. This should not happen!")
	end
end

function HEX.CheckChatforRTV( player, text, teamonly )
    if string.sub(text,0,4) == "/rtv" or string.sub(text,0,4) == "!rtv" then

        if player.RTVInit == true then return "" end
    	if HEX.MapVote.Active == 1 then 
    		HexMsg(player,"HEX","A map vote is already active!",Vector(215,215,215),false)
    		return "" 
    	end

    	if HEX.MapVote.NextRTV > CurTime() then
    		HexMsg(player,"HEX","You can RTV in " .. string.NiceTime( HEX.MapVote.NextRTV-CurTime() ) .. ".",Vector(215,155,95),false)
    		return ""
    	end

		player.RTVInit = true

		HexMsg(self,"HEX",player:Name() .. " rocked the vote!",Vector(215,115,115),true)
		HEX.AddRTV()

        return ""

    end
    if string.sub(text,0,8) == "/mapvote" then
		if HEX.MapVote.Active == 1 then
			net.Start( "mapvotesend" )
				net.WriteTable(HEX.MapVote.MapList)
			net.Send(player)
		end
		return ""
	end
end
hook.Add("PlayerSay", "HEXCheckChatforRTVHook", HEX.CheckChatforRTV )

net.Receive("addmapvote", function(len,ply)
	local map = net.ReadInt(3)
	local name = net.ReadString()

	if ply.VotedMap == map then
		HexMsg(ply,"Map Vote","You've already voted for "..name..".",Vector(185,215,115),false)
		return
	end

	if ply.VotedMap == 0 then
		HEX.MapVote.MapList[map].votes = HEX.MapVote.MapList[map].votes + 1

		ply.VotedMap = map

		HexMsg(ply,"Map Vote","Voted for "..name..".",Vector(185,215,115),false)

		net.Start("updatemapvote")
			net.WriteTable(HEX.MapVote.MapList)
		net.Broadcast()
	else
		HEX.MapVote.MapList[ply.VotedMap].votes = HEX.MapVote.MapList[ply.VotedMap].votes - 1
		HEX.MapVote.MapList[map].votes = HEX.MapVote.MapList[map].votes + 1

		ply.VotedMap = map

		HexMsg(ply,"Map Vote","Voted for "..name..".",Vector(185,215,115),false)

		net.Start("updatemapvote")
			net.WriteTable(HEX.MapVote.MapList)
		net.Broadcast()
	end
end)


net.Receive("addgamevote", function(len,ply)
	local game = net.ReadInt(10)
	local name = net.ReadString()

	local function MatchGametypetoTable(m)
        for a, b in pairs(HEX.GametypeTable) do
            if m == a then
                return a
            end
        end
    end

    local GametypeID = MatchGametypetoTable(game)
	HexMsg(ply,"Gametype Info",HEX.GametypeTable[GametypeID].desc,Vector(185,215,115),false)

	if ply.VotedGameType == game then
		HexMsg(ply,"Gametype","You've already voted for "..name..".",Vector(185,215,115),false)
		return
	end

	if ply.VotedGameType == 0 then
		HEX.MapVote.GameList[game].votes = HEX.MapVote.GameList[game].votes + 1

		ply.VotedGameType = game

		HexMsg(ply,"Gametype","Voted for "..name..".",Vector(185,215,115),false)

		net.Start("updategamevote")
			net.WriteTable(HEX.MapVote.GameList)
		net.Broadcast()
	else
		HEX.MapVote.GameList[ply.VotedGameType].votes = HEX.MapVote.GameList[ply.VotedGameType].votes - 1
		HEX.MapVote.GameList[game].votes = HEX.MapVote.GameList[game].votes + 1

		ply.VotedGameType = game

		HexMsg(ply,"Gametype","Voted for "..name..".",Vector(185,215,115),false)

		net.Start("updategamevote")
			net.WriteTable(HEX.MapVote.GameList)
		net.Broadcast()
	end
end)