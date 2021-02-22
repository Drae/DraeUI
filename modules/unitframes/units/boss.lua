--[[


--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")

-- Boss frames - basically focus with classifications
local StyleDrae_Boss = function(frame, unit, isSingle)
	frame:SetSize(150, 14)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	UF.CreateHealthBar(frame, 150, 0, 0)
	UF.CreatePowerBar(frame, 150)
	UF.CreateUnitFrameBackground(frame)
	UF.CreateUnitFrameHighlight(frame)

	frame.Health.value = DraeUI.CreateFontObject(frame.Health, DraeUI.db["general"].fontsize1, DraeUI["media"].font, "RIGHT", -2, 0)

	local info = DraeUI.CreateFontObject(frame.Health, DraeUI.db["general"].fontsize0, DraeUI["media"].font, "LEFT", -2, 22)
	info:SetSize(140, 20)
	frame:Tag(info, "[drae:shortclassification][drae:unitcolour][name]")

	local level = DraeUI.CreateFontObject(frame.Health, DraeUI.db["general"].fontsize0, DraeUI["media"].font, "RIGHT", 2, 22)
	level:SetSize(40, 20)
	frame:Tag(level, "[level]")

	-- Castbar
	local cb = DraeUI.db["castbar"].boss
	UF.CreateCastBar(frame, cb.width, cb.height, self, cb.anchorat, cb.anchorto, cb.xOffset, cb.yOffset, true)

	-- Auras - just debuffs for target of target
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, 2, DraeUI.db["frames"].auras.auraSml, 8, "LEFT", "DOWN")
	UF.AddBuffs(frame, "TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -12, 2, DraeUI.db["frames"].auras.auraSml, 8, "RIGHT", "DOWN")

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 30)
end

oUF:RegisterStyle("DraeBoss", StyleDrae_Boss)
