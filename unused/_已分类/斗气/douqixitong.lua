--[[
历练系统LUA---击杀指定怪物获得历练值，分配给角色属性
]]--


print(">>Script: douqixitong.lua Loading...OK")

local itemEntry=60011 -- 打开历练界面的物品
local guaiwu={429, }; -- 获得1级历练经验值的怪物ID
local guaiwu2={431, }; -- 获得2级历练经验值的怪物ID
local guaiwu3={432, }; -- 获得3级历练经验值的怪物ID
local guaiwu4={433, 579}; -- 获得4级历练经验值的怪物ID
local douqizhiCount=1000 -- 1级历练怪物获得多少经验
local douqizhiCount2=5000 -- 2级历练怪物获得多少经验
local douqizhiCount3=10000 -- 3级历练怪物获得多少经验
local douqizhiCount4=20000 -- 4级历练怪物获得多少经验
local czitem=41751 -- 重置历练点需要消耗的物品ID
local czitemcount=5 -- 重置历练点消耗物品数量
local xiaofeicount=1000 -- 每次加点消耗多少经验
local jiadianshangxian=1000 -- 每个属性最高分配多少次


local spell_liliang=99901
local spell_liliangup=99902
local spell_liliangup2=500
local spell_minjie=99903
local spell_minjieup=99904
local spell_naili=99905
local spell_nailiup=99906
local spell_zhili=99907
local spell_zhiliup=99908
local spell_jingshen=99909
local spell_jingshenup=99910
local spell_gongqiang=99911
local spell_gongqiangup=99912
local spell_faqiang=99913
local spell_faqiangup=99914
local spell_jisu=99915
local spell_jisuup=99916

local douqizhi=nil
local shuxingcount=1
local CooldownTimer = 0.3; -- 每次加点点击间隔（秒）
local RCD = {};

local function guaiwuDQ(event, killer, enemy)
    local douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..killer:GetGUIDLow()..";")	
	-- for k,v in pairs (guaiwu) do
	    if (douqizhi==nil) then
		    CharDBExecute("INSERT INTO characters_douqi VALUES ("..killer:GetGUIDLow()..", 0, 0, 0, 0, 0, 0, 0, 0, 0);")
			killer:SaveToDB()
			killer:SendBroadcastMessage("初次击杀初始化存档")
		else
			CharDBExecute("UPDATE characters_douqi SET douqizhi=douqizhi+"..douqizhiCount.." WHERE guid="..killer:GetGUIDLow()..";")
			killer:SaveToDB()
			killer:SendBroadcastMessage("你击杀历练怪物，获得"..douqizhiCount.."点历练值.")
		end			   
	-- end
end

local function guaiwuDQ2(event, killer, enemy)
    local douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..killer:GetGUIDLow()..";")	
	for k,v in pairs (guaiwu2) do
	    if (douqizhi==nil and enemy:GetEntry()==v) then
		    CharDBExecute("INSERT INTO characters_douqi VALUES ("..killer:GetGUIDLow()..", 0, 0, 0, 0, 0, 0, 0, 0, 0);")
			killer:SaveToDB()
			killer:SendBroadcastMessage("初次击杀初始化存档")
		end
		if (enemy:GetEntry()==v) then
		    CharDBExecute("UPDATE characters_douqi SET douqizhi=douqizhi+"..douqizhiCount2.." WHERE guid="..killer:GetGUIDLow()..";")
			killer:SaveToDB()
			killer:SendBroadcastMessage("你击杀历练怪物，获得"..douqizhiCount2.."点历练值.")
		end			   
	end
end

local function guaiwuDQ3(event, killer, enemy)
    local douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..killer:GetGUIDLow()..";")	
	for k,v in pairs (guaiwu3) do
	    if (douqizhi==nil and enemy:GetEntry()==v) then
		    CharDBExecute("INSERT INTO characters_douqi VALUES ("..killer:GetGUIDLow()..", 0, 0, 0, 0, 0, 0, 0, 0, 0);")
			killer:SaveToDB()
			killer:SendBroadcastMessage("初次击杀初始化存档")
		end
		if (enemy:GetEntry()==v) then
		    CharDBExecute("UPDATE characters_douqi SET douqizhi=douqizhi+"..douqizhiCount3.." WHERE guid="..killer:GetGUIDLow()..";")
			killer:SaveToDB()
			killer:SendBroadcastMessage("你击杀历练怪物，获得"..douqizhiCount3.."点历练值.")
		end			   
	end
end

