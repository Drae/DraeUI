--[[


--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Arena player frames - basically focus frames with castbars
local StyleDrae_ArenaPlayers = function(frame, unit, isSingle)
	frame:SetSize(120, 47)
	frame:SetHitRectInsets(0, 0, 0, 10)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	frame.Health = UF.CreateHealthBar(frame, 150, 16, 0, 0)
	frame.Power = UF.CreatePowerBar(frame, 150, 5)

	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "RIGHT", -2, 0)

	local info = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "LEFT", -2, 22)
	info:SetSize(110, 20)
	frame:Tag(info, "[drae:shortclassification][drae:unitcolour][name]")

	local level = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "RIGHT", 2, 22)
	level:SetSize(40, 20)
	frame:Tag(level, "[level]")

	UF.FlagIcons(frame)

	-- Castbar
	local cb = T.db["castbar"].arena
	UF.CreateCastBar(frame, cb.width, cb.height, self, cb.anchorat, cb.anchorto, cb.xOffset, cb.yOffset, true)

	-- Auras - just debuffs for target of target
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, T.db["frames"].auras.maxFocusDebuff or 15, T.db["frames"].auras.auraSml, 8, "LEFT", "DOWN")
	UF.AddBuffs(frame, "TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -12, T.db["frames"].auras.maxFocusBuff or 15, T.db["frames"].auras.auraSml, 8, "RIGHT", "DOWN")

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 15)
end

oUF:RegisterStyle("DraeArenaPlayer", StyleDrae_ArenaPlayers)
