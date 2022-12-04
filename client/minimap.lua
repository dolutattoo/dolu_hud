-- Hide Health & Armour under minimap
CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")

	Wait(500)
    SetRadarBigmapEnabled(true, false)
    Wait(500)
    SetRadarBigmapEnabled(false, false)

    while true do
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        Wait(0)
    end
end)

-- Hide radar if not in a vehicle
if Config.hideRadarOnFoot then
	CreateThread(function()
		local isRadarDisplayed, vehicle = false, false
		DisplayRadar(isRadarDisplayed)

		while true do
			if PlayerIsLoaded and not PlayerIsDead and cache.vehicle ~= vehicle then
				isRadarDisplayed = not isRadarDisplayed
				vehicle = cache.vehicle
				DisplayRadar(isRadarDisplayed)

				SendNUIMessage({
					action = 'toggleSpeedo',
					data = vehicle and true or false
				})
			end

			Wait(200)
		end
	end)
end
