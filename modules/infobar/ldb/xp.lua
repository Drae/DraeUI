--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:GetModule("Infobar")
local XP = IB:NewModule("XP", "AceEvent-3.0")

local Smoothing = LibStub("LibCutawaySmooth-1.0", true)

--[[

]]
local xpFrame
local restingIcon = "|TInterface\\AddOns\\draeUI\\media\\textures\\resting-icon:13:13:0:0|t"

--[[

]]
XP.UpdateReputation = function(self)
	local name, reaction, min, max, value, faction = GetWatchedFactionInfo()
	local friend, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(faction)
	local numFactions = GetNumFactions()

	if (not name) then
		self.button["Text"]:SetText("")
		self.button.bar:Hide()

		return
	end

	local pct = (value - min) / (max - min) * 100
	local affix = "[" ..  (friend and friendTextLevel or _G["FACTION_STANDING_LABEL" .. reaction]) .. "]"

	local r1, g1, b1 = T.ColorGradient(pct / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	self.button["Text"]:SetFormattedText("%s: |cff%02x%02x%02x%d|r|cffffffff%%|r %s", name, r1 * 255, g1 * 255, b1 * 255, pct, affix)

	self.button.bar:SetMinMaxValues(min, max)
	self.button.bar:SetValue(value)
	self.button.bar:Show()

	self.button:SetPluginSize()
end

do
	local OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -(IB.infoBar:GetHeight()))

		GameTooltip:ClearLines()

		local name, reaction, min, max, value, faction = GetWatchedFactionInfo()
		local friend, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(faction)

		if name then
			GameTooltip:AddLine(name)
			GameTooltip:AddLine(" ")

			GameTooltip:AddDoubleLine(STANDING..":", friend and friendTextLevel or _G["FACTION_STANDING_LABEL"..reaction], 1, 1, 1)
			GameTooltip:AddDoubleLine(REPUTATION..":", format("%d / %d (%d%%)", value - min, max - min, (value - min) / ((max - min == 0) and max or (max - min)) * 100), 1, 1, 1)
		end

		GameTooltip:Show()
	end

	local OnLeave = function(self)
		GameTooltip:Hide()
	end

	XP.EnableReputation = function(self)
		self:RegisterEvent("UPDATE_FACTION", "UpdateReputation")

		self.button:SetScript("OnEnter", OnEnter)
		self.button:SetScript("OnLeave", OnLeave)
	end

	XP.DisableReputation = function(self)
		self:UnregisterEvent("UPDATE_FACTION", "UpdateReputation")

		self.button:SetScript("OnEnter", nil)
		self.button:SetScript("OnLeave", nil)
	end
end

