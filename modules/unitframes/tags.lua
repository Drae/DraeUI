--[[


--]]
local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Localise a bunch of functions
local UnitName, UnitIsAFK, UnitIsDND, UnitPowerType = UnitName, UnitIsAFK, UnitIsDND, UnitPowerType
local UnitPlayerControlled, UnitIsTapDenied = UnitPlayerControlled, UnitIsTapDenied
local UnitIsPlayer, UnitPlayerControlled, UnitReaction = UnitIsPlayer, UnitPlayerControlled, UnitReaction
local UnitIsConnected, UnitClass = UnitIsConnected, UnitClass
local format = string.format

--[[
		Unit frame tags
--]]
oUF.Tags.Methods["drae:unitcolour"] = function(u, r)
	local reaction = UnitReaction(u, "player")

	if (not UnitPlayerControlled(u) and UnitIsTapDenied(u)) then
		return T.Hex(oUF.colors.tapped)
	elseif (not UnitIsConnected(u)) then
		return T.Hex(oUF.colors.disconnected)
	elseif (UnitIsPlayer(u)) then
		local _, class = UnitClass(u)
		return T.Hex(oUF.colors.class[class])
	elseif reaction then
		return T.Hex(oUF.colors.reaction[reaction])
	else
		return T.Hex(oUF.colors.health)
	end
end
oUF.Tags.Events["drae:unitcolour"] = "UNIT_FACTION UNIT_ENTERED_VEHICLE UNIT_EXITED_VEHICLE UNIT_PET"

oUF.Tags.Methods["drae:afk"] = function(u)
	if (UnitIsAFK(u)) then
		return "|cffff0000 AFK -|r"
	elseif (UnitIsDND(u)) then
		return "|cffff0000 DND -|r"
	end
end
oUF.Tags.Events["drae:afk"] = "PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods["drae:power"] = function(u, t)
	local _, str = UnitPowerType(u)
	--	return ("%s%s|r"):format(T.Hex(oUF.colors.power[str] or {1, 1, 1}), T.ShortVal(oUF.Tags.Methods["curpp"](u)))
	return ("|cffffffff%s|r"):format(T.ShortVal(oUF.Tags.Methods["curpp"](u)))
end
oUF.Tags.Events["drae:power"] = "UNIT_POWER UNIT_MAXPOWER"

oUF.Tags.Methods["draeraid:name"] = function(u, r)
	local name = UnitName(r or u) or "Unknown"

	return T.UTF8(name, T.db["raidframes"].raidnamelength or 4, false) .. "|r"
end
oUF.Tags.Events["draeraid:name"] = "UNIT_NAME_UPDATE UNIT_ENTERED_VEHICLE UNIT_EXITED_VEHICLE UNIT_PET"

oUF.Tags.Methods["drae:shortclassification"] = function(u)
	local c = UnitClassification(u)
	if (c == "rare") then
		return "[R] "
	elseif (c == "minus") then
		return "[-] "
	end
end
oUF.Tags.Events["drae:shortclassification"] = "UNIT_CLASSIFICATION_CHANGED"
