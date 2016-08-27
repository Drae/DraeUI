--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:GetModule("Infobar")
local FPS = IB:NewModule("FPS", "AceEvent-3.0", "AceTimer-3.0")


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

	local r2, g2, b2 = T.ColorGradient(framerate / 60 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)
	self.button["Text"]:SetFormattedText("|cff%02x%02x%02x%d|r|cff%02x%02x%02xfps|r", r2 * 255, g2 * 255, b2 * 255, framerate, 255, 255, 255)

	self.button:SetPluginSize()
end

local TooltipFPS = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -(IB.infoBar:GetHeight()))

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

	FPS.EnablePlugin = function(self, button)
		self.button = button

		self.button:SetScript("OnEnter", function()
			TooltipFPS(self.button)
			tooltipRenew = IB:ScheduleRepeatingTimer(TooltipFPS, 1.0, self.button)
		end)

		self.button:SetScript("OnLeave", function()
			IB:CancelTimer(tooltipRenew)
			GameTooltip:Hide()
		end)

		self.button:SetScript("OnClick", function(self)
			timeFPS = 0
		end)

		-- FPS handling
		self.timerFPS = self:ScheduleRepeatingTimer("UpdateFPS", 1.0)

		self:UpdateFPS()
	end
end

local PluginFPS = function(button)
	FPS:EnablePlugin(button)
end

FPS.OnInitialize = function(self)
	IB.RegisterPlugin("FPS", PluginFPS)
end
