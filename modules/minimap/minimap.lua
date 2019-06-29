--[[
	Basically rMinimap customied a bit!
	zoomscript taken from pminimap by p3lim - http://www.wowinterface.com/downloads/info8389-pT.html
--]]

--
local T, C, G, P, U, _ = select(2, ...):UnPack()

local MM = T:GetModule("Minimap")

--
local _G = _G
local Minimap, MinimapCluster, MinimapBackdrop, MinimapPing = _G["Minimap"], _G["MinimapCluster"], _G["MinimapBackdrop"], _G["MinimapPing"]

--
MM.frame = CreateFrame("Frame") -- Animation frame
local pingFrame

--[[
		This is the right click menu
--]]
local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{text = CHARACTER_BUTTON,
	func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON,
	func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
	{text = TALENTS_BUTTON,
	func = function()
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end

		if not GlyphFrame then
			GlyphFrame_LoadUI()
		end

		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end},
	{text = MOUNTS,
	func = function()
		TogglePetJournal(1);
	end},
	{text = TIMEMANAGER_TITLE,
	func = function() ToggleFrame(TimeManagerFrame) end},
	{text = ACHIEVEMENT_BUTTON,
	func = function() ToggleAchievementFrame() end},
	{text = SOCIAL_BUTTON,
	func = function() ToggleFriendsFrame() end},
	{text = "Calendar",
	func = function() GameTimeFrame:Click() end},
	{text = GARRISON_LANDING_PAGE_TITLE,
	func = function() GarrisonLandingPageMinimapButton_OnClick() end},
	{text = ACHIEVEMENTS_GUILD_TAB,
	func = function()
		if IsInGuild() then
			if not GuildFrame then GuildFrame_LoadUI() end
			GuildFrame_Toggle()
		else
			if not LookingForGuildFrame then LookingForGuildFrame_LoadUI() end
			if not LookingForGuildFrame then return end
			LookingForGuildFrame_Toggle()
		end
	end},
	{text = LFG_TITLE,
	func = function() PVEFrame_ToggleFrame(); end},
	{text = ENCOUNTER_JOURNAL,
	func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end}
}

--[[

--]]
local noop = function() end

do
	local alreadyGrabbed = {}

	local grabFrames = function(...)
		for i=1, select("#", ...) do
			local f = select(i, ...)
			local n = f:GetName()

			if n and not alreadyGrabbed[n] then
				alreadyGrabbed[n] = true
				MM.buttons:NewFrame(f)
			end
		end
	end

	MM.StartFrameGrab = function(self)
		-- Try to capture new frames periodically
		-- We"d use ADDON_LOADED but it"s too early, some addons load a minimap icon afterwards
		local updateTimer = MM.frame:CreateAnimationGroup()
		local anim = updateTimer:CreateAnimation()
		updateTimer:SetScript("OnLoop", function() grabFrames(Minimap:GetChildren()) end)
		anim:SetOrder(1)
		anim:SetDuration(1)
		updateTimer:SetLooping("REPEAT")
		updateTimer:Play()

		-- Grab Icons
		grabFrames(MinimapZoneTextButton, Minimap, MiniMapTrackingButton, TimeManagerClockButton, MinimapBackdrop:GetChildren())
		grabFrames(MinimapCluster:GetChildren())

		self.StartFrameGrab = nil
	end
end

MM.OnEnable = function(self)
	Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -30, -30)

	MinimapBackdrop:ClearAllPoints()
	MinimapBackdrop:SetParent(Minimap)
	MinimapBackdrop:SetPoint("CENTER", Minimap, "CENTER", -8, -24)

	-- Change some basic textures
	MinimapBorder:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\UI-Minimap-Border")
	MinimapNorthTag:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\CompassNorthTag")
	MinimapCompassTexture:SetTexture("Interface\\AddOns\\draeUI\\media\textures\\CompassRing")
	MiniMapTrackingButtonBorder:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\MiniMap-TrackingBorder")
	QueueStatusMinimapButtonBorder:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\MiniMap-TrackingBorder")
	MiniMapMailBorder:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\MiniMap-TrackingBorder")

	-- The Pinger
	pingFrame = CreateFrame("Frame", nil, Minimap)
	pingFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		insets = {left = 2, top = 2, right = 2, bottom = 2},
		edgeSize = 12,
		tile = true
	})
	pingFrame:SetBackdropColor(0, 0, 0, 0.8)
	pingFrame:SetBackdropBorderColor(0, 0, 0, 0.6)
	pingFrame:SetHeight(20)
	pingFrame:SetWidth(100)
	pingFrame:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 10)
	pingFrame:SetFrameStrata("HIGH")
	pingFrame.name = pingFrame:CreateFontString(nil, nil, "GameFontNormalSmall")
	pingFrame.name:SetAllPoints()
	pingFrame:Hide()

	local animGroup = pingFrame:CreateAnimationGroup()
	local anim = animGroup:CreateAnimation("Alpha")
	animGroup:SetScript("OnFinished", function() pingFrame:Hide() end)
    anim:SetFromAlpha(1)
    anim:SetToAlpha(0)
	anim:SetOrder(1)
	anim:SetDuration(3)
	anim:SetStartDelay(3)

	pingFrame:SetScript("OnEvent", function(_, _, unit)
		local class = select(2, UnitClass(unit))
		local color = class and RAID_CLASS_COLORS[class] or GRAY_FONT_COLOR

		pingFrame.name:SetFormattedText("|cFF%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, UnitName(unit))
		pingFrame:SetWidth(pingFrame.name:GetStringWidth() + 14)
		pingFrame:SetHeight(pingFrame.name:GetStringHeight() + 10)
		animGroup:Stop()
		pingFrame:Show()
		animGroup:Play()
	end)
	pingFrame:RegisterEvent("MINIMAP_PING")

	-- Clock
	if (TimeManagerClockButton) then
		local timerframe = _G["TimeManagerClockButton"]
		TimeManagerClockTicker:SetFont(NAMEPLATE_FONT, 12, "THINOUTLINE")
		local region1 = timerframe:GetRegions()
		region1:Hide()
	end

	-- Hide other buttons
	MinimapZoomOut:Hide()
	MinimapZoomIn:Hide()
	MinimapZoneTextButton:Hide()
	MinimapBorderTop:Hide()
	MiniMapWorldMapButton:Hide()
	MiniMapWorldMapButton:Hide()

	Minimap:EnableMouseWheel()
	Minimap:SetScript("OnMouseWheel", function(self, direction)
		if (direction > 0) then
			Minimap_ZoomIn()
		else
			Minimap_ZoomOut()
		end
	end)

	Minimap:SetScript("OnMouseUp", function(self, btn)
		if (btn == "RightButton") then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
		else
			Minimap_OnClick(self)
		end
	end)

	-- Grab all the buttons and stuffs
	self:StartFrameGrab()
end

