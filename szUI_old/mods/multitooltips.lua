--[[
	MultiTooltips -- Mod to allow multiple item tooltips to be open at once.
	
	This mod "replaces" (actually copies) the default ItemRefTooltip into a rotating
	stack of tooltips. Currently the stack is capped at 10 statically created windows,
	however I may decide to change this in the future.
	
	In order to get this functionality, I emulate the ItemRefTooltip; hence the code
	replicated from FrameXML/ItemRef.xml
	
	For background styling, it won't be possible to automatically pick up the style of
	ItemRefTooltip: this mod (or styling mods) will have to include specific support for
	styling the windows.
]]--

local MAX_REF_FRAMES = 10

local function Ref_Style(self, ...)
	self:SetBackdrop({bgFile="Interface/Buttons/WHITE8X8", edgeFile="Interface/Tooltips/UI-Tooltip-Border", edgeSize=16, insets={top=3, bottom=3, left=3, right=3}})
	self:SetBackdropColor(0, 0, 0, .9)
	self:SetBackdropBorderColor(.5, 0, 0, 1)
end

local function Ref_OnShow(self, ...)
	Ref_Style(self)
end

local function Ref_OnLoad(self, ...)
	--Begin code from FrameXML/ItemRef.xml
	GameTooltip_OnLoad(self);
	self:SetPadding(16);
	self:RegisterForDrag("LeftButton");
	self.shoppingTooltips = { ItemRefShoppingTooltip1, ItemRefShoppingTooltip2, ItemRefShoppingTooltip3 };
	self.UpdateTooltip = function(self)
		if ( not self.comparing and IsModifiedClick("COMPAREITEMS")) then
			GameTooltip_ShowCompareItem(self);
			self.comparing = true;
		elseif ( self.comparing and not IsModifiedClick("COMPAREITEMS")) then
			for _, frame in pairs(self.shoppingTooltips) do
				frame:Hide();
			end
			self.comparing = false;
		end
	end
	--End code from FrameXML/ItemRef.xml
	tinsert(UISpecialFrames,self:GetName());
end

local function Ref_OnTooltipSetItem(self, ...)
	--Begin code from FrameXML/ItemRef.xml
	if ( IsModifiedClick("COMPAREITEMS") and self:IsMouseOver()) then
		GameTooltip_ShowCompareItem(self, 1);
		self.comparing = true;
	end
	--End code from FrameXML/ItemRef.xml
end

local function Ref_OnDragStart(self, ...)
	--Begin code from FrameXML/ItemRef.xml
	self:StartMoving()
	--End code from FrameXML/ItemRef.xml	
end

local function Ref_OnDragStop(self, ...)
	--Begin code from FrameXML/ItemRef.xml
	self:StopMovingOrSizing();
	ValidateFramePosition(self);
	if ( IsModifiedClick("COMPAREITEMS") ) then --We do this to choose where the comparison is shown
		GameTooltip_ShowCompareItem(self, 1);
		self.comparing = true;
	end
	--End code from FrameXML/ItemRef.xml	
end

local function Ref_OnEnter(self, ...)
	--Begin code from FrameXML/ItemRef.xml
	self:SetScript("OnUpdate", self.UpdateTooltip)
	--Begin code from FrameXML/ItemRef.xml
end

local function Ref_OnLeave(self, ...)
	--Begin code from FrameXML/ItemRef.xml
	for _, frame in pairs(self.shoppingTooltips) do
		frame:Hide();
	end
	self.comparing = false;
	self:SetScript("OnUpdate", nil);
	--End code from FrameXML/ItemRef.xml
end

local function Ref_OnHide(self, ...)
	--Begin code from FrameXML/ItemRef.xml
	GameTooltip_OnHide(self);
	--While it is true that OnUpdate won't fire while the frame is hidden, we don't want to have to check-and-unregister when we show it
	self:SetScript("OnUpdate", nil);
	--End code from FrameXML/ItemRef.xml
	
	--Clear the itemref corresponding to this tip
	pUI_MultiTips.RefFrameTable[self.index] = ""
end

local RefHandlers = { 	["OnShow"] = Ref_OnShow,
						["OnLoad"] = Ref_OnLoad,
						["OnTooltipSetItem"] = Ref_OnTooltipSetItem,
						["OnDragStart"] = Ref_OnDragStart,
						["OnDragStop"] = Ref_OnDragStop,
						["OnEnter"] = Ref_OnEnter,
						["OnLeave"] = Ref_OnLeave,
						["OnHide"] = Ref_OnHide
}

