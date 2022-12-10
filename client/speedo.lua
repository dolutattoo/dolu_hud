
CreateThread(function()
	local lastSpeed = 0
	local speedo = false

	-- Support resource restart
	while not nuiReady do Wait(10) end
	if PlayerIsLoaded and not PlayerIsDead and cache.vehicle then
		if DoesEntityExist(cache.vehicle) then
			SendNUIMessage({
				action = 'toggleSpeedo',
				data = true
			})
			speedo = true
			lastSpeed = 0
			SendNUIMessage({
				action = 'setSpeedo',
				data = {
					speed = 0,
					rpm = GetVehicleCurrentRpm(cache.vehicle),
					fuelLevel = GetVehicleFuelLevel(cache.vehicle)
				}
			})
		end
	end

	while true do
		if PlayerIsLoaded and not PlayerIsDead and cache.vehicle then
			if DoesEntityExist(cache.vehicle) then
				if not speedo then
					SendNUIMessage({
						action = 'toggleSpeedo',
						data = true
					})
					speedo = true
				end

				local currentSpeed = GetEntitySpeed(cache.vehicle)*(Config.speedoMetrics == 'kmh' and 3.6 or 2.236936)
				if lastSpeed ~= currentSpeed then
					lastSpeed = currentSpeed
					SendNUIMessage({
						action = 'setSpeedo',
						data = {
							speed = math.floor(currentSpeed),
							rpm = GetVehicleCurrentRpm(cache.vehicle),
							fuelLevel = GetVehicleFuelLevel(cache.vehicle)
						}
					})
				end
			end
		else
			if speedo then
				SendNUIMessage({
					action = 'toggleSpeedo',
					data = false
				})
				speedo = false
			end
			Wait(1000)
		end
		Wait(20)
	end
end)
