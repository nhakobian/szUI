local iconsize = 32
local padding = 0
local alpha = 0.8

local LeftNX   = 6--4
local LeftNY   = 2--3
local RightNX  = 6
local RightNY  = 2
local BLeftNX  = 6--4
local BLeftNY  = 2--3
local BRightNX = 12
local BRightNY = 1

local pUI_LeftFrame = CreateFrame("Frame", "pUI_LeftFrame", UIParent, "SecureHandlerStateTemplate")
local pUI_RightFrame = CreateFrame("Frame", "pUI_RightFrame", UIParent,  "SecureHandlerStateTemplate")
local pUI_BLeftFrame = CreateFrame("Frame", "pUI_BLeftFrame", UIParent,  "SecureHandlerStateTemplate")
local pUI_BRightFrame = CreateFrame("Frame", "pUI_BRightFrame", UIParent,  "SecureHandlerStateTemplate")

pUI_LeftFrame:RegisterEvent("PLAYER_LOGIN")
pUI_RightFrame:RegisterEvent("PLAYER_LOGIN")
pUI_BLeftFrame:RegisterEvent("PLAYER_LOGIN")
pUI_BRightFrame:RegisterEvent("PLAYER_LOGIN")

pUI_LeftFrame:SetAttribute("actionpage", 4)
pUI_RightFrame:SetAttribute("actionpage", 3)
pUI_BLeftFrame:SetAttribute("actionpage", 6)
pUI_BRightFrame:SetAttribute("actionpage", 5)

--Individual Setup and styling functions for each window

pUI_LeftFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		self:SetWidth(LeftNX*iconsize + (LeftNX-1)*padding)
		self:SetHeight(LeftNY*iconsize + (LeftNY-1)*padding)
		self:SetPoint("BOTTOMLEFT", pUI_ActionBar1, "BOTTOMRIGHT", (pUI_InfoDock:GetLeft()-pUI_ActionBar1:GetRight()-self:GetWidth())/2.0, 0)

		MakeBkgWindow(self)

		MakeABCube(self, "MultiBarLeftButton", LeftNX, LeftNY, "BOTTOMLEFT")
	end
end)

--[[
Timer = CreateFrame("FRAME", "testtime", pUI_RightFrame)
Timer:SetHitRectInsets(0, 0, 0, 0)
function Tick(self)
	local prevtime = Timer.prevtime
	Timer.prevtime = GetTime()
	Timer.elapsed = Timer.elapsed + (Timer.prevtime - prevtime)
	
	if (Timer.elapsed >= Timer.length) then
		Timer.elapsed = Timer.length
		Timer.frame:SetAlpha(Timer.endalpha)
		Timer:SetScript("OnUpdate", nil)
		Timer:Hide()
	else
		Timer.frame:SetAlpha((Timer.elapsed/Timer.length)*(Timer.endalpha-Timer.startalpha) + Timer.startalpha)
	end
	--print(Timer.elapsed.." / "..Timer.frame:GetAlpha())
end

Timer:SetScript("OnEnter", function(self, ...)
	Timer.prevtime = GetTime()
	Timer.length = .2
	Timer.elapsed = 0
	Timer.endalpha  = 1
	Timer.startalpha = 0
	Timer.frame = pUI_RightFrame
	Timer:SetScript("OnUpdate", Tick)
end)

Timer:SetScript("OnLeave", function(self, ...)
	Timer.prevtime = GetTime()
	Timer.length = .2
	Timer.elapsed = 0
	Timer.endalpha  = 0
	Timer.startalpha = 1
	Timer.frame = pUI_RightFrame
	Timer:SetScript("OnUpdate", Tick)
end)
]]--

pUI_RightFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		self:SetWidth(RightNX*iconsize + (RightNX-1)*padding)
		self:SetHeight(RightNY*iconsize + (RightNY-1)*padding)
		self:SetPoint("BOTTOMRIGHT", pUI_InfoDock, "TOPRIGHT", 0, .4*42)
		
		MakeBkgWindow(self)
		
		MakeABCube(self, "MultiBarRightButton", RightNX, RightNY, "BOTTOMLEFT")

		--self:SetAlpha(0)
		--Timer:SetAllPoints(pUI_RightFrame)
		--Timer:SetFrameStrata(pUI_RightFrame:GetFrameStrata())
	end
end)

pUI_BLeftFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		self:SetWidth(BLeftNX*iconsize + (BLeftNX-1)*padding)
		self:SetHeight(BLeftNY*iconsize + (BLeftNY-1)*padding)
		self:SetPoint("BOTTOMRIGHT", pUI_ActionBar1, "BOTTOMLEFT", -(pUI_ActionBar1:GetLeft()-pUI_ChatDock:GetRight()-self:GetWidth())/2.0, 0)
	
		MakeBkgWindow(self)
		MakeABCube(self, "MultiBarBottomLeftButton", BLeftNX, BLeftNY, "BOTTOMLEFT", 0, 0)
	end
end)

pUI_BRightFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		self:SetWidth(BRightNX*iconsize + (BRightNX-1)*padding)
		self:SetHeight(BRightNY*iconsize + (BRightNY-1)*padding)
		self:SetPoint("BOTTOM", pUI_ActionBar1, "TOP", 0, padding)
		MakeABCube(self, "MultiBarBottomRightButton", BRightNX, BRightNY, "BOTTOMLEFT")
	end
end)
















