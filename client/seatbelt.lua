local attached

CreateThread(function()
	SetFlyThroughWindscreenParams(15.0, 20.0, 17.0, 2000.0)

	while true do
		if PlayerIsLoaded and not PlayerIsDead and nuiReady and cache.vehicle and attached then
			DisableControlAction(0, 75, true)
		end
		Wait(0)
	end
end)

local function toggleSeatbelt()
	attached = not attached

	SendNUIMessage({
		action = 'setSeatbelt',
		data = attached
	})

	if attached then
		SetFlyThroughWindscreenParams(1000.0, 1000.0, 0.0, 0.0)
	else
		SetFlyThroughWindscreenParams(15.0, 20.0, 17.0, 2000.0)
	end
end

RegisterCommand('dolu_hud:seatbelt', toggleSeatbelt)
RegisterKeyMapping('dolu_hud:seatbelt', 'Toggle seatbelt', 'keyboard', Config.seatbeltKey)
