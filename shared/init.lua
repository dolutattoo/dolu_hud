Config = json.decode(LoadResourceFile(cache.resource, 'config.json'))

if IsDuplicityVersion() then
	SetConvarReplicated('voice_enableUi', 'false') -- pma_voice
else
	playerStatus = {}

	RegisterNetEvent('dolu_hud:initStatus', function(data)
		SetEntityMaxHealth(cache.ped, 200)

		for k in pairs(Config.status) do
			playerStatus[k] = data[k]
		end

		player.loaded = true
		SendNUIMessage({ action = 'init', data = data })
	end)

	RegisterNetEvent('ox:playerLogout', function()
		SendNUIMessage({ action = 'toggleVisibility', data = false })
		TriggerServerEvent('dolu_hud:updateStatus', playerStatus)
		playerStatus = {}
		player.loaded = false
		nuiReady = false
	end)

	RegisterNUICallback('nuiReady', function(_, cb)
		nuiReady = true
		cb(1)
	end)
end