--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:GetModule("Infobar")
local XP = IB:NewModule("XP", "AceEvent-3.0")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DraeExp", {
	type = "draeUI",
	icon = nil,
	statusbar = {
		xp = {
			isStatusBar = true,
			level = 3,
			texture = "Interface\\AddOns\\draeUI\\media\\statusbars\\striped",
			position = {
				{
					anchorat = "TOPLEFT",
					anchorto = "BOTTOMLEFT",
					offsetX = 0,
					offsetY = 2
				},
				{
					anchorat = "TOPRIGHT",
					anchorto = "BOTTOMRIGHT",
					offsetX = 0,
					offsetY = 2
				}
			},
			height = 5,
			spark = true,
			smooth = true,
		},
		rested = {
			isStatusBar = true,
			level = 2,
			texture = "Interface\\AddOns\\draeUI\\media\\statusbars\\striped",
			position = {
				{
					anchorat = "TOPLEFT",
					anchorto = "BOTTOMLEFT",
					offsetX = 0,
					offsetY = 2
				},
				{
					anchorat = "TOPRIGHT",
					anchorto = "BOTTOMRIGHT",
					offsetX = 0,
					offsetY = 2
				}
			},
			height = 5,
			color = { 0.5, 0.5, 0, 0.5 },
			spark = false,
			smooth = true
		},
		bg = {
			isStatusBar = false,
			level = 1,
			position = {
				{
					anchorat = "TOPLEFT",
					anchorto = "BOTTOMLEFT",
					offsetX = 0,
					offsetY = 2
				},
				{
					anchorat = "TOPRIGHT",
					anchorto = "BOTTOMRIGHT",
					offsetX = 0,
					offsetY = 2
				}
			},
			height = 5,
			spark = false,
			bg = {
				texture = "Interface\\Buttons\\White8x8",
				color = { 0, 0, 0, 1 }
			}
		}
	},
	label = "DraeExp"
})

--[[

]]
local restingIcon = "|TInterface\\AddOns\\draeUI\\media\\textures\\resting-icon:14:14:0:0|t"

