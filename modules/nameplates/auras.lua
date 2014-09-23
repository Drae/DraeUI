--[[


--]]
local T, C, G, P, U, _ = select(2, ...):unpack()

--
local PL = T:GetModule("Nameplates")
local PLA = PL:NewModule("Auras", "AceEvent-3.0")

--[[

--]]
local _G = _G
local GetTime, floor, ceil = GetTime, math.floor, math.ceil

--[[

--]]
local FADE_THRESHOLD = 5 -- auras pulsate when they have less than this many seconds remaining
local listeners = {}

-- combat log events to listen to for fading auras
local auraEvents = {
--	["SPELL_DISPEL"] = true,
	["SPELL_AURA_REMOVED"] = true,
	["SPELL_AURA_BROKEN"] = true,
	["SPELL_AURA_BROKEN_SPELL"] = true,
}

--[[

--]]
local RegisterChanged = function(table, method)
	-- register listener for whitelist updates
	tinsert(listeners, { table, method })
end

local WhitelistChanged = function()
	-- inform listeners of whitelist update
	for _, listener in ipairs(listeners) do
		if (listener[1])[listener[2]] then
			(listener[1])[listener[2]]()
		end
	end
end

local AppendGlobalSpells = function(toList)
	for spellid, _ in pairs(PL.db.auras.whitelist.GlobalSelf) do
		toList[spellid] = true
	end

	return toList
end

local GetDefaultSpells = function(class, onlyClass)
	-- get spell list, ignoring KuiSpellListCustom
	local list = {}

	-- return a copy of the list rather than a reference
	for spellid,_ in pairs(PL.db.auras.whitelist[class]) do
		list[spellid] = true
	end

	if not onlyClass then
		AppendGlobalSpells(list)
	end

	return list
end

local GetImportantSpells = function(class)
	-- get spell list and merge with KuiSpellListCustom if it is set
	local list = GetDefaultSpells(class)
--[[
	if KuiSpellListCustom then
		for _,group in pairs({class,'GlobalSelf'}) do
			if KuiSpellListCustom.Ignore and
			   KuiSpellListCustom.Ignore[group]
			then
				-- remove ignored spells
				for spellid,_ in pairs(KuiSpellListCustom.Ignore[group]) do
					list[spellid] = nil
				end
			end

			if KuiSpellListCustom.Classes and
			   KuiSpellListCustom.Classes[group]
			then
				-- merge custom added spells
				for spellid,_ in pairs(KuiSpellListCustom.Classes[group]) do
					list[spellid] = true
				end
			end
		end
	end
	]]
	return list
end

local ArrangeButtons = function(self)
	local pv, pc
	self.visible = 0

	for k,b in ipairs(self.buttons) do
		if b:IsShown() then
			self.visible = self.visible + 1

			b:ClearAllPoints()

			if pv then
				if (self.visible-1) % (self.frame.trivial and 3 or 5) == 0 then
					-- start of row
					b:SetPoint("BOTTOMLEFT", pc, "TOPLEFT", 0, 1)
					pc = b
				else
					-- subsequent button in a row
					b:SetPoint("LEFT", pv, "RIGHT", 1, 0)
				end
			else
				-- first button
				b:SetPoint("BOTTOMLEFT")
				pc = b
			end

			pv = b
		end
	end

	if self.visible == 0 then
		self:Hide()
	else
		self:Show()
	end
end
-- aura pulsating functions ----------------------------------------------------
local DoPulsateAura
do
	local OnFadeOutFinished = function(button)
		button.fading = nil
		button.faded = true
		DoPulsateAura(button)
	end

	local OnFadeInFinished = function(button)
		button.fading = nil
		button.faded = nil
		DoPulsateAura(button)
	end

	DoPulsateAura = function(button)
		if button.fading or not button.doPulsate then return end
		button.fading = true

		if button.faded then
			PL.frameFade(button, {
				startAlpha = .5,
				timeToFade = .5,
				finishedFunc = OnFadeInFinished
			})
		else
			PL.frameFade(button, {
				mode = "OUT",
				endAlpha = .5,
				timeToFade = .5,
				finishedFunc = OnFadeOutFinished
			})
		end
	end