XP.UpdateHonor = function(self, event, unit)
	if event == "HONOR_PRESTIGE_UPDATE" and unit ~= "player" then return end

	local cur, max = UnitHonor("player"), UnitHonorMax("player")
	local level, levelMax = UnitHonorLevel("player"), GetMaxPlayerHonorLevel()
	local prestige = UnitPrestige("player") or 0

	local pct = cur / max * 100

	if (level == levelmax) then
		-- Force the bar to full for the max level
		self.button.bar:SetMinMaxValues(0, 1)
		self.button.bar:SetValue(1)
	else
		self.button.bar:SetMinMaxValues(0, max)
		self.button.bar:SetValue(cur)
	end

	local affix = ""
	if (CanPrestige()) then
		affix = " [|cff00ff00" .. PVP_HONOR_PRESTIGE_AVAILABLE .. "|r]"
	elseif (level == levelmax) then
		affix = " [|cff00ff00" .. MAX_HONOR_LEVEL .. "|r]"
	else
		affix = " [" .. level .. "]"
	end

	local r1, g1, b1 = T.ColorGradient(pct / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	self.button["Text"]:SetFormattedText("Honor: |cff%02x%02x%02x%d|r|cffffffff%%|r%s", r1 * 255, g1 * 255, b1 * 255, pct, affix)
	self.button.bar:Show()

	self.button:SetPluginSize()
end

do
	local OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -(IB.infoBar:GetHeight()))

		GameTooltip:ClearLines()

		local cur, max = UnitHonor("player"), UnitHonorMax("player")
		local level, levelMax = UnitHonorLevel("player"), GetMaxPlayerHonorLevel()

		GameTooltip:AddLine(HONOR)

		GameTooltip:AddDoubleLine("Current Level:", level, 1, 1, 1)
		GameTooltip:AddLine(" ")

		if (CanPrestige()) then
			GameTooltip:AddLine(PVP_HONOR_PRESTIGE_AVAILABLE)
		elseif (level == levelmax) then
			GameTooltip:AddLine(MAX_HONOR_LEVEL)
		else
			GameTooltip:AddDoubleLine("Honor XP:", format(" %d / %d (%d%%)", cur, max, cur/max * 100), 1, 1, 1)
			GameTooltip:AddDoubleLine("Honor Remaining:", format(" %d (%d%% - %d ".. "Bars)", max - cur, (max - cur) / max * 100, 20 * (max - cur) / max), 1, 1, 1)
		end

		GameTooltip:Show()
	end

	local OnLeave = function(self)
		GameTooltip:Hide()
	end

	XP.EnableHonor = function(self)
		self:RegisterEvent("HONOR_XP_UPDATE", "UpdateHonor")
		self:RegisterEvent("HONOR_PRESTIGE_UPDATE", "UpdateHonor")

		self.button:SetScript("OnEnter", OnEnter)
		self.button:SetScript("OnLeave", OnLeave)
	end

	XP.DisableHonor = function(self)
		self:UnregisterEvent("HONOR_XP_UPDATE", "UpdateHonor")
		self:UnregisterEvent("HONOR_PRESTIGE_UPDATE", "UpdateHonor")

		self.button:SetScript("OnEnter", nil)
		self.button:SetScript("OnLeave", nil)
	end
end

