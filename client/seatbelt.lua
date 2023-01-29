local isBuckled = false
local curInVehicle

local function updateSeatbeltHud(state)
	SendNUIMessage({action = 'setSeatbelt', data = state})
	if state then
		SetFlyThroughWindscreenParams(1000.0,1000.0,0.0,0.0)
	else
		SetFlyThroughWindscreenParams(15.0, 20.0, 17.0, 2000.0)
	end
end

CreateThread(function()
	updateSeatbeltHud(false)
    while true do
        if nuiReady then
            local inVehicle = cache.vehicle
            if inVehicle ~= curInVehicle then
                updateSeatbeltHud(isBuckled)
                if not inVehicle and isBuckled then isBuckled = false end
                curInVehicle = inVehicle
            end
        end
        Wait(1000)
    end
end)

RegisterCommand('dolu_hud:seatbelt', function()
    if cache.vehicle then
        local curVehicleClass = GetVehicleClass(cache.vehicle)

        if curVehicleClass ~= 8 and curVehicleClass ~= 13 and curVehicleClass ~= 14 then
			if not isBuckled then
				updateSeatbeltHud(true)
				repeat
					DisableControlAction(0, 75, true)
					Wait(0)
				until not isBuckled
			else
				updateSeatbeltHud(false)
			end
			isBuckled = not isBuckled
		end
    end
end, false)
RegisterKeyMapping('dolu_hud:seatbelt', 'Toggle seatbelt', 'keyboard', Config.seatbeltKey)