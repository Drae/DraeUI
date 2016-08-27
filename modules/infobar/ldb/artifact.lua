--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:GetModule("Infobar")
local AT = IB:NewModule("Artifact", "AceEvent-3.0")

local Smoothing = LibStub("LibCutawaySmooth-1.0", true)

--[[

]]
AT.UpdateArtifact = function(self, event, unit)
	if (unit and unit ~= "player") then return end

	if (not HasArtifactEquipped() or not self.db.enable) then
		self.button:Hide()
		IB:RepositionPlugins()

		return
	else
		self.button:Show()
		IB:RepositionPlugins()
	end

	local _, _, name, _, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUI.GetEquippedArtifactInfo()
	local pointsAvailable, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)

	local pct = (xp / xpForNextPoint) * 100

	local r1, g1, b1 = T.ColorGradient(pct / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	self.button["Text"]:SetFormattedText("|cff%02x%02x%02x%s: |r|cff%02x%02x%02x%s|r|cff%02x%02x%02x / %s|r", 255, 255, 255, name, r1 * 255, g1 * 255, b1 * 255, xp, 255, 255, 255, pointsAvailable)

	if (xp == 0) then
		self.button.bar.spark:Hide()
	else
		self.button.bar.spark:Show()
	end

	self.button.bar:SetMinMaxValues(0, xpForNextPoint)
	self.button.bar:SetValue(xp)

	self.button:SetPluginSize()
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -(IB.infoBar:GetHeight()))

	GameTooltip:ClearLines()

	GameTooltip:AddLine(ARTIFACT_POWER)
	GameTooltip:AddLine(" ")

	local itemID, altItemID, name, icon, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUI.GetEquippedArtifactInfo()
	local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)

	GameTooltip:AddDoubleLine("XP:", format(" %d / %d (%d%%)", xp, xpForNextPoint, xp / xpForNextPoint * 100), 1, 1, 1)
	GameTooltip:AddDoubleLine("Remaining:", format(" %d (%d%% - %d Bars)", xpForNextPoint - xp, (xpForNextPoint - xp) / xpForNextPoint * 100, 20 * (xpForNextPoint - xp) / xpForNextPoint), 1, 1, 1)

	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

AT.EnableArtifact = function(self, button)
	if (self.db.enable) then
		if (not self.button) then
			local bar = CreateFrame("StatusBar", nil, button)
			bar:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\artifactbar")
			bar:SetFrameLevel(3)
			bar:Point("TOPLEFT", button, "BOTTOMLEFT", 0, -5)
			bar:Point("TOPRIGHT", button, "BOTTOMRIGHT", 0, -5)
			bar:Height(4)

			bar.spark = bar:CreateTexture(nil, "OVERLAY", nil, 5)
			bar.spark:SetTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\statusbar-spark-white")
			bar.spark:Point("BOTTOMRIGHT", bar:GetStatusBarTexture(), "BOTTOMRIGHT")
			bar.spark:Point("TOPRIGHT", bar:GetStatusBarTexture(), "TOPRIGHT")
			bar.spark:Width(8)

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

			self.button = button
		end

		self:RegisterEvent("ARTIFACT_UPDATE", "UpdateArtifact")
		self:RegisterEvent("ARTIFACT_XP_UPDATE", "UpdateArtifact")
		self:RegisterEvent("ARTIFACT_MAX_RANKS_UPDATE", "UpdateArtifact")
		self:RegisterEvent("UNIT_INVENTORY_CHANGED", "UpdateArtifact")

		self.button:SetScript("OnEnter", OnEnter)
		self.button:SetScript("OnLeave", OnLeave)

		self:UpdateArtifact()
	end

	AT.DisableArtifact = function(self)
		self:UnregisterEvent("ARTIFACT_UPDATE", "UpdateArtifact")
		self:UnregisterEvent("ARTIFACT_XP_UPDATE", "UpdateArtifact")
		self:UnregisterEvent("ARTIFACT_MAX_RANKS_UPDATE", "UpdateArtifact")
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED", "UpdateArtifact")

		self.button:SetScript("OnEnter", nil)
		self.button:SetScript("OnLeave", nil)
	end
end

local ArtifactBar = function(button)
	AT:EnableArtifact(button)
end

AT.OnInitialize = function(self)
	self.db = IB.db["artifact"]

	IB.RegisterPlugin("Artifact", ArtifactBar)
end
