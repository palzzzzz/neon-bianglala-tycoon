local Models = require(game.ReplicatedStorage.Shared.BrainrotModels)
local Money = require(game.ReplicatedStorage.Shared.Money)
local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local World = {}
function World.create()
	local lighting=game:GetService("Lighting")
	lighting.ClockTime,lighting.Brightness,lighting.ExposureCompensation=16.2,2.2,0.05
	lighting.Ambient=Color3.fromRGB(168,142,160)
	lighting.OutdoorAmbient=Color3.fromRGB(196,170,176)
	lighting.GlobalShadows=true
	local atmosphere=Instance.new("Atmosphere")
	atmosphere.Density,atmosphere.Haze,atmosphere.Color=0.12,0.3,Color3.fromRGB(255,206,170)
	atmosphere.Parent=lighting
	local grade=Instance.new("ColorCorrectionEffect")
	grade.Name,grade.Saturation,grade.Contrast,grade.TintColor="WarmGrade",0.3,0.06,Color3.fromRGB(255,238,214)
	grade.Parent=lighting
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
	local marquee=part("WheelMarquee",Vector3.new(33,6,1),Vector3.new(0,14,-10),Color3.fromRGB(104,78,149))
	local title=Instance.new("SurfaceGui")
	title.Face,title.CanvasSize,title.Parent=Enum.NormalId.Front,Vector2.new(1100,200),marquee
	local titleText=Instance.new("TextLabel")
	titleText.Size,titleText.BackgroundTransparency=UDim2.fromScale(1,1),1
	titleText.Font,titleText.TextSize=Enum.Font.GothamBlack,65
	titleText.TextColor3=Color3.fromRGB(255,232,148)
	titleText.Text="BIANGLALA BRAINROT\nPASAR MALAM · REZEKI BERPUTAR"
	titleText.Parent=title
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
	Models.label(branch,"BUKA CABANG",Money.format(Catalog.rebirthBase).." lifetime → income ×2",Color3.new(1,1,1),5)
	part("PhotoStage",Vector3.new(22,2,16),Vector3.new(75,1,65),palette[1])
	for i=1,8 do
		if i==2 then continue end -- Keep the spawn and its camera approach unobstructed.
		local a=i*math.pi/4
		local p=Vector3.new(math.cos(a)*96,0,math.sin(a)*82)
		part("MarketTent",Vector3.new(12,1,9),p+Vector3.new(0,9,0),palette[i%3+1])
		for stripe=-2,2 do
			part("AwningStripe",Vector3.new(1,0.12,9.2),p+Vector3.new(stripe*2,9.6,0),Color3.fromRGB(255,244,219))
		end
		part("MarketCounter",Vector3.new(10,3,6),p+Vector3.new(0,1.5,0),palette[(i+1)%3+1])
		for fruit=1,5 do
			local produce=part("FruitBasket",Vector3.one*1.2,p+Vector3.new(fruit*1.5-4.5,3.8,0),palette[fruit%3+1])
			produce.Shape=Enum.PartType.Ball
		end
		for _, side in {-1,1} do part("TentPole",Vector3.new(0.6,9,0.6),p+Vector3.new(side*5,4.5,0),Color3.fromRGB(108,79,99)) end
		local lantern=part("Lantern",Vector3.one*1.5,p+Vector3.new(0,11,0),palette[i%3+1],Enum.Material.Neon)
		local light=Instance.new("PointLight")
		light.Brightness,light.Range,light.Color=2,28,palette[2]
		light.Parent=lantern
	end
	for i=1,24 do
		local a=i*math.pi/12
		local p=Vector3.new(math.cos(a)*56,0,math.sin(a)*53+6)
		local lamp=part("PlazaBulb",Vector3.one*0.8,p+Vector3.new(0,12,0),palette[i%3+1],Enum.Material.Neon)
		if i%3==0 then
			part("FestivalPole",Vector3.new(0.45,12,0.45),p+Vector3.new(0,6,0),Color3.fromRGB(128,95,116))
			local lampLight=Instance.new("PointLight");lampLight.Range=24;lampLight.Brightness=0.7;lampLight.Color=palette[2];lampLight.Parent=lamp
		end
		local nextA=(i+1)*math.pi/12
		local q=Vector3.new(math.cos(nextA)*56,12,math.sin(nextA)*53+6)
		local from=p+Vector3.new(0,12,0)
		Models.part(root,"FestivalWire",Vector3.new(0.08,0.08,(q-from).Magnitude),CFrame.lookAt((q+from)/2,q),Color3.fromRGB(89,69,103))
	end
	for i=1,16 do
		local a=i*math.pi/8
		local p=Vector3.new(math.cos(a)*109,0,math.sin(a)*97)
		part("Planter",Vector3.new(5,1.5,5),p+Vector3.new(0,0.75,0),palette[2])
		local shrub=part("PastelShrub",Vector3.new(5,5,5),p+Vector3.new(0,3,0),Color3.fromRGB(114,204,155))
		shrub.Shape=Enum.PartType.Ball
	end
	-- KEBUN ANOMALI: decor-only garden in front of the wheel (no planting mechanics).
	local garden=Instance.new("Folder")
	garden.Name,garden.Parent="KebunAnomali",root
	local function gpart(name,size,pos,color,material,shape)
		return Models.part(garden,name,size,pos,color,material,shape)
	end
	local wood,soil=Color3.fromRGB(150,102,66),Color3.fromRGB(92,64,50)
	local plantIds={"kangkung","lemper","boba","pentol","nangka","rendang","koplo","parkir","naga"}
	local perBed={4,3,2} -- small sprouts, half-grown, full size
	local rowZ={14,6,-2} -- sprouts at the front, full-size anomalies nearest the wheel
	local planted=0
	for side=-1,1,2 do
		for _,cx in {side*14,side*26} do
			for row=1,3 do
				local cz=rowZ[row]
				gpart("BedFrame",Vector3.new(10.6,0.9,5.6),CFrame.new(cx,0.45,cz),wood)
				gpart("SoilBed",Vector3.new(10,0.95,5),CFrame.new(cx,0.5,cz),soil)
				for k=1,perBed[row] do
					planted+=1
					local px=cx-5+(k-0.5)*10/perBed[row]
					Models.plant(garden,plantIds[(planted-1)%#plantIds+1],Vector3.new(px,0.95,cz),math.pi,row)
				end
			end
		end
		-- seed packets on stakes at the row ends
		for row=1,3 do
			local colorPick=palette[(row+side+1)%3+1]
			gpart("PacketStake",Vector3.new(0.18,3.2,0.18),CFrame.new(side*7.4,1.6,rowZ[row]+2.2),wood)
			local packet=gpart("SeedPacket",Vector3.new(1.6,2.2,0.12),CFrame.new(side*7.4,3.7,rowZ[row]+2.2),colorPick)
			for _,face in {Enum.NormalId.Front,Enum.NormalId.Back} do
				local gui=Instance.new("SurfaceGui")
				gui.Face,gui.CanvasSize,gui.Parent=face,Vector2.new(160,220),packet
				local label=Instance.new("TextLabel")
				label.Size,label.BackgroundTransparency=UDim2.fromScale(1,1),1
				label.Font,label.TextScaled=Enum.Font.GothamBlack,true
				label.TextColor3=Color3.fromRGB(58,42,76)
				label.Text="BIBIT\nANOMALI"
				label.Parent=gui
			end
		end
		-- soft sparkle drifting over this half of the garden (same look as the giants)
		Models.sparkleField(garden,CFrame.new(side*20,3.5,6),Vector3.new(24,7,21),Color3.fromRGB(255,222,140),0.8,5,1)
	end
	-- wooden entrance sign over the central path
	for _,x in {-9.5,9.5} do gpart("SignPost",Vector3.new(0.9,11,0.9),CFrame.new(x,5.5,21),wood) end
	local board=gpart("KebunSign",Vector3.new(21,3.8,0.6),CFrame.new(0,9.6,21),Color3.fromRGB(176,124,78))
	gpart("SignRail",Vector3.new(22,0.5,0.9),CFrame.new(0,11.7,21),wood)
	for _,face in {Enum.NormalId.Front,Enum.NormalId.Back} do
		local gui=Instance.new("SurfaceGui")
		gui.Face,gui.CanvasSize,gui.Parent=face,Vector2.new(840,152),board
		local label=Instance.new("TextLabel")
		label.Size,label.BackgroundTransparency=UDim2.fromScale(1,1),1
		label.Font,label.TextScaled=Enum.Font.GothamBlack,true
		label.TextColor3,label.TextStrokeColor3,label.TextStrokeTransparency=Color3.fromRGB(255,240,200),Color3.fromRGB(74,46,34),0
		label.Text="KEBUN ANOMALI"
		label.Parent=gui
	end
	-- watering cans
	for _,can in {{Vector3.new(8.6,0,10),0.6,Color3.fromRGB(103,212,203)},{Vector3.new(-8.6,0,2),math.pi-0.5,Color3.fromRGB(255,137,139)}} do
		local base=CFrame.new(can[1])*CFrame.Angles(0,can[2],0)
		local function piece(name,size,offset,color,shape,rotation)
			return Models.part(garden,name,size,base*CFrame.new(offset)*(rotation or CFrame.new()),color,nil,shape)
		end
		piece("CanBody",Vector3.new(1.7,1.8,1.8),Vector3.new(0,0.9,0),can[3],Enum.PartType.Cylinder,CFrame.Angles(0,0,math.pi/2))
		piece("CanTop",Vector3.new(0.15,1.8,1.8),Vector3.new(0,1.8,0),Color3.fromRGB(240,240,235),Enum.PartType.Cylinder,CFrame.Angles(0,0,math.pi/2))
		piece("CanSpout",Vector3.new(0.3,0.3,2.1),Vector3.new(0,1.5,-1.7),can[3],nil,CFrame.Angles(math.rad(35),0,0))
		piece("CanRose",Vector3.new(0.9,0.9,0.3),Vector3.new(0,2.3,-2.5),Color3.fromRGB(240,240,235),Enum.PartType.Cylinder,CFrame.Angles(0,math.pi/2,0))
		piece("CanHandleTop",Vector3.new(0.25,0.25,1.3),Vector3.new(0,2.2,0.85),Color3.fromRGB(240,240,235),nil,CFrame.Angles(math.rad(-25),0,0))
		piece("CanHandleLow",Vector3.new(0.25,1.4,0.25),Vector3.new(0,1.3,1.45),Color3.fromRGB(240,240,235))
	end
	-- loose seed packets lying by the paths
	for _,loose in {{Vector3.new(7.4,0.1,6),0.4},{Vector3.new(-7.4,0.1,10),-0.5}} do
		local flat=Models.part(garden,"LooseSeedPacket",Vector3.new(1.6,0.12,2.2),CFrame.new(loose[1])*CFrame.Angles(0,loose[2],0),palette[2])
		local gui=Instance.new("SurfaceGui")
		gui.Face,gui.CanvasSize,gui.Parent=Enum.NormalId.Top,Vector2.new(160,220),flat
		local label=Instance.new("TextLabel")
		label.Size,label.BackgroundTransparency=UDim2.fromScale(1,1),1
		label.Font,label.TextScaled,label.TextColor3=Enum.Font.GothamBlack,true,Color3.fromRGB(58,42,76)
		label.Text="BIBIT"
		label.Parent=gui
	end
	-- Five GIANT permanent decor copies (8x) of the five highest-rarity characters.
	local giants=Instance.new("Folder")
	giants.Name,giants.Parent="Giants",root
	for _,g in {
		{"maharaja",Vector3.new(-76,0.3,-96),math.pi},       -- behind the front stalls
		{"phoenix",Vector3.new(-36,0.3,-14),math.rad(160)},  -- beside the ferris wheel
		{"pocongphoenix",Vector3.new(-30,0.3,52),math.rad(200)}, -- near the fusion cart
		{"pinisidurian",Vector3.new(-74,0.3,88),math.rad(180)},   -- by the home base
		{"nagarujak",Vector3.new(106,0.3,22),math.rad(110)},     -- near the flood stilts
	} do
		Models.giant(giants,g[1],g[2],g[3],8)
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
