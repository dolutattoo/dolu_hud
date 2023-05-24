local isUnderwater, oxygenMax

CreateThread(function()
	while true do
		local wait = 500
		if PlayerIsLoaded and not PlayerIsDead and nuiReady then
			if IsPedSwimmingUnderWater(cache.ped) then
				local oxygenState = GetPlayerUnderwaterTimeRemaining(cache.playerId)

				if not oxygenMax then
					oxygenMax = oxygenState
				end

				SendNUIMessage({
					action = 'setStatuses',
					data = {
						oxygen = utils.percent(oxygenState, oxygenMax)
					}
				})

				isUnderwater = true
				wait = 10

			elseif isUnderwater then
				SendNUIMessage({
					action = 'setStatuses',
					data = {
						oxygen = 100
					}
				})

				isUnderwater = false
				oxygenMax = nil
			end
		end
		Wait(wait)
	end
end)
