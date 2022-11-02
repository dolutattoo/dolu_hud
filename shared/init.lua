Config = json.decode(LoadResourceFile(cache.resource, 'config.json'))

if IsDuplicityVersion() then
	-- Force disabling pma_voice hud
	SetConvarReplicated('voice_enableUi', 'false')
else
	playerStatus = {}

	RegisterNetEvent('dolu_hud:init', function(data)
		SetEntityMaxHealth(cache.ped, 200)

		for k in pairs(Config.status) do
			playerStatus[k] = data.status[k]
		end

		-- Get voice level from statebag (pma_voice)
		data.voiceLevel = LocalPlayer.state.proximity.index or 2

		PlayerIsLoaded = true
		SendNUIMessage({ action = 'init', data = data })
	end)

	RegisterNetEvent('ox:playerLogout', function()
		SendNUIMessage({ action = 'toggleVisibility', data = false })
		TriggerServerEvent('dolu_hud:updateStatus', playerStatus)
		playerStatus = {}
		PlayerIsLoaded = false
		nuiReady = false
	end)

	RegisterNUICallback('nuiReady', function(_, cb)
		nuiReady = true
		SendNUIMessage({ action = 'toggleVisibility', data = true })
		cb(1)
	end)

	-- Death handler
	AddStateBagChangeHandler('dead', 'player:' .. cache.serverId, function(_, _, value)
		PlayerIsDead = value
		if not nuiReady or not PlayerIsLoaded then return end
		if PlayerIsDead then
			SendNUIMessage({ action = 'toggleVisibility', data = false })
		else
			SendNUIMessage({ action = 'toggleVisibility', data = true })
		end
	end)
end