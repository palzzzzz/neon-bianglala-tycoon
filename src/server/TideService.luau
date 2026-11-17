local Tide = {level = 0, elapsed = 0, night = false, height = -2}

function Tide.isStallFlooded(stall)
	if stall.level >= 5 then return false end
	return Tide.level >= stall.level
end

function Tide.raiseTide(seconds)
	Tide.level = math.min(5, 1 + math.floor(seconds / 12))
	Tide.height = Tide.level * 3
end

function Tide.lowerTide(seconds)
	Tide.height = 15 - math.clamp(seconds / 10, 0, 1) * 17
	Tide.level = math.max(0, math.ceil(Tide.height / 3))
end

function Tide.update(dt, world)
	Tide.elapsed += dt
	local cycle = Tide.elapsed % 240
	Tide.night = cycle >= 180
	if Tide.night then
		Tide.raiseTide(cycle - 180)
	elseif Tide.elapsed >= 240 and cycle < 10 then
		Tide.lowerTide(cycle)
	else
		Tide.level, Tide.height = 0, -2
	end
	world.water.Position = Vector3.new(0, Tide.height - 1, 0)
	game:GetService("Lighting").ClockTime = Tide.night and 0.2 or 17.3
	workspace:SetAttribute("TideLevel", Tide.level)
	workspace:SetAttribute("Night", Tide.night)
	workspace:SetAttribute("CycleRemaining", math.ceil(Tide.night and (240 - cycle) or (180 - cycle)))
end

return Tide
