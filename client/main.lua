local vehicle = false
local isRadarDisplayed = false

CreateThread(function()
	DisplayRadar(isRadarDisplayed)

	while true do
		if playerLoaded and cache.vehicle ~= vehicle then
			isRadarDisplayed = not isRadarDisplayed
			vehicle = cache.vehicle
			DisplayRadar(isRadarDisplayed)
		end
		Wait(200)
	end
end)

-- Get Health and Armour and send them to NUI when they change
CreateThread(function()
	local playerPed, lastHealth, lastArmour

	while true do
		if nuiReady and playerLoaded then
			if playerPed ~= cache.ped then
				SetEntityMaxHealth(cache.ped, 200)
				playerPed = cache.ped
			end

			local currentHealth = utils.percent(GetEntityHealth(playerPed)-100, GetEntityMaxHealth(playerPed)-100)
			if currentHealth ~= lastHealth then
				lastHealth = currentHealth
				print('Health: ' .. currentHealth)
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



RegisterCommand('setHealth', function(source, args)
	print('Current health:', GetEntityHealth(cache.ped) .. "/" .. GetEntityMaxHealth(cache.ped))
	local value = args[1] and tonumber(args[1]) or 200
	SetEntityHealth(cache.ped, value)
	print('New health:', GetEntityHealth(cache.ped) .. "/" .. GetEntityMaxHealth(cache.ped))
end, false)