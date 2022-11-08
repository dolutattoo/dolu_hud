-- Retrieve status from database and send it to the player
local function initStatus(player)
	local data = json.decode(GetResourceKvpString(('%s:status'):format(player.charid))) or {}
	local status, created = {}, false

	for name, v in pairs(Config.status) do
		-- Create status if they doesn't exists
		if not data[name] then
			data[name] = v.default
			created = true
		end

		status[name] = data[name]
	end

	-- If any status just got created, update kvp
	if created then
		SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
	end

	TriggerClientEvent('dolu_hud:init', player.source, {
		health = player.get('health'),
		armour = player.get('armour'),
		status = status
	})
end

-- Send status when resource restart
AddEventHandler('onResourceStart', function(resourceName)
	if resourceName ~= cache.resource then return end
	SetTimeout(200, function()
		local players = Ox.GetPlayers()
		for i = 1, #players do
			initStatus(players[i])
		end
	end)
end)

-- Send status when character is loaded
AddEventHandler('ox:playerLoaded', function(source, userid, charid)
	local player = Ox.GetPlayer(source)
	initStatus(player)
end)

-- Save status in kvp
RegisterNetEvent('dolu_hud:updateStatus', function(status)
	local player = Ox.GetPlayer(source)
	if player then
		SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
		utils.debug(1, "Saved status for player " .. player.source)
	end
end)

-- Save all players status every X amount of time
CreateThread(function()
    while true do
		Wait(Config.serverStatusInterval)

        local players = Ox.GetPlayers()
        for i = 1, #players do
            local player = players[i]
            local status = lib.callback.await('dolu_hud:getStatus', player.source)
            SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
			utils.debug(2, ("Saved status for player %s"):format(player.source), json.encode(status, {indent=true}))
		end

		utils.debug(1, ("Saved status for %s players"):format(#players))
    end
end)
