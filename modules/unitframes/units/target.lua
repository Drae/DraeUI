--[[


--]]
local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Target frame
local StyleDrae_Target = function(frame, unit, isSingle)
	frame:SetSize(260, 14)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	UF.CreateHealthBar(frame, 260, 0, 0)
	UF.CreatePowerBar(frame, 260)
	UF.CreateUnitFrameBackground(frame)
	UF.CreateUnitFrameHighlight(frame)

	frame.Health.value = T.CreateFontObject(frame, T.db["general"].fontsize1, T["media"].font, "LEFT", -2, 15)

	local level = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "RIGHT", 2, 15)
	level:SetSize(190, 20)
	frame:Tag(level, "[drae:afk] [drae:shortclassification][drae:unitcolour][name]|r | [level]")

	-- Dragon texture on rare/elite
	frame.Classification = {}

	-- Flags for PvP, leader, etc.
	UF.FlagIcons(frame, true)

	-- Auras
	UF.AddBuffs(frame, "TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -12, T.db["frames"].auras.maxTargetBuff or 8, T.db["frames"].auras.auraLrg, 8, "RIGHT", "DOWN")
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, T.db["frames"].auras.maxTargetDebuff or 6, T.db["frames"].auras.auraSml, 8, "LEFT", "DOWN")

	-- Castbar
	local cb = T.db["castbar"].target
	UF.CreateCastBar(frame, cb.width, cb.height, cb.anchor, cb.anchorat, cb.anchorto, cb.xOffset, cb.yOffset, true)

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 30)
end

oUF:RegisterStyle("DraeTarget", StyleDrae_Target)
