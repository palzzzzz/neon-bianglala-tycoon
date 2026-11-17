local Tide={level=0,night=0,isNight=false,elapsed=0}
function Tide.isStallFlooded(stall)
	return stall.level<5 and Tide.level>=stall.level
end
function Tide.raiseTide(level,world)
	Tide.level=level
	world.water.Position=Vector3.new(0,level*3,0)
end
function Tide.lowerTide(progress,world)
	Tide.level=math.max(0,5*(1-progress))
	world.water.Position=Vector3.new(0,math.max(-1,Tide.level*3),0)
end
function Tide.update(elapsed,world,announce)
	Tide.elapsed=elapsed
	local phase=elapsed%240
	local wasNight=Tide.isNight
	Tide.isNight=phase>=180
	if Tide.isNight then
		Tide.night=math.floor(elapsed/240)+1
		local level=math.min(5,math.floor((phase-180)/12)+1)
		if not wasNight or (level==3 and Tide.level~=3) then announce("BANJIR ROB RISING! Naikkan tiang lapak!") end
		Tide.raiseTide(level,world)
	elseif elapsed>=240 and phase<10 then Tide.lowerTide(phase/10,world)
	else Tide.level=0;world.water.Position=Vector3.new(0,-1,0) end
	return Tide.isNight and not wasNight
end
return Tide
