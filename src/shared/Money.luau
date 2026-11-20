-- Shared short money formatter: 950 -> "$950", 12000 -> "$12K", 3400000 -> "$3.4M", 1.2e9 -> "$1.2B".
local Money = {}
local suffixes = {"", "K", "M", "B", "T", "Qa"}
function Money.format(amount)
	amount = math.max(0, amount or 0)
	if amount < 1000 then return "$" .. math.floor(amount + 0.5) end
	local index, value = 1, amount
	while index < #suffixes and value >= 1000 do
		value /= 1000
		index += 1
	end
	local rounded = math.floor(value * 10 + 0.5) / 10
	if rounded >= 1000 and index < #suffixes then rounded, index = 1, index + 1 end
	local text = rounded % 1 == 0 and tostring(math.floor(rounded)) or string.format("%.1f", rounded)
	return "$" .. text .. suffixes[index]
end
function Money.rate(amount)
	return Money.format(amount) .. "/s"
end
return Money
