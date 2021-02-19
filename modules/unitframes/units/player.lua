--[[


--]]
local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Player frame
local StyleDrae_Player = function(frame, unit, isSingle)
	frame:SetSize(260, 14)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	UF.CreateHealthBar(frame, 260, 0, 0)
	UF.CreatePowerBar(frame, 260)
	UF.CreateAdditionalPower(frame, 260)
	UF.CreateUnitFrameBackground(frame)
	UF.CreateUnitFrameHighlight(frame)

	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "RIGHT", 2, 15)

	local level = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "LEFT", -2, 15)
	level:SetSize(40, 20)
	frame:Tag(level, "[level]")

	-- Combat icon
	local combat = frame.Health:CreateTexture(nil, "OVERLAY")
	combat:SetSize(18, 18)
	combat:SetPoint("BOTTOMRIGHT", frame, 10, -10)
	combat:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
	combat:SetTexCoord(0.58, 0.90, 0.08, 0.41)
	frame.CombatIndicator = combat

	UF.FlagIcons(frame.Health)

	-- Auras
	UF.AddLongBuffs(frame, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 20)
	UF.AddWeaponEnchants(frame, -24, 0) -- Anchored to Long Buffs
	UF.AddBuffs(frame, "TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -12, T.db["frames"].auras.maxPlayerBuff or 8, T.db["frames"].auras.auraSml, 8, "RIGHT",	"DOWN")
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, T.db["frames"].auras.maxPlayerDebuff or 6, T.db["frames"].auras.auraLrg, 8, "LEFT", "DOWN")

	UF.CreateTotemBar(frame, "RIGHT", frame, "LEFT", -12, 0)

	-- Castbars
	local cbp = T.db["castbar"].player
	UF.CreateCastBar(frame, cbp.width, cbp.height, cbp.anchor, cbp.anchorat, cbp.anchorto, cbp.xOffset, cbp.yOffset, T.db["castbar"].showLatency, false)

	UF.CreateMirrorCastbars(frame)

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 30)
end

oUF:RegisterStyle("DraePlayer", StyleDrae_Player)
