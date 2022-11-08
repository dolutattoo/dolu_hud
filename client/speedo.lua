CreateThread(function()
	local lastSpeed = 0
	while true do
		if PlayerIsLoaded and cache.seat and not IsPedDeadOrDying(cache.ped) then
			if DoesEntityExist(cache.vehicle) then
				local currentSpeed = GetEntitySpeed(cache.vehicle)*(Config.speedoMetrics == 'kmh' and 3.6 or 2.236936)
				if oldSpeed ~= currentSpeed then
					lastSpeed = currentSpeed
					SendNUIMessage({
						action = 'setSpeedo',
						data = {
							speed = math.floor(currentSpeed),
							gear = GetVehicleCurrentGear(cache.vehicle),
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