end

local StopPulsatingAura = function(button)
	PL.frameFadeRemoveFrame(button)
	button.doPulsate = nil
	button.fading = nil
	button.faded = nil
	button:SetAlpha(1)
end
--------------------------------------------------------------------------------
local OnAuraUpdate = function(self, elapsed)
	self.elapsed = self.elapsed - elapsed

	if self.elapsed <= 0 then
		local timeLeft = self.expirationTime - GetTime()

		if PL.db.display.pulsate then
			if self.doPulsate and timeLeft > FADE_THRESHOLD then
				-- reset pulsating status if the time is extended
				StopPulsatingAura(self)
			elseif not self.doPulsate and timeLeft <= FADE_THRESHOLD then
				-- make the aura pulsate
				self.doPulsate = true
				DoPulsateAura(self)
			end
		end

		if PL.db.display.decimal and
		   timeLeft <= 2 and timeLeft > 0
		then
			-- faster updates in the last two seconds
			self.elapsed = .05
		else
			self.elapsed = .5
		end
	end
end

local OnAuraShow = function(self)
	local parent = self:GetParent()
	parent:ArrangeButtons()
end

local OnAuraHide = function(self)
	local parent = self:GetParent()

	if parent.spellIds[self.spellId] == self then
		parent.spellIds[self.spellId] = nil
	end

	self.spellId = nil

	-- reset button pulsating
	StopPulsatingAura(self)

	parent:ArrangeButtons()
end

local GetAuraButton = function(self, spellId, icon, count, duration, expirationTime)
	local button

	if self.spellIds[spellId] then
		-- use this spell's current button...
		button = self.spellIds[spellId]
	elseif self.visible ~= #self.buttons then
		-- .. or reuse a hidden button...
		for k, b in pairs(self.buttons) do
			if not b:IsShown() then
				button = b
				break
			end
		end
	end

	if not button then
		button = CreateFrame("Frame", nil, self)
		button:Hide()

		local border = CreateFrame("Frame", nil, button)
		border:SetPoint("TOPLEFT", button, -6, 6)
		border:SetPoint("BOTTOMRIGHT", button, 6, -6)
		border:SetFrameStrata("BACKGROUND")
		border:SetBackdrop {
			edgeFile = "Interface\\AddOns\\draeUI\\media\\textures\\glowtex",
			tile = false,
			edgeSize = 6
		}
		border:SetBackdropBorderColor(0, 0, 0, 0.5)
		button.border = border

		local icon = button:CreateTexture(nil, "BACKGROUND")
		icon:SetTexCoord(.07, .93, .07, .93)
		icon:SetPoint("TOPLEFT", button, "TOPLEFT", -0.7, 0.93)
		icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0.7, -0.93)
		button.icon = icon

		local overlay = button:CreateTexture(nil, "OVERLAY")
		button.overlay = overlay

		local cd = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
		cd:SetReverse(true)
		cd:SetAllPoints(button)
		cd:SetHideCountdownNumbers(true)
		button.cd = cd

		local borderFrame = T.CreateBorder(button, "smaller")
		button.borderFrame = borderFrame

		local count = borderFrame:CreateFontString(nil)
		count:SetFont(T.db["media"].fontOther, T.db["media"].fontsize3, "OUTLINE")
		count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 7, -6)
		button.count = count

		tinsert(self.buttons, button)

		button:SetScript("OnHide", OnAuraHide)
		button:SetScript("OnShow", OnAuraShow)
	end

	button:SetSize(PL.db.auraiconsize, PL.db.auraiconsize)
	button.icon:SetTexture(icon)

	if count > 1 and not self.frame.trivial then
		button.count:SetText(count)
		button.count:Show()
	else
		button.count:Hide()
	end

	if (duration > 0) then
		button.cd:SetCooldown(expirationTime - duration, duration)
	else
		button.cd:SetCooldown(0, -1)
	end

	button.duration = duration
	button.expirationTime = expirationTime
	button.spellId = spellId
	button.elapsed = 0

	self.spellIds[spellId] = button

	return button
end

