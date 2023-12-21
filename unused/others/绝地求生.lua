local gamgestate=0 --游戏状态  0 没开  1开启
local JionPlayKill={}  --参加游戏的人
local jishiqi=0
local tongip={}



------------刷怪得buff-------------

function chijiashaguai(event, creature, killer)
	--killer:AddAura( 66721, killer)
	
end

RegisterCreatureEvent( 200050, 4, chijiashaguai )
----------------------------------------------------------------

---------吃鸡杀人
function chijisharen(event, killer, killed)
	
	if killer:GetAreaId()==4710 or killer:GetZoneId()==4710 then
		if event==6 then
			killer:RemoveFromGroup()
			killer:AddAura( 66721, killer)
			killer:AddItem(60022,1)
			JionPlayKill[killer:GetGUIDLow()]=JionPlayKill[killer:GetGUIDLow()]+1
			if killer~=killed then
				killed:AddItem(60011,1)
			end
			
		end
		
		SendWorldMessage("|CFFfe7801【绝地求生】【"..killer:GetName().."】杀死了【"..killed:GetName().."】");
		killed:Teleport(571, 5815.01, 441.72,658.76, 6.051165,TELE_TO_GM_MODE)
	end
end

RegisterPlayerEvent( 6, chijisharen )
RegisterPlayerEvent( 8, chijisharen )
----------------------------------------------------------

----------------定时通报人数
function dingshibaoshu()
	if gamgestate==1 then
		local curplays= GetPlayersInMap(628)
		local countlive=0
		jishiqi=jishiqi+1
		for k,v in pairs(curplays) do
			
			if v:IsAlive() then
				v:RemoveFromGroup()
				countlive=countlive+1

			end
			if jishiqi>14 then
				v:Teleport(628, 769.83, -802.39,6.40, 0.135462,TELE_TO_GM_MODE)
				v:SendBroadcastMessage("|CFFfe7801【绝地逃生】游戏时间超过15分钟,所有人被传送到地图中央!")
			end
				
		end
		SendWorldMessage("|CFFfe7801【绝地求生】已开始"..jishiqi.."分钟,存活人数："..countlive.."人");
		
		if countlive<2 and jishiqi>4 then
			local winplay
			for k,v in pairs(curplays) do
				winplay=v
				
			end
			if winplay~=nil then
				SendWorldMessage("|CFFfe7801【绝地求生】结束,胜者【"..winplay:GetName().."】"..JionPlayKill[winplay:GetGUIDLow()].."杀吃鸡,大吉大利");
				winplay:AddItem(60000,100)
				winplay:AddItem(60011,1)
				winplay:Teleport(571, 5815.01, 441.72,658.76, 6.051165,TELE_TO_GM_MODE)	
			else
				SendWorldMessage("|CFFfe7801【绝地求生】结束,地图中无玩家");
			end
			
			gamgestate=0
			
		else
			CreateLuaEvent(dingshibaoshu, 60*1000, 1)
		end		
		
		if countlive>1 and jishiqi>19 then
			SendWorldMessage("|CFFfe7801【绝地求生】满30分钟,存活人数多余1人,杀人最多者为获胜");
			local winplay
			for k,v in pairs(curplays) do
				if winplay==nil then
					winplay=v
					
				else
					if JionPlayKill[v:GetGUIDLow()]>JionPlayKill[winplay:GetGUIDLow()] then
						winplay=v
						
					end
				end
				
				v:Teleport(571, 5815.01, 441.72,658.76, 6.051165,TELE_TO_GM_MODE)
				
			end
			SendWorldMessage("|CFFfe7801【绝地求生】结束,胜者【"..winplay:GetName().."】"..JionPlayKill[winplay:GetGUIDLow()].."杀吃鸡,大吉大利");
			winplay:AddItem(60000,100)
			winplay:AddItem(60011,1)
		end
		
		
	end

	
	
end
--------------------------------------------------------------------------------------

