local isTalking

CreateThread(function()
	while true do
		local voiceState = NetworkIsPlayerTalking(cache.playerId)

		if not isTalking and voiceState then
			SendNUIMessage({
				action = 'setPlayerTalking',
				data = true
			})
		elseif isTalking and not voiceState then
			SendNUIMessage({
				action = 'setPlayerTalking',
				data = false
			})
		end
		isTalking = voiceState
		Wait(200)
	end
end)

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
			talkingRadio = bool and 1 or 0
		}
	})
	Wait(500)
end)
