utils = {}

---Round a number to the given number of decimal places
---@param num number
---@param decimals number
---@return number
function utils.round(num, decimals)
	return tonumber(('%.' .. (decimals or 0) .. 'f'):format(num))
end

---Keep a value between 0 and 100
---@param value number
---@return number
function utils.formatPercentage(value)
	return value > 100 and 100 or value < 0 and 0 or value
end

---Get percentage from a value and his maximum, optionally round
---@param value number
---@param max number
---@param round? number
---@return number
function utils.percent(value, max, round)
	local percentage = (value * 100) / max
	if round then
		percentage = utils.round(percentage, round)
	end
	return percentage > 100 and 100 or percentage < 0 and 0 or percentage
end

---Beautiful debugging logs
---@param level number 1: standard logs, 2: everything
---@param msg string
function utils.debug(level, msg)
	if Config.debug and Config.debug >= level then
		print('^2[dolu_hud][' .. level .. '] ^7' .. msg)
	end
end