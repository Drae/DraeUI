--[[


--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Player frame
local StyleDrae_Player = function(frame, unit, isSingle)
	frame:SetSize(320, 70)
	frame:SetHitRectInsets(0, 0, 23, 23)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	local framebg = frame:CreateTexture(nil, "BACKGROUND", nil, 0)
	framebg:SetSize(512, 128)
	framebg:SetPoint("CENTER", frame, "CENTER")
	framebg:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\largeframe-bg")
	framebg:SetTexCoord(0, 1, 0, 0.5)

	framebg.overlay = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	framebg.overlay:SetSize(512, 128)
	framebg.overlay:SetPoint("CENTER", frame, "CENTER")
	framebg.overlay:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\largeframe-bg")
	framebg.overlay:SetTexCoord(0, 1, 0.5, 1)
	framebg.overlay:Hide()

	frame.Sword = framebg

	frame.Health = UF.CreateHealthBar(frame, 250, 16, 62, -23)
	frame.Power = UF.CreatePowerBar(frame, 250, 5)
	frame.AdditionalPower = UF.CreateAdditionalPower(frame, 250, 3)

	local portrait = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	portrait:SetSize(56, 56)
	portrait:SetPoint("TOPLEFT", 3, -5)

	frame.Portrait = portrait

	local portraitOverlay = frame:CreateTexture(nil, "BACKGROUND", nil, 2)
	portraitOverlay:SetSize(62, 62)
	portraitOverlay:SetPoint("CENTER", portrait, "CENTER")
	portraitOverlay:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\targetPortraitinner")

	--[[

	]]
	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize2, T["media"].font, "RIGHT", -2, 0)

	local level = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "LEFT", 2, 22)
	level:SetSize(40, 20)
	frame:Tag(level, "[level]")

	--[[

	]]
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
	UF.AddBuffs(frame, "TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -12, T.db["frames"].auras.maxPlayerBuff or 4, T.db["frames"].auras.auraLrg, 8, "RIGHT", "DOWN")
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, T.db["frames"].auras.maxPlayerDebuff or 15, T.db["frames"].auras.auraSml, 8, "LEFT", "DOWN")

	-- Castbars
	local cbp = T.db["castbar"].player
	UF.CreateCastBar(frame, cbp.width, cbp.height, cbp.anchor, cbp.anchorat, cbp.anchorto, cbp.xOffset, cbp.yOffset, T.db["castbar"].showLatency, false)

	UF.CreateMirrorCastbars(frame)

	--[[

	]]
	UF.CreateTotemBar(frame, "TOP", portrait, "BOTTOM", 0, -12)
end

oUF:RegisterStyle("DraePlayer", StyleDrae_Player)