--[[

--]]
function PLA:Create(msg, frame)
	frame.auras = CreateFrame("Frame", nil, frame)
	frame.auras.frame = frame

	frame.auras:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", -3, 0)
	frame.auras:SetHeight(50)
	frame.auras:Hide()

	frame.auras.visible = 0
	frame.auras.buttons = {}
	frame.auras.spellIds = {}
	frame.auras.GetAuraButton = GetAuraButton
	frame.auras.ArrangeButtons = ArrangeButtons

	frame.auras:SetScript("OnHide", function(self)
		for k, b in pairs(self.buttons) do
			b:Hide()
		end

		self.visible = 0
	end)
end

function PLA:Show(msg, frame)
	-- set vertical position of the container frame
	if frame.trivial then
		frame.auras:SetPoint("BOTTOMLEFT", frame.hp, "TOPLEFT",
			0, 8)
	else
		frame.auras:SetPoint("BOTTOMLEFT", frame.hp, "TOPLEFT",
			0, 8)
	end
end

function PLA:Hide(msg, frame)
	if frame.auras then
		frame.auras:Hide()
	end
end

-------------------------------------------------------------- event handlers --
function PLA:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local castTime, event, _, guid, name, _, _, targetGUID, targetName = ...
	if not guid then return end
	if not auraEvents[event] then return end
	if guid ~= UnitGUID("player") then return end

	-- fetch the subject"s nameplate
	local f = PL:GetNameplate(targetGUID, targetName)
	if not f or not f.auras then return end

	local spId = select(12, ...)

	if f.auras.spellIds[spId] then
		f.auras.spellIds[spId]:Hide()
	end
end

function PLA:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA("UNIT_AURA", "target")
end

function PLA:UPDATE_MOUSEOVER_UNIT()
	self:UNIT_AURA("UNIT_AURA", "mouseover")
end

function PLA:UNIT_AURA(event, unit)
	-- select the unit"s nameplate
	local frame = PL:GetNameplate(UnitGUID(unit), nil)
	if not frame or not frame.auras then return end
	if frame.trivial and not PL.db.showtrivial then return end

	local filter = "PLAYER "
	if UnitIsFriend(unit, "player") then
		filter = filter.."HELPFUL"
	else
		filter = filter.."HARMFUL"
	end

	for i = 0, 40 do
		local name, _, icon, count, _, duration, expirationTime, _, _, _, spellId = UnitAura(unit, i, filter)
		name = name and strlower(name) or nil

		if (name and
				(not PL.db.behav.useWhitelist or (whitelist[spellId] or whitelist[name])) and
				(duration >= PL.db.display.lengthMin) and
				(PL.db.display.lengthMax == -1 or (duration > 0 and duration <= PL.db.display.lengthMax))) then
			local button = frame.auras:GetAuraButton(spellId, icon, count, duration, expirationTime)
			frame.auras:Show()
			button:Show()
			button.used = true
		end
	end

	for _,button in pairs(frame.auras.buttons) do
		-- hide buttons that weren't used this update
		if not button.used then
			button:Hide()
		end

		button.used = nil
	end
end

function PLA:WhitelistChanged()
	-- update spell whitelist
	whitelist = GetImportantSpells(T.playerClass)
end

function PLA:OnInitialize()
	self:WhitelistChanged()
	RegisterChanged(self, "WhitelistChanged")
end

function PLA:OnEnable()
	self:RegisterMessage("DraeUI_Nameplates_PostCreate", "Create")
	self:RegisterMessage("DraeUI_Nameplates_PostShow", "Show")
	self:RegisterMessage("DraeUI_Nameplates_PostHide", "Hide")
	self:RegisterMessage("DraeUI_Nameplates_PostTarget", "PLAYER_TARGET_CHANGED")

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	local _, frame
	for _, frame in pairs(PL.frameList) do
		if not frame.auras then
			self:Create(nil, frame.draePlate)
		end
	end
end

function PLA:OnDisable()
	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("PLAYER_TARGET_CHANGED")
	self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	local _, frame
	for _, frame in pairs(PL.frameList) do
		self:Hide(nil, frame.draePlate)
	end
end
