--[[信息：
	作者：363642022@qq.com
	修改日期：2022-12-7
	功能：控制副本、纹章分阶段开放
]]--
print(">>Script: CheckInstance loading...OK")
local P1 = 'P1'
local P2 = 'P2'
local P3 = 'P3'
local P4 = 'P4'

local P2_MAP_ID = {
	603 --奥杜尔
}
local P3_MAP_ID = {
	649, --十字军的试炼
	650, --冠军的试炼
	249, --奥妮克希亚的巢穴
}
local P4_MAP_ID = {
	631, --十字军的试炼
	632, --灵魂洪炉
	658, --萨隆深渊
	668, --映像大厅
	724, --红玉圣殿
}

--P2开放
local CREATURE_EMALON = 33993
--P3开放
local CREATURE_KORALON = 35013
--P4开放
local CREATURE_TORAVON = 38433

--英雄纹章   P1: 40752, P2: 40753, P3: 45624, P4: 47241
local HERO_P1 = 40752
--勇气纹章
local COURAGE_P1 = 40753
--征服纹章
local CONQUER_P2 = 45624
--凯旋纹章
local TRIUMPHAL_P3 = 47241
--寒冰纹章
local ICE_P4 = 49426

--当前阶段 P1	
local CURR_PHASE = P1

local ACCOUNTS = {1, 9, 10, 537, 549}

local function CheckExist(tab, val)
	for _, v in ipairs(tab) do
		if v == val then
			return true
		end
	end
	return false
end

local function CheckMapId(tab, val)
	for _, v in ipairs(tab) do
		if v == val then
			return true
		end
	end
	return false
end

local function TeleportPlayer(player)
	if (CheckExist(ACCOUNTS, player:GetAccountId()) == false) then --传送
		player:CastSpell(player, 8690, true)
		player:SendBroadcastMessage("当前区域暂未开放，你已被传送")
	end
end

local function HandleEmblem(event, player)
	local ice_count = player:GetItemCount(ICE_P4)
	local triumphal_count = player:GetItemCount(TRIUMPHAL_P3)
	local conquer_count = player:GetItemCount(CONQUER_P2)
	if (CURR_PHASE == P1) then
		if ice_count > 0 then
			player:RemoveItem(ICE_P4, ice_count)
			player:AddItem(COURAGE_P1, ice_count)
		elseif triumphal_count > 0 then
			player:RemoveItem(TRIUMPHAL_P3, triumphal_count)
			player:AddItem(HERO_P1, triumphal_count)
		end
	elseif (CURR_PHASE == P2) then
		if ice_count > 0 then
			player:RemoveItem(ICE_P4, ice_count)
			player:AddItem(CONQUER_P2, ice_count)
		elseif triumphal_count > 0 then
			player:RemoveItem(TRIUMPHAL_P3, triumphal_count)
			player:AddItem(COURAGE_P1, triumphal_count)
		end
	elseif (CURR_PHASE == P3) then
		if ice_count > 0 then
			player:RemoveItem(ICE_P4, ice_count)
			player:AddItem(TRIUMPHAL_P3, ice_count)
		elseif triumphal_count > 0 then
			player:RemoveItem(TRIUMPHAL_P3, triumphal_count)
			player:AddItem(CONQUER_P2, triumphal_count)
		end
	end
end

local function MapChange(event, player)
	local mapId = player:GetMapId()
	HandleEmblem(event, player)
	if (CURR_PHASE == P1) then
		if CheckMapId(P2_MAP_ID, mapId) then
			TeleportPlayer(player)
		elseif CheckMapId(P3_MAP_ID, mapId) then
			TeleportPlayer(player)
		elseif CheckMapId(P4_MAP_ID, mapId) then
			TeleportPlayer(player)
		end
	elseif (CURR_PHASE == P2) then
		if CheckMapId(P3_MAP_ID, mapId) then
			TeleportPlayer(player)
		elseif CheckMapId(P4_MAP_ID, mapId) then
			TeleportPlayer(player)
		end
	elseif (CURR_PHASE == P3) then
		if CheckMapId(P4_MAP_ID, mapId) then
			TeleportPlayer(player)
		end
	end
