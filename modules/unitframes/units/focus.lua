--[[


--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Focus is a common frame type used for most other frames inc. pet, pettarget, etc.
local StyleDrae_Focus = function(frame, unit, isSingle)
	frame:SetSize(150, 14)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	UF.CreateHealthBar(frame, 150, 0, 0)
	UF.CreatePowerBar(frame, 150)
	UF.CreateUnitFrameBackground(frame)
	UF.CreateUnitFrameHighlight(frame)

	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "LEFT", -2, 15)

	local info = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "RIGHT", 2, 15)
	info:SetSize(110, 20)
	frame:Tag(info, "[drae:shortclassification][drae:unitcolour][name]|r | [level]")

	-- Castbar
	local cb = T.db["castbar"].focus
	UF.CreateCastBar(frame, cb.width, cb.height, cb.anchor, cb.anchorat, cb.anchorto, cb.xOffset, cb.yOffset, true)

	-- Auras - just debuffs for target of target
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, T.db["frames"].auras.maxFocusDebuff or 15, T.db["frames"].auras.auraSml, 8, "LEFT", "DOWN")
	UF.AddBuffs(frame, "TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -12, T.db["frames"].auras.maxFocusBuff or 15, T.db["frames"].auras.auraSml, 8, "RIGHT", "DOWN")

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 30)
end

oUF:RegisterStyle("DraeFocus", StyleDrae_Focus)
