AddEventHandler('ox:playerLoaded', function(source, userid, charid)
	local player = Ox.GetPlayer(source)
	local data = player.get()

	for name, v in pairs(Config.status) do
		if not data[name] then
			player.setdb(name, v.default)
			data[name] = v.default
		end
	end

	TriggerClientEvent('dolu_hud:onPlayerLoaded', player.source, {
		voiceLevel = Player(player.source).state.proximity.index or 2,
		health = data.health,
		armour = data.armour,
		hunger = data.hunger,
		thirst = data.thirst,
		stress = data.stress,
		drunk = data.drunk,
	})
end)

RegisterNetEvent('dolu_hud:updateStatus', function(status)
	local player = Ox.GetPlayer(source)
	if player then
		for name, value in pairs(status) do
			player.setdb(name, value, true)
			utils.debug(2, "Saved status for player " .. player.source .. " - " .. name .. ': ' .. value)
		end
	end
	utils.debug(1, "Saved status for player " .. player.source)
end)

lib.addCommand('group.admin', 'heal', function(source, args)
	if source < 1 and not args.playerId then return end
	local player = Ox.GetPlayer(args.playerId or source)
	if player then
		for key, value in pairs({ hunger = 100, thirst = 100, stress = 0, drunk = 0 }) do
			player.setdb(key, value, true)
		end
		TriggerClientEvent('dolu_hud:healPlayer', player.source)
		utils.debug(1, "Player " .. player.source .. " healed!")
	end
end, {'playerId:number'})


-- dev
RegisterCommand('demo', function(source, args)
	local player = Ox.GetPlayer(args[1] or source)
	if player then
		for key, value in pairs({ hunger = 10, thirst = 5, stress = 80, drunk = 70 }) do
			player.setdb(key, value, true)
		end
		utils.debug(1, "Player " .. player.source .. " healed!")
	end
end, false)