end

local function SwitchItem(player, fromItemId, toItemId, count)
	player:RegisterEvent(function(_, _, _, player2)
		if player2:HasItem(fromItemId, count) then
			player2:RemoveItem(fromItemId, count)
			player2:AddItem(toItemId, count)
		end
	end, 100, 1)
end

local function LootItem(event, player, item, count)
	if item ~= nil then
		local mapId = player:GetMapId()
		if (CURR_PHASE == P1) then
			if mapId == 533 or mapId == 616 or mapId == 615 or mapId == 624 then --NAXX
				if item:GetEntry() == ICE_P4 or item:GetEntry() == TRIUMPHAL_P3 then
					SwitchItem(player, item:GetEntry(), COURAGE_P1, count)
				end
			else
				if item:GetEntry() == ICE_P4 then
					SwitchItem(player, item:GetEntry(), COURAGE_P1, count)
				elseif item:GetEntry() == TRIUMPHAL_P3 and mapId ~= 533 then
					SwitchItem(player, item:GetEntry(), HERO_P1, count)
				end
			end

		elseif (CURR_PHASE == P2) then
			if item:GetEntry() == ICE_P4 then
				SwitchItem(player, item:GetEntry(), CONQUER_P2, count)
			elseif item:GetEntry() == TRIUMPHAL_P3 then
				SwitchItem(player, item:GetEntry(), COURAGE_P1, count)
			end
		elseif (CURR_PHASE == P3) then
			if item:GetEntry() == ICE_P4 then
				SwitchItem(player, item:GetEntry(), TRIUMPHAL_P3, count)
			elseif item:GetEntry() == TRIUMPHAL_P3 then
				SwitchItem(player, item:GetEntry(), CONQUER_P2, count)
			end
		end
	end
end

local function PlayerLogin(event, player)--玩家登录
	HandleEmblem(event, player)
end

local function PlayerLogout(event, player)--玩家登出
	HandleEmblem(event, player)
end

local function OnCreatureEMALONAdd(event, creature)
	if (CURR_PHASE == P1) then
		creature:SetDeathState(0x00400000)
	end
end

local function OnCreatureKORALONAdd(event, creature)
	if (CURR_PHASE == P1) then
		creature:SetDeathState(0x00400000)
	elseif (CURR_PHASE == P2) then
		creature:SetDeathState(0x00400000)
	end
end

local function OnCreatureTORAVONAdd(event, creature)
	if (CURR_PHASE == P1) then
		creature:SetDeathState(0x00400000)
	elseif (CURR_PHASE == P2) then
		creature:SetDeathState(0x00400000)
	elseif (CURR_PHASE == P3) then
		creature:SetDeathState(0x00400000)
	end
end

--PLAYER_EVENT_ON_LOGIN                   =     3        -- (event, player)
RegisterPlayerEvent(3, PlayerLogin)--登录
--PLAYER_EVENT_ON_LOGOUT                  =     4        -- (event, player)
RegisterPlayerEvent(4, PlayerLogout)--登出
--PLAYER_EVENT_ON_MAP_CHANGE           =     28       -- (event, player)
RegisterPlayerEvent(28, MapChange)
--PLAYER_EVENT_ON_LOOT_ITEM            =     32,       // (event, player, item, count)
RegisterPlayerEvent(32, LootItem)
--CREATURE_EVENT_ON_ADD                             = 36, // (event, creature)
RegisterCreatureEvent(CREATURE_EMALON, 36, OnCreatureEMALONAdd)
RegisterCreatureEvent(CREATURE_KORALON, 36, OnCreatureKORALONAdd)
RegisterCreatureEvent(CREATURE_TORAVON, 36, OnCreatureTORAVONAdd)