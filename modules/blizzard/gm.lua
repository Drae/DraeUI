--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local B = T:GetModule("Blizzard")

--[[

--]]
function B:PositionGMFrames()
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:Point("TOPLEFT", UIParent, "TOPLEFT", 250, -10)

	HelpOpenTicketButton:SetParent(Minimap)
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT")
end
