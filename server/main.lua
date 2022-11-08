-- Save all status on txAdmin server shutdown
AddEventHandler('txAdmin:events:serverShuttingDown', function()
	local players = Ox.GetPlayers()
	for i = 1, #players do
		local player = players[i]
		local status = Player(player.source).state.status
		SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))

		utils.debug(2, ("Saved status for player %s"):format(player.source), json.encode(status, {indent=true}))
	end

	utils.debug(1, ("Saved status for %s players"):format(#players))
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
