--[[


--]]
local DraeUI = select(2, ...)

local InfoBar = DraeUI:GetModule("Infobar")
local FPS = InfoBar:NewModule("DraeFPS", "AceEvent-3.0", "AceTimer-3.0")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DraeFPS", {
	type = "draeUI",
	icon = nil,
	label = "DraeFPS",
})

local format = string.format

--[[

]]
local timeFPS = 0
local minFPS, maxFPS, avgFPS

FPS.UpdateFPS = function(self)
	local framerate = floor(GetFramerate())

	timeFPS = timeFPS + 1

	if (timeFPS == 1) then
		minFPS = framerate
		maxFPS = framerate
		avgFPS = framerate
	else
		if (framerate < minFPS) then
			minFPS = framerate
		elseif (framerate > maxFPS) then
			maxFPS = framerate
		end

		avgFPS = (avgFPS * (timeFPS - 1) + framerate) / timeFPS
	end

	local r2, g2, b2 = DraeUI.ColorGradient(framerate / 60 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)
	LDB.text = format("|cff%02x%02x%02x%d|r|cff%02x%02x%02xfps|r", r2 * 255, g2 * 255, b2 * 255, framerate, 255, 255, 255)
end

local TooltipFPS = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

	GameTooltip:ClearLines()

	GameTooltip:AddLine("FPS", 1, 1, 1)
	GameTooltip:AddLine(" ")

	GameTooltip:AddDoubleLine("Minimum", format("%d", minFPS), 1, 1, 1)
	GameTooltip:AddDoubleLine("Maximum", format("%d", maxFPS), 1, 1, 1)
	GameTooltip:AddDoubleLine("Average", format("%d", avgFPS), 1, 1, 1)

	GameTooltip:Show()
end

do
	local tooltipRenew

	LDB.OnEnter = function(self)
		TooltipFPS(self)
		tooltipRenew = FPS:ScheduleRepeatingTimer(TooltipFPS, 0.5, self)
	end

	LDB.OnLeave = function(self)
		FPS:CancelTimer(tooltipRenew)
		GameTooltip:Hide()
	end

	LDB.OnClick = function(self)
		timeFPS = 0
	end
end

FPS.OnInitialize = function(self)
	-- FPS handling
	self.timerFPS = self:ScheduleRepeatingTimer("UpdateFPS", 0.5)

	self:UpdateFPS()
end
