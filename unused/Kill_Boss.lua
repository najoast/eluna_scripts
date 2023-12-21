
local boss = {32353, 35143, 38482              }; 
local T = {}
local function KilledCreature(event, player, enemy)
    if(not enemy:IsWorldBoss()) then return end -- not world boss, skip
    local pguid, cguid = player:GetGUIDLow(), enemy:GetGUIDLow() -- get guids
   
    local ktime = 0 -- get time (default to 0)
    if(T[pguid] and T[pguid][cguid]) then
        ktime = os.time() - T[pguid][cguid] -- (now - start) = passed time (seconds)
        T[pguid][cguid] = nil -- erase record
    end
       
    local participants
        if(player:IsInGroup()) then
                participants = "和他的战友 (合计: "..player:GetGroup():GetMembersCount().." 人, "
        else
                participants = "独自一人! "
        end
   
    SendWorldMessage("|cffcc0000[击杀公告]|cffff9900 |Hplayer:"..player:GetName().."|h["..player:GetName().."]|h|r |cffcc0000"..participants.."|击杀了 ["..enemy:GetName().."] |r")
end
local function EnterCombat(event, player, enemy)
    if(not enemy:IsWorldBoss()) then return end -- not world boss, skip saving time etc
    local pguid, cguid = player:GetGUIDLow(), enemy:GetGUIDLow() -- get guids
   
    if(not T[pguid]) then -- if the player doesnt have a table
        T[pguid] = {} -- create a new table for him
    elseif(T[pguid][cguid]) then -- check that we are not already in combat with the creature (already saved a time)
        return -- we are, already a time saved. Stop before saving
    end
    T[pguid][cguid] = os.time() -- save combat start time
end
local function LeaveCombat(event, player)
        if(T[player:GetGUIDLow()]) then
                T[player:GetGUIDLow()] = nil -- erase combat time records
        end
end

function Notice (event, player, enemy)

	for k,v in pairs (boss) do
		if ( enemy:GetEntry() == v) then
				local ktime = 0 -- get time (default to 0)
					if(T[pguid] and T[pguid][cguid]) then
						ktime = os.time() - T[pguid][cguid] -- (now - start) = passed time (seconds)
						T[pguid][cguid] = nil -- erase record
					end
			    local participants
					if(player:IsInGroup()) then
							participants = "和他的战友 (合计: "..player:GetGroup():GetMembersCount().." 人, "
					else
							participants = "独自一人! ("
					end
			   
				SendWorldMessage("|cffcc0000[击杀公告]|cffff9900 |Hplayer:"..player:GetName().."|h["..player:GetName().."]|h|r |cffcc0000"..participants.."|击杀了 ["..enemy:GetName().."] |r")
		end
	end
end




RegisterPlayerEvent(7, Notice)
RegisterPlayerEvent(7, KilledCreature) -- executes when a player kills a creature
RegisterPlayerEvent(33, EnterCombat) -- executes on each player attack attempt (spammy)
RegisterPlayerEvent(34, LeaveCombat) -- executes when a player leaves combat