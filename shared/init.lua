if IsDuplicityVersion() then
	SetConvarReplicated('voice_enableUi', 'false') -- pma_voice
else
	RegisterNetEvent('dolu_hud:onPlayerLoaded', function(data)
		SendNUIMessage({
			action = 'initStatus',
			data = data
		})
		data.voiceLevel = nil -- We only needed it on player loaded
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