include("shared.lua")
include("sh/sh_maintable.lua")
include("sh/sh_gametypetable.lua")
include("sh/sh_itemtable.lua")
include("sh/sh_weapontable.lua")
include("sh/sh_ranktable.lua")
include("cl/cl_fonts.lua")
include("cl/cl_hud.lua")
include("cl/cl_loadoutmenu.lua")
include("cl/cl_mapvote.lua")
include("cl/cl_gamevote.lua")
include("cl/cl_settingsmenu.lua")
include("cl/cl_scoreboard.lua")
include("cl/cl_shopmenu.lua")
include("cl/cl_thirdperson.lua")

CreateClientConVar( "hex_cl_togglepickuplight", "1", true, false )
CreateClientConVar( "hex_cl_toggledamagenumbers", "1", true, false )
CreateClientConVar( "hex_cl_togglechatsound", "1", true, false )
CreateClientConVar( "hex_cl_toggle2dparticles", "1", true, false )
CreateClientConVar( "hex_cl_togglecrosshairindicator", "1", true, false )
CreateClientConVar( "hex_cl_thirdpersonpositionx", "-25", true, false )
CreateClientConVar( "hex_cl_thirdpersonpositiony", "-15", true, false )

function HEX.SetTeamColors()
        HEX.TeamColors = {}
        HEX.TeamColors[1] = Color(215,75,75)
        HEX.TeamColors[2] = Color(75,155,195)      
        HEX.TeamColors[3] = Color(115,215,75)
        HEX.TeamColors[4] = Color(215,195,75)

        team.SetColor(1,HEX.TeamColors[1])
        team.SetColor(2,HEX.TeamColors[2])
        team.SetColor(3,HEX.TeamColors[3])
        team.SetColor(4,HEX.TeamColors[4])
end
HEX.SetTeamColors()
timer.Create("HEXUPDATETEAMCOLOR",32,0,function() HEX.SetTeamColors() end)

function GM:InitPostEntity() 
	local self = LocalPlayer()
	self.FloatingDmg		= {}
	self.RespawnTime = 0
        self.ItemCooldown = 0
        self.ObjectiveAlpha = 0
        self.drawScoreboard = false

        self.TitleTable = {}
end

net.Receive( "updateroundtimer", function()
        local time = net.ReadInt(12)
        HEX.Round.Timer = time
end )

net.Receive( "hexnetworkcrests", function()
        for k, v in pairs(ents.GetAll()) do
                if v.Crest == true then
                        v.prop_a1:Remove()
                        v.prop_a2:Remove()
                        v:Initialize()
                end
        end
end )

net.Receive( "hexdebugspawndisplay", function()
        local spawns = net.ReadTable()
        HEX.EntSpawnTable = spawns
end )

net.Receive( "updateitemcooldown", function()
        local cooldown = net.ReadInt(10)
        LocalPlayer().ItemCooldown = CurTime() + cooldown
end )

net.Receive( "updatetitletable", function()
        local titles = net.ReadTable()
        LocalPlayer().TitleTable = titles
end )

net.Receive( "hexroundstate", function()
        local state = net.ReadInt(3)
        HEX.Round.RoundState = state
end )

net.Receive( "updategamemodeinfo", function()
        local gametype = net.ReadString()
        local teamplay = net.ReadBool()
        local objective = net.ReadString()
        local objectivedesc = net.ReadString()

        HEX.Gametype = gametype
        HEX.Teamplay = teamplay
        HEX.Objective = objective
        HEX.ObjectiveDesc = objectivedesc

        LocalPlayer().ObjectiveAlpha = 1000
end )

function RecieveHexMsg(UM)
        local ttype,text,col
        ttype = UM:ReadString()
        text = UM:ReadString()
        col  = UM:ReadVector()

        local col2 = Color( col.x, col.y, col.z )

        chat.AddText(Color(215,155,115),"["..ttype.."] ",col2,text)
end
usermessage.Hook("SendHexMsg",RecieveHexMsg)

function RecieveHexPlyMsg(UM)
        local name,namecol,text,col
        name = UM:ReadString()
        namecol = UM:ReadVector()
        text = UM:ReadString()
        col  = UM:ReadVector()

        local namecol2 = Color( namecol.x, namecol.y, namecol.z )
        local col2 = Color( col.x, col.y, col.z )

        chat.AddText(namecol2,name..": ",col2,text)
end
usermessage.Hook("SendHexPlyMsg",RecieveHexPlyMsg)


function RecieveRespawnTime(UM)
        local time
        time = UM:ReadShort()

        LocalPlayer().RespawnTime = CurTime() + time
end
usermessage.Hook("SendHexRespawnTime",RecieveRespawnTime)

function HexSplash()
        local HexSplashScreen = vgui.Create("DImage")
        HexSplashScreen:SetSize(262,91)
        HexSplashScreen:SetPos(-4,ScrH()-87)
        HexSplashScreen:SetImage("hexgm/ui/hexlogo.png")
        timer.Simple(15,function()
                if IsValid(HexSplashScreen) then
                        HexSplashScreen:Remove()
                end
        end)
end
usermessage.Hook("SendHexSplash",HexSplash)

function HexSound(UM)
        local sound,chat
        sound = UM:ReadString()
        chat = UM:ReadBool()

        if chat == true then
                if GetConVar("hex_cl_togglechatsound"):GetInt() == 0 then return end
        end

        surface.PlaySound(sound)
end
usermessage.Hook("SendHexSound",HexSound)

function HexObjectiveText(UM)
        local title,desc
        title = UM:ReadString()
        desc = UM:ReadString()

        local a = vgui.Create("DLabel")
        a:SetPos(ScrW()/2,ScrH()-250)
        a:SetFont("HexFontMedium")
        a:SetTextColor(Color(215,185,115,215))
        a:SetText(title)
        a:SizeToContents()
        a:CenterHorizontal()

        local b = vgui.Create("DLabel")
        b:SetPos(ScrW()/2,ScrH()-205)
        b:SetFont("HexFontSmall")
        b:SetTextColor(Color(215,185,115,155))
        b:SetText(desc)
        b:SizeToContents()
        b:CenterHorizontal()

        timer.Simple(5,function()
                if IsValid(a) then
                        a:Remove()
                end
                if IsValid(b) then
                        b:Remove()
                end
        end)
end
usermessage.Hook("SendHexObjText",HexObjectiveText)