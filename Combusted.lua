local start, ids, _G = -500, {}, _G

local function checkslot(slot)
	ids[slot] = select(4,_G.GetActionInfo(slot)) == 11129
end

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
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		checkslot(...)
	else
		for i=1,120 do
			checkslot(i)
		end
		self:UnregisterEvent"PLAYER_ENTERING_WORLD"
	end
end)

local oldGetActionCooldown = GetActionCooldown
function GetActionCooldown(slot)
	if ids[slot] then
		if start + 120 > _G.GetTime() then
			return start, 120, 1
		else
			return oldGetActionCooldown(slot)
		end
	else
		return oldGetActionCooldown(slot)
	end
end