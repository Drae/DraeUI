--[[


--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Boss frames - basically focus with classifications
local StyleDrae_Boss = function(frame, unit, isSingle)
	UF.CommonInit(frame)

	frame.healthHeight = T.db["frames"].smallHeight - 4.25 -- spacing
	frame.Health = UF.CreateHealthBar(frame, frame.healthHeight)
	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize2, T["media"].font, "RIGHT", -4, 12)
	frame.Power = UF.CreatePowerBar(frame, 3)

	-- Dragon texture on rare/elite
	frame.Classification = {}
	local cl = CreateFrame("Frame", nil, frame)
	cl:Size(70, 70)
	cl:Point("TOPLEFT", frame.Health, "TOPRIGHT", -38, 22)

	local dragonElite = cl:CreateTexture(nil, "OVERLAY")
	dragonElite:SetAllPoints(cl)
	dragonElite:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\EliteLeft")
	frame.Classification.elite = dragonElite

	local info = T.CreateFontObject(frame.Health, T.db["general"].fontsize2, T["media"].font, "LEFT", 4, -13)
	info:Size(T.db["frames"].smallWidth - 4, 20)
	frame:Tag(info, "[level] [drae:unitcolour][name]")

	UF.CommonPostInit(frame, 20)

	-- Auras
	if (T.db["frames"].auras.showBuffsOnBoss and T.db["frames"].auras.showBuffsOnEnemies) then
		UF.AddBuffs(frame, "TOPRIGHT", frame, "TOPLEFT", -12, 1, T.db["frames"].auras.maxBossBuff or 1, T.db["frames"].auras.auraSml, 10, "LEFT", "DOWN")
	end

	if (isSingle) then
		frame:Size(T.db["frames"].mediumWidth, T.db["frames"].mediumHeight)
	end
end

oUF:RegisterStyle("DraeBoss", StyleDrae_Boss)
