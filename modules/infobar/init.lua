--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:NewModule("Infobar", "AceEvent-3.0", "AceTimer-3.0")

-- Localise a bunch of functions
local _G = _G
local IsEncounterInProgress = IsEncounterInProgress
local pairs, ipairs, format, gupper, gsub, floor, ceil, abs, mmin, type, unpack = pairs, ipairs, string.format, string.upper, string.gsub, math.floor, math.ceil, math.abs, math.min, type, unpack
local tinsert = table.insert

-- Containing frames for the infobar text
local infoBar = CreateFrame("Frame", nil, T.UIParent)
infoBar:SetFrameStrata("LOW")

IB.infoBar = infoBar

local infoBarPlugins = {}

--[[
		Calculation and display functions
--]]
IB.RegisterPlugin = function(name, callback)
	local plugin

	plugin = CreateFrame("Button", nil, infoBar)
	plugin["Text"] = T.CreateFontObject(plugin, T.db["general"].fontsize1, T["media"].font, "LEFT", 0, 0)
	plugin["Text"]:SetJustifyV("TOP")
	plugin:Size(1, 1)

	if (callback) then
		plugin.Callback = callback
	end

	plugin.SetPluginSize = function(self)
		self:Width(self["Text"]:GetStringWidth())
		self:Height(select(2, self["Text"]:GetFont()))
	end

	plugin.name = name

	infoBarPlugins[name] = plugin
end

do
	local initOrder = {"FPS", "Mem", "Latency", "Durability", "Coin", "XP", "Artifact", "Res"}

	IB.RepositionPlugins = function(self)
		local startLeft = 10
		local v_prev = nil
		local i = 1

		for _, name in pairs(initOrder) do
			if (infoBarPlugins[name]) then
				local plugin = infoBarPlugins[name]

				if (plugin:IsVisible()) then
					if (i == 1) then
						plugin:Point("BOTTOMLEFT", infoBar, startLeft, 0)
					else
						plugin:Point("BOTTOMLEFT", v_prev, "BOTTOMRIGHT", 25, 0)
					end

					v_prev = plugin
					i = i + 1
				end
			end
		end
	end
end

--[[

]]
local PlayerEnteringWorld = function()
    for name, plugin in pairs(infoBarPlugins) do
		if (plugin.Callback) then
			plugin:Callback()
		end
	end

	IB:RepositionPlugins()
end

local ValidateDataObject
do
	local function DetectType(_, name, _, _, data)
		ValidateDataObject(_, name, data)
		T:LDB_UnregisterCallback("LibDataBroker_AttributeChanged_" .. name .. "_type")
	end

	function ValidateDataObject(_, name, data)
		local type = data.type
		if type == nil then														-- Just in case type == false
			T:RegisterCallback("LibDataBroker_AttributeChanged_" .. name .. "_type", DetectType)
		elseif (type == "data source" or type == "launcher") then -- and not addon.dataObj[name]
			addon.dataObj[name], addon.pluginType[name] = data, type
			if addon.GetPluginSettings(name).enable then
				addon.CreatePlugin(name)
			else
				addon.PluginList:Add(name)
			end
		end
	end
end

--[[

]]
IB.OnInitialize = function(self)
	self.db = T.db["infobar"]
end

IB.OnEnable = function(self)
	infoBar:Point("BOTTOMLEFT", draeUI_MicroBarContainer, "BOTTOMRIGHT", 10, 6)
	infoBar:Size(T.screenWidth, 20)

	-- Do things when we enter the world
	self:RegisterEvent("PLAYER_ENTERING_WORLD", PlayerEnteringWorld)
end
