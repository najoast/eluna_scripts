print(">>Script: InstanceAura loading...OK")

-- 副本类型
local DUNGEON = 1
local HEROIC  = 2
local RAID    = 3

-- 阵营
local ALLIANCE = 1
local HORDE    = 2

-- 职业
local CLASS_HUNTER = 3 --猎人

--[[
	--联盟光环
	73762, -- 5%
	73824, -- 10%
	73825, -- 15%
	73826, -- 20%
	73827, -- 25%
	73828, -- 30%
	--部落光环
	73816, -- 5%
	73818, -- 10%
	73819, -- 15%
	73820, -- 20%
	73821, -- 25%
	73822, -- 30%
]]

local AURAS = {
	[ALLIANCE] = {
		[DUNGEON] = 73826, -- 20%
		[HEROIC]  = 73827, -- 25%
		[RAID]    = 73828, -- 30%
	},
	[HORDE] = {
		[DUNGEON] = 73820, -- 20%
		[HEROIC]  = 73821, -- 25%
		[RAID]    = 73822, -- 30%
	},
}

local function AddAuraByInstanceType(player, instanceType)
	local auras = player:IsAlliance() and AURAS[ALLIANCE] or AURAS[HORDE]
	local auraId = auras[instanceType]
	if auraId and auraId > 0 then
		player:AddAura(auraId, player)
	end
end

local function ClearAura(player)
	local auras = player:IsAlliance() and AURAS[ALLIANCE] or AURAS[HORDE]
	for _, auraId in pairs(auras) do
		player:RemoveAura(auraId)
	end
end

local function PlayerChangeMap(_, player)
	if player:GetMap():IsDungeon() then
		AddAuraByInstanceType(player, DUNGEON)
		player:SendAreaTriggerMessage("您已获得地下城强化光环")
	elseif player:GetMap():IsHeroic() then
		AddAuraByInstanceType(player, HEROIC)
		player:SendAreaTriggerMessage("您已获得英雄地下城强化光环")
	elseif player:GetMap():IsRaid() then
		AddAuraByInstanceType(player, RAID)
		player:SendAreaTriggerMessage("您已获得团队地下城强化光环")
	else
		ClearAura(player)
	end
end

RegisterPlayerEvent(27, PlayerChangeMap)
