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
		local isRadarDisplayed = false
		DisplayRadar(false)

		while true do
			if PlayerIsLoaded and not PlayerIsDead and cache.vehicle and not isRadarDisplayed then
				DisplayRadar(true)
			elseif (not cache.vehicle or PlayerIsDead or not PlayerIsLoaded) and isRadarDisplayed then
				DisplayRadar(false)
			end
			isRadarDisplayed = not isRadarDisplayed
			Wait(200)
		end
	end)
end
