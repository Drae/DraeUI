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

--]]
do
	local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER

	local UpdatePower = function(self, event, unit, powerType)
		if (unit ~= "player" ) then return end

		local powerBar = self.resourceBar

		local power = UnitPower(unit, SPELL_POWER_HOLY_POWER)

		for i = 1, UnitPowerMax(unit, SPELL_POWER_HOLY_POWER) do
			local isShown = ((powerBar[i].lit:GetAlpha() > 0 and not powerBar[i].animHide:IsPlaying()) or powerBar[i].animShow:IsPlaying()) and true or false
			local shouldShow = i <= power and true or false

			if (isShown ~= shouldShow) then
				if (isShown) then
					if (powerBar[i].animShow:IsPlaying()) then
						powerBar[i].animShow:Stop()
					end
					powerBar[i].animHide:Play()
				else
					if (powerBar[i].animHide:IsPlaying()) then
						powerBar[i].animHide:Stop()
					end
					powerBar[i].animShow:Play()
				end
			end
		end
	end

	local UpdatePositions = function(self)
		local rs = self.resourceBar

		local maxPower = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)

		local _prev

		for i = maxPower, 1, -1 do
			if (_prev) then
				rs[i]:Point("RIGHT", _prev, "LEFT", 0, 0)
			else
				rs[i]:Point("RIGHT", rs, "RIGHT", 0, 0)
			end

			_prev = rs[i]
		end
	end

	local PlayerSpecChanged = function(self)
		local spec = GetSpecialization()

		if (UnitLevel("player") >= PALADINPOWERBAR_SHOW_LEVEL) then
			if (spec == SPEC_PALADIN_RETRIBUTION) then
				self.resourceBar:Show()
			else
				self.resourceBar:Hide()
			end
		end
	end

	UF.CreatePaladinClassBar = function(self, point, anchor, relpoint, xOffset, yOffset)
		local spec = GetSpecialization()

		if (T.playerClass ~= "PALADIN" or (T.playerClass == "PALADIN" and spec ~= SPEC_PALADIN_RETRIBUTION)) then return end

		local rs = CreateFrame("Frame", nil, self)
		rs:SetFrameLevel(12)
		rs:Point(point, anchor, relpoint, xOffset, yOffset)
		rs:Size(210, 20)

		rs.maxLight 	= 0
		rs.animShow 	= {}
		rs.animHide 	= {}

		local runes = {1, 2, 3, 4, 4}

		for i = 1, UnitPowerMax("player", SPELL_POWER_HOLY_POWER) do
			rs[i] = CreateFrame("Frame", nil, rs)
			rs[i]:Size(34, 34)

			local r = rs[i]:CreateTexture(nil, "ARTWORK")
			r:SetAtlas("nameplates-holypower" .. runes[i] .. "-off")
			r:SetAllPoints(rs[i])

			local r2 = rs[i]:CreateTexture(nil, "ARTWORK")
			r2:SetAtlas("nameplates-holypower" .. runes[i] .. "-on")
			r2:SetAllPoints(rs[i])
			r2:SetAlpha(0)

			rs[i].lit = r2

			rs[i].animShow = rs[i].lit:CreateAnimationGroup()
			local showPoint = rs[i].animShow:CreateAnimation("Alpha")
			showPoint:SetFromAlpha(0)
			showPoint:SetToAlpha(1)
			showPoint:SetDuration(0.2)
			showPoint:SetOrder(1)
			rs[i].animShow:SetScript("OnFinished", function()
				rs[i].lit:SetAlpha(1.0)
			end)

			rs[i].animHide = rs[i].lit:CreateAnimationGroup()
			local hidePoint = rs[i].animHide:CreateAnimation("Alpha")
			hidePoint:SetFromAlpha(1)
			hidePoint:SetToAlpha(0)
			hidePoint:SetDuration(0.3)
			hidePoint:SetOrder(1)
			rs[i].animHide:SetScript("OnFinished", function()
				rs[i].lit:SetAlpha(0)
			end)
		end

		self.resourceBar 				= rs
		self.ClassIcons					= rs
		self.ClassIcons.Override 		= UpdatePower
		self.ClassIcons.UpdateTexture 	= function() end

		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", PlayerSpecChanged, true)
		self:RegisterEvent("PLAYER_LEVEL_UP", PlayerSpecChanged, true)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", PlayerSpecChanged, true)

		UpdatePositions(self)
	end

--[[
		Paladin
		This hijacks the existing Blizzard power bar and builds
		around it - includes extra power bar for Holy specs
--]]
--[[do
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
	end]]
end
