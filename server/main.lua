-- Retrieve status from database and send it to the player
local function initStatus(player, data)
	local data = player.get()
	local status = {}

	for name, v in pairs(Config.status) do
		-- Create status if they doesn't exists
		if not data[name] then
			data[name] = v.default
			player.setdb(name, v.default)
		end

		status[name] = data[name]
	end

	status.voiceLevel = Player(player.source).state.proximity.index or 2
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
			if name ~= 'voiceLevel' then
				player.setdb(name, value)
				utils.debug(2, "Saved status for player " .. player.source .. " - " .. name .. ': ' .. value)
			end
		end
	end
	utils.debug(1, "Saved status for player " .. player.source)
end)

lib.addCommand('group.admin', 'heal', function(source, args)
	if source < 1 and not args.target then return end
	local player = Ox.GetPlayer(args.target)
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
			player.setdb(key, value) -- not replicated, let's use the event below since we need to apply health/armour client-side.
		end
		status.voiceLevel = Player(player.source).state.proximity.index or 2
		TriggerClientEvent('dolu_hud:healPlayer', player.source, status)
		utils.debug(1, "Player " .. player.source .. " healed!")
	end
end, {'target:number'})


-- Dev
lib.addCommand('group.admin', 'demo', function(source, args)
	if source < 1 and not args.target then return end
	local player = Ox.GetPlayer(args.target)
	if player then
		for key, value in pairs({ hunger = 10, thirst = 5, stress = 80, drunk = 70 }) do
			player.setdb(key, value, true)
		end
	end
end, {'target:number'})