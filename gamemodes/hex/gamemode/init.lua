-- Hex by Demonkush

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh/sh_maintable.lua" )
AddCSLuaFile( "sh/sh_gametypetable.lua" )
AddCSLuaFile( "sh/sh_crests.lua" )
AddCSLuaFile( "sh/sh_itemtable.lua" )
AddCSLuaFile( "sh/sh_poweruptable.lua" )
AddCSLuaFile( "sh/sh_weapontable.lua" )
AddCSLuaFile( "sh/sh_ranktable.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl/cl_fonts.lua" )
AddCSLuaFile( "cl/cl_hud.lua" )
AddCSLuaFile( "cl/cl_loadoutmenu.lua" )
AddCSLuaFile( "cl/cl_mapvote.lua" )
AddCSLuaFile( "cl/cl_gamevote.lua" )
AddCSLuaFile( "cl/cl_settingsmenu.lua" )
AddCSLuaFile( "cl/cl_scoreboard.lua" )
AddCSLuaFile( "cl/cl_shopmenu.lua" )
AddCSLuaFile( "cl/cl_thirdperson.lua" )
include('shared.lua')
include('sh/sh_maintable.lua')
include('sh/sh_gametypetable.lua')
include('sh/sh_crests.lua')
include('sh/sh_itemtable.lua')
include('sh/sh_poweruptable.lua')
include('sh/sh_weapontable.lua')
include('sh/sh_ranktable.lua')
include('sv/damage_meta.lua')
include('sv/player_meta.lua')
include('sv/player_meta_buffs.lua')
include('sv/sv_brutal.lua')
include('sv/sv_mapvote.lua')
include('sv/sv_mysql.lua')
include('sv/sv_spawns.lua')
include('sv/sv_milestone.lua')
include('sv/sv_msgsys.lua')
include('sv/sv_player.lua')
include('sv/sv_resources.lua')
include('sv/sv_roundsys.lua')

util.AddNetworkString( "loadoutsend" )
util.AddNetworkString( "playermodelsend" )
util.AddNetworkString( "playertitlesend" )
util.AddNetworkString( "mapvotesend" )
util.AddNetworkString( "gamevotesend" )
util.AddNetworkString( "rtvsend" )
util.AddNetworkString( "addmapvote" )
util.AddNetworkString( "addgamevote" )
util.AddNetworkString( "updatemapvote" )
util.AddNetworkString( "updategamevote" )
util.AddNetworkString( "updateitemcooldown" )
util.AddNetworkString( "updategamemodeinfo" )
util.AddNetworkString( "updatetitletable" )
util.AddNetworkString( "ply_notification_info" )
util.AddNetworkString( "hexroundstate" )
util.AddNetworkString( "hexdebugspawndisplay" )
util.AddNetworkString( "updateroundtimer" )
util.AddNetworkString( "hexnetworkcrests" )

-- connect to mysql database
-- DISABLED BY DEFAULT! TO ENABLE, GO TO "sh/sh_maintable.lua"
-- I recommend you change the mysql fail password too.
if HEX.DebugSQL == false then
	timer.Simple(0.1, function()
		omsql.connect({"127.0.0.1", "hex", "MYSQLPASSWORD", "hex", 12345}, function(db)
			print("[HEX SQL SUCCESS] Successfully connected to database.")
			hook.Run("HexMySQL", db)
		end, function()
			print("[FATAL SQL ERROR!] Could not connect to mysql database. Password locking server for safety.")
			RunConsoleCommand("sv_password", "am52pamfap3m6l47w") -- change this!
		end)
	end)
end

