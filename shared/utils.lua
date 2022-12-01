utils = {}

---Get percentage from a value and his maximum, optionally round
---@param value number
---@param max number
---@param round? number
---@return number
function utils.percent(value, max)
	local percentage = (value * 100) / max
	return percentage > 100 and 100 or percentage < 0 and 0 or percentage
end

---Beautiful debugging logs
---@param level number 1: standard logs, 2: everything
---@param msg string
function utils.debug(level, ...)
	if Config.debug and Config.debug >= (level == true and 1 or level) then
		print('^2[' .. cache.resource .. '][' .. level .. '] ^7', ...)
	end
end