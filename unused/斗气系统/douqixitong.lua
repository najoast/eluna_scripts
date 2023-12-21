--[[
斗气系统LUA---击杀指定怪物获得斗气值，分配给角色属性
]]--


print(">>Script: douqixitong.lua Loading...OK")

local itemEntry=79001------------------------------物品ID.惯例是带使用性质的
local guaiwu={1488, };-------------------------斗气值怪物ID--自己设置
local czitem=65501      -----------重置需要的物品
local czitemcount=5     -----------重置需要的物品数量
local douqizhiCount=1000 -----------每杀一只怪获得斗气值的数量
local xiaofeicount=5000----------------------加点消费的斗气值数量
local shuxingcount=1000----------------------每次加点增加的属性值（请注意..这儿的值跟DBC是相关联的）

local spell_liliang=99901-------------------力量
local spell_liliangup=99902
local spell_minjie=99903--------------------敏捷
local spell_minjieup=99904
local spell_naili=99905---------------------耐力
local spell_nailiup=99906
local spell_zhili=99907---------------------智力
local spell_zhiliup=99908
local spell_jingshen=99909------------------精神
local spell_jingshenup=99910
local spell_gongqiang=98001-----------------攻强
local spell_gongqiangup=98003
local spell_faqiang=98002-------------------法强
local spell_faqiangup=98004

local douqizhi=nil

local function guaiwuDQ(event, killer, enemy)
    local douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..killer:GetGUIDLow()..";")	
	for k,v in pairs (guaiwu) do
	    if (douqizhi==nil and enemy:GetEntry()==v) then
		    CharDBExecute("INSERT INTO characters_douqi VALUES ("..killer:GetGUIDLow()..", 0, 0, 0, 0, 0, 0, 0, 0);")
			killer:SaveToDB()
			killer:SendBroadcastMessage("初次击杀初始化存档")
		end
		    if (enemy:GetEntry()==v) then
		           CharDBExecute("UPDATE characters_douqi SET douqizhi=douqizhi+"..douqizhiCount.." WHERE guid="..killer:GetGUIDLow()..";")
				   killer:SaveToDB()
				   killer:SendBroadcastMessage("你击杀斗气怪物，获得"..douqizhiCount.."点斗气值.")
		    end			   
	end
end

local function Douqi_AddGoss(event, player, item, target,intid)
	douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..player:GetGUIDLow()..";")
	if (douqizhi==nil) then
	    player:SendBroadcastMessage("对不起.你无法使用.因为你目前没有斗气值")
		player:SendAreaTriggerMessage("|CFF00FFFF对不起.你无法使用.因为你目前没有斗气值|r")
	else
	    player:GossipClearMenu()
	    player:SaveToDB()
	    player:GossipMenuAddItem(8,"|CFF00FFFF斗气系统-当前角色斗气值|r：\n（|CFFFF0000"..math.modf(douqizhi:GetUInt32(2)*5+douqizhi:GetUInt32(3)*5+douqizhi:GetUInt32(4)*5+douqizhi:GetUInt32(5)*5+douqizhi:GetUInt32(6)*5+douqizhi:GetUInt32(7)*5+douqizhi:GetUInt32(8)*5).."/"..douqizhi:GetUInt32(1).."|r）\n(已分配点数/共剩余点数)\n消耗|CFFFF0000"..xiaofeicount.."|r点斗气值.提升|CFFFF00001000|r点属性|r\n|cff0000ff点击下列对应菜单可提升角色的属性",1,0)
	    player:GossipMenuAddItem(5,"当前-|cFF009933力量:|r [|CFFFF0000"..douqizhi:GetUInt32(2).."|r] ---|cff0000ff确认|r",1,1)		
	    player:GossipMenuAddItem(5,"当前-|cFF009933敏捷:|r [|CFFFF0000"..douqizhi:GetUInt32(3).."|r] ---|cff0000ff确认|r",1,2)	
	    player:GossipMenuAddItem(5,"当前-|cFF009933耐力:|r [|CFFFF0000"..douqizhi:GetUInt32(4).."|r] ---|cff0000ff确认|r",1,3)	
	    player:GossipMenuAddItem(5,"当前-|cFF009933智力:|r [|CFFFF0000"..douqizhi:GetUInt32(5).."|r] ---|cff0000ff确认|r",1,4)	
	    player:GossipMenuAddItem(5,"当前-|cFF009933精神:|r [|CFFFF0000"..douqizhi:GetUInt32(6).."|r] ---|cff0000ff确认|r",1,5)
	    player:GossipMenuAddItem(5,"当前-|cFF009933攻强:|r [|CFFFF0000"..douqizhi:GetUInt32(7).."|r] ---|cff0000ff确认|r",1,6)	
	    player:GossipMenuAddItem(5,"当前-|cFF009933法强:|r [|CFFFF0000"..douqizhi:GetUInt32(8).."|r] ---|cff0000ff确认|r",1,7)
        player:GossipMenuAddItem(0,"|cff0000ff每种属性可分配62500次\n62500 * "..shuxingcount.." = "..math.modf(62500*shuxingcount).."|r",1,8)	
	    player:GossipMenuAddItem(0,"|cFFA50000重置斗气值|r",1,9,false,"确定重置吗？\n需要消耗："..GetItemLink(czitem).." x "..czitemcount.."")
	    player:GossipSendMenu(1, item)
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
			CharDBExecute("insert into characters_douqi VALUES ("..player:GetGUIDLow()..", "..math.modf(douqizhi:GetUInt32(2)*5+douqizhi:GetUInt32(3)*5+douqizhi:GetUInt32(4)*5+douqizhi:GetUInt32(5)*5+douqizhi:GetUInt32(6)*5+douqizhi:GetUInt32(7)*5+douqizhi:GetUInt32(8)*5)+douqizhi:GetUInt32(1)..", 0, 0, 0, 0, 0, 0, 0);")		
		    player:RemoveItem(czitem,czitemcount)
			player:RemoveAura(spell_liliang)
			player:RemoveAura(spell_minjie)
			player:RemoveAura(spell_naili)
			player:RemoveAura(spell_zhili)
			player:RemoveAura(spell_jingshen)
			player:RemoveAura(spell_gongqiang)
			player:RemoveAura(spell_faqiang)
			player:SendBroadcastMessage("|CFFFF0080【系统提示】|r 重置成功！！请重新打开菜单分配点数.")
			player:GossipComplete()
		else
		    player:SendBroadcastMessage("|CFFFF0080【系统提示】|r 重置失败.缺少"..GetItemLink(czitem).." x "..czitemcount.."")
			player:GossipComplete()
		end
    end
   	
	if (douqizhi:GetUInt32(1)) < 5000 then
	    player:SendBroadcastMessage("|CFFFF0080【系统提示】|r 可分配的斗气值不足.请重新点开菜单.如果是重置请无视此提示..")
		player:GossipComplete()
	else
	
	    if intid==1 then
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
		elseif intid==2 then
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
		elseif intid==3 then
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
		elseif intid==4 then
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
		elseif intid==5 then
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
		elseif intid==6 then
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
		elseif intid==7 then
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
	end		
end


			
RegisterPlayerEvent(7, guaiwuDQ)
RegisterItemGossipEvent(itemEntry, 1, Douqi_AddGoss)
RegisterItemGossipEvent(itemEntry, 2, Douqi_seleGoss)



