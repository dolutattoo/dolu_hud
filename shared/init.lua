local server = IsDuplicityVersion()
Config = json.decode(LoadResourceFile(cache.resource, 'config.json'))

if server then
	-- Retrieve status from database and send it to the player
	function initStatus(player)
		local data = json.decode(GetResourceKvpString(('%s:status'):format(player.charid))) or {}
		local status, created = {}, false

		for name, v in pairs(Config.status) do
			-- Create status if they doesn't exists
			if not data[name] then
				data[name] = v.default
				created = true
			end

			status[name] = data[name]
		end

		-- If any status just got created, update kvp
		if created then
			SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
		end

		local data = {
			health = player.get('health'),
			armour = player.get('armour'),
			status = status
		}

		TriggerClientEvent('dolu_hud:init', player.source, data)
		utils.debug(1, ("Loaded status for player %s"):format(player.source), json.encode(data, {indent=true}))
	end

	-- Hide pma_voice hud
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
		utils.debug(1, "Loaded status", json.encode(data, {indent=true}))
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
end

-- Support resource restart
AddEventHandler('onResourceStart', function(resourceName)
	if resourceName ~= cache.resource then return end

	if server then
		SetTimeout(200, function()
			local players = Ox.GetPlayers()
			for i = 1, #players do
				initStatus(players[i])
			end
		end)
	else
		if cache.ped then
			PlayerIsLoaded = true
		end
	end
end)