--[[


--]]
local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Player frame
local StyleDrae_Player = function(frame, unit, isSingle)
	frame:SetSize(250, 14)
	--	frame:SetHitRectInsets(0, 0, 23, 23)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	frame.Sword = frame.Health

	frame.Health = UF.CreateHealthBar(frame, 250, 0, 0)
	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "RIGHT", 2, 15)
	frame.Power = UF.CreatePowerBar(frame, 250)
	frame.AdditionalPower = UF.CreateAdditionalPower(frame, 250, 3)

	local level = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "LEFT", -2, 15)
	level:SetSize(40, 20)
	frame:Tag(level, "[level]")

	UF.FlagIcons(frame)

	-- Combat icon
	local combat = frame.Health:CreateTexture(nil, "OVERLAY")
	combat:SetSize(18, 18)
	combat:SetPoint("BOTTOMRIGHT", portrait, 0, -5)
	combat:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
	combat:SetTexCoord(0.58, 0.90, 0.08, 0.41)
	frame.CombatIndicator = combat

	-- Auras
	UF.AddLongBuffs(frame, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 20)
	UF.AddBuffs(
		frame,
		"TOPLEFT",
		frame.Power,
		"BOTTOMLEFT",
		0,
		-12,
		T.db["frames"].auras.maxPlayerBuff or 4,
		T.db["frames"].auras.auraLrg,
		8,
		"RIGHT",
		"DOWN"
	)
	UF.AddDebuffs(
		frame,
		"TOPRIGHT",
		frame.Power,
		"BOTTOMRIGHT",
		0,
		-12,
		T.db["frames"].auras.maxPlayerDebuff or 15,
		T.db["frames"].auras.auraSml,
		8,
		"LEFT",
		"DOWN"
	)

	-- Castbars
	local cbp = T.db["castbar"].player
	UF.CreateCastBar(
		frame,
		cbp.width,
		cbp.height,
		cbp.anchor,
		cbp.anchorat,
		cbp.anchorto,
		cbp.xOffset,
		cbp.yOffset,
		T.db["castbar"].showLatency,
		false
	)

	UF.CreateMirrorCastbars(frame)

	--[[

	]]
	UF.CreateTotemBar(frame, "TOP", portrait, "BOTTOM", 0, -12)
end

oUF:RegisterStyle("DraePlayer", StyleDrae_Player)
