--[[
    
    How to use:
    
        CreateBorder(self, borderSize, R, G, B, uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2)
        
            self         -> The name of your frame, It must be a frame not a texture
            borderSize   -> The size of the simple square Border. 10, 11 or 12 looks amazing
            R, G, B      -> The colors of the Border. R = Red, G = Green, B = Blue
            uL1, uL2     -> top left x, top left y
            uR1, uR2     -> top right x, top right] y
            bL1, bL2     -> bottom left x, bottom left y
            bR1, bR2     -> bottom right x, bottom right y
			
			bR2 - DOWN
			bL2 - DOWN
            
        A sample:
            CreateBorder(myFrameName, 12, R, G, B, 1, 1, 1, 1, 1, 1, 1, 1)
            
        or
            CreateBorder(myFrameName, 12, R, G, B)
    
    If you want you recolor the Border (for aggrowarning or similar) you can make this with this little trick
    
        ColorBorder(myFrameName, R, G, B)
    
    Thanks to Phanx (http://www.wowinterface.com/list.php?skinnerid=28751) for the idea and help.
    
-]]

--RAID_CLASS_COLORS["PRIEST"] = { r = 0.659, g = 0.843, b = 1 }

local textureNormal = 'Interface\\AddOns\\szCommon\\media\\textureNormal'
local textureShadow = 'Interface\\AddOns\\szCommon\\media\\textureShadow'

function CreateBorder(self, borderSize, R, G, B, ...)
    local uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2, noBottom, noTop = ...
    
    if (not self.HasBorder) then
		self.HasBorder = {borderSize, R, G, B, uL1 or 0, uL2 or 0, uR1 or 0, uR2 or 0, bL1 or 0, bL2 or 0, bR1 or 0, bR2 or 0, noBottom, noTop}

		self.Border = {}
		
        for i = 1, 8 do
            self.Border[i] = self:CreateTexture(nil, 'OVERLAY')
            self.Border[i]:SetParent(self)
            self.Border[i]:SetTexture(textureNormal)
            self.Border[i]:SetWidth(borderSize) 
            self.Border[i]:SetHeight(borderSize)
            self.Border[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end

		self.Border[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Border[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Border[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Border[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Border[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Border[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Border[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Border[8]:SetTexCoord(2/3, 1, 1/3, 2/3)		

		self.Shadow = {}
		
        for i = 1, 8 do
            self.Shadow[i] = self:CreateTexture(nil, 'BORDER')
            self.Shadow[i]:SetParent(self)
            self.Shadow[i]:SetTexture(textureShadow)
            self.Shadow[i]:SetWidth(borderSize) 
            self.Shadow[i]:SetHeight(borderSize)
            self.Shadow[i]:SetVertexColor(0, 0, 0, 1)
        end
		
        self.Shadow[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Shadow[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Shadow[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Shadow[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Shadow[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Shadow[6]:SetTexCoord(1/3, 2/3, 2/3, 1)		
        self.Shadow[7]:SetTexCoord(0, 1/3, 1/3, 2/3)		
        self.Shadow[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
		
		SetBorder(self)
    end
end

function SetBorder(self)
	if self.HasBorder then
		local borderSize, R, G, B, uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2, noBottom, noTop = unpack(self.HasBorder)

		if noBottom == true then 
			self.Border[6]:Hide() 
			self.Border[3]:Hide() 
			self.Border[4]:Hide() 
			self.Shadow[6]:Hide() 
			self.Shadow[3]:Hide() 
			self.Shadow[4]:Hide() 

			bL2 = borderSize + bL2
			bR2 = borderSize + bR2
		else
			self.Border[6]:Show() 
			self.Border[3]:Show() 
			self.Border[4]:Show() 
			self.Shadow[6]:Show() 
			self.Shadow[3]:Show() 
			self.Shadow[4]:Show() 
		end

		if noTop == true then 
			self.Border[1]:Hide() 
			self.Border[2]:Hide() 
			self.Border[5]:Hide() 
			self.Shadow[1]:Hide() 
			self.Shadow[2]:Hide() 
			self.Shadow[5]:Hide() 

			uL2 = borderSize + uL2
			uR2 = borderSize + uR2
		else
			self.Border[1]:Show() 
			self.Border[2]:Show() 
			self.Border[5]:Show() 
			self.Shadow[1]:Show() 
			self.Shadow[2]:Show() 
			self.Shadow[5]:Show() 
		end

        self.Border[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)
        self.Border[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)
        self.Border[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))
        self.Border[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))
        self.Border[5]:SetPoint('TOPLEFT', self.Border[1], 'TOPRIGHT')
        self.Border[5]:SetPoint('TOPRIGHT', self.Border[2], 'TOPLEFT')
        self.Border[6]:SetPoint('BOTTOMLEFT', self.Border[3], 'BOTTOMRIGHT')
        self.Border[6]:SetPoint('BOTTOMRIGHT', self.Border[4], 'BOTTOMLEFT')
        self.Border[7]:SetPoint('TOPLEFT', self.Border[1], 'BOTTOMLEFT')
        self.Border[7]:SetPoint('BOTTOMLEFT', self.Border[3], 'TOPLEFT')
        self.Border[8]:SetPoint('TOPRIGHT', self.Border[2], 'BOTTOMRIGHT')
        self.Border[8]:SetPoint('BOTTOMRIGHT', self.Border[4], 'TOPRIGHT')
       
        local space
        if (borderSize >= 10) then
            space = 3
        else
            space = borderSize/3.5
        end
		
		local bypad = 0
		local typad = 0
		if noBottom == true then bypad = -space end
		if noTop == true then typad = -space end

        self.Shadow[1]:SetPoint('TOPLEFT', self, -(uL1 or 0)-space, (uL2 or 0)+space+typad)
        self.Shadow[2]:SetPoint('TOPRIGHT', self, (uR1 or 0)+space, (uR2 or 0)+space+typad)
        self.Shadow[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0)-space, -(bL2 or 0)-space-bypad)
        self.Shadow[4]:SetPoint('BOTTOMRIGHT', self, (bR1 or 0)+space, -(bR2 or 0)-space-bypad)
        self.Shadow[5]:SetPoint('TOPLEFT', self.Shadow[1], 'TOPRIGHT')
        self.Shadow[5]:SetPoint('TOPRIGHT', self.Shadow[2], 'TOPLEFT')
        self.Shadow[6]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'BOTTOMRIGHT')
        self.Shadow[6]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'BOTTOMLEFT')
        self.Shadow[7]:SetPoint('TOPLEFT', self.Shadow[1], 'BOTTOMLEFT')
		self.Shadow[7]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'TOPLEFT')
        self.Shadow[8]:SetPoint('TOPRIGHT', self.Shadow[2], 'BOTTOMRIGHT')
		self.Shadow[8]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'TOPRIGHT')
	end
end

function SetBorderVis(self, noLeft, noBottom, noRight, noTop)
	if (self.HasBorder) then
		noLeft, noRight = nil, nil -- not implemented yet
		if noBottom ~= nil then	self.HasBorder[13] = noBottom end
		if noTop    ~= nil then self.HasBorder[14] = noTop end
		SetBorder(self)
	end
end

function ColorBorder(self, R, G, B)
    if (self.Border) then
        for i = 1, 8 do
            self.Border[i]:SetVertexColor(R, G, B)
        end
    else
        local name
        if (self:GetName()) then
            name = self:GetName()
        else
            name = 'Unnamed'
        end
        print('|cff00FF00Beautycase:|r '..name..'|cffFF0000 has no border!|r')        
    end
end
