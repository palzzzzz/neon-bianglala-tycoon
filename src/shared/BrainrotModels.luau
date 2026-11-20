local Catalog = require(script.Parent.Catalog)
local Money = require(script.Parent.Money)
local Models = {}
function Models.part(parent, name, size, frame, color, material, shape)
	local p = Instance.new("Part")
	p.Name, p.Size, p.CFrame = name, size, frame
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Shape = shape or Enum.PartType.Block
	p.Anchored, p.CanCollide, p.CanTouch = true, false, false
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end
function Models.label(part, title, detail, color, height)
	local gui = Instance.new("BillboardGui")
	gui.Name, gui.Size = "Label", UDim2.fromScale(16, 4)
	gui.StudsOffset = Vector3.new(0, height or 4, 0)
	gui.MaxDistance, gui.AlwaysOnTop = 65, false
	gui.Parent = part
	local text = Instance.new("TextLabel")
	text.Size, text.BackgroundTransparency = UDim2.fromScale(1, 1), 1
	text.Font, text.TextSize = Enum.Font.GothamBold, 19
	text.TextScaled=true
	text.TextColor3, text.TextStrokeTransparency = color or Color3.new(1,1,1), 0.25
	text.Text = title .. "\n" .. detail
	text.Parent = gui
	return gui
end
function Models.buildFace(model,item)
	local cream=Color3.fromRGB(255,251,232)
	local ink=Color3.fromRGB(40,31,55)
	local function facePart(name,size,pos,color,ball)
		return Models.part(model,name,size,CFrame.new(pos),color,nil,ball and Enum.PartType.Ball)
	end
	for _,side in {-1,1} do
		facePart("EyeWhite",Vector3.new(1.08,1.2,0.5),Vector3.new(side*0.67,4.25,-1.23),cream,true)
		facePart("Pupil",Vector3.new(0.53,0.66,0.23),Vector3.new(side*0.61,4.18,-1.51),ink,true)
		facePart("EyeSpark",Vector3.one*0.18,Vector3.new(side*0.61-0.1,4.38,-1.65),Color3.new(1,1,1),true)
		local brow=facePart("Eyebrow",Vector3.new(0.86,0.17,0.22),Vector3.new(side*0.67,4.99,-1.31),ink)
		brow.CFrame*=CFrame.Angles(0,0,side*(item.rarity=="Common" and -0.12 or 0.2))
		facePart("Cheek",Vector3.new(0.5,0.22,0.16),Vector3.new(side*1.05,3.65,-1.31),Color3.fromRGB(255,145,159),true)
	end
	facePart("Smile",Vector3.new(0.95,0.53,0.22),Vector3.new(0,3.55,-1.36),ink,true)
	facePart("Tooth",Vector3.new(0.54,0.17,0.15),Vector3.new(0,3.71,-1.5),cream)
	if item.shape=="ghost" then
		for _,side in {-1,1} do
			facePart("PremiumGlasses",Vector3.new(1.22,0.5,0.18),Vector3.new(side*0.65,4.37,-1.72),ink)
			facePart("LensGlint",Vector3.new(0.34,0.08,0.05),Vector3.new(side*0.65,4.5,-1.83),Color3.fromRGB(160,232,255))
		end
		facePart("GlassesBridge",Vector3.new(0.4,0.12,0.18),Vector3.new(0,4.4,-1.72),ink)
	elseif item.shape=="skewer" then
		for _,side in {-1,1} do
			local moustache=facePart("SateMoustache",Vector3.new(0.8,0.18,0.15),Vector3.new(side*0.42,3.87,-1.59),ink)
			moustache.CFrame*=CFrame.Angles(0,0,side*0.2)
		end
	elseif item.shape=="fruit" then
		facePart("NangkaBun",Vector3.one*1.5,Vector3.new(0,5.6,0.4),Color3.fromRGB(190,185,61),true)
	end
