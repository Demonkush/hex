net.Receive( "rtvsend", function()
        local mod = net.ReadInt(3)

        if mod == 1 then
                if HEX.MapVote.RTVActive == 0 then
                        HEX.MapVote.RTVTime = CurTime() + 30
                end
                HEX.MapVote.CurrentRTV = HEX.MapVote.CurrentRTV + 1
                HEX.MapVote.RTVActive = 1
        end
        
        if mod == 2 then
                HEX.MapVote.CurrentRTV = 0
                HEX.MapVote.RTVActive = 0
        end
end )

net.Receive( "mapvotesend", function()
        local maplist = net.ReadTable()
        HEX.MapVote.RTVActive = 0
        HEX.MapVote.MapList = maplist
        HEXMapVoteMenu()
end )

net.Receive( "gamevotesend", function()
        local gamelist = net.ReadTable()
        HEX.MapVote.RTVActive = 0
        HEX.MapVote.GameList = gamelist
        HEXGameVoteMenu()
end )

net.Receive( "updatemapvote", function()
        local maplist = net.ReadTable()
        HEX.MapVote.MapList = maplist
end )

net.Receive( "updategamevote", function()
        local gamelist = net.ReadTable()
        HEX.MapVote.GameList = gamelist
end )

function HEXMapVoteMenu()

        local timer = CurTime() + 30

        local nextthink = 1

        if IsValid(hexgvotemenu) then
                hexgvotemenu:Close()
        end
        
        local main = vgui.Create("DFrame")
        main:SetSize(ScrW(),ScrH())
        main:SetTitle("")
        main:SetDraggable(false)
        main:ShowCloseButton(true)
        main:Center()
        main:MakePopup()
        main.Paint = function()
                draw.RoundedBox( 1, 0, 0, main:GetWide(), main:GetTall(), Color( 0, 0, 0, 200 ) )
        end
        main.Think = function()
                if nextthink < CurTime() then
                        main:SetTitle("Map change in... "..math.Round(timer-CurTime()))
                        --timer = timer - 0.1
                        nextthink = CurTime() + 1
                end
        end

        local function MatchMapToTable(m)
                for a, b in pairs(HEX.MapVote.Maps) do
                        if m == b.map then
                                return b.name
                        end
                end
        end

        local function GetVotes(m)
                for a, b in pairs(HEX.MapVote.MapList) do
                        if m == a then
                                return b.votes
                        end
                end
        end

        local preview = vgui.Create("DImage",main)
        preview:SetPos(ScrW()/2-128,ScrH()-300)
        preview:SetSize(256,256)
        preview:SetImage("hexgm/maps/none.png")

        local xpos = ScrW() / 2 - 374 + 150
        local ypos = ScrH() / 2 - 128
        local margin = 0
        for a, b in pairs(HEX.MapVote.MapList) do
                local cd = vgui.Create("DPanel",main)
                cd:SetPos(xpos+margin,ypos)
                cd:SetSize(132,132)
                cd.Paint = function()
                        draw.RoundedBox( 4, 0, 0, cd:GetWide(), cd:GetTall(), Color( 175, 215, 125, 200 ) )
                end
                local c = vgui.Create("DImageButton",main)
                c:SetPos((xpos+2)+margin,ypos+2)
                c:SetSize(128,128)
                c:SetImage("hexgm/maps/"..b.map..".png")
                c.DoClick = function()
                        preview:SetImage("hexgm/maps/"..b.map..".png")

                        net.Start( "addmapvote" )
                        net.WriteInt( a, 3 )
                        net.WriteString(MatchMapToTable(b.map))
                        net.SendToServer()

                        surface.PlaySound( "wc3sound/BigButtonClick.wav" )
                end
                local n = vgui.Create("DLabel",main)
                n:SetPos((xpos+32)+margin,ypos+135)
                n:SetFont("Trebuchet24")
                n:SetText(MatchMapToTable(b.map))
                n:SizeToContents()
                local d = vgui.Create("DLabel",main)
                d:SetPos((xpos+42)+margin,ypos+180)
                d:SetText("Votes: "..GetVotes(a))
                d:SizeToContents()
                d.Think = function()
                        d:SetText("Votes: "..GetVotes(a))
                        d:SizeToContents()
                end
                margin = margin + 150
        end

end