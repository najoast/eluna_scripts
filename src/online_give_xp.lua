
--[[
* 设计：https://github.com/najoast/qzms_forum/issues/1
* 作者：全栈君
* B站: 全栈游戏开发 https://space.bilibili.com/389407601
* 时间：2023-5-30 17:02:52
]]

local playerId2EventId = {}

local function RemoveEvent(player)
	local eventId = playerId2EventId[player:GetGUIDLow()]
	if eventId then
		-- print("移除事件ID", eventId)
		player:RemoveEventById(eventId)
		playerId2EventId[player:GetGUIDLow()] = nil
	end
end

local function OnTimer(event, delay, repeats, player)
	if player:GetLevel() >= 80 then
		RemoveEvent(player)
		return
	end
	player:GiveXP(230)
	-- print(string.format("玩家 %s 获得了 230 点经验", player:GetName()))
end

--- @param player Player
local function OnPlayerLogin(event, player)
	-- print(string.format("玩家 %s 上线了，等级 %d, GUIDLow %d", player:GetName(), player:GetLevel(), player:GetGUIDLow()))
	if player:GetLevel() >= 80 then
		return
	end
	local eventId = player:RegisterEvent(OnTimer, 5000, 0)
	-- print("注册事件ID", eventId)
	playerId2EventId[player:GetGUIDLow()] = eventId
end

local function OnPlayerLogout(event, player)
	-- print(string.format("玩家 %s 下线了，等级 %d, GUIDLow %d", player:GetName(), player:GetLevel(), player:GetGUIDLow()))
	RemoveEvent(player)
end

-- LOGIN
RegisterPlayerEvent(3, OnPlayerLogin)
RegisterPlayerEvent(4, OnPlayerLogout)
