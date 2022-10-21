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
		health = data.health,
		armour = data.armour,
		hunger = data.hunger,
		thirst = data.thirst,
		stress = data.stress,
		drunk = data.drunk,
	})
end)

RegisterNetEvent('ox:status:add', function(name, value)
	local player = Ox.GetPlayer(source)
	local currentStatus = player.get(name)

	value = utils.percent(value, 1000000, 2) -- Because people use 1000000 as max value

	local newStatus = utils.formatPercentage(currentStatus + value)
	player.setdb(name, newStatus, true)
	utils.debug(1, "^7Action:add:^5" .. name, "^7Value added:^5" .. value, "^7New status:^5" .. newStatus .. "^7")
end)

RegisterNetEvent('ox:status:remove', function(name, value)
	local player = Ox.GetPlayer(source)
	local currentStatus = player.get(name)

	value = utils.percent(value, 1000000, 2) -- Because people use 1000000 ax max value

	local newStatus = utils.formatPercentage(currentStatus - value)
	player.setdb(name, newStatus, true)
	utils.debug(1, "^7Action:remove:^5" .. name, "^7Value removed:^5" .. value, "^7New status:^5" .. newStatus .. "^7")
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

RegisterCommand('heal', function(source, args)
	local player = Ox.GetPlayer(args[1] or source)
	if player then
		for key, value in pairs({ hunger = 100, thirst = 100, stress = 0, drunk = 0 }) do
			player.setdb(key, value, true)
		end
		utils.debug(1, "Player " .. player.source .. " healed!")
	end
end, false)

RegisterCommand('random', function(source, args)
	local player = Ox.GetPlayer(args[1] or source)
	if player then
		for key, value in pairs({ hunger = 85, thirst = 25, stress = 80, drunk = 70 }) do
			player.setdb(key, value, true)
		end
		utils.debug(1, "Player " .. player.source .. " healed!")
	end
end, false)