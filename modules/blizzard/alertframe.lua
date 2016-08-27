--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local B = T:GetModule("Blizzard")

--
local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10
local FORCE_POSITION = false

--[[

--]]
local AlertFrameHolder = CreateFrame("Frame", "AlertFrameHolder", UIParent)
AlertFrameHolder:Width(180)
AlertFrameHolder:Height(20)
AlertFrameHolder:Point("TOP", UIParent, "TOP", 0, -25)

local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10
local FORCE_POSITION = false

--[[

--]]
B.PostAlertMove = function()
    AlertFrame:ClearAllPoints()
    AlertFrame:SetAllPoints(AlertFrameHolder)
    GroupLootContainer:ClearAllPoints()
    GroupLootContainer:SetPoint(POSITION, AlertFrameHolder, ANCHOR_POINT, 0, YOFFSET)

    if GroupLootContainer:IsShown() then
        B.GroupLootContainer_Update(GroupLootContainer)
    end
end

B.GroupLootContainer_Update = function(self)
	local lastIdx = nil

	for i=1, self.maxIndex do
		local frame = self.rollFrames[i]
		local prevFrame = self.rollFrames[i-1]
		if ( frame ) then
			frame:ClearAllPoints()
			if prevFrame then
				frame:Point(POSITION, prevFrame or self, ANCHOR_POINT, 0, YOFFSET)
			else
				frame:Point("CENTER", self, "BOTTOM", 0, self.reservedSize * (i-1 + 0.5))
			end
			lastIdx = i
		end
	end

	if ( lastIdx ) then
		self:Height(self.reservedSize * lastIdx)
		self:Show()
	else
		self:Hide()
	end
end

B.AdjustAnchors = function(self, relativeAlert)
	if self.alertFrame:IsShown() then
		self.alertFrame:ClearAllPoints()
		self.alertFrame:SetPoint(POSITION, relativeAlert, ANCHOR_POINT, 0, YOFFSET)
	end
end

B.AdjustQueuedAnchors = function(self, relativeAlert)
	for alertFrame in self.alertFramePool:EnumerateActive() do
		alertFrame:ClearAllPoints()
		alertFrame:SetPoint(POSITION, relativeAlert, ANCHOR_POINT, 0, YOFFSET)
		relativeAlert = alertFrame
	end
end

B.AlertMovers = function(self)
	self:SecureHook(AlertFrame, "UpdateAnchors",B.PostAlertMove)
	hooksecurefunc("GroupLootContainer_Update", B.GroupLootContainer_Update)

	--From Leatrix Plus
	-- Achievements
	hooksecurefunc(AchievementAlertSystem, "AdjustAnchors", B.AdjustQueuedAnchors) 		-- /run AchievementAlertSystem:AddAlert(5192)
	hooksecurefunc(CriteriaAlertSystem, "AdjustAnchors", B.AdjustQueuedAnchors) 		-- /run CriteriaAlertSystem:AddAlert(9023, "Doing great!")
	-- Encounters
	hooksecurefunc(DungeonCompletionAlertSystem, "AdjustAnchors", B.AdjustAnchors) 		-- /run DungeonCompletionAlertSystem
	hooksecurefunc(GuildChallengeAlertSystem, "AdjustAnchors", B.AdjustAnchors) 		-- /run GuildChallengeAlertSystem:AddAlert(3, 2, 5)
	hooksecurefunc(InvasionAlertSystem, "AdjustAnchors", B.AdjustAnchors) 				-- /run InvasionAlertSystem:AddAlert(1)
	hooksecurefunc(ScenarioAlertSystem, "AdjustAnchors",  B.AdjustAnchors) 				-- ScenarioAlertSystem
	hooksecurefunc(WorldQuestCompleteAlertSystem, "AdjustAnchors", B.AdjustAnchors) 	-- /run WorldQuestCompleteAlertSystem:AddAlert(112)
	-- Garrisons
	hooksecurefunc(GarrisonBuildingAlertSystem, "AdjustAnchors",  B.AdjustAnchors) 		-- /run GarrisonBuildingAlertSystem:AddAlert("Barracks")
	hooksecurefunc(GarrisonFollowerAlertSystem, "AdjustAnchors",  B.AdjustAnchors) 		-- /run GarrisonFollowerAlertSystem:AddAlert(204, "Ben Stone", 90, 3, false)
	hooksecurefunc(GarrisonMissionAlertSystem, "AdjustAnchors", B.AdjustAnchors) 		-- /run GarrisonMissionAlertSystem:AddAlert(681)
	hooksecurefunc(GarrisonShipMissionAlertSystem, "AdjustAnchors", B.AdjustAnchors)	-- No test for this, it was missing from Leatrix Plus
	hooksecurefunc(GarrisonRandomMissionAlertSystem, "AdjustAnchors", B.AdjustAnchors)	-- GarrisonRandomMissionAlertSystem
	hooksecurefunc(GarrisonShipFollowerAlertSystem, "AdjustAnchors", B.AdjustAnchors)	-- /run GarrisonShipFollowerAlertSystem:AddAlert(592, "Test", "Transport", "GarrBuilding_Barracks_1_H", 3, 2, 1)
	hooksecurefunc(GarrisonTalentAlertSystem, "AdjustAnchors",  B.AdjustAnchors) 		-- GarrisonTalentAlertSystem
	-- Loot
	hooksecurefunc(LegendaryItemAlertSystem, "AdjustAnchors",  B.AdjustAnchors) 		-- /run LegendaryItemAlertSystem:AddAlert("\\124cffa335ee\\124Hitem:18832::::::::::\\124h[Brutality Blade]\\124h\\124r")
	hooksecurefunc(LootAlertSystem, "AdjustAnchors", B.AdjustQueuedAnchors) 			-- /run LootAlertSystem:AddAlert("\\124cffa335ee\\124Hitem:18832::::::::::\\124h[Brutality Blade]\\124h\\124r", 1, 1, 1, 1, false, false, 0, false, false)
	hooksecurefunc(LootUpgradeAlertSystem, "AdjustAnchors", B.AdjustQueuedAnchors) 		-- /run LootUpgradeAlertSystem:AddAlert("\\124cffa335ee\\124Hitem:18832::::::::::\\124h[Brutality Blade]\\124h\\124r", 1, 1, 1, nil, nil, false)
	hooksecurefunc(MoneyWonAlertSystem, "AdjustAnchors", B.AdjustQueuedAnchors) 		-- /run MoneyWonAlertSystem:AddAlert(815)
	hooksecurefunc(StorePurchaseAlertSystem, "AdjustAnchors", B.AdjustAnchors) 			-- /run StorePurchaseAlertSystem:AddAlert("\\124cffa335ee\\124Hitem:180545::::::::::\\124h[Mystic Runesaber]\\124h\\124r", "", "", 214)
	-- Professions
	hooksecurefunc(DigsiteCompleteAlertSystem, "AdjustAnchors", B.AdjustAnchors) 		-- /run DigsiteCompleteAlertSystem:AddAlert(1)
	hooksecurefunc(NewRecipeLearnedAlertSystem, "AdjustAnchors", B.AdjustQueuedAnchors)	-- /run NewRecipeLearnedAlertSystem:AddAlert(204)
end
