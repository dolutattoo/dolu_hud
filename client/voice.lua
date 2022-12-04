-- pma_voice
RegisterNetEvent('pma-voice:setTalkingMode', function(mode)
	SendNUIMessage({
		action = 'setStatuses',
		data = {
			voice = mode
		}
	})
	Wait(500)
end)

RegisterNetEvent('pma-voice:radioActive', function(bool)
	SendNUIMessage({
		action = 'setStatuses',
		data = {
			talking = bool and 1 or 0
		}
	})
	Wait(500)
end)
