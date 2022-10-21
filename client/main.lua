
-- Hide radar if not in a vehicle
if Config.hideRadarOnFoot then
	CreateThread(function()
		local isRadarDisplayed, vehicle = false, false
		DisplayRadar(isRadarDisplayed)
		while true do
			if player?.loaded and cache.vehicle ~= vehicle then
				isRadarDisplayed = not isRadarDisplayed
				vehicle = cache.vehicle
				DisplayRadar(isRadarDisplayed)
			end
			Wait(200)
		end
	end)
end

-- Get Health and Armour and send them to NUI when they change
CreateThread(function()
	local playerPed, lastHealth, lastArmour
	while true do
		if nuiReady and player?.loaded then
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

RegisterNetEvent('dolu_hud:healPlayer', function()
	if player?.loaded and IsPedDeadOrDying(cache.ped) then return end
	SetEntityHealth(cache.ped, 200)
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

RegisterNetEvent('pma-voice:radioActive', function(...)
	-- todo: icon change when talking over radio
end)