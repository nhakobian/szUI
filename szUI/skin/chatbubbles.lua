-------------------------------------------------
----------------chat bubbles---------------------
-------------------------------------------------
--[[ 
Much of this code was adapted from Tukui.
This shrinks the font size in the chat 
bubbles and enables the edge coloring due to
type of chat (i.e. yell, say, party).

It also fixes a 1px error in the blizzard interface
with the little bottom part of the chat bubble.
]]--

local chatbubblehook = CreateFrame("Frame", nil, UIParent)
local tslu = 0
local numkids = 0
local bubbles = {}

TestBubble = nil

local function skinbubble(frame)
	for i=1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		
		if region:GetObjectType() == "Texture" then
			if region:GetTexture() == "Interface\\Tooltips\\ChatBubble-Tail" then
				frame.boogly = region
				a, b, c, d, e = region:GetPoint(1)
				e = e-1
				region:ClearAllPoints()
				region:SetPoint(a, b, c, d, e)
				
			end
		elseif region:GetObjectType() == "FontString" then
			frame.text = region
			region:SetFont("Fonts\\FRIZQT__.TTF", 10)
		end
	end
		
	tinsert(bubbles, frame)
end

local function ischatbubble(frame)
	if frame:GetName() then return end
	if not frame:GetRegions() then return end
	return frame:GetRegions():GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
end

chatbubblehook:SetScript("OnUpdate", function(chatbubblehook, elapsed)
	tslu = tslu + elapsed

	if tslu > .05 then
		tslu = 0

		local newnumkids = WorldFrame:GetNumChildren()
		if newnumkids ~= numkids then
			for i=numkids + 1, newnumkids do
				local frame = select(i, WorldFrame:GetChildren())

				if ischatbubble(frame) then
					skinbubble(frame)
				end
			end
			numkids = newnumkids
		end
		
		for i, frame in next, bubbles do
			local r, g, b = frame.text:GetTextColor()
			frame:SetBackdropBorderColor(r, g, b)
			frame.boogly:SetVertexColor(r, g, b)
		end
	end
end)
