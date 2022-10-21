if not IsDuplicityVersion() then
	playerLoaded = false

	RegisterNetEvent('dolu_hud:onPlayerLoaded', function(data)
		SendNUIMessage({
			action = 'initStatus',
			data = data
		})
		playerStatus = data
		playerLoaded = true
	end)

	RegisterNetEvent('ox:playerLogout', function()
		TriggerServerEvent('dolu_hud:updateStatus', playerStatus)
		SendNUIMessage({
			action = 'toggleVisibility',
			data = false
		})
		playerStatus = {}
		playerLoaded = false
	end)

	RegisterNUICallback('nuiReady', function(_, cb)
		nuiReady = true
		cb(1)
	end)
end