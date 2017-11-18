function HEXGameVoteMenu()

        local timer = CurTime() + 20

        local nextthink = 1

        hexgvotemenu = vgui.Create("DFrame")
        hexgvotemenu:SetSize(512,512)
        hexgvotemenu:SetTitle("")
        hexgvotemenu:SetDraggable(false)
        hexgvotemenu:ShowCloseButton(true)
        hexgvotemenu:Center()
        hexgvotemenu:MakePopup()
        hexgvotemenu.Paint = function()
                draw.RoundedBox( 8, 0, 0, hexgvotemenu:GetWide(), hexgvotemenu:GetTall(), Color( 115, 95, 155, 155 ) )
        end
        hexgvotemenu.Think = function()
                if nextthink < CurTime() then
                        hexgvotemenu:SetTitle("Next Map Vote in... "..math.Round(timer-CurTime()))
                        --timer = timer - 0.1
                        nextthink = CurTime() + 1
                end
        end

        local function MatchGametypeToTable(m)
                for a, b in pairs(HEX.MapVote.GameList) do
                        if m == a then
                                return a
                        end
                end
        end

        local function GetVotes(m)
                for a, b in pairs(HEX.MapVote.GameList) do
                        if m == a then
                                return b.votes
                        end
                end
        end


        local marginx = 0
        local marginy = 0
        local row = 1
        for a, b in pairs(HEX.MapVote.GameList) do
                local c = vgui.Create("DButton",hexgvotemenu)
                c:SetPos(40+marginx,45+marginy)
                c:SetSize(76,32)
                c:SetText(b.game)
                c.DoClick = function()

                        net.Start( "addgamevote" )
                                net.WriteInt(MatchGametypeToTable(a),10)
                                net.WriteString(b.game)
                        net.SendToServer()

                        surface.PlaySound( "wc3sound/BigButtonClick.wav" )
                end
                local d = vgui.Create("DLabel",hexgvotemenu)
                d:SetPos(75+marginx,80+marginy)
                d:SetText("Votes: "..GetVotes(a))
                d:SizeToContents()
                d.Think = function()
                        d:SetText("Votes: "..GetVotes(a))
                        d:SizeToContents()
                end
                marginx = marginx + 150
                row = row + 1
                if row > 3 or row > 6 or row > 9 then
                        marginx = 0
                        marginy = marginy + 85
                        row = 0
                end
        end

end