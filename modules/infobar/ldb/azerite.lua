--[[


--]]
local DraeUI = select(2, ...)

local IB = DraeUI:GetModule("Infobar")
local AT = IB:NewModule("Azerite", "AceEvent-3.0")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DraeAzerite", {
	type = "draeUI",
	icon = nil,
	statusbar = {
		azerite = {
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
			spark = true,
			smooth = true,
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
	label = "DraeAzerite"
})

--
local C_AzeriteEmpoweredItem, C_AzeriteItem, Item = C_AzeriteEmpoweredItem, C_AzeriteItem, Item
local mfloor, format = math.floor, string.format

--[[

]]
local ReadableNumber = function(num, places)
    local ret
    local placeValue = ("%%.%df"):format(places or 2)

    if not num then
        return 0
    elseif num >= 1000000000000 then
        ret = placeValue:format(num / 1000000000000) .. " Tril" -- trillion
    elseif num >= 1000000000 then
        ret = placeValue:format(num / 1000000000) .. " Bil" -- billion
    elseif num >= 1000000 then
        ret = placeValue:format(num / 1000000) .. " Mil" -- million
    else
        ret = num -- hundreds
    end

    return ret
end

AT.UpdateAzerite = function(self, event, unit)
	if event == "UNIT_INVENTORY_CHANGED" and unit ~= 'player' then return end

	if (not C_AzeriteEmpoweredItem.IsHeartOfAzerothEquipped()) then
		LDB.ShowPlugin = false

		return
	else
		LDB.ShowPlugin = true
	end

	local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()

	local xp, totalLevelXP = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)
	local xpToNextLevel = totalLevelXP - xp
	local currentLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)

	local pct = (xp / totalLevelXP * 100) * 100
	local r1, g1, b1 = DraeUI.ColorGradient(pct / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	LDB.text = format('Azerite: %s / |cff%02x%02x%02x%s%%|r (%s) [%s]', ReadableNumber(xp), r1 * 255, g1 * 255, b1 * 255, mfloor(xp / totalLevelXP * 100), ReadableNumber(xpToNextLevel), currentLevel)

	LDB.statusbar__azerite_min_max = "0," .. totalLevelXP
	LDB.statusbar__azerite_cur = xp
end

LDB.OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

	GameTooltip:ClearLines()

	GameTooltip:AddLine(AZERITE_POWER)
	GameTooltip:AddLine(" ")

	local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem();
	local azeriteItem = Item:CreateFromItemLocation(azeriteItemLocation);
	local xp, totalLevelXP = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)
	local currentLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
	local xpToNextLevel = totalLevelXP - xp

	local azeriteItemName = azeriteItem:GetItemName()

	GameTooltip:AddDoubleLine("Azerite item:", azeriteItemName.." ("..currentLevel..")", nil,  nil, nil, 0.90, 0.80, 0.50)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("XP:", format(" %s / %s (%d%%)", ReadableNumber(xp), ReadableNumber(totalLevelXP), xp / totalLevelXP * 100), 1, 1, 1)
	GameTooltip:AddDoubleLine("Remaining:", format(" %d (%d%% - %d Bars)", ReadableNumber(xpToNextLevel), xpToNextLevel / totalLevelXP * 100, 10 * xpToNextLevel / totalLevelXP), 1, 1, 1)

	GameTooltip:Show()
end

LDB.OnLeave = function(self)
	GameTooltip:Hide()
end

LDB.OnClick = function(self)
	return
end

AT.PlayerEnteringWorld = function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD", "PlayerEnteringWorld")

	self:UpdateAzerite()
end

AT.OnInitialize = function(self)
	self:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED", "UpdateAzerite")
	self:RegisterEvent("AZERITE_ITEM_POWER_LEVEL_CHANGED", "UpdateAzerite")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "UpdateAzerite")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateAzerite")

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "PlayerEnteringWorld")
end

AT.OnDisable = function(self)
	self:UnregisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED", "UpdateAzerite")
	self:UnregisterEvent("AZERITE_ITEM_POWER_LEVEL_CHANGED", "UpdateAzerite")
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED", "UpdateAzerite")
	self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateAzerite")

	self:UnregisterEvent("PLAYER_ENTERING_WORLD", "PlayerEnteringWorld")
end
