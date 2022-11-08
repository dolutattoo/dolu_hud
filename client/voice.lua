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