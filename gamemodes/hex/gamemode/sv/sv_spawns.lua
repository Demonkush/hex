-- Unique spawn system
HEX.EntSpawnTable.PlayerSpawns = {}
HEX.EntSpawnTable.TeamSpawns = {}
HEX.EntSpawnTable.LootCrates = {}
HEX.EntSpawnTable.Powerups = {}
HEX.EntSpawnTable.Traps = {}
HEX.EntSpawnTable.RandomCrests = {}
HEX.EntSpawnTable.Obelisk = {}
HEX.EntSpawnTable.SpecifiedCrests = {}
HEX.SpawnsValidated = false

HEX.Spawnpoints = {}
HEX.TeamSpawnpoints = {}

function HEX.SendSpawnstoClient(ply)
	net.Start("hexdebugspawndisplay")
		net.WriteTable(HEX.EntSpawnTable)
	net.Send(ply)
end

local spawnents = {"ent_hex_a_spawnplayer","ent_hex_a_spawnteam"}
function HEX.RemoveSpawns()
	for k, v in pairs(ents.GetAll()) do
		if table.HasValue(spawnents,v:GetClass()) then
			v:Remove()
		end
	end
	HEX.Spawnpoints = {}
	HEX.TeamSpawnpoints = {}
end

function HEX.CreateSpawns()
	if HEX.SpawnsValidated == false then return end
	if HEX.EntSpawnTable.PlayerSpawns then
		for k, v in pairs(HEX.EntSpawnTable.PlayerSpawns) do
	        local ent = ents.Create( "ent_hex_a_spawnplayer" )
	        ent:SetPos(v)
	        ent:Spawn()
	        table.insert(HEX.Spawnpoints,ent)
		end
	end
	if HEX.EntSpawnTable.TeamSpawns then
		for k, v in pairs(HEX.EntSpawnTable.TeamSpawns) do
	        local ent = ents.Create( "ent_hex_a_spawnteam" )
	        ent:SetPos(v.pos)
	        ent:Spawn()

	        ent:TeamSet(v.team)
	        table.insert(HEX.TeamSpawnpoints,ent)
		end
	end
end

