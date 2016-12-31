--[[


--]]
local _, ns = ...
local oUF = ns.oUF or oUF

local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Localise a bunch of functions
local _G = _G
local format, unpack = string.format, unpack
local CreateFrame, UnitLevel, UnitPower, UnitPowerMax, InCombatLockdown = CreateFrame, UnitLevel, UnitPower, UnitPowerMax, InCombatLockdown
local UnitExists, GetComboPoints = UnitExists, GetComboPoints

--[[
		Deathknight
		This uses the libring library to create some fancy run cooldown animations
--]]
UF.CreateDeathknightClassBar = function(self, point, anchor, relpoint, xOffset, yOffset)
	if (T.playerClass ~= "DEATHKNIGHT") then return end

	local cb = CreateFrame("Frame", nil, self)
	cb:SetFrameLevel(12)
	cb:EnableMouse(false)
	cb.unit = "player"

	_G["RuneFrame"]:SetParent(cb)
	_G["RuneFrame"]:ClearAllPoints()
	_G["RuneFrame"]:Point(point, anchor, relpoint, xOffset, yOffset)
--	_G["RuneFrame"]:SetScale(scale)

	self.resourceBar = cb
end