end
function Models.build(catch, parent)
	local item = Catalog.byId[catch.id]
	local model = Instance.new("Model")
	model.Name = item.name
	local color = item.color
	if catch.mutation == "Gold" then color = Color3.fromRGB(255,207,69)
	elseif catch.mutation == "Diamond" then color = Color3.fromRGB(123,243,255)
	elseif catch.mutation == "Sambal-Lava" then color = Color3.fromRGB(255,78,42) end
	local function piece(name, size, x,y,z, tint, ball)
		return Models.part(model, name, size, CFrame.new(x,y,z), tint or color, nil, ball and Enum.PartType.Ball)
	end
	local core = piece("Body", Vector3.new(2.3,2.8,1.8), 0,2,0, color, true)
	model.PrimaryPart = core
	piece("Head", Vector3.new(2.9,2.6,2.4), 0,4,0, color, true)
	for _, side in {-1,1} do
		piece("Foot", Vector3.new(0.9,0.6,1.3), side*0.65,0.45,-0.2, Color3.fromRGB(64,48,78), true)
		piece("Hand", Vector3.new(0.7,1.6,0.7), side*1.55,2.1,0, color, true)
	end
	local s = item.shape
	if s == "greens" then
		for i=1,5 do piece("Kangkung", Vector3.new(0.65,3.2,0.6), (i-3)*0.4,3.6,1.2, Color3.fromRGB(48,153,75), true) end
		piece("Beard",Vector3.new(1.6,1.3,0.5),0,2.9,-1.2,Color3.new(1,1,1),true)
	elseif s == "parcel" then
		piece("BananaLeaf",Vector3.new(2.6,3,2),0,2,0,Color3.fromRGB(40,138,78))
		piece("ShoppingBag",Vector3.new(1,1.4,0.8),1.9,1.1,0,Color3.fromRGB(255,183,111))
	elseif s == "cup" then
		piece("Straw",Vector3.new(0.3,2,0.3),0.7,5.8,0,Color3.fromRGB(255,117,164))
		for i=1,5 do piece("Pearl",Vector3.one*0.45,(i-3)*0.4,3,-1.05,Color3.fromRGB(65,39,46),true) end
	elseif s == "skewer" or s == "crown" then
		piece("Skewer",Vector3.new(0.2,5,0.2),1.9,3,0,Color3.fromRGB(238,194,120))
		for i=1,3 do piece("Meatball",Vector3.one*0.8,1.9,2.6+i*0.8,0,nil,true) end
	elseif s == "pot" then
		piece("RendangPot",Vector3.new(3.4,0.7,2.6),0,5.2,0,Color3.fromRGB(72,59,86))
		piece("PotLid",Vector3.new(0.6,0.4,0.6),0,5.8,0,Color3.fromRGB(255,206,65))
	elseif s == "speaker" then
		piece("SpeakerCase",Vector3.new(3.1,3,2.4),0,4,0,Color3.fromRGB(49,64,141))
		piece("SpeakerCone",Vector3.new(1.8,1.8,0.3),0,4,-1.3,Color3.fromRGB(86,223,244),true)
		piece("Disco",Vector3.one*1.1,0,6,0,Color3.fromRGB(255,111,200),true)
	elseif s == "whistle" then
		piece("SafetyVest",Vector3.new(2.5,2,1.9),0,2.3,0,Color3.fromRGB(255,145,45))
		piece("Whistle",Vector3.new(0.7,0.4,0.8),0,3.2,-1.4,Color3.fromRGB(255,218,63))
	elseif s == "dragon" or s == "bird" then
		for side=-1,1,2 do
			local wing = piece("Wing",Vector3.new(3,0.5,2),side*2,3,0)
			wing.CFrame *= CFrame.Angles(0,0,side*0.45)
		end
		for i=1,4 do piece("Tail",Vector3.one*(1.5-i*0.2),0,1.6,1+i*0.65,nil,true) end
	elseif s == "ghost" then
		piece("ShroudKnot",Vector3.new(1.2,1.3,0.9),0,5.6,0,Color3.fromRGB(255,209,83),true)
	elseif s == "mortar" then
		piece("StoneBowl",Vector3.new(3.2,1.4,2.6),0,1.3,0,Color3.fromRGB(80,73,91),true)
		piece("Pestle",Vector3.new(0.7,4,0.7),2,2,0,Color3.fromRGB(104,82,69))
	elseif s == "ship" then
		piece("Hull",Vector3.new(4.3,1.1,2.2),0,1,0)
		piece("Mast",Vector3.new(0.25,5.4,0.25),0,3.8,0.9,Color3.fromRGB(96,55,43))
		piece("GoldenSail",Vector3.new(2.3,2.1,0.18),1.1,5.4,0.9,Color3.fromRGB(255,224,133))
	end
	if s == "fruit" or s == "spikes" or s == "halo" then
		for i=1,12 do
			local a = i*math.pi/6
			piece("CrownFruit",Vector3.one*0.65,math.cos(a)*1.45,4+math.sin(a)*1.3,0, s=="halo" and Color3.fromHSV(i/12,0.7,1) or color,true)
		end
	end
	if s == "crown" or s == "spikes" then
		for i=-1,1 do piece("CrownPoint",Vector3.new(0.45,0.9,0.45),i*0.7,5.6,0,Color3.fromRGB(255,224,81)) end
	end
	Models.buildFace(model,item)
	local highlight = Instance.new("Highlight")
	highlight.FillTransparency, highlight.OutlineTransparency = 1, 0.3
	highlight.DepthMode=Enum.HighlightDepthMode.Occluded
	highlight.OutlineColor = Catalog.colors[item.rarity]
	highlight.Parent = model
	Models.collectionLabel(core,item,catch)
	model:SetAttribute("Mutation",catch.mutation or "Normal")
	model:SetAttribute("Dance",item.effect == "dance")
	model.Parent = parent
	return model
