--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local B = T:GetModule("Blizzard")

--[[
		Move alt power bar
--]]
B.PositionAltPowerBar = function(self)
	local holder = CreateFrame("Frame", "AltPowerBarHolder")
	holder:Point("TOP", T.UIParent, "TOP", 0, -80)
	holder:Size(128, 50)

	PlayerPowerBarAlt:ClearAllPoints()
	PlayerPowerBarAlt:SetPoint("CENTER", holder, "CENTER")
	PlayerPowerBarAlt:SetParent(holder)
	PlayerPowerBarAlt.ignoreFramePositionManager = true

	--The Blizzard function FramePositionDelegate:UIParentManageFramePositions()
	--calls :ClearAllPoints on PlayerPowerBarAlt under certain conditions.
	--Doing ".ClearAllPoints = function() end" causes error when you enter combat.
	local function Position(self)
		self:SetPoint("CENTER", holder, "CENTER")
	end

	hooksecurefunc(PlayerPowerBarAlt, "ClearAllPoints", Position)
end
