--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:GetModule("Infobar")
local PING = IB:NewModule("Latency", "AceEvent-3.0", "AceTimer-3.0")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DraeLatency", {
	type = "draeUI",
	icon = nil,
	label = "DraeLatency",
})

local GetNetStats, format = GetNetStats, string.format

--[[

]]
PING.UpdateLatency = function(self)
	local _, _, homeLatency, worldLatency = GetNetStats()

	local r2, g2, b2 = T.ColorGradient(homeLatency / 500 - 0.001, 0, 1, 0, 1, 1, 0, 0, 1, 0)
	local r3, g3, b3 = T.ColorGradient(worldLatency / 500 - 0.001, 0, 1, 0, 1, 1, 0, 0, 1, 0)

	LDB.text = format("|cff%02x%02x%02x%d|r|cff%02x%02x%02xms/|r|cff%02x%02x%02x%d|r|cff%02x%02x%02xms|r", r2 * 255, g2 * 255, b2 * 255, homeLatency, 255, 255, 255, r3 * 255, g3 * 255, b3 * 255, worldLatency, 255, 255, 255)

end

local TooltipLatency = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

	GameTooltip:ClearLines()

	local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()

	GameTooltip:AddLine("Latency", 1, 1, 1)

	GameTooltip:AddLine(" ")

	GameTooltip:AddDoubleLine("Latency - Home", format("%d ms", latencyHome), 1, 1, 1)
	GameTooltip:AddDoubleLine("Latency - World", format("%d ms", latencyWorld), 1, 1, 1)

	GameTooltip:AddDoubleLine("Bandwidth - In", format("%.2f kB/s", bandwidthIn), 1, 1, 1)
	GameTooltip:AddDoubleLine("Bandwidth - Out", format("%.2f kB/s", bandwidthOut), 1, 1, 1)

	GameTooltip:Show()
end

do
	local tooltipRenew

	LDB.OnEnter = function(self)
		TooltipLatency(self)
		tooltipRenew = PING:ScheduleRepeatingTimer(TooltipLatency, 1.0, self)
	end

	LDB.OnLeave = function(self)
		PING:CancelTimer(tooltipRenew)
		GameTooltip:Hide()
	end
end

PING.OnInitialize = function(self)
	self.timerPING = self:ScheduleRepeatingTimer("UpdateLatency", 1.0)

	self:UpdateLatency()
end
