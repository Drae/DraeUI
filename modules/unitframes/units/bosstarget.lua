--[[


--]]

local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Boss frames - basically focus with classifications
local StyleDrae_BossTarget = function(frame, unit, isSingle)
	UF.CommonInit(frame)

	frame.healthHeight = T.db["frames"].smallHeight - 4.25 -- spacing
	frame.Health = UF.CreateHealthBar(frame, frame.healthHeight)
	frame.Health.value = T.CreateFontObject(frame.Health, T.db["general"].fontsize2, T["media"].font, "RIGHT", -4, 12)
	frame.Power = UF.CreatePowerBar(frame, 3)

	local info = T.CreateFontObject(frame.Health, T.db["general"].fontsize2, T["media"].font, "LEFT", 4, -13)
	info:Size(T.db["frames"].smallWidth - 4, 20)
	frame:Tag(info, "[level] [drae:unitcolour][name]")

	UF.CommonPostInit(frame, 20)

	if (isSingle) then
		frame:Size(T.db["frames"].mediumWidth, T.db["frames"].mediumHeight)
	end
end

oUF:RegisterStyle("DraeBoss", StyleDrae_BossTarget)
