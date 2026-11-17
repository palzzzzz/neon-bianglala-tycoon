local Catalog = require(script.Parent.Catalog)
local Models = {}

local function part(model, name, size, position, color, shape, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = CFrame.new(position)
	p.Color = color
	p.Anchored = true
	p.CanCollide = false
	p.CanTouch = false
	p.Material = material or Enum.Material.SmoothPlastic
	p.Shape = shape or Enum.PartType.Block
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = model
	return p
end

function Models.create(item, parent)
	local data = Catalog.Characters[item.id]
	local model = Instance.new("Model")
	model.Name = data.name
	local color = data.color
	local neon = Enum.Material.Neon
	local ball = Enum.PartType.Ball
	if item.mutation == "Gold" then color = Color3.fromRGB(255, 204, 38) end
	if item.mutation == "Diamond" then color = Color3.fromRGB(135, 242, 255) end
	if item.mutation == "Sambal-Lava" then color = Color3.fromRGB(255, 75, 30) end
	local body = part(model, "Body", Vector3.new(2.4, 2.7, 1.7), Vector3.new(0, 2.5, 0), color, ball)
	model.PrimaryPart = body
	for _, x in {-0.7, 0.7} do
		part(model, "Shoe", Vector3.new(1, 0.65, 1.6), Vector3.new(x, 0.4, -0.3), Color3.fromRGB(54, 35, 65))
		part(model, "Arm", Vector3.new(0.6, 1.7, 0.7), Vector3.new(x * 2.2, 2.6, 0), color, ball)
	end
	local head = part(model, "Head", Vector3.new(2, 1.8, 1.8), Vector3.new(0, 4.1, 0), color, ball)
	for _, x in {-0.5, 0.5} do
		part(model, "EyeWhite", Vector3.new(0.65, 0.75, 0.22), Vector3.new(x, 4.3, -0.83), Color3.new(1, 1, 1), ball)
		part(model, "Pupil", Vector3.new(0.27, 0.38, 0.18), Vector3.new(x + 0.07, 4.28, -0.98), Color3.fromRGB(25, 19, 42), ball)
	end
	part(model, "Grin", Vector3.new(0.8, 0.15, 0.16), Vector3.new(0, 3.78, -0.94), Color3.fromRGB(42, 22, 37))
	local shape = data.shape
	if shape == "cup" then
		body.Shape = Enum.PartType.Cylinder
		body.Size = Vector3.new(2.7, 2.5, 2.5)
		body.CFrame *= CFrame.Angles(0, 0, math.pi / 2)
		part(model, "MilkLid", Vector3.new(2.8, 0.25, 2.8), Vector3.new(0, 3.85, 0), Color3.fromRGB(255, 225, 195))
		part(model, "Straw", Vector3.new(0.35, 2.4, 0.35), Vector3.new(0.8, 5.05, 0.2), Color3.fromRGB(255, 103, 151))
		for i = 1, 5 do part(model, "BobaPearl", Vector3.new(0.45, 0.45, 0.45), Vector3.new(-0.9 + i * 0.3, 1.5 + (i % 2) * 0.4, -1.1), Color3.fromRGB(57, 30, 39), ball) end
	elseif shape == "greens" then
		for i = 1, 7 do
			local leaf = part(model, "KangkungLeaf", Vector3.new(0.9, 3, 0.4), Vector3.new((i - 4) * 0.4, 4.4, 1), Color3.fromRGB(76 + i * 12, 170, 55), ball)
			leaf.CFrame *= CFrame.Angles(0, 0, (i - 4) * 0.16)
		end
		part(model, "Beard", Vector3.new(1.3, 1.3, 0.4), Vector3.new(0, 3.4, -0.9), Color3.fromRGB(235, 230, 219), ball)
	elseif shape == "parcel" then
		body.Shape = Enum.PartType.Block
		part(model, "LeafTie", Vector3.new(2.5, 0.3, 1.85), Vector3.new(0, 2.3, 0), Color3.fromRGB(244, 214, 122))
		part(model, "ShoppingBag", Vector3.new(1.2, 1.4, 0.8), Vector3.new(2, 1.9, -0.2), Color3.fromRGB(245, 117, 145))
	elseif shape == "skewer" then
		part(model, "Skewer", Vector3.new(0.18, 6, 0.18), Vector3.new(0, 3, 0), Color3.fromRGB(233, 200, 140))
		for i = 1, 3 do part(model, "Meatball", Vector3.new(1.8, 1.4, 1.6), Vector3.new(0, 0.4 + i * 1.25, 0), color, ball) end
	elseif shape == "speaker" then
		head.Shape = Enum.PartType.Block
		head.Size = Vector3.new(3, 2.8, 1.8)
		part(model, "SpeakerCone", Vector3.new(1.6, 1.6, 0.35), Vector3.new(0, 4.4, -1), Color3.fromRGB(28, 25, 47), ball)
		part(model, "SpeakerGlow", Vector3.new(0.7, 0.7, 0.4), Vector3.new(0, 4.4, -1.18), Catalog.Rarities.Epic, ball, neon)
		part(model, "Disco", Vector3.new(1, 1, 1), Vector3.new(0, 6, 0), Color3.fromRGB(255, 82, 177), ball, neon)
	elseif shape == "ghost" then
		body.Size = Vector3.new(2.4, 4, 2.1)
		part(model, "Sunglasses", Vector3.new(1.9, 0.5, 0.3), Vector3.new(0, 4.35, -1), Color3.fromRGB(22, 19, 37))
		part(model, "GoldenKnot", Vector3.new(0.7, 1.3, 0.7), Vector3.new(0, 5.5, 0), Color3.fromRGB(255, 202, 62), ball)
	elseif shape == "fruit" then
		body.Size = Vector3.new(3.6, 3.8, 2.8)
		for i = 1, 12 do
			local a = i * math.pi / 6
			local spike = part(model, "DurianSpike", Vector3.new(0.5, 1.1, 0.5), Vector3.new(math.cos(a) * 1.65, 2.7 + math.sin(a) * 1.7, 0), color)
			spike.CFrame *= CFrame.Angles(0, 0, a - math.pi / 2)
		end
	elseif shape == "boat" then
		body.Size = Vector3.new(5, 1.4, 2.6)
		part(model, "Mast", Vector3.new(0.25, 5.4, 0.25), Vector3.new(0, 4.5, 0.4), Color3.fromRGB(91, 49, 44))
		part(model, "GoldenSail", Vector3.new(3.2, 2.8, 0.18), Vector3.new(0, 5.4, 0.4), Color3.fromRGB(255, 229, 152))
	elseif shape == "dragon" or shape == "bird" then
		for side = -1, 1, 2 do
			local wing = part(model, "Wing", Vector3.new(4, 0.4, 2.7), Vector3.new(side * 2.7, 3.3, 0.4), color)
			wing.CFrame *= CFrame.Angles(0, 0, side * 0.4)
		end
		for i = 1, 4 do part(model, "TailPlate", Vector3.new(2 - i * 0.25, 0.7, 2), Vector3.new(0, 2.3 - i * 0.25, i * 1.1), color, ball) end
	elseif shape == "pot" or shape == "mortar" then
		part(model, "Bowl", Vector3.new(3.5, 1.8, 3), Vector3.new(0, 4.8, 0), Color3.fromRGB(80, 70, 89), ball)
		part(model, "Pestle", Vector3.new(0.6, 4.5, 0.6), Vector3.new(2, 2.8, 0), Color3.fromRGB(128, 100, 83))
	elseif shape == "vest" then
		part(model, "Reflector", Vector3.new(2.5, 0.4, 1.85), Vector3.new(0, 2.7, 0), Color3.fromRGB(233, 255, 120), nil, neon)
		part(model, "Whistle", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, 3, -1), Color3.fromRGB(255, 215, 78), ball)
	end
	if data.rarity == "Legendary" or data.rarity == "Brainrot God" or item.id == "Sultan" then
		for i = -1, 1 do part(model, "Crown", Vector3.new(0.5, 0.9 + (i == 0 and 0.5 or 0), 0.6), Vector3.new(i * 0.65, 5.25, 0), Color3.fromRGB(255, 216, 57), nil, neon) end
	end
	if shape == "rainbow" or item.mutation == "Rainbow" then
		for i = 1, 7 do part(model, "RainbowHalo", Vector3.new(0.8, 0.8, 0.8), Vector3.new(math.cos(i * math.pi * 2 / 7) * 2, 6, math.sin(i * math.pi * 2 / 7) * 2), Color3.fromHSV(i / 7, 0.8, 1), ball, neon) end
	end
	local highlight = Instance.new("Highlight")
	highlight.FillTransparency = 1
	highlight.OutlineColor = Catalog.Rarities[data.rarity]
	highlight.OutlineTransparency = 0.35
	highlight.Parent = model
	if data.rarity ~= "Common" then
		local spark = Instance.new("Sparkles")
		spark.SparkleColor = Catalog.Rarities[data.rarity]
		spark.Parent = body
	end
	local label = Instance.new("BillboardGui")
	label.Name = "Identity"
	label.Size = UDim2.fromOffset(280, 85)
	label.StudsOffsetWorldSpace = Vector3.new(0, 4.7, 0)
	label.MaxDistance = 65
	label.Parent = body
	local text = Instance.new("TextLabel")
	text.Size = UDim2.fromScale(1, 1)
	text.BackgroundTransparency = 1
	text.TextColor3 = Catalog.Rarities[data.rarity]
	text.TextStrokeTransparency = 0.2
	text.TextStrokeColor3 = Color3.fromRGB(24, 15, 38)
	text.Font = Enum.Font.FredokaOne
	text.TextSize = 18
	text.Text = (item.mutation and item.mutation .. " " or "") .. data.name .. "\n" .. string.upper(data.rarity) .. "  •  " .. Catalog.money(Catalog.rate(item)) .. "/s"
	text.Parent = label
	model:PivotTo(CFrame.new(0, 2.5, 0))
	model.Parent = parent
	return model
end

return Models
