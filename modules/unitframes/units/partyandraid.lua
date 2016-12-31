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
	["CENTERICON"]		= { type = "icon",  width = 22, height = 22, at = "CENTER",      to = "CENTER",      offsetX = 0,  offsetY = 0},
	["BOTTOMICON"]		= { type = "icon",  width = 18, height = 18, at = "CENTER",      to = "BOTTOM",      offsetX = 0,  offsetY = -2},
	["TOPICON"]			= { type = "icon",  width = 18, height = 18, at = "CENTER",      to = "TOP",      	 offsetX = 0,  offsetY = 2},

	-- Colour only indicators
	["TOP"]				= { type = "color", width = 9,  height = 9,  at = "TOP",         to = "TOP",         offsetX = 0,  offsetY = 1},
	["TOPR"]			= { type = "color", width = 9,  height = 9,  at = "TOP",         to = "TOP",         offsetX = -9, offsetY = 1},
	["TOPL"]			= { type = "color", width = 9,  height = 9,  at = "TOP",         to = "TOP",         offsetX = 9,  offsetY = 1},

	["TOPLEFT"] 		= { type = "color", width = 9,  height = 9,  at = "TOPLEFT",     to = "TOPLEFT",     offsetX = 0,  offsetY = 1},

	["TOPRIGHT"]		= { type = "color", width = 9,  height = 9,  at = "TOPRIGHT",    to = "TOPRIGHT",    offsetX = 1,  offsetY = 1},

	["BOTTOM"] 			= { type = "color", width = 9,  height = 9,  at = "BOTTOM",      to = "BOTTOM",      offsetX = 0,  offsetY = -1},
	["BOTTOML"] 		= { type = "color", width = 9,  height = 9,  at = "BOTTOM",      to = "BOTTOM",      offsetX = -9, offsetY = -1},
	["BOTTOMR"] 		= { type = "color", width = 9,  height = 9,  at = "BOTTOM",      to = "BOTTOM",      offsetX = 9,  offsetY = -1},

	["BOTTOMLEFT"]		= { type = "color", width = 9,  height = 9,  at = "BOTTOMLEFT",  to = "BOTTOMLEFT",  offsetX = 0,  offsetY = -1},

	["LEFT"] 			= { type = "color", width = 9,  height = 9,  at = "LEFT",        to = "LEFT",        offsetX = 0,  offsetY = 0},
	["LEFTT"]	 		= { type = "color", width = 9,  height = 9,  at = "LEFT",        to = "LEFT",        offsetX = 0,  offsetY = -9},
	["LEFTB"]	 		= { type = "color", width = 9,  height = 9,  at = "LEFT",        to = "LEFT",        offsetX = 0,  offsetY = 9},

	["RIGHT"] 			= { type = "color", width = 9,  height = 9,  at = "RIGHT",       to = "RIGHT",       offsetX = 1, offsetY = 0},

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
		color = data.color or { 0, 0, 0, 1.0 }
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
	local ind = CreateFrame("Frame", nil, frame)

	if (not indicators[indicator]) then return end

	if (indicators[indicator].type == "color") then
		ind:Size(indicators[indicator].width, indicators[indicator].height)

		ind:SetBackdrop({
			bgFile = "Interface\\BUTTONS\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeFile = "Interface\\BUTTONS\\WHITE8X8",
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1},
		})

		ind.SetJob = SetStatus_Indicator
	elseif (indicators[indicator].type == "icon") then
		ind:Size(indicators[indicator].width, indicators[indicator].height)

		ind:SetBackdrop({
			bgFile = "Interface\\BUTTONS\\WHITE8X8",
			tile = true,
			tileSize = 8,
		})

		local t = ind:CreateTexture(nil, "OVERLAY")
		t:SetTexCoord(.1, .9, .1, .9)
		t:Point("CENTER", ind, "CENTER")
		t:Size(indicators[indicator].width - 2, indicators[indicator].height - 2)
		t:SetTexture(0, 0, 0, 1)

		ind.icon = t
		ind.SetJob = SetStatus_Icon

		local g = ind:CreateAnimationGroup()
		g:SetLooping("BOUNCE")

		local grow = g:CreateAnimation("Scale")
		grow:SetScale(1.25, 1.25)
		grow:SetOrigin("CENTER", 0, 0)
		grow:SetDuration(0.25)
		grow:SetOrder(0)

		ind.pulse = g

		ind:SetScript("OnHide", function()
			if (ind.pulse:IsPlaying()) then
				ind.pulse:Stop()
			end
		end)
	end

	ind:ClearAllPoints()
	ind:SetFrameLevel(frame:GetFrameLevel() + 7)
	ind:Point(indicators[indicator].at, frame.Health, indicators[indicator].to, indicators[indicator].offsetX, indicators[indicator].offsetY)
	ind:SetBackdropBorderColor(0, 0, 0, 1)
	ind:SetBackdropColor(1, 1, 1, 1)
	ind:Hide()

	-- A little black "dot" which says "this indicator didn't originate from me"
	if (indicators[indicator].type ~= "icon") then
		local notMine = ind:CreateTexture(nil, "ARTWORK")
		notMine:Point("BOTTOMLEFT", ind, "BOTTOMLEFT", 0, 0)
		notMine:SetWidth(indicators[indicator].width / 3)
		notMine:Height(indicators[indicator].height / 3)
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
		count:Point("BOTTOMRIGHT", ind, "BOTTOMRIGHT", 5, -4)
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

	if  (self[indicator]) then
		if (self ~= self[indicator]) then
			self[indicator]:Show()
		end

		if (self[indicator].SetJob) then
			self[indicator]:SetJob(status)
		end
	end
