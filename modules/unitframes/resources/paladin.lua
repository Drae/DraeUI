--[[


--]]
local _, ns = ...
local oUF = ns.oUF or oUF

local T, C, G, P, U, _ = select(2, ...):unpack()
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
		TODO: Mana regen for Holy?
--]]
do
	local SPELL_POWER_HOLY_POWER, PALADINPOWERBAR_SHOW_LEVEL = SPELL_POWER_HOLY_POWER, PALADINPOWERBAR_SHOW_LEVEL
	local hopo = 0

	local OnPower = function(self, event, unit, powerType)
		if (powerType ~= "HOLY_POWER" or InCombatLockdown()) then return end

		local rs = self.resourceBar
		local pp = self.ExtraPower
		local curHopo = UnitPower("player", SPELL_POWER_HOLY_POWER)

		if (curHopo == 0) then
			rs:SetAlpha(0)
			if (not pp._hide) then
				pp:Hide()
			end
		elseif (hopo == 0 and curHopo > 0) then
			rs:SetAlpha(1.0)
			if (not pp._hide) then
				pp:Show()
			end
		end

		hopo = curHopo
	end

	local OnEvent = function(self, event)
		local rs = self.resourceBar
		local pp = self.ExtraPower

		if (InCombatLockdown() or event == "PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("UNIT_POWER", OnPower)

			rs:SetAlpha(1.0)
			if (not pp._hide) then
				pp:Show()
			end
		else
			self:RegisterEvent("UNIT_POWER", OnPower)

			OnPower(self, nil, unit, "HOLY_POWER")
		end
	end

		-- Store the current spec in ExtraPower._spec so we can avoid
	-- showing the extrapower bar, etc. for non-holy specs
	local PlayerSpecChanged = function(self, event, unit)
		local pp = self.ExtraPower
		local spec = GetSpecialization()

		-- Holy? Enable mana regen and shizzle
		pp._hide = (spec == 1) and false or true
	end

	local EnablePaladinPowerBar = function(self)
		if (UnitLevel("player") >= PALADINPOWERBAR_SHOW_LEVEL) then
			self:RegisterEvent("PLAYER_REGEN_DISABLED", OnEvent, true)
			self:RegisterEvent("PLAYER_REGEN_ENABLED", OnEvent, true)

			PlayerSpecChanged(self)
		end
	end

	UF.CreateHolyPowerBar = function(self, point, anchor, relpoint, xOffset, yOffset)
		if (T.playerClass ~= "PALADIN") then return end

		local scale = 1.35

		local rs = CreateFrame("Frame", nil, self)
		rs:SetFrameLevel(12)
		rs.unit = "player"

		_G["PaladinPowerBar"]:SetParent(rs)
		_G["PaladinPowerBar"]:EnableMouse(false)
		_G["PaladinPowerBar"]:ClearAllPoints()
		_G["PaladinPowerBar"]:SetPoint(point, anchor, relpoint, xOffset / scale, yOffset / scale)
		_G["PaladinPowerBar"]:SetScale(scale)
		rs:SetAlpha(0)

		_G["PaladinPowerBarBG"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarGlowBGTexture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarRune1Texture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarRune2Texture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarRune3Texture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarRune4Texture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")
		_G["PaladinPowerBarRune5Texture"]:SetTexture("Interface\\AddOns\\draeUI\\media\\resourcebars\\PaladinHolyPower")

		-- Create power bar - only displayed for Holy
		local pp = UF.CreateExtraPowerBar(self, point, anchor, relpoint, 0, 32)

		self.ExtraPower = pp
		self.resourceBar = rs

		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", PlayerSpecChanged, true)
		self:RegisterEvent("PLAYER_LEVEL_UP", EnablePaladinPowerBar, true)

		-- Run stuff that requires us to be in-game before it returns any
		-- meaningful results
		local enterWorld = CreateFrame("Frame")
		enterWorld:RegisterEvent("PLAYER_ENTERING_WORLD")
		enterWorld:SetScript("OnEvent", function()
			PlayerSpecChanged(self)
			EnablePaladinPowerBar(self)
			OnEvent(self)
		end)
	end
end
