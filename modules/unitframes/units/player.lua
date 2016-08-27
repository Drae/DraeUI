--[[


--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Player frame
local StyleDrae_Player = function(frame, unit, isSingle)
	frame:Size(320, 70)
	frame:SetHitRectInsets(0, 0, 23, 23)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	local framebg = frame:CreateTexture(nil, "BACKGROUND", nil, 0)
	framebg:Size(512, 128)
	framebg:SetPoint("CENTER", frame, "CENTER")
	framebg:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\largeframe-bg")
	framebg:SetTexCoord(0, 1, 0, 0.5)

	framebg.overlay = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	framebg.overlay:Size(512, 128)
	framebg.overlay:SetPoint("CENTER", frame, "CENTER")
	framebg.overlay:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\largeframe-bg")
	framebg.overlay:SetTexCoord(0, 1, 0.5, 1)
	framebg.overlay:Hide()

	frame.Sword = framebg

	frame.Health = UF.CreateHealthBar(frame, 254, 21, 62, -22)
	frame.Power = UF.CreatePowerBar(frame, 254, 10)
	frame.AdditionalPower = UF.CreateAdditionalPower(frame, 254, 6)

	local portrait = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	portrait:Size(56, 56)
	portrait:Point("TOPLEFT", 3, -5)

	frame.Portrait = portrait

	local portraitOverlay = frame:CreateTexture(nil, "BACKGROUND", nil, 2)
	portraitOverlay:Size(62, 62)
	portraitOverlay:SetPoint("CENTER", portrait, "CENTER")
	portraitOverlay:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\targetPortraitinner")

	--[[

	]]
	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize2, T["media"].font, "RIGHT", -2, 0)

	local level = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "LEFT", 2, 22)
	level:Size(40, 20)
	frame:Tag(level, "[level]")

	--[[

	]]
	UF.FlagIcons(frame)

	-- Combat icon
	local combat = frame.Health:CreateTexture(nil, "OVERLAY")
	combat:Size(18, 18)
	combat:Point("BOTTOMRIGHT", portrait, 0, -5)
	combat:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
	combat:SetTexCoord(0.58, 0.90, 0.08, 0.41)
	frame.Combat = combat

	-- Auras
	UF.AddBuffs(frame, "TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -12, T.db["frames"].auras.maxPlayerBuff or 4, T.db["frames"].auras.auraLrg, 8, "RIGHT", "DOWN")
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, T.db["frames"].auras.maxPlayerDebuff or 15, T.db["frames"].auras.auraSml, 8, "LEFT", "DOWN")

	-- Castbars
	local cbp = T.db["castbar"].player
	UF.CreateCastBar(frame, cbp.width, cbp.height, cbp.anchor, cbp.anchorat, cbp.anchorto, cbp.xOffset, cbp.yOffset, T.db["castbar"].showLatency, false)

	UF.CreateMirrorCastbars(frame)

	--[[

	]]
	UF.CreateTotemBar(frame, "TOP", portrait, "BOTTOM", 0, -12)

	-- Class specific resource bars
	UF.CreateMageClassBar(frame, "CENTER", frame.Castbar, "CENTER", 0, -14)
	UF.CreatePaladinClassBar(frame, "CENTER", frame.Castbar, "CENTER", 0, -10)
--[[
	UF.CreateDeathknightBar(frame, "CENTER", frame.Castbar, "CENTER", rbp.xOffset, rbp.yOffset)
	UF.CreateDemonhunterBar(frame, "CENTER", frame.Castbar, "CENTER", rbp.xOffset, rbp.yOffset)
	UF.CreateDruidBar(frame, "CENTER", frame.Castbar, "CENTER", rbp.xOffset, rbp.yOffset)
	UF.CreateMonkBar(frame, "CENTER", frame.Castbar, "CENTER", rbp.xOffset, rbp.yOffset)
	UF.CreateRogueBar(frame, "CENTER", frame.Castbar, "CENTER", rbp.xOffset, rbp.yOffset)
	UF.CreateWarlockBar(frame, "CENTER", frame.Castbar, "CENTER", rbp.xOffset, rbp.yOffset)
]]
end

oUF:RegisterStyle("DraePlayer", StyleDrae_Player)
