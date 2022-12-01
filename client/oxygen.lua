local isUnderwater, oxygenMax

CreateThread(function()
	while true do
		local wait = 200

		if nuiReady then
			if IsPedSwimmingUnderWater(PlayerPedId()) then
				local oxygenState = GetPlayerUnderwaterTimeRemaining(PlayerId())
				if not oxygenMax then
					oxygenMax = oxygenState
				end
				SendNUIMessage({
					action = 'setStatusValue',
					data = {
						statusName = 'oxygen',
						value = utils.percent(oxygenState, oxygenMax)
					}
				})
				isUnderwater = true
				wait = 10

			elseif isUnderwater then
				SendNUIMessage({
					action = 'setStatusValue',
					data = {
						statusName = 'oxygen',
						value = 100
					}
				})
				isUnderwater = false
				oxygenMax = nil
			end
		end
		Wait(wait)
	end
end)