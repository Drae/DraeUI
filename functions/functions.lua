--[[


--]]
local DraeUI = select(2, ...)

-- Localise a bunch of functions
local _G = _G
local pairs, format, match, gupper, gsub, type, unpack = pairs, string.format, string.match, string.upper, string.gsub, type, unpack
local mmax, mmin, mfloor, mceil, mabs  = math.max, math.min, math.floor, math.ceil, math.abs
local UIParent, CreateFrame, ToggleDropDownMenu = UIParent, CreateFrame, ToggleDropDownMenu
local COPPER_PER_SILVER, SILVER_PER_GOLD = COPPER_PER_SILVER, SILVER_PER_GOLD

--[[
	Font functions
--]]

-- Create and set font
DraeUI.CreateFontObject = function(parent, size, font, anchorAt, oX, oY, type, anchor, anchorTo)
	local fo
	if (parent:IsObjectType("EditBox") or parent:IsObjectType("FontString")) then
		fo = parent
	else
		fo = parent:CreateFontString(nil, "OVERLAY")
	end

	fo:SetFont(font, size, type or "THINOUTLINE")

	if (anchor) then
		fo:SetPoint(anchorAt, anchor, anchorTo, oX, oY)
	else
		fo:SetJustifyH(anchorAt or "LEFT")

		if (oX or oY) then
			fo:SetPoint(anchorAt or "LEFT", oX or 0, oY or 0)
		end
	end

	return fo
end

--[[
	Math functions
--]]

-- Reduce to nearest kilo value, e.g. 1,200,00 becomes 1.2M, 1450 becomes 1.45K
DraeUI.ShortVal = function(value)
	if (mabs(value) >= 1e6) then
		return ("%.2fM"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif (mabs(value) >= 1e3 or value <= -1e3) then
		return ("%.1fK"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

-- Round to nearest integer
DraeUI.Round = function(num)
	if (num >= 0) then
		return mfloor(num + 0.5)
	else
		return mceil(num - 0.5)
	end
end

--[[
	String functions
--]]

-- UTF-8 encoding
DraeUI.UTF8 = function(str, i, dots)
	local bytes = str and str:len() or 0

	if (bytes <= i) then
		return str
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = str:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return str:sub(1, pos - 1)..(dots and "..." or "")
		else
			return str
		end
	end
end

-- Output an rgb hex string
DraeUI.Hex = function (r, g, b, a)
	if (type(r) == "table") then
		if (r.r) then
			r, g, b = r.r, r.g, r.b
		else
			r, g, b = unpack(r)
		end
	end

	return ("|c%02x%02x%02x%02x"):format((a or 1) * 255, r * 255, g * 255, b * 255)
end

-- MB or KB
DraeUI.MemFormat = function(num)
	if (num > 1024) then
		return format("%.2f MB", (num / 1024))
	else
		return format("%.1f KB", mfloor(num))
	end
end

--[[
	Colour functions
--]]

-- Smooth colour gradient between two r, g, b value
DraeUI.ColorGradient = function(perc, ...)
	if (perc > 1) then
		local r, g, b = select(select("#", ...) - 2, ...)
		return r, g, b
	elseif (perc < 0) then
		local r, g, b = ... return r, g, b
	end

	local num = select("#", ...) / 3

	local segment, relperc = math.modf(perc * (num - 1))
	local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

	return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
end

--[[
	Table/array functions
--]]

-- Search object for needle in haystack
DraeUI.Contains = function(val, table)
	for i = 1, #table do
		if (table[i] == val) then
			return true
		end
	end

	return false
end

--[[
		Print/Output
--]]

-- Print to ChatFrame1
DraeUI.Print = function(...)
	print("|cff33ff99DraeUI:|r ", ...)
end

DraeUI.Debug = function(t)
    local print_r_cache = {}

    local function sub_print_r(t, indent)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print_r(val,indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end

    if (type(t) == "table") then
        print(tostring(t).." {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end

    print()
end
