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

-- Reduce health if low statuses
if Config.damagePedIfLowStatuses.enabled then
	CreateThread(function()
		while true do
			if PlayerIsLoaded and not PlayerIsDead and statuses then
				local playerHealth = GetEntityHealth(cache.ped)

				for _, v in pairs(statuses) do
					if v >= 95 then
						SetEntityHealth(cache.ped, playerHealth - Config.damagePedIfLowStatuses.amount)
					end
				end
			end
			Wait(Config.damagePedIfLowStatuses.rate)
		end
	end)
end
