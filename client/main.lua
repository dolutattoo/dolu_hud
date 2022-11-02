
-- Get Health and Armour and send them to NUI when they change
CreateThread(function()
	local playerPed, lastHealth, lastArmour
	while true do
		if nuiReady and PlayerIsLoaded then
			local playerPed = cache.ped

			local currentHealth = utils.percent(GetEntityHealth(playerPed)-100, GetEntityMaxHealth(playerPed)-100)
			if currentHealth ~= lastHealth then
				lastHealth = currentHealth
				SendNUIMessage({
					action = 'setStatusValue',
					data = {
						statusName = 'health',
						value = currentHealth
					}
				})
			end

			local currentArmour = utils.percent(GetPedArmour(playerPed), GetPlayerMaxArmour(cache.playerId))
			if currentArmour ~= lastArmour then
				lastArmour = currentArmour
				SendNUIMessage({
					action = 'setStatusValue',
					data = {
						statusName = 'armour',
						value = currentArmour
					}
				})
			end
		end
		Wait(50)
	end
end)

-- Speedo
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
							rpm = GetVehicleCurrentRpm(cache.vehicle)
						}
					})
				end
			end
		end
		Wait(20)
	end
end)

RegisterNetEvent('dolu_hud:healPlayer', function(status)
	if PlayerIsLoaded and IsPedDeadOrDying(cache.ped) then return end
	SetEntityHealth(cache.ped, 200)
	TriggerEvent('dolu_hud:initStatus', status) -- Use the init event to send all status to nui
end)

-- pma_voice
RegisterNetEvent('pma-voice:setTalkingMode', function(mode)
	SendNUIMessage({
		action = 'setStatusValue',
		data = {
			statusName = 'voiceLevel',
			value = mode
		}
	})
	Wait(500)
end)

RegisterNetEvent('pma-voice:radioActive', function(bool)
	SendNUIMessage({
		action = 'setStatusValue',
		data = {
			statusName = 'radioState',
			value = bool and 1 or 0
		}
	})
	Wait(500)
end)