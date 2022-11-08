
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

RegisterNetEvent('dolu_hud:healPlayer', function(data)
	if PlayerIsLoaded and IsPedDeadOrDying(cache.ped) then return end

	SetEntityHealth(cache.ped, data.health)

	if data.armour then
		SetPedArmour(cache.ped, data.armour)
	end

	-- Sending all data to nui using the ini event
	TriggerEvent('dolu_hud:init', {
		health = data.health,
		armour = data.armour,
		status = data.status
	})
end)