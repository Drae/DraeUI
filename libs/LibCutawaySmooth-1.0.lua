--[[

]]
--[[
Functions:

]]

local MAJOR = "LibCutawaySmooth-1.0"
local MINOR = 1

local lib, upgrade = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

lib.frame = lib.frame or CreateFrame("Frame")
lib.bars = lib.bars or {}

-------------------------------------------------------------------------------

local abs = math.abs
local smoother, smoothing, num_smoothing = nil, {}, 0
local FADEFRAMES = {}

local frameIsFading = function(frame)
	for index, value in pairs(FADEFRAMES) do
		if value == frame then
			return true
		end
	end
end

local FrameFadeRemoveFrame = function(frame)
	tDeleteItem(FADEFRAMES, frame)
end

local FrameFadeOnUpdate = function(self, elapsed)
	local frame, info
	for index, value in pairs(FADEFRAMES) do
		frame, info = value, value.fadeInfo

		if info.startDelay and info.startDelay > 0 then
			info.startDelay = info.startDelay - elapsed
		else
			info.fadeTimer = (info.fadeTimer and info.fadeTimer + elapsed) or 0

			if info.fadeTimer < info.timeToFade then
				-- perform animation in either direction
				if info.mode == "IN" then
					frame:SetAlpha(
						(info.fadeTimer / info.timeToFade) *
						(info.endAlpha - info.startAlpha) +
						info.startAlpha
					)
				elseif info.mode == "OUT" then
					frame:SetAlpha(
						((info.timeToFade - info.fadeTimer) / info.timeToFade) *
						(info.startAlpha - info.endAlpha) + info.endAlpha
					)
				end
			else
				-- animation has ended
				frame:SetAlpha(info.endAlpha)

				if info.fadeHoldTime and info.fadeHoldTime > 0 then
					info.fadeHoldTime = info.fadeHoldTime - elapsed
				else
					FrameFadeRemoveFrame(frame)

					if info.finishedFunc then
						info.finishedFunc(frame)
						info.finishedFunc = nil
					end
				end
			end
		end
	end

	if #FADEFRAMES == 0 then
		self:SetScript("OnUpdate", nil)
	end
end
--[[
	info = {
		mode            = "IN" (nil) or "OUT",
		startAlpha      = alpha value to start at,
		endAlpha        = alpha value to end at,
		timeToFade      = duration of animation,
		startDelay      = seconds to wait before starting animation,
		fadeHoldTime    = seconds to wait after ending animation before calling finishedFunc,
		finishedFunc    = function to call after animation has ended,
	}

	If you plan to reuse `info`, it should be passed as a single table,
	NOT a reference, as the table will be directly edited.
]]
local FrameFade = function(frame, info)
	if not frame then return end

	if frameIsFading(frame) then
		-- cancel the current operation
		-- the code calling this should make sure not to interrupt a
		-- necessary finishedFunc. This will entirely skip it.
		FrameFadeRemoveFrame(frame)
	end

	info        = info or {}
	info.mode   = info.mode or "IN"

	if info.mode == "IN" then
		info.startAlpha = info.startAlpha or 0
		info.endAlpha   = info.endAlpha or 1
	elseif info.mode == "OUT" then
		info.startAlpha = info.startAlpha or 1
		info.endAlpha   = info.endAlpha or 0
	end

	frame:SetAlpha(info.startAlpha)
	frame.fadeInfo = info

	tinsert(FADEFRAMES, frame)
	lib.frame:SetScript("OnUpdate", FrameFadeOnUpdate)
end

local ClearBar = function(bar)
	if smoothing[bar] then
		num_smoothing = num_smoothing - 1
		smoothing[bar] = nil
	end

	if num_smoothing <= 0 then
		num_smoothing = 0
		smoother:Hide()
	end
end

local SmootherOnUpdate = function(bar)
	local limit = 10 / GetFramerate()

	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value - cur) / 3, max(value - cur, limit))

		if cur == value or abs(new - value) < .5 then
			bar:orig_anim_SetValue(value)
			ClearBar(bar)
		else
			bar:orig_anim_SetValue(new)
		end
	end
end

local SmoothBar = function(bar, value)
	if not smoothing[bar] then
		num_smoothing = num_smoothing + 1
	end

	smoothing[bar] = value
	smoother:Show()
end

