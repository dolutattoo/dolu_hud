CreateThread(function()
	local lastSpeed = 0

	-- Support resource restart
	repeat Wait(10) until nuiReady

	if PlayerIsLoaded and not PlayerIsDead and cache.seat then
		if DoesEntityExist(cache.vehicle) then
			SendNUIMessage({
				action = 'toggleSpeedo',
				data = true
			})
			lastSpeed = 0
			SendNUIMessage({
				action = 'setSpeedo',
				data = {
					speed = 0,
					rpm = GetVehicleCurrentRpm(cache.vehicle),
					fuelLevel = 10
				}
			})
		end
	end

	while true do
		if PlayerIsLoaded and not PlayerIsDead and cache.seat then
			if DoesEntityExist(cache.vehicle) then
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
		end
		Wait(20)
	end
end)
