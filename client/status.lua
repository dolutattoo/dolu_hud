local function updateStatus(name, data)
	if PlayerIsLoaded and Config.status[name] then
		if data > 100 or data < -100 then
			data = utils.percent(data, 1000000, 2) -- Because people use 1000000 as max value...
		end

		local currentStatus = playerStatus[name]
		local newStatus = utils.formatPercentage(data > 0 and currentStatus + data or currentStatus - data)
		SendNUIMessage({
			action = 'setStatusValue',
			data = {
				statusName = name,
				value = newStatus
			}
		})

		playerStatus[name] = newStatus
		utils.debug(1, "^7Action:add:^5" .. name, "^7Value added:^5" .. data, "^7New status:^5" .. newStatus .. "^7")
	end
end

-- Receive event from ox_inventory, when a satus item is used
RegisterNetEvent('ox:status:update', updateStatus)

-- Status loop
CreateThread(function()
	while true do
		Wait(Config.statusClientInterval)

		if nuiReady and PlayerIsLoaded then
			for name, value in pairs(playerStatus) do
				local status = Config.status[name]

				if status then
					playerStatus[name] += status.onTick

					if playerStatus[name] < 0 then
						playerStatus[name] = 0

					elseif playerStatus[name] > 100 then
						playerStatus[name] = 100
					end

					SendNUIMessage({
						action = 'setStatusValue',
						data = {
							statusName = name,
							value = value
						}
					})

					playerStatus[name] = utils.round(playerStatus[name], 2)
				end
			end
			utils.debug(2, 'Updated status ' .. json.encode(playerStatus, {indent=true}))
		end
	end
end)

-- Get status server side
lib.callback.register('dolu_hud:getStatus', function()
  return playerStatus
end)