
local ChatPrefix = ".sj";
local WorldChannelName = "世界聊天";
local CooldownTimer = 5; -- 聊天CD，无CD 设置为0
 
local Class = { -- 职业颜色
        [1] = "C79C6E", -- 战士
        [2] = "F58CBA", -- 骑士
        [3] = "ABD473", -- 猎人
        [4] = "FFF569", -- 盗贼
        [5] = "FFFFFF", -- 牧师
        [6] = "C41F3B", -- DK
        [7] = "0070DE", -- 萨满
        [8] = "69CCF0", -- 法师
        [9] = "9482C9", -- 术士
        [11] = "FF7d0A" -- 小德
};
 


if (ChatPrefix:sub(-1) ~= " ") then
        ChatPrefix = ChatPrefix.." ";
end

 
local RCD = {};
function ChatSystem(event, player, msg, _, lang)
        if (RCD[player:GetGUIDLow()] == nil) then
                RCD[player:GetGUIDLow()] = 0;
        end
		local Team=player:GetTeam()
		if (Team == 0)then
			TEAM = "[|cFF0070d0联盟|r]"
		else
			TEAM = "[|cFFF000A0部落|r]"
		end
		
        if (msg:sub(1, ChatPrefix:len()) == ChatPrefix) then
                local r = RCD[player:GetGUIDLow()] - os.clock();
                if (0 < r) then
                        local s = string.format("|cFFFF0000你必须等待 %i 秒后才能继续重新使用|r", math.floor(r));
                        player:SendAreaTriggerMessage(s);
                else
                        RCD[player:GetGUIDLow()] = os.clock() + CooldownTimer;
                        local t = table.concat({"[|cffff0000", WorldChannelName, "|r]"..TEAM.."[|cff", Class[player:GetClass()], "|Hplayer:", player:GetName(), "|h", player:GetName(), "|h|r]: |r|cff", Class[player:GetClass()], msg:sub(ChatPrefix:len()+1), "|r"});
                        SendWorldMessage(t);
                end
                return false;
        end
end
 
RegisterPlayerEvent(18, ChatSystem);
RegisterPlayerEvent(4, function(_, player) RCD[player:GetGUIDLow()] = 0; end);