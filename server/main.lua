-- Retrieve status from database and send it to the player
local function initStatus(player, data)
	local data = player.get()

	-- Create status if they doesn't exists
	for name, v in pairs(Config.status) do
		if not data[name] then
			player.setdb(name, v.default)
			data[name] = v.default
		end
	end

	local status = {
		voiceLevel = Player(player.source).state.proximity.index or 2,
		health = data.health,
		armour = data.armour,
		hunger = data.hunger,
		thirst = data.thirst,
		stress = data.stress,
		drunk = data.drunk,
	}

	TriggerClientEvent('dolu_hud:initStatus', player.source, status)
end

-- Send status when resource restart
AddEventHandler('onResourceStart', function(resourceName)
	if resourceName ~= cache.resource then return end
	SetTimeout(200, function()
		local players = Ox.GetPlayers()
		for i = 1, #players do
			initStatus(players[i])
		end
	end)
end)

-- Send status when character is loaded
AddEventHandler('ox:playerLoaded', function(source, userid, charid)
	local player = Ox.GetPlayer(source)
	initStatus(player)
end)

-- Save status in database
RegisterNetEvent('dolu_hud:updateStatus', function(status)
	local player = Ox.GetPlayer(source)
	if player then
		for name, value in pairs(status) do
			player.setdb(name, value)
			utils.debug(2, "Saved status for player " .. player.source .. " - " .. name .. ': ' .. value)
		end
	end
	utils.debug(1, "Saved status for player " .. player.source)
end)

lib.addCommand('group.admin', 'heal', function(source, args)
	if source < 1 and not args.target then return end
	local player = Ox.GetPlayer(args.target or source)
	if player then
		local status = {
			voiceLevel = Player(player.source).state.proximity.index or 2,
			health = 100,
			armour = player.get('armour'),
			hunger = 100,
			thirst = 100,
			stress = 0,
			drunk = 0,
		}
		for key, value in pairs(status) do
			player.setdb(key, value)
		end
		TriggerClientEvent('dolu_hud:healPlayer', player.source, status)
		utils.debug(1, "Player " .. player.source .. " healed!")
	end
end, {'target:number'})


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