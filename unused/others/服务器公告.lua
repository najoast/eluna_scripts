--[[服务器喊话系统 by ljq5555]]--
print(">>Script: server_yell.lua loading...OK")
local TIME=2    ---------------间隔时间(单位分钟)
local diffTime=os.time()     ---不要改动
local function server_yell()
	local nowTime = os.time()
  if (nowTime-diffTime>=(TIME*60))then
    local text=CharDBQuery("SELECT text FROM server_text  AS u1  JOIN (SELECT ROUND(RAND() * ((SELECT MAX(id) FROM `server_text` )-(SELECT MIN(id) FROM server_text  ))+(SELECT MIN(id) FROM server_text ) ) AS uid) AS u2 WHERE u1.id >= u2.uid ORDER BY u1.id LIMIT 1")
   if (text )   then 

    SendWorldMessage("|cffff0000[服务器公告]|r"..text:GetString(0))

end 
diffTime=os.time()
end
end

RegisterServerEvent(5, server_yell)

CharDBExecute([[
CREATE TABLE IF NOT EXISTS `server_text` (
  `id` int(11) DEFAULT NULL,
  `text` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]])
