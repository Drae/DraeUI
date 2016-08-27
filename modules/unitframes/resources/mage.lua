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
		Mage
		Custom arcane charge and power bar
--]]
do
	local mageStatusColour = {
		[1] = { 0.32, 1.00, 0.00 },
		[2] = { 1.00, 0.99, 0.00 },
		[3] = { 1.00, 0.73, 0.00 },
		[4] = { 1.00, 0.32, 0.00 },
		[5] = { 1.00, 0.00, 0.00 },
	}

	local OnEvent = function(self, event, unit)
		self.classBar:SetAlpha(event == "PLAYER_REGEN_DISABLED" and 1.0 or 0)
	end

	local UpdateMageManaColor = function(pp, unit, curMana, maxMana)
		local pct = curMana / maxMana

		local r, g, b, t

		if (pct >= 0.95) then
			t = mageStatusColour[1]
		elseif (pct >= 0.9) then
			t = mageStatusColour[2]
		elseif (pct >= 0.85) then
			t = mageStatusColour[3]
		elseif (pct >= 0.8) then
			t = mageStatusColour[4]
		else
			t = mageStatusColour[5]
		end

		r, g, b = unpack(t)

		pp:SetStatusBarColor(r, g, b)
	end

	local PlayerSpecChanged = function(self)
		local spec = GetSpecialization()

		if (spec == SPEC_MAGE_ARCANE) then
			self:RegisterEvent("PLAYER_REGEN_DISABLED", OnEvent, true)
			self:RegisterEvent("PLAYER_REGEN_ENABLED", OnEvent, true)

			self.classBar:Show()
			self.classBar:SetAlpha(0)
		else
			self.classBar:Hide()

			self:UnregisterEvent("PLAYER_REGEN_ENABLED", OnEvent)
			self:UnregisterEvent("PLAYER_REGEN_DISABLED", OnEvent)
		end
	end

	UF.CreateMageClassBar = function(self, point, anchor, relpoint, xOffset, yOffset)
		local spec = GetSpecialization()

		if (T.playerClass ~= "MAGE" or (T.playerClass == "MAGE" and spec ~= SPEC_MAGE_ARCANE)) then return end

		local scale = 1

		local cb = CreateFrame("Frame", nil, self)
        cb:Point(point, anchor, relpoint, xOffset / scale, yOffset / scale)
		cb:SetFrameLevel(12)
		cb.unit = "player"

		_G["MageArcaneChargesFrame"]:SetParent(cb)
		_G["MageArcaneChargesFrame"]:EnableMouse(false)
		_G["MageArcaneChargesFrame"]:ClearAllPoints()
		_G["MageArcaneChargesFrame"]:Point(point, anchor, relpoint, xOffset / scale, yOffset / scale)
		_G["MageArcaneChargesFrame"]:SetScale(scale)

		_G["MageArcaneChargesFrame"].Background:SetTexture(nil)

		self.classBar = cb

		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", PlayerSpecChanged, true)

		-- Run stuff that requires us to be in-game before it returns any
		-- meaningful results
		local enterWorld = CreateFrame("Frame")
		enterWorld:RegisterEvent("PLAYER_ENTERING_WORLD")
		enterWorld:SetScript("OnEvent", function()
			PlayerSpecChanged(self)
			enterWorld:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end)
	end
end
