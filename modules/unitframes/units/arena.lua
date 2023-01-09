--[[


--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")

-- Arena player frames - basically focus frames with castbars
local StyleDrae_ArenaPlayers = function(frame, unit, isSingle)
	frame:SetSize(120, 14)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	frame.Health = UF.CreateHealthBar(frame, 150, 0, 0)
	frame.Power = UF.CreatePowerBar(frame, 150)

	frame.Health.value = DraeUI.CreateFontObject(frame.Health, DraeUI.db["general"].fontsize1, DraeUI["media"].font, "RIGHT", -2, 0)

	local info = DraeUI.CreateFontObject(frame.Health, DraeUI.db["general"].fontsize0, DraeUI["media"].font, "LEFT", -2, 22)
	info:SetSize(110, 20)
	frame:Tag(info, "[drae:shortclassification][drae:unitcolour][name]")

	local level = DraeUI.CreateFontObject(frame.Health, DraeUI.db["general"].fontsize0, DraeUI["media"].font, "RIGHT", 2, 22)
	level:SetSize(40, 20)
	frame:Tag(level, "[level]")

	UF.FlagIcons(frame)

	-- Castbar
	local cb = DraeUI.db["castbar"].arena
	UF.CreateCastBar(frame, cb.width, cb.height, nil, cb.anchorat, cb.anchorto, cb.xOffset, cb.yOffset)

	-- Auras - just debuffs for target of target
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, 2, DraeUI.db["frames"].auras.auraSml, 8, "LEFT", "DOWN")
	UF.AddBuffs(frame, "TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -12, 2, DraeUI.db["frames"].auras.auraSml, 8, "RIGHT", "DOWN")

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 15)
end

oUF:RegisterStyle("DraeArenaPlayer", StyleDrae_ArenaPlayers)
