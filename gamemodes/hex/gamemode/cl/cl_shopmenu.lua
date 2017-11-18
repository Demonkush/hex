function HexShopMenu()
	local a = vgui.Create("DFrame")
	a:SetSize(500,500)
	a:SetPos( (ScrW()/2)-250, (ScrH()/2)-250 )
	a:SetTitle("Market")
	a:SetVisible( true )
	a:SetDraggable( false )
	a:ShowCloseButton( true )
	a:MakePopup()

	local cname = ""
	local cprice = ""
	local cdesc = ""
	local cicon = "hexgm/ui/icon_blank.png"
	local cselect = "weapon"
	local cwep = "none"
	local citem = "none"
	local ccolor = Color( 255, 235, 215, 255)

	local stlow = {}
	local stnorm = {}
	local sthigh = {}
	local stsuper = {}
	local stbuffs = {}

	local iability = "none"
	local iabilitydesc = "none"

	local function ResetWeaponVars()
		stlow = {}
		stnorm = {}
		sthigh = {}
		stsuper = {}
		stbuffs = {}
	end

	local dicon1 = "damage"
	local dcolor1 = Color(185,185,185,255)

	local dicon2 = "damage"
	local dcolor2 = Color(185,185,185,255)

	a.Paint = function()
		draw.RoundedBox( 8, 0, 0, a:GetWide(), a:GetTall(), Color( 135, 135, 135, 55 ) )
	end

	local MainPanel = vgui.Create("DPanel", a)
	MainPanel:SetPos(15,30)
	MainPanel:SetSize(250,450)
	MainPanel.Paint = function()
		draw.RoundedBox( 8, 0, 0, MainPanel:GetWide(), MainPanel:GetTall(), Color( 135, 135, 135, 55 ) )
	end

	local InfoPanel = vgui.Create("DPanel", a)
	InfoPanel:SetPos(285,30)
	InfoPanel:SetSize(200,400)
	InfoPanel.Paint = function()
		draw.RoundedBox( 8, 0, 0, InfoPanel:GetWide(), InfoPanel:GetTall(), Color( 135, 135, 135, 55 ) )
	
		draw.SimpleTextOutlined( cname, "HexFontLittle", 100, 15, ccolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(55,55,55,255))
		draw.SimpleTextOutlined( cprice, "HexFontLittle", 100, 115, Color( 255, 215, 155, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(55,55,55,255))


		if iability != "none" then
			draw.SimpleTextOutlined( iability, "HexFontLittle", 10, 160, Color(215,215,215,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
			if iabilitydesc != "none" then
				draw.SimpleTextOutlined( iabilitydesc, "Trebuchet18", 10, 185, Color(215,215,215,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(55,55,55,255))
			end
		end

		-- burning, chilled, poison, magic, nature, storm, water, light, dark, earth
		local margin = 0
		if stlow then
			if stlow.name then
				draw.SimpleTextOutlined( stlow.name, "Trebuchet18", 45, 160, Color(215,215,215,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material("hexgm/ui/type/"..stlow.element..".png") )
				surface.DrawTexturedRect( 10, 145, 32, 32 )
			end
			margin = margin + 25
		end
		if stnorm then
			if stnorm.name then
				draw.SimpleTextOutlined( stnorm.name, "Trebuchet18", 45, 160+margin, Color(215,215,215,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material("hexgm/ui/type/"..stnorm.element..".png") )
				surface.DrawTexturedRect( 10, 145+margin, 32, 32 )
			end
			margin = margin + 25
		end
		if sthigh then
			if sthigh.name then
				draw.SimpleTextOutlined( sthigh.name, "Trebuchet18", 45, 160+margin, Color(215,215,215,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material("hexgm/ui/type/"..sthigh.element..".png") )
				surface.DrawTexturedRect( 10, 145+margin, 32, 32 )
			end
			margin = margin + 25
		end
		if stsuper then
			if stsuper.name then
				draw.SimpleTextOutlined( stsuper.name, "Trebuchet18", 45, 160+margin, Color(215,215,215,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material("hexgm/ui/type/"..stsuper.element..".png") )
				surface.DrawTexturedRect( 10, 145+margin, 32, 32 )
			end
			margin = margin + 25
		end
		if stbuffs then
			for x, y in pairs(stbuffs) do
				if y != "none" then
					draw.SimpleTextOutlined( "Buffs", "Trebuchet18", 100, 320, Color(215,215,215,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))

					local margin = 60 * x
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material("hexgm/ui/type/"..y..".png") )
					surface.DrawTexturedRect( margin-55, 330, 64, 64 )
				end
			end
		end
	end

	local InfoPanelIcon = vgui.Create("DImageButton", InfoPanel)
	InfoPanelIcon:SetPos(64,32)
	InfoPanelIcon:SetSize(64,64)
	InfoPanelIcon:SetImage(cicon)
	InfoPanelIcon:Hide()

	local InfoPanelButton = vgui.Create("DButton", a)
	InfoPanelButton:SetPos(335,450)
	InfoPanelButton:SetSize(100,20)
	InfoPanelButton:SetFont("Trebuchet18")
	InfoPanelButton:SetText("Purchase")
	InfoPanelButton.DoClick = function()

		if cselect == "weapon" then
			if cwep != "none" then
				net.Start( "loadoutsend" )
					net.WriteString( cwep )
					net.WriteString( "weapon" )
				net.SendToServer()
			end
		end
		if cselect == "item" then
			if citem != "none" then
				net.Start( "loadoutsend" )
					net.WriteString( citem )
					net.WriteString( "item" )
				net.SendToServer()
			end
		end
	end

	local MainPanelListA = vgui.Create( "DScrollPanel", MainPanel )
	MainPanelListA:SetSize( 230, 380 )
	MainPanelListA:SetPos( 10, 65 )

	local MainPanelListB = vgui.Create( "DScrollPanel", MainPanel )
	MainPanelListB:SetSize( 230, 380 )
	MainPanelListB:SetPos( 10, 65 )
	MainPanelListB:Hide()

	local MainPanelLabel = vgui.Create( "DLabel", a )
	MainPanelLabel:SetPos(85,60)
	MainPanelLabel:SetText("Weapons")
	MainPanelLabel:SetFont("HexFontSmall")
	MainPanelLabel:SizeToContents()

	local MainPanelButtonA = vgui.Create("DButton", a)
	MainPanelButtonA:SetPos(35,35)
	MainPanelButtonA:SetSize(80,20)
	MainPanelButtonA:SetFont("Trebuchet18")
	MainPanelButtonA:SetText("Weapons")
	MainPanelButtonA:SetDisabled(true)

	local MainPanelButtonB = vgui.Create("DButton", a)
	MainPanelButtonB:SetPos(165,35)
	MainPanelButtonB:SetSize(80,20)
	MainPanelButtonB:SetFont("Trebuchet18")
	MainPanelButtonB:SetText("Items")

	MainPanelButtonA.DoClick = function()
		MainPanelLabel:SetPos(85,60)
		MainPanelLabel:SetText("Weapons")
		MainPanelListA:Show()
		MainPanelListB:Hide()
		MainPanelButtonA:SetDisabled(true)
		MainPanelButtonB:SetDisabled(false)
		surface.PlaySound( "wc3sound/exp/QuestActivateWhat1.wav" )
	end

	MainPanelButtonB.DoClick = function()
		MainPanelLabel:SetPos(105,60)
		MainPanelLabel:SetText("Items")
		MainPanelListA:Hide()
		MainPanelListB:Show()
		MainPanelButtonB:SetDisabled(true)
		MainPanelButtonA:SetDisabled(false)
		surface.PlaySound( "wc3sound/exp/QuestActivateWhat1.wav" )
	end

	local marginx = 0
	local marginy = 0
	local column = 0	
	for a, b in SortedPairsByMemberValue( HEX.WeaponTable, "price", false ) do
		local bab = vgui.Create( "DImageButton", MainPanelListA)
		bab:SetPos(10+marginx,5+marginy)
		bab:SetSize(64,64)
		bab:SetImage(b.icon)
		bab:SetTooltip(b.name)
		bab.DoClick = function()

		iability = "none"
		iabilitydesc = "none"

			InfoPanelIcon:Show()

			cname = b.name
			cprice = b.price.." Gold"
			InfoPanelIcon:SetImage(b.icon)

			InfoPanelIcon:SetTooltip(b.desc)

			local function GetWeaponStatTable(wep)
				for c, d in pairs(HEX.WeaponTable) do
					if wep == d.wep then
						stlow = d.stats.low
						stnorm = d.stats.norm
						sthigh = d.stats.high
						stsuper = d.stats.super
						stbuffs = d.stats.buffs
					end
				end
			end

			GetWeaponStatTable(b.wep)

			ccolor = Color( 255, 235, 215, 255)

			cwep = b.wep
			cselect = "weapon"

			surface.PlaySound( "wc3sound/BigButtonClick.wav" )
		end
		local prc = vgui.Create("DLabel",bab)
		prc:SetText(b.price.."g")
		prc:SetPos(0,0)
		prc:SizeToContents()
		column = column + 1
		if column > 2 then
			marginy = marginy + 70
			marginx = -70
			column = 0
		end
		marginx = marginx + 70	
	end

	local marginx2 = 0
	local marginy2 = 0
	local column2 = 0
	for c, d in SortedPairsByMemberValue( HEX.ItemTable, "price", false ) do
		local cab = vgui.Create( "DImageButton", MainPanelListB)
		cab:SetPos(10+marginx2,5+marginy2)
		cab:SetSize(64,64)
		cab:SetImage(d.icon)
		cab:SetTooltip(d.name)
		cab.DoClick = function()

			InfoPanelIcon:Show()

			cname = d.name
			cprice = d.price.." Gold"
			InfoPanelIcon:SetImage(d.icon)

			InfoPanelIcon:SetTooltip(d.desc)

			iability = d.itemability
			iabilitydesc = d.itemabilitydesc

			ResetWeaponVars()

			ccolor = Color( 215, 215, 255, 255)

			citem = d.id
			cselect = "item"

			surface.PlaySound( "wc3sound/BigButtonClick.wav" )
		end
		local prc = vgui.Create("DLabel",cab)
		prc:SetText(d.price.."g")
		prc:SetPos(0,0)
		prc:SizeToContents()
		column2 = column2 + 1
		if column2 > 2 then
			marginy2 = marginy2 + 70
			marginx2 = -70
			column2 = 0
		end
		marginx2 = marginx2 + 70	
	end

end
usermessage.Hook("SendHexShopMenu",HexShopMenu)