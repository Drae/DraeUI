--[[


--]]
local addon, DraeUI = ...

LibStub("AceAddon-3.0"):NewAddon(DraeUI, addon, "AceEvent-3.0", "AceConsole-3.0")

local LSM = LibStub("LibSharedMedia-3.0")

--
local CreateFrame = CreateFrame
local UnitClass, UnitName, GetRealmName, UnitGUID, GetScreenHeight, GetScreenWidth, GetCVar = UnitClass, UnitName, GetRealmName, UnitGUID, GetScreenHeight, GetScreenWidth, GetCVar
local select, mfloor, tonumber = select, math.floor, tonumber

--
DraeUI.defaults = {
	profile = {},
	global = {},
	class = {},
	char = {}
}

--[[

--]]
DraeUI.OnEnable = function(self)
	self.screenHeight = mfloor(GetScreenHeight()*100+.5)/100
	self.screenWidth = mfloor(GetScreenWidth()*100+.5)/100
	self.uiScale = tonumber(GetCVar("uiScale"))

	self:UpdateBlizzardFonts()
	self:InitializeConsoleCommands()

	self:RegisterEvent("ADDON_LOADED", "ADDON_LOADED")
	self:ADDON_LOADED()
end

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

	self:UpdateMedia()
end

DraeUI.UpdateMedia = function(self)
	self.media = {}

	if (not self.db.general) then return end

	self.media = {
		font = LSM:Fetch("font", self.db.general.font),
		statusbar = LSM:Fetch("statusbar", self.db.general.statusbar)
	}
end

DraeUI.UnPack = function(self)
	return self, self.db, self.dbClass, self.dbGlobal, self.dbChar
end

DraeUI.ADDON_LOADED = function(self)
	if (IsAddOnLoaded("Blizzard_OrderHallUI") and OrderHallCommandBar ~= nil) then
		OrderHallCommandBar:Hide()
		OrderHallCommandBar:UnregisterAllEvents()
		OrderHallCommandBar.Show = OrderHallCommandBar.Hide
	end

	-- Hide ArenaUI
	if (IsAddOnLoaded("Blizzard_ArenaUI") and self.db.frames.showArena) then
		Arena_LoadUI = function() end
		SetCVar('showArenaEnemyFrames', '0', 'SHOW_ARENA_ENEMY_FRAMES_TEXT')

		ArenaPrepFrames.Show = ArenaPrepFrames.Hide
		ArenaPrepFrames:UnregisterAllEvents()
		ArenaPrepFrames:Hide()

		ArenaEnemyFrames.Show = ArenaEnemyFrames.Hide
		ArenaEnemyFrames:UnregisterAllEvents()
		ArenaEnemyFrames:Hide()
	end
end