function HEX.SendGamemodeInfo(global,ply)
	local gametype = string.upper(HEX.Gametype[1])..""..string.sub(HEX.Gametype,2,#HEX.Gametype)
	if global == true then
		net.Start("updategamemodeinfo")
			net.WriteString(gametype)
			net.WriteBool(HEX.Teamplay)
			net.WriteString(HEX.Objective)
			net.WriteString(HEX.ObjectiveDesc)
		net.Broadcast()
	elseif global == false then
		if IsValid(ply) && ply:IsPlayer() then
			net.Start("updategamemodeinfo")
				net.WriteString(gametype)
				net.WriteBool(HEX.Teamplay)
				net.WriteString(HEX.Objective)
				net.WriteString(HEX.ObjectiveDesc)
			net.Send(ply)
		end
	end
end

function HEX.LoadGametypeSettings()
	local function MatchGametypetoTable(t)
		for a, b in pairs(HEX.GametypeTable) do
			if t == b.name then
				return a
			end
		end
	end

	local GametypeID = MatchGametypetoTable(HEX.Gametype)

	if GametypeID == nil then
		GametypeID = 1
	end
	HEX.GametypeTable[GametypeID].settings()

	HEX.SpawnCrestsforRound(0)	
	HEX.SendGamemodeInfo(true)
end

function GM:Think()
	if gamemode.CrestRefreshTick < CurTime() then
		for k, v in pairs(ents.GetAll()) do
			if v.Crest == true then
				v:SetNWBool("CrestActive",v:GetNWBool("CrestActive"))
			end
		end
		gamemode.CrestRefreshTick = CurTime() + 5
	end
	if gamemode.GoldTick < CurTime() then
		self:SendGoldInfo()
		gamemode.GoldTick = CurTime() + 1
	end
	if gamemode.ManaTick < CurTime() then
		self:SendManaInfo()
		gamemode.ManaTick = CurTime() + 0.5
	end
	if gamemode.RegenTick < CurTime() then
		self:RegenTickFunc()
		gamemode.RegenTick = CurTime() + 1
	end
	if gamemode.LastHitTick < CurTime() then
		self:LastHitRefresh()
		gamemode.LastHitTick = CurTime() + 1
	end
	if gamemode.RoundTick < CurTime() then

			HEX.CheckRound()
			HEX.SendGamemodeInfo()

		gamemode.RoundTick = CurTime() + 5
	end
	if HEX.MOD.MilestoneToggle == true then
		if gamemode.MilestoneTick < CurTime() then
			HEX.MilestoneFunc()
			gamemode.MilestoneTick = CurTime() + 240
		end
	end
	if HEX.MOD.LootCrateToggle == true then
		if gamemode.LootSpawnTick < CurTime() then
			HEX.SpawnLootCrate()
			gamemode.LootSpawnTick = CurTime() + HEX.MOD.LootSpawnTick
		end
	end
	if HEX.MOD.PowerupsToggle == true then
		if gamemode.PowerupSpawnTick < CurTime() then
			HEX.SpawnPowerup(2)
			gamemode.PowerupSpawnTick = CurTime() + HEX.MOD.PowerupSpawnTick
		end
	end
end

function GM:SendGoldInfo()
	if HEX.MOD.PaydayToggle == true then
		for a, b in pairs(player.GetAll()) do
			if b:Frags() > 1 then 
				if b.NextPayday < CurTime() then
					local g = 5 + (b:Frags()*2)
					b:AddGold(g)
					b.NextPayday = CurTime()+120
					HexMsg(b,"Payday","+"..g.." Gold!",Vector(215,185,115),false)
				end
			end
		end
	end
end

function GM:SendManaInfo()
	if HEX.MOD.PlayerMPRegenToggle == true then
		for a, b in pairs(player.GetAll()) do
			if b.NextManaRegen < CurTime() then
				b:AddMana(b.ManaRegenRate)
			end
		end
	end
end

function GM:RegenTickFunc()
	if HEX.MOD.PlayerHPRegenToggle == true then
		for a, b in pairs(player.GetAll()) do
			if b:Alive() then
				if b.NextHealthRegen < CurTime() then
					if b:Health() >= b:GetNWInt("MaxHealth") then
						b:SetHealth(b:GetNWInt("MaxHealth"))
					else
						b:SetHealth(b:Health()+b.HealthRegenRate)

						umsg.Start("SendHPEffects",b)
						umsg.End()
					end
				end
			end
		end
	end
end

function GM:LastHitRefresh()
	for a, b in pairs( player.GetAll() ) do
		if b.LastHitDelay < CurTime() then
			b.LastHit = nil
			b.LastHitDelay = CurTime() + 7
		end
	end
end

-- Menu Buttons
function GM:ShowHelp(ply)
	HexLoadout(ply)
end

function GM:ShowTeam(ply)
	if HEX.MOD.SkirmishShopToggle == true then
		HexShopMenu(ply)
	end
end

function GM:ShowSpare1(ply)
	HexSettings(ply)
end