AddStateBagChangeHandler('dead', 'player:' .. cache.serverId, function(_, _, value)
	if not nuiReady or not PlayerIsLoaded then return end
	if value then
		SendNUIMessage({ action = 'toggleVisibility', data = false })
	else
		if PlayerIsDead then
			TriggerEvent('dolu_hud:init', {
				health = 200,
				armour = 0,
				status = {
					hunger = Config.status.hunger.default * 0.75,
					thirst = Config.status.thirst.default * 0.75,
					stress = Config.status.stress.default,
					drunk = Config.status.drunk.default
				}
			})
		end
		SendNUIMessage({ action = 'toggleVisibility', data = true })
	end
	PlayerIsDead = value
end)