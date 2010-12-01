szCommon = CreateFrame("Frame")

szCommon.EDFlag = true
function szCommon:EventDebug(addonname)
	if szCommon.EDFlag == false then return end

	local sample = CreateFrame("FRAME")
	sample:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" then
			local arg1 = ...
			if arg1 ~= addonname then return end
		end
		print(addonname..":"..event)
	end)
	sample:RegisterEvent("ADDON_LOADED")
	sample:RegisterEvent("SPELLS_CHANGED")
	sample:RegisterEvent("PLAYER_LOGIN")
	sample:RegisterEvent("PLAYER_ENTERING_WORLD")
	sample:RegisterEvent("PLAYER_ALIVE")
end

szCommon:EventDebug("szCommon")