------------定时发放坦克-----------------
function zhaohuantanke()
	if gamgestate==1 then
		local dfgdfg=math.random(1,4)
		
		if dfgdfg==1 then
		GetPlayersInMap(628)[1]:SpawnCreature(28312,1222.03,-764.59,48.92,3.152162, 3,3*60*1000)
		SendWorldMessage("|CFFfe7801【绝地求生】冰封要塞刷新了一辆坦克车,载具持续3分钟后消失");
		end
		
		if dfgdfg==2 then
		GetPlayersInMap(628)[1]:SpawnCreature(27881,1222.03,-764.59,48.92,3.152162, 3,3*60*1000)
		SendWorldMessage("|CFFfe7801【绝地求生】冰封要塞刷新了一辆投石车,载具持续3分钟后消失");
		end
		
		if dfgdfg==3 then
		GetPlayersInMap(628)[1]:SpawnCreature(28312,345.99,-831.32,48.92,6.270186, 3,3*60*1000)
		SendWorldMessage("|CFFfe7801【绝地求生】无畏要塞刷新了一辆坦克车,载具持续3分钟后消失");
		end
		
		if dfgdfg==4 then
		GetPlayersInMap(628)[1]:SpawnCreature(27881,345.99,-831.32,48.92,6.270186, 3,3*60*1000)
		SendWorldMessage("|CFFfe7801【绝地求生】无畏要塞刷新了一辆投石车,载具持续3分钟后消失");
		end
		
		
		CreateLuaEvent(zhaohuantanke, 3*60*1000,1 )
	end
	
	
end
-------------------------------------------



--------吃鸡开始
function chijikaishi()
	gamgestate=1

		local players = GetPlayersInWorld()
		if(players) then
			for k, player in ipairs(players) do
				player:GossipComplete()
				player:GossipClearMenu()
				player:GossipMenuAddItem(30, "【绝地求生】吃鸡开始\n点击传送参加", 0, 1, false, "|TInterface/FlavorImages/BloodElfLogo-small:64:64:0:-30|t\n \n \n \n \n \n【荒岛求生】吃鸡开始\n点击传送参加。")
				player:GossipSendMenu(100, player, 12329)
			end
		end
	SendWorldMessage("|CFFfe7801【绝地求生】开始:游戏20分钟内,唯一存活的玩家为胜者,可以用传送宝石进入【绝地求生】,吃鸡者奖励100"..GetItemLink(60000)..",参与奖励"..GetItemLink(60011));
	CreateLuaEvent(dingshibaoshu, 60*1000, 1)
	
	CreateLuaEvent(zhaohuantanke, 3*60*1000,1 )
end


----------------------------------------------------------------------




--------预备吃鸡开始
function yubeichiji()
	if gamgestate~=1 then
		if tonumber(os.date("%H"))<23 and tonumber(os.date("%H"))>12 then
			----清空数据
				jishiqi=0
				for k,v in pairs(JionPlayKill) do
				
					JionPlayKill[k] = nil
					
				end
				for k,v in pairs(tongip) do
				
					tongip[k] = nil
					
				end
				

							local players = GetPlayersInWorld()
							if(players) then
								for k, player in ipairs(players) do
									player:GossipComplete()
									player:GossipClearMenu()
									player:GossipMenuAddItem(30, "【绝地求生】一分钟后吃鸡开始,参与奖励【天赋卷轴】,需要参加的脱光装备,带上新手武器,准备参加", 0, 1, false, "|TInterface/FlavorImages/BloodElfLogo-small:64:64:0:-30|t\n \n \n \n \n \n【绝地求生】一分钟后吃鸡开始,参与奖励【天赋卷轴】,需要参加的脱光装备,带上新手武器,准备参加。")
									player:GossipSendMenu(100, player, 123291)
								end
							end
				SendWorldMessage("|CFFfe7801【绝地求生】一分钟后开始,吃鸡者奖励100"..GetItemLink(60000)..",参与奖励"..GetItemLink(60011).."，参加的脱光装备,带上新手武器【新手武器】在【日常用品】npc出售");
				
			CreateLuaEvent(chijikaishi, 60*1000, 1)		
		end
	end
	
end
CreateLuaEvent(yubeichiji, 97*60*1000, 0)

--yubeichiji()
-------------------------------------------------------------------------------------------------------------






