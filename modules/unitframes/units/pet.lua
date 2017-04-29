--[[


--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Pet frame - this is the same as focus but we do this seperately so we can colour by happiness
local StyleDrae_Pet = function(frame, unit, isSingle)
	frame:SetSize(120, 47)
	frame:SetHitRectInsets(0, 0, 0, 23)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	frame.Health = UF.CreateHealthBar(frame, 120, 16, 0, 0)
	frame.Power = UF.CreatePowerBar(frame, 120, 5)

	frame.Health.colorClassPet = false
	frame.Health.colorReaction = false

	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "RIGHT", -2, 0)

	local info = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "LEFT", -2, 22)
	info:SetSize(95, 20)
	frame:Tag(info, "[drae:shortclassification][drae:unitcolour][name]")

	local level = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "RIGHT", 2, 22)
	level:SetSize(40, 20)
	frame:Tag(level, "[level]")

	-- Auras - just debuffs for target of target
	UF.AddBuffs(frame, "BOTTOMLEFT", frame.Health, "TOPLEFT", 1, 28, T.db["frames"].auras.maxPetBuff or 2, T.db["frames"].auras.auraTny, 10, "RIGHT", "UP")
	UF.AddDebuffs(frame, "BOTTOMRIGHT", frame.Health, "TOPRIGHT", -1, 28, T.db["frames"].auras.maPetDebuff or 4, T.db["frames"].auras.auraSml, 8, "LEFT", "UP")

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 30)
end

oUF:RegisterStyle("DraePet", StyleDrae_Pet)
