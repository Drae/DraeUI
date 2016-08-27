--[[


--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Pet frame - this is the same as focus but we do this seperately so we can colour by happiness
local StyleDrae_Pet = function(frame, unit, isSingle)
	frame:Size(150, 47)
	frame:SetHitRectInsets(0, 0, 0, 23)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	frame.Health = UF.CreateHealthBar(frame, 150, 21, 0, 1)
	frame.Health.colorClassPet = true -- else colour by creature type
	frame.Health.colorReaction = false -- but don"t colour by reaction

	frame.Power = UF.CreatePowerBar(frame, 150, 7)

	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "RIGHT", -2, 0)

	local info = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "LEFT", -2, 22)
	info:Size(110, 20)
	frame:Tag(info, "[drae:shortclassification][drae:unitcolour][name]")

	local level = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "RIGHT", 2, 22)
	level:Size(40, 20)
	frame:Tag(level, "[level]")

	-- Auras - just debuffs for target of target
	UF.AddBuffs(frame, "TOPLEFT", frame, "BOTTOMLEFT", -1, -17, T.db["frames"].auras.maxPetBuff or 2, T.db["frames"].auras.auraTny, 10, "RIGHT", "DOWN")
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, T.db["frames"].auras.maPetDebuff or 15, T.db["frames"].auras.auraSml, 8, "LEFT", "DOWN")

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 30)
end

oUF:RegisterStyle("DraePet", StyleDrae_Pet)
