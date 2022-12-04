AddEventHandler('ox:statusTick', function(_statuses)
	if not PlayerIsDead then
		statuses = _statuses
		SendNUIMessage({
			action = 'setStatuses',
			data = {
				statuses = statuses
			}
		})
		utils.debug(1, json.encode(statuses, {indent=true}))
	end
end)
