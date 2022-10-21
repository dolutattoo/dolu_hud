-- Sending data from server to NUI
RegisterNetEvent('ox:setPlayerData', function(name, data)
	if player?.loaded and Config.status[name] then
		SendNUIMessage({
			action = 'setStatusValue',
			data = {
				statusName = name,
				value = data
			}
		})
	end
	playerStatus[name] = data
end)

-- Status loop
CreateThread(function()
	while true do
		Wait(Config.updateInterval)

		if nuiReady and player?.loaded then
			for name, value in pairs(playerStatus) do
				local status = Config.status[name]

				if status then
					if status.onTick.action == 'add' then
						playerStatus[name] +=  status.onTick.value
					elseif status.onTick.action == 'remove' then
						playerStatus[name] -=  status.onTick.value
					end

					if playerStatus[name] < 0 then
						playerStatus[name] = 0
					elseif playerStatus[name] > 100 then
						playerStatus[name] = 100
					end

					playerStatus[name] = utils.round(playerStatus[name], 2)
				end
			end

			utils.debug(2, 'Updated status ' .. json.encode(playerStatus, {indent=true}))
		end
	end
end)

-- Save player status in database
CreateThread(function()
	while true do
		if player?.loaded then
			TriggerServerEvent('dolu_hud:updateStatus', playerStatus)
			utils.debug(1, 'Saving status in database')
		end
		Wait(Config.updateDatabaseInterval)
	end
end)