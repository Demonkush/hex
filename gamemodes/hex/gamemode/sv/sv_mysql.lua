require("sv_mysql")

local plytbl
local stattbl

function HEX.GetPlayerMySQL()
	return plytbl
end

function HEX.GetGlobalStatsMySQL()
	return stattbl
end

hook.Add("HexMySQL", "HexPlayerData", function(db)
	local dbtbl = db:newTable("hex_player_info")
	
	local column = dbtbl:newColumn("steamid64", omsql.TYPE_INTEGER)
	column:setPrimaryKey(true)
	column:setBytes(8)
	column:addOption("NOT NULL")
	
	local column = dbtbl:newColumn("ply_rank_lvl", omsql.TYPE_INTEGER)
	column:setBytes(4)
	column:addOption("NOT NULL")
	
	local column = dbtbl:newColumn("ply_rank_lvlmax", omsql.TYPE_INTEGER)
	column:setBytes(4)
	column:addOption("NOT NULL")
	
	local column = dbtbl:newColumn("ply_rank_exp", omsql.TYPE_INTEGER)
	column:setBytes(4)
	column:addOption("NOT NULL")
	
	local column = dbtbl:newColumn("ply_rank_expmax", omsql.TYPE_INTEGER)
	column:setBytes(4)
	column:addOption("NOT NULL")

	dbtbl:create()
	
	plytbl = dbtbl
end)

local Ply = FindMetaTable("Player")

function Ply:LoadData()
	if self:Loaded() then
		error("Player already loaded, operation not permitted")
	end
	self.LoadedSQL = true

	plytbl:selectAll(
		{steamid64 = self:SteamID64() or 0},
		function(sqlData)
			if not IsValid(self) then return end
			
			-- new players, first time entering server
			if not sqlData or #sqlData == 0 then
				
				self:SetNWString("Rank","Rookie")
				self:SetNWInt("RankLevel",1)
				self:SetNWInt("RankLevelMax",100)
				self:SetNWInt("Experience",0)
				self:SetNWInt("ExperienceMax",100)

			else
				local data = sqlData[1]
				-- These methods don't force a data save
				-- because they change often.
				-- See SaveData
				self:SetNWInt("RankLevel",data.ply_rank_lvl)
				self:SetNWInt("RankLevelMax",data.ply_rank_lvlmax)
				self:SetNWInt("Experience",data.ply_rank_exp)
				self:SetNWInt("ExperienceMax",data.ply_rank_expmax)
			end
		end
	)
end

-- add a function to be called once the player is done loading
function Ply:OnLoaded(func)
	if self:Loaded() then func() return end
	self.onLoaded = self.onLoaded or {}
	self.onLoaded[func] = true
end

function Ply:Loaded()
	-- currently there are 3 data stages: player data, inventory, and bank
	return self.LoadedSQL == true
end

-- Called to verify that there will be no data hazard.
-- If the player's data has not been loaded, throw an error instead of proceeding.
function Ply:VerifyData()
	if not self:Loaded() then
		-- unfortunately mysqloo has a bug that causes stack traces to be empty
		-- so if it doesn't contain a trace stack, assume it originated from a mysql callback
		debug.traceback()
		error("Attempt to read or write to player's data before it has been loaded.")
	end
end

-- Save basic player data. This should be called occasionally, not on change.
function Ply:SaveData()
	self:VerifyData()

	plytbl:replace({self:SteamID64() or 0, self:GetNWInt("RankLevel"), self:GetNWInt("RankLevelMax"), self:GetNWInt("Experience"), self:GetNWInt("ExperienceMax")})
end