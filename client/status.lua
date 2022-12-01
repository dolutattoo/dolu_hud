AddEventHandler('ox:statusTick', function(_statuses)
	statuses = _statuses

	for name, value in pairs(statuses) do
		SendNUIMessage({
			action = 'setStatusValue',
			data = {
				statusName = name,
				value = value
			}
		})
	end

	utils.debug(1, json.encode(statuses, {indent=true}))
end)