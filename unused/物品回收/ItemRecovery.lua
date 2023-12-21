--[[
简介: ELUNA 物品回收
源码：5L 烟雨江南
修改：Mojito         @http://uiwow.cc:88/
致谢：ayase
]]--
print(">>Script: ItemRecovery loading...OK")
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
local ITEMID   = 60007 --回收宝石
RC ={};

function Item_Recovery(event, player, item, target)
	player:MoveTo(0,player:GetX()+0.01,player:GetY(),player:GetZ())
	U = target:GetEntry();
	--------------------------0-----1---------2------3-----------------
	Q = WorldDBQuery("SELECT id, shuliang, jiage, huobi FROM item_recovery WHERE `id` = '"..U.."';");
	if (Q == nil) then
		player:SendBroadcastMessage("这件物品无法回收。")
		player:SendAreaTriggerMessage("这件物品无法回收。")	
		return;
	end
	RC[U] = {
		id        = Q:GetString(0),  --物品ID
		shuliang  = Q:GetString(1),  --自定义多少个才可以回收
		jiage     = Q:GetString(2),  --回收价格
		huobi     = Q:GetString(3),  --回收货币类型（可自定义积分、寒冰徽章49426等）
			};
		player:GossipClearMenu();
		player:GossipMenuAddItem(1,"|- 确定回收:"..GetItemLink(U).."?!",0,99);
		player:GossipMenuAddItem(1,"|- 回收价格:"..GetItemLink(RC[U].huobi).."×"..RC[U].jiage.."件",0,99);
		player:GossipMenuAddItem(1,"|- 回收后装备将消失无法找回！",0,99);
		player:GossipMenuAddItem(1,"|TInterface\\ICONS\\Spell_Holy_HopeAndGrace.blp:40|t |CFFFF1100确认回收|R",1,1);
		player:GossipSendMenu(1,item);
	
end
function Item_Select(event, player, object, sender, intid, code, menu_id)
	if (intid == 1) then
		if player:HasItem(U, tonumber(RC[U].shuliang)) then
			    player:RemoveItem(U, RC[U].shuliang);
				player:AddItem(RC[U].huobi, RC[U].jiage);
				player:SendBroadcastMessage("|CFFFF0000回收成功!!|R");
				player:SendAreaTriggerMessage("|CFFFF0000回收成功!!|R");
		else
			player:SendBroadcastMessage("|CFFFF0000无可回收装备|R");
			player:SendAreaTriggerMessage("|CFFFF0000无可回收装备|R");	
		end
		player:GossipComplete();
	end
	if(intid == 99) then
		player:SendBroadcastMessage("|CFFFF0000请点击确定回收按钮！！！|R");
		player:SendAreaTriggerMessage("|CFFFF0000请点击确定回收按钮！！！R");
		player:GossipComplete();
	end
end
RegisterItemEvent(ITEMID, 2, Item_Recovery);
RegisterItemGossipEvent(ITEMID, 2, Item_Select);