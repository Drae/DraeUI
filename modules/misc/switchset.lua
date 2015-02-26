--[[

--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local TS = T:NewModule("SwitchSet", "AceEvent-3.0")

--
local _G = _G
local GetSpecialization, UseEquipmentSet, UnitClass = GetSpecialization, UseEquipmentSet, UnitClass
local print = print

--[[

--]]
TS.ACTIVE_TALENT_GROUP_CHANGED = function()
	if (T.dbGlobal.equipSets[T.playerClass]) then
		local spec = GetSpecialization()

		if (T.dbGlobal.equipSets[T.playerClass][spec]) then
			if (UseEquipmentSet(T.dbGlobal.equipSets[T.playerClass][spec])) then
				T.Print("Switching to equipment set: ", T.dbGlobal.equipSets[T.playerClass][spec])
			end
		end
	end
end

TS.OnEnable = function(self)
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
end
