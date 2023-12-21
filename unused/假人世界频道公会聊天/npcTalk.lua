local talk_time = {1000,10000} --聊天刷屏时间间隔 1秒 = 1000
local guild_talk_time= {10000,30000} --公会聊天刷屏时间间隔 1秒 = 1000

--local ns = "SELECT name FROM creature_template WHERE entry BETWEEN '14500000' AND '14600000'"  --选取数据库的数据作为npc名字源,留空时使用npc_name.lua设置的名字
--local ns = "SELECT name FROM characters.ai_playerbot_names"
local ns = ""

local t = {}

t.t = {
    talk = require("npc_text"),
    guild_talk = require("npc_text_guild"),
}

t.cc = {"C79C6E","F58CBA","ABD473","FFF569","FFFFFF","C41F3B","0070DE","69CCF0","9482C9","FF7d0A" }

t.init = function(s)
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    s.d = require("npc_name") or {}
    if (ns ~= "") then
        local q = WorldDBQuery(ns)
        if (q) then
            repeat
                table.insert(s.d,q:GetString(0))
            until not q:NextRow()
        end
    end
end
t:init()


t.fg = function(s,talkType)
    math.randomseed(tostring(os.time()):reverse():sub(1, 7)) 
    local i = math.random(#s.t[talkType]) 
    s.t[talkType][0][1] = i 
    s.t[talkType][0][2] = 1 
    if (type(s.t[talkType][i])=="string") then 
        return s.t[talkType][i] 
    elseif (type(s.t[talkType][i])=="table") then 
        s.t[talkType][0][2] = s.t[talkType][0][2] + 1 
        return s.t[talkType][i][1] 
    end 
end

--生成当前聊天文本
t.dt = function(s,talkType) 
    local i = s.t[talkType][0][1] 
    local ti = s.t[talkType][0][2] 
    local t = "" 
    if (type(s.t[talkType][i])=="string") then 
        t = s:fg(talkType) 
    end 
    if (type(s.t[talkType][i])=="table") then 
        if (#s.t[talkType][i] < ti) then 
            t = s:fg(talkType) 
        else 
            t = s.t[talkType][i][ti] 
            s.t[talkType][0][2] = s.t[talkType][0][2] + 1 
        end 
    end 
    return t 
end

--创建公共聊天事件
CreateLuaEvent(function() 
    local n = t.d[math.random(#t.d)] 
    SendWorldMessage(string.format("|cFFFFC0C0[世]|r|cff%s|Hplayer:%s|h[%s]|h|r:|cFFFFC0C0%s|r",t.cc[math.random(#t.cc)],n,n,t:dt("talk")))
end,{talk_time[1],talk_time[2]},0)

--创建公会聊天事件
CreateLuaEvent(function() 
    local n = t.d[math.random(#t.d)] 
    SendWorldMessage(string.format("|cFF40FF40[会]|Hplayer:%s|h[%s]|h:%s|r",n,n,t:dt("guild_talk")))
end,{guild_talk_time[1],guild_talk_time[2]},0)


--处理密语,邀请封包
RegisterServerEvent(5, function(_, p, w) 
    local c = p:GetOpcode() 
    if (c==0x095) then 
        local t = p:ReadULong() 
        local l = p:ReadULong() 
        local n = p:ReadString() 
        local m = p:ReadString() 
        if (t == 7 and n~= w:GetName()) then  
            SendWorldMessage(string.format("|cFFFF80FF|Hplayer:%s|h[%s]|h悄悄的说:%s|r",n,n,m)) 
        end 
    end
    
    if (c==0x06E) then 
        local n = p:ReadString() 
        SendWorldMessage(string.format("%s 拒绝了你的邀请.",n)) 
    end
    
    if (c==0x069) then 
        local n = p:ReadString() 
        SendWorldMessage(string.format("%s 拒绝了你的邀请.",n)) 
    end 
end)
