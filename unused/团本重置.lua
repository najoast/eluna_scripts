print "ResetMap5H Loading...OK"    --[color=#ff0000]这里就是LUA运行脚本   没有这个服务端不会读取你的LUA！[/color]

local TIMER = 1  --[color=#ff0000]使用后物品消失时间  也就是说 360000秒  你可以用N次物品还在这   1秒  就是用完后就没了！[/color]
local ITEM  = 8210533   --[color=#ff0000]物品的ID这个不用说了吧！[/color]
local FBMAP = {{533,"|cFF0000FF纳克萨玛斯(10)|r",0,1},        --添加方法 ： { 副本地图ID,副本名字,副本难度,对话选项分类(每个保持不同依次叠加)}
                        {533,"|cFF0000FF纳克萨玛斯(25)|r",1,2},        
                        {603,"|cFF0000FF奥杜尔(10)|r",0,3},                         					   
                        {603,"|cFF0000FF奥杜尔(25)|r",1,4},  
                        {649,"|cFF0000FF十字军的试炼(10)|r",0,5},   
                        {649,"|cFF0000FF十字军的试炼(25)|r",1,6},   
                        {649,"|cFF0000FF十字军的试炼(H10)|r",2,7},   
                        {649,"|cFF0000FF十字军的试炼(H25)|r",3,8},   
                        {631,"|cFF0000FF冰冠堡垒(10)|r",0,9},   
                        {631,"|cFF0000FF冰冠堡垒(25)|r",1,10},   
                        {631,"|cFF0000FF冰冠堡垒(H10)|r",2,11},   
                        {631,"|cFF0000FF冰冠堡垒(H25)|r",3,12},   
};


local function RemoveResetMap(event, _, _, player)
        player:RemoveItem(ITEM, 1)
end


local function ResetMap (event, player, item)
        if (player:IsInCombat() == true)then;
                player:SendBroadcastMessage("对不起在战斗状态下无法使用重置卷轴!");
                player:SendAreaTriggerMessage("对不起在战斗状态下无法使用重置卷轴!");
		else
			for k,v in pairs (FBMAP) do
					local gName = v[2]
					local gIntid= v[4]
					player:GossipMenuAddItem(0,"重置"..gName.."。",0,gIntid,false,"确定重置",0)
					player:GossipSendMenu(1, item)
			end
        end
end

local function ResetMap_Select(event, player, item, sender, intid, code)
        for k,v in pairs (FBMAP) do
                local gMap  = v[1]
                local gName = v[2]
                local gDiff = v[3]
                local gIntid= v[4]
                if (intid == gIntid)then
                        player:UnbindInstance(gMap,gDiff);
                        player:SendAreaTriggerMessage("副本"..gName.."已经重置。");
                        player:SendBroadcastMessage("副本"..gName.."已经重置。");
                        player:GossipComplete();
                        player:RegisterEvent(RemoveResetMap, TIMER, 1, player)
                end
        end        
       -- if (intid == 2)then
      --          player:UnbindInstance(FBMAP[2][1],FBMAP[2][3]);
      --          player:SendAreaTriggerMessage("副本"..FBMAP[2][2].."已经重置。");
      --          player:GossipComplete();
      --  end
end

RegisterItemGossipEvent(ITEM, 1, ResetMap)
RegisterItemGossipEvent(ITEM, 2, ResetMap_Select)
