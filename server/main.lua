-- Retrieve status from database and send it to the player
local function initStatus(player)
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

	TriggerClientEvent('dolu_hud:init', player.source, {
		health = player.get('health'),
		armour = player.get('armour'),
		status = status
	})
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

-- Save status in kvp
RegisterNetEvent('dolu_hud:updateStatus', function(status)
	local player = Ox.GetPlayer(source)
	if player then
		SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
		utils.debug(1, "Saved status for player " .. player.source)
	end
end)

lib.addCommand('group.admin', 'heal', function(source, args)
	if source < 1 and not args.target then return end
	local player = Ox.GetPlayer(args.target)
	if player then
		local status = {
			hunger = Config.status.hunger and 100 or nil,
			thirst = Config.status.thirst and 100 or nil,
			stress = Config.status.stress and 0 or nil,
			drunk = Config.status.drunk and 0 or nil,
		}

		TriggerClientEvent('dolu_hud:healPlayer', player.source, {
			health = 100,
			armour = player.get('armour'),
			status = status
		})

		SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
		utils.debug(1, "Player " .. player.source .. " healed!")
	end
end, {'target:number'})

-- Dev
lib.addCommand('group.admin', 'demo', function(source, args)
	if source < 1 and not args.target then return end
	local player = Ox.GetPlayer(args.target)
	if player then
		local status = {
			hunger = math.random(0, 100),
			thirst = math.random(0, 100),
			stress = math.random(0, 100),
			drunk = math.random(0, 100),
		}
		TriggerClientEvent('dolu_hud:healPlayer', player.source, {
			health = math.random(150, 200),
			thirst = math.random(0, 100),
			status = status
		})
		SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
	end
end, {'target:number'})