end
-- Sparse, tasteful sparkles drifting around a model (invisible emitter box matching its bounds).
function Models.sparkle(model,color,size,rate,speed)
	local box,extent=model:GetBoundingBox()
	return Models.sparkleField(model,box,extent*0.9,color,size,rate,speed)
end
-- Invisible emitter box with the shared soft sparkle look (giants, front-row Mythics, garden).
function Models.sparkleField(parent,frame,extent,color,size,rate,speed)
	local field=Models.part(parent,"SparkleField",extent,frame,color)
	field.Transparency,field.CastShadow=1,false
	local e=Instance.new("ParticleEmitter")
	e.Name="Sparkle"
	e.Shape,e.ShapeStyle=Enum.ParticleEmitterShape.Box,Enum.ParticleEmitterShapeStyle.Volume
	e.Color=ColorSequence.new(color:Lerp(Color3.new(1,1,1),0.55))
	e.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.5,size),NumberSequenceKeypoint.new(1,0)})
	e.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.25,0.1),NumberSequenceKeypoint.new(0.75,0.25),NumberSequenceKeypoint.new(1,1)})
	e.Lifetime=NumberRange.new(1.8,3)
	e.Rate=rate
	e.Speed=NumberRange.new(speed*0.4,speed)
	e.SpreadAngle=Vector2.new(180,180)
	e.Rotation,e.RotSpeed=NumberRange.new(0,360),NumberRange.new(-40,40)
	e.LightEmission,e.LightInfluence=1,0
	e.Parent=field
	return field
end
-- Decor-only "planted anomaly": a character at a growth scale, sunk into a soil bed, no label, no interaction.
-- stage 1 = small sprout, 2 = half-grown, 3 = full size.
local GROWTH={0.3,0.6,1}
function Models.plant(parent,id,position,yaw,stage)
	local scale=GROWTH[stage]
	local model=Models.build({id=id,mutation="Normal"},parent)
	for _,d in model:GetDescendants() do
		if d:IsA("BillboardGui") or d:IsA("Highlight") then d:Destroy() end
	end
	model:SetAttribute("Idle",nil)
	model:ScaleTo(scale)
	model:PivotTo(CFrame.new(position)*CFrame.Angles(0,yaw,0))
	local box,size=model:GetBoundingBox()
	model:TranslateBy(Vector3.new(0,position.Y-0.25*scale-(box.Position.Y-size.Y/2),0))
	for _,d in model:GetDescendants() do
		if d:IsA("BasePart") then d.CanCollide,d.CanTouch,d.CanQuery=false,false,false end
	end
	if stage==1 then
		-- sprout leaves on top of the little head
		local top=box.Position.Y+size.Y/2+position.Y-0.25*scale-(box.Position.Y-size.Y/2)
		for side=-1,1,2 do
			local leaf=Models.part(model,"SproutLeaf",Vector3.new(0.9,0.12,0.5),CFrame.new(position.X+side*0.45,top+0.2,position.Z)*CFrame.Angles(0,0,side*0.5),Color3.fromRGB(96,205,104),nil,Enum.PartType.Ball)
			leaf.CanCollide=false
		end
	end
	model.Name="Anomali_"..Catalog.byId[id].name
	return model
