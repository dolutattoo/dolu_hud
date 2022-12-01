
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

-- Death handler
AddStateBagChangeHandler('dead', 'player:' .. cache.serverId, function(_, _, value)
	if not nuiReady or not PlayerIsLoaded then return end

	if value then
		SendNUIMessage({ action = 'toggleVisibility', data = false })
	else
		if PlayerIsDead then
			TriggerEvent('dolu_hud:init', {
				health = 200,
				armour = 0,
				status = {
					hunger = Config.status.hunger.default * 0.75,
					thirst = Config.status.thirst.default * 0.75,
					stress = Config.status.stress.default,
					drunk = Config.status.drunk.default
				}
			})
		end

		SendNUIMessage({
			action = 'toggleVisibility',
			data = true
		})
	end

	PlayerIsDead = value
end)
