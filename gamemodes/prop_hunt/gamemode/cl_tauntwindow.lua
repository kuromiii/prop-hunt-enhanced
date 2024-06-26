local isplayed = false
local isopened = false
local hastaunt = false

local function MainFrame()
	if GetConVar("ph_enable_custom_taunts"):GetInt() < 1 then
		chat.AddText(Color(220,0,0),"[PH:E - Taunts] Warning: This server has custom taunts disabled.")
		return
	end

	isopened = true

	local frame = vgui.Create("DFrame")
	frame:SetSize(400,600)
	frame:SetTitle("Prop Hunt | Taunt Menu")
	frame:Center()
	frame:SetVisible(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)
	frame:SetKeyboardInputEnabled(true)

	frame.Paint = function(self,w,h)
		surface.SetDrawColor(Color(40,40,40,180))
		surface.DrawRect(0,0,w,h)
	end

	frame.OnClose = function()
		isopened = false
		hastaunt = false
	end

	local function frame_Think_Force()
		if isopened == true then
			isopened = false
			hastaunt = false
			frame:Close()
		end
	end
	hook.Add("Think", "CloseWindowFrame_Force", frame_Think_Force)

	local list = vgui.Create("DListView", frame)
	list:SetMultiSelect(false)
	list:AddColumn("soundlist") -- because header is gone.
	list.m_bHideHeaders = true
	list:SetPos(10,52)
	list:SetSize(0,420)
	list:Dock(BOTTOM)

	local team = LocalPlayer():Team()
	local TEAM_TAUNTS = PHE:GetTeamTaunt(team, false)
	local WHOLE_TEAM_TAUNTS = PHE:GetAllTeamTaunt(team)

	for name,_ in pairs(TEAM_TAUNTS) do
		list:AddLine(name)
	end

	local comb = vgui.Create("DComboBox", frame)
	comb:Dock(TOP)
	comb:SetSize(0, 20)
	comb:SetValue("Original Taunts")
	comb:AddChoice("Original Taunts")
	comb:AddChoice("PH:E/Custom Taunts")

	function comb:SortAndStyle(pnl)
		pnl:SortByColumn(1,false)

		pnl.Paint = function(self,w,h)
			surface.SetDrawColor(Color(50,50,50,180))
			surface.DrawRect(0,0,w,h)
		end

		local color = {
			hover 	= Color(80,80,80,200),
			select 	= Color(120,120,120,255),
			alt		= Color(60,60,60,180),
			normal 	= Color(50,50,50,180)
		}

		for _,line in pairs(pnl:GetLines()) do
			function line:Paint(w, h)
				if (self:IsHovered()) then
					surface.SetDrawColor(color.hover)
				elseif (self:IsSelected()) then
					surface.SetDrawColor(color.select)
				elseif (self:GetAltLine()) then
					surface.SetDrawColor(color.alt)
				else
					surface.SetDrawColor(color.normal)
				end
				surface.DrawRect(0,0,w,h)
			end
			for _,col in pairs(line["Columns"]) do
				col:SetFont("PHE.TauntFont")
				col:SetTextColor(color_white)
			end
		end
	end

	comb.OnSelect = function(pnl, idx, val)
		if val == "Original Taunts" then
			list:Clear()
			hastaunt = false
			if TEAM_TAUNTS then
				for name,val in pairs(TEAM_TAUNTS) do
					list:AddLine(name)
				end
			end
			pnl:SortAndStyle(list)
		elseif val == "PH:E/Custom Taunts" then
			list:Clear()
			hastaunt = false
			for name,val in pairs(PHE:GetTeamTaunt(team, true)) do
				list:AddLine(name)
			end
			pnl:SortAndStyle(list)
		end
	end

	comb:SortAndStyle(list)

	-- I know, this one is fixed style.
	local btnpanel = vgui.Create("DPanel", frame)
	btnpanel:Dock(FILL)
	btnpanel:SetBackgroundColor(Color(20,20,20,200))

	local slider_panel = vgui.Create("DPanel", frame)
	slider_panel:Dock(BOTTOM)
	slider_panel:SetBackgroundColor(Color(20,20,20,200))

	local function CreateStyledButton(dock, size, ttip, margin, texture, imagedock, btnfunction)
		local left, top, right, bottom = margin[1], margin[2], margin[3], margin[4]

		local button = vgui.Create("DButton", btnpanel)
		button:Dock(dock)
		button:SetSize(size, 0)
		button:DockMargin(left, top, right, bottom)
		button:SetText("")
		button:SetTooltip(ttip)

		button.Paint = function(self, w, h)
			if self:IsHovered() then
				surface.SetDrawColor(Color(90, 90, 90, 200))
			else
				surface.SetDrawColor(Color(0, 0, 0, 0))
			end
			surface.DrawRect(0, 0, w, h)
		end

		button.DoClick = btnfunction

		local image = vgui.Create("DImage", button)
		image:SetImage(texture)
		image:Dock(imagedock)
	end

	local function TranslateTaunt(linename)
		return WHOLE_TEAM_TAUNTS[linename]
	end

	local pitch_slider = vgui.Create("DNumSlider", slider_panel)
	pitch_slider:Dock(LEFT)
	pitch_slider:SetSize(300, 100)
	pitch_slider:SetText("Pitch")
	pitch_slider:SetMin(75)
	pitch_slider:SetMax(135)
	pitch_slider:SetDecimals(0)
	pitch_slider:SetValue(100)

	local function SendToServer(snd)
		if !isplayed then
			net.Start("CL2SV_PlayThisTaunt")
				net.WriteString(tostring(snd))
				net.WriteUInt(100, 9)
				net.WriteUInt(pitch_slider:GetValue(), 8)
			net.SendToServer()
			isplayed = true
			timer.Simple(GetConVar("ph_customtaunts_delay"):GetInt(), function() isplayed = false end)
		else
			chat.AddText(Color(220,40,0),"[PH:E - Taunts] Warning: ",Color(220,220,220),"Please wait in " .. GetConVar("ph_customtaunts_delay"):GetInt() .. " seconds...!")
		end
	end

	CreateStyledButton(LEFT,86,"Play Taunt Locally",{5,5,5,5},"vgui/phehud/btn_play.vmt",FILL, function()
		if hastaunt then
			local getline = TranslateTaunt(list:GetLine(list:GetSelectedLine()):GetValue(1))
			surface.PlaySound(getline)
		end
	end)

	CreateStyledButton(LEFT,86,"Play Taunt Globally",{5,5,5,5}, "vgui/phehud/btn_playpub.vmt",FILL, function()
		if hastaunt then
			local getline = TranslateTaunt(list:GetLine(list:GetSelectedLine()):GetValue(1))
			SendToServer(getline)
		end
	end)

	CreateStyledButton(LEFT,86,"Play Taunt Globally and Close",{5,5,5,5},"vgui/phehud/btn_playx.vmt",FILL, function()
		if hastaunt then
			local getline = TranslateTaunt(list:GetLine(list:GetSelectedLine()):GetValue(1))

			SendToServer(getline)
			frame:Close()
		end
	end)

	CreateStyledButton(FILL,86,"Close the Window",{5,5,5,5},"vgui/phehud/btn_close.vmt",FILL, function()
		frame:Close()
	end)

	list.OnRowRightClick = function(panel,line)
		hastaunt = true
		local getline = TranslateTaunt(list:GetLine(list:GetSelectedLine()):GetValue(1))

		local menu = DermaMenu()
		menu:AddOption("Play (Local)", function() surface.PlaySound(getline) print("Playing: " .. getline) end):SetIcon("icon16/control_play.png")
		menu:AddOption("Play (Global)", function() SendToServer(getline) end):SetIcon("icon16/sound.png")
		menu:AddOption("Play and Close (Global)", function() SendToServer(getline) frame:Close() end):SetIcon("icon16/sound_delete.png")
		menu:AddSpacer()
		menu:AddOption("Close Menu", function() frame:Close() end):SetIcon("icon16/cross.png")
		menu:Open()
	end

	list.OnRowSelected = function()
		hastaunt = true
	end

	list.DoDoubleClick = function(id,line)
		hastaunt = true
		local getline = TranslateTaunt(list:GetLine(list:GetSelectedLine()):GetValue(1))
		SendToServer(getline)

		if GetConVar("ph_cl_autoclose_taunt"):GetBool() then 
			frame:Close()
		end
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)
end

concommand.Add("ph_showtaunts", function()
	if LocalPlayer():Alive() && LocalPlayer():GetObserverMode() == OBS_MODE_NONE then
		if isopened != true then
			MainFrame()
		end
	else
		chat.AddText(Color(220,40,0),"[PH:E Taunts] Notice: ",Color(220,220,220), "You can only play custom taunts when you\'re alive as prop/hunter!")
	end
end, nil, "Show Prop Hunt taunt list, so you can select and play for self or play as a taunt.")

local function BindPress(ply, bind, pressed)
	if string.find(bind, "+menu_context") && pressed then
		RunConsoleCommand("ph_showtaunts")
	end
end
hook.Add("PlayerBindPress", "PlayerBindPress_menuContext", BindPress)
