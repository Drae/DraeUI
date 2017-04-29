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

T.UIParent = CreateFrame("Frame", "DraeUIParent", UIParent)
T.UIParent:SetFrameLevel(UIParent:GetFrameLevel())
T.UIParent:SetPoint("CENTER", UIParent, "CENTER")
T.UIParent:SetSize(UIParent:GetSize())

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

do
	local CreateHUDBg = function(frame, width, height, texture, sub, tex)
		local t = frame:CreateTexture(nil, "BACKGROUND", T.UIParent, sub)
		t:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\" .. texture)
		t:SetSize(width, height)

		if (type(tex) == "table") then
			t:SetTexCoord(tex[1], tex[2], tex[3], tex[4])
		end

		return t
	end

	T.OnEnable = function(self)
--		self:UIScale("PLAYER_LOGIN")

		self:UpdateBlizzardFonts()
		self:InitializeConsoleCommands()

--		self:RegisterEvent("UI_SCALE_CHANGED", "UIScale")

		-- Hide the guild hall command bar
		if (not IsAddOnLoaded("Blizzard_OrderHallUI")) then
			self:RegisterEvent("ADDON_LOADED", "HookAddons")
		else
			HideCommandBar()
		end
--[[
		local borderFrame = CreateFrame("frame", nil, T.UIParent)
		borderFrame:SetFrameStrata("BACKGROUND")
		borderFrame:SetAllPoints(T.UIParent)

--		CreateHUDBg(borderFrame, 512, 256, "windowcorner", 0):SetPoint("TOPLEFT", 0, 0)
--		CreateHUDBg(borderFrame, 512, 256, "windowcorner", 0, {1, 0, 0, 1}):SetPoint("TOPRIGHT", 0, 0)
--		CreateHUDBg(borderFrame, 512, 256, "windowcorner", 0, {1, 0, 1, 0}):SetPoint("BOTTOMRIGHT", 0, 0)
--		CreateHUDBg(borderFrame, 512, 256, "windowcorner", 0, {0, 1, 1, 0}):SetPoint("BOTTOMLEFT", 0, 0)
		local temp
		temp = CreateHUDBg(borderFrame, 512, 256, "windowborder", 0)
		temp:SetPoint("TOPLEFT", 512, 0)
		temp:SetPoint("TOPRIGHT", -512, 0)

		temp = CreateHUDBg(borderFrame, 512, 256, "windowborder", 0, {1, 0, 1, 0})
		temp:SetPoint("BOTTOMLEFT", 512, 0)
		temp:SetPoint("BOTTOMRIGHT", -512, 0)

		temp = CreateHUDBg(borderFrame, 256, 512, "windowborder-side", 0, {0, 1, 1, 0})
		temp:SetPoint("TOPRIGHT", 0, -256)
		temp:SetPoint("BOTTOMRIGHT", 0, 256)

		temp = CreateHUDBg(borderFrame, 512, 256, "windowborder-side", 0, {1, 0, 1, 0})
		temp:SetPoint("TOPLEFT", 0, -256)
		temp:SetPoint("BOTTOMLEFT", 0, 256)
]]
		local actionBarBg = CreateFrame("frame", nil, T.UIParent)
		actionBarBg:SetFrameStrata("BACKGROUND")
		actionBarBg:SetSize(1024, 256)
		actionBarBg:SetPoint("BOTTOM", 0, 14)

--		CreateHUDBg(actionBarBg, 512, 256, "leftshadow", 0):SetPoint("LEFT", 0, 0)
--		CreateHUDBg(actionBarBg, 512, 256, "rightshadow", 0):SetPoint("RIGHT", 0, 0)
	end
end

T.UpdateMedia = function(self)
	if (not self.db["general"]) then return end

	self["media"].font = LSM:Fetch("font", self.db["general"].font)
	self["media"].fontFancy = LSM:Fetch("font", self.db["general"].fontFancy)
	self["media"].fontTimers = LSM:Fetch("font", self.db["general"].fontTimers)
	self["media"].fontCombat = LSM:Fetch("font", self.db["general"].fontCombat)

	self["media"].statusbar = LSM:Fetch("statusbar", self.db["general"].statusbar)
end
