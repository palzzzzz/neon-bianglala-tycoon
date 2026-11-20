-- HOME poster screen: cinematic wheel + plaza camera, title, full 16-character lineup, buttons.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Catalog=require(game.ReplicatedStorage.Shared.Catalog)
local Models=require(game.ReplicatedStorage.Shared.BrainrotModels)
local Money=require(game.ReplicatedStorage.Shared.Money)
local Home={open=false}
local NAVY=Color3.fromRGB(44,39,74)
local CREAM=Color3.fromRGB(255,244,216)
local GOLD=Color3.fromRGB(255,198,119)
local LINEUP_Z=66
local SPACING=6.3
local CAMERA_POS=Vector3.new(0,26,108)
local CAMERA_TARGET=Vector3.new(0,15,60)

local function round(object,radius)
	local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,radius or 12);c.Parent=object
end
local function stroke(object,color,thickness)
	local s=Instance.new("UIStroke");s.Color,s.Thickness=color,thickness or 2
	s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Parent=object
	return s
end

local function buildLineup()
	local folder=Instance.new("Folder")
	folder.Name="HomeLineup"
	for slot=1,16 do
		local item=Catalog.items[slot]
		local x=(slot-8.5)*SPACING
		local color=Catalog.colors[item.rarity]
		local base=Models.part(folder,"HomePedestal",Vector3.new(5.2,1.2,5.2),CFrame.new(x,0.9,LINEUP_Z),Color3.fromRGB(70,60,110),Enum.Material.SmoothPlastic,Enum.PartType.Cylinder)
		base.CFrame=CFrame.new(x,0.9,LINEUP_Z)*CFrame.Angles(0,0,math.pi/2)
		local glow=Models.part(folder,"HomeGlow",Vector3.new(0.3,5.6,5.6),CFrame.new(x,1.55,LINEUP_Z)*CFrame.Angles(0,0,math.pi/2),color,Enum.Material.Neon,Enum.PartType.Cylinder)
		local light=Instance.new("PointLight");light.Color,light.Range,light.Brightness=color,14,1.5;light.Parent=glow
		local model=Models.build({id=item.id,mutation="Normal"},folder)
		model:PivotTo(CFrame.new(x,2.15,LINEUP_Z))
		local core=model.PrimaryPart
		local old=core and core:FindFirstChild("CollectionLabel")
		if old then old:Destroy() end
		-- two-line label: name / $ per second (alternating heights so neighbours never collide)
		local label=Instance.new("BillboardGui")
		label.Name,label.Size="HomeLabel",UDim2.fromScale(12.4,3)
		label.StudsOffset=Vector3.new(0,slot%2==0 and 11.4 or 7.2,0)
		label.AlwaysOnTop,label.MaxDistance=false,400
		label.Adornee=core
		label.Parent=core
		local rows={item.name,Money.rate(item.rate)}
		for i,value in rows do
			local t=Instance.new("TextLabel")
			t.Size,t.Position=UDim2.fromScale(1,0.5),UDim2.fromScale(0,(i-1)/2)
			t.BackgroundTransparency=1
			t.Text,t.Font,t.TextScaled=value,Enum.Font.GothamBlack,true
			t.TextColor3=i==2 and Color3.fromRGB(172,255,164) or Color3.new(1,1,1)
			t.TextStrokeColor3,t.TextStrokeTransparency=Color3.fromRGB(40,30,58),0
			t.Parent=label
		end
	end
	folder.Parent=workspace
	return folder
end

local function chip(parent,value,x,width)
	local f=Instance.new("TextLabel")
	f.Size,f.Position=UDim2.fromScale(width,1),UDim2.fromScale(x,0)
	f.BackgroundColor3,f.BackgroundTransparency=NAVY,0.05
	f.Text,f.TextColor3,f.Font=value,Color3.fromRGB(255,231,123),Enum.Font.GothamBlack
	f.TextScaled=true
	f.Parent=parent
	round(f,14);stroke(f,GOLD,2)
	local pad=Instance.new("UIPadding")
	pad.PaddingTop,pad.PaddingBottom=UDim.new(0.18,0),UDim.new(0.18,0)
	pad.Parent=f
	return f
end
local function button(parent,value,position,size,color,textColor,callback)
	local b=Instance.new("TextButton")
	b.Name,b.Size,b.Position=value,size,position
	b.Text,b.Font,b.TextScaled=value,Enum.Font.GothamBlack,true
	b.BackgroundColor3,b.TextColor3=color,textColor
	b.Parent=parent
	round(b,16);stroke(b,Color3.fromRGB(44,39,74),3)
	local pad=Instance.new("UIPadding");pad.PaddingTop,pad.PaddingBottom=UDim.new(0.2,0),UDim.new(0.2,0);pad.Parent=b
	b.Activated:Connect(callback)
	return b
end

