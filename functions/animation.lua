--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local random = math.random

function T:SetUpAnimGroup(object, type, ...)
	if not type then type = 'Flash' end

	if type == 'Flash' then
		object.anim = object:CreateAnimationGroup("Flash")
		object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
		object.anim.fadein:SetFromAlpha(0)
        object.anim.fadein:SetToAlpha(1)
		object.anim.fadein:SetOrder(2)

		object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
		object.anim.fadeout:SetFromAlpha(1)
        object.anim.fadeout:SetToAlpha(0)
		object.anim.fadeout:SetOrder(1)
	elseif type == 'FlashLoop' then
		object.anim = object:CreateAnimationGroup("Flash")
		object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
		object.anim.fadein:SetFromAlpha(0)
        object.anim.fadein:SetToAlpha(1)
		object.anim.fadein:SetOrder(2)

		object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
		object.anim.fadeout:SetFromAlpha(1)
        object.anim.fadeout:SetToAlpha(0)
		object.anim.fadeout:SetOrder(1)

		object.anim:SetScript("OnFinished", function(self, requested)
			if(not requested) then
				object.anim:Play()
			end
		end)
	else
		local x, y, duration, customName = ...
		if not customName then
			customName = 'anim'
		end
		object[customName] = object:CreateAnimationGroup("Move_In")
		object[customName].in1 = object[customName]:CreateAnimation("Translation")
		object[customName].in1:SetDuration(0)
		object[customName].in1:SetOrder(1)
		object[customName].in2 = object[customName]:CreateAnimation("Translation")
		object[customName].in2:SetDuration(duration)
		object[customName].in2:SetOrder(2)
		object[customName].in2:SetSmoothing("OUT")
		object[customName].out1 = object:CreateAnimationGroup("Move_Out")
		object[customName].out2 = object[customName].out1:CreateAnimation("Translation")
		object[customName].out2:SetDuration(duration)
		object[customName].out2:SetOrder(1)
		object[customName].out2:SetSmoothing("IN")
		object[customName].in1:SetOffset(T:Scale(x), T:Scale(y))
		object[customName].in2:SetOffset(T:Scale(-x), T:Scale(-y))
		object[customName].out2:SetOffset(T:Scale(x), T:Scale(y))
		object[customName].out1:SetScript("OnFinished", function() object:Hide() end)
	end
end

function T:Flash(object, duration, loop)
	if not object.anim then
		T:SetUpAnimGroup(object, loop and "FlashLoop" or 'Flash')
	end

	if not object.anim.playing then
		object.anim.fadein:SetDuration(duration)
		object.anim.fadeout:SetDuration(duration)
		object.anim:Play()
		object.anim.playing = true
	end
end

function T:StopFlash(object)
	if object.anim and object.anim.playing then
		object.anim:Stop()
		object.anim.playing = nil
	end
end

