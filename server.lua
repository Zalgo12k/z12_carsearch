ESX = nil

-- discord webhook --

function dclog(xPlayer, text)
	local playerName = Sanitize(xPlayer.getName())
	
	local discord_webhook = GetConvar('discord_webhook', Config.DiscordWebhook)
	if discord_webhook == '' then
	  return
	end
	local headers = {
	  ['Content-Type'] = 'application/json'
	}
	local data = {
	  ["username"] = Config.WebhookName,
	  ["avatar_url"] = Config.WebhookAvatarUrl,
	  ["embeds"] = {{
		["author"] = {
		  ["name"] = playerName .. ' - ' .. xPlayer.identifier
		},
		["color"] = 1942002,
		["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
	  }}
	}
	data['embeds'][1]['description'] = text
	PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end
----------------------

TriggerEvent('esx:GetObject', function(obj) ESX = obj end)


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent('z12:startcarTimer')
AddEventHandler('z12:startcarTimer', function(car)
    startTimer(source, car)
end)

RegisterServerEvent('z12:server:rewarditem')
AddEventHandler('z12:server:rewarditem', function(listKey)
    local src = source 
	local xPlayer = ESX.GetPlayerFromId(src)
	local itemAmount1 = math.random(Config.ItemMinAmount1,Config.ItemMaxAmount1)
        for i = 1, math.random(1, 1), 1 do
            local item = Config.Items[math.random(1, #Config.Items)]
            xPlayer.addInventoryItem(item, itemAmount1)
            dclog(xPlayer, '**'..item..'** Eşyasından **'..itemAmount1..' adet ** Arabayı arayarak buldu!')
            Citizen.Wait(500)
        end
        local Luck = math.random(Config.ItemMinAmount1,Config.ItemMaxAmount1)
		local Odd = math.random(Config.ItemMinAmount1,Config.ItemMaxAmount1)
		local item2 = Config.RareItems[math.random(1, #Config.RareItems)]
        if Luck == Odd then
            local random = math.random(Config.LuckItemMinAmount1,Config.LuckItemMaxAmount1)
			xPlayer.addInventoryItem(item2, random)
			dclog(xPlayer, 'Şanslı Gününde! **'..item2..'** Eşyasından **'..random..' adet ** Arabayı arayarak buldu!')
        end
end)

function startTimer(id, object)
    local timer = 1 * 6

    while timer > 0 do
        Wait(1000)
        timer = timer - 1
        if timer == 0 then
            TriggerClientEvent('z12:removecar', id, object)
        end
    end
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		print('[^2z12:CarSeach^0] - Started!')
	end
end)
