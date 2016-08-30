--[[


--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Target frame
local StyleDrae_Target = function(frame, unit, isSingle)

	frame:Size(320, 70)
	frame:SetHitRectInsets(0, 0, 23, 23)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	local framebg = frame:CreateTexture(nil, "BACKGROUND", nil, 0)
	framebg:Size(512, 128)
	framebg:SetPoint("CENTER", frame, "CENTER")
	framebg:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\largeframe-bg")
	framebg:SetTexCoord(1, 0, 0, 0.5)

	framebg.overlay = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	framebg.overlay:Size(512, 128)
	framebg.overlay:SetPoint("CENTER", frame, "CENTER")
	framebg.overlay:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\largeframe-bg")
	framebg.overlay:SetTexCoord(1, 0, 0.5, 1)
	framebg.overlay:Hide()

	frame.Sword = framebg

	frame.Health = UF.CreateHealthBar(frame, 250, 16, -62, -23, true, true)
	frame.Power = UF.CreatePowerBar(frame, 250, 5, true, true)

	local portrait = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	portrait:Size(56, 56)
	portrait:Point("TOPRIGHT", -3, -5)

	frame.Portrait = portrait

	local portraitOverlay = frame:CreateTexture(nil, "BACKGROUND", nil, 2)
	portraitOverlay:Size(68, 68)
	portraitOverlay:Point("CENTER", portrait, "CENTER")
	portraitOverlay:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\targetPortraitinner")

	-- Dragon texture on rare/elite
	frame.Classification = {}

	local dragonElite = frame:CreateTexture(nil, "BACKGROUND", nil, 3)
	dragonElite:Size(128, 128)
	dragonElite:SetPoint("CENTER", portrait, "CENTER")
	dragonElite:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\target-elite")
	dragonElite:SetTexCoord(1, 0, 0, 1)
	dragonElite:Hide()
	frame.Classification.elite = dragonElite

	local dragonRare = frame:CreateTexture(nil, "BACKGROUND", nil, 3)
	dragonRare:Size(128, 128)
	dragonRare:SetPoint("CENTER", portrait, "CENTER")
	dragonRare:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\target-rare")
	dragonRare:SetTexCoord(1, 0, 0, 1)
	dragonRare:Hide()
	frame.Classification.rare = dragonRare

	--[[

	]]
	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize2, T["media"].font, "LEFT", 2, 0)

	local info = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "LEFT", 2, 22)
	info:Size(210, 20)
	frame:Tag(info, "[drae:shortclassification][drae:unitcolour][name][drae:afk]")

	local level = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "RIGHT", -2, 22)
	level:Size(40, 20)
	frame:Tag(level, "[level]")

	-- Flags for PvP, leader, etc.
	UF.FlagIcons(frame, true)

	-- Auras
	UF.AddBuffs(frame, "TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -12, T.db["frames"].auras.maxTargetBuff or 4, T.db["frames"].auras.auraLrg, 8, "RIGHT", "DOWN")
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, T.db["frames"].auras.maxTargetDebuff or 15, T.db["frames"].auras.auraSml, 8, "LEFT", "DOWN")

	-- Castbar
	local cb = T.db["castbar"].target
	UF.CreateCastBar(frame, cb.width, cb.height, cb.anchor, cb.anchorat, cb.anchorto, cb.xOffset, cb.yOffset, true)

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 30)
end

oUF:RegisterStyle("DraeTarget", StyleDrae_Target)
