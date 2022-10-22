-- Receive event from ox_inventory, when a satus item is used
RegisterNetEvent('ox:status:update', function(name, value)
	value = utils.percent(value, 1000000, 2) -- Because people use 1000000 as max value
	local currentStatus = playerStatus[name]
	local newStatus = utils.formatPercentage(value > 0 and currentStatus + value or currentStatus - value)
	SendNUIMessage({
		action = 'setStatusValue',
		data = {
			statusName = name,
			value = newStatus
		}
	})
	playerStatus[name] = newStatus
	utils.debug(1, "^7Action:add:^5" .. name, "^7Value added:^5" .. value, "^7New status:^5" .. newStatus .. "^7")
end)

-- Status loop
CreateThread(function()
	while true do
		Wait(Config.updateInterval)

		if nuiReady and player?.loaded then
			for name, value in pairs(playerStatus) do
				local status = Config.status[name]

				if status then
					playerStatus[name] += status.onTick

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
		if player?.loaded and playerStatus then
			TriggerServerEvent('dolu_hud:updateStatus', playerStatus)
			utils.debug(1, 'Saving status in database')
		end
		Wait(Config.updateDatabaseInterval)
	end
end)