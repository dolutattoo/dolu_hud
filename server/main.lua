-- Retrieve status from database and send it to the player
local function initStatus(player)
	local data = GetResourceKvpString(('%s:status'):format(player.charid))
	local decode = json.decode(data) or {}
	local status = {}

	for name, v in pairs(Config.status) do
		-- Create status if they doesn't exists
		if not decode[name] then
			decode[name] = v.default
			TriggerClientEvent('dolu_hud:setPlayerData', player.source, name, v.default)
		end

		status[name] = decode[name]
	end

	status.voiceLevel = Player(player.source).state.proximity.index or 2
	SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
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
		SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
	end
	utils.debug(1, "Saved status for player " .. player.source)
end)

lib.addCommand('group.admin', 'heal', function(source, args)
	if source < 1 and not args.target then return end
	local player = Ox.GetPlayer(args.target)
	if player then
		local status = {
			health = 100,
			armour = player.get('armour'),
			hunger = Config.status.hunger and 100 or nil,
			thirst = Config.status.thirst and 100 or nil,
			stress = Config.status.stress and 0 or nil,
			drunk = Config.status.drunk and 0 or nil,
		}

		for key, value in pairs(status) do
			TriggerClientEvent('dolu_hud:setPlayerData', player.source, key, value) -- not replicated, let's use the event below since we need to apply health/armour client-side.
		end

		status.voiceLevel = Player(player.source).state.proximity.index or 2
		SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
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