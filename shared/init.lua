local server = IsDuplicityVersion()
Config = json.decode(LoadResourceFile(cache.resource, 'config.json'))

if server then
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

		local data = {}

		-- Make Hud visible
		data.toggle = true

		-- Health & Armour
		data.health = utils.percent(GetEntityHealth(playerPed)-100, GetEntityMaxHealth(playerPed)-100)
		data.armour = utils.percent(GetPedArmour(playerPed), GetPlayerMaxArmour(cache.playerId))

		-- Wait for ox_core to provide statuses
		while not statuses?.hunger do Wait(0) end
		data.statuses = statuses

		-- Get voice level from statebag (pma_voice)
		data.voice = LocalPlayer.state.proximity.index or 2

		SendNUIMessage({
			action = 'setStatuses',
			data = data
		})

		utils.debug(1, "Loaded status ", json.encode(data, {indent=true}))
	end

	AddEventHandler('ox:playerLoaded', init)

	RegisterNetEvent('ox:playerLogout', function()
		SendNUIMessage({ action = 'toggleVisibility', data = false })
		PlayerIsLoaded = false
		nuiReady = false
		statuses = nil
	end)

	RegisterNUICallback('nuiReady', function(_, cb)
		nuiReady = true
		SendNUIMessage({
			action = 'setConfig',
			data = Config or {}
		})
		cb(1)
	end)

	-- Death handler
	AddStateBagChangeHandler('dead', 'player:' .. cache.serverId, function(_, _, value)
		if not nuiReady or not PlayerIsLoaded then return end

		if value then
			-- Just dead
			SendNUIMessage({ action = 'toggleVisibility', data = false })
		elseif PlayerIsDead then
			-- Just revived
			init()
		end
		PlayerIsDead = value
	end)

	-- Support resource restart
	AddEventHandler('onResourceStart', function(resourceName)
		if resourceName == cache.resource and cache.ped then
			PlayerIsLoaded = true
			init()
		end
	end)
end

