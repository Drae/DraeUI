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
local SPELL_POWER_CHI = SPELL_POWER_CHI

local curChi = 0

--[[
		Monk
		This handles Chi, ExtraPower and mana regen via stacks of mana tea
--]]
local UpdateChi = function(self, event, unit, powerType)
	if (unit ~= "player" ) then return end

	local chiBar = self.resourceBar
	local chi = UnitPower(unit, SPELL_POWER_CHI)

	for i = 1, UnitPowerMax(unit, SPELL_POWER_CHI) do
		local isShown = ((chiBar[i].lit:GetAlpha() > 0 and not chiBar[i].animHide:IsPlaying()) or chiBar[i].animShow:IsPlaying()) and true or false
		local shouldShow = i <= chi and true or false

		if (isShown ~= shouldShow) then
			if (isShown) then
				if (chiBar[i].animShow:IsPlaying()) then
					chiBar[i].animShow:Stop()
				end
				chiBar[i].animHide:Play()
			else
				if (chiBar[i].animHide:IsPlaying()) then
					chiBar[i].animHide:Stop()
				end
				chiBar[i].animShow:Play()
			end
		end
	end
end

local UpdateChiPositions = function(self)
	local rs = self.resourceBar

	local maxChi = UnitPowerMax("player", SPELL_POWER_CHI)

	if (rs.maxChi ~= maxChi) then
		local _prev

		for i = maxChi, 1, -1 do
			if (_prev) then
				rs[i]:Point("RIGHT", _prev, "LEFT", 0, 0)
			else
				rs[i]:Point("RIGHT", rs, "RIGHT", 0, 0)
			end

			_prev = rs[i]
		end

		rs.maxChi = maxChi
	end
end

local PlayerSpecChanged = function(self)
	local spec = GetSpecialization()

	if (spec == SPEC_MONK_WINDWALKER) then
		self.resourceBar:Show()
		UpdateChiPositions(self)
	else
		self.resourceBar:Hide()
	end
end

UF.CreateMonkClassBar = function(self, point, anchor, relpoint, xOffset, yOffset)
	local spec = GetSpecialization()

	if (T.playerClass ~= "MONK") then return end

	local rs = CreateFrame("Frame", nil, self)
	rs:SetFrameLevel(12)
	rs:Point(point, anchor, relpoint, xOffset, yOffset)
	rs:Size(210, 20)
	rs:Hide()

	rs.maxLight 	= 0
	rs.animShow 	= {}
	rs.animHide 	= {}

	for i = 1, 6 do
		rs[i] = CreateFrame("Frame", nil, rs)
		rs[i]:Size(22, 22)

		local r = rs[i]:CreateTexture(nil, "ARTWORK")
		r:SetAtlas("MonkUI-OrbOff", true)
		r:SetAllPoints(rs[i])

		local r2 = rs[i]:CreateTexture(nil, "ARTWORK")
		r2:SetAtlas("MonkUI-LightOrb", true)
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
	self.ClassIcons.Override 		= UpdateChi
	self.ClassIcons.UpdateTexture 	= function() end

	self:RegisterEvent("PLAYER_TALENT_UPDATE", UpdateChiPositions, true)
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", PlayerSpecChanged, true)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", PlayerSpecChanged, true)

	UpdateChiPositions(self)
end
