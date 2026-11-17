local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local Models = require(game.ReplicatedStorage.Shared.BrainrotModels)
local World = require(script.Parent.World)
local Claim = require(script.Parent.ClaimService)
local Wheel = {gondolas = {}, elapsed = 0}
local rng = Random.new()

function Wheel.stockGondola(gondola, starter)
	local high = gondola.floor.Position.Y > 62
	local roll = rng:NextNumber()
	local rarity
	if high then
		rarity = roll < 0.03 and "Mythic" or roll < 0.2 and "Legendary" or roll < 0.7 and "Epic" or "Rare"
	else
		rarity = roll < 0.8 and "Common" or "Rare"
	end
	local list = Catalog.Stock[rarity]
	local id = starter or list[rng:NextInteger(1, #list)]
	gondola.item = {id = id}
	gondola.character = Models.create(gondola.item, gondola.model)
	gondola.character:ScaleTo(0.85)
	gondola.prompt.ObjectText = Catalog.Characters[id].name .. " • " .. Catalog.money(Catalog.Characters[id].price)
	gondola.prompt.Enabled = true
	gondola.restockAt = nil
	gondola.stockedAt = workspace:GetServerTimeNow()
	gondola.floor.Color = Catalog.Rarities[Catalog.Characters[id].rarity]
end

function Wheel.build(profiles, notify)
	for i = 1, 12 do
		local angle = (i - 1) * math.pi / 6 - math.pi / 2
		local pos = World.wheelCenter + Vector3.new(math.cos(angle) * 36, math.sin(angle) * 36, -7)
		local model = Instance.new("Model")
		model.Name = "Gondola" .. i
		model.Parent = World.root
		local floor = World.part(model, "ClaimFloor", Vector3.new(8, 0.7, 6), CFrame.new(pos), Catalog.Rarities.Common)
		model.PrimaryPart = floor
		for _, x in {-3.6, 3.6} do World.part(model, "Post", Vector3.new(0.3, 6, 0.3), CFrame.new(pos + Vector3.new(x, 3, 2.5)), Color3.fromRGB(255, 194, 104)) end
		World.part(model, "Roof", Vector3.new(8.5, 0.5, 6.5), CFrame.new(pos + Vector3.new(0, 6, 0)), Color3.fromRGB(229, 76, 142), Enum.Material.Neon)
		local gondola = {model = model, floor = floor, offset = angle}
		gondola.prompt = World.prompt(floor, "Klaim & bawa", "", Enum.KeyCode.E, function(player)
			if profiles[player] then Claim.claimFromGondola(player, profiles[player], gondola, notify) end
		end)
		Wheel.stockGondola(gondola, i <= 3 and ({"Kangkung", "Lemper", "Boba"})[i] or nil)
		table.insert(Wheel.gondolas, gondola)
	end
end

function Wheel.spinBianglala(dt)
	Wheel.elapsed += dt
	local angle = Wheel.elapsed * math.pi / 30
	World.rotor:PivotTo(CFrame.new(World.wheelCenter) * CFrame.Angles(0, 0, angle))
	for _, gondola in Wheel.gondolas do
		local a = angle + gondola.offset
		local pos = World.wheelCenter + Vector3.new(math.cos(a) * 36, math.sin(a) * 36, -7)
		gondola.model:PivotTo(CFrame.new(pos))
		if gondola.character then gondola.character:PivotTo(CFrame.new(pos + Vector3.new(0, 2.6 + math.sin(Wheel.elapsed * 2) * 0.15, 0))) end
		local now = workspace:GetServerTimeNow()
		if gondola.restockAt and now >= gondola.restockAt then Wheel.stockGondola(gondola) end
		if gondola.item and now - gondola.stockedAt > 62 then
			gondola.character:Destroy()
			Wheel.stockGondola(gondola)
		end
	end
end

return Wheel