--[[

]]
XP.UpdateReputation = function(self)
	local name, reaction, min, max, value, faction = GetWatchedFactionInfo()
	local friend, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(faction)
	local numFactions = GetNumFactions()

	if (not name) then
		LDB.ShowPlugin = false

		return
	end

	LDB.ShowPlugin = true

	local pct = (value - min) / (max - min) * 100
	local affix = "[" ..  (friend and friendTextLevel or _G["FACTION_STANDING_LABEL" .. reaction]) .. "]"

	local r1, g1, b1 = T.ColorGradient(pct / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	LDB.text = format("%s: |cff%02x%02x%02x%d|r|cffffffff%%|r %s", name, r1 * 255, g1 * 255, b1 * 255, pct, affix)

	LDB.statusbar__xp_min_max = min .. "," .. max
	LDB.statusbar__xp_cur = value
	LDB.statusbar__rested_hide = true
end

do
	local OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

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

	local OnClick = function(self)
	end

	XP.EnableReputation = function(self)
		self:RegisterEvent("UPDATE_FACTION", "UpdateReputation")

		LDB.OnEnter = OnEnter
		LDB.OnLeave = OnLeave
	end

	XP.DisableReputation = function(self)
		self:UnregisterEvent("UPDATE_FACTION", "UpdateReputation")

		LDB.OnEnter = nil
		LDB.OnLeave = nil
	end
end

XP.UpdateHonor = function(self, event, unit)
	local cur, max = UnitHonor("player"), UnitHonorMax("player")
	local level, levelMax = UnitHonorLevel("player"), GetMaxPlayerHonorLevel()

	local pct = cur / max * 100

	if (level == levelmax) then
		-- Force the bar to full for the max level
		LDB.statusbar__xp_min_max = "0,1"
		LDB.statusbar__xp_cur = 1
	else
		LDB.statusbar__xp_min_max = "0," .. max
		LDB.statusbar__xp_cur = cur
	end
	LDB.statusbar__rested_hide = true

	local affix = ""
	if (level == levelmax) then
		affix = " [|cff00ff00" .. MAX_HONOR_LEVEL .. "|r]"
	else
		affix = " [" .. level .. "]"
	end

	local r1, g1, b1 = T.ColorGradient(pct / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	LDB.text = format("Honor: |cff%02x%02x%02x%d|r|cffffffff%%|r%s", r1 * 255, g1 * 255, b1 * 255, pct, affix)
end

do
	local OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

		GameTooltip:ClearLines()

		local cur, max = UnitHonor("player"), UnitHonorMax("player")
		local level, levelMax = UnitHonorLevel("player"), GetMaxPlayerHonorLevel()

		GameTooltip:AddLine(HONOR)

		GameTooltip:AddDoubleLine("Current Level:", level, 1, 1, 1)
		GameTooltip:AddLine(" ")

		if (level == levelmax) then
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
		LDB.OnEnter = OnEnter
		LDB.OnLeave = OnLeave
	end

	XP.DisableHonor = function(self)
		self:UnregisterEvent("HONOR_XP_UPDATE", "UpdateHonor")

		LDB.OnEnter = nil
		LDB.OnLeave = nil
	end
end

XP.UpdateExperience = function(self, event, unit)
	local level = UnitLevel("player")

	if (level == MAX_PLAYER_LEVEL) then
		self:DisableExperience()

		LDB.ShowPlugin = false

		self:EnableExperience()
		return
	end

	local cur, max = UnitXP("player"), UnitXPMax("player")
	local rested = GetXPExhaustion()

	local pct = 0
	if (max and max ~= 0) then
		pct = (cur / max) * 100
	end

	LDB.statusbar__xp_min_max = "0," .. max
	LDB.statusbar__xp_cur = cur - 1 >= 0 and cur - 1 or 0

	if (rested and rested > 0) then
		LDB.statusbar__rested_min_max = "0," .. max
		LDB.statusbar__rested_cur = min(cur + rested, max)
		LDB.statusbar__rested_hide = false
	else
		LDB.statusbar__rested_hide = true
	end

	local r1, g1, b1 = T.ColorGradient(pct / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	LDB.text = format((IsResting() and (restingIcon .. " ") or "") .. "[|cff00ff00%s|r] |cff%02x%02x%02x%d|r|cffffffff%%|rxp (%d/%d)%s", level, r1 * 255, g1 * 255, b1 * 255, pct, cur, max, (rested and format(" |cff%02x%02x%02x%d|r|cff%02x%02x%02x%%rested|r", 0, 255, 0, rested / max * 100, 255, 255, 255) or ""))
end

do
	local OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

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

	XP.EnableExperience = function(self, event)
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

			LDB.OnEnter = OnEnter
			LDB.OnLeave = OnLeave

			LDB.ShowPlugin = true

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

				LDB.ShowPlugin = true

				self:EnableHonor()
				self:UpdateHonor()

				self.Disable = XP.DisableHonor
			elseif (self.db["altxp"] == "reputation") then
				self.enabled = "rep"

				LDB.ShowPlugin = true

				self:EnableReputation()
				self:UpdateReputation()

				self.Disable = XP.DisableReputation
			else
				LDB.ShowPlugin = false
			end
		end
	end

	XP.DisableExperience = function(self)
		self:UnregisterEvent("DISABLE_XP_GAIN")
		self:UnregisterEvent("PLAYER_XP_UPDATE")
		self:UnregisterEvent("UPDATE_EXHAUSTION")
		self:UnregisterEvent("PLAYER_UPDATE_RESTING")
		self:UnregisterEvent("PLAYER_LEVEL_UP")

		LDB.OnEnter = nil
		LDB.OnLeave = nil
	end
end

XP.PlayerEnteringWorld = function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD", "PlayerEnteringWorld")

	self:EnableExperience()
end

XP.OnInitialize = function(self)
	IB.db = IB.db or {}
	IB.db["xp"] = IB.db["xp"] or {}
	self.db = IB.db["xp"]

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "PlayerEnteringWorld")
end
