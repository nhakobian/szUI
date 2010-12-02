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
	--sample:RegisterEvent("SPELLS_CHANGED")
	sample:RegisterEvent("PLAYER_LOGIN")
	sample:RegisterEvent("PLAYER_ENTERING_WORLD")
	sample:RegisterEvent("PLAYER_ALIVE")
end

szCommon:EventDebug("szCommon")

--function MakeBackgroundWindow

function MakeBkgWindow(frame)
	local alpha = 0.9

	bkg = CreateFrame("FRAME", nil, frame, "SecureHandlerStateTemplate")
	frame.bkg = bkg
	
	bkg:SetFrameStrata("BACKGROUND")

	bkg.reframe = frame
	bkg.SetBkgPoints = function(self, frame)
		self:ClearAllPoints()
		self:SetPoint("TOP", frame, 0, 6)
		self:SetPoint("LEFT", self.reframe, -6, 0)
		self:SetPoint("BOTTOMRIGHT", self.reframe, 6, -6)
	end
	bkg:SetBkgPoints(frame)
	
	bkg.bg = bkg:CreateTexture(nil, "BACKGROUND")
	bkg.bg:SetTexture(.0, .0, .0, alpha)
	bkg.bg:SetPoint("TOPLEFT", bkg, 3, -3)
	bkg.bg:SetPoint("BOTTOMRIGHT", bkg, "BOTTOMRIGHT", -3, 3)
	bkg:SetBackdrop({bgFile=""})
	CreateBorder(bkg, 14, .5, 0, 0)
end
