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

--[[

--]]
B.PostAlertMove = function(self, screenQuadrant)
	AlertFrame:ClearAllPoints()
	AlertFrame:SetAllPoints(AlertFrameHolder)

	if (screenQuadrant) then
		FORCE_POSITION = true
		AlertFrame_FixAnchors()
		FORCE_POSITION = false
	end
end

B.AlertFrame_SetLootAnchors = function(self, alertAnchor)
	--This is a bit of reverse logic to get it to work properly because blizzard was a bit lazy..
	if (MissingLootFrame:IsShown()) then
		MissingLootFrame:ClearAllPoints()
		MissingLootFrame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT)

		if (GroupLootContainer:IsShown()) then
			GroupLootContainer:ClearAllPoints()
			GroupLootContainer:Point(POSITION, MissingLootFrame, ANCHOR_POINT, 0, YOFFSET)
		end
	elseif (GroupLootContainer:IsShown() or FORCE_POSITION) then
		GroupLootContainer:ClearAllPoints()
		GroupLootContainer:SetPoint(POSITION, alertAnchor, ANCHOR_POINT)
	end
end

B.AlertFrame_SetStorePurchaseAnchors = function(self, alertAnchor)
	local frame = StorePurchaseAlertFrame

	if (frame:IsShown()) then
		frame:ClearAllPoints()
		frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end

B.AlertFrame_SetLootWonAnchors = function(self, alertAnchor)
	for i=1, #LOOT_WON_ALERT_FRAMES do
		local frame = LOOT_WON_ALERT_FRAMES[i]

		if (frame:IsShown()) then
			frame:ClearAllPoints()
			frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)

			alertAnchor = frame
		end
	end
end

B.AlertFrame_SetLootUpgradeFrameAnchors = function(self, alertAnchor)
	for i=1, #LOOT_UPGRADE_ALERT_FRAMES do
		local frame = LOOT_UPGRADE_ALERT_FRAMES[i]

		if (frame:IsShown()) then
			frame:ClearAllPoints()
			frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)

			alertAnchor = frame
		end
	end
end

B.AlertFrame_SetMoneyWonAnchors = function(self, alertAnchor)
	for i=1, #MONEY_WON_ALERT_FRAMES do
		local frame = MONEY_WON_ALERT_FRAMES[i]

		if (frame:IsShown()) then
			frame:ClearAllPoints()
			frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)

			alertAnchor = frame
		end
	end
end

function B:AlertFrame_SetAchievementAnchors(alertAnchor)
	if (AchievementAlertFrame1) then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i]
			if ( frame and frame:IsShown() ) then
				frame:ClearAllPoints()
				frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
				alertAnchor = frame
			end
		end
	end
end

B.AlertFrame_SetCriteriaAnchors = function(self, alertAnchor)
	if (CriteriaAlertFrame1) then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["CriteriaAlertFrame"..i]

			if (frame and frame:IsShown()) then
				frame:ClearAllPoints()
				frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)

				alertAnchor = frame
			end
		end
	end
end

B.AlertFrame_SetChallengeModeAnchors = function(self, alertAnchor)
	local frame = ChallengeModeAlertFrame1

	if (frame:IsShown()) then
		frame:ClearAllPoints()
		frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end

B.AlertFrame_SetDungeonCompletionAnchors = function(self, alertAnchor)
	local frame = DungeonCompletionAlertFrame1

	if (frame:IsShown()) then
		frame:ClearAllPoints()
		frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end

B.AlertFrame_SetScenarioAnchors = function(self, alertAnchor)
	local frame = ScenarioAlertFrame1

	if (frame:IsShown()) then
		frame:ClearAllPoints()
		frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end

B.AlertFrame_SetGuildChallengeAnchors = function(self, alertAnchor)
	local frame = GuildChallengeAlertFrame

	if (frame:IsShown()) then
		frame:ClearAllPoints()
		frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end

B.AlertFrame_SetDigsiteCompleteToastFrameAnchors = function(self, alertAnchor)
	local frame = DigsiteCompleteToastFrame

	if (frame and frame:IsShown()) then
		frame:ClearAllPoints()
		frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end

B.AlertFrame_SetGarrisonBuildingAlertFrameAnchors = function(self, alertAnchor)
	local frame = GarrisonBuildingAlertFrame

	if (frame:IsShown()) then
		frame:ClearAllPoints()
		frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end

B.AlertFrame_SetGarrisonMissionAlertFrameAnchors = function(self, alertAnchor)
	local frame = GarrisonMissionAlertFrame

	if (frame:IsShown()) then
		frame:ClearAllPoints()
		frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end

B.AlertFrame_SetGarrisonFollowerAlertFrameAnchors = function(self, alertAnchor)
	local frame = GarrisonFollowerAlertFrame

	if (frame:IsShown()) then
		frame:ClearAllPoints()
		frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end

B.AlertMovers = function(self)
	self:SecureHook("AlertFrame_FixAnchors", "PostAlertMove")
	self:SecureHook("AlertFrame_SetLootAnchors")
	self:SecureHook("AlertFrame_SetStorePurchaseAnchors")
	self:SecureHook("AlertFrame_SetLootWonAnchors")
	self:SecureHook("AlertFrame_SetLootUpgradeFrameAnchors")
	self:SecureHook("AlertFrame_SetMoneyWonAnchors")
	self:SecureHook("AlertFrame_SetAchievementAnchors")
	self:SecureHook("AlertFrame_SetCriteriaAnchors")
	self:SecureHook("AlertFrame_SetChallengeModeAnchors")
	self:SecureHook("AlertFrame_SetDungeonCompletionAnchors")
	self:SecureHook("AlertFrame_SetScenarioAnchors")
	self:SecureHook("AlertFrame_SetGuildChallengeAnchors")
	self:SecureHook("AlertFrame_SetDigsiteCompleteToastFrameAnchors") --
	self:SecureHook("AlertFrame_SetGarrisonBuildingAlertFrameAnchors")
	self:SecureHook("AlertFrame_SetGarrisonMissionAlertFrameAnchors")
	self:SecureHook("AlertFrame_SetGarrisonFollowerAlertFrameAnchors")

	UIPARENT_MANAGED_FRAME_POSITIONS["GroupLootContainer"] = nil
end