local function guaiwuDQ4(event, killer, enemy)
    local douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..killer:GetGUIDLow()..";")	
	for k,v in pairs (guaiwu4) do
	    if (douqizhi==nil and enemy:GetEntry()==v) then
		    CharDBExecute("INSERT INTO characters_douqi VALUES ("..killer:GetGUIDLow()..", 0, 0, 0, 0, 0, 0, 0, 0, 0);")
			killer:SaveToDB()
			killer:SendBroadcastMessage("初次击杀初始化存档")
		end
		if (enemy:GetEntry()==v) then
		    CharDBExecute("UPDATE characters_douqi SET douqizhi=douqizhi+"..douqizhiCount4.." WHERE guid="..killer:GetGUIDLow()..";")
			killer:SaveToDB()
			killer:SendBroadcastMessage("你击杀历练怪物，获得"..douqizhiCount4.."点历练值.")
		end			   
	end
end


local function Douqi_AddGoss(event, player, item, target,intid)
	douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..player:GetGUIDLow()..";")
    if (RCD[player:GetGUIDLow()] == nil) then
        RCD[player:GetGUIDLow()] = 0;
    end
	if (douqizhi==nil) then
	    player:SendBroadcastMessage("对不起.你无法使用.因为你目前没有历练值")
		player:SendAreaTriggerMessage("|CFF00FFFF对不起.你无法使用.因为你目前没有历练值|r")
	else
		local r = RCD[player:GetGUIDLow()] - os.clock();
		                                         -- 这里的数字要和DBC一致，否则加点界面显示不正确
		local liliang=douqizhi:GetUInt32(2)*500 -- 每次加点奖励多少力量
		local minjie=douqizhi:GetUInt32(3)*500 -- 每次加点奖励多少敏捷
		local naili=douqizhi:GetUInt32(4)*500 -- 每次加点奖励多少耐力
		local zhili=douqizhi:GetUInt32(5)*500 -- 每次加点奖励多少智力
		local jingshen=douqizhi:GetUInt32(6)*500 -- 每次加点奖励多少精神
		local gongqiang=douqizhi:GetUInt32(7)*500 -- 每次加点奖励多少攻强
		local faqiang=douqizhi:GetUInt32(8)*500 -- 每次加点奖励多少法强
		local jisu=douqizhi:GetUInt32(9)*10 -- 每次加点奖励多少急速
		if (r > 0) then
		player:SendBroadcastMessage("|CFF00FFFF你点的太快了，请手动分配点数！")
		player:GossipComplete()
		else
		RCD[player:GetGUIDLow()] = os.clock() + CooldownTimer;
	    player:GossipClearMenu()
	    player:SaveToDB()
	    player:GossipMenuAddItem(8,"|CFF00FFFF历练系统-当前角色历练值|r：\n已使用历练值：（|CFFFF0000"..math.modf(douqizhi:GetUInt32(2)*xiaofeicount+douqizhi:GetUInt32(3)*xiaofeicount+douqizhi:GetUInt32(4)*xiaofeicount+douqizhi:GetUInt32(5)*xiaofeicount+douqizhi:GetUInt32(6)*xiaofeicount+douqizhi:GetUInt32(7)*xiaofeicount+douqizhi:GetUInt32(8)*xiaofeicount+douqizhi:GetUInt32(9)*xiaofeicount).."|r）\n剩余历练值：（|CFFFF0000"..douqizhi:GetUInt32(1).."|r）\n|cff0000ff每次加点消耗|r|CFFFF0000"..xiaofeicount.."|r|cff0000ff点历练值|r",1,0)
	    player:GossipMenuAddItem(5,"奖励|cff0000ff力量：|CFFFF0000"..liliang.."|r     加点：[|CFFFF0000"..douqizhi:GetUInt32(2).."|r]",1,1)		
	    player:GossipMenuAddItem(5,"奖励|cff0000ff敏捷：|CFFFF0000"..minjie.."|r     加点：[|CFFFF0000"..douqizhi:GetUInt32(3).."|r]",1,2)	
	    player:GossipMenuAddItem(5,"奖励|cff0000ff耐力：|CFFFF0000"..naili.."|r     加点：[|CFFFF0000"..douqizhi:GetUInt32(4).."|r]",1,3)	
	    player:GossipMenuAddItem(5,"奖励|cff0000ff智力：|CFFFF0000"..zhili.."|r     加点：[|CFFFF0000"..douqizhi:GetUInt32(5).."|r]",1,4)	
	    player:GossipMenuAddItem(5,"奖励|cff0000ff精神：|CFFFF0000"..jingshen.."|r     加点：[|CFFFF0000"..douqizhi:GetUInt32(6).."|r]",1,5)
	    player:GossipMenuAddItem(5,"奖励|cff0000ff攻强：|CFFFF0000"..gongqiang.."|r     加点：[|CFFFF0000"..douqizhi:GetUInt32(7).."|r]",1,6)	
	    player:GossipMenuAddItem(5,"奖励|cff0000ff法强：|CFFFF0000"..faqiang.."|r     加点：[|CFFFF0000"..douqizhi:GetUInt32(8).."|r]",1,7)
	    player:GossipMenuAddItem(5,"奖励|cff0000ff急速：|CFFFF0000"..jisu.."|r     加点：[|CFFFF0000"..douqizhi:GetUInt32(9).."|r]",1,8)
	    player:GossipMenuAddItem(0,"|cFFA50000重置历练值|r",1,9,false,"确定重置吗？\n需要消耗："..GetItemLink(czitem).." x "..czitemcount.."")
	    player:GossipSendMenu(1, item)
		end
	end
