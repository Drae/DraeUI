--[[


--]]
local addon, ns = ...

-- Saved Variables
local AddonDraeUI = LibStub("AceAddon-3.0"):NewAddon(addon, "AceConsole-3.0")

AddonDraeUI.VC= {}
AddonDraeUI.VC["profile"] = {}
AddonDraeUI.VC["global"] = {}
AddonDraeUI.VC["class"] = {}
AddonDraeUI.VC["char"] = {}

-- Define common elements for our namespace T, C, G, P
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
end

T.OnEnable = function(self)
--	self:UIScaling()
	self:UpdateBlizzardFonts()
	self:InitializeConsoleCommands()

	local viewportEdgeBot = CreateFrame("Frame", nil, UIParent)
	viewportEdgeBot:SetFrameStrata("BACKGROUND")
	viewportEdgeBot:SetFrameLevel(3)
	viewportEdgeBot:SetWidth(T.screenWidth)
	viewportEdgeBot:SetHeight(5)
	viewportEdgeBot:SetPoint("BOTTOMLEFT", 0, 0)

	local botTex = viewportEdgeBot:CreateTexture(nil, "BACKGROUND")
	botTex:SetTexture(0.35, 0.35, 0.50, 0.60)
	botTex:SetAllPoints(viewportEdgeBot)

	local viewportEdgeTop = CreateFrame("Frame", nil, UIParent)
	viewportEdgeTop:SetFrameStrata("BACKGROUND")
	viewportEdgeTop:SetFrameLevel(3)
	viewportEdgeTop:SetWidth(T.screenWidth)
	viewportEdgeTop:SetHeight(5)
	viewportEdgeTop:SetPoint("TOPLEFT", 0, 0)

	local topTex = viewportEdgeTop:CreateTexture(nil, "BACKGROUND")
	topTex:SetTexture(0.35, 0.35, 0.50, 0.60)
	topTex:SetAllPoints(viewportEdgeTop)

--	self:RegisterEvent("UI_SCALE_CHANGED", "UIScaling")
end