XP.UpdateExperience = function(self, event, unit)
	local level = UnitLevel("player")

	if (level == MAX_PLAYER_LEVEL) then
		self:DisableExperience()
		self:EnableExperience()
		return
	end

	local cur, max = UnitXP("player"), UnitXPMax("player")
	local rested = GetXPExhaustion()

	local pct = 0
	if (max and max ~= 0) then
		pct = (cur / max) * 100

		affix = "xp" .. (rested and format("/|cff%02x%02x%02x%d|r|cff%02x%02x%02x%%rested|r", 0, 255, 0, rested / max * 100, 255, 255, 255) or "")
	end

	self.button.bar:SetMinMaxValues(0, max)
	self.button.bar:SetValue(cur - 1 >= 0 and cur - 1 or 0)
	self.button.bar:SetValue(cur)

	if (rested and rested) > 0 then
		self.button.restedBar:Show()

		self.button.restedBar:SetMinMaxValues(0, max)
		self.button.restedBar:SetValue(min(cur + rested, max))
	else
		self.button.restedBar:Hide()

		self.button.restedBar:SetValue(0)
	end

	local r1, g1, b1 = T.ColorGradient(pct / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	self.button["Text"]:SetFormattedText((IsResting() and (restingIcon .. " ") or "") .. "|cff%02x%02x%02x%d|r|cffffffff%%|r%s [|cff00ff00%s|r]", r1 * 255, g1 * 255, b1 * 255, pct, affix, level)
	self.button.bar:Show()

	self.button:SetPluginSize()
end

do
	local OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -(IB.infoBar:GetHeight()))

		GameTooltip:ClearLines()

		local cur, max = UnitXP("player"), UnitXPMax("player")
		local rested = GetXPExhaustion()

		GameTooltip:AddLine("Experience")
		GameTooltip:AddLine(" ")

		GameTooltip:AddDoubleLine("XP:", format(" %d / %d (%d%%)", cur, max, cur/max * 100), 1, 1, 1)
		GameTooltip:AddDoubleLine("Remaining:", format(" %d (%d%% - %d " .. "Bars" .. ")", max - cur, (max - cur) / max * 100, 20 * (max - cur) / max), 1, 1, 1)

		if rested then
			GameTooltip:AddDoubleLine("Rested:", format("+%d (%d%%)", rested, rested / max * 100), 1, 1, 1)
		end

		GameTooltip:Show()
	end

	local OnLeave = function(self)
		GameTooltip:Hide()
	end

	XP.EnableExperience = function(self, button)
		if (not self.button) then
			local bar = CreateFrame("StatusBar", nil, button)
			bar:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\xpbar")
			bar:SetFrameLevel(3)
			bar:Point("TOPLEFT", button, "BOTTOMLEFT", 0, -5)
			bar:Point("TOPRIGHT", button, "BOTTOMRIGHT", 0, -5)
			bar:Height(4)

			bar.spark = bar:CreateTexture(nil, "OVERLAY", nil, 5)
			bar.spark:SetTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\statusbar-spark-white")
			bar.spark:Point("BOTTOMRIGHT", bar:GetStatusBarTexture(), "BOTTOMRIGHT")
			bar.spark:Point("TOPRIGHT", bar:GetStatusBarTexture(), "TOPRIGHT")
			bar.spark:Width(8)
			bar:Hide()

			Smoothing:EnableBarAnimation(bar)

			button.bar = bar

			local bg = CreateFrame("Frame", nil, button.bar)
			bg:SetFrameLevel(1)
			bg:SetAllPoints(button.bar)
			bg:SetBackdrop {
				bgFile = "Interface\\Buttons\\White8x8"
			}
			bg:SetBackdropColor(0, 0, 0, 0.9)

			button.bar.bg = bg

			local restedBar = CreateFrame("StatusBar", nil, button.bar)
			restedBar:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\xpbar")
			restedBar:SetStatusBarColor(0.5, 0.5, 0, 0.5)
			restedBar:SetFrameLevel(2)
			restedBar:SetAllPoints(button.bar)
			restedBar:Hide()

			Smoothing:EnableBarAnimation(restedBar)

			button.restedBar = restedBar

			self.button = button
		end

		if (event == "PLAYER_XP_UPDATE" or not IsXPUserDisabled() and UnitLevel("player") ~= MAX_PLAYER_LEVEL and self.db.enable) then
			if (self.enabled ~= "xp") then
				self:Disable()
			end

			self.enabled = "xp"

			self:RegisterEvent("DISABLE_XP_GAIN", "EnableExperience")
			self:RegisterEvent("PLAYER_XP_UPDATE", "UpdateExperience")
			self:RegisterEvent("UPDATE_EXHAUSTION", "UpdateExperience")
			self:RegisterEvent("PLAYER_UPDATE_RESTING", "UpdateExperience")
			self:RegisterEvent("PLAYER_LEVEL_UP", "UpdateExperience")

			self:UnregisterEvent("UPDATE_EXPANSION_LEVEL", "EnableExperience")

			self.button:SetScript("OnEnter", OnEnter)
			self.button:SetScript("OnLeave", OnLeave)

			self:UpdateExperience()

			self.Disable = XP.DisableExperience
		else
			if (IsXPUserDisabled() and UnitLevel("player") ~= MAX_PLAYER_LEVEL) then
				self:RegisterEvent("ENABLE_XP_GAIN", "EnableExperience")
			end

			self:RegisterEvent("UPDATE_EXPANSION_LEVEL", "EnableExperience")

			if (self.enabled == "xp") then
				self:Disable()
			end

			if (self.db["altxp"] == "honor") then
				self.enabled = "honor"

				self:EnableHonor()
				self:UpdateHonor()

				self.Disable = XP.DisableHonor
			elseif (self.db["altxp"] == "reputation") then
				self.enabled = "rep"

				self:EnableReputation()
				self:UpdateReputation()

				self.Disable = XP.DisableReputation
			end
		end
	end

	XP.DisableExperience = function(self)
		self:UnregisterEvent("DISABLE_XP_GAIN")
		self:UnregisterEvent("PLAYER_XP_UPDATE")
		self:UnregisterEvent("UPDATE_EXHAUSTION")
		self:UnregisterEvent("PLAYER_UPDATE_RESTING")
		self:UnregisterEvent("PLAYER_LEVEL_UP")

		self.button:SetScript("OnEnter", nil)
		self.button:SetScript("OnLeave", nil)
	end
end

local ExperienceBar = function(button)
	XP:EnableExperience(button)
end

XP.OnInitialize = function(self)
	self.db = IB.db["xp"]

	self.enabled = nil

	IB.RegisterPlugin("XP", ExperienceBar)
end
