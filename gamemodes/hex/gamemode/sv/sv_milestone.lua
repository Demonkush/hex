HEX.MilestoneCycle = 1
HEX.MilestoneTable = {}
function HEX.MilestoneFunc()
	if #player.GetAll() < 2 then return end

	table.Empty(HEX.MilestoneTable)
	for k, v in pairs(player.GetAll()) do
		table.insert(HEX.MilestoneTable,v)
	end

	if HEX.MilestoneCycle == 1 then
		-- Gold
		table.sort( HEX.MilestoneTable, function( a, b ) return a:GetGold() > b:GetGold() end )
		for k, v in pairs(HEX.MilestoneTable) do
			if k == 1 then
				if v:GetGold() > 1 then
					HexMsg(self,"Milestone",v:Name().. " is leading over a total of "..v:GetGold().." Gold!",Vector(215,185,115),true)
				end
			end
		end

		HEX.MilestoneCycle = 2
		if HEX.Gametype == "Greed" then
			HEX.MilestoneCycle = 1
		end

	elseif HEX.MilestoneCycle == 2 then
		-- Kills
		table.sort( HEX.MilestoneTable, function( a, b ) return a:Frags() > b:Frags() end )
		for k, v in pairs(HEX.MilestoneTable) do
			if k == 1 then
				if v:Frags() > 1 then
					HexMsg(self,"Milestone",v:Name().. " is leading over a total of "..v:Frags().." Kills!",Vector(215,185,115),true)
				end
			end
		end

		HEX.MilestoneCycle = 3
		
	elseif HEX.MilestoneCycle == 3 then
		-- Deaths
		table.sort( HEX.MilestoneTable, function( a, b ) return a:Deaths() > b:Deaths() end )
		for k, v in pairs(HEX.MilestoneTable) do
			if k == 1 then
				if v:Deaths() > 1 then
					HexMsg(self,"Milestone",v:Name().. " is leading over a total of "..v:Deaths().." Deaths!",Vector(215,185,115),true)
				end
			end
		end

		HEX.MilestoneCycle = 1
	end
end