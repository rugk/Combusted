local cds, cd = {}, nil
local kill = function() return end

local f = CreateFrame"Frame"
f:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
f:RegisterEvent"PLAYER_ENTERING_WORLD"
f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		for i=1,120 do
			cd = _G["BT4Button"..i.."Cooldown"]
			if cd then
				if cd:GetParent().icon:GetTexture() == "Interface\\Icons\\Spell_Fire_SealOfFire" then
					cds[#cds+1] = cd
				end
			end
		end
		self:UnregisterEvent"PLAYER_ENTERING_WORLD"
	else
		if arg9 ~= 28682 then return end
		if arg2 == "SPELL_AURA_REMOVED" and arg6 == UnitGUID"player" then
			for k,v in pairs(cds) do
				v:SetCooldown(GetTime(),120)
				v.Show, v.Hide = kill, kill
			end
		end
	end
end)