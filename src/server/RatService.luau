local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local World = require(script.Parent.World)
local Stall = require(script.Parent.StallService)
local Rats = {active = {}, timer = 0}

function Rats.ratStealAttempt(rat, profiles, notify)
	local profile = profiles[rat.player]
	local stall = profile and profile.stalls[rat.index]
	if not stall or not stall.item then return end
	if stall.lockedUntil > workspace:GetServerTimeNow() then
		notify(rat.player, "Tikus kecele: lapak terkunci!", "defend")
		local _, label = World.sign(rat.model, "?!", Vector3.new(3, 2, 0.2), rat.model:GetPivot() * CFrame.new(0, 3, 0), Color3.fromRGB(255, 220, 90))
		label.Text = "?!"
	else
		local loss = math.min(profile.cash, Catalog.rate(stall.item) * 20)
		profile.cash -= loss
		notify(rat.player, "TIKUS! Uang dicuri " .. Catalog.money(loss) .. ". Kunci lapak dengan T.", "rat")
	end
end

function Rats.spawnRat(profiles)
	local start = Vector3.new(-112, 1.5, 26)
	local nearest, distance
	for player, profile in profiles do
		local plot = Stall.plots[player]
		if plot then
			for index, stall in profile.stalls do
				if stall.item and stall.lockedUntil <= workspace:GetServerTimeNow() then
					local d = (plot.slots[index].origin - start).Magnitude
					if not distance or d < distance then nearest, distance = {player = player, index = index, target = plot.slots[index].origin + Vector3.new(0, 1.5, 0)}, d end
				end
			end
		end
	end
	if not nearest then return end
	local model = Instance.new("Model")
	model.Name = "TikusPasar"
	model.Parent = World.root
	local body = World.part(model, "Body", Vector3.new(2.4, 1.5, 4), CFrame.new(start), Color3.fromRGB(113, 91, 134))
	body.Shape = Enum.PartType.Ball
	body.CanCollide = false
	model.PrimaryPart = body
	for _, x in {-0.8, 0.8} do
		local ear = World.part(model, "Ear", Vector3.new(1.1, 1.2, 0.4), CFrame.new(start + Vector3.new(x, 1, -1)), Color3.fromRGB(235, 132, 171))
		ear.Shape = Enum.PartType.Ball
		ear.CanCollide = false
	end
	local tail = World.part(model, "Tail", Vector3.new(0.25, 0.25, 4), CFrame.new(start + Vector3.new(0, 0, 3)), Color3.fromRGB(235, 132, 171))
	tail.CanCollide = false
	nearest.model, nearest.position, nearest.home = model, start, start
	table.insert(Rats.active, nearest)
end

function Rats.update(dt, night, profiles, notify)
	if night then
		Rats.timer += dt
		if Rats.timer >= 20 then Rats.timer = 0 Rats.spawnRat(profiles) end
	else Rats.timer = 0 end
	for i = #Rats.active, 1, -1 do
		local rat = Rats.active[i]
		local target = rat.fleeing and rat.home or rat.target
		local delta = target - rat.position
		if delta.Magnitude < 1 then
			if rat.fleeing then rat.model:Destroy() table.remove(Rats.active, i) else
				Rats.ratStealAttempt(rat, profiles, notify)
				rat.fleeing = true
			end
		else
			rat.position += delta.Unit * math.min(delta.Magnitude, dt * (rat.fleeing and 24 or 12))
			rat.model:PivotTo(CFrame.lookAt(rat.position, target))
		end
	end
end

return Rats
