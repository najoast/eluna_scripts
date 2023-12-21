local ChatPrefix = "";
local WorldChannelName = "世界(/s)";
local CooldownTimer = 0; -- Cooldown in seconds. Set to 0 for no CD obviously.
 
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
};
 
local Rank = {
        [0] = "7DFF00", -- Player
        [1] = "E700B1", -- Moderator
        [2] = "E7A200", -- Game Master
        [3] = "E7A200", -- Admin
        [4] = "E7A200" -- Console
};
 
 
local RCD = {};
function ChatSystem(event, player, msg, chattype, lang)
	local gmText = ""
	--if(player:GetGMRank() > 0) then gmText = blizzard end
	local playerTeam = "[联盟] "
	if(player:GetTeam() == 1) then playerTeam = "[部落] " end
    --if((chattype == 1 or chattype == 17) and lang ~= 0xFFFFFFFF) then --17 是综合频道
    if(chattype == 1) then --1 是s频道
    	if (RCD[player:GetGUIDLow()] == nil) then
    		RCD[player:GetGUIDLow()] = 0;
    	end
    	local r = RCD[player:GetGUIDLow()] - os.clock();
    	if (0 < r) then
    		local s = string.format("你说话太快了！%i秒后可再次发言", math.ceil(r));
    		player:SendAreaTriggerMessage(color(s,"red"));
            player:SendBroadcastMessage(s);
    	else
        	RCD[player:GetGUIDLow()] = os.clock() + CooldownTimer;
        	local t = table.concat({"|cff7DFF00[", WorldChannelName, "] ", gmText, "|Hplayer:", player:GetName(), "|h[|r|cFF", Class[player:GetClass()], player:GetName(), "|r|cff7DFF00]|h: ", msg, "|r"});
        	SendWorldMessage(t);
    	end
    	return false;
	end
end
 
RegisterPlayerEvent(18, ChatSystem);
RegisterPlayerEvent(22, ChatSystem);
RegisterPlayerEvent(4, function(_, player) RCD[player:GetGUIDLow()] = 0; end);