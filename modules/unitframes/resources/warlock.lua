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
		Warlock
		Hijacks all three Blizzard bars
--]]
do
	local OnEvent = function(self, event)
		local cb = self.classBar

		if (event == "PLAYER_REGEN_DISABLED") then
			cb:SetAlpha(1.0)
		else
			cb:SetAlpha(0)
		end
	end

	UF.CreateWarlockBar = function(self, point, anchor, relpoint, xOffset, yOffset)
		if (T.playerClass ~= "WARLOCK") then return end

		local scale = 1.2

		local cb = CreateFrame("Frame", nil, self)
		cb:SetFrameLevel(12)
		cb:EnableMouse(false)
		cb.unit = "player"

		_G["WarlockPowerFrame"]:SetParent(cb)
		_G["WarlockPowerFrame"]:ClearAllPoints()
		_G["WarlockPowerFrame"]:Point(point, anchor, relpoint, xOffset / scale, yOffset / scale)
		_G["WarlockPowerFrame"]:SetScale(scale)

		cb:SetAlpha(0)

		self.classBar = cb

		self:RegisterEvent("PLAYER_REGEN_DISABLED", OnEvent, true)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", OnEvent, true)
	end
end
