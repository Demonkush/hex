function HexLoadout()
	-- Mainframe Setup
	local a = vgui.Create("DFrame")
	a:SetSize(500,350)
	a:SetPos( (ScrW()/2)-250, (ScrH()/2)-160 )
	a:SetTitle("Character Settings")
	a:SetVisible( true )
	a:SetDraggable( false )
	a:ShowCloseButton( true )
	a:MakePopup()

	-- Data Retrieval functions
	local function MatchWeptoTable(t)
		local ico = "hexgm/ui/icon_blank.png" 
		local name = "No Weapon"
		local desc = ""
		for a, b in pairs(HEX.WeaponTable) do
			if LocalPlayer():GetNWString("MainWeapon") == b.wep then
				if t == "icon" then
					if b.icon != nil then
						ico = b.icon
					end
					return ico
				end
				if t == "name" then
					if b.name != nil then
						name = b.name
					end
					return name
				end
				if t == "desc" then
					if b.desc != nil then
						desc = b.desc
					end
					return desc
				end
			end
		end
	end

	local function MatchItemtoTable(t)
		local ico = "hexgm/ui/icon_blank.png" 
		local name = "No Item"
		local desc = ""
		for c, d in pairs(HEX.ItemTable) do
			if LocalPlayer():GetNWString("MainItem") == "none" then 
				if t == "icon" then return ico end
				if t == "name" then return name end
				if t == "desc" then return desc end
			end
			if LocalPlayer():GetNWString("MainItem") == d.id then
				if t == "icon" then
					if d.icon != nil then
						ico = d.icon
					end
					return ico
				end
				if t == "name" then
					if d.name != nil then
						name = d.name
					end
					return name
				end
				if t == "desc" then
					if d.desc != nil then
						desc = d.desc
					end
					return desc
				end
			end
		end
	end

	local ResistanceLabel = vgui.Create("DLabel",a)
	ResistanceLabel:SetPos(25,315)
	ResistanceLabel:SetFont("HexFontLittle")
	ResistanceLabel:SetText("Resistances")
	ResistanceLabel:SizeToContents()

	local marginx = 0
	local w1 = 135
	local h1 = 310
	local zResistanceDmg = vgui.Create("DImage",a)
	zResistanceDmg:SetPos(w1+marginx,h1)
	zResistanceDmg:SetSize(32,32)
	zResistanceDmg:SetImage("hexgm/ui/type/damage.png")
	local zResistanceDmgL = vgui.Create("DLabel",a)
	zResistanceDmgL:SetPos(w1+marginx+35,h1+5)
	zResistanceDmgL:SetFont("HexFontLittle")
	zResistanceDmgL:SetText(LocalPlayer():GetNWInt("DamageResist"))
	zResistanceDmgL:SizeToContents()
	marginx = marginx + 60

	local zResistanceMagic = vgui.Create("DImage",a)
	zResistanceMagic:SetPos(w1+marginx,h1)
	zResistanceMagic:SetSize(32,32)
	zResistanceMagic:SetImage("hexgm/ui/type/magic.png")
	local zResistanceMagicL = vgui.Create("DLabel",a)
	zResistanceMagicL:SetPos(w1+marginx+35,h1+5)
	zResistanceMagicL:SetFont("HexFontLittle")
	zResistanceMagicL:SetText(LocalPlayer():GetNWInt("MagicResist"))
	zResistanceMagicL:SizeToContents()
	marginx = marginx + 60

	local zResistanceFire = vgui.Create("DImage",a)
	zResistanceFire:SetPos(w1+marginx,h1)
	zResistanceFire:SetSize(32,32)
	zResistanceFire:SetImage("hexgm/ui/type/burning.png")
	local zResistanceFireL = vgui.Create("DLabel",a)
	zResistanceFireL:SetPos(w1+marginx+35,h1+5)
	zResistanceFireL:SetFont("HexFontLittle")
	zResistanceFireL:SetText(LocalPlayer():GetNWInt("FireResist"))
	zResistanceFireL:SizeToContents()
	marginx = marginx + 60

	local zResistanceIce = vgui.Create("DImage",a)
	zResistanceIce:SetPos(w1+marginx,h1)
	zResistanceIce:SetSize(32,32)
	zResistanceIce:SetImage("hexgm/ui/type/chilled.png")
	local zResistanceIceL = vgui.Create("DLabel",a)
	zResistanceIceL:SetPos(w1+marginx+35,h1+5)
	zResistanceIceL:SetFont("HexFontLittle")
	zResistanceIceL:SetText(LocalPlayer():GetNWInt("FrostResist"))
	zResistanceIceL:SizeToContents()
	marginx = marginx + 60

	local zResistanceStorm = vgui.Create("DImage",a)
	zResistanceStorm:SetPos(w1+marginx,h1)
	zResistanceStorm:SetSize(32,32)
	zResistanceStorm:SetImage("hexgm/ui/type/storm.png")
	local zResistanceStormL = vgui.Create("DLabel",a)
	zResistanceStormL:SetPos(w1+marginx+35,h1+5)
	zResistanceStormL:SetFont("HexFontLittle")
	zResistanceStormL:SetText(LocalPlayer():GetNWInt("StormResist"))
	zResistanceStormL:SizeToContents()
	marginx = marginx + 60

	local zResistanceVenom = vgui.Create("DImage",a)
	zResistanceVenom:SetPos(w1+marginx,h1)
	zResistanceVenom:SetSize(32,32)
	zResistanceVenom:SetImage("hexgm/ui/type/poison.png")
	local zResistanceVenomL = vgui.Create("DLabel",a)
	zResistanceVenomL:SetPos(w1+marginx+35,h1+5)
	zResistanceVenomL:SetFont("HexFontLittle")
	zResistanceVenomL:SetText(LocalPlayer():GetNWInt("PoisonResist"))
	zResistanceVenomL:SizeToContents()


	-- Content Setup
	local Pmodel = vgui.Create("DPanel",a)
	Pmodel:SetPos(25,35)
	Pmodel:SetSize(125,215)
	local PmodelModel = vgui.Create( "DModelPanel", Pmodel )
	PmodelModel:SetSize( 120, 210 )	
	PmodelModel:SetModel( LocalPlayer():GetModel() )
	function PmodelModel:LayoutEntity( Entity ) return end
	local eyepos = PmodelModel.Entity:GetBonePosition( PmodelModel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
	eyepos:Add( Vector( 0, 0, -5 ) )
	PmodelModel:SetLookAt( eyepos )
	PmodelModel:SetCamPos( eyepos-Vector( -25, 0, -5 ) )
	PmodelModel.Entity:SetEyeTarget( eyepos-Vector( -12, 0, 0 ) )
	local PmodelButton = vgui.Create("DButton",a)
	PmodelButton:SetPos(20,260)
	PmodelButton:SetSize(125,20)
	PmodelButton:SetText("Change Appearance")
	PmodelButton:SetTextColor(Color(255,255,255,255))
	local ATitleButton = vgui.Create("DButton",a)
	ATitleButton:SetPos(20,285)
	ATitleButton:SetSize(125,20)
	ATitleButton:SetText("Change Title")
	ATitleButton:SetTextColor(Color(255,255,255,255))


	local Uinfo = vgui.Create("DPanel",a)
	Uinfo:SetPos(170,35)
	Uinfo:SetSize(300,80)
	local UinfoUser = vgui.Create("DLabel",Uinfo)
	UinfoUser:SetPos(15,0)
	UinfoUser:SetFont("HexFontSmall")
	UinfoUser:SetText( LocalPlayer():Name() )
	UinfoUser:SizeToContents()
	local UinfoRank = vgui.Create("DLabel",Uinfo)
	UinfoRank:SetPos(15,30)
	UinfoRank:SetFont("HexFontLittle")
	UinfoRank:SetText( "Rank "..LocalPlayer():GetNWInt("RankLevel").." - "..LocalPlayer():GetNWString("Rank") )
	UinfoRank:SizeToContents()

	local UinfoExpBar = vgui.Create( "DProgress",Uinfo )
	UinfoExpBar:SetPos( 10, 60 )
	UinfoExpBar:SetSize( 280, 10 )
	UinfoExpBar:SetFraction( 1/(LocalPlayer():GetNWInt("ExperienceMax")/LocalPlayer():GetNWInt("Experience")) )
	local UinfoExp = vgui.Create("DLabel",Uinfo)
	UinfoExp:SetPos(125,58)
	UinfoExp:SetText( LocalPlayer():GetNWInt("Experience").."/"..LocalPlayer():GetNWInt("ExperienceMax") )
	UinfoExp:SetTextColor(Color(0,0,0,255))
	UinfoExp:SizeToContents()


	local WeaponIconLabel = vgui.Create("DLabel",a)
	WeaponIconLabel:SetPos(255,155)
	WeaponIconLabel:SetText(MatchWeptoTable("name"))
	WeaponIconLabel:SetFont("HexFontLittle")
	WeaponIconLabel:SizeToContents()
	local WeaponIconButton = vgui.Create("DImageButton",a)
	WeaponIconButton:SetPos(175,135)
	WeaponIconButton:SetImage(MatchWeptoTable("icon"))
	WeaponIconButton:SizeToContents()

	local ItemIconLabel = vgui.Create("DLabel",a)
	ItemIconLabel:SetPos(255,235)
	ItemIconLabel:SetText(MatchItemtoTable("name"))
	ItemIconLabel:SetFont("HexFontLittle")
	ItemIconLabel:SizeToContents()
	local ItemIconButton = vgui.Create("DImageButton",a)
	ItemIconButton:SetPos(175,215)
	ItemIconButton:SetImage(MatchItemtoTable("icon"))
	ItemIconButton:SizeToContents()

	local WepIconTooltip = vgui.Create("DPanel",a)
	WepIconTooltip:SetSize(330,85)
	WepIconTooltip:SetPos(160,210)
	local ItemIconTooltip = vgui.Create("DPanel",a)
	ItemIconTooltip:SetSize(330,85)
	ItemIconTooltip:SetPos(160,120)

	local models = {}
	models[1] = {name="Legion Cultist [War40k]",model="models/whdow2/cultist_plr.mdl"}
	models[2] =	{name="Skeleton King [Dota2]",model="models/player/theonlykingthatmatters.mdl"}
	models[3] =	{name="Skeleton",model="models/player/skeleton.mdl"}
	models[4] =	{name="Auron [Final Fantasy]",model="models/player/ffx/auron.mdl"}
	models[5] =	{name="Zeus [God of War]",model="models/player/gow3_zeus.mdl"}
	models[6] = {name="High Elf Sylvanas [Warcraft]",model="models/player/hots/sylvana_highelf.mdl"}
	models[7] = {name="Undead Sylvanas [Warcraft]",model="models/player/hots/sylvana_base.mdl"}

	marginx = 0
	marginy = 0
	column = 0

	local TitlePanel = vgui.Create("DPanel",a)
	TitlePanel:SetPos(160,35)
	TitlePanel:SetSize(330,275)
	TitlePanel:Hide()
	local TitlePanelList = vgui.Create("DScrollPanel",TitlePanel)
	TitlePanelList:SetPos(5,45)
	TitlePanelList:SetSize(325,200)
	local TitlePanelTitle = vgui.Create("DLabel",TitlePanel)
	TitlePanelTitle:SetPos(30,5)
	TitlePanelTitle:SetText("Select a Title")
	TitlePanelTitle:SetFont("HexFontSmall")
	TitlePanelTitle:SizeToContents()

	local function MatchTitleToTable(t)
		for z, x in pairs(HEX.Titles) do
			if t == x.id then
				return x.title
			end
		end
	end

	local margin = 0
	for c, d in pairs(LocalPlayer().TitleTable) do
		local TitleButton = vgui.Create("DButton",TitlePanelList)
		TitleButton:SetPos(5,5+margin)
		TitleButton:SetText(MatchTitleToTable(d))
		TitleButton:SetSize(300,25)
		TitleButton.DoClick = function()
			net.Start("playertitlesend")
				net.WriteInt(d,10)
			net.SendToServer()
		end
		margin = margin + 30
	end

	local PmodelPanel = vgui.Create("DPanel",a)
	PmodelPanel:SetPos(160,35)
	PmodelPanel:SetSize(330,275)
	PmodelPanel:Hide()
	local PmodelPanelList = vgui.Create("DScrollPanel",PmodelPanel)
	PmodelPanelList:SetPos(5,45)
	PmodelPanelList:SetSize(325,200)
	local PmodelPanelTitle = vgui.Create("DLabel",PmodelPanel)
	PmodelPanelTitle:SetPos(30,5)
	PmodelPanelTitle:SetText("Select a Player Model")
	PmodelPanelTitle:SetFont("HexFontSmall")
	PmodelPanelTitle:SizeToContents()
	for a, b in pairs(models) do
		if util.IsValidModel(b.model) then
			local POutline = vgui.Create("DPanel", PmodelPanelList )
			POutline:SetPos( 10+marginx, 10+marginy )
			POutline:SetSize( 80, 80 )
			POutline.Paint = function()
				draw.RoundedBox( 8, 0, 0, POutline:GetWide(), POutline:GetTall(), Color( 175, 175, 175, 100 ) )
			end

			local PmodelSelect = vgui.Create( "DModelPanel", PmodelPanelList )
			PmodelSelect:SetPos( 10+marginx, 10+marginy )
			PmodelSelect:SetSize( 80, 80 )	
			PmodelSelect:SetModel( b.model )
			PmodelSelect:SetTooltip( b.name )
			PmodelSelect.DoClick = function()
				net.Start( "playermodelsend" )
					net.WriteString( b.name )
					net.WriteString( b.model )
				net.SendToServer()
				PmodelPanel:Hide()
			end


			function PmodelSelect:LayoutEntity( Entity ) return end
			local eyepos = PmodelSelect.Entity:GetBonePosition( PmodelSelect.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
			eyepos:Add( Vector( 0, 0, -5 ) )
			PmodelSelect:SetLookAt( eyepos )
			PmodelSelect:SetCamPos( eyepos-Vector( -25, 0, -5 ) )
			PmodelSelect.Entity:SetEyeTarget( eyepos-Vector( -12, 0, 0 ) )

			marginx = marginx + 110
			column = column + 1
			if column > 2 then
				marginx = 0
				marginy = marginy + 100
				column = 0
			end
		end
	end

	a.Think = function()
		zResistanceDmgL:SetText(LocalPlayer():GetNWInt("DamageResist"))
		zResistanceDmgL:SizeToContents()
		zResistanceMagicL:SetText(LocalPlayer():GetNWInt("MagicResist"))
		zResistanceMagicL:SizeToContents()
		zResistanceFireL:SetText(LocalPlayer():GetNWInt("FireResist"))
		zResistanceFireL:SizeToContents()
		zResistanceIceL:SetText(LocalPlayer():GetNWInt("FrostResist"))
		zResistanceIceL:SizeToContents()
		zResistanceStormL:SetText(LocalPlayer():GetNWInt("StormResist"))
		zResistanceStormL:SizeToContents()
		zResistanceVenomL:SetText(LocalPlayer():GetNWInt("PoisonResist"))
		zResistanceVenomL:SizeToContents()
	end

	-- Paint Functions
	a.Paint = function()
		draw.RoundedBox( 8, 0, 0, a:GetWide(), a:GetTall(), Color( 155, 145, 135, 100 ) )
	end

	Pmodel.Paint = function()
		draw.RoundedBox( 8, 0, 0, Pmodel:GetWide(), Pmodel:GetTall(), Color( 135, 155, 135, 100 ) )
	end

	PmodelButton.Paint = function()
		draw.RoundedBox( 8, 0, 0, PmodelButton:GetWide(), PmodelButton:GetTall(), Color( 175, 175, 175, 100 ) )
	end

	ATitleButton.Paint = function()
		draw.RoundedBox( 8, 0, 0, ATitleButton:GetWide(), ATitleButton:GetTall(), Color( 175, 175, 175, 100 ) )
	end

	Uinfo.Paint = function()
		draw.RoundedBox( 8, 0, 0, Uinfo:GetWide(), Uinfo:GetTall(), Color( 135, 135, 155, 100 ) )
	end

	UinfoExpBar.Paint = function()
		draw.RoundedBox( 4, 0, 0, UinfoExpBar:GetWide(), UinfoExpBar:GetTall(), Color( 155, 155, 155, 255 ) )
		draw.RoundedBox( 4, 0, 0, UinfoExpBar:GetFraction()*UinfoExpBar:GetWide(), UinfoExpBar:GetTall(), Color( 255, 135, 155, 255 ) )
	end

	PmodelPanel.Paint = function()
		draw.RoundedBox( 8, 0, 0, PmodelPanel:GetWide(), PmodelPanel:GetTall(), Color( 135, 135, 135, 255 ) )
	end

	TitlePanel.Paint = function()
		draw.RoundedBox( 8, 0, 0, TitlePanel:GetWide(), TitlePanel:GetTall(), Color( 135, 135, 135, 255 ) )
	end

	WepIconTooltip.Paint = function()
		draw.RoundedBox( 8, 0, 0, WepIconTooltip:GetWide(), WepIconTooltip:GetTall(), Color( 85, 85, 85, 255 ) )
		draw.SimpleTextOutlined( MatchWeptoTable("name"), "HexFontSmall", 10, 20, Color( 255, 215, 155, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(55,55,55,255))
		draw.SimpleTextOutlined( string.sub(MatchWeptoTable("desc"),0,45), "HexFontTiny", 15, 45, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(55,55,55,255))
		draw.SimpleTextOutlined( string.sub(MatchWeptoTable("desc"),45,90), "HexFontTiny", 15, 65, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(55,55,55,255))
	end
	ItemIconTooltip.Paint = function()
		draw.RoundedBox( 8, 0, 0, ItemIconTooltip:GetWide(), ItemIconTooltip:GetTall(), Color( 85, 85, 85, 255 ) )
		draw.SimpleTextOutlined( MatchItemtoTable("name"), "HexFontSmall", 10, 20, Color( 255, 215, 155, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(55,55,55,255))
		draw.SimpleTextOutlined( string.sub(MatchItemtoTable("desc"),0,45), "HexFontTiny", 15, 45, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(55,55,55,255))
		draw.SimpleTextOutlined( string.sub(MatchItemtoTable("desc"),45,90), "HexFontTiny", 15, 65, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(55,55,55,255))
	end

	-- Button Functions
	WeaponIconButton.Think = function()
		if WeaponIconButton:IsHovered() == true then
			WepIconTooltip:Show()
		else
			WepIconTooltip:Hide()
		end
	end
	ItemIconButton.Think = function()
		if ItemIconButton:IsHovered() == true then
			ItemIconTooltip:Show()
		else
			ItemIconTooltip:Hide()
		end
	end

	PmodelModel.DoClick = function()
		if PmodelPanel:IsVisible() then
			PmodelPanel:Hide()
		else
			TitlePanel:Hide()
			PmodelPanel:Show()
		end
	end

	PmodelButton.DoClick = function()
		if PmodelPanel:IsVisible() then
			PmodelPanel:Hide()
		else
			TitlePanel:Hide()
			PmodelPanel:Show()
		end
	end

	ATitleButton.DoClick = function()
		if TitlePanel:IsVisible() then
			TitlePanel:Hide()
		else
			PmodelPanel:Hide()
			TitlePanel:Show()
		end
	end


end
usermessage.Hook("SendHexLoadout",HexLoadout)