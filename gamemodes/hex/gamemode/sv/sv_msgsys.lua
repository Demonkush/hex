function HexMsg(ply,ttype,msg,col,broadcast)
	local msg = tostring(msg)
	local col = Vector(col.x,col.y,col.z)

	if broadcast == false then
		umsg.Start("SendHexMsg",ply)
		  	umsg.String(ttype)
		  	umsg.String(msg)
		  	umsg.Vector(Vector(col.x,col.y,col.z))
		umsg.End()
	elseif broadcast == true then
		for a, b in pairs(player.GetAll()) do
			umsg.Start("SendHexMsg",b)
			  	umsg.String(ttype)
			  	umsg.String(msg)
			  	umsg.Vector(Vector(col.x,col.y,col.z))
			umsg.End()
		end
	end
end

function HEX.SendNotification(ply,col,alpha,msg,global)
	if global == true then
		for k, v in pairs(player.GetAll()) do
			net.Start("ply_notification_info")
				net.WriteColor(col)
				net.WriteInt(alpha,10)
				net.WriteString(msg)
			net.Send(v)
		end
	else
		net.Start("ply_notification_info")
			net.WriteColor(col)
			net.WriteInt(alpha,10)
			net.WriteString(msg)
		net.Send(ply)
	end
end

function HexPlyMsg(ply,msg,col,teamnum)
	local msg = tostring(msg)
	local col = Vector(col.x,col.y,col.z)

	local namecol = team.GetColor(ply:Team())
	local col2 = Vector(namecol.r,namecol.g,namecol.b)

	if teamnum == false then
		for a, b in pairs(player.GetAll()) do
			umsg.Start("SendHexPlyMsg",b)
			  	umsg.String(ply:Name())
			  	umsg.Vector(Vector(col2.x,col2.y,col2.z))
			  	umsg.String(msg)
			  	umsg.Vector(Vector(col.x,col.y,col.z))
			umsg.End()
		end
 	end
 	if teamnum == true then
		for a, b in pairs(player.GetAll()) do
			if b:Team() == ply:Team() then
				umsg.Start("SendHexPlyMsg",b)
				  	umsg.String(ply:Name().." (Team)")
				  	umsg.Vector(Vector(col2.x,col2.y,col2.z))
				  	umsg.String(msg)
				  	umsg.Vector(Vector(col.x,col.y,col.z))
				umsg.End()
			end
		end
 	end
end

function HexSound(ply,sound,broadcast,chat)
	if chat == nil then chat = false end
	if broadcast == false then
		umsg.Start("SendHexSound",ply)
		  	umsg.String(sound)
		  	umsg.Bool(chat)
		umsg.End()
	elseif broadcast == true then
		for a, b in pairs(player.GetAll()) do
			umsg.Start("SendHexSound",b)
				umsg.String(sound)
			  	umsg.Bool(chat)
			umsg.End()
		end
	end
end

function HexSplash(ply)
	umsg.Start("SendHexSplash",ply) umsg.End()
end

function HexObjectiveText(ply)
	umsg.Start("SendHexObjText",ply)
	  	umsg.String(HEX.Objective)
	  	umsg.String(HEX.ObjectiveDesc)
	umsg.End()
end

function HexSettings(ply)
	umsg.Start("SendHexSettings",ply) umsg.End()
end

function HexLoadout(ply)
	umsg.Start("SendHexLoadout",ply) umsg.End()
end

function HexShopMenu(ply)
	umsg.Start("SendHexShopMenu",ply) umsg.End()
end

function HEX.FormatChat(player,text,teamonly)
	if text != "" then
		if HEX.Teamplay == true then
			if teamonly then
				HexPlyMsg(player,text,Vector(215,215,215),true)
			else
				HexPlyMsg(player,text,Vector(215,215,215),false)
			end
		else
			HexPlyMsg(player,text,Vector(215,215,215),false)
		end
		return ""
	end
end
hook.Add("PlayerSay","FormatChatHook",HEX.FormatChat)

function HEX.AddSoundtoChat(player,text,teamonly)
	if string.sub(text,0,1) != "/" then
		HexSound(player,"wc3sound/exp/InGameChatWhat1.wav",true,true)
	end
end
hook.Add("PlayerSay","AddSoundtoChatHook",HEX.AddSoundtoChat)