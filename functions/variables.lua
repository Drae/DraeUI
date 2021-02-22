--[[


--]]
local DraeUI = select(2, ...)

-- Localize some vars
local match = string.match

-- "Constants"
DraeUI.playerClass = select(2, UnitClass("player"))
DraeUI.playerName = UnitName("player")
DraeUI.playerRealm = GetRealmName()
DraeUI.playerGuid = UnitGUID("player")

DraeUI.screenHeight = floor(GetScreenHeight()*100+.5)/100
DraeUI.screenWidth = floor(GetScreenWidth()*100+.5)/100
DraeUI.uiScale = tonumber(GetCVar("uiScale"))