function Home.create(Hud,Index)
	Home.Hud,Home.Index=Hud,Index
	local gui=Instance.new("ScreenGui")
	gui.Name,gui.ResetOnSpawn,gui.IgnoreGuiInset,gui.DisplayOrder="HomeGui",false,true,10
	gui.Enabled=false
	gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
	Home.gui=gui
	local title=Instance.new("TextLabel")
	title.Name,title.Size,title.Position="Judul",UDim2.fromScale(0.78,0.17),UDim2.fromScale(0.11,0.025)
	title.BackgroundTransparency=1
	title.Text,title.Font,title.TextScaled="BIANGLALA BRAINROT",Enum.Font.GothamBlack,true
	title.TextColor3=Color3.new(1,1,1)
	title.Parent=gui
	local gradient=Instance.new("UIGradient")
	gradient.Color=ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.fromRGB(255,236,92)),
		ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,120,190)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(94,226,255)),
	})
	gradient.Rotation=10
	gradient.Parent=title
	local outline=Instance.new("UIStroke")
	outline.Color,outline.Thickness=Color3.fromRGB(44,39,74),8
	outline.Parent=title
	local tag=Instance.new("TextLabel")
	tag.Name,tag.Size,tag.Position="Tagline",UDim2.fromScale(0.6,0.058),UDim2.fromScale(0.2,0.2)
	tag.BackgroundColor3,tag.BackgroundTransparency=NAVY,0.05
	tag.Text,tag.TextColor3,tag.Font=("Kumpulkan brainrot. Naiki bianglala. Jadi juragan."),CREAM,Enum.Font.GothamBold
	tag.TextScaled=true
	tag.Parent=gui
	round(tag,14);stroke(tag,GOLD,2)
	local tp=Instance.new("UIPadding");tp.PaddingTop,tp.PaddingBottom=UDim.new(0.16,0),UDim.new(0.16,0);tp.Parent=tag
	local chips=Instance.new("Frame")
	chips.Name,chips.Size,chips.Position="Chips",UDim2.fromScale(0.62,0.055),UDim2.fromScale(0.19,0.27)
	chips.BackgroundTransparency=1
	chips.Parent=gui
	chip(chips,"16 BRAINROT",0,0.26)
	chip(chips,"7 RESEP FUSION",0.28,0.3)
	chip(chips,"REBIRTH: BUKA CABANG",0.6,0.4)
	local bar=Instance.new("Frame")
	bar.Name,bar.Size,bar.Position="Tombol",UDim2.fromScale(0.7,0.085),UDim2.fromScale(0.15,0.89)
	bar.BackgroundTransparency=1
	bar.Parent=gui
	button(bar,"MAIN",UDim2.fromScale(0.3,0),UDim2.fromScale(0.4,1),Color3.fromRGB(255,204,116),Color3.fromRGB(46,40,68),Home.close)
	button(bar,"INDEX",UDim2.fromScale(0,0.08),UDim2.fromScale(0.26,0.84),Color3.fromRGB(94,226,255),Color3.fromRGB(46,40,68),function() Index.open() end)
	button(bar,"RESEP FUSION",UDim2.fromScale(0.74,0.08),UDim2.fromScale(0.26,0.84),Color3.fromRGB(255,140,190),Color3.fromRGB(46,40,68),function() Hud.toggleRecipe() end)
	-- keep camera fixed while HOME is open
	RunService:BindToRenderStep("HomeCamera",Enum.RenderPriority.Camera.Value+2,function()
		if not Home.open then return end
		local camera=workspace.CurrentCamera
		camera.CameraType=Enum.CameraType.Scriptable
		camera.FieldOfView=78
		camera.CFrame=CFrame.lookAt(CAMERA_POS,CAMERA_TARGET)
	end)
end

local function setWalking(enabled)
	local character=Players.LocalPlayer.Character
	local humanoid=character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed=enabled and 16 or 0
		humanoid.JumpHeight=enabled and 7.2 or 0
	end
end

-- The welcome signboard sits between the camera and the lineup, so it is hidden locally while HOME is open.
local function setSignVisible(visible)
	local market=workspace:FindFirstChild("Market")
	local sign=market and market:FindFirstChild("Welcome")
	if sign then
		sign.Transparency=visible and 0 or 1
		local gui=sign:FindFirstChild("Label")
		if gui then gui.Enabled=visible end
	end
end

-- Keep the poster crisp: local-only lighting tweak (less bloom/haze/exposure wash-out) while HOME is open.
local function setPosterLighting(on)
	local lighting=game:GetService("Lighting")
	local bloom=lighting:FindFirstChildOfClass("BloomEffect")
	local atmosphere=lighting:FindFirstChildOfClass("Atmosphere")
	if on then
		Home.saved={exposure=lighting.ExposureCompensation,bloom=bloom and bloom.Intensity,haze=atmosphere and atmosphere.Haze}
		lighting.ExposureCompensation=-0.35
		if bloom then bloom.Intensity=0.05 end
		if atmosphere then atmosphere.Haze=0.05 end
	elseif Home.saved then
		lighting.ExposureCompensation=Home.saved.exposure
		if bloom and Home.saved.bloom then bloom.Intensity=Home.saved.bloom end
		if atmosphere and Home.saved.haze then atmosphere.Haze=Home.saved.haze end
		Home.saved=nil
	end
end

function Home.show()
	Home.open=true
	setSignVisible(false)
	if not Home.saved then setPosterLighting(true) end
	pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat,false) end)
	Home.gui.Enabled=true
	if Home.Hud.gui then Home.Hud.gui.Enabled=false end
	if not Home.lineup or not Home.lineup.Parent then Home.lineup=buildLineup() end
	-- stand the avatar in front of the lineup, facing the camera
	local character=Players.LocalPlayer.Character
	if character then character:PivotTo(CFrame.lookAt(Vector3.new(22,3,75),Vector3.new(22,3,CAMERA_POS.Z))) end
	setWalking(false)
end

function Home.close()
	Home.open=false
	setSignVisible(true)
	setPosterLighting(false)
	pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat,true) end)
	Home.gui.Enabled=false
	Home.Index.close()
	Home.Hud.recipe.Visible=false
	if Home.Hud.gui then Home.Hud.gui.Enabled=true end
	if Home.lineup then Home.lineup:Destroy();Home.lineup=nil end
	local camera=workspace.CurrentCamera
	local character=Players.LocalPlayer.Character
	local humanoid=character and character:FindFirstChildOfClass("Humanoid")
	camera.CameraType=Enum.CameraType.Custom
	camera.FieldOfView=70
	if humanoid then camera.CameraSubject=humanoid end
	setWalking(true)
end

return Home
