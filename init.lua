--[[


--]]
local addon, DraeUI = ...

LibStub("AceAddon-3.0"):NewAddon(DraeUI, addon, "AceEvent-3.0")

local LSM = LibStub("LibSharedMedia-3.0")

--
local CreateFrame = CreateFrame
local UnitClass, UnitName, GetRealmName, UnitGUID, GetScreenHeight, GetScreenWidth, GetCVar = UnitClass, UnitName, GetRealmName, UnitGUID, GetScreenHeight, GetScreenWidth, GetCVar
local select, mfloor, tonumber, smatch = select, math.floor, tonumber, string.match
local OrderHallCommandBar, ArenaPrepFrames, ArenaEnemyFrames = OrderHallCommandBar, ArenaPrepFrames, ArenaEnemyFrames
local ReloadUI, DoReadyCheck = ReloadUI, DoReadyCheck

--
DraeUI.defaults = {
	profile = {},
	global = {},
	class = {},
	char = {}
}

--[[
		OnInitialize fires after ADDON_LOADED
		OnEnabled fires after PLAYER_LOGIN
--]]
DraeUI.OnInitialize = function(self)
	self.playerClass = select(2, UnitClass("player"))
	self.playerName = UnitName("player")
	self.playerRealm = GetRealmName()
	self.playerGuid = UnitGUID("player")

	--[[
		.db 		-> (profile) -> data stored under "name-realm" tables and available to all chars on this account
		.dbGlobal 	-> (global)	 ->	data stored under single table available to all chars on this account
		.dbClass 	-> (class)	 ->	data stored under class name
		.dbChar		-> (profile) ->	data stored under "name-realm" tables and accessible to only this char
	--]]
	local db = LibStub("AceDB-3.0"):New("draeUIDB", self.defaults)	-- Default to our defaults (C. setup)

	self.db = db.profile
	self.dbClass = db.class[self.playerClass]
	self.dbGlobal = db.global

	self.dbChar = LibStub("AceDB-3.0"):New("draeUICharDB")["profile"]	-- Pull the profile specifically

	self.media = {
		font = LSM:Fetch("font", self.db.general.font) or "Interface\\AddOns\\draeUI\\media\\fonts\\Proza",
		fontTitles = LSM:Fetch("font", self.db.general.fontTitles) or "Interface\\AddOns\\draeUI\\media\\fonts\\Proza",
		statusbar = LSM:Fetch("statusbar", self.db.general.statusbar) or "Interface\\AddOns\\draeUI\\media\\statusbars\\striped"
	}
end

DraeUI.OnEnable = function(self)
	self.screenHeight = mfloor(GetScreenHeight() * 100 + .5) / 100
	self.screenWidth = mfloor(GetScreenWidth() * 100 + .5) / 100
	self.uiScale = tonumber(GetCVar("uiScale"))

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateFonts")
	self:RegisterEvent("ADDON_LOADED", "ADDON_LOADED")

	self:ADDON_LOADED()
end

