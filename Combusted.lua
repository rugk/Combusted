local start, ids, _G = -500, {}, _G
local oldGetActionCooldown = GetActionCooldown

local function hook(doHook)
	if doHook then
		function GetActionCooldown(slot)
			local startTime, duration, enable = oldGetActionCooldown(slot)
			if ids[slot] then
				if start + 120 > _G.GetTime() then
					return start, 120, 1
				else
					return startTime, duration, enable
				end
			else
				return startTime, duration, enable
			end
		end
	else
		GetActionCooldown = oldGetActionCooldown
	end
end

local function checkslot(slot)
	if select(4,_G.GetActionInfo(slot)) == 11129 then
		ids[slot] = true
	else
		ids[slot] = nil
	end
end

local function scan()
	if select(2,_G.UnitClass"player") == "MAGE" and select(5,_G.GetTalentInfo(2,20)) == 1 then
		hook(true)
		for i=1,120 do
			checkslot(i)
		end
	else
		hook(false)
	end
end

local f = CreateFrame"Frame"
f:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
f:RegisterEvent"ACTIONBAR_SLOT_CHANGED"
f:RegisterEvent"ACTIVE_TALENT_GROUP_CHANGED"
f:RegisterEvent"PLAYER_ENTERING_WORLD"
f:SetScript("OnEvent", function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if arg9 ~= 28682 then return end
		if arg2 == "SPELL_AURA_REMOVED" and arg6 == _G.UnitGUID"player" then
			start = _G.GetTime()
		end
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		checkslot(...)
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		scan()
	else
		scan()
		self:UnregisterEvent"PLAYER_ENTERING_WORLD"
	end
end)