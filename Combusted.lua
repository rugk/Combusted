local start, ids, _G = nil, {}, _G
local f = CreateFrame"Frame"
f:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
f:RegisterEvent"PLAYER_ENTERING_WORLD"
f:RegisterEvent"ACTIONBAR_SLOT_CHANGED"
f:SetScript("OnEvent", function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if arg9 ~= 28682 then return end
		if arg2 == "SPELL_AURA_REMOVED" and arg6 == _G.UnitGUID"player" then
				start = _G.GetTime()
		end
	else
		for i=1,120 do
			if select(4,_G.GetActionInfo(i)) == 28682 then
				ids[i] = true
			else
				ids[i] = false
			end
		end
	end
end)

local oldGetActionCooldown = GetActionCooldown
function GetActionCooldown(...)
	local slot = ...
	if not start then return oldGetActionCooldown(...) end
	if ids[slot] and (start + 120 > _G.GetTime()) then
		return start, 120, 1
	else
		return oldGetActionCooldown(...)
	end
end