--[[


--]]
local addon, ns = ...

-- Saved Variables
local AddonDraeUI = LibStub("AceAddon-3.0"):NewAddon(addon, "AceEvent-3.0", "AceConsole-3.0")

AddonDraeUI.VC= {}
AddonDraeUI.VC["profile"] = {}
AddonDraeUI.VC["global"] = {}
AddonDraeUI.VC["class"] = {}
AddonDraeUI.VC["char"] = {}

-- Define common elements for our namespace T, C, G, P, U
ns[1] = AddonDraeUI
ns[2] = AddonDraeUI.VC["profile"]
ns[3] = AddonDraeUI.VC["global"]
ns[4] = AddonDraeUI.VC["class"]
ns[5] = AddonDraeUI.VC["char"]

ns.UnPack = function(self)
	return self[1], self[2], self[3], self[4], self[5]
end

-- Add this addon into the global space
_G.draeUI = ns

--[[

--]]
local  T, C, G, P, U, _ = select(2, ...):UnPack()

local LSM = LibStub("LibSharedMedia-3.0")

T.HiddenFrame = CreateFrame("Frame")
T.HiddenFrame:Hide()

--
T.TexCoords = {.08, .92, .08, .92}

--
T.media = {}

T.OnInitialize = function(self)
	--[[
		C == config/.db.profile -> data stored under "name-realm" tables and available to all chars on this account
		G == global/.db.global -> data stored under single table available to all chars on this account
		P == config/.db.class -->data stored under class name
		U == .dbChar.profile -> data stored under "name-realm" tables and accessible to only this char
	--]]
	local db = LibStub("AceDB-3.0"):New("draeUIDB", self.VC)			-- Default to our defaults (C. setup)
	self.dbObj = db

	self.db = db.profile
	self.dbClass = db.class[ns[1].playerClass]
	self.dbGlobal = db.global

	self.dbChar = LibStub("AceDB-3.0"):New("draeUICharDB")["profile"]	-- Pull the profile specifically

	self:UpdateMedia()
end


local HideCommandBar = function()
	OrderHallCommandBar:Hide()
	OrderHallCommandBar:UnregisterAllEvents()
	OrderHallCommandBar.Show = OrderHallCommandBar.Hide
end

T.HookAddons = function(self, event)
	if (IsAddOnLoaded("Blizzard_OrderHallUI") and OrderHallCommandBar ~= nil) then
		self:UnregisterEvent("ADDON_LOADED", "HookAddons")
		HideCommandBar()
	end
end

T.OnEnable = function(self)
	self:UpdateBlizzardFonts()
	self:InitializeConsoleCommands()

	-- Hide the guild hall command bar
	if (not IsAddOnLoaded("Blizzard_OrderHallUI")) then
		self:RegisterEvent("ADDON_LOADED", "HookAddons")
	else
		HideCommandBar()
	end
end

T.UpdateMedia = function(self)
	if (not self.db["general"]) then return end

	self["media"].font = LSM:Fetch("font", self.db["general"].font)
--	self["media"].fontFancy = LSM:Fetch("font", self.db["general"].fontFancy)

	self["media"].statusbar = LSM:Fetch("statusbar", self.db["general"].statusbar)
end
