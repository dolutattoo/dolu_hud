Config = json.decode(LoadResourceFile(cache.resource, 'config.json'))

if IsDuplicityVersion() then
	SetConvarReplicated('voice_enableUi', 'false') -- pma_voice
else
	playerStatus = {}

	RegisterNetEvent('dolu_hud:onPlayerLoaded', function(data)
		SetEntityMaxHealth(cache.ped, 200)

		for k in pairs(Config.status) do
			playerStatus[k] = data[k]
		end

		SendNUIMessage({
			action = 'init',
			data = data
		})
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