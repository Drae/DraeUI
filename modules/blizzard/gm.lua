--[[


--]]
local DraeUI = select(2, ...)

local B = DraeUI:GetModule("Blizzard")

--[[

--]]
function B:PositionGMFrames()
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 250, -10)

	if HelpOpenTicketButton then
		HelpOpenTicketButton:SetParent(Minimap)
		HelpOpenTicketButton:ClearAllPoints()
		HelpOpenTicketButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT")
	end
end
