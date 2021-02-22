--[[


--]]
local DraeUI = select(2, ...)

local B = DraeUI:GetModule("Blizzard")

--
local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10
local FORCE_POSITION = false

--[[

--]]
local AlertFrameHolder = CreateFrame("Frame", "AlertFrameHolder", UIParent)
AlertFrameHolder:SetWidth(180)
AlertFrameHolder:SetHeight(20)
AlertFrameHolder:SetPoint("TOP", UIParent, "TOP", 0, -25)

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
			if prevFrame and not (prevFrame == frame) then
				frame:SetPoint(POSITION, prevFrame, ANCHOR_POINT, 0, YOFFSET)
			else
				frame:SetPoint(POSITION, self, POSITION, 0, 0)
			end
			lastIdx = i
		end
	end

	if ( lastIdx ) then
		self:SetHeight(self.reservedSize * lastIdx)
		self:Show()
	else
		self:Hide()
	end
end

B.AdjustAnchors = function(self, relativeAlert)
	if self.alertFrame:IsShown() then
		self.alertFrame:ClearAllPoints()
		self.alertFrame:SetPoint(POSITION, relativeAlert, ANCHOR_POINT, 0, YOFFSET)

		return self.alertFrame
	end

	return relativeAlert
end

B.AdjustQueuedAnchors = function(self, relativeAlert)
	for alertFrame in self.alertFramePool:EnumerateActive() do
		alertFrame:ClearAllPoints()
		alertFrame:SetPoint(POSITION, relativeAlert, ANCHOR_POINT, 0, YOFFSET)
		relativeAlert = alertFrame
	end

	return relativeAlert
end

B.AlertMovers = function(self)
	UIPARENT_MANAGED_FRAME_POSITIONS["GroupLootContainer"] = nil

	--Replace AdjustAnchors functions to allow alerts to grow down if needed.
	--We will need to keep an eye on this in case it taints. It shouldn't, but you never know.
	for i, alertFrameSubSystem in ipairs(AlertFrame.alertFrameSubSystems) do
		if alertFrameSubSystem.alertFramePool then --queued alert system
			alertFrameSubSystem.AdjustAnchors = B.AdjustQueuedAnchors
		elseif not alertFrameSubSystem.anchorFrame then --simple alert system
			alertFrameSubSystem.AdjustAnchors = B.AdjustAnchors
		end
	end

	self:SecureHook(AlertFrame, "UpdateAnchors", B.PostAlertMove)
	hooksecurefunc("GroupLootContainer_Update", B.GroupLootContainer_Update)
end
