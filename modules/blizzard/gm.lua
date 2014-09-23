--[[


--]]
local T, C, G, P, U, _ = select(2, ...):unpack()

local B = T:GetModule("Blizzard")

--[[

--]]
function B:PositionGMFrames()
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 250, -10)

	HelpOpenTicketButton:SetParent(Minimap)
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT")
end
