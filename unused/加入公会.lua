local guildid = {
    [0] = '为了联盟',
    [1] = '为了部落'
}
local guildrank={
    [0] = 4,
    [1] = 4 
}
function AutoJoinGuildOnLogin(event, player)
    if not player:IsInGuild() then
        local newguild = GetGuildByName(guildid[player:GetTeam()]) 
        if newguild == nil then
        else
            newguild:AddMember(player, guildrank[player:GetTeam()])
            player:SendBroadcastMessage('你已加入工会['..guildid[player:GetTeam()]   ..']'        )
        end
    end
end
RegisterPlayerEvent(3, AutoJoinGuildOnLogin)                  
print('>>Script: AutoJoinGuildOnLogin.') 