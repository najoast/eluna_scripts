--[[
功能：世界聊天
时间：2023-5-31 19:47:21
]]

--[[
玩家使用方法：在输入的消息前加上@符号，即可转变为世界聊天

比如：
@你好世界

GM可以修改CooldownTime的值（单位秒），来给世界聊天增加CD限制。
玩家首次登陆时，会提示TA如何使用该功能，之后不再提示。
]]

print(">>Script: world_chat.lua")

local CooldownTime = 0 -- Cooldown in seconds. Set to 0 for no CD obviously.

local Class = { -- Class colors :) Prettier and easier than the elseif crap :) THESE ARE HEX COLORS!
    [1] = "C79C6E", -- Warrior
    [2] = "F58CBA", -- Paladin
    [3] = "ABD473", -- Hunter
    [4] = "FFF569", -- Rogue
    [5] = "FFFFFF", -- Priest
    [6] = "C41F3B", -- Death Knight
    [7] = "0070DE", -- Shaman
    [8] = "69CCF0", -- Mage
    [9] = "9482C9", -- Warlock
    [10] = "00FF96",-- Monk
    [11] = "FF7d0A" -- Druid
}

-- local Rank = {
--     [0] = "7DFF00", -- Player
--     [1] = "E700B1", -- Moderator
--     [2] = "E7A200", -- Game Master
--     [3] = "E7A200", -- Admin
--     [4] = "E7A200" -- Console
-- }

local PlayersLastChatTime = {} -- guidLow => os.time()

local function CheckCD(guidLow)
    if CooldownTime == 0 then
        return true
    end
    local lastChatTime = PlayersLastChatTime[guidLow] or 0
    local nowTime = os.time()
    local diffTime = nowTime - lastChatTime
    if diffTime < CooldownTime then
        return false, diffTime
    end
    PlayersLastChatTime[guidLow] = nowTime
    return true
end

local function OnPlayerChat(event, player, msg, chattype, lang)
	local playerTeam = player:GetTeam() == 0 and "[联盟]" or "[部落]"

    -- if msg:sub(1, 4) ~= "@sj " then
    --     return true
    -- end
    -- msg = msg:sub(5)
    if msg:byte(1) ~= 64 then -- 64 = @
        return true
    end
    msg = msg:sub(2)
    -- trim
    msg = msg:gsub("^%s*(.-)%s*$", "%1")
    if msg == "" then
        return false
    end

    -- 检查CD
    local guid = player:GetGUIDLow()
    local canChat, diffTime = CheckCD(guid)
    if not canChat then
        player:SendAreaTriggerMessage(string.format("你说话太快了！%d秒后可再次发言", CooldownTime-diffTime))
        return false
    end

    local playerName = player:GetName()
    local worldMsg = string.format([=[|cff7DFF00[世界]%s|Hplayer:%s|h[|r|cFF%s%s|r|cff7DFF00]|h: %s|r]=],
        playerTeam, playerName, Class[player:GetClass()], playerName, msg)
    SendWorldMessage(worldMsg)
    return false
end

local function OnPlayerLogout(_, player)
    PlayersLastChatTime[player:GetGUIDLow()] = nil
end

local function OnPlayerFirstLogin(_, player)
    player:SendBroadcastMessage("|cFFFF0000[功能提示]|r在聊天框输入的消息前加上@可转变为世界聊天")
end

RegisterPlayerEvent(4, OnPlayerLogout) --PLAYER_EVENT_ON_LOGOUT
RegisterPlayerEvent(18, OnPlayerChat)  --PLAYER_EVENT_ON_CHAT
RegisterPlayerEvent(22, OnPlayerChat)  --PLAYER_EVENT_ON_CHANNEL_CHAT
RegisterPlayerEvent(30, OnPlayerFirstLogin) --PLAYER_EVENT_ON_LOGOUT