end

local function Douqi_seleGoss(event,player,item,target,intid)
    local douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..player:GetGUIDLow()..";")
    if intid==0 then
		Douqi_AddGoss(event, player, item, target,intid)
	end
    if intid==8 then
		Douqi_AddGoss(event, player, item, target,intid)
    elseif 	intid==9 then
        if (player:HasItem(czitem,czitemcount)) then
            CharDBExecute("DELETE FROM characters_douqi WHERE guid="..player:GetGUIDLow()..";")
			CharDBExecute("insert into characters_douqi VALUES ("..player:GetGUIDLow()..", "..math.modf(douqizhi:GetUInt32(2)*xiaofeicount+douqizhi:GetUInt32(3)*xiaofeicount+douqizhi:GetUInt32(4)*xiaofeicount+douqizhi:GetUInt32(5)*xiaofeicount+douqizhi:GetUInt32(6)*xiaofeicount+douqizhi:GetUInt32(7)*xiaofeicount+douqizhi:GetUInt32(8)*xiaofeicount+douqizhi:GetUInt32(9)*xiaofeicount)+douqizhi:GetUInt32(1)..", 0, 0, 0, 0, 0, 0, 0, 0);")		
		    player:RemoveItem(czitem,czitemcount)
			player:RemoveAura(spell_liliang)
			player:RemoveAura(spell_liliangup)
			player:RemoveAura(spell_minjie)
			player:RemoveAura(spell_minjieup)
			player:RemoveAura(spell_naili)
			player:RemoveAura(spell_nailiup)
			player:RemoveAura(spell_zhili)
			player:RemoveAura(spell_zhiliup)
			player:RemoveAura(spell_jingshen)
			player:RemoveAura(spell_jingshenup)
			player:RemoveAura(spell_gongqiang)
			player:RemoveAura(spell_gongqiangup)
			player:RemoveAura(spell_faqiang)
			player:RemoveAura(spell_faqiangup)
			player:RemoveAura(spell_jisu)
			player:RemoveAura(spell_jisuup)
			player:SendBroadcastMessage("|CFFFF0080【系统提示】|r 重置成功！！请重新打开菜单分配点数.")
			player:GossipComplete()
		else
		    player:SendBroadcastMessage("|CFFFF0080【系统提示】|r 重置失败.缺少"..GetItemLink(czitem).." x "..czitemcount.."")
			player:GossipComplete()
		end
    end
   	
	if (douqizhi:GetUInt32(1)) < xiaofeicount then
	    player:SendBroadcastMessage("|CFFFF0080【系统提示】|r 可分配的历练值不足.请重新点开菜单.如果是重置请无视此提示..")
		player:GossipComplete()
	else
	
	    if intid==1 then
			if (douqizhi:GetUInt32(2)>=jiadianshangxian) then
				player:SendBroadcastMessage("|CFF00FFFF该属性已达上限！")
				player:GossipComplete()
			else
		    CharDBExecute("update characters_douqi set liliang=liliang+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
			CharDBExecute("update characters_douqi set douqizhi=douqizhi-"..xiaofeicount.." where guid="..player:GetGUIDLow()..";")
			local spell_liliang_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_liliang.." and guid="..player:GetGUIDLow()..";")
			if (spell_liliang_1==nil) then
                player:AddAura(spell_liliang, player)
				Douqi_AddGoss(event, player, item, target,intid)
			else
			    if (spell_liliang_1:GetUInt32(0)<250) then
                    player:AddAura(spell_liliang, player)
				    Douqi_AddGoss(event, player, item, target,intid)
				else
				    player:RemoveAura(spell_liliang)
					player:AddAura(spell_liliang, player)
					player:AddAura(spell_liliangup, player)
					Douqi_AddGoss(event, player, item, target,intid)
				end
			end
			end
		elseif intid==2 then
			if (douqizhi:GetUInt32(3)>=jiadianshangxian) then
				player:SendBroadcastMessage("|CFF00FFFF该属性已达上限！")
				player:GossipComplete()
			else
		        CharDBExecute("update characters_douqi set minjie=minjie+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				CharDBExecute("update characters_douqi set douqizhi=douqizhi-"..xiaofeicount.." where guid="..player:GetGUIDLow()..";")
			local spell_minjie_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_minjie.." and guid="..player:GetGUIDLow()..";")
			if (spell_minjie_1==nil) then
                player:AddAura(spell_minjie, player)
				Douqi_AddGoss(event, player, item, target,intid)
			else
			    if (spell_minjie_1:GetUInt32(0)<250) then
                    player:AddAura(spell_minjie, player)
				    Douqi_AddGoss(event, player, item, target,intid)
				else
				    player:RemoveAura(spell_minjie)
					player:AddAura(spell_minjie, player)
					player:AddAura(spell_minjieup, player)
					Douqi_AddGoss(event, player, item, target,intid)	
				end
			end
			end
		elseif intid==3 then
			if (douqizhi:GetUInt32(4)>=jiadianshangxian) then
				player:SendBroadcastMessage("|CFF00FFFF该属性已达上限！")
				player:GossipComplete()
			else
		        CharDBExecute("update characters_douqi set naili=naili+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				CharDBExecute("update characters_douqi set douqizhi=douqizhi-"..xiaofeicount.." where guid="..player:GetGUIDLow()..";")
			local spell_naili_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_naili.." and guid="..player:GetGUIDLow()..";")
			if (spell_naili_1==nil) then
                player:AddAura(spell_naili, player)
				Douqi_AddGoss(event, player, item, target,intid)
			else
			    if (spell_naili_1:GetUInt32(0)<250) then
                    player:AddAura(spell_naili, player)
				    Douqi_AddGoss(event, player, item, target,intid)
				else
					player:RemoveAura(spell_naili)
					player:AddAura(spell_naili, player)
					player:AddAura(spell_nailiup, player)
					Douqi_AddGoss(event, player, item, target,intid)	
				end
			end
			end
		elseif intid==4 then
			if (douqizhi:GetUInt32(5)>=jiadianshangxian) then
				player:SendBroadcastMessage("|CFF00FFFF该属性已达上限！")
				player:GossipComplete()
			else
		        CharDBExecute("update characters_douqi set zhili=zhili+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				CharDBExecute("update characters_douqi set douqizhi=douqizhi-"..xiaofeicount.." where guid="..player:GetGUIDLow()..";")
			local spell_zhili_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_zhili.." and guid="..player:GetGUIDLow()..";")
			if (spell_zhili_1==nil) then
                player:AddAura(spell_zhili, player)
				Douqi_AddGoss(event, player, item, target,intid)
			else
			    if (spell_zhili_1:GetUInt32(0)<250) then
                    player:AddAura(spell_zhili, player)
				    Douqi_AddGoss(event, player, item, target,intid)
				else
					player:RemoveAura(spell_zhili)
					player:AddAura(spell_zhili, player)
					player:AddAura(spell_zhiliup, player)
					Douqi_AddGoss(event, player, item, target,intid)	
				end
			end
			end
		elseif intid==5 then
			if (douqizhi:GetUInt32(6)>=jiadianshangxian) then
				player:SendBroadcastMessage("|CFF00FFFF该属性已达上限！")
				player:GossipComplete()
			else
		        CharDBExecute("update characters_douqi set jingshen=jingshen+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				CharDBExecute("update characters_douqi set douqizhi=douqizhi-"..xiaofeicount.." where guid="..player:GetGUIDLow()..";")
			local spell_jingshen_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_jingshen.." and guid="..player:GetGUIDLow()..";")
			if (spell_jingshen_1==nil) then
                player:AddAura(spell_jingshen, player)
				Douqi_AddGoss(event, player, item, target,intid)
			else
			    if (spell_jingshen_1:GetUInt32(0)<250) then
                    player:AddAura(spell_jingshen, player)
				    Douqi_AddGoss(event, player, item, target,intid)
				else
					player:RemoveAura(spell_jingshen)
					player:AddAura(spell_jingshen, player)
					player:AddAura(spell_jingshenup, player)
					Douqi_AddGoss(event, player, item, target,intid)	
				end
			end
			end
		elseif intid==6 then
			if (douqizhi:GetUInt32(7)>=jiadianshangxian) then
				player:SendBroadcastMessage("|CFF00FFFF该属性已达上限！")
				player:GossipComplete()
			else
		        CharDBExecute("update characters_douqi set gongqiang=gongqiang+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				CharDBExecute("update characters_douqi set douqizhi=douqizhi-"..xiaofeicount.." where guid="..player:GetGUIDLow()..";")
			local spell_gongqiang_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_gongqiang.." and guid="..player:GetGUIDLow()..";")
			if (spell_gongqiang_1==nil) then
                player:AddAura(spell_gongqiang, player)
				Douqi_AddGoss(event, player, item, target,intid)
			else
			    if (spell_gongqiang_1:GetUInt32(0)<250) then
                    player:AddAura(spell_gongqiang, player)
				    Douqi_AddGoss(event, player, item, target,intid)
				else
					player:RemoveAura(spell_gongqiang)
					player:AddAura(spell_gongqiang, player)
					player:AddAura(spell_gongqiangup, player)
					Douqi_AddGoss(event, player, item, target,intid)	
				end
			end
			end
		elseif intid==7 then
			if (douqizhi:GetUInt32(8)>=jiadianshangxian) then
				player:SendBroadcastMessage("|CFF00FFFF该属性已达上限！")
				player:GossipComplete()
			else
		        CharDBExecute("update characters_douqi set faqiang=faqiang+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				CharDBExecute("update characters_douqi set douqizhi=douqizhi-"..xiaofeicount.." where guid="..player:GetGUIDLow()..";")
			local spell_faqiang_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_faqiang.." and guid="..player:GetGUIDLow()..";")
			if (spell_faqiang_1==nil) then
                player:AddAura(spell_faqiang, player)
				Douqi_AddGoss(event, player, item, target,intid)
			else
			    if (spell_faqiang_1:GetUInt32(0)<250) then
                    player:AddAura(spell_faqiang, player)
				    Douqi_AddGoss(event, player, item, target,intid)
				else
					player:RemoveAura(spell_faqiang)
					player:AddAura(spell_faqiang, player)
					player:AddAura(spell_faqiangup, player)
					Douqi_AddGoss(event, player, item, target,intid)	
				end
			end
			end
		elseif intid==8 then
			if (douqizhi:GetUInt32(9)>=jiadianshangxian) then
				player:SendBroadcastMessage("|CFF00FFFF该属性已达上限！")
				player:GossipComplete()
			else
		        CharDBExecute("update characters_douqi set jisu=jisu+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				CharDBExecute("update characters_douqi set douqizhi=douqizhi-"..xiaofeicount.." where guid="..player:GetGUIDLow()..";")
			local spell_jisu_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_jisu.." and guid="..player:GetGUIDLow()..";")
			if (spell_jisu_1==nil) then
                player:AddAura(spell_jisu, player)
				Douqi_AddGoss(event, player, item, target,intid)
			else
			    if (spell_jisu_1:GetUInt32(0)<250) then
                    player:AddAura(spell_jisu, player)
				    Douqi_AddGoss(event, player, item, target,intid)
				else
					player:RemoveAura(spell_jisu)
					player:AddAura(spell_jisu, player)
					player:AddAura(spell_jisuup, player)
					Douqi_AddGoss(event, player, item, target,intid)	
				end
			end
			end
		end
	end		
end



	CharDBExecute([[	
CREATE TABLE If Not Exists `characters_douqi` (
  `guid` int(10) NOT NULL,
  `douqizhi` int(30) NOT NULL DEFAULT '0',
  `liliang` int(30) NOT NULL,
  `minjie` int(30) NOT NULL,
  `naili` int(30) NOT NULL,
  `zhili` int(30) NOT NULL,
  `jingshen` int(30) NOT NULL,
  `gongqiang` int(30) NOT NULL,
  `faqiang` int(30) NOT NULL,
  `jisu` int(30) NOT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

			
RegisterPlayerEvent(7, guaiwuDQ)
RegisterPlayerEvent(7, guaiwuDQ2)
RegisterPlayerEvent(7, guaiwuDQ3)
RegisterPlayerEvent(7, guaiwuDQ4)
RegisterItemGossipEvent(itemEntry, 1, Douqi_AddGoss)
RegisterItemGossipEvent(itemEntry, 2, Douqi_seleGoss)