do
	local ChangeFont = function(obj, font, size, style, r, g, b, sr, sg, sb, sa, sox, soy)
		if (obj == nil) then return end

		local oldFont, oldSize, oldStyle = obj:GetFont()

		if (not size) then
			size = oldSize
		end

		if (not style) then
			style = (oldStyle == "OUTLINE") and "THINOUTLINE" or oldStyle -- keep outlines thin
		end

		obj:SetFont(font, size, style)

		if (sox and soy) then
			obj:SetShadowOffset(sox, soy)
			obj:SetShadowColor(sr or 0, sg or 0, sb or 0, sa or 1)
		end

		if (r and g and b) then
			obj:SetTextColor(r, g, b)
		end

		return obj
	end

	local UpdateChatFontSizes = function()
		CHAT_FONT_HEIGHTS = { 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 20 }
	end

	hooksecurefunc("FCF_ResetChatWindows", UpdateChatFontSizes)

	DraeUI.UpdateFonts = function(self)
		-- Change fonts
		local FontStandard = self.media.font
		local FontSmall = self.media.font
		local FontTitles = self.media.fontTitles

		local SizeSmall    = 10
		local SizeMedium   = 12
		local SizeLarge    = 16
		local SizeHuge     = 18
		local SizeInsane   = 26

		-- Game engine fonts
		STANDARD_TEXT_FONT = FontStandard
		NAMEPLATE_FONT = FontStandard

		UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 14

		-- Base fonts
		ChangeFont(SystemFont_Tiny                   	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(SystemFont_Small                  	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(SystemFont_Outline_Small          	, FontSmall   	, SizeSmall 	, "THINOUTLINE")
		ChangeFont(SystemFont_Shadow_Small           	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(SystemFont_InverseShadow_Small    	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(SystemFont_Med1                   	, FontStandard	, SizeMedium	, nil)
		ChangeFont(SystemFont_Shadow_Med1            	, FontStandard	, SizeMedium	, nil)
		ChangeFont(SystemFont_Med2                   	, FontStandard	, SizeMedium	, nil)
		ChangeFont(SystemFont_Med3                   	, FontStandard	, SizeMedium	, nil)
		ChangeFont(SystemFont_Shadow_Med3            	, FontStandard	, SizeMedium	, nil)
		ChangeFont(SystemFont_Large                  	, FontStandard	, SizeLarge 	, nil)
		ChangeFont(SystemFont_Shadow_Large           	, FontStandard	, SizeLarge 	, nil)
		ChangeFont(SystemFont_Shadow_Huge1           	, FontStandard	, SizeHuge  	, nil)
		ChangeFont(SystemFont_Shadow_Outline_Large   	, FontStandard	, SizeHuge  	, "THICKOUTLINE")
		ChangeFont(SystemFont_OutlineThick_Huge2     	, FontStandard	, SizeHuge  	, "THICKOUTLINE")
		ChangeFont(SystemFont_Shadow_Huge3           	, FontStandard	, SizeHuge  	, nil)
		ChangeFont(SystemFont_Shadow_Outline_Huge2   	, FontStandard	, SizeHuge  	, "THICKOUTLINE")
		ChangeFont(SystemFont_OutlineThick_Huge4     	, FontStandard	, SizeHuge  	, "THICKOUTLINE")
		ChangeFont(SystemFont_OutlineThick_WTF       	, FontStandard	, SizeInsane	, "THICKOUTLINE")

		ChangeFont(GameFontNormal						, FontStandard	, SizeMedium	, nil)
		ChangeFont(GameFontWhite						, FontStandard	, SizeMedium	, nil)
		ChangeFont(GameFontWhiteSmall					, FontSmall		, SizeSmall		, nil)
		ChangeFont(GameFontBlack						, FontStandard	, SizeMedium	, nil)
		ChangeFont(GameFontBlackSmall					, FontStandard	, SizeSmall		, nil)
		ChangeFont(GameFontNormalMed2					, FontStandard	, SizeMedium	, nil)
		ChangeFont(GameFontNormalLarge					, FontStandard	, SizeLarge		, nil)
		ChangeFont(GameFontNormalLargeOutline			, FontStandard	, SizeLarge		, "THINOUTLINE")
		ChangeFont(GameFontHighlightSmall				, FontStandard	, SizeSmall		, nil)
		ChangeFont(GameFontHighlight					, FontStandard	, SizeMedium	, nil)
		ChangeFont(GameFontHighlightLeft				, FontStandard	, SizeMedium	, nil)
		ChangeFont(GameFontHighlightRight				, FontStandard	, SizeMedium	, nil)
		ChangeFont(GameFontHighlightLarge2				, FontStandard	, SizeMedium	, nil)
		ChangeFont(GameFont_Gigantic					, FontStandard	, SizeHuge		, nil)
		ChangeFont(GameFontNormalSmall					, FontStandard	, SizeSmall		, nil)
		ChangeFont(GameFontNormalSmall2					, FontStandard	, SizeSmall		, nil)
		ChangeFont(GameTooltipHeader					, FontTitles	, SizeMedium	, nil)

		ChangeFont(NumberFont_Shadow_Small           	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(NumberFont_OutlineThick_Mono_Small	, FontStandard	, SizeMedium	, "OUTLINE")
		ChangeFont(NumberFont_Shadow_Med             	, FontStandard	, SizeMedium	, nil)
		ChangeFont(NumberFont_Outline_Med            	, FontStandard	, SizeMedium	, "THINOUTLINE")
		ChangeFont(NumberFont_Outline_Large          	, FontStandard	, SizeLarge 	, "THINOUTLINE")
		ChangeFont(NumberFont_Outline_Huge           	, FontStandard	, SizeHuge  	, "THINOUTLINE")

		ChangeFont(QuestFont_Large                   	, FontTitles   , SizeMedium		, nil)
		ChangeFont(QuestFont_Shadow_Huge             	, FontTitles   , SizeHuge  		, nil)

		ChangeFont(GameTooltipHeader                 	, FontStandard	, SizeMedium	, nil)
		ChangeFont(MailFont_Large                    	, FontTitles   , SizeMedium		, nil)
		ChangeFont(SpellFont_Small                   	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(InvoiceFont_Med                   	, FontStandard	, SizeMedium	, nil)
		ChangeFont(InvoiceFont_Small                 	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(Tooltip_Med                       	, FontStandard	, SizeMedium	, nil)
		ChangeFont(Tooltip_Small                     	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(AchievementFont_Small             	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(ReputationDetailFont              	, FontSmall   	, SizeSmall 	, nil)

		ChangeFont(FriendsFont_UserText              	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(FriendsFont_Normal                	, FontStandard	, SizeMedium	, nil)
		ChangeFont(FriendsFont_Small                 	, FontSmall   	, SizeSmall 	, nil)
		ChangeFont(FriendsFont_Large                 	, FontStandard	, SizeLarge 	, nil)

		UpdateChatFontSizes()
	end
end

DraeUI.ADDON_LOADED = function(self)
	if (IsAddOnLoaded("Blizzard_OrderHallUI") and OrderHallCommandBar ~= nil) then
		OrderHallCommandBar:Hide()
		OrderHallCommandBar:UnregisterAllEvents()
		OrderHallCommandBar.Show = OrderHallCommandBar.Hide
	end

	-- Hide ArenaUI
	if (IsAddOnLoaded("Blizzard_ArenaUI") and self.db.frames.showArena) then
		SetCVar('showArenaEnemyFrames', '0', 'SHOW_ARENA_ENEMY_FRAMES_TEXT')

		ArenaPrepFrames.Show = ArenaPrepFrames.Hide
		ArenaPrepFrames:UnregisterAllEvents()
		ArenaPrepFrames:Hide()

		ArenaEnemyFrames.Show = ArenaEnemyFrames.Hide
		ArenaEnemyFrames:UnregisterAllEvents()
		ArenaEnemyFrames:Hide()
	end
end

-- Console commands
do
	-- /rl - ReloadUI end
	local UIReload = function()
		ReloadUI()
	end

	-- /rar - ReadyCheck
	local ReadyCheck = function()
		DoReadyCheck()
	end

	-- /draeui grid X - Draw a grid, default or at X "pixels"
	local ConsoleGrid
	do
		local grid

		local AlignGridCreate = function(gridSize)
			if (not grid or (gridSize and grid.gridSize ~= gridSize)) then
				grid = nil

				grid = CreateFrame("Frame", nil, UIParent)
				grid:SetAllPoints(UIParent)
			end

			gridSize = gridSize or 128
			grid.gridSize = gridSize

			local size = 2
			local width = DraeUI.screenWidth
			local ratio = width / DraeUI.screenHeight
			local height = DraeUI.screenHeight * ratio

			local wStep = width / gridSize
			local hStep = height / gridSize

			for i = 0, gridSize do
				local tx = grid:CreateTexture(nil, "BACKGROUND")

				if (i == gridSize / 2 ) then
					tx:SetColorTexture(1, 0, 0, 0.5)
				else
					tx:SetColorTexture(0, 0, 0, 0.5)
				end

				tx:SetPoint("TOPLEFT", grid, "TOPLEFT", i * wStep - (size / 2), 0)
				tx:SetPoint("BOTTOMRIGHT", grid, "BOTTOMLEFT", i * wStep + (size / 2), 0)
			end

			height = DraeUI.screenHeight

			do
				local tx = grid:CreateTexture(nil, "BACKGROUND")
				tx:SetColorTexture(1, 0, 0, 0.5)
				tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height / 2) + (size / 2))
				tx:SetPoint("BOTTOMRIGHT", grid, "TOPRIGHT", 0, -(height / 2 + size / 2))
			end

			for i = 1, mfloor((height / 2) / hStep) do
				local tx = grid:CreateTexture(nil, "BACKGROUND")
				tx:SetColorTexture(0, 0, 0, 0.5)

				tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height / 2 + i * hStep) + (size / 2))
				tx:SetPoint("BOTTOMRIGHT", grid, "TOPRIGHT", 0, -(height / 2 + i * hStep + size / 2))

				tx = grid:CreateTexture(nil, "BACKGROUND")
				tx:SetColorTexture(0, 0, 0, 0.5)

				tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height / 2 - i * hStep) + (size / 2))
				tx:SetPoint("BOTTOMRIGHT", grid, "TOPRIGHT", 0, -(height / 2 - i * hStep + size / 2))
			end
		end

		local AlignGridShow = function(gridSize)
			if (not grid or (gridSize and grid.gridSize ~= gridSize)) then
				AlignGridCreate(gridSize)
			end

			grid:Show()
		end

		local AlignGridHide = function(gridSize)
			if (not grid) then return end

			grid:Hide()

			if (gridSize and grid.gridSize ~= gridSize) then
				AlignGridCreate(gridSize)
			end
		end

		local AlignGridToggle = function(gridSize)
			if (grid and grid:IsVisible()) then
				AlignGridHide(gridSize)
			else
				AlignGridShow(gridSize)
			end
		end

		ConsoleGrid = function(grid_size)
			if (grid_size and type(tonumber(grid_size)) == "number" and tonumber(grid_size) <= 256 and tonumber(grid_size) >= 4) then
				AlignGridToggle(grid_size)
			else
				AlignGridToggle()
			end
		end
	end

	-- /draeui hide - Hide the UI and show friendly names (photos!)
	local DraeHideUI = function()
		if (InCombatLockdown()) then return end

		if (UIParent:IsShown())then
			UIParent:Hide()
			SetCVar("UnitNameOwn", 1)
			SetCVar("UnitNameFriendlyPlayerName", 1)
		else
			UIParent:Show()
			SetCVar("UnitNameOwn", 0)
			SetCVar("UnitNameFriendlyPlayerName", 0)
		end
	end

	-- Setup the commands
	SLASH_DRAEUI_RELOADUI1 = "/rl"
	SlashCmdList["DRAEUI_RELOADUI"] = UIReload

	SLASH_DRAEUI_RAR1 = "/rar"
	SlashCmdList["DRAEUI_RAR"] = ReadyCheck

	SLASH_DRAEUI1 = "/draeui"
	SlashCmdList["DRAEUI"] = function(msg)
		if (msg) then
			msg = string.lower(msg)

			if (msg == "hide") then
				DraeHideUI()
			elseif (smatch(msg, "^grid ?[0-9]*")) then
				local grid_size = smatch(msg, "^grid ?([0-9]*)")
				ConsoleGrid(grid_size)
			end
		end
	end
end
