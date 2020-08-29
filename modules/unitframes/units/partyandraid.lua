--[[


--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local Smoothing = LibStub("LibCutawaySmooth-1.0", true)

-- Default indicator positions
local indicators = {
	-- Icons
	["CENTERICON"] = {type = "icon", width = 20, height = 20, at = "CENTER", to = "CENTER", offsetX = 0, offsetY = -4},
	["BOTTOMICON"] = {type = "icon", width = 18, height = 18, at = "CENTER", to = "BOTTOM", offsetX = 0, offsetY = -3},
	["TOPICON"] = {type = "icon", width = 18, height = 18, at = "CENTER", to = "TOP", offsetX = 0, offsetY = 3},
	-- Colour only indicators
	["TOP"] = {type = "color", width = 8, height = 8, at = "TOP", to = "TOP", offsetX = 0, offsetY = 1},
	["TOPR"] = {type = "color", width = 8, height = 8, at = "TOP", to = "TOP", offsetX = -8, offsetY = 1},
	["TOPL"] = {type = "color", width = 8, height = 8, at = "TOP", to = "TOP", offsetX = 8, offsetY = 1},
	["TOPLEFT"] = {type = "color", width = 8, height = 8, at = "TOPLEFT", to = "TOPLEFT", offsetX = 0, offsetY = 1},
	["TOPRIGHTL"] = {type = "color", width = 6, height = 6, at = "TOPRIGHT", to = "TOPRIGHT", offsetX = -6, offsetY = 1},
	["TOPRIGHT"] = {type = "color", width = 8, height = 8, at = "TOPRIGHT", to = "TOPRIGHT", offsetX = 1, offsetY = 1},
	["TOPRIGHTB"] = {type = "color", width = 6, height = 6, at = "TOPRIGHT", to = "TOPRIGHT", offsetX = 1, offsetY = -6},
	["BOTTOM"] = {type = "color", width = 8, height = 8, at = "BOTTOM", to = "BOTTOM", offsetX = 0, offsetY = -1},
	["BOTTOML"] = {type = "color", width = 8, height = 8, at = "BOTTOM", to = "BOTTOM", offsetX = -8, offsetY = -1},
	["BOTTOMR"] = {type = "color", width = 8, height = 8, at = "BOTTOM", to = "BOTTOM", offsetX = 8, offsetY = -1},
	["BOTTOMLEFT"] = {
		type = "color",
		width = 8,
		height = 8,
		at = "BOTTOMLEFT",
		to = "BOTTOMLEFT",
		offsetX = 0,
		offsetY = -1
	},
	["LEFT"] = {type = "color", width = 8, height = 8, at = "LEFT", to = "LEFT", offsetX = 0, offsetY = 0},
	["LEFTT"] = {type = "color", width = 8, height = 8, at = "LEFT", to = "LEFT", offsetX = 0, offsetY = -8},
	["LEFTB"] = {type = "color", width = 8, height = 8, at = "LEFT", to = "LEFT", offsetX = 0, offsetY = 8},
	["RIGHT"] = {type = "color", width = 8, height = 8, at = "RIGHT", to = "RIGHT", offsetX = 1, offsetY = 0}

	-- Additional indicators are:
	-- Border
	-- Text2
}

--[[

--]]
local FrameOnEnter = function(frame)
	UnitFrame_OnEnter(frame)
	if (frame.Highlight) then
		frame.Highlight:Show()
	end
end

local FrameOnLeave = function(frame)
	UnitFrame_OnLeave(frame)
	if (frame.Highlight) then
		frame.Highlight:Hide()
	end
end

--[[
		Handlers for various indicator functions
--]]
local SetStatus_Indicator = function(ind, data)
	if (ind.cd) then
		if (data.duration) then
			ind.cd:SetCooldown(data.start, data.duration)
			ind.cd:Show()
		else
			ind.cd:Hide()
		end
	end

	if (data.notMine) then
		ind.notMine:Show()
	else
		ind.notMine:Hide()
	end

	local color
	if (data.stack and data.color and type(data.color[1]) == "table") then
		color = data.color[data.stack]
	else
		color = data.color
	end

	if (color) then
		ind:SetBackdropColor(color.r, color.g, color.b, color.a or 1.0)
	end

	if (data.pulse) then
		if (not ind.pulse:IsPlaying()) then
			ind.pulse:Play()
		end
	elseif (ind.pulse:IsPlaying()) then
		ind.pulse:Stop()
	end

	if (data.flash) then
		if (not ind.flash:IsPlaying()) then
			ind.flash:Play()
		end
	elseif (ind.flash:IsPlaying()) then
		ind.flash:Stop()
	end
end

local SetStatus_Icon = function(ind, data)
	if (ind.cd) then
		if (data.duration) then
			ind.cd:SetCooldown(data.start, data.duration)
			ind.cd:Show()
		else
			ind.cd:Hide()
		end
	end

	local color
	if (data.stack and data.color and type(data.color[1]) == "table") then
		color = data.color[data.stack]
	else
		color = data.color or {0, 0, 0, 1.0}
	end

	if (color) then
		ind:SetBackdropColor(color.r, color.g, color.b, color.a or 1.0)
	end

	ind.icon:SetTexture(data.texture)

	if (data.stack) then
		ind.count:SetText(data.stack > 1 and data.stack or "")
	end

	if (data.pulse) then
		if (not ind.pulse:IsPlaying()) then
			ind.pulse:Play()
		end
	elseif (ind.pulse:IsPlaying()) then
		ind.pulse:Stop()
	end

	if (data.flash) then
		if (not ind.flash:IsPlaying()) then
			ind.flash:Play()
		end
	elseif (ind.flash:IsPlaying()) then
		ind.flash:Stop()
	end
end

local SetStatus_BorderColor = function(ind, data)
	local color
	if (data.stack and data.color and type(data.color[1]) == "table") then
		color = data.color[data.stack]
	else
		color = data.color
	end

	if (color) then
		ind:SetBackdropBorderColor(color.r, color.g, color.b, color.a or 1.0)
	end
end

local ClearStatus_BorderColor = function(ind)
	ind:SetBackdropBorderColor(0, 0, 0, 1)
end

local SetStatus_Text2 = function(ind, data)
	if (data.text) then
		UF.UpdateText2(ind:GetParent():GetParent(), data.text) -- Parent of text2 health, parent of health is the button
	end
end

local ClearStatus_Text2 = function(ind, data)
	UF.UpdateText2(ind:GetParent():GetParent(), "")
end

--[[
		Create the indicator frames
--]]
local CreateIndicator = function(frame, indicator)
	local ind = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")

	if (not indicators[indicator]) then
		return
	end

	if (indicators[indicator].type == "color") then
		ind:SetSize(indicators[indicator].width, indicators[indicator].height)

		ind:SetBackdrop(
			{
				bgFile = "Interface\\BUTTONS\\WHITE8X8",
				tile = true,
				tileSize = 8,
				edgeFile = "Interface\\BUTTONS\\WHITE8X8",
				edgeSize = 1,
				insets = {left = 1, right = 1, top = 1, bottom = 1}
			}
		)

		ind.SetJob = SetStatus_Indicator
	elseif (indicators[indicator].type == "icon") then
		ind:SetSize(indicators[indicator].width, indicators[indicator].height)

		ind:SetBackdrop(
			{
				bgFile = "Interface\\BUTTONS\\WHITE8X8",
				tile = true,
				tileSize = 8
			}
		)

		local t = ind:CreateTexture(nil, "OVERLAY")
		t:SetTexCoord(.1, .9, .1, .9)
		t:SetPoint("CENTER", ind, "CENTER")
		t:SetSize(indicators[indicator].width - 2, indicators[indicator].height - 2)
		t:SetColorTexture(0, 0, 0, 1)

		ind.icon = t
		ind.SetJob = SetStatus_Icon
	end

	-- Pulsing
	local pulse = ind:CreateAnimationGroup()
	pulse:SetLooping("BOUNCE")

	local grow = pulse:CreateAnimation("Scale")
	grow:SetScale(1.15, 1.15)
	grow:SetOrigin("CENTER", 0, 0)
	grow:SetDuration(0.25)
	grow:SetOrder(0)

	ind.pulse = pulse

	local flash = ind:CreateAnimationGroup()
	flash:SetLooping("BOUNCE")

	local alpha = flash:CreateAnimation("Alpha")
	alpha:SetFromAlpha(1)
	alpha:SetToAlpha(0)
	alpha:SetDuration(0.25)
	alpha:SetOrder(0)

	ind.flash = flash

	ind:SetScript(
		"OnHide",
		function()
			if (ind.pulse:IsPlaying()) then
				ind.pulse:Stop()
			end

			if (ind.flash:IsPlaying()) then
				ind.flash:Stop()
			end
		end
	)

	ind:ClearAllPoints()
	ind:SetFrameLevel(frame:GetFrameLevel() + 7)
	ind:SetPoint(
		indicators[indicator].at,
		frame.Health,
		indicators[indicator].to,
		indicators[indicator].offsetX,
		indicators[indicator].offsetY
	)
	ind:SetBackdropBorderColor(0, 0, 0, 1)
	ind:SetBackdropColor(1, 1, 1, 1)
	ind:Hide()

	-- A little black "dot" which says "this indicator didn't originate from me"
	if (indicators[indicator].type ~= "icon") then
		local notMine = ind:CreateTexture(nil, "ARTWORK")
		notMine:SetPoint("BOTTOMLEFT", ind, "BOTTOMLEFT", 0, 0)
		notMine:SetWidth(indicators[indicator].width / 3)
		notMine:SetHeight(indicators[indicator].height / 3)
		notMine:SetTexture("Interface\\BUTTONS\\WHITE8X8")
		notMine:SetVertexColor(0, 0, 0, 1)
		notMine:Hide()
		ind.notMine = notMine
	end

	local cd = CreateFrame("Cooldown", nil, ind, "CooldownFrameTemplate")
	cd:SetReverse(true)
	cd:SetAllPoints(indicators[indicator].type == "color" and ind or ind.icon)
	cd:SetHideCountdownNumbers(indicators[indicator].type ~= "icon" and true or false)
	cd.noCooldownCount = indicators[indicator].type ~= "icon" and true or false -- disable OmniCC for non-icon indicators
	ind.cd = cd

	if (indicators[indicator].type == "icon") then
		local count = ind:CreateFontString(nil, "OVERLAY")
		count:SetFont(T["media"].font, T.db["general"].fontsize2, "OUTLINE")
		count:SetPoint("BOTTOMRIGHT", ind, "BOTTOMRIGHT", 5, -4)
		count:SetTextColor(1, 1, 1)
		count:SetShadowOffset(1, -1)

		ind.count = count
	end

	frame[indicator] = ind
end

--[[

--]]
local SetIndicator = function(self, indicator, status)
	if (not self[indicator]) then
		self:CreateIndicator(indicator)
	end

	if (self[indicator]) then
		if (self ~= self[indicator]) then
			self[indicator]:Show()
		end

		if (self[indicator].SetJob) then
			self[indicator]:SetJob(status)
		end
	end
end

local ClearIndicator = function(self, indicator, status)
	if (self[indicator]) then
		if self[indicator].ClearJob then
			self[indicator]:ClearJob()
		elseif (self ~= self[indicator]) then
			self[indicator]:Hide()
		end
	end
end

local UpdateIndicator = function(self, status)
	local topPriority = 0
	local topStatus

	for indicator, map_for_indicator in pairs(T.dbClass["statusmap"]) do
		if (map_for_indicator[status]) then
			for statusName, enabled in pairs(map_for_indicator) do
				local st = enabled and self.statuscache[statusName]

				if (st and st.state) then
					if (st.priority or 99) > topPriority then
						topStatus = st
						topPriority = st.priority
					end
				end
			end

			if (topStatus) then
				self:SetIndicator(indicator, topStatus)
			else
				self:ClearIndicator(indicator)
			end
		end
	end
end

local GainedStatus
do
	local cached

	GainedStatus = function(
		self,
		unit,
		status,
		priority,
		color,
		texture,
		text,
		value,
		maxValue,
		start,
		duration,
		stack,
		notMine,
		pulse,
		flash)
		if (unit and self.unit ~= unit) then
			return
		end
		unit = unit or self.unit

		local statuscache = self.statuscache

		if (type(color) ~= "table") then
			color = {}
		end

		if (text == nil) then
			text = ""
		end

		-- create cache for unit if needed
		if (not statuscache[status]) then
			statuscache[status] = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
		end

		cached = statuscache[status]

		-- if no changes were made, return rather than triggering an event
		if
			(cached and cached.state == true and cached.priority == priority and cached.color == color and
				cached.texture == texture and
				cached.text == text and
				cached.value == value and
				cached.maxValue == maxValue and
				cached.start == start and
				cached.duration == duration and
				cached.stack == stack and
				cached.notMine == notMine and
				cached.pulse == pulse and
				cached.flash == flash)
		 then
			return
		end

		-- update cache
		cached.state = true
		cached.priority = priority
		cached.color = color
		cached.texture = texture
		cached.text = text
		cached.value = value
		cached.maxValue = maxValue
		cached.start = start
		cached.duration = duration
		cached.stack = stack
		cached.notMine = notMine
		cached.pulse = pulse
		cached.flash = flash

		self:UpdateIndicator(status)
	end
end

local LostStatus = function(self, unit, status)
	if (unit and self.unit ~= unit) then
		return
	end
	unit = unit or self.unit

	-- if status isn't cached or is not longer true don't update the indicator
	if (not self.statuscache[status] or self.statuscache[status].state == false) then
		return
	end

	self.statuscache[status].state = false

	self:UpdateIndicator(status)
end

--[[

--]]
local CoreUpdate = function(frame, event)
	if (not frame.unit) then
		return
	end

	local guid = UnitGUID(frame.unit)
	if (not guid) then
		return
	end

	if (not oUF.frames) then
		oUF.frames = {}
	end

	oUF.frames[guid] = frame
end

--[[
		Let"s style the button
--]]
local StyleDrae_Raid = function(frame, unit)
	frame.PreUpdate = CoreUpdate

	frame.isPet = unit:match("raidpet") and true or false

	frame:SetScript("OnEnter", FrameOnEnter)
	frame:SetScript("OnLeave", FrameOnLeave)

	frame.Range = {
		insideAlpha = 1.0,
		outsideAlpha = 0.25
	}

	local baseLevel = frame:GetFrameLevel()

	-- Frame edge glow
	local border = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
	border:SetPoint("TOPLEFT", frame, -2, 2)
	border:SetPoint("BOTTOMRIGHT", frame, 2, -2)
	border:SetFrameStrata("BACKGROUND")
	border:SetBackdrop {
		bgFile = "Interface\\Buttons\\White8x8",
		edgeFile = "Interface\\Buttons\\White8x8",
		tile = false,
		edgeSize = 2
	}
	border:SetBackdropColor(0, 0, 0, 1)
	border:SetBackdropBorderColor(0, 0, 0, 1)
	border.SetJob = SetStatus_BorderColor
	border.ClearJob = ClearStatus_BorderColor
	frame.Border = border

	-- Frame highlight
	local highlight = border:CreateTexture(nil, "BACKGROUND", -7)
	highlight:SetPoint("TOPLEFT", frame, -4, 4)
	highlight:SetPoint("BOTTOMRIGHT", frame, 4, -4)
	highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	highlight:SetTexCoord(0, 1, 0.23, 0.77)
	highlight:SetBlendMode("ADD")
	highlight:Hide()
	frame.Highlight = highlight

	-- Get height of powerbar so we can size the healthbar correctly
	local powerBarSize = 4
	frame.powerBarSize = powerBarSize

	-- Health
	local hp = CreateFrame("StatusBar", nil, frame)
	hp:SetFrameLevel(baseLevel + 2)
	hp:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped")
	hp:SetOrientation("VERTICAL")
	hp:SetHeight(40 - powerBarSize)
	hp:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
	hp:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, frame.isPet and 1 or 1 + powerBarSize)

	if (T.db["raidframes"].colorSmooth) then
		Smoothing:EnableBarAnimation(hp)
	end

	hp.colorClassPet = T.db["raidframes"].colorPet
	hp.colorCharmed = T.db["raidframes"].colorCharmed
	hp.Override = UF.UpdateRaidHealth -- override the oUF update

	hp.height = hp:GetHeight()

	frame.Health = hp

	do
		-- Total healing required to increase units health due to a heal absorb debuff/effect
		local healAbsorbBar = CreateFrame("StatusBar", nil, frame.Health)
		healAbsorbBar:SetStatusBarTexture("Interface\\Buttons\\White8x8")
		healAbsorbBar:SetOrientation("VERTICAL")
		healAbsorbBar:SetReverseFill(true)
		healAbsorbBar:SetHeight(hp:GetHeight() - powerBarSize)
		healAbsorbBar:SetStatusBarColor(1.0, 0, 0, 0.33)
		healAbsorbBar:SetPoint("LEFT")
		healAbsorbBar:SetPoint("RIGHT")
		healAbsorbBar:SetPoint("TOP", frame.Health:GetStatusBarTexture(), "TOP")

		-- My incoming heals
		local myBar = CreateFrame("StatusBar", nil, frame.Health)
		myBar:SetStatusBarTexture("Interface\\Buttons\\White8x8")
		myBar:SetOrientation("VERTICAL")
		myBar:SetHeight(hp:GetHeight() - powerBarSize)
		myBar:SetStatusBarColor(0, 1, 0, 0.7)
		myBar:SetPoint("LEFT")
		myBar:SetPoint("RIGHT")
		myBar:SetPoint("BOTTOM", healAbsorbBar:GetStatusBarTexture(), "TOP")

		-- Other incoming heals
		local otherBar = CreateFrame("StatusBar", nil, frame.Health)
		otherBar:SetStatusBarTexture("Interface\\Buttons\\White8x8")
		otherBar:SetOrientation("VERTICAL")
		otherBar:SetHeight(hp:GetHeight() - powerBarSize)
		otherBar:SetStatusBarColor(0.5, 0, 1, 0.7)
		otherBar:SetPoint("LEFT")
		otherBar:SetPoint("RIGHT")
		otherBar:SetPoint("BOTTOM", myBar:GetStatusBarTexture(), "TOP")

		-- Total absorb/shields on target
		local absorbBar = CreateFrame("StatusBar", nil, frame.Health)
		absorbBar:SetStatusBarTexture("Interface\\Buttons\\White8x8")
		absorbBar:SetOrientation("VERTICAL")
		absorbBar:SetHeight(hp:GetHeight() - powerBarSize)
		absorbBar:SetStatusBarColor(1.0, 1.0, 1.0, 0.33)
		absorbBar:SetPoint("LEFT")
		absorbBar:SetPoint("RIGHT")
		absorbBar:SetPoint("BOTTOM", otherBar:GetStatusBarTexture(), "TOP")

		-- Damage (shields/absorbs) greater than health
		local overAbsorb = frame.Health:CreateTexture(nil, "OVERLAY")
		overAbsorb:SetTexture("Interface/BUTTONS/WHITE8X8")
		overAbsorb:SetColorTexture(1.0, 1.0, 1.0, 0.66) -- Always white
		overAbsorb:SetBlendMode("ADD")
		overAbsorb:SetPoint("LEFT")
		overAbsorb:SetPoint("RIGHT")
		overAbsorb:SetPoint("TOP")
		overAbsorb:SetHeight(3)
		overAbsorb:Hide()

		-- Healing absorb greater than health
		local overHealAbsorb = frame.Health:CreateTexture(nil, "OVERLAY")
		overHealAbsorb:SetTexture("Interface\\Buttons\\White8x8")
		overHealAbsorb:SetColorTexture(1.0, 0, 0, 0.66) -- Always red
		overHealAbsorb:SetBlendMode("ADD")
		overHealAbsorb:SetPoint("LEFT")
		overHealAbsorb:SetPoint("RIGHT")
		overHealAbsorb:SetPoint("BOTTOM")
		overHealAbsorb:SetHeight(2)
		overHealAbsorb:Hide()

		frame.HealthPrediction = {
			myBar = myBar,
			otherBar = otherBar,
			absorbBar = absorbBar,
			healAbsorbBar = healAbsorbBar,
			overAbsorb = overAbsorb,
			overHealAbsorb = overHealAbsorb,
			maxOverflow = 1.0,
		}
	end

	if (not frame.isPet) then
		-- Power
		local pr, pg, pb = unpack(frame.colors.power["MANA"])

		local pp = CreateFrame("StatusBar", nil, frame)
		pp:SetFrameLevel(baseLevel + 2)
		pp:SetHeight(powerBarSize)
		pp:SetPoint("BOTTOMLEFT", 1, 1)
		pp:SetPoint("BOTTOMRIGHT", -1, 1)
		pp:SetPoint("TOP", hp, "BOTTOM", 0, -1) -- Little offset to make it pretty
		pp:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\Striped")

		pp.Override = UF.UpdateRaidPower -- override oUF
		frame.Power = pp

		if (T.db["raidframes"].colorSmooth) then
			Smoothing:EnableBarAnimation(pp)
		end

		pp:SetStatusBarColor(pr, pg, pb)
	end

	-- Text1 (used for name)
	local text1 = hp:CreateFontString(nil, "OVERLAY")
	text1:SetFont(T["media"].font, T.db["general"].fontsize3, "NONE")
	text1:SetPoint("CENTER", hp, "CENTER", 0, frame.isPet and 0 or 5)
	text1:SetShadowOffset(1, -1)
	frame:Tag(text1, "[draeraid:name]")
	frame.Text1 = text1

	if (not frame.isPet) then
		-- Text2 (used for general indication)
		local text2 = frame.Health:CreateFontString(nil, "OVERLAY")
		text2:SetFont(T["media"].font, T.db["general"].fontsize3, "NONE")
		text2:SetPoint("CENTER", frame.Health, "CENTER", 0, -6)
		text2:SetShadowOffset(1, -1)
		text2.__locked = nil
		text2.SetJob = SetStatus_Text2
		text2.ClearJob = ClearStatus_Text2
		frame.Text2 = text2
	end

	-- Leader Icon
	local leaderFrame = CreateFrame("Frame", nil, hp)
	leaderFrame:SetSize(15, 15)
	leaderFrame:SetPoint("TOPLEFT", frame, -7, 9)
	leaderFrame:SetFrameLevel(baseLevel + 4)
	local leader = leaderFrame:CreateTexture(nil, "OVERLAY")
	leader:SetAllPoints(leaderFrame)
	leader:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	leader:Hide()
	frame.LeaderIndicator = leader

	-- Role Icon
	local lfdroleFrame = CreateFrame("Frame", nil, hp)
	lfdroleFrame:SetSize(12, 12)
	lfdroleFrame:SetPoint("BOTTOMRIGHT", frame, 7, -7)
	lfdroleFrame:SetFrameLevel(baseLevel + 4)
	local lfdrole = lfdroleFrame:CreateTexture(nil, "OVERLAY")
	lfdrole:SetAllPoints(lfdroleFrame)
	lfdrole:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
	lfdrole:Hide()
	lfdrole.Override = UF.OverrideGroupRoleIndicator
	frame.GroupRoleIndicator = lfdrole

	-- Raid Icon - unit and target of unit
	local raidIconFrame = CreateFrame("Frame", nil, hp)
	raidIconFrame:SetSize(16, 16)
	raidIconFrame:SetPoint("CENTER", frame, "TOP", 0, 0)
	raidIconFrame:SetFrameLevel(baseLevel + 4)
	local raidIcon = raidIconFrame:CreateTexture(nil, "OVERLAY")
	raidIcon:SetAllPoints(raidIconFrame)
	raidIcon:SetAlpha(0.75)
	raidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	raidIcon:Hide()
	frame.RaidTargetIndicator = raidIcon

	-- Readycheck
	local readyCheck = hp:CreateTexture(nil, "OVERLAY")
	readyCheck:SetHeight(22)
	readyCheck:SetWidth(22)
	readyCheck:SetPoint("CENTER", frame, "CENTER", 0, 0)
	frame.ReadyCheckIndicator = readyCheck

	-- Show/hide mana bar
	frame:RegisterEvent("UNIT_DISPLAYPOWER", UF.UpdateRaidPower)

	-- Update unit colouration
	frame:RegisterEvent("UNIT_CONNECTION", UF.UpdateRaidHealth)
	frame:RegisterEvent("PLAYER_FLAGS_CHANGED", UF.UpdateRaidHealth) -- AFK status changes
	frame:RegisterEvent("PLAYER_CONTROL_LOST", UF.UpdateRaidHealth, true) -- Mind control, fear, taxi, etc.

	--[[
			Indicators
	--]]
	frame.CreateIndicator = CreateIndicator
	frame.SetIndicator = SetIndicator
	frame.ClearIndicator = ClearIndicator
	frame.UpdateIndicator = UpdateIndicator
	frame.GainedStatus = GainedStatus
	frame.LostStatus = LostStatus

	frame.statuscache = {}
end

oUF:RegisterStyle("DraeRaid", StyleDrae_Raid)
