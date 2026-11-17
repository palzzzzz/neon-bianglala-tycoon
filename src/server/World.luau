local World = {}
local warm = Color3.fromRGB(255, 181, 75)
local pink = Color3.fromRGB(255, 81, 156)
local teal = Color3.fromRGB(49, 225, 217)
local dark = Color3.fromRGB(40, 33, 65)

function World.part(parent, name, size, cf, color, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

function World.sign(parent, text, size, cf, color)
	local p = World.part(parent, "Sign", size, cf, dark)
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 35
	gui.Parent = p
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(0.94, 0.9)
	label.Position = UDim2.fromScale(0.03, 0.05)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or warm
	label.Font = Enum.Font.FredokaOne
	label.TextScaled = true
	label.Parent = gui
	return p, label
end

function World.prompt(parent, action, object, key, callback)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = action
	prompt.ObjectText = object
	prompt.KeyboardKeyCode = key or Enum.KeyCode.E
	prompt.MaxActivationDistance = 13
	prompt.RequiresLineOfSight = false
	prompt.HoldDuration = 0.2
	prompt.Parent = parent
	prompt.Triggered:Connect(callback)
	return prompt
end

function World.beam(parent, a, b, width, color, material)
	return World.part(parent, "Strut", Vector3.new(width, width, (b - a).Magnitude), CFrame.lookAt((a + b) / 2, b), color, material)
end

function World.build()
	local old = workspace:FindFirstChild("Baseplate")
	if old then old:Destroy() end
	local root = Instance.new("Folder")
	root.Name = "PasarMalam"
	root.Parent = workspace
	World.root = root
	World.part(root, "Island", Vector3.new(245, 10, 225), CFrame.new(0, -5, 0), Color3.fromRGB(63, 66, 78), Enum.Material.Slate)
	World.part(root, "Plaza", Vector3.new(218, 0.4, 200), CFrame.new(0, 0.2, 0), Color3.fromRGB(89, 66, 86), Enum.Material.Cobblestone)
	World.water = World.part(root, "BanjirRob", Vector3.new(900, 2, 900), CFrame.new(0, -3, 0), Color3.fromRGB(23, 165, 175), Enum.Material.Glass)
	World.water.Transparency = 0.35
	World.water.CanCollide = false
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "PasarSpawn"
	spawn.Anchored = true
	spawn.Size = Vector3.new(12, 1, 12)
	spawn.CFrame = CFrame.new(0, 1, -84)
	spawn.Color = teal
	spawn.Neutral = true
	spawn.Duration = 0
	spawn.Material = Enum.Material.Neon
	spawn.Parent = root
	World.sign(root, "BIANGLALA\nBRAINROT", Vector3.new(57, 14, 2), CFrame.new(0, 79, 14), warm)
	World.sign(root, "KLAIM → LAPAK → FUSION\nNaik tangga • E ambil • E taruh • F pilih bahan", Vector3.new(36, 5, 1), CFrame.new(0, 7, -98) * CFrame.Angles(0, math.pi, 0), teal)
	for _, z in {-3, 10} do
		World.beam(root, Vector3.new(-26, 1, z), Vector3.new(0, 43, z), 2.6, pink, Enum.Material.Metal)
		World.beam(root, Vector3.new(26, 1, z), Vector3.new(0, 43, z), 2.6, pink, Enum.Material.Metal)
	end
	World.part(root, "Axle", Vector3.new(5, 5, 23), CFrame.new(0, 43, 3), warm, Enum.Material.Neon)
	World.wheelCenter = Vector3.new(0, 43, 0)
	World.rotor = Instance.new("Model")
	World.rotor.Name = "BianglalaNeon"
	World.rotor.Parent = root
	for i = 1, 48 do
		local a, b = i * math.pi / 24, (i + 1) * math.pi / 24
		for _, z in {-2, 6} do
			World.beam(World.rotor, Vector3.new(math.cos(a) * 36, 43 + math.sin(a) * 36, z), Vector3.new(math.cos(b) * 36, 43 + math.sin(b) * 36, z), 0.65, i % 2 == 0 and pink or teal, Enum.Material.Neon)
		end
		if i % 4 == 0 then World.beam(World.rotor, World.wheelCenter, World.wheelCenter + Vector3.new(math.cos(a) * 36, math.sin(a) * 36, 0), 0.6, warm, Enum.Material.Neon) end
	end
	World.rotor.WorldPivot = CFrame.new(World.wheelCenter)
	for i = 1, 32 do
		local x = 42 + math.floor((i - 1) / 16) * 12
		local z = -66 + ((i - 1) % 16) * 3.5
		if i > 16 then z = -13.5 - ((i - 1) % 16) * 3.5 end
		World.part(root, "ClaimStair", Vector3.new(12, 1.3, 4), CFrame.new(x, i * 1.25, z), Color3.fromRGB(104, 77, 118))
	end
	for _, y in {3, 21, 41} do
		World.part(root, "ClaimLanding", Vector3.new(26, 1, 15), CFrame.new(41, y, -12), dark)
		World.part(root, "ClaimRing", Vector3.new(19, 0.18, 0.5), CFrame.new(38, y + 0.6, -18), teal, Enum.Material.Neon)
	end
	World.part(root, "UpperClaimWalkway", Vector3.new(12, 1, 58), CFrame.new(54, 41, -39), dark)
	World.part(root, "UpperSafetyRail", Vector3.new(0.4, 3, 58), CFrame.new(60, 43, -39), teal, Enum.Material.Neon)
	World.sign(root, "KLAIM GONDOLA\nATAS = PELUANG LANGKA", Vector3.new(27, 6, 1), CFrame.new(46, 48, -3), teal)
	World.fusion = World.part(root, "GerobakFusion", Vector3.new(15, 4, 9), CFrame.new(-65, 3, -28), Color3.fromRGB(137, 57, 131))
	World.sign(root, "GEROBAK FUSION\n2 BAHAN → 1 KEAJAIBAN", Vector3.new(24, 7, 1), CFrame.new(-65, 13, -24), pink)
	for _, x in {-69, -61} do
		World.part(root, "IngredientSlot", Vector3.new(5, 0.4, 5), CFrame.new(x, 5.3, -28), teal, Enum.Material.Neon)
		local wheel = World.part(root, "CartWheel", Vector3.new(3, 3, 1), CFrame.new(x, 1.5, -33), dark)
		wheel.Shape = Enum.PartType.Cylinder
		wheel.CFrame *= CFrame.Angles(0, math.pi / 2, 0)
	end
	World.rebirth = World.sign(root, "BUKA CABANG\nIncome permanen +1× • Lapak +2", Vector3.new(34, 9, 2), CFrame.new(0, 10, 87), warm)
	World.part(root, "PhotoStage", Vector3.new(26, 2, 18), CFrame.new(82, 1, -75), dark)
	World.sign(root, "PASAR MALAM\nBIANGLALA BRAINROT", Vector3.new(28, 12, 1), CFrame.new(82, 9, -66), pink)
	for i = 1, 14 do
		local x = -104 + (i - 1) * 16
		for _, z in {-104, 100} do
			World.part(root, "LanternPost", Vector3.new(0.6, 18, 0.6), CFrame.new(x, 9, z), dark)
			local lamp = World.part(root, "Lantern", Vector3.new(2, 2.5, 2), CFrame.new(x, 18, z), i % 2 == 0 and pink or warm, Enum.Material.Neon)
			local light = Instance.new("PointLight")
			light.Color = lamp.Color
			light.Range = 25
			light.Brightness = 0.7
			light.Parent = lamp
		end
	end
	for i = 1, 7 do
		local x = -100 + i * 25
		World.beam(root, Vector3.new(x, 18, -104), Vector3.new(x, 18, 100), 0.1, dark)
		for j = 1, 10 do
			local lamp = World.part(root, "FestoonBulb", Vector3.new(0.8, 0.8, 0.8), CFrame.new(x, 18 - math.sin(j / 11 * math.pi) * 3, -104 + j * 18), Color3.fromHSV((i + j) / 18, 0.7, 1), Enum.Material.Neon)
			lamp.Shape = Enum.PartType.Ball
		end
	end
	for _, x in {-93, 93} do
		for _, z in {-20, 18, 55} do
			World.part(root, "Warung", Vector3.new(13, 4, 9), CFrame.new(x, 2, z), Color3.fromRGB(140, 79, 65))
			for stripe = -3, 3 do World.part(root, "StripedCanopy", Vector3.new(2, 0.5, 12), CFrame.new(x + stripe * 2, 10, z), stripe % 2 == 0 and warm or pink) end
			for _, dx in {-6, 6} do World.part(root, "TentPost", Vector3.new(0.4, 10, 0.4), CFrame.new(x + dx, 5, z), warm) end
		end
	end
	local lighting = game:GetService("Lighting")
	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Density = 0.22
	atmosphere.Color = Color3.fromRGB(213, 182, 232)
	atmosphere.Parent = lighting
	local bloom = Instance.new("BloomEffect")
	bloom.Intensity = 0.35
	bloom.Size = 24
	bloom.Threshold = 1.2
	bloom.Parent = lighting
	local correction = Instance.new("ColorCorrectionEffect")
	correction.Saturation = 0.12
	correction.Contrast = 0.08
	correction.Parent = lighting
	return World
end

return World
