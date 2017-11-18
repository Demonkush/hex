function HexHUDDraw()
	local self = LocalPlayer()

	-- RTV
	if HEX.MapVote.RTVActive == 1 then
		draw.SimpleTextOutlined("Rock the Vote: "..HEX.MapVote.CurrentRTV,"HexFontSmall",ScrW()/2,75,Color(255,115,115,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,155))
		draw.SimpleTextOutlined("Time Left: "..math.Round( HEX.MapVote.RTVTime-CurTime() ),"HexFontTiny",ScrW()/2,95,Color(255,175,175,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,155))
	end

	-- Round
	if HEX.Round.RoundState == 0 then
		draw.SimpleTextOutlined("Waiting to start...","HexFontMedium",ScrW()/2,25,Color(215,215,215,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,155))
	end
	if HEX.Round.RoundState == 1 then
		draw.SimpleTextOutlined("Round Active","HexFontMedium",ScrW()/2,25,Color(215,245,215,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,155))
		if HEX.Round.Timer > 1 then
			draw.SimpleTextOutlined("Time Left: "..string.FormattedTime( HEX.Round.Timer, "%02i:%02i" ),"HexFontSmall",ScrW()/2,65,Color(245,215,185,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,155))
		end
	end
	if HEX.Round.RoundState == 2 then
		draw.SimpleTextOutlined("Round over!","HexFontMedium",ScrW()/2,25,Color(255,215,155,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,155))
	end

	-- Gold
	draw.SimpleTextOutlined("Gold: " .. LocalPlayer():GetNWInt("Gold"),"HexFontMedium",ScrW()/2,ScrH()-32,Color(255,215,155,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,155))

	local hp = math.Clamp(LocalPlayer():Health(),0,100)
	local mp = math.Clamp(LocalPlayer():GetNWInt("Mana"),0,100)

	local baseicon = "hexgm/ui/icon_blank.png" 

	local function MatchWeptoTable()
		local ico = "hexgm/ui/icon_blank.png" 
		if !LocalPlayer():Alive() then return ico end
		for a, b in pairs(HEX.WeaponTable) do
			if LocalPlayer():GetNWString("CurrentWeapon") == "none" then return ico end
			if LocalPlayer():GetNWString("CurrentWeapon") == b.wep then
				if b.icon != nil then
					ico = b.icon
				end
				return ico
			end
		end
	end
	local function MatchItemtoTable()
		local ico = "hexgm/ui/icon_blank.png" 
		if !LocalPlayer():Alive() then return ico end
		for c, d in pairs(HEX.ItemTable) do
			if LocalPlayer():GetNWString("CurrentItem") == "none" then return ico end
			if LocalPlayer():GetNWString("CurrentItem") == d.id then
				if d.icon != nil then
					ico = d.icon
				end
				return ico
			end
		end
	end

	-- Health Bar
	surface.SetDrawColor(Color(75,75,75,25))
	surface.DrawOutlinedRect(ScrW()/2-302,ScrH()-112,204,39)

	surface.SetDrawColor(Color(155,55,55,155))
	surface.DrawRect(ScrW()/2-290,ScrH()-105,180,25)
	surface.SetDrawColor(Color(255,155,155,35))
	surface.DrawRect(ScrW()/2-100+(hp*-2),ScrH()-110,hp*2,35)
	draw.SimpleTextOutlined("Health: " .. LocalPlayer():Health(),"HexFontSmall",ScrW()/2-285,ScrH()-93,Color(215,155,115,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(0,0,0,100))

	-- Respawn timer
	if LocalPlayer().RespawnTime-1 > CurTime() then
		draw.SimpleTextOutlined("- Respawning in " .. math.Round( LocalPlayer().RespawnTime-CurTime() ).." -","HexFontMedium",ScrW()/2,ScrH()/2,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
	end

	-- Mana Pool
	surface.SetDrawColor(Color(75,75,75,25))
	surface.DrawOutlinedRect(ScrW()/2+98,ScrH()-112,204,39)

	surface.SetDrawColor(Color(55,55,155,155))
	surface.DrawRect(ScrW()/2+110,ScrH()-105,180,25)
	surface.SetDrawColor(Color(155,155,255,35))
	surface.DrawRect(ScrW()/2+100,ScrH()-110,mp*2,35)

	draw.SimpleTextOutlined(LocalPlayer():GetNWInt("Mana") .. " :Mana","HexFontSmall",ScrW()/2+285,ScrH()-93,Color(115,155,215,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,100))

	-- Weapon
	--if IsValid(LocalPlayer():GetActiveWeapon()) then
	--	draw.SimpleTextOutlined(LocalPlayer():GetActiveWeapon().PrintName,"HexFontTiny",ScrW()/2-50,ScrH()-150,Color(255,215,155,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
	--end
	surface.SetDrawColor(Color(75,75,75,55))
	surface.DrawOutlinedRect(ScrW()/2-84,ScrH()-132,72,72)

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( Material( baseicon ) )
	surface.DrawTexturedRect( ScrW()/2-80,ScrH()-128, 64, 64 )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( Material( MatchWeptoTable() ) )
	surface.DrawTexturedRect( ScrW()/2-80,ScrH()-128, 64, 64 )


	-- Item
	surface.SetDrawColor(Color(75,75,75,55))
	surface.DrawOutlinedRect(ScrW()/2+12,ScrH()-132,72,72)

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( Material( baseicon ) )
	surface.DrawTexturedRect( ScrW()/2+16,ScrH()-128, 64, 64 )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( Material( MatchItemtoTable() ) )
	surface.DrawTexturedRect( ScrW()/2+16,ScrH()-128, 64, 64 )

	-- Item
	--draw.SimpleTextOutlined(LocalPlayer():GetNWString("MainItem"),"HexFontTiny",ScrW()/2+50,ScrH()-150,Color(255,215,155,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))

	DrawFloatingDmg( self ) -- Floating Damage Numbers by Crashlemon
	DrawKillInfo( self ) -- Kill Info by Crashlemon
	DrawTargetInfo( self ) -- Target Info by Demonkush
	DrawBuffIcons( self ) -- Buff Icons by Demonkush
	DrawCooldowns( self ) -- Cooldowns by Demonkush
	DrawNotifInfo( self )
	DrawObjective( self )
	if self.drawScoreboard then
		HEX_Scoreboard( self )
	end
	DrawSpawnDisplay( self )
end
hook.Add("HUDPaint","HEXHUDDRAWHOOK",HexHUDDraw)

function DrawSpawnDisplay( self )
	if HEX.EntSpawnTable.PlayerSpawns then
		for k, v in pairs(HEX.EntSpawnTable.PlayerSpawns) do
			local ts = (v + Vector(0,0,16)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet22",ts.x,ts.y,Color(55,255,55,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
			draw.SimpleTextOutlined("Player Spawn","Trebuchet22",ts.x,ts.y-15,Color(55,255,55,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
		end
	end
	if HEX.EntSpawnTable.TeamSpawns then
		for k, v in pairs(HEX.EntSpawnTable.TeamSpawns) do
			local ts = (v.pos + Vector(0,0,16)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet22",ts.x,ts.y,Color(255,255,255,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
			draw.SimpleTextOutlined("Team Spawn( "..v.team.." )","Trebuchet22",ts.x,ts.y-15,Color(255,255,255,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
		end
	end
	if HEX.EntSpawnTable.LootCrates then
		for k, v in pairs(HEX.EntSpawnTable.LootCrates) do
			local ts = (v + Vector(0,0,16)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet22",ts.x,ts.y,Color(255,215,155,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
			draw.SimpleTextOutlined("Loot Crate","Trebuchet22",ts.x,ts.y-15,Color(255,215,155,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
		end
	end
	if HEX.EntSpawnTable.RandomCrests then
		for k, v in pairs(HEX.EntSpawnTable.RandomCrests) do
			local ts = (v + Vector(0,0,16)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet22",ts.x,ts.y,Color(155,155,255,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
			draw.SimpleTextOutlined("Crest ( Random )","Trebuchet22",ts.x,ts.y-15,Color(155,155,255,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
		end
	end
	if HEX.EntSpawnTable.SpecifiedCrests then
		for k, v in pairs(HEX.EntSpawnTable.SpecifiedCrests) do
			local ts = (v.pos + Vector(0,0,16)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet22",ts.x,ts.y,Color(215,155,255,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
			draw.SimpleTextOutlined("Crest ( "..v.crest.." )","Trebuchet22",ts.x,ts.y-15,Color(215,155,255,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
		end
	end
	if HEX.EntSpawnTable.Powerups then
		for k, v in pairs(HEX.EntSpawnTable.Powerups) do
			local ts = (v.pos + Vector(0,0,16)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet22",ts.x,ts.y,Color(255,115,55,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
			draw.SimpleTextOutlined("Powerup ( "..v.powerup.." )","Trebuchet22",ts.x,ts.y-15,Color(255,115,55,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
		end
	end
	if HEX.EntSpawnTable.Obelisk then
		for k, v in pairs(HEX.EntSpawnTable.Obelisk) do
			local ts = (v.pos + Vector(0,0,16)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet22",ts.x,ts.y,Color(215,155,255,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
			draw.SimpleTextOutlined("Obelisk ( "..v.obeliskteam.." )","Trebuchet22",ts.x,ts.y-15,Color(215,155,255,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
		end
	end
end

function DrawObjective( self )

	local alpha = LocalPlayer().ObjectiveAlpha

	if alpha && alpha > 1 then

		draw.SimpleTextOutlined(HEX.Gametype,"HexFontMedium",ScrW()/2,115,Color(225,215,245,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,alpha-55))
		draw.SimpleTextOutlined(HEX.Objective,"HexFontSmall",ScrW()/2,145,Color(215,215,215,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,alpha-55))
		draw.SimpleTextOutlined(HEX.ObjectiveDesc,"HexFontSmall",ScrW()/2,170,Color(215,215,215,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,alpha-55))

		LocalPlayer().ObjectiveAlpha = LocalPlayer().ObjectiveAlpha - 1
	end
end

function DrawCooldowns( self )
	if self:Alive() then
		if IsValid(self:GetActiveWeapon()) then
			local wep = self:GetActiveWeapon()
			local pfire = wep:GetNextPrimaryFire()
			local sfire = wep:GetNextSecondaryFire()

			-- Weapon Cooldown
			if pfire > CurTime() then
				local pval = pfire-CurTime()
				local pmax = 72*pval
				surface.SetDrawColor(Color(25,25,25,155))
				surface.DrawRect( ScrW()/2-84, ScrH()-132, 72, math.Clamp(pmax,1,72) )
			end
			if sfire > CurTime() then
				local sval = sfire-CurTime()
				local smax = 72*sval
				surface.SetDrawColor(Color(75,25,25,215))
				surface.DrawRect( ScrW()/2-84, ScrH()-132, 72, math.Clamp(smax,1,72) )
			end
		end

		-- Item Cooldown
		local icool = self.ItemCooldown
		if icool > CurTime() then
			local ival = icool-CurTime()
			local imax = 72*ival
			surface.SetDrawColor(Color(55,25,25,215))
			surface.DrawRect( ScrW()/2+12,ScrH()-132, 72, math.Clamp(imax,1,72) )

			draw.SimpleTextOutlined(math.Round(ival),"Trebuchet18",ScrW()/2+70,ScrH()-120,Color(215,215,215,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))

		end
	end
end

function DrawBuffIcons( self )
	local marginx = 0
	local marginy = 0
	local stack = 0
	local z = 60

	local w = ScrW()/2
	local h = ScrH()

	local w1 = 485
	local h1 = 125

	local size = 48

	local statuses = {}
	statuses[1] = {status="Frozen",icon="type/frozen"}
	statuses[2] = {status="Stunned",icon="type/stun"}
	statuses[3] = {status="Slowed",icon="type/slow"}
	statuses[4] = {status="Soaked",icon="type/water"}
	statuses[5] = {status="Burning",icon="type/burning"}
	statuses[6] = {status="Poisoned",icon="type/poison"}
	statuses[7] = {status="Healing",icon="type/light"}
	statuses[8] = {status="Chilled",icon="type/chilled"}
	statuses[9] = {status="Draining",icon="type/manadrain"}
	statuses[10] = {status="Bleeding",icon="type/bleeding"}
	statuses[11] = {status="DamageResist",icon="type/armor"}
	statuses[12] = {status="AtkSpdUp",icon="type/atkspdup"}
	statuses[13] = {status="MoveSpeedUp",icon="type/quick"}
	statuses[14] = {status="Overpowered",icon="type/overpower"}
	statuses[15] = {status="Magesoul",icon="type/magesoul"}
	statuses[16] = {status="PowerupVampirism",icon="elements/blood"}
	statuses[17] = {status="PowerupInferno",icon="elements/fire"}
	statuses[18] = {status="PowerupFrostbite",icon="elements/frost"}
	statuses[19] = {status="PowerupLife",icon="elements/life"}
	statuses[20] = {status="PowerupNature",icon="elements/nature"}
	statuses[21] = {status="PowerupPoison",icon="elements/poison"}
	statuses[22] = {status="PowerupShield",icon="elements/shield"}
	statuses[23] = {status="PowerupStorm",icon="elements/storm"}

	for k, v in pairs(statuses) do
		if self:GetNWInt(v.status) == 1 then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material( "hexgm/ui/"..v.icon..".png" ) )
			surface.DrawTexturedRect( w-w1+marginx,h-h1+marginy, size, size )

			marginx = marginx + z stack = stack + 1
			if stack > 2 then stack = 0 marginy = marginy - z marginx = 0 end
		end
	end
end

function DoHealthParticles(um)
	if GetConVar("hex_cl_toggle2dparticles"):GetInt() == 0 then return end
	HEX_TestHealthParticles(10)
end
usermessage.Hook("SendHPEffects", DoHealthParticles)

function DoManaParticles(um)
	if GetConVar("hex_cl_toggle2dparticles"):GetInt() == 0 then return end
	HEX_TestManaParticles(10)
end
usermessage.Hook("SendMPEffects", DoManaParticles)

-- Floating DMG Info by Crashlemon
function DrawFloatingDmg( self )
	if GetConVar("hex_cl_toggledamagenumbers"):GetInt() == 0 then return end
	if self.FloatingDmg then
		for k,v in pairs(self.FloatingDmg) do
			v["curTime"] = v["curTime"] - FrameTime()
			if v["curTime"] <= 0 then
				table.remove( self.FloatingDmg, k )
			else
				local timeFraction = (v["maxTime"] - v["curTime"]) / v["maxTime"]
				local text = "HexFontSmall"
				local color = Color( 255, 255, 255, 155 )
				local showText = v["damage"]
				local buffColor = v["buffColor"]

				if v["showType"] == true then
					-- Setting the color for different damage types.
					if v["dmgType"] == "fire" then 
						color = Color( 255, 155, 55, 155 )

					elseif v["dmgType"] == "bleed" then
						color = Color( 215, 75, 75, 155 )

					elseif v["dmgType"] == "poison" then
						color = Color( 155, 255, 55, 155 )

					elseif v["dmgType"] == "nature" then
						color = Color( 155, 255, 155, 155 )

					elseif v["dmgType"] == "storm" then
						color = Color( 215, 235, 255, 155 )

					elseif v["dmgType"] == "magic" then
						color = Color( 185, 155, 215, 155 )

					elseif v["dmgType"] == "water" then
						color = Color( 155, 155, 215, 155 )

					elseif v["dmgType"] == "earth" then
						color = Color( 185, 155, 55, 155 )

					elseif v["dmgType"] == "light" then
						color = Color( 255, 235, 215, 155 )

					elseif v["dmgType"] == "dark" then
						color = Color( 155, 115, 155, 155 )

					elseif v["dmgType"] == "frost" then
						color = Color( 155, 215, 255, 155 )

					end

					if v["damage"] >= 20 then text = "HexFontMedium" end
					if v["damage"] >= 50 then text = "HexFontLarge" end
					if v["critical"] == true then text = "HexFontLarge" color = Color( 255, 55, 55, 155 ) end
					draw.SimpleTextOutlined( showText, text, v["screenPos"].x + v["xOffset"], v["yOffset"] + v["screenPos"].y - (120 * timeFraction), Color( color.r ,color.g ,color.b, 255 - (255 * timeFraction)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255 - (255 * timeFraction)) )
				end
				if v["showType"] == false then
					color = Color( buffColor.x, buffColor.y, buffColor.z )
					draw.SimpleTextOutlined( v["buffText"], text, v["screenPos"].x + v["xOffset"], v["yOffset"] + v["screenPos"].y - (200 * timeFraction), Color( color.r ,color.g ,color.b, 255 - (255 * timeFraction)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255 - (255 * timeFraction)) )
				end
			end
		end
	end
end

-- Floating DMG Info by Crashlemon
function ShowFloatingDamage(um)
	local ply = LocalPlayer()
	local dmg = um:ReadShort() / 10
	local t = um:ReadString()
	local victimPos = um:ReadVector()
	local crit = um:ReadBool()
	local a = um:ReadBool()
	local b = um:ReadVector()
	local c = um:ReadString()
	local DamageTable = { 
			damage = dmg, 
			dmgType = t, 
			curTime = 1.4,
			maxTime = 1.4, 
			screenPos = (victimPos + Vector(0, 0, 40)):ToScreen(),
			yOffset = table.getn( ply.FloatingDmg ) * 10,
			xOffset = math.Rand( -30, 30 ),
			critical = crit,
			showType = a,
			buffColor = b,
			buffText = c
		}
	table.insert( ply.FloatingDmg, DamageTable )
end
usermessage.Hook("ply_floating_dmg", ShowFloatingDamage)

-- Death Info by Crashlemon, from Lment
function DrawKillInfo( self )

	if !self.KillTable then return end

	local twep = "none"
	-- For each kills, draw it on the top right.
	for k,v in pairs(self.KillTable) do
		-- If they left or whatever, remove them from the table.
		twep = v.wep

		if v.expire < CurTime() then 
			table.remove(self.KillTable, k)
		else

			local function MatchWeptoTable(x)
				local ico = "hexgm/ui/killicon.png" 
				for a, b in pairs(HEX.WeaponTable) do
					if x == b.wep then
						ico = b.icon
					end
				end
				if v.wep == "none" then
					ico = "hexgm/ui/killicon.png"
				end
				return ico
			end

			if !IsValid(v.killer) then return end
			if !v.killer:IsPlayer() then v.killer = v.dead end

			draw.SimpleTextOutlined( v.killer:Name(), "HexFontSmall", ScrW() / 2 - 40, (k*36) + 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1, Color(0, 0, 0, 255 ))

				surface.SetDrawColor( 255, 255, 255, 255 ) 
				surface.SetMaterial( Material( MatchWeptoTable(twep) ) )
				surface.DrawTexturedRect( ScrW() / 2-16, (k*36) + 20, 32, 32 )


			if v.dead == v.killer then return end
			if !IsValid(v.dead) then return end
			draw.SimpleTextOutlined( v.dead:Name(), "HexFontSmall", ScrW() / 2 + 40, (k*36) + 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0, 0, 0, 255 ))
		end
	end

end

function DrawNotifInfo( self )

	local col = Color( 255, 255, 255, 255 )
	local posx = ScrW() / 2 - 300
	local posy = ScrH() - 150

	if !self.NotifTable then return end

	for k,v in pairs(self.NotifTable) do

		if v.alpha < 1 then 
			table.remove(self.NotifTable, k)
		else

			col = Color(v.color.r,v.color.g,v.color.b,math.Clamp(v.alpha,0,255))

			draw.SimpleTextOutlined( v.message, "HexFontSmall", posx+64, (k*-36) + posy, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0, 0, 0, v.alpha ))

			surface.SetDrawColor( Color(155,155,155,v.alpha) ) 
			surface.SetMaterial( Material( "hexgm/ui/notification_marker.png" ) )
			surface.DrawTexturedRect( posx + 8, (k*-36) + posy + 4, 48, 24 )

			v.alpha = v.alpha - 0.4
		end
	end

end

-- Death Info by Crashlemon, from Lment
function ReceiveDeathInfo(um)
	
	local ply = LocalPlayer()
	local dead = ents.GetByIndex(um:ReadShort())
	local killer = ents.GetByIndex(um:ReadShort())
	local weapon = um:ReadString()
	
	if !ply.KillTable then ply.KillTable = {} end
	local t = {}
	t.dead = dead
	t.killer = killer
	t.wep = weapon
	t.expire = CurTime() + 5
	
	table.insert( ply.KillTable, t )
	
end
usermessage.Hook("ply_death_info", ReceiveDeathInfo )

net.Receive( "ply_notification_info", function()
	local ply = LocalPlayer()
	local color = net.ReadColor()
	local alpha = net.ReadInt(10)
	local message = net.ReadString()

	if !ply.NotifTable then ply.NotifTable = {} end
	local t = {}
	t.color = color
	t.alpha = alpha
	t.message = message
	
	table.insert( ply.NotifTable, t )
end )

function DrawTargetInfo( self )
	local distance = 0
	local alpha1 = 0
	local alpha2 = 0

	local tr = util.TraceLine( {
		start = EyePos(),
		endpos = EyePos() + EyeAngles():Forward() * 1000
	} )

	if tr.Entity:IsPlayer() then
		local ts = tr.Entity:GetPos():ToScreen()
		local hp = math.Clamp(tr.Entity:Health(),0,100)

		-- Name
		draw.SimpleTextOutlined( tr.Entity:Name(), "HexFontSmall", ts.x, ts.y-24, team.GetColor(tr.Entity:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 115 ))
		draw.SimpleTextOutlined( tr.Entity:GetNWString("PlayerTitle"), "HexFontTiny", ts.x, ts.y-48, Color( 255, 255, 255, 115 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 115 ))

		-- Health Bar
		surface.SetDrawColor(Color(75,55,55,155))
		surface.DrawOutlinedRect(ts.x-56,ts.y-3,112,30,2)

		surface.SetDrawColor(Color(215,55,55,55))
		surface.DrawRect(ts.x-(hp/2)-6,ts.y-3,hp+12,30)
		surface.SetDrawColor(Color(255,55,55,35))
		surface.DrawRect(ts.x-(hp/2),ts.y+3,hp,17)

		draw.SimpleTextOutlined("Health: " .. tr.Entity:Health(),"HexFontTiny",ts.x,ts.y+10,Color(255,185,125,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
	end

	for x, y in pairs(ents.GetAll()) do
		if y.Crest == true then
			distance = y:GetPos():Distance(LocalPlayer():GetPos())
			--distance = 0
			if distance > 512 then
				alpha1 = 0
			else
				distance = -distance/2 - 1*1
				alpha1 = math.Clamp( distance+255,-155,155)
			end
			local tx = (y:GetPos() + Vector(0,0,80)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet22",tx.x,tx.y,Color(235,215,215,alpha1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))
			draw.SimpleTextOutlined(y.PrintName,"Trebuchet22",tx.x,tx.y-15,Color(y:GetColor().r,y:GetColor().g,y:GetColor().b,alpha1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))
			if y:GetNWBool("CrestActive") == false then
				draw.SimpleTextOutlined("-(SPENT)-","Trebuchet22",tx.x,tx.y-45,Color(255,0,0,alpha1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))
			end
		end
		if y:GetClass() == "ent_hex_pickupitem" or y:GetClass() == "ent_hex_pickupweapon" then
			distance = y:GetPos():Distance(LocalPlayer():GetPos())
			--distance = 0
			if distance > 512 then
				alpha1 = 0
			else
				distance = -distance/2 - 1*1
				alpha1 = math.Clamp( distance+200,-155,155)
			end
			local tx = (y:GetPos() + Vector(0,0,32)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet22",tx.x,tx.y,Color(235,215,215,alpha1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))
			draw.SimpleTextOutlined(y:GetNWString("ItemName"),"Trebuchet22",tx.x,tx.y-18,Color(y:GetColor().r,y:GetColor().g,y:GetColor().b,alpha1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))
		end
		if y:GetClass() == "ent_hex_powerup" then
			distance = y:GetPos():Distance(LocalPlayer():GetPos())
			--distance = 0
			if distance > 512 then
				alpha1 = 0
			else
				distance = -distance/2 - 1*1
				alpha1 = math.Clamp( distance+200,-155,155)
			end
			local tx = (y:GetPos() + Vector(0,0,32)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet22",tx.x,tx.y,Color(235,215,215,alpha1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))
			draw.SimpleTextOutlined(y:GetNWString("PowerupName"),"Trebuchet22",tx.x,tx.y-18,Color(y:GetColor().r,y:GetColor().g,y:GetColor().b,alpha1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))
		end
		if y:GetClass() == "ent_hex_a_obelisk" then
			if HEX.Gametype == "Mountain Man" then
				distance = y:GetPos():Distance(LocalPlayer():GetPos())

				if distance > 512 then
					alpha1 = 0
				else
					distance = -distance/2 - 1*1
					alpha1 = math.Clamp( distance+200,-155,155)
				end

				local tx = (y:GetPos() + Vector(0,0,32)):ToScreen()
				draw.SimpleTextOutlined("V","Trebuchet22",tx.x,tx.y-160,Color(235,215,215,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))
				draw.SimpleTextOutlined("Obelisk","Trebuchet22",tx.x,tx.y-180,Color(y:GetColor().r,y:GetColor().g,y:GetColor().b,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))

				if y:GetContested() == false then
					if y:GetMountainMan():IsPlayer() then
						draw.SimpleTextOutlined("Controlled by: " .. y:GetMountainMan():Name(),"Trebuchet22",tx.x,tx.y-48,Color(175,215,255,alpha1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))
					end
				else
					draw.SimpleTextOutlined("Contested","Trebuchet22",tx.x,tx.y-48,Color(255,115,115,alpha1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha1))
				end
			end
		end
	end

	if HEX.Teamplay == true && HEX.Round.RoundState == 1 then
		for k , v in pairs(player.GetAll()) do
			distance = v:GetPos():Distance(LocalPlayer():GetPos())
			if distance < 500 then
				alpha2 = math.Clamp( distance/4,25,155)
			else
				alpha2 = 155
			end
			local tp = (v:GetPos() + Vector(0,0,80)):ToScreen()
			if LocalPlayer():Team() == v:Team() && LocalPlayer() != v then
				draw.SimpleTextOutlined("V","Trebuchet22",tp.x,tp.y,Color(125,255,125,alpha2),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha2))
				draw.SimpleTextOutlined("Team","Trebuchet22",tp.x,tp.y-15,Color(125,255,125,alpha2),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha2))
			end
			if HEX.Gametype == "Elder" then
				if v:Team() == 2 then
					draw.SimpleTextOutlined("V","Trebuchet22",tp.x,tp.y,Color(255,125,125,alpha2),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha2))
					draw.SimpleTextOutlined("Elder","Trebuchet22",tp.x,tp.y-15,Color(255,125,125,alpha2),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha2))
				end
			end
		end
	end
end

function DrawAttackRangeIndicator()

    if !LocalPlayer():Alive() then return end
    if IsValid(LocalPlayer():GetActiveWeapon()) then
        local wep = LocalPlayer():GetActiveWeapon()

        if LocalPlayer():GetNWString("PreparingAttack") == false then return end

		local tr = util.TraceLine( {
			start = LocalPlayer():GetShootPos(),
			endpos = LocalPlayer():GetShootPos() + ( LocalPlayer():GetAimVector() * wep.Secondary.AttackRange ),
			filter = LocalPlayer()
		} )
		
        local trace = util.TraceLine(tr)
        local angle = trace.HitNormal:Angle()

        local ind = "hexgm/ui/spelltarget.png"
        local incolor = Color(55,115,255,155)
        local outcolor = Color(155,155,155,55)

        if LocalPlayer():GetNWInt("Mana") < wep.Secondary.ManaCost then
        	incolor = Color(255,115,115,155)
        	outcolor = Color(155,155,155,55)
        end

        if tr.Hit then
	        cam.Start3D2D( tr.HitPos+Vector(0,0,1), Angle(0,0,0), 1 )
	            surface.SetDrawColor( incolor )
	            surface.SetMaterial( Material(ind) )
	            surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*6) * 4 + 32, math.sin(RealTime()*6) * 4 + 32,(CurTime()*25) % 360)
	            surface.SetDrawColor( outcolor )
	            surface.SetMaterial( Material(ind) )
	            surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*-6) * 4 + 48, math.sin(RealTime()*-6) * 4 + 48,(CurTime()*-25) % 360)
	        cam.End3D2D()
	        cam.Start3D2D( tr.HitPos+Vector(0,0,-1), Angle(0,0,180), 1 )
	            surface.SetDrawColor( incolor )
	            surface.SetMaterial( Material(ind) )
	            surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*6) * 4 + 32, math.sin(RealTime()*6) * 4 + 32,(CurTime()*25) % 360)
	            surface.SetDrawColor( outcolor )
	            surface.SetMaterial( Material(ind) )
	            surface.DrawTexturedRectRotated(0,0,math.sin(RealTime()*-6) * 4 + 48, math.sin(RealTime()*-6) * 4 + 48,(CurTime()*-25) % 360)
	        cam.End3D2D()
	    end
    end

end
hook.Add( "PostDrawOpaqueRenderables", "DrawAttackRangeIndicatorHook", DrawAttackRangeIndicator )

function GM:HUDDrawTargetID()
end
function GM:HUDAmmoPickedUp()

end
function GM:HUDItemPickedUp()

end
function GM:HUDWeaponPickedUp()

end
local hide = { 
	CHudHealth = true, 
	CHudBattery = true, 
	CHudWeaponSelection = true, 
	CHudAmmo = true, 
	CHudSecondaryAmmo = true,
	CHudDamageIndicator = true
}
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )