Config = {}

Config.debug = 1
Config.updateInterval = 2500
Config.updateDatabaseInterval = 60*1000

Config.status = {
	['hunger'] = {
		default = 100,
		onTick = {
			action = "remove",
			value = 0.1
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