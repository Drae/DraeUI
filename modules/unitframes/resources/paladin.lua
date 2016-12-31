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
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER

--[[

--]]
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
	if (T.playerClass ~= "PALADIN") then return end

	local rs = CreateFrame("Frame", nil, self)
	rs:SetFrameLevel(12)
	rs:Point(point, anchor, relpoint, xOffset, yOffset)
	rs:Size(210, 20)
	rs:Hide()

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

	self.resourceBar 				= rs
	self.ClassIcons					= rs
	self.ClassIcons.Override 		= UpdatePower
	self.ClassIcons.UpdateTexture 	= function() end

	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", PlayerSpecChanged, true)
	self:RegisterEvent("PLAYER_LEVEL_UP", PlayerSpecChanged, true)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", PlayerSpecChanged, true)
end
