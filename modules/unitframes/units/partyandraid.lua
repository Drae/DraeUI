--[[


--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")
local Roster = DraeUI:GetModule("Roster")

local Smoothing = LibStub("LibCutawaySmooth-1.0", true)
local CG = LibStub("LibCustomGlow-1.0", true)

--
local CreateFrame = CreateFrame
local tsort, tinsert, unpack, wipe = table.sort, table.insert, unpack, wipe

-- Default indicator positions
local indicators = {
	-- Icons
	["CENTERICON"] 		= {type = "icon", width = 25, height = 25, at = "CENTER", 		to = "CENTER", 		offsetX = 0,  offsetY = 0, frame = "parent"},
	["BOTTOMICON"] 		= {type = "icon", width = 18, height = 18, at = "CENTER", 		to = "BOTTOM", 		offsetX = 0,  offsetY = -3, frame = "parent"},
	["TOPICON"] 		= {type = "icon", width = 18, height = 18, at = "CENTER", 		to = "TOP", 		offsetX = 0,  offsetY = 3, frame = "parent"},

	-- Colour only indicators
	["TOP"] 			= {type = "color", width = 8, height = 8,  at = "TOP", 			to = "TOP", 		offsetX = 0,  offsetY = 1},
	["TOPL"] 			= {type = "color", width = 8, height = 8,  at = "TOP", 			to = "TOP", 		offsetX = 7,  offsetY = 1},
	["TOPR"] 			= {type = "color", width = 8, height = 8,  at = "TOP", 			to = "TOP", 		offsetX = -7, offsetY = 1},

	["TOPLEFT"] 		= {type = "color", width = 8, height = 8,  at = "TOPLEFT", 		to = "TOPLEFT", 	offsetX = -1,  offsetY = 1},
	["TOPLEFTB"] 		= {type = "color", width = 8, height = 8,  at = "TOPLEFT", 		to = "TOPLEFT", 	offsetX = -1,  offsetY = -7},
	["TOPLEFTR"] 		= {type = "color", width = 8, height = 8,  at = "TOPLEFT", 		to = "TOPLEFT", 	offsetX = 7,  offsetY = 1},

	["TOPRIGHT"] 		= {type = "color", width = 8, height = 8,  at = "TOPRIGHT", 	to = "TOPRIGHT", 	offsetX = 1,  offsetY = 1},
	["TOPRIGHTB"] 		= {type = "color", width = 8, height = 8,  at = "TOPRIGHT", 	to = "TOPRIGHT", 	offsetX = 1,  offsetY = -7},
	["TOPRIGHTL"] 		= {type = "color", width = 8, height = 8,  at = "TOPRIGHT", 	to = "TOPRIGHT", 	offsetX = -7, offsetY = 1},

	["BOTTOM"] 			= {type = "color", width = 8, height = 8,  at = "BOTTOM", 		to = "BOTTOM", 		offsetX = 0,  offsetY = -1},
	["BOTTOML"] 		= {type = "color", width = 8, height = 8,  at = "BOTTOM", 		to = "BOTTOM", 		offsetX = -7, offsetY = -1},
	["BOTTOMR"] 		= {type = "color", width = 8, height = 8,  at = "BOTTOM", 		to = "BOTTOM", 		offsetX = 7,  offsetY = -1},

	["BOTTOMLEFT"] 		= {type = "color", width = 8, height = 8,  at = "BOTTOMLEFT",	to = "BOTTOMLEFT", 	offsetX = -1, offsetY = -1},
	["BOTTOMLEFTT"] 	= {type = "color", width = 8, height = 8,  at = "BOTTOMLEFT", 	to = "BOTTOMLEFT", 	offsetX = -1, offsetY = 7},
	["BOTTOMLEFTR"] 	= {type = "color", width = 8, height = 8,  at = "BOTTOMLEFT", 	to = "BOTTOMLEFT", 	offsetX = 7,  offsetY = -1},

	["BOTTOMRIGHT"] 	= {type = "color", width = 6, height = 6,  at = "BOTTOMRIGHT", 	to = "BOTTOMRIGHT", offsetX = 1,  offsetY = -1},
	["BOTTOMRIGHTT"] 	= {type = "color", width = 6, height = 6,  at = "BOTTOMRIGHT", 	to = "BOTTOMRIGHT", offsetX = 1,  offsetY = 5},
	["BOTTOMRIGHTL"] 	= {type = "color", width = 6, height = 6,  at = "BOTTOMRIGHT", 	to = "BOTTOMRIGHT", offsetX = -5, offsetY = -1},
	["BOTTOMRIGHTTL"] 	= {type = "color", width = 6, height = 6,  at = "BOTTOMRIGHT", 	to = "BOTTOMRIGHT", offsetX = -5, offsetY = -5},

	["LEFT"] 			= {type = "color", width = 8, height = 8,  at = "LEFT", 		to = "LEFT", 		offsetX = -1, offsetY = 0},
	["LEFTT"] 			= {type = "color", width = 8, height = 8,  at = "LEFT", 		to = "LEFT", 		offsetX = -1, offsetY = -7},
	["LEFTB"] 			= {type = "color", width = 8, height = 8,  at = "LEFT", 		to = "LEFT", 		offsetX = -1, offsetY = 7},

	["RIGHT"] 			= {type = "color", width = 8, height = 8,  at = "RIGHT", 		to = "RIGHT", 		offsetX = 1,  offsetY = 0},
	["RIGHTT"] 			= {type = "color", width = 8, height = 8,  at = "RIGHT", 		to = "RIGHT", 		offsetX = 1,  offsetY = 7},
	["RIGHTB"] 			= {type = "color", width = 8, height = 8,  at = "RIGHT", 		to = "RIGHT", 		offsetX = 1,  offsetY = -7},

	-- Additional indicators are:
	-- BORDER
	-- TEXT2
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
local SetStatus_Statusbar = function(ind, data)
end

local ClearStatus_Statusbar = function(ind)
end

local SetStatus_Indicator = function(ind, data)
	if (ind.cd and data.duration > 0) then
		ind.cd:SetCooldown(data.start, data.duration)
		ind.cd:Show()
	else
		ind.cd:Hide()
	end

	if (data.notMine) then
		ind.notMine:Show()
	else
		ind.notMine:Hide()
	end

	ind:SetBackdropColor(data.color[1] or 0, data.color[2] or 0, data.color[3] or 0, data.color[4] or 1.0)

	if (data.pulse and not ind.__Pulse:IsPlaying()) then
		ind.__Pulse:Play()
	elseif (not data.pulse and ind.__Pulse:IsPlaying()) then
		ind.__Pulse:Stop()
	end

	if (data.flash and not ind.__Flash:IsPlaying()) then
		ind.__Flash:Play()
	elseif (not data.flash and ind.__Flash:IsPlaying()) then
		ind.__Flash:Stop()
	end
end

local SetStatus_Icon
do
	local color_glow = {1.0, 1.0, 1.0}

	SetStatus_Icon = function(ind, data)
		if (ind.cd and data.duration > 0) then
			ind.cd:SetCooldown(data.start, data.duration)
			ind.cd:Show()
		else
			ind.cd:Hide()
		end

		ind:SetBackdropColor(data.color[1] or 0, data.color[2] or 0, data.color[3] or 0, data.color[4] or 1.0)

		ind.icon:SetTexture(data.texture)

		ind.count:SetText(data.stack > 1 and data.stack or "")

		if (data.pulse and not ind.__Pulse:IsPlaying()) then
			ind.__Pulse:Play()
		elseif (not data.pulse and ind.__Pulse:IsPlaying()) then
			ind.__Pulse:Stop()
		end

		if (data.flash and not ind.__Flash:IsPlaying()) then
			ind.__Flash:Play()
		elseif (not data.flash and ind.__Flash:IsPlaying()) then
			ind.__Flash:Stop()
		end

		if (data.glow) then
			-- frame, color (rgba), number of lines, frequency (-ve to rev), length, thickness, xoffset, yoffset, border, key (multiple glows)
			CG.PixelGlow_Start(ind.__Glow, color_glow, 12, nil, nil, 2, 3, 3)
		else
			CG.PixelGlow_Stop(ind.__Glow)
		end
	end
end

local SetStatus_BorderColor = function(ind, data)
	if (data.color and data.color[1]) then
		ind:SetBackdropBorderColor(data.color[1], data.color[2], data.color[3], data.color[4] or 1.0)
	end
end

local ClearStatus_BorderColor = function(ind)
	ind:SetBackdropBorderColor(0, 0, 0, 0)
end

local SetStatus_Text = function(ind, data)
	if (data.color and data.color[1]) then
		ind:SetTextColor(data.color[1], data.color[2], data.color[3], data.color[4] or 1.0)
	end

	if (data.text) then
		ind:SetText(data.text)
	end
end

local ClearStatus_Text = function(ind)
	ind:SetText("")
end

--[[
		Create the indicator frames
--]]
local CreateIndicator
do
	local backdrop_insets = {left = 1, right = 1, top = 1, bottom = 1}

	CreateIndicator = function(frame, indicator)
		local ind = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")

		if (not indicators[indicator]) then return end

		if (indicators[indicator].type == "color") then
			ind:SetSize(indicators[indicator].width, indicators[indicator].height)

			ind:SetBackdrop({
				bgFile = "Interface\\BUTTONS\\WHITE8X8",
				tile = true,
				tileSize = 9,
				edgeFile = "Interface\\BUTTONS\\WHITE8X8",
				edgeSize = 1.5,
				insets = backdrop_insets
			})

			ind.SetJob = SetStatus_Indicator
		elseif (indicators[indicator].type == "icon") then
			ind:SetSize(indicators[indicator].width, indicators[indicator].height)

			ind:SetBackdrop({
				bgFile = "Interface\\BUTTONS\\WHITE8X8",
				tile = true,
				tileSize = 9,
				edgeSize = 2,
			})

			local t = ind:CreateTexture(nil, "OVERLAY")
			t:SetTexCoord(unpack(DraeUI.config["general"].texcoords))
			t:SetPoint("CENTER", ind, "CENTER")
			t:SetSize(indicators[indicator].width - 2, indicators[indicator].height - 2)
			t:SetColorTexture(0, 0, 0, 1)

			ind.__Glow = CreateFrame("Frame", nil, ind, BackdropTemplateMixin and "BackdropTemplate")
			ind.__Glow:SetAllPoints(ind)
			ind.__Glow:SetSize(ind:GetSize())

			ind.icon = t
			ind.SetJob = SetStatus_Icon
		end

		-- Pulsing
		local pulse = ind:CreateAnimationGroup()
		pulse:SetLooping("BOUNCE")

		local grow = pulse:CreateAnimation("Scale")
		grow:SetScale(1.1, 1.1)
		grow:SetOrigin("CENTER", 0, 0)
		grow:SetDuration(0.33)
		grow:SetOrder(0)

		ind.__Pulse = pulse

		local flash = ind:CreateAnimationGroup()
		flash:SetLooping("BOUNCE")

		local alpha = flash:CreateAnimation("Alpha")
		alpha:SetFromAlpha(1)
		alpha:SetToAlpha(0.25)
		alpha:SetDuration(0.33)
		alpha:SetOrder(0)

		ind.__Flash = flash

		ind:SetScript("OnHide",	function()
			if (ind.__Pulse:IsPlaying()) then
				ind.__Pulse:Stop()
			end

			if (ind.__Flash:IsPlaying()) then
				ind.__Flash:Stop()
			end

			if (ind.__Glow) then
				CG.PixelGlow_Stop(ind.__Glow)
			end
		end)

		local relFrame = indicators[indicator].frame == "parent" and frame or frame.Health

		ind:ClearAllPoints()
		ind:SetFrameLevel(frame:GetFrameLevel() + 7)
		ind:SetPoint(indicators[indicator].at, relFrame, indicators[indicator].to, indicators[indicator].offsetX, indicators[indicator].offsetY)
		ind:SetBackdropBorderColor(0, 0, 0, 1)
		ind:SetBackdropColor(0, 0, 0, 1)
		ind:Hide()

		-- A little black "dot" which says "this indicator didn't originate from me"
		if (indicators[indicator].type ~= "icon") then
			local notMine = ind:CreateTexture(nil, "ARTWORK")
			notMine:SetPoint("BOTTOMLEFT", ind, "BOTTOMLEFT", 0, 0)
			notMine:SetSize(indicators[indicator].width / 2, indicators[indicator].height / 2)
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
			count:SetFont(DraeUI["media"].font, DraeUI.config["general"].fontsize2, "OUTLINE")
			count:SetPoint("BOTTOMRIGHT", ind, "BOTTOMRIGHT", 5, -4)
			count:SetTextColor(1, 1, 1)
			count:SetShadowOffset(1, -1)

			ind.count = count
		end

		frame[indicator] = ind
	end
end

--[[

--]]
local SetIndicator = function(frame, indicator, status)
	if (not frame[indicator]) then
		frame:CreateIndicator(indicator)
	end

	if (frame[indicator]) then
		if (frame ~= frame[indicator]) then
			frame[indicator]:Show()
		end

		if (frame[indicator].SetJob) then
			frame[indicator]:SetJob(status)
		end
	end
end

local ClearIndicator = function(frame, indicator)
	if (frame[indicator]) then
		if (frame[indicator].ClearJob) then
			frame[indicator]:ClearJob()
		elseif (frame ~= frame[indicator]) then
			frame[indicator]:Hide()
		end
	end
end

local GainedStatus = function(frame, status, color, texture, text, value, max_value, start, duration, stack, not_mine, pulse, flash, glow)
	-- Set some param defaults
	color = type(color) ~= "table" and {nil, nil, nil, nil} or color
	texture = texture == nil and "" or texture
	text = text == nil and "" or text
	value = value == nil and 0 or value
	max_value = max_value == nil and 0 or max_value
	start = start == nil and 0 or start
	duration = duration == nil and 0 or duration
	stack = stack == nil and 0 or stack

	local cache = frame.__cache_statuses

	if (cache[status] and
		cache[status].state == true and
		cache[status].color == color and
		cache[status].texture == texture and
		cache[status].text == text and
		cache[status].value == value and
		cache[status].maxValue == max_value and
		cache[status].start == start and
		cache[status].duration == duration and
		cache[status].stack == stack and
		cache[status].notMine == not_mine and
		cache[status].pulse == pulse and
		cache[status].flash == flash and
		cache[status].glow == glow) then
		return
	end

	if (not cache[status]) then
		cache[status] = {}
	end

	-- update cache
	cache[status].state = true
	cache[status].color = color
	cache[status].texture = texture
	cache[status].text = text
	cache[status].value = value
	cache[status].maxValue = max_value
	cache[status].start = start
	cache[status].duration = duration
	cache[status].stack = stack
	cache[status].notMine = not_mine
	cache[status].pulse = pulse
	cache[status].flash = flash
	cache[status].glow = glow

	frame:UpdateIndicator(status)
end

local LostStatus = function(frame, status)
	local status_from_cache = frame.__cache_statuses[status]

	-- if status isn't cached or is no longer true don't update the indicator
	if (not status_from_cache or status_from_cache.state == false) then return end

	-- Set the status as inactive
	status_from_cache.state = false

	-- See if the indicator(s) for this status need updating
	frame:UpdateIndicator(status)
end

local UpdateIndicator
do
	local status_to_indicator, top_status, current_top_status

	-- Invert the statusmap table so we have a list of statuses and the indicators
	-- to which they map
	local InvertStatusMap = function()
		local inv = {}

		for indicator, statuses in pairs(DraeUI.class[DraeUI.playerClass].statusmap) do
			for status, priority in pairs(statuses) do
				if (not inv[status]) then
					inv[status] = {}
				end

				inv[status][indicator] = priority
			end
		end

		return inv
	end

	-- Sort priority | state (true/false) > priority > start_time
	local sort_statuses = function(t1, t2)
		if (t1[1].state == t2[1].state) then
			return (t1.priority == t2.priority) and t1[1].start > t2[1].start or t1.priority > t2.priority
		end

		return t1[1].state and not t2[1].state
	end

	UpdateIndicator = function(frame, status)
		local indicator_cache = frame.__cache_indicators
		local status_cache = frame.__cache_statuses

		-- Get the list of indicators displaying this status
		if (not status_to_indicator) then
			status_to_indicator = InvertStatusMap()
		end

		if (not status_to_indicator[status]) then return end

		-- Loop through the indicators for this status
		for indicator, pr in pairs(status_to_indicator[status]) do
			-- Setup indicator cache for this indicator
			if (not indicator_cache[indicator]) then
				indicator_cache[indicator] = {}

				for st, pr in pairs(DraeUI.class[DraeUI.playerClass].statusmap[indicator]) do
					tinsert(indicator_cache[indicator], { status = st, priority = pr, status_cache[st] })
				end
			end

			current_top_status = indicator_cache[indicator][1].status

			-- Only sort if there is more than one entry - waste of memory/cycles otherwise
			if (#indicator_cache[indicator] > 1) then
				tsort(indicator_cache[indicator], sort_statuses)
			end

			top_status = indicator_cache[indicator][1]

			if (top_status and top_status[1].state) then
				if (top_status.status == status or top_status.status ~= current_top_status) then
					frame:SetIndicator(indicator, status_cache[top_status.status])
				end
			else
				frame:ClearIndicator(indicator)
			end
		end
	end
end

--[[

	frame.__cache_indicators = {
		["IND1"] = {
			{priority = X, status = "status1", >(__cache_statuses)>{state = true, start = Y, ...},
			{priority = Y, status = "status2", >(__cache_statuses)>{state = true, start = Y, ...},
			...
		},
		["IND2"] = {
			...
		},
		...
	}

	frame.__cache_statuses = {
		["status_1"] = {state = true, start = 0, ...},
		["status_2"] = {state = true, start = 0, ...},
		...
	}

--]]

--[[
		Let"s style the unit frame
--]]
local StyleDrae_Raid
do
	local range = {insideAlpha = 1.0, outsideAlpha = 0.33}
	local border_insets = {left = 2, right = 2, top = 2, bottom = 2}

	-- Default basis status
	local mt_statuses = {__index = function(t, k)
		rawset(t, k, { state = false, start = 0 })
		return rawget(t, k)
	end}

	StyleDrae_Raid = function(frame, unit)
		-- Store some data related to this frame, associated unit, etc.
		frame.PreUpdate = Roster.UpdateRoster

		-- "Kludge" to limit statuses associated with the raid frames acting on
		-- unit frames with the same name (e.g. when in a party)
		frame.__is_grid = true
		frame.__is_pet = unit:match("raidpet") and true or false

		-- Reuse and wipe the indicator and status cache tables if they exist,
		-- else assign new ones
		if (type(frame.__cache_indicators) ~= "table") then
			frame.__cache_indicators = {}
		else
			wipe(frame.__cache_indicators)
		end

		if (not frame.__cache_statuses) then
			frame.__cache_statuses = setmetatable({}, mt_statuses)
		else
			wipe(frame.__cache_statuses)
		end

		frame:SetScript("OnEnter", FrameOnEnter)
		frame:SetScript("OnLeave", FrameOnLeave)

		frame.SpellRange = range

		local baseLevel = frame:GetFrameLevel()

		-- Frame edge glow
		local border = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
		border:SetPoint("TOPLEFT", frame, -12, 12)
		border:SetPoint("BOTTOMRIGHT", frame, 12, -12)
		border:SetFrameStrata("BACKGROUND")
		border:SetBackdrop {
			edgeFile = "Interface\\Addons\\DraeUI\\media\\textures\\glowtex",
			edgeSize = 14,
			insets = border_insets
		}
		border:SetBackdropColor(0, 0, 0, 0)
		border:SetBackdropBorderColor(0, 0, 0, 0)
		border.SetJob = SetStatus_BorderColor
		border.ClearJob = ClearStatus_BorderColor
		frame.BORDER = border

		-- Frame background
		local bg = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
		bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -3.5, 3)
		bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 3, -3)
		bg:SetBackdrop({bgFile = "Interface\\Buttons\\White8x8"})
		bg:SetBackdropColor(0, 0, 0, 1)
		frame.bg = bg

		-- Frame highlight
		local highlight = border:CreateTexture(nil, "BACKGROUND", nil, 3)
		highlight:SetPoint("TOPLEFT", frame, -8.5, 7)
		highlight:SetPoint("BOTTOMRIGHT", frame, 8.5, -7)
		highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		highlight:SetTexCoord(0, 1, 0.23, 0.77)
		highlight:SetBlendMode("ADD")
		highlight:Hide()
		frame.Highlight = highlight

		-- Health
		local hp = CreateFrame("StatusBar", nil, frame)
		hp:SetFrameLevel(baseLevel + 2)
		hp:SetStatusBarTexture(DraeUI.media.statusbar_raid)
		hp:SetOrientation("VERTICAL")
		hp:SetPoint("TOPLEFT", frame, "TOPLEFT")
		hp:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")

		local hpbg = hp:CreateTexture(nil, 'BACKGROUND')
		hpbg:SetAllPoints(hp)
		hpbg:SetTexture(DraeUI.media.statusbar_raid)
		hpbg.multiplier = 0.25
		hp.bg = hpbg

		if (DraeUI.config["raidframes"].colorSmooth) then
			Smoothing:EnableBarAnimation(hp)
		end

		hp.colorClassPet = DraeUI.config["raidframes"].colorPet
		hp.colorCharmed = DraeUI.config["raidframes"].colorCharmed
		hp.Override = UF.UpdateRaidHealth -- override the oUF update
		frame.Health = hp

		-- Power
		if (not frame.__is_pet) then
			local pp = CreateFrame("StatusBar", nil, frame)
			pp:SetFrameLevel(baseLevel + 2)
			pp:SetHeight(DraeUI.config["raidframes"].powerHeight)
			pp:SetPoint("BOTTOMLEFT")
			pp:SetPoint("BOTTOMRIGHT")
			pp:SetPoint("TOP", hp, "BOTTOM", 0, -1.5) -- Little offset to make it pretty
			pp:SetStatusBarTexture(DraeUI.media.statusbar)
			pp:Hide()

			local ppbg = pp:CreateTexture(nil, 'BACKGROUND')
			ppbg:SetAllPoints(pp)
			ppbg:SetTexture(DraeUI.media.statusbar_raid_power)
			ppbg.multiplier = 0.25
			pp.bg = ppbg

			if (DraeUI.config["raidframes"].colorSmooth) then
				Smoothing:EnableBarAnimation(pp)
			end

			pp.__bar_height = DraeUI.config["raidframes"].powerHeight
			pp.__bar_texture = DraeUI.media.statusbar
			frame.RaidPower = pp
		end

		-- My incoming heals
		local myBar = CreateFrame("StatusBar", nil, hp)
		myBar:SetStatusBarTexture(DraeUI.media.statusbar_raid)
		myBar:SetOrientation("VERTICAL")
		myBar:SetStatusBarColor(0, 1, 0, 0.6)
		myBar:SetPoint("LEFT")
		myBar:SetPoint("RIGHT")
		myBar:SetPoint("BOTTOM", hp:GetStatusBarTexture(), "TOP")

		-- Other incoming heals
		local otherBar = CreateFrame("StatusBar", nil, hp)
		otherBar:SetStatusBarTexture(DraeUI.media.statusbar_raid)
		otherBar:SetOrientation("VERTICAL")
		otherBar:SetStatusBarColor(0.5, 0, 1, 0.6)
		otherBar:SetPoint("LEFT")
		otherBar:SetPoint("RIGHT")
		otherBar:SetPoint("BOTTOM", myBar:GetStatusBarTexture(), "TOP")

		-- Total absorb/shields on target
		local absorbBar = CreateFrame("StatusBar", nil, hp)
		absorbBar:SetStatusBarTexture(DraeUI.media.statusbar_raid)
		absorbBar:SetOrientation("VERTICAL")
		absorbBar:SetStatusBarColor(1.0, 1.0, 1.0, 0.33)
		absorbBar:SetPoint("LEFT")
		absorbBar:SetPoint("RIGHT")
		absorbBar:SetPoint("BOTTOM", otherBar:GetStatusBarTexture(), "TOP")

		-- Total healing required to increase units health due to a heal absorb debuff/effect
		local healAbsorbBar = CreateFrame("StatusBar", nil, hp)
		healAbsorbBar:SetStatusBarTexture(DraeUI.media.statusbar_raid)
		healAbsorbBar:SetOrientation("VERTICAL")
		healAbsorbBar:SetReverseFill(true)
		healAbsorbBar:SetStatusBarColor(1.0, 0, 0, 0.5)
		healAbsorbBar:SetPoint("LEFT")
		healAbsorbBar:SetPoint("RIGHT")
		healAbsorbBar:SetPoint("TOP", hp:GetStatusBarTexture(), "TOP")

		-- Damage (shields/absorbs) greater than health
		local overAbsorb = hp:CreateTexture(nil, "OVERLAY")
		overAbsorb:SetTexture("Interface\\Buttons\\White8x8")
		overAbsorb:SetVertexColor(1, 1, 1, 0.5) -- Always white
		overAbsorb:SetBlendMode("ADD")
		overAbsorb:SetPoint("LEFT")
		overAbsorb:SetPoint("RIGHT")
		overAbsorb:SetPoint("TOP")
		overAbsorb:SetHeight(3)
		overAbsorb:Hide()

		-- Healing absorb greater than health
		local overHealAbsorb = hp:CreateTexture(nil, "OVERLAY")
		overHealAbsorb:SetTexture("Interface\\Buttons\\White8x8")
		overHealAbsorb:SetVertexColor(1.0, 0, 0, 0.5)
		overHealAbsorb:SetBlendMode("ADD")
		overHealAbsorb:SetPoint("LEFT")
		overHealAbsorb:SetPoint("RIGHT")
		overHealAbsorb:SetPoint("BOTTOM")
		overHealAbsorb:SetHeight(3)
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

		-- Text1 (used for name)
		local text1 = hp:CreateFontString(nil, "OVERLAY")
		text1:SetFont(DraeUI["media"].font, DraeUI.config["general"].fontsize3, "NONE")
		text1:SetPoint("CENTER", hp, "CENTER", 0, frame.__is_pet and 0 or 7)
		text1:SetShadowOffset(1, -1)
		frame:Tag(text1, "[draeraid:name]")
		frame.Text1 = text1

		if (not frame.__is_pet) then
			-- Text2 (used for general indication)
			local text2 = hp:CreateFontString(nil, "OVERLAY")
			text2:SetFont(DraeUI["media"].font, DraeUI.config["general"].fontsize3, "NONE")
			text2:SetPoint("CENTER", hp, "CENTER", 0, -7)
			text2:SetShadowOffset(1, -1)
			text2.SetJob = SetStatus_Text
			text2.ClearJob = ClearStatus_Text
			frame.TEXT2 = text2
		end

		-- Leader Icon
		local leaderFrame = CreateFrame("Frame", nil, hp)
		leaderFrame:SetSize(14, 14)
		leaderFrame:SetPoint("TOPLEFT", frame, -8, 9)
		leaderFrame:SetFrameLevel(baseLevel + 4)
		local leader = leaderFrame:CreateTexture(nil, "OVERLAY")
		leader:SetAllPoints(leaderFrame)
		leader:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
		leader:Hide()
		frame.LeaderIndicator = leader

		-- Role Icon
		local lfdroleFrame = CreateFrame("Frame", nil, hp)
		lfdroleFrame:SetSize(12, 12)
		lfdroleFrame:SetPoint("BOTTOMRIGHT", frame, 8, -8)
		lfdroleFrame:SetFrameLevel(baseLevel + 4)
		local lfdrole = lfdroleFrame:CreateTexture(nil, "OVERLAY")
		lfdrole:SetAllPoints(lfdroleFrame)
		lfdrole:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
		lfdrole:Hide()
		lfdrole.Override = UF.OverrideGroupRoleIndicator
		frame.GroupRoleIndicator = lfdrole

		-- Raid Icon - unit and target of unit
		local raidIconFrame = CreateFrame("Frame", nil, hp)
		raidIconFrame:SetSize(18, 18)
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
		readyCheck:SetSize(26, 26)
		readyCheck:SetPoint("CENTER", frame, "CENTER", 0, 0)
		frame.ReadyCheckIndicator = readyCheck

		--[[
			Update unit colouration
		--]]
		frame:RegisterEvent("UNIT_CONNECTION", UF.UpdateRaidHealth)
		frame:RegisterEvent("UNIT_FLAGS", UF.UpdateRaidHealth) -- Mind control, fear, taxi, etc.
		frame:RegisterEvent("PLAYER_FLAGS_CHANGED", UF.UpdateRaidHealth) -- AFK status changes
		frame:RegisterEvent("PLAYER_CONTROL_LOST", UF.UpdateRaidHealth, true) -- Mind control, fear, taxi, etc.

		--[[
				Indicator related
		--]]
		frame.CreateIndicator = CreateIndicator
		frame.SetIndicator = SetIndicator
		frame.ClearIndicator = ClearIndicator
		frame.UpdateIndicator = UpdateIndicator
		frame.GainedStatus = GainedStatus
		frame.LostStatus = LostStatus
	end
end

oUF:RegisterStyle("DraeRaid", StyleDrae_Raid)
