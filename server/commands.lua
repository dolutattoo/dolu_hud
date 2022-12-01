lib.addCommand('group.admin', 'heal', function(source, args)
	if source < 1 and not args.target then return end
	local player = Ox.GetPlayer(args.target)
	if player then
		local status = {
			hunger = Config.status.hunger and 100 or nil,
			thirst = Config.status.thirst and 100 or nil,
			stress = Config.status.stress and 0 or nil,
			drunk = Config.status.drunk and 0 or nil
		}

		TriggerClientEvent('dolu_hud:healPlayer', player.source, {
			health = 200,
			armour = player.get('armour'),
			status = status
		})

		SetResourceKvp(('%s:status'):format(player.charid), json.encode(status))
		utils.debug(1, "Player " .. player.source .. " healed!")
	end
end, {'target:number'})

-- Set random status
lib.addCommand('group.admin', 'random', function(source, args)
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
			armour = math.random(0, 100),
			status = status
		})
	end
end, {'target:number'})