szCommon = CreateFrame("Frame")

szCommon.EDFlag = false
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

-- On Addon Loaded Handler
--   This complex function operates by registering the ADDON_LOADED event with an addon name.
--   When that addon finishes loading and its event procs, the registered functions will be 
--   iterated through, and all functions corresponding to that addon name will be run.
--   
--   The registered functions will be stored in a table themselves to allow multiple functions
--   To be run with the same addon name.

szCommon.ALStack = CreateFrame("FRAME")
szCommon.ALStack.stack = {}

local OnEvent = function(self, event, ...)
	if(not self:IsShown()) then return end
	return self[event](self, event, ...)
end

szCommon.ALStack:SetScript("OnEvent", OnEvent)
szCommon.ALStack:RegisterEvent("ADDON_LOADED")

function szCommon.ALStack:Register(addon, func)
	if self.stack[addon] == nil then
		self.stack[addon] = {func}
	else
		table.insert(self.stack[addon], func)
	end
end

function szCommon.ALStack:ADDON_LOADED(event, arg1, ...)
	if self.stack[arg1] ~= nil then
		for i, func in ipairs(self.stack[arg1]) do
			func(event, arg1, ...)
			--remove function from stack
			--(self.stack[arg1])[i] = nil
		end
	end
end

szCommon.ALStack:Show()


function pfix(pos)
	local apos = pos - floor(pos)
	if apos > .5 then
		return floor(pos) + 1
	else
		return floor(pos)
	end
end