Config = {}

Config.debug = false -- false=disabled, 1=basics, 2=everything
Config.updateInterval = 2500 -- how fast to loop for updating status (/!\ Will affect values in Config.status below!)
Config.updateDatabaseInterval = 60*1000 -- Frenquency when client send status to server to save in database

Config.status = {
	['hunger'] = { -- status name
		default = 100, -- default status state
		onTick = {
			action = "remove", -- when ticked, add or remove?
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