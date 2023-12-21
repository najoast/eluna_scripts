--local NpcEntry = 60006               --可自定义NPC实现功能
print(">>  Loading maxskills.lua Code by Mojito")
local itemid = 6948                     --可自定义宝石
local ItemEntry = 29434					--可自定义材料
local ItemName = GetItemLink(ItemEntry)    --材料名称[勿改]

local function OnGossipHello(event, player, item)
    player:GossipMenuAddItem(10, "提升<急救>--宗师！需要"..ItemName.." x10", 0, 1)            --.setskill 129 450 450 急救
    player:GossipMenuAddItem(10, "提升<烹饪>--宗师！需要"..ItemName.." x10", 0, 2)            --.setskill 185 450 450 烹饪
    player:GossipMenuAddItem(10, "提升<钓鱼>--宗师！需要"..ItemName.." x10", 0, 3)  	      --.setskill 356 450 450 钓鱼
    player:GossipMenuAddItem(10, "提升<采矿>--宗师！需要"..ItemName.." x10", 0, 4) 		      --.setskill 186 450 450 采矿
    player:GossipMenuAddItem(10, "提升<锻造>--宗师！需要"..ItemName.." x10", 0, 5)			  --.setskill 164 450 450 锻造
    player:GossipMenuAddItem(10, "提升<剥皮>--宗师！需要"..ItemName.." x10", 0, 6) 		      --.setskill 393 450 450 剥皮
    player:GossipMenuAddItem(10, "提升<制皮>--宗师！需要"..ItemName.." x10", 0, 7) 		 	  --.setskill 165 450 450 制皮
    player:GossipMenuAddItem(10, "提升<裁缝>--宗师！需要"..ItemName.." x10", 0, 8) 		 	  --.setskill 197 450 450 裁缝
    player:GossipMenuAddItem(10, "提升<附魔>--宗师！需要"..ItemName.." x10", 0, 9) 		 	  --.setskill 333 450 450 附魔
    player:GossipMenuAddItem(10, "提升<采药>--宗师！需要"..ItemName.." x10", 0, 10)		 	  --.setskill 182 450 450 草药学
    player:GossipMenuAddItem(10, "提升<炼金>--宗师！需要"..ItemName.." x10", 0, 11) 	 	  --.setskill 171 450 450 炼金术
    player:GossipMenuAddItem(10, "提升<工程>--宗师！需要"..ItemName.." x10", 0, 12) 		  --.setskill 202 450 450 工程学
    player:GossipMenuAddItem(10, "提升<珠宝>--宗师！需要"..ItemName.." x10", 0, 13) 		  --.setskill 755 450 450 宝石加工
    player:GossipMenuAddItem(10, "提升<铭文>--宗师！需要"..ItemName.." x10", 0, 14) 		  --.setskill 773 450 450 铭文
    player:GossipMenuAddItem(10, "修改玩家名称"..ItemName.." x10", 0, 15)
    player:GossipMenuAddItem(10, "更改角色外观"..ItemName.." x10", 0, 16)
    player:GossipMenuAddItem(10, "更改玩家阵营"..ItemName.." x10", 0, 17)
    player:GossipMenuAddItem(10, "更改玩家种族"..ItemName.." x10", 0, 18)
	player:GossipSendMenu(1, item)
end

local function OnGossipSelect(event, player, item, sender, intid, code)
    if (intid == 1) then
	    if  player:HasSpell(45542) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
		   (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10 ) then
            player:LearnSpell(45542)     --宗师急救
			player:AdvanceSkill(129,450)
		    player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
			player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
    elseif (intid == 2) then
        if  player:HasSpell(51296) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
     		(player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(51296)     --宗师烹饪
			player:AdvanceSkill(185,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
    elseif (intid == 3) then
        if  player:HasSpell(51294) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
           (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(51294)     -- 宗师钓鱼
			player:AdvanceSkill(356,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
    elseif (intid == 4) then
	    if  player:HasSpell(50310) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
           (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(50310) --采矿
			player:AdvanceSkill(186,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end   
	elseif (intid == 5) then 
	    if  player:HasSpell(51300) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
		   (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(51300) --锻造
			player:AdvanceSkill(164,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
	elseif (intid == 6) then
	    if  player:HasSpell(50305) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
           (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(50305) --剥皮
			player:AdvanceSkill(393,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
	elseif (intid == 7) then
        if  player:HasSpell(51302) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
		   (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(51302) --制皮
			player:AdvanceSkill(165,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
	elseif (intid == 8) then
         if player:HasSpell(51309) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
   		   (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(51309) --裁缝
			player:AdvanceSkill(197,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
	elseif (intid == 9) then
        if  player:HasSpell(51313) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
		   (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(51313) --附魔
			player:AdvanceSkill(333,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
	elseif (intid == 10) then
        if  player:HasSpell(50300) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif	
           (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(50300) --采药
			player:AdvanceSkill(182,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
	elseif (intid == 11) then
        if  player:HasSpell(51304) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
		   (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(51304) --炼金
			player:AdvanceSkill(171,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
	elseif (intid == 12) then
        if  player:HasSpell(51306) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
		   (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(51306) --工程
			player:AdvanceSkill(202,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
	elseif (intid == 13) then
        if  player:HasSpell(51311) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
		   (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(51311) --珠宝
			player:AdvanceSkill(755,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
	elseif (intid == 14) then
        if  player:HasSpell(45363) then
		    player:SendNotification("你已经学过此技能!该哪玩哪玩去！")
		elseif
		   (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:LearnSpell(45363) --铭文
			player:AdvanceSkill(773,450)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("床前明月光，问你上不上！！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，该哪玩哪玩去！")
			player:GossipComplete()
        end
    end
    if (intid == 15) then
        if (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:SetAtLoginFlag(0x01)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("修改成功！玩家返回到角色选择界面即可修改角色名称！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，无法进行此项操作！")
			player:GossipComplete()
        end
    elseif (intid == 16) then
        if (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:SetAtLoginFlag(0x08)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("修改成功！玩家返回到角色选择界面即可修改角色外观！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，无法进行此项操作！")
			player:GossipComplete()
        end
    elseif (intid == 17) then
        if (player:HasItem(ItemEntry) and player:GetItemCount(ItemEntry) >= 10) then
            player:SetAtLoginFlag(0x40)
            player:RemoveItem(ItemEntry, 10)
            player:SendNotification("修改成功！玩家返回到角色选择界面即可修改角色阵营！")
			player:GossipComplete()
        else
            player:SendNotification("你的"..ItemName.."不足，无法进行此项操作！")
			player:GossipComplete()
        end
    elseif (intid == 18) then
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