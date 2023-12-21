
print(">> loading BossReward.lua")

local BossStore = {
                    [54001] = {45624, 40753, 47241, 49426, 1},
					[55001] = {45624, 0, 47241, 49426, 1},
					[56001] = {45624, 0, 47241, 49426, 1},
};

--[[
-- 此脚本最好适用于 世界BOSS 配置不同的BOSS 输出越高奖励越多 0表示不奖励
-- BossStore表详解 [Boss的ID] = {最后一击奖励, 击杀所在团队奖励, 参与奖励, 伤害奖励, 比例百分比}
-- 备注: 比例百分比 = 1 相当于 每1%的伤害可获得一个奖励 如果0.1%则表示1000份 以此类推 所以此项奖励的物品最好能堆叠
-- 注意事项: 重载LUA会使得玩家对其伤害和参与标识清零 请慎用.reload eluna
]]

local AttMap = {};
local DmgMap = {};

function ResetTable()
    AttMap = {};
	DmgMap = {};
end

--最后一击奖励 (第三个参数为false则不提示)
function RewardKill(id, p, b)
    if (BossStore[id][1] > 0) then
		if (b) then
		    --提示全服
	        SendWorldMessage("[击杀提示]: 恭喜玩家 ["..p:GetName().."] 最后一击终结BOSS 获得奖励 "..GetItemLink(BossStore[id][1]))
	    end
		p:AddItem(BossStore[id][1], 1)
	end
end

--团队奖励 (第三个参数为false则不提示)
function RewardKillGroup(id, p, b)
    if (BossStore[id][2] > 0) then
		if (b) then
		    --提示全服
	        SendWorldMessage("[击杀提示]: 恭喜玩家 ["..p:GetName().."] 所在团队终结BOSS 获得奖励 "..GetItemLink(BossStore[id][2]))
	    end
		local Group = p:GetGroup()
		local GroupPlayers = Group:GetMembers()
		for _,p in ipairs(GroupPlayers) do
		    if (AttMap[p:GetGUIDLow()] == 1) then --必须参与伤害
		        p:AddItem(BossStore[id][2], 1)
			end
		end
	end
end

--参与奖励 (第三个参数为false则不提示)
function RewardKillAll(id, p, b)
    if (BossStore[id][3] > 0) then
		if (b) then
		    --提示(仅玩家)
	        p:SendBroadcastMessage("[击杀提示]: 获得参与奖 "..GetItemLink(BossStore[id][3]))
	    end
		p:AddItem(BossStore[id][3], 1)
	end
end

--伤害奖励 (第三个参数为false则不提示)
function RewardKillDmg(creature, p, b)
    local id = creature:GetEntry()
    if (BossStore[id][4] > 0) then
	    local Proportion = DmgMap[p:GetGUIDLow()] / creature:GetMaxHealth() * 100
		local Count = math.floor(Proportion / BossStore[id][5])
		if (Count > 0) then
		    if (b) then
		        --提示(仅玩家)
	            p:SendBroadcastMessage("[击杀提示]: 获得伤害奖励 "..GetItemLink(BossStore[id][4]).." X "..Count)
	        end
			p:AddItem(BossStore[id][4], Count)
		end
	end
end

--受到伤害
function OnDamageTaken(event, creature, attacker, damage)
    local Entry = creature:GetEntry()
    local Plr = attacker:ToPlayer()
    if (Plr and damage > 0) then
	    local Guid = Plr:GetGUIDLow()
	    local CurrentDmg = damage
	    if (damage > creature:GetHealth()) then
		   CurrentDmg = creature:GetHealth()
		end
		
		--造成伤害即算参与
		if (AttMap[Guid] ~= 1) then
		    AttMap[Guid] = 1
		end
		
		if (DmgMap[Guid] == nil) then
		    DmgMap[Guid] = 0
		end
		
		--累加伤害
	    DmgMap[Guid] = DmgMap[Guid] + CurrentDmg
		
		--提示(仅玩家)
		local Proportion = DmgMap[Guid] / creature:GetMaxHealth() * 100
		local Count = math.floor(Proportion / BossStore[Entry][5])
		Plr:SendBroadcastMessage("[伤害奖励提示]: 当前造成的伤害总和: "..DmgMap[Guid].." 得到奖励 "..GetItemLink(BossStore[Entry][4]).." X "..Count)
	end
end

--死亡
function OnDie(event, creature, killer)
    local Entry = creature:GetEntry()
	local Plr = killer:ToPlayer()
	if (Plr) then
	    --发放最后一击奖励
	    RewardKill(Entry, Plr, true)
	    if (Plr:IsInGroup()) then
			--发放所在团队奖励
		    RewardKillGroup(Entry, Plr, true)
		end
	end
    local AllPlayers = GetPlayersInWorld()
	if (AllPlayers) then
        for _,p in ipairs(AllPlayers) do
            if (AttMap[p:GetGUIDLow()] == 1) then
			    --发放参与奖励
				RewardKillAll(Entry, p, true)
				--发放伤害奖励
				RewardKillDmg(creature, p, true)
			end
        end
	end
	--清空
    ResetTable()
end

for k,_ in pairs (BossStore) do
	RegisterCreatureEvent(k, 4, OnDie)
	RegisterCreatureEvent(k, 9, OnDamageTaken)
end

