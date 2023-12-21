--local NpcEntry = 60006
local itemid =60006
local ItemEntry = 60000
local ItemName = GetItemLink(ItemEntry)

local function OnGossipHello(event, player, item)
    player:GossipMenuAddItem(10, "修改玩家名称"..ItemName.." x10", 0, 1)
    player:GossipMenuAddItem(10, "更改角色外观"..ItemName.." x10", 0, 2)
    player:GossipMenuAddItem(10, "更改玩家阵营"..ItemName.." x10", 0, 3)
    player:GossipMenuAddItem(10, "更改玩家种族"..ItemName.." x10", 0, 4)
    player:GossipSendMenu(1, item)
end

local function OnGossipSelect(event, player, item, sender, intid, code)
    if (intid == 1) then
        if (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:SetAtLoginFlag(0x01)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("修改成功！玩家返回到角色选择界面即可修改角色名称！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，无法进行此项操作！")
			player:GossipComplete()
        end
    elseif (intid == 2) then
        if (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:SetAtLoginFlag(0x08)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("修改成功！玩家返回到角色选择界面即可修改角色外观！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，无法进行此项操作！")
			player:GossipComplete()
        end
    elseif (intid == 3) then
        if (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:SetAtLoginFlag(0x40)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("修改成功！玩家返回到角色选择界面即可修改角色阵营！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，无法进行此项操作！")
			player:GossipComplete()
        end
    elseif (intid == 4) then
        if (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:SetAtLoginFlag(0x80)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("修改成功！玩家返回到角色选择界面即可修改角色种族！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，无法进行此项操作！")
			player:GossipComplete()
        end
    end
end

RegisterItemGossipEvent(itemid, 1, OnGossipHello)
RegisterItemGossipEvent(itemid, 2, OnGossipSelect)