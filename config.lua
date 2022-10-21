Config = {}

Config.debug = false -- false=disabled, 1=basics, 2=everything
Config.hideRadarOnFoot = true -- If true, show the radar only when seating in a vehicle
Config.updateInterval = 2500 -- How fast to loop for updating status (/!\ Will affect values in Config.status below!)
Config.updateDatabaseInterval = 60*1000 -- Frenquency when client send status to server to save in database

Config.status = {
	['hunger'] = { -- status name
		default = 100, -- default status state (percentage)
		onTick = { -- depends of Config.updateInterval
			action = "remove", -- add/remove
			value = 0.1 -- how much? (percentage)
		}
	},
	['thirst'] = {
		default = 100,
		onTick = {
			action = "remove",
			value = 0.1
		}
	},
	['stress'] = {
		default = 0,
		onTick = {
			action = "remove",
			value = 0.1
		}
	},
	['drunk'] = {
		default = 0,
		onTick = {
			action = "remove",
			value = 0.1
		}
	}
}