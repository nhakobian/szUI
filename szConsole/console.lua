local inset = 3

local szConsole = CreateFrame("FRAME", "szConsole", UIParent)
szConsole:SetHeight(300)
szConsole:SetPoint("LEFT", UIParent, "LEFT")
szConsole:SetWidth(UIParent:GetWidth()/2)
szConsole:SetFrameStrata("DIALOG")
szConsole:Hide()
CreateBorder(szConsole, 14, .3, .3, .3, 2, 2, 2, 2, 2, 2, 2, 2)

--make background
szConsole.bkg = szConsole:CreateTexture(nil, "BORDER")
szConsole.bkg:SetAllPoints(szConsole)
szConsole.bkg:SetTexture(0, 0, 0, 0.8)

--Stretch window to the correct screen width after all addons are loaded
function szConsole:OnEvent(event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		--self:SetWidth(UIParent:GetWidth())
	end
end
szConsole:RegisterEvent("PLAYER_ENTERING_WORLD")
szConsole:SetScript("OnEvent", szConsole.OnEvent)


szConsole.History = {}
szConsole.HistoryNum = 0

--Generate edit box and line prefix
szConsole.LinePrefix = szConsole:CreateFontString()
local LinePrefix = szConsole.LinePrefix
LinePrefix:SetFontObject(ChatFontNormal)
LinePrefix:SetPoint("BOTTOMLEFT", szConsole, "BOTTOMLEFT", inset+1, inset)
function szConsole:UpdateLinePrefix()
	self.LinePrefix:SetText("|cff00ff00In ["..(szConsole.HistoryNum+1).."] : |r")
end
szConsole:UpdateLinePrefix()

szConsole.EditBox = CreateFrame("EditBox", nil, szConsole)
local EditBox = szConsole.EditBox
EditBox:SetPoint("BOTTOMLEFT", LinePrefix, "BOTTOMRIGHT", 0, 0)
EditBox:SetPoint("BOTTOMRIGHT", szConsole, "BOTTOMRIGHT", -inset, inset)
EditBox:SetHeight(16)
EditBox:SetFontObject(ChatFontNormal)
EditBox:SetAutoFocus(false)

--Generate output frame
szConsole.Output = CreateFrame("ScrollingMessageFrame", nil, szConsole)
local Output = szConsole.Output
Output:SetPoint("TOPLEFT", szConsole, "TOPLEFT", inset, inset)
Output:SetPoint("BOTTOMRIGHT", EditBox, "TOPRIGHT", 0, 0)
Output:SetFontObject(ChatFontNormal)
Output:SetHyperlinksEnabled(true)
Output:SetFading(false)
Output:SetMaxLines(128)
Output:EnableMouseWheel(true)
Output:SetJustifyH("LEFT")
Output:SetScript("OnMouseWheel", function(self, dir)
	if(dir > 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToTop()
		else
			self:ScrollUp()
		end
	elseif(dir < 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToBottom()
		else
			self:ScrollDown()
		end
	end
end)
--Enable syntax highlighting filters
Output.origAddMessage = Output.AddMessage
function Output:AddMessage(text)
	--put text in green
	text = text:gsub('".-"', function(w) return "|cff00ff00"..w.."|r" end)
	text = text:gsub("'.-'", function(w) return "|cff00ff00"..w.."|r" end)
	--put comments in blue 30,154,224 = 1e, 9a, e0
	text = text:gsub("%-%-.*", function(w) return "|cff1e9ae0"..w.."|r" end)
	--all numbers to pinkish red FF3A83
	--text = text:gsub("(^%|.-%|) | (%d-)", function(w) return "|cffff3a83"..w.."|r" end)
	Output:origAddMessage(text)
end
--Output.origGetPoint = Output.GetPoint
--function Output:GetPoint(...)
	--local a,b,c,d,e = self:origGetPoint(...)
	--print(a,b,c,d,e)
	--return a,b,c,d,e
--end

EditBox:SetScript("OnEscapePressed", function(self) szConsole.EditBox:ClearFocus() end)
EditBox:SetScript("OnEnterPressed", function(self)
	local text = EditBox:GetText()
	szConsole.History[szConsole.HistoryNum+1] = text
	szConsole.HistoryNum = szConsole.HistoryNum + 1
	szConsole:UpdateLinePrefix()
	EditBox:SetText("")
	Output:AddMessage("|cff00ff00In ["..szConsole.HistoryNum.."] : |r"..text)
	szConsole:ProcessCommand(text)
end)

szConsole.converters = {}
szConsole.converters['string'] = function(text)
	local color = "ffff00"
	return ('|cff%s\'"..%s.."\'|r'):format(color, text)
end
	
szConsole.converters['function'] = function(text)
	local color = "ffffff"
	return ('|cff%s"..tostring(%s).."|r'):format(color, text)
end

szConsole.converters['number'] = function(text)
	local color = "FF3A83"
	return ('|cff%s"..tostring(%s).."|r'):format(color, text)
end
	
szConsole.converters['table'] = function(text)
		local color = "ffffff"
		return ("table: |cff%s%s|r"):format(color, text)
end
	
szConsole.converters['boolean'] = function(text)
		local color = "FF3A83"
		return ("|cff%s%s|r"):format(color, text)
end

--this function doesnt work right. it'll execute some code twice...do not use
function szConsole:ProcessCommand(text)
	if text == "" then return end

	local func, err = loadstring(text)
	local output, errorflag, value
	
	if err ~= nil then 
		szConsole.Output:origAddMessage("|cffff0000"..err.."|r") 
		return
	end

	--tests to see if input is a variable
	if func ~= nil then
		errorflag, value = pcall(func)
		if errorflag == false then 
			szConsole.Output:AddMessage("|cffff0000"..value.."|r") 
		else
			print("Code ran")
		end
	end
end




--[[		if value == "string" or value == "function" or value == "number" or value == "table" or value == "boolean" then
				--loadstring('szConsole.Output:AddMessage("|cffffff00"..'..text..'.."|r")')()
				loadstring('szConsole.Output:origAddMessage("|cffff0000Out ["..szConsole.HistoryNum.."] : |r'..szConsole.converters[value](text)..'")\n')()
			else
				print("unrecognized output ")
			end
		end
	else
		--input is not a variable so try to treat it as a statement
		func, err = loadstring(text)
		if err ~= nil then 
			Output:AddMessage("|cffff0000"..err.."|r")
		else
			errorflag, value = pcall(func)
			if errorflag == false then
				Output:AddMessage("|cffff0000Statement error.|r")
				Output:AddMessage("|cffff0000"..value.."|r")
			else
				Output:AddMessage("Statement executed.")
			end
		end
	end
end]]--