--[[


--]]
local DraeUI = select(2, ...)

local IB = DraeUI:GetModule("Infobar")
local RES = IB:NewModule("Res", "AceEvent-3.0")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DraeUIRes", { type = "DraeUI", icon = nil, label = "DraeUIRes" })

--
local C_Timer, GetSpellInfo, GetSpellCharges, GetInstanceInfo, GetDifficultyInfo, GetTime = C_Timer, GetSpellInfo, GetSpellCharges, GetInstanceInfo, GetDifficultyInfo, GetTime
local mfloor, mmod, format = math.floor, mod, string.format

--[[

--]]
local UpdateTimer = function()
	local charges, maxCharges, started, duration = GetSpellCharges(20484) -- Rebirth

	if (started) then
		local time = duration - (GetTime() - started)
		local min = mfloor(time / 60)
		local sec = mmod(time, 60)

		LDB.text = format(charges == 0 and "|cffff0000%d|rres (%d:%02d)" or "|cff00ff00%d|rres (%d:%02d)", charges, min, sec)
	else
		LDB.text = format("|cff00ff000|rres (0:00)")
	end
end

do
	local is_raid, is_mythic_plus, timer_running

	RES.CheckEnableTimer = function(self, event)
		if (is_raid) then
			if (event == "ENCOUNTER_START") then
				LDB.ShowPlugin = true
				timer_running = C_Timer.NewTicker(1.0, UpdateTimer)
			elseif (event == "ENCOUNTER_END") then
				LDB.ShowPlugin = false
				if (timer_running) then
					timer_running:Cancel()
				end
			end
		else
			local _, instanceType, difficulty = GetInstanceInfo()
			local isChallengeMode = select(4, GetDifficultyInfo(difficulty))

			if (instanceType == "raid") then
				is_raid = true
			elseif (isChallengeMode) then
				is_mythic_plus = true

				LDB.ShowPlugin = true
				timer_running = C_Timer.NewTicker(1.0, UpdateTimer)
			else
				is_mythic_plus = nil
				is_raid = nil

				LDB.ShowPlugin = false
				if (timer_running) then
					timer_running:Cancel()
				end
			end
		end
	end
end

RES.OnInitialize = function(self)
	self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "CheckEnableTimer")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "CheckEnableTimer")
	self:RegisterEvent("UPDATE_INSTANCE_INFO", "CheckEnableTimer")
	self:RegisterEvent("ENCOUNTER_START", "CheckEnableTimer")
	self:RegisterEvent("ENCOUNTER_END", "CheckEnableTimer")

	self:CheckEnableTimer()
end
