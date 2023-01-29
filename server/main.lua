local function healPlayer(source, target, armour)
	local player = Ox.GetPlayer(target)

	if not player then
		if source == 0 then
			print('Player not found!')
		else
			lib.notify(source, {
				type = 'error',
				description = "Player not found!",
			})
		end
		return
	end

	player.setStatus('hunger', 0)
	player.setStatus('thirst', 0)
	player.setStatus('stress', 0)
	player.setStatus('drunk', 0)

	lib.callback('dolu_hud:healPlayer', target, function(success)
		if success then
			lib.notify(source, {
				type = 'success',
				description = "Player ID " .. target .. " have been healed!",
			})
		else
			lib.notify(source, {
				type = 'error',
				description = "Player ID " .. target .. " cannot be healed!",
			})
		end
	end, armour)
end

lib.addCommand('group.admin', 'heal', function(source, args)
	if not args.target then
		if source == 0 then
			print('Usage: heal [playerId]')
		else
			healPlayer(source, args.target, args.armour)
		end
	else
		healPlayer(source, args.target, args.armour)
	end
end, { 'target:number', 'armour:?number' })

if Config.setStatusesAfterDeath.enabled then
	RegisterNetEvent('dolu_hud:revived', function()
		local player = Ox.GetPlayer(source)
		if player then
			player.setStatus('hunger', Config.setStatusesAfterDeath.hunger)
			player.setStatus('thirst', Config.setStatusesAfterDeath.thirst)
			player.setStatus('stress', Config.setStatusesAfterDeath.stress)
			player.setStatus('drunk', Config.setStatusesAfterDeath.drunk)
		end
	end)
end
