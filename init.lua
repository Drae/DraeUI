--[[


--]]
local addon, DraeUI = ...

DraeUI[1] = {}
DraeUI[2] = {}
DraeUI[3] = {}
DraeUI[4] = {}
DraeUI[5] = {}

LibStub("AceAddon-3.0"):NewAddon(DraeUI[1], addon, "AceEvent-3.0", "AceConsole-3.0")

--[[

--]]
DraeUI.UnPack = function(self)
	return self[1], self[2], self[3], self[4], self[5]
end

--
DraeUI[1].defaults = {
	profile = {},
	global = {},
	class = {},
	char = {}
}

--[[

--]]
local  T, C, G, P, U, _ = select(2, ...):UnPack()

local LSM = LibStub("LibSharedMedia-3.0")

--
T.TexCoords = {.1, .9, .1, .9}

--
T.media = {}

T.HiddenFrame = CreateFrame("Frame")
T.HiddenFrame:Hide()

--[[

--]]
T.OnInitialize = function(self)
	--[[
		C == config/.db.profile -> data stored under "name-realm" tables and available to all chars on this account
		G == global/.db.global -> data stored under single table available to all chars on this account
		P == config/.db.class -->data stored under class name
		U == .dbChar.profile -> data stored under "name-realm" tables and accessible to only this char
	--]]
	local db = LibStub("AceDB-3.0"):New("draeUIDB", self.defaults)	-- Default to our defaults (C. setup)

	self.db = db.profile
	self.dbClass = db.class[self.playerClass]
	self.dbGlobal = db.global

	self.dbChar = LibStub("AceDB-3.0"):New("draeUICharDB")["profile"]	-- Pull the profile specifically

	self:UpdateMedia()
end

local HideCommandBar = function()
	OrderHallCommandBar:Hide()
	OrderHallCommandBar:UnregisterAllEvents()
	OrderHallCommandBar.Show = OrderHallCommandBar.Hide
end

T.ADDON_LOADED = function(self)
	if (IsAddOnLoaded("Blizzard_OrderHallUI") and OrderHallCommandBar ~= nil) then
		self:UnregisterEvent("ADDON_LOADED", "HookAddons")
		HideCommandBar()
	end

	-- Hide ArenaUI
	if (IsAddOnLoaded("Blizzard_ArenaUI") and T.db["frames"].showArena) then
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

T.OnEnable = function(self)
	self:UpdateBlizzardFonts()
	self:InitializeConsoleCommands()

	self:RegisterEvent("ADDON_LOADED", "ADDON_LOADED")
	T:ADDON_LOADED()
end

T.UpdateMedia = function(self)
	if (not self.db["general"]) then return end

	self["media"].font 		= LSM:Fetch("font", self.db["general"].font)
	self["media"].statusbar = LSM:Fetch("statusbar", self.db["general"].statusbar)
end