local pUI_MultiTips = CreateFrame("FRAME", "pUI_MultiTips", UIParent)

pUI_MultiTips.RefFrameTable = { }

pUI_MultiTips.lastopened = 0

--Create sets of tip windows (up to MAX_REF_FRAMES worth)
for i = 1, MAX_REF_FRAMES do
	local Tip = CreateFrame("GameTooltip", "pUI_MultiTips"..i, pUI_MultiTips, "GameTooltipTemplate")

	--Create the close button on each frame
	Tip.CloseButton = CreateFrame("BUTTON", nil, Tip)
	Tip.CloseButton:SetSize(32, 32)
	Tip.CloseButton:SetPoint("TOPRIGHT", Tip, 1, 0)
	Tip.CloseButton:SetNormalTexture("Interface/Buttons/UI-Panel-MinimizeButton-Up")
	Tip.CloseButton:SetPushedTexture("Interface/Buttons/UI-Panel-MinimizeButton-Down")
	Tip.CloseButton:SetHighlightTexture("Interface/Buttons/UI-Panel-MinimizeButton-Highlight", "ADD")
	Tip.CloseButton:SetScript("OnClick", function(self, ...)
		HideUIPanel(Tip)
	end)
	
	Tip.index = i
	pUI_MultiTips.RefFrameTable[i] = ""
	
	--Register Handlers
	for handler, func in pairs(RefHandlers) do
		Tip:SetScript(handler, func)
	end
	
	Tip:ClearLines()
end

function pUI_MultiTips:AddTip(ItemLink)
	local notintable = true
	local firstempty = 0
	
	--Scan if tooltip is already in table or not.
	--If it is, clear/close that tooltip.
	--At the same time, check to see what the first available
	--empty tip is.
	for TipNum, Link in pairs(pUI_MultiTips.RefFrameTable) do
		--The Scan for the first empty tooltip
		if (firstempty == 0) and (Link == "") then
			firstempty = TipNum
		end
		--The scan to see if Link is in table already
		if Link == ItemLink then
			notintable = TipNum
		end
	end
	
	--If the link is in the table, close the link and clear its tableref
	if notintable ~= true then
		_G["pUI_MultiTips"..notintable]:Hide()
		ItemRefTooltip:Hide()
	else
		--If the link isnt in the table and firstempty == 0 (all are open)
		--Close (lastopened-MAX_REF_FRAMES+1) and open a new tip there
		if firstempty == 0 then
			local newtip = pUI_MultiTips.lastopened - MAX_REF_FRAMES + 1
			if newtip < 0 then newtip = newtip + MAX_REF_FRAMES end
			_G["pUI_MultiTips"..newtip]:Hide()
			firstempty = newtip
		end
	
		--If the link isnt in the table create/show it and add to tableref
		Tip = _G["pUI_MultiTips"..firstempty]
		Tip:ClearLines()
		Tip:SetOwner(UIParent, "ANCHOR_NONE")
		Tip:SetPoint("BOTTOM", UIParent, 0, 80)
	
		Ref_OnLoad(Tip)
		Ref_Style(Tip)
		Tip:EnableMouse(true)
		Tip:SetMovable(true)

		pUI_MultiTips.RefFrameTable[firstempty] = ItemLink
		pUI_MultiTips.lastopened = firstempty
		Tip:SetHyperlink(ItemLink)
		Tip:SetFrameLevel(6+(firstempty*2))
		ItemRefTooltip:Hide()
		ItemRefTooltip:ClearLines()
	end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(self, link, ...)
	pUI_MultiTips:AddTip(link)
end)

local function ItemLink(id)
	local _, link = GetItemInfo(id)
	return link
end

local function QuestLink(id, level)
	return "|cff808080|Hquest:"..id..":"..level.."|h[A Quest]|h|r"
end

function SampleTips()
	print(ItemLink(50849))
	print(ItemLink(47072))
	print(ItemLink(46169))
	print(ItemLink(50207))
	print(ItemLink(45326))
	print(QuestLink(13749,80))
	print(QuestLink(13852,80))
	print(QuestLink(13748,80))
	print(GetAchievementLink(3456))
	print(GetSpellLink(59752))
	print(GetSpellLink(86479))
	print(ItemLink(46169))


end
--SampleTips()