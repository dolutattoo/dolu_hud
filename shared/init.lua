local server = IsDuplicityVersion()
Config = json.decode(LoadResourceFile(cache.resource, 'config.json'))

if server then
	lib.versionCheck('dolutattoo/dolu_hud')
	SetConvarReplicated('game_enableFlyThroughWindscreen', 'true') -- Enable flying trough windscreen while in vehicle
	SetConvarReplicated('voice_enableUi', 'false') -- Hide pma_voice hud
else
	PlayerIsLoaded = false
	PlayerIsDead = false
	statuses = {}

	local function init()
		local playerPed = cache.ped

		-- Set max ped entity to 200 (NPCs and mp_f_freemode_01 has lower values)
		if Config.setMaxHealth then
			SetEntityMaxHealth(playerPed, 200)
		end

		-- Wait for ox_core to provide statuses
		while not statuses?.hunger do Wait(0) end

		local data = {
			toggle = true,
			statuses = statuses,
			health = utils.percent(GetEntityHealth(playerPed)-100, GetEntityMaxHealth(playerPed)-100),
			armour = utils.percent(GetPedArmour(playerPed), GetPlayerMaxArmour(cache.playerId)),
			voice = LocalPlayer.state.proximity.index or 2,
			playerId = cache.serverId
		}

		SendNUIMessage({
			action = 'setStatuses',
			data = data
		})

		utils.debug(1, "Loaded status ", json.encode(data, {indent=true}))
	end

	AddEventHandler('ox:playerLoaded', function()
		PlayerIsLoaded = true
		init()
	end)

	AddEventHandler('ox:playerLogout', function()
		SendNUIMessage({ action = 'toggleVisibility', data = false })
		PlayerIsLoaded = false
		nuiReady = false
		statuses = {}
	end)

	RegisterNUICallback('nuiReady', function(_, cb)
		cb(1)
		nuiReady = true
		SendNUIMessage({
			action = 'setConfig',
			data = Config or {}
		})
	end)

	-- Death handler
	AddStateBagChangeHandler('dead', 'player:' .. cache.serverId, function(_, _, value)
		if not nuiReady or not PlayerIsLoaded then return end

		if value then
			-- Just dead
			SendNUIMessage({ action = 'toggleVisibility', data = false })

			if Config.setStatusesAfterDeath then
				TriggerServerEvent('dolu_hud:revived')
			end
		elseif PlayerIsDead then
			-- Just revived
			init()
		end
		PlayerIsDead = value
	end)

	-- Support ox_core restart
	AddEventHandler('onResourceStop', function(resourceName)
		if resourceName == 'ox_core' then
			SendNUIMessage({ action = 'toggleVisibility', data = false })
			PlayerIsLoaded = false
			nuiReady = false
			statuses = {}
		end
	end)

	-- Support resource restart
	AddEventHandler('onResourceStart', function(resourceName)
		if resourceName == cache.resource and cache.ped then
			PlayerIsLoaded = true
			init()
		end
	end)
end