function HEX.SpawnLootCrate()
	if HEX.SpawnsValidated == false then return end
	if HEX.EntSpawnTable.LootCrates then
		local r = math.random(1, #HEX.EntSpawnTable.LootCrates)
		for k, v in pairs(HEX.EntSpawnTable.LootCrates) do
			if k == r then
		        local ent = ents.Create( "ent_hex_lootcrate" )
		        ent:SetPos(v+Vector(0,0,32))
		        ent:Spawn()
			end
		end
	end
end

function HEX.SpawnObelisk()
	if HEX.SpawnsValidated == false then return end
	if HEX.MOD.ObeliskToggle == false then return end
	if HEX.EntSpawnTable.Obelisk then
		for k, v in pairs(HEX.EntSpawnTable.Obelisk) do

	        local ent = ents.Create( "ent_hex_a_obelisk" )
	        ent:SetPos(v.pos+Vector(0,0,8))
	        ent:Spawn()

	        if HEX.Teamplay == true then
		        v:SetOwningTeam(v.obeliskteam)
	        end
		end
	end
end

function HEX.SpawnCrestsforRound(mode)
	if HEX.SpawnsValidated == false then return end
	if HEX.MOD.CrestToggle == false then return end
	if mode == 1 or mode == 0 then
		HEX.SpawnCrestRandom(false)
	end
	if mode == 2 or mode == 0 then
		HEX.SpawnCrestSpecified()
	end
end

function HEX.SpawnCrestRandom(random)
	if HEX.SpawnsValidated == false then return end
	if HEX.EntSpawnTable.RandomCrests then
		local r = math.random(1, #HEX.EntSpawnTable.RandomCrests)
		for k, v in pairs(HEX.EntSpawnTable.RandomCrests) do
			if random == true then
				if k == r then
					for x, y in pairs(ents.FindInSphere(v,55)) do
						if y.Crest == true then
							y:Remove()
						end
				    end
			        local ent = ents.Create( table.Random(HEX.CrestTableLite) )
			        ent:SetPos(v)
			        ent:Spawn()
				end
			else
				for x, y in pairs(ents.FindInSphere(v,55)) do
					if y.Crest == true then
						y:Remove()
					end
			    end
				local ent = ents.Create( table.Random(HEX.CrestTableLite) )
		        ent:SetPos(v)
		        ent:Spawn()
			end
		end
	end
end

local explosioncrests = {"ent_hex_a_infernocrest","ent_hex_a_tidalcrest","ent_hex_a_plaguecrest","ent_hex_a_staticcrest","ent_hex_a_tundracrest","ent_hex_a_magicbombcrest"}
local spiritcrests = {"ent_hex_a_spiritoffirecrest","ent_hex_a_spiritoffrostcrest","ent_hex_a_spiritofstormcrest","ent_hex_a_spiritofpoisoncrest","ent_hex_a_spiritofarcanecrest"}
local resistancecrests = {"ent_hex_a_fireresistcrest","ent_hex_a_frostresistcrest","ent_hex_a_stormresistcrest","ent_hex_a_poisonresistcrest","ent_hex_a_magicresistcrest"}
local restorativecrests = {"ent_hex_a_lifecrest","ent_hex_a_rejuvinationcrest","ent_hex_a_manacrest","ent_hex_a_holycrest"}
function HEX.SpawnCrestSpecified()
	if HEX.SpawnsValidated == false then return end
	if HEX.EntSpawnTable.SpecifiedCrests then
		for k, v in pairs(HEX.EntSpawnTable.SpecifiedCrests) do
			local cr = v.crest
			if HEX.MOD.LoadoutCrestToggle == false then
				if v.crest == "ent_hex_a_loadoutcrest" then return end
			end
			if v.crest == "explosioncrest" then
				cr = table.Random(explosioncrests)
			end
			if v.crest == "spiritcrest" then
				cr = table.Random(spiritcrests)				
			end
			if v.crest == "resistancecrest" then
				cr = table.Random(resistancecrests)				
			end
			if v.crest == "restorativecrest" then
				cr = table.Random(restorativecrests)				
			end
			for x, y in pairs(ents.FindInSphere(v.pos,55)) do
				if y.Crest == true then
					y:Remove()
				end
		    end
	        local ent = ents.Create( cr )
	        ent:SetPos(v.pos)
	        ent:Spawn()
		end
	end
end

function HEX.SpawnPowerup(mode)
	if HEX.SpawnsValidated == false then return end
	if HEX.EntSpawnTable.Powerups then
		if mode == 2 then 
			local r = math.random(1,#HEX.EntSpawnTable.Powerups)
			for k, v in pairs(HEX.EntSpawnTable.Powerups) do
				if k == r then
					local pr = v.powerup

					for x, y in pairs(ents.FindInSphere(v.pos,55)) do
						if y:GetClass() == "ent_hex_powerup" then
							y:Remove()
						end
				    end
			        local ent = ents.Create( "ent_hex_powerup" )
			        ent:SetPos(v.pos)
			        ent:Spawn()

			        if pr == "random" then ent:SetRandomItemInfo() return end
			        ent:SetItemInfo(pr)
			    end
			end
		end

		if mode == 1 then
			for k, v in pairs(HEX.EntSpawnTable.Powerups) do
				local pr = v.powerup

				for x, y in pairs(ents.FindInSphere(v.pos,55)) do
					if y:GetClass() == "ent_hex_powerup" then
						y:Remove()
					end
			    end
		        local ent = ents.Create( "ent_hex_powerup" )
		        ent:SetPos(v.pos)
		        ent:Spawn()

		        if pr == "random" then ent:SetRandomItemInfo() return end
		        ent:SetItemInfo(pr)
			end
		end
	end
end

function HEX.AddPlayerSpawn(pos)
	table.insert(HEX.EntSpawnTable.PlayerSpawns,pos)
end
concommand.Add("hex_addplayerspawn",function(ply) if ply:IsSuperAdmin() == true then HEX.AddPlayerSpawn(ply:GetPos()) end end,nil,"Add Player Spawn usage: hex_addcrestspecific crest(ent) pos(vector)")

function HEX.AddTeamSpawn(a,b)
	table.insert(HEX.EntSpawnTable.TeamSpawns,{team=a,pos=b})
end
concommand.Add("hex_addteamspawn",function(ply,cmd,args) if ply:IsSuperAdmin() == true then HEX.AddTeamSpawn(args[1],ply:GetPos()) end end,nil,"Add Team Spawn usage: hex_addcrestspecific crest(ent) pos(vector)")

function HEX.AddCrate(pos)
	table.insert(HEX.EntSpawnTable.LootCrates,pos)
end
concommand.Add("hex_addcrate",function(ply) if ply:IsSuperAdmin() == true then HEX.AddCrate(ply:GetPos()) end end,nil,"Add Crate usage: hex_addcrestspecific crest(ent) pos(vector)")

function HEX.AddTrap(a,b,c,d,e,f,g,h)
	table.insert(HEX.EntSpawnTable.Traps,{trap=a,pos=b,projectile=c,range=d,delay=e,force=f,alwaysfire=g,gravity=h})
end
concommand.Add("hex_addtrap",function(ply,cmd,args) 
	if ply:IsSuperAdmin() == true then 
		HEX.AddTrap(args[1],ply:GetPos(),args[2],args[3],args[4],args[5],args[6],args[7]) 
	end end, nil,
	"Add Trap usage: hex_addtrap trap(ent) pos(vector) projectile(ent) range delay force alwaysfire(bool) gravity(bool)"
)

function HEX.AddRandomCrest(pos)
	table.insert(HEX.EntSpawnTable.RandomCrests,pos)
end
concommand.Add("hex_addcrestrandom",function(ply) if ply:IsSuperAdmin() == true then HEX.AddRandomCrest(ply:GetPos()) end end,nil,"Add Crest Random usage: hex_addcrestrandom pos(vector)")

function HEX.AddSpecifiedCrest(a,b)
	table.insert(HEX.EntSpawnTable.SpecifiedCrests,{crest=a,pos=b})
end
concommand.Add("hex_addcrestspecific",function(ply,cmd,args) if ply:IsSuperAdmin() == true then HEX.AddSpecifiedCrest(args[1],ply:GetPos()) end end,nil,"Add Crest Specific usage: hex_addcrestspecific crest(ent) pos(vector)")

function HEX.AddObelisk(a,b)
	table.insert(HEX.EntSpawnTable.Obelisk,{obeliskteam=a,pos=b})
end
concommand.Add("hex_addobelisk",function(ply,cmd,args) if ply:IsSuperAdmin() == true then HEX.AddObelisk(args[1],ply:GetPos()) end end,nil,"Add Obelisk usage: hex_addobelisk team(number) pos(vector)")

function HEX.AddPowerup(a,b)
	table.insert(HEX.EntSpawnTable.Powerups,{powerup=a,pos=b})
end
concommand.Add("hex_addpowerup",function(ply,cmd,args) if ply:IsSuperAdmin() == true then HEX.AddPowerup(args[1],ply:GetPos()) end end,nil,"Add Powerup usage: hex_addpowerup powerup(ent) pos(vector)")

concommand.Add("hex_debug",function(ply,cmd,args) if ply:IsSuperAdmin() == true then HEX.SendSpawnstoClient(ply) end end,nil,"Debug usage: hex_debug")


function HEX.SaveMapSpawns()
	local map = game.GetMap()
	local path = "hex/"..map..".txt"

	local spawns = util.TableToJSON(HEX.EntSpawnTable)
	if !file.Exists("hex","DATA") then
		file.CreateDir("hex")
	end

	file.Write(path,spawns)
end
concommand.Add("hex_mapsave",function(ply) if ply:IsSuperAdmin() == true then HEX.SaveMapSpawns() end end,nil)

function HEX.LoadMapSpawns()
	local map = game.GetMap()
	local path = "hex/"..map..".txt"

	if file.Exists(path,"DATA") then
		local load = file.Read(path,"DATA")
		local spawns = util.JSONToTable( load )

		table.Empty(HEX.EntSpawnTable)
		HEX.EntSpawnTable = table.Copy(spawns)

		HEX.SpawnsValidated = true
		HEX.RevitalizeSpawnTable()
		timer.Simple(0.5,function()
			HEX.CreateSpawns()
		end)
	else
		print("Loot configuration missing for "..map..".bsp!")
	end
end
concommand.Add("hex_mapload",function(ply) if ply:IsSuperAdmin() == true then HEX.LoadMapSpawns() end end,nil)

function HEX.RevitalizeSpawnTable()
	if !HEX.EntSpawnTable.PlayerSpawns then
		HEX.EntSpawnTable.PlayerSpawns = {}
	end
	if !HEX.EntSpawnTable.TeamSpawns then
		HEX.EntSpawnTable.TeamSpawns = {}
	end
	if !HEX.EntSpawnTable.LootCrates then
		HEX.EntSpawnTable.LootCrates = {}
	end
	if !HEX.EntSpawnTable.Powerups then
		HEX.EntSpawnTable.Powerups = {}
	end
	if !HEX.EntSpawnTable.Traps then
		HEX.EntSpawnTable.Traps = {}
	end
	if !HEX.EntSpawnTable.RandomCrests then
		HEX.EntSpawnTable.RandomCrests = {}
	end
	if !HEX.EntSpawnTable.Obelisk then
		HEX.EntSpawnTable.Obelisk = {}
	end
	if !HEX.EntSpawnTable.SpecifiedCrests then
		HEX.EntSpawnTable.SpecifiedCrests = {}
	end
end