---传送荒岛
function chuansonghuangdao(event, player, object, sender, intid, code)
	
	
		--player:SendBroadcastMessage(player:GetEquippedItemBySlot( 17):GetName())
		
		
	if gamgestate==1 then
		if player:GetAreaId()==4710 or player:GetZoneId()==4710 then
			player:SendBroadcastMessage("|CFFfe7801你已经在【绝地就生】地图,无法再传送")
		else
			if JionPlayKill[player:GetGUIDLow()]==nil then
				
				if tongip[player:GetPlayerIP()]==nil then
				
						
						if player:GetEquippedItemBySlot( 0)~=nil
							or player:GetEquippedItemBySlot( 1)~=nil
							or  player:GetEquippedItemBySlot( 2)~=nil
							or  player:GetEquippedItemBySlot( 3)~=nil
							or  player:GetEquippedItemBySlot( 4)~=nil
							or  player:GetEquippedItemBySlot( 5)~=nil
							or  player:GetEquippedItemBySlot( 6)~=nil
							or  player:GetEquippedItemBySlot( 7)~=nil
							or  player:GetEquippedItemBySlot( 8)~=nil
							or  player:GetEquippedItemBySlot( 9)~=nil
							or  player:GetEquippedItemBySlot( 10)~=nil
							or  player:GetEquippedItemBySlot( 11)~=nil
							or  player:GetEquippedItemBySlot( 12)~=nil
							or  player:GetEquippedItemBySlot( 13)~=nil
							or  player:GetEquippedItemBySlot( 14)~=nil
							--or  (player:GetEquippedItemBySlot( 17)~=nil and player:GetClass()~=3)
							or  player:GetEquippedItemBySlot( 18)~=nil
						 then
									player:SendBroadcastMessage("|CFFfe7801除了主副手武器,身上不能穿其他装备参加游戏,请脱掉后用传送宝石进【绝地就生】")
									return false
						else
						
							if player:GetEquippedItemBySlot( 15)==nil then
									player:SendBroadcastMessage("|CFFfe7801你主手没带武器,请带上【新手武器】,用传送宝石进【绝地就生】,【新手武器】在【日常用品】npc出售")
									return false
							else
								if  string.find(player:GetEquippedItemBySlot(15):GetName(), "新手")==nil then
									player:SendBroadcastMessage("|CFFfe7801你只能带【新手武器】参加,更换武器后,用传送宝石进【绝地就生】,【新手武器】在【日常用品】npc出售")
									return false
								end
							end
							
							if player:GetEquippedItemBySlot( 16)~=nil then
									if  string.find(player:GetEquippedItemBySlot(16):GetName(), "新手")==nil then
										player:SendBroadcastMessage("|CFFfe7801你只能带【新手武器】参加,更换武器后,用传送宝石进【绝地就生】,【新手武器】在【日常用品】npc出售")
										return false
									end
							end
							
							if player:GetEquippedItemBySlot( 17)~=nil then
								if player:GetClass()==3 then
									if  string.find(player:GetEquippedItemBySlot(17):GetName(), "新手")==nil then
										player:SendBroadcastMessage("|CFFfe7801你只能带【新手武器】参加,更换武器后,用传送宝石进【绝地就生】,【新手武器】在【日常用品】npc出售")
										return false
									end		
									else
									player:SendBroadcastMessage("|CFFfe7801除了主副手武器,身上不能穿其他装备参加游戏,请脱掉后用传送宝石进【绝地就生】")
									return false							
									
								end

							end
							
						end
								ReSetStatsPoints2(nil, player, nil, nil,nil)
								player:SendBroadcastMessage("|CFFfe7801你的属性加点已重置")
								player:RemoveFromGroup()
								JionPlayKill[player:GetGUIDLow()]=0
								tongip[player:GetPlayerIP()]=1
								player:Teleport(628, 772.55+math.random(-500,500), -806.33+math.random(-500,500), 304.26, 0.124451)
								player:AddAura( 37897, player)	
								SendWorldMessage("|CFFfe7801【绝地求生】【"..player:GetName().."】加入吃鸡");
								
				else
					player:SendBroadcastMessage("|CFFfe7801同IP的角色只能进入一次")
				end				
			else
				player:SendBroadcastMessage("|CFFfe7801你已经退出了【绝地求生】不能再进入了")
			end
			
		end

					
	else
		player:SendBroadcastMessage("|CFFfe7801游戏还没开始，开始后才能传送")
		
	end

end

RegisterPlayerGossipEvent(12329, 2, chuansonghuangdao)
--------------------------------------------------------------------------------






-----装备装备判断
function zhuangbeiwup(event, packet, player)
	if player:GetMapId()==628 then
		player:SendBroadcastMessage("|CFFfe7801在【绝地逃生】中不能装备物品")
		
		
		return false
	end
end


RegisterPacketEvent( 0x10A, 5, zhuangbeiwup )
RegisterPacketEvent( 0x10C, 5, zhuangbeiwup )
------------------------------------------------------------------








