print(">>Script:Scrolls By EM Loaded...")
	

local function Scrolls_15(event, p, item, target)
     
	if (p:GetLevel() < 80) then
	
	    local level=p:GetLevel()
		p:SetLevel(level+1)
		p:RemoveItem(60000, 1)
	else
		p:SendBroadcastMessage("你已经满级了！")
	end
end
RegisterItemEvent(60000,2,Scrolls_15)