end
-- GIANT decor copy: real scaled model standing on the ground, name label overhead, no interaction.
function Models.giant(parent,id,position,yaw,scale)
	local item=Catalog.byId[id]
	local model=Models.build({id=id,mutation="Normal"},parent)
	for _,d in model:GetDescendants() do
		if d:IsA("BillboardGui") or d:IsA("Highlight") then d:Destroy() end
	end
	model:ScaleTo(scale)
	model:PivotTo(CFrame.new(position)*CFrame.Angles(0,yaw,0))
	local box,size=model:GetBoundingBox()
	model:TranslateBy(Vector3.new(0,position.Y-(box.Position.Y-size.Y/2),0))
	for _,d in model:GetDescendants() do
		if d:IsA("BasePart") then d.CastShadow,d.CanCollide,d.CanTouch,d.CanQuery=true,false,false,false end
	end
	model.Name="Giant_"..item.name
	local color=Catalog.colors[item.rarity]
	local box2,size2=model:GetBoundingBox()
	local core=model.PrimaryPart
	local label=Instance.new("BillboardGui")
	label.Name,label.Size="GiantLabel",UDim2.fromScale(46,12)
	label.Adornee=core
	label.StudsOffsetWorldSpace=Vector3.new(0,box2.Position.Y+size2.Y/2+9-core.Position.Y,0)
	label.MaxDistance,label.AlwaysOnTop=700,false
	label.Parent=core
	local name=Instance.new("TextLabel")
	name.Size,name.BackgroundTransparency=UDim2.fromScale(1,0.62),1
	name.Text,name.Font,name.TextScaled=item.name,Enum.Font.GothamBlack,true
	name.TextColor3,name.TextStrokeColor3,name.TextStrokeTransparency=Color3.new(1,1,1),Color3.fromRGB(40,30,58),0
	name.Parent=label
	local tier=Instance.new("TextLabel")
	tier.Size,tier.Position,tier.BackgroundTransparency=UDim2.fromScale(1,0.34),UDim2.fromScale(0,0.64),1
	tier.Text,tier.Font,tier.TextScaled=item.rarity:upper(),Enum.Font.GothamBlack,true
	tier.TextColor3,tier.TextStrokeColor3,tier.TextStrokeTransparency=color,Color3.fromRGB(40,30,58),0
	tier.Parent=label
	Models.sparkle(model,color,scale*0.45,7,scale*0.3)
	return model
end
function Models.collectionLabel(core,item,catch)
	local label=Instance.new("BillboardGui")
	label.Name,label.Size="CollectionLabel",UDim2.fromScale(14,4.8)
	label.StudsOffset, label.MaxDistance=Vector3.new(0,6.7,0),85
	label.AlwaysOnTop=false
	label.Parent=core
	local mutation=catch.mutation or "Normal"
	-- Only: name, mutation tag (if any), income.
	local rows={{item.name,Color3.new(1,1,1)}}
	if mutation~="Normal" then table.insert(rows,{mutation,Catalog.colors[item.rarity]}) end
	table.insert(rows,{Money.rate(Catalog.income(catch)),Color3.fromRGB(172,255,164)})
	for i,row in rows do
		local text=Instance.new("TextLabel")
		text.Name="Line"..i
		text.Size,text.Position=UDim2.fromScale(1,1/#rows),UDim2.fromScale(0,(i-1)/#rows)
		text.BackgroundTransparency=1
		text.Text,text.TextSize,text.Font=row[1],i==1 and 26 or 25,Enum.Font.GothamBlack
		text.TextScaled=true
		text.TextColor3=row[2]
		text.TextStrokeColor3,text.TextStrokeTransparency=Color3.fromRGB(40,30,58),0
		text.Parent=label
	end
end
return Models
