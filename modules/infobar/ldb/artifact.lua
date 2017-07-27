--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:GetModule("Infobar")
local AT = IB:NewModule("Artifact", "AceEvent-3.0")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DraeArtifact", {
	type = "draeUI",
	icon = nil,
	statusbar = {
		artifact = {
			isStatusBar = true,
			level = 2,
			texture = "Interface\\AddOns\\draeUI\\media\\statusbars\\Striped",
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
	label = "DraeArtifact"
})

local format = string.format

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

--[[

]]
AT.UpdateArtifact = function(self, event, unit)
	if (unit and unit ~= "player") then return end

	if (not HasArtifactEquipped()) then
		LDB.ShowPlugin = false

		return
	else
		LDB.ShowPlugin = true
	end

	local _, _, name, _, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
	local pointsAvailable, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)

	local pct = (xp / xpForNextPoint) * 100

	local r1, g1, b1 = T.ColorGradient(pct / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	LDB.text = format("|cff%02x%02x%02x%s: |r|cff%02x%02x%02x%s|r|cff%02x%02x%02x / %s|r [|cff00ff00%dpoints|r]", 255, 255, 255, name, r1 * 255, g1 * 255, b1 * 255, ReadableNumber(xp), 255, 255, 255, pointsAvailable, pointsSpent)

	LDB.statusbar__artifact_min_max = "0," .. xpForNextPoint
	LDB.statusbar__artifact_cur = xp
end

LDB.OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

	GameTooltip:ClearLines()

	GameTooltip:AddLine(ARTIFACT_POWER)
	GameTooltip:AddLine(" ")

	local itemID, altItemID, name, icon, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
	local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)

	GameTooltip:AddDoubleLine("XP:", format(" %s / %s (%d%%)", ReadableNumber(xp), ReadableNumber(xpForNextPoint), xp / xpForNextPoint * 100), 1, 1, 1)
	GameTooltip:AddDoubleLine("Remaining:", format(" %s (%d%% - %d Bars)", ReadableNumber(xpForNextPoint - xp), (xpForNextPoint - xp) / xpForNextPoint * 100, 20 * (xpForNextPoint - xp) / xpForNextPoint), 1, 1, 1)

	GameTooltip:Show()
end

LDB.OnLeave = function(self)
	GameTooltip:Hide()
end

LDB.OnClick = function(self)
	ArtifactFrame_LoadUI()
	if ( ArtifactFrame:IsVisible() ) then
		HideUIPanel(ArtifactFrame)
	else
		SocketInventoryItem(16);
	end
end

AT.OnInitialize = function(self)
	self:RegisterEvent("ARTIFACT_UPDATE", "UpdateArtifact")
	self:RegisterEvent("ARTIFACT_XP_UPDATE", "UpdateArtifact")
	self:RegisterEvent("ARTIFACT_MAX_RANKS_UPDATE", "UpdateArtifact")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "UpdateArtifact")

	self:UpdateArtifact()
end

AT.OnDisable = function(self)
	self:UnregisterEvent("ARTIFACT_UPDATE", "UpdateArtifact")
	self:UnregisterEvent("ARTIFACT_XP_UPDATE", "UpdateArtifact")
	self:UnregisterEvent("ARTIFACT_MAX_RANKS_UPDATE", "UpdateArtifact")
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED", "UpdateArtifact")
end
