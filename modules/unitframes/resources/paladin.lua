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
		Paladin
		This hijacks the existing Blizzard power bar and builds
		around it - includes extra power bar for Holy specs
--]]
do
	local SPELL_POWER_HOLY_POWER, PALADINPOWERBAR_SHOW_LEVEL = SPELL_POWER_HOLY_POWER, PALADINPOWERBAR_SHOW_LEVEL
	local hopo = 0

	local OnPower = function(self, event, unit, powerType)
		if (powerType ~= "HOLY_POWER" or InCombatLockdown()) then return end

		local cb = self.classBar
		local curHopo = UnitPower("player", SPELL_POWER_HOLY_POWER)

		if (curHopo == 0) then
			cb:SetAlpha(0)
		elseif (hopo == 0 and curHopo > 0) then
			cb:SetAlpha(1.0)
		end

		hopo = curHopo
	end

	local OnEvent = function(self, event)
		local cb = self.classBar

		if (InCombatLockdown() or event == "PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("UNIT_POWER", OnPower)

			cb:SetAlpha(1.0)
		else
			self:RegisterEvent("UNIT_POWER", OnPower)

			OnPower(self, nil, unit, "HOLY_POWER")
		end
	end

	local CheckPaladinPowerBar = function(self)
		local spec = GetSpecialization()

		if (spec == SPEC_PALADIN_RETRIBUTION and not self.__holyPowerEnabled) then
			if (UnitLevel("player") >= PALADINPOWERBAR_SHOW_LEVEL) then
				self.__holyPowerEnabled = true

				self:RegisterEvent("PLAYER_REGEN_DISABLED", OnEvent, true)
				self:RegisterEvent("PLAYER_REGEN_ENABLED", OnEvent, true)

                self.classBar:Show()
                OnEvent(self, "")
			end
		elseif (self.__holyPowerEnabled) then
			self.__holyPowerEnabled = nil

			self:UnregisterEvent("PLAYER_REGEN_DISABLED", OnEvent, true)
			self:UnregisterEvent("PLAYER_REGEN_ENABLED", OnEvent, true)

            self.classBar:Hide()
		end
	end

	UF.CreatePaladinClassBar = function(self, point, anchor, relpoint, xOffset, yOffset)
		local spec = GetSpecialization()

		if (T.playerClass ~= "PALADIN" or (T.playerClass == "PALADIN" and spec ~= SPEC_PALADIN_RETRIBUTION)) then return end

		local scale = 1.25

		local cb = CreateFrame("Frame", nil, self)
        cb:Point(point, anchor, relpoint, xOffset / scale, yOffset / scale)
		cb:SetFrameLevel(12)
		cb.unit = "player"

		_G["PaladinPowerBarFrame"]:SetParent(cb)
		_G["PaladinPowerBarFrame"]:EnableMouse(false)
		_G["PaladinPowerBarFrame"]:ClearAllPoints()
		_G["PaladinPowerBarFrame"]:Point(point, anchor, relpoint, xOffset / scale, yOffset / scale)
		_G["PaladinPowerBarFrame"]:SetScale(scale)

		_G["PaladinPowerBarFrameBG"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarFrameGlowBGTexture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarFrameRune1Texture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarFrameRune2Texture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarFrameRune3Texture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarFrameRune4Texture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarFrameRune5Texture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		cb:SetAlpha(0)
		cb:Hide()

		self.classBar = cb

		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", CheckPaladinPowerBar, true)
		self:RegisterEvent("PLAYER_LEVEL_UP", CheckPaladinPowerBar, true)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", CheckPaladinPowerBar, true)

        CheckPaladinPowerBar(self)
	end
end
