local cds = {}
local kill = function() return end

for i=1,120 do
	local cd = _G["BT4Button"..i.."Cooldown"]
	if cd then
		if cd:GetParent().icon:GetTexture() == "Interface\\Icons\\Spell_Fire_SealOfFire" then
			cds[#cds+1] = cd
		end
	end
end

local f = CreateFrame"Frame"
f:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
f:SetScript("OnEvent", function()
	if arg9 ~= 28682 then return end
	if arg2 == "SPELL_AURA_REMOVED" and arg6 == UnitGUID"player" then
		for k,v in pairs(cds) do
			v:SetCooldown(GetTime(),120)
			v.Show, v.Hide = kill, kill
		end
	end
end)