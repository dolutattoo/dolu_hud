if not IsDuplicityVersion() then
	playerLoaded = false

	RegisterNetEvent('dolu_hud:onPlayerLoaded', function(data)
		SendNUIMessage({
			action = 'initStatus',
			data = data
		})
		playerStatus = data
		SetEntityMaxHealth(cache.ped, 200)
	end)

	RegisterNetEvent('ox:playerLogout', function()
		TriggerServerEvent('dolu_hud:updateStatus', playerStatus)
		SendNUIMessage({
			action = 'toggleVisibility',
			data = false
		})
		playerStatus = {}
		if nuiReady then
			nuiReady = false
			player.loaded = false
		end
	end)

	RegisterNUICallback('nuiReady', function(_, cb)
		nuiReady = true
		player.loaded = true
		cb(1)
	end)
end