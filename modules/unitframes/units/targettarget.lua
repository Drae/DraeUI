--[[


--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Target of target frame
local StyleDrae_TargetTarget = function(frame, unit, isSingle)
	frame:SetSize(150, 14)
	frame:SetFrameStrata("LOW")

	UF.CommonInit(frame)

	local arrow = frame:CreateTexture(nil, "BACKGROUND", nil, 0)
	arrow:SetSize(14, 30)
	arrow:SetPoint("RIGHT", frame, "LEFT", -5, -2)
	arrow:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\targetArrow")

	frame.Health = UF.CreateHealthBar(frame, 150, 0, 0)
	frame.Power = UF.CreatePowerBar(frame, 150)

	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "RIGHT", 2, 15)

	local info = T.CreateFontObject(frame.Health, T.db["general"].fontsize1, T["media"].font, "LEFT", -2, 15)
	info:SetSize(95, 20)
	frame:Tag(info, "[drae:shortclassification][drae:unitcolour][name]")

--	local level = T.CreateFontObject(frame.Health, T.db["general"].fontsize0, T["media"].font, "RIGHT", 2, 22)
--	level:SetSize(40, 20)
--	frame:Tag(level, "[level]")

	-- Auras - just debuffs for target of target
	UF.AddDebuffs(frame, "TOPRIGHT", frame.Power, "BOTTOMRIGHT", 0, -12, T.db["frames"].auras.maxTargetDebuff or 15, T.db["frames"].auras.auraSml, 8, "LEFT", "DOWN")

	-- The number here is the size of the raid icon
	UF.CommonPostInit(frame, 30)
end

oUF:RegisterStyle("DraeTargetTarget", StyleDrae_TargetTarget)
