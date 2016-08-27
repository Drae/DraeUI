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
		Monk
		This handles Chi, ExtraPower and mana regen via stacks of mana tea
--]]
do
	local SPELL_POWER_CHI = SPELL_POWER_CHI
	local curChi = 0

	local OnPower = function(self, event, unit, powerType)
		if (powerType ~= "CHI" or InCombatLockdown()) then return end

		local rs = self.resourceBar

		local chi = UnitPower("player", SPELL_POWER_CHI)

		if (chi == 0) then
			rs:SetAlpha(0)
		elseif (curChi == 0 and chi > 0) then
			rs:SetAlpha(1.0)
		end

		curChi = chi
	end

	local OnEvent = function(self, event, arg1, arg2)
		local rs = self.resourceBar

		if (InCombatLockdown() or event == "PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("UNIT_POWER", OnPower)

			rs:SetAlpha(1.0)
		else
			self:RegisterEvent("UNIT_POWER", OnPower)

			OnPower(self, nil, unit, "CHI")
		end
	end

	local UpdateChi = function(self, event, unit, powerType)
		if (unit ~= "player" ) then return end

		local chiBar = self.resourceBar
		local chi = UnitPower(unit, SPELL_POWER_CHI)

		for i = 1, UnitPowerMax(unit, SPELL_POWER_CHI) do
			local isShown = ((chiBar[i].lit:GetAlpha() > 0 and not chiBar[i].animHide:IsPlaying()) or chiBar[i].animShow:IsPlaying()) and true or false
			local shouldShow = i <= chi and true or false

			if (isShown ~= shouldShow) then
				if (isShown) then
					chiBar[i].animHide:Play()
				else
					chiBar[i].animShow:Play()
				end
			end
		end
	end

	local UpdateChiPositions = function(self)
		local rs = self.resourceBar

		local maxChi = UnitPowerMax("player", SPELL_POWER_CHI)

		if (rs.maxChi ~= maxChi) then
			for i = 1, maxChi do
				if (i == 1) then
					rs[i]:Point("LEFT", maxChi == 5 and 8 or maxChi == 6 and 12 or 28, -2)
				else
					rs[i]:Point("LEFT", rs[i - 1], "RIGHT", maxChi == 6 and 0 or 10, 0)
				end
				rs[i]:SetAlpha(1.0)
			end

			if (rs.maxChi == 5) then
				rs[5]:SetAlpha(0)
			end

			rs.maxChi = maxChi
		end
	end

	local PlayerSpecChanged = function(self)
		local spec = GetSpecialization()

		-- Mistweaver? Enable mana feedback
		if (spec == 2) then
			pp.PostUpdate = UpdateMonkManaRegen
			self:RegisterEvent("UNIT_AURA", UpdateMonkManaTea)

			UpdateMonkManaTea(self)
		else
			self:UnregisterEvent("UNIT_AURA", UpdateMonkManaTea)
			pp.PostUpdate = nil
		end
	end

	UF.CreateMonkBar = function(self, point, anchor, relpoint, xOffset, yOffset)
		local spec = GetSpecialization()

		if (T.playerClass ~= "MONK" or (T.playerClass == "MONK" and spec ~= SPEC_MONK_WINDWALKER)) then return end

		self:RegisterEvent("PLAYER_TALENT_UPDATE", UpdateChiPositions, true)
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", PlayerSpecChanged, true)
		self:RegisterEvent("PLAYER_REGEN_DISABLED", OnEvent, true)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", OnEvent, true)

		-- Run stuff that requires us to be in-game before it returns any
		-- meaningful results
		local enterWorld = CreateFrame("Frame")
		enterWorld:RegisterEvent("PLAYER_ENTERING_WORLD")
		enterWorld:SetScript("OnEvent", function()
			UpdateChiPositions(self)
			PlayerSpecChanged(self)
			OnEvent(self)
		end)
	end
end