local ClearAnimation = function(bar)
	if smoother and smoothing[bar] then
		ClearBar(bar)
	end

	if not bar.barFader then return end

	FrameFadeRemoveFrame(bar.barFader)
	bar.barFader:SetAlpha(0)
end

local SetStatusBarColor = function(self,...)
	self:orig_anim_SetStatusBarColor(...)
	self.barFader:SetVertexColor(...)
end

local SetValueAnimate = function(self, value)
	if not self:IsVisible() then
		-- passthrough initial calls
		self:orig_anim_SetValue(value)
		return
	end

	if value < self:GetValue() then
		if not frameIsFading(self.barFader) then
			ClearBar(self)

			if (self.barFader.orientation == "HORIZONTAL") then
				if (self.barFader.reversefill) then
					self.barFader:SetPoint("LEFT", self, "RIGHT", -((self:GetValue()  / select(2, self:GetMinMaxValues())) * self:GetWidth()), 0)
				else
					self.barFader:SetPoint("RIGHT", self, "LEFT", ((self:GetValue() / select(2, self:GetMinMaxValues())) * self:GetWidth()), 0)
				end
			else
				if (self.barFader.reversefill) then
					self.barFader:SetPoint("BOTTOM", self, "TOP", 0, -((self:GetValue()  / select(2, self:GetMinMaxValues())) * self:GetHeight()))
				else
					self.barFader:SetPoint("TOP", self, "BOTTOM", 0, ((self:GetValue() / select(2, self:GetMinMaxValues())) * self:GetHeight()))
				end
			end

			-- store original rightmost value
			self.barFader.right = self:GetValue()

			FrameFade(self.barFader, {
				mode = "OUT",
				timeToFade = .2
			})
		end
	end

	if self.barFader.right and value > self.barFader.right then
		-- stop animation if new value overlaps old end point
		FrameFadeRemoveFrame(self.barFader)
		self.barFader:SetAlpha(0)
	end

	if value == self:GetValue() then
		ClearBar(self)
	elseif (value > self:GetValue()) then
		SmoothBar(self, value)

		return
	end

	self:orig_anim_SetValue(value)
end

function lib:ResetBarAnimation(bar)
	ClearAnimation(bar)

	bar.SetValue = bar.orig_anim_SetValue
	bar.orig_anim_SetValue = nil
	bar.SetStatusBarColor = bar.orig_anim_SetStatusBarColor
	bar.orig_anim_SetStatusBarColor = nil

	bar.barFader = nil
end

function lib:EnableBarAnimation(bar)
	if bar.animation then
		-- disable current animation
		lib.ResetBarAnimation(bar)
	end

	if not smoother then
		smoother = CreateFrame("Frame")
		smoother:Hide()
		smoother:SetScript("OnUpdate",SmootherOnUpdate)
	end

	local fader = bar:CreateTexture(nil, "ARTWORK", nil, 7)
	fader:SetTexture("interface/buttons/white8x8")
	fader:SetAlpha(0)

	fader.reversefill = bar:GetReverseFill()
	fader.orientation = bar:GetOrientation()

	if (fader.orientation == "HORIZONTAL") then
		fader:SetPoint("TOP")
		fader:SetPoint("BOTTOM")

		if (fader.reversefill) then
			fader:SetPoint("RIGHT", bar:GetStatusBarTexture(), "LEFT")
		else
			fader:SetPoint("LEFT", bar:GetStatusBarTexture(), "RIGHT")
		end
	else
		fader:SetPoint("LEFT")
		fader:SetPoint("RIGHT")

		if (fader.reversefill) then
			fader:SetPoint("TOP", bar:GetStatusBarTexture(), "BOTTOM")
		else
			fader:SetPoint("BOTTOM", bar:GetStatusBarTexture(), "TOP")
		end
	end

	bar.orig_anim_SetValue = bar.SetValue
	bar.SetValue = SetValueAnimate
	bar.orig_anim_SetStatusBarColor = bar.SetStatusBarColor
	bar.SetStatusBarColor = SetStatusBarColor

	bar.barFader = fader

	if not bar.animation then
		tinsert(lib.bars, bar)
	end

	bar.animation = true
end

function lib:DisableBarAnimation(bar)
	if lib.bars and #lib.bars > 0 then
		for i, a_bar in ipairs(lib.bars) do
			if bar == a_bar then
				tremove(lib.bars,i)
				FrameFadeRemoveFrame(bar.barFader)
			end
		end
	end

	return
end

