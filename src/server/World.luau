local Models = require(game.ReplicatedStorage.Shared.BrainrotModels)
local World = {}
function World.create()
	local lighting=game:GetService("Lighting")
	lighting.ClockTime,lighting.Brightness,lighting.ExposureCompensation=16.2,2.2,0.05
	lighting.Ambient=Color3.fromRGB(151,145,173)
	lighting.OutdoorAmbient=Color3.fromRGB(174,177,199)
	lighting.GlobalShadows=false
	local atmosphere=Instance.new("Atmosphere")
	atmosphere.Density,atmosphere.Haze,atmosphere.Color=0.12,0.35,Color3.fromRGB(255,222,204)
	atmosphere.Parent=lighting
	local bloom=Instance.new("BloomEffect")
	bloom.Intensity,bloom.Size,bloom.Threshold=0.2,20,1.7
	bloom.Parent=lighting
	local old = workspace:FindFirstChild("Market")
	if old then old:Destroy() end
	local baseplate = workspace:FindFirstChild("Baseplate")
	if baseplate then baseplate:Destroy() end
	local root = Instance.new("Folder")
	root.Name, root.Parent = "Market", workspace
	local function part(name,size,pos,color,material)
		local p = Models.part(root,name,size,CFrame.new(pos),color,material)
		p.CanCollide = true
		return p
	end
	local palette = {Color3.fromRGB(255,137,139),Color3.fromRGB(255,205,113),Color3.fromRGB(103,212,203)}
	part("Island",Vector3.new(230,8,210),Vector3.new(0,-4,0),Color3.fromRGB(218,183,145))
	part("Plaza",Vector3.new(120,0.3,135),Vector3.new(0,0.15,5),Color3.fromRGB(241,210,181))
	local sea = part("Sea",Vector3.new(1600,1,1600),Vector3.new(0,-3,0),Color3.fromRGB(57,170,184),Enum.Material.Glass)
	sea.CanCollide = false
	local water = part("BanjirRob",Vector3.new(232,0.3,212),Vector3.new(0,-1,0),Color3.fromRGB(51,211,211),Enum.Material.Glass)
	water.CanCollide, water.Transparency = false, 0.35
	local spawn = Instance.new("SpawnLocation")
	spawn.Name, spawn.Size, spawn.CFrame = "MarketSpawn", Vector3.new(14,1,12), CFrame.new(0,1,75)
	spawn.Anchored, spawn.Neutral, spawn.Duration = true,true,0
	spawn.Color, spawn.Material = palette[3], Enum.Material.Neon
	spawn.Parent = root
	local welcome = part("Welcome",Vector3.new(24,8,1),Vector3.new(0,9,90),palette[1])
	local welcomeLabel=Models.label(welcome,"BIANGLALA BRAINROT","KLAIM → LAPAK → FUSION",Color3.new(1,1,1),0)
	welcomeLabel.Size=UDim2.fromOffset(540,105)
	welcomeLabel.TextLabel.TextSize=34
	local wheel = Instance.new("Model")
	wheel.Name, wheel.Parent = "Bianglala", root
	local center = Vector3.new(0,46,-22)
	for _, x in {-13,13} do
		local support = part("WheelSupport",Vector3.new(3,51,4),Vector3.new(x,23,-17),Color3.fromRGB(111,91,173))
		support.CFrame *= CFrame.Angles(0,0,x>0 and 0.25 or -0.25)
	end
	local hub = part("Hub",Vector3.one*7,center,Color3.fromRGB(255,225,103),Enum.Material.Neon)
	hub.Shape = Enum.PartType.Ball
	for i=1,48 do
		local a,b = i*math.pi/24,(i+1)*math.pi/24
		local p,q = center+Vector3.new(math.cos(a)*40,math.sin(a)*40,0),center+Vector3.new(math.cos(b)*40,math.sin(b)*40,0)
		local beam = Models.part(wheel,"Rim",Vector3.new(1,1,(p-q).Magnitude),CFrame.lookAt((p+q)/2,q),palette[(i%3)+1],Enum.Material.Neon)
		beam.CanCollide = false
	end
	for i=1,12 do
		local a=i*math.pi/6
		local endPoint=center+Vector3.new(math.cos(a)*39,math.sin(a)*39,0)
		Models.part(wheel,"Spoke",Vector3.new(0.4,0.4,39),CFrame.lookAt((center+endPoint)/2,endPoint),palette[2],Enum.Material.Neon)
	end
	-- Broad zig-zag stairways give access to the side and top claim decks.
	for flight=0,3 do
		for step=1,20 do
			local y=flight*20+step
			local z=flight%2==0 and (43-step*3) or (-17+step*3)
			part("ClaimStair",Vector3.new(11,1.1,3.3),Vector3.new(48+flight*5,y,z),palette[2])
		end
		local z=flight%2==0 and -17 or 43
		part("Landing",Vector3.new(17,1,13),Vector3.new(50+flight*5,(flight+1)*20,z),palette[3])
	end
	part("SkyBridge",Vector3.new(73,1,11),Vector3.new(31,81,-17),palette[1])
	part("TopLandingWalkway",Vector3.new(11,1,71),Vector3.new(63,81,13),palette[2])
	part("TopClaimDeck",Vector3.new(18,1,18),Vector3.new(0,81,-17),palette[3])
	local fusion=part("FusionCart",Vector3.new(13,4,8),Vector3.new(-43,2,27),palette[1])
	Models.label(fusion,"GEROBAK FUSION","Pilih 2 bahan di lapak [F]",Color3.fromRGB(255,238,171),5)
	for _, x in {-47,-39} do part("IngredientTray",Vector3.new(3,0.4,3),Vector3.new(x,4.3,27),palette[2],Enum.Material.Neon) end
	local branch=part("BranchGate",Vector3.new(24,4,4),Vector3.new(0,3,-83),palette[2])
	Models.label(branch,"BUKA CABANG","$250.000 lifetime → income ×2",Color3.new(1,1,1),5)
	part("PhotoStage",Vector3.new(22,2,16),Vector3.new(75,1,65),palette[1])
	for i=1,8 do
		if i==2 then continue end -- Keep the spawn and its camera approach unobstructed.
		local a=i*math.pi/4
		local p=Vector3.new(math.cos(a)*96,0,math.sin(a)*82)
		part("MarketTent",Vector3.new(12,1,9),p+Vector3.new(0,9,0),palette[i%3+1])
		part("MarketCounter",Vector3.new(10,3,6),p+Vector3.new(0,1.5,0),palette[(i+1)%3+1])
		for _, side in {-1,1} do part("TentPole",Vector3.new(0.6,9,0.6),p+Vector3.new(side*5,4.5,0),Color3.fromRGB(108,79,99)) end
		local lantern=part("Lantern",Vector3.one*1.5,p+Vector3.new(0,11,0),palette[i%3+1],Enum.Material.Neon)
		local light=Instance.new("PointLight")
		light.Brightness,light.Range,light.Color=2,28,palette[2]
		light.Parent=lantern
	end
	return {root=root,water=water,center=center,fusion=fusion,branch=branch,spawn=spawn}
end
function World.prompt(part, action, key, callback, distance)
	local prompt=Instance.new("ProximityPrompt")
	prompt.ActionText, prompt.ObjectText = action,part.Name
	prompt.KeyboardKeyCode = key or Enum.KeyCode.E
	prompt.MaxActivationDistance, prompt.RequiresLineOfSight = distance or 12,false
	prompt.HoldDuration = 0.12
	prompt.Parent=part
	prompt.Triggered:Connect(function(player)
		local character=player.Character
		local root=character and character:FindFirstChild("HumanoidRootPart")
		if root and (root.Position-part.Position).Magnitude <= prompt.MaxActivationDistance+3 then callback(player) end
	end)
	return prompt
end
return World
