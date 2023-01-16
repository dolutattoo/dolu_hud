local isBuckled = false

local Buckled = function ()
    CreateThread(function ()
        while isBuckled do
            DisableControlAction(0, 75, true)
            Wait(0)
        end
    end)
end

SetFlyThroughWindscreenParams(15.0, 20.0, 17.0, 2000.0)
local Seatbelt = function (status)
    if status then
        SendNUIMessage({action = 'setSeatbelt', data = true})
        SetFlyThroughWindscreenParams(1000.0,1000.0,0.0,0.0)
        Buckled()
    else
        SendNUIMessage({action = 'setSeatbelt', data = false})
        SetFlyThroughWindscreenParams(15.0, 20.0, 17.0, 2000.0)
    end
    isBuckled = status
end

local curInVehicle

CreateThread(function ()
    while true do
        if nuiReady then
            local inVehicle = cache.vehicle
            if inVehicle ~= curInVehicle then
                SendNUIMessage({action = 'setSeatbelt', data = isBuckled})
                if not inVehicle and isBuckled then isBuckled = false end
                curInVehicle = inVehicle
                print(curInVehicle)
            end
        end
        Wait(1000)
    end
end)

RegisterCommand('dolu_hud:seatbelt', function ()
    if cache.vehicle then
        local curVehicleClass = GetVehicleClass(cache.vehicle)

        if curVehicleClass ~= 8
        and curVehicleClass ~= 13
        and curVehicleClass ~= 14
        then Seatbelt(not isBuckled) end
    end
end, false)
RegisterKeyMapping('dolu_hud:seatbelt', 'Toggle seatbelt', 'keyboard', Config.seatbeltKey)