end

local ClearIndicator = function(self, indicator, status)
	if  (self[indicator]) then
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

	GainedStatus = function(self, unit, status, priority, color, texture, text, value, maxValue, start, duration, stack, notMine, pulse)
		if (unit and self.unit ~= unit) then return end
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
			statuscache[status] = { nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil }
		end

		cached = statuscache[status]

		-- if no changes were made, return rather than triggering an event
		if (cached
			and cached.state == true
			and cached.priority == priority
			and cached.color == color
			and cached.texture == texture
			and cached.text == text
			and cached.value == value
			and cached.maxValue == maxValue
			and cached.start == start
			and cached.duration == duration
			and cached.stack == stack
			and cached.notMine == notMine
			and cached.pulse == pulse)
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

		self:UpdateIndicator(status)
	end
end

local LostStatus = function(self, unit, status)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	-- if status isn't cached or is not longer true don't update the indicator
	if (not self.statuscache[status] or self.statuscache[status].state == false) then return end

	self.statuscache[status].state = false

	self:UpdateIndicator(status)
end

--[[

--]]
local CoreUpdate = function(frame, event)
	if (not frame.unit) then return end

	local guid = UnitGUID(frame.unit)
	if (not guid) then return end

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

	frame.Range	= {
		insideAlpha	= 1.0,
		outsideAlpha = 0.25,
	}

	local baseLevel = frame:GetFrameLevel()

	-- Frame edge glow
	local border = CreateFrame("Frame", nil, frame)
	border:Point("TOPLEFT", frame, -2, 2)
	border:Point("BOTTOMRIGHT", frame, 2, -2)
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
	highlight:Point("TOPLEFT", frame, -4, 4)
	highlight:Point("BOTTOMRIGHT", frame, 4, -4)
	highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	highlight:SetTexCoord(0, 1, 0.23, 0.77)
	highlight:SetBlendMode("ADD")
	highlight:Hide()
	frame.Highlight = highlight

	-- Get height of powerbar so we can size the healthbar correctly
	local powerBarSize = 4

	-- Health
	local hp = CreateFrame("StatusBar", nil, frame)
	hp:SetFrameLevel(baseLevel + 2)
	hp:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped")
	hp:SetOrientation("VERTICAL")
	hp:Height(40 - powerBarSize)
	hp:Point("TOPLEFT", frame, "TOPLEFT", 1, -1)
	hp:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, frame.isPet and 1 or 1 + powerBarSize)

	if (T.db["raidframes"].colorSmooth) then
		Smoothing:EnableBarAnimation(hp)
	end

	hp.colorClassPet = T.db["raidframes"].colorPet
	hp.colorCharmed	= T.db["raidframes"].colorCharmed
	hp.Override	= UF.UpdateRaidHealth -- override the oUF update

	hp.height = hp:GetHeight()

	frame.Health = hp

	-- Total absorb/shields on target
	local absorb = CreateFrame("StatusBar", nil, frame.Health)
	absorb:SetStatusBarTexture("Interface\\Buttons\\White8x8")
	absorb:SetOrientation("VERTICAL")
	absorb:Height(hp:GetHeight() - powerBarSize)
	absorb:SetStatusBarColor(1.0, 1.0, 1.0, 0.5)
	absorb:SetPoint("LEFT")
	absorb:SetPoint("RIGHT")
	absorb:SetPoint("BOTTOM", frame.Health:GetStatusBarTexture(), "TOP")

	-- Total healing required to increase units health due to a heal absorb debuff/effect
	local absorbHeal = CreateFrame("StatusBar", nil, frame.Health)
	absorbHeal:SetStatusBarTexture("Interface\\Buttons\\White8x8")
	absorbHeal:SetOrientation("VERTICAL")
	absorbHeal:Height(hp:GetHeight() - powerBarSize)
	absorbHeal:SetStatusBarColor(1.0, 0, 0, 0.8)
	absorbHeal:SetPoint("LEFT")
	absorbHeal:SetPoint("RIGHT")
	absorbHeal:SetPoint("BOTTOM", frame.Health:GetStatusBarTexture(), "TOP")

	-- My incoming heals
	local heal = CreateFrame("StatusBar", nil, frame.Health)
	heal:SetStatusBarTexture("Interface\\Buttons\\White8x8")
	heal:SetOrientation("VERTICAL")
	heal:Height(hp:GetHeight() - powerBarSize)
	heal:SetStatusBarColor(0, 1, 0, 0.8)
	heal:SetPoint("LEFT")
	heal:SetPoint("RIGHT")
	heal:SetPoint("BOTTOM", frame.Health:GetStatusBarTexture(), "TOP")

	-- Other incoming heals
	local othersHeal = CreateFrame("StatusBar", nil, frame.Health)
	othersHeal:SetStatusBarTexture("Interface\\Buttons\\White8x8")
	othersHeal:SetOrientation("VERTICAL")
	othersHeal:Height(hp:GetHeight() - powerBarSize)
	othersHeal:SetStatusBarColor(0.5, 0, 1, 0.8)
	othersHeal:SetPoint("LEFT")
	othersHeal:SetPoint("RIGHT")
	othersHeal:SetPoint("BOTTOM", heal:GetStatusBarTexture(), "TOP")

	-- Over-absorb - show a brighter "line"
	local overAbsorb = hp:CreateTexture(nil, "OVERLAY")
	overAbsorb:SetTexture(1.0, 1.0, 1.0, 0.5) -- Always white
	overAbsorb:SetBlendMode("ADD")
	overAbsorb:SetPoint("LEFT")
	overAbsorb:SetPoint("RIGHT")
	overAbsorb:SetPoint("TOP")
	overAbsorb:Height(2)
	overAbsorb:Hide()

	frame.HealPrediction = {
		myBar = heal,
		otherBar = othersHeal,
		absorbBar = absorb,
		healAbsorbBar = absorbHeal,
		overHealAbsorb = overAbsorb,
		maxOverflow = 1.0,
		frequentUpdates = true,
		PostUpdate = UF.PostUpdateHealPrediction
	}

	if (not frame.isPet) then
		-- Power
		local pr, pg, pb = unpack(frame.colors.power["MANA"])

		local pp = CreateFrame("StatusBar", nil, frame)
		pp:SetFrameLevel(baseLevel + 2)
		pp:Height(powerBarSize)
		pp:Point("BOTTOMLEFT", 1, 1)
		pp:Point("BOTTOMRIGHT", -1, 1)
		pp:Point("TOP", hp, "BOTTOM", 0, -1) -- Little offset to make it pretty
		pp:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\statusbarsfill")
		pp:SetStatusBarColor(pr, pg, pb)

		pp.Override = UF.UpdateRaidPower -- override oUF
		frame.Power = pp

		if (T.db["raidframes"].colorSmooth) then
			Smoothing:EnableBarAnimation(pp)
		end
	end

	-- Text1 (used for name)
	local text1 = hp:CreateFontString(nil, "OVERLAY")
	text1:SetFont(T["media"].font, T.db["general"].fontsize3, "NONE")
	text1:Point("CENTER", hp, "CENTER", 0, frame.isPet and 0 or 5)
	text1:SetShadowOffset(1, -1)
	frame:Tag(text1, "[draeraid:name]")
	frame.Text1 = text1

	if (not frame.isPet) then
		-- Text2 (used for general indication)
		local text2 = frame.Health:CreateFontString(nil, "OVERLAY")
		text2:SetFont(T["media"].font, T.db["general"].fontsize3, "NONE")
		text2:Point("CENTER", frame.Health, "CENTER", 0, -6)
		text2:SetShadowOffset(1, -1)
		text2.__locked = nil
		text2.SetJob = SetStatus_Text2
		text2.ClearJob = ClearStatus_Text2
		frame.Text2 = text2
	end

	-- Leader Icon
	local leaderFrame = CreateFrame("Frame", nil, hp)
	leaderFrame:SetSize(15, 15)
	leaderFrame:Point("TOPLEFT", frame, -7, 9)
	leaderFrame:SetFrameLevel(baseLevel + 4)
	local leader = leaderFrame:CreateTexture(nil, "OVERLAY")
	leader:SetAllPoints(leaderFrame)
	leader:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	leader:Hide()
	frame.Leader = leader

	-- Role Icon
	local lfdroleFrame = CreateFrame("Frame", nil, hp)
	lfdroleFrame:SetSize(12, 12)
	lfdroleFrame:Point("BOTTOMRIGHT", frame, 7, -7)
	lfdroleFrame:SetFrameLevel(baseLevel + 4)
	local lfdrole = lfdroleFrame:CreateTexture(nil, "OVERLAY")
	lfdrole:SetAllPoints(lfdroleFrame)
	lfdrole:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
	lfdrole:Hide()
	frame.LFDRole = lfdrole

	-- Raid Icon - unit and target of unit
	local raidIconFrame = CreateFrame("Frame", nil, hp)
	raidIconFrame:SetSize(16, 16)
	raidIconFrame:Point("CENTER", frame, "TOP", 0, 0)
	raidIconFrame:SetFrameLevel(baseLevel + 4)
	local raidIcon = raidIconFrame:CreateTexture(nil, "OVERLAY")
	raidIcon:SetAllPoints(raidIconFrame)
	raidIcon:SetAlpha(0.75)
	raidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	raidIcon:Hide()
	frame.RaidIcon = raidIcon

	-- Readycheck
	local readyCheck = hp:CreateTexture(nil, "OVERLAY")
	readyCheck:Height(22)
	readyCheck:SetWidth(22)
	readyCheck:Point("CENTER", frame, "CENTER", 0, 0)
	frame.ReadyCheck = readyCheck
--[[
	-- Debuffs
	local debuffs = CreateFrame("Frame", nil, hp)
	debuffs:SetFrameLevel(baseLevel + 4)
	debuffs:Point("CENTER", frame, "BOTTOM", 0, -3)
	debuffs.num = 2
	debuffs.size = 21
	debuffs.spacing = 0
	debuffs:Size(debuffs.num * (debuffs.size + debuffs.spacing), debuffs.size + debuffs.spacing)
	debuffs.initialAnchor = "BOTTOMLEFT"
	debuffs.growthX = "RIGHT"
	debuffs.growthY = "UP"
	debuffs.showDebuffType = true

	frame.PartyDebuffs = debuffs
]]
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
