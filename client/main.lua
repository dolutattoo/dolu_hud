
-- Get Health and Armour and send them to NUI when they change
CreateThread(function()
	local playerPed, lastHealth, lastArmour

	while true do
		if nuiReady and PlayerIsLoaded and not PlayerIsDead then
			local playerPed = cache.ped
			local changed = false

			local currentHealth = utils.percent(GetEntityHealth(playerPed)-100, GetEntityMaxHealth(playerPed)-100)
			if currentHealth ~= lastHealth then
				lastHealth = currentHealth
				changed = true
			end

			local currentArmour = utils.percent(GetPedArmour(playerPed), GetPlayerMaxArmour(cache.playerId))
			if currentArmour ~= lastArmour then
				lastArmour = currentArmour
				changed = true
			end

			if not changed then
				Wait(1000)
			else
				SendNUIMessage({
					action = 'setStatuses',
					data = {
						health = currentHealth,
						armour = currentArmour
					}
				})
			end
		end
		Wait(50)
	end
end)
