--[[


--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")

-- Target of target frame
local StyleDrae_FocusTarget = function(frame, unit, isSingle)
	frame:SetSize(150, 14)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	UF.CreateHealthBar(frame, 150, 0, 0)
	UF.CreatePowerBar(frame, 150)
	UF.CreateUnitFrameBackground(frame)
	UF.CreateUnitFrameHighlight(frame)
	UF.CreateTargetArrow(frame)

	frame.Health.value = DraeUI.CreateFontObject(frame.Health, DraeUI.db["general"].fontsize1, DraeUI["media"].font, "RIGHT", 2, 15)

	local info = DraeUI.CreateFontObject(frame.Health, DraeUI.db["general"].fontsize1, DraeUI["media"].font, "LEFT", -2, 15)
	info:SetSize(95, 20)
	frame:Tag(info, "[drae:shortclassification][drae:unitcolour][name]")

	-- Auras - just debuffs for target of target
	UF.AddBuffs(frame, "TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -12, DraeUI.db["frames"].auras.maxFocusTargetBuff or 15, DraeUI.db["frames"].auras.auraSml, 8, "RIGHT", "DOWN")

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 30)
end

oUF:RegisterStyle("DraeFocusTarget", StyleDrae_FocusTarget)
