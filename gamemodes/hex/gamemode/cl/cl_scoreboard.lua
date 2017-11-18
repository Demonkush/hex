function GM:HUDDrawScoreBoard()

end
function GM:ScoreboardShow()
    LocalPlayer().drawScoreboard = true
    return true
end

function GM:ScoreboardHide()
    LocalPlayer().drawScoreboard = false
    return true
end

function HEX_Scoreboard(self)
    local w = ScrW()
    local h = ScrH()

    local w1 = w / 2
    local h1 = h / 2

    local h2 = h1 - 256
    
    draw.SimpleTextOutlined( "HEX - "..HEX.Version, "Trebuchet18", w1, h2-48, Color( 235, 215, 255, 155 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 25, 0, 55, 55 ))
    draw.SimpleTextOutlined( GetHostName(), "Trebuchet24", w1, h2-32, Color( 235, 215, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 25, 0, 55, 255 ))

    local nw, nh = 512,40
    draw.RoundedBox(8, w1-(nw/2), h2, nw, nh, Color( 0, 0, 0, 200 ))

    draw.SimpleTextOutlined( HEX.Gametype, "Trebuchet24", w1, h2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ))
    draw.SimpleTextOutlined( HEX.Objective .. ": " ..HEX.ObjectiveDesc, "Trebuchet18", w1, h2+20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ))

    draw.SimpleTextOutlined( "Player                            -    Rank    -    Score    -    Ping", "Trebuchet24", w1, h2+63, Color( 255, 255, 255, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ))

    local margin = 75
    for k, v in pairs(player.GetAll()) do
        local color = Color(55,55,55,200)
        local nw, nh = 512,30

        if IsValid(v) then
            local team = v:Team()
            if HEX.TeamColors[team] then
                color = HEX.TeamColors[team]
            else
                color = Color(195,135,75,200)
            end
        end

        if !v:Alive() then
            color = Color(55,0,0,200)
        end

        draw.RoundedBox(8, w1-(nw/2), h2+margin, nw, nh, color)
        draw.SimpleTextOutlined( v:Name(), "Trebuchet18", w1-250, h2+margin+8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ))
        draw.SimpleTextOutlined( v:GetNWString("PlayerTitle"), "Trebuchet18", w1-220, h2+margin+22, Color( 25, 25, 25, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 0 ))
        
        draw.SimpleTextOutlined( "Lvl-"..v:GetNWString("RankLevel").." "..v:GetNWString("Rank"), "Trebuchet18", w1+30, h2+margin+15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ))
        
        if HEX.Gametype == "Greed" or HEX.Gametype == "Scavenger" then
            draw.SimpleTextOutlined( v:GetNWInt("Gold"), "Trebuchet18", w1+130, h2+margin+15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ))
        else
            draw.SimpleTextOutlined( v:GetNWInt("Score"), "Trebuchet18", w1+130, h2+margin+15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ))
        end
        draw.SimpleTextOutlined( v:Ping(), "Trebuchet18", w1+230, h2+margin+15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ))
        
        margin = margin + 35
    end

end
concommand.Add( "hex_scoreboard", HEX_Scoreboard )