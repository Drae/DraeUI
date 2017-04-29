--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local B = T:GetModule("Blizzard")

local function InitializeTalkingHead()
	--Prevent WoW from moving the frame around
	TalkingHeadFrame.ignoreFramePositionManager = true
	UIPARENT_MANAGED_FRAME_POSITIONS["TalkingHeadFrame"] = nil

	--Set default position
	TalkingHeadFrame:ClearAllPoints()
	TalkingHeadFrame:SetPoint("TOP", 0, -125)

	--Iterate through all alert subsystems in order to find the one created for TalkingHeadFrame, and then remove it.
	--We do this to prevent alerts from anchoring to this frame when it is shown.
	for index, alertFrameSubSystem in ipairs(AlertFrame.alertFrameSubSystems) do
		if alertFrameSubSystem.anchorFrame and alertFrameSubSystem.anchorFrame == TalkingHeadFrame then
			table.remove(AlertFrame.alertFrameSubSystems, index)
		end
	end
end

function B:PositionTalkingHead()
	if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
		InitializeTalkingHead()
	else --We want the mover to be available immediately, so we load it ourselves
		local f = CreateFrame("Frame")
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self, event)
			self:UnregisterEvent(event)
			TalkingHead_LoadUI()
			InitializeTalkingHead()
		end)
	end
end
