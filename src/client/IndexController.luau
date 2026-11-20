-- Buku Koleksi: collection book panel (opened from HOME and the HUD INDEX button).
local Players=game:GetService("Players")
local Catalog=require(game.ReplicatedStorage.Shared.Catalog)
local Money=require(game.ReplicatedStorage.Shared.Money)
local Models=require(game.ReplicatedStorage.Shared.BrainrotModels)
local Index={data={owned={},seen={},heldMut={},seenMut={}}}
local NAVY=Color3.fromRGB(44,39,74)
local CREAM=Color3.fromRGB(255,244,216)
local GOLD=Color3.fromRGB(255,198,119)
local GREY=Color3.fromRGB(112,108,130)
local MUTATIONS={{"Gold","x2",Color3.fromRGB(255,207,69)},{"Diamond","x5",Color3.fromRGB(123,243,255)},{"Sambal-Lava","x9",Color3.fromRGB(255,98,62)},{"Rainbow","x20",Color3.fromRGB(255,130,230)}}

local function box(parent,name,size,position,color,transparency)
	local f=Instance.new("Frame")
	f.Name,f.Size,f.Position=name,size,position
	f.BackgroundColor3,f.BackgroundTransparency=color,transparency or 0
	f.BorderSizePixel=0
	f.Parent=parent
	return f
end
local function round(object,radius)
	local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,radius or 10);c.Parent=object
end
local function stroke(object,color,thickness)
	local s=Instance.new("UIStroke");s.Color,s.Thickness=color,thickness or 2
	s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Parent=object
	return s
end
local function text(parent,name,value,size,position,color,font)
	local t=Instance.new("TextLabel")
	t.Name,t.Size,t.Position=name,size,position
	t.BackgroundTransparency=1
	t.Text,t.TextColor3,t.Font=value,color or CREAM,font or Enum.Font.GothamBold
	t.TextScaled=true
	t.Parent=parent
	return t
end

-- Square 3D portrait of the character's real model, framed from its bounding box
-- (so oddly pivoted / large models such as wings, ships and halos still fit) on a rarity-tinted backdrop.
local function portrait(card,item,color)
	local view=Instance.new("ViewportFrame")
	view.Name,view.Size,view.Position="Portrait",UDim2.fromScale(0.34,0.9),UDim2.fromScale(0.03,0.05)
	view.BackgroundColor3,view.BackgroundTransparency=color:Lerp(Color3.fromRGB(30,26,52),0.62),0
	view.Ambient,view.LightColor,view.LightDirection=Color3.fromRGB(190,185,200),Color3.new(1,1,1),Vector3.new(0.3,-0.6,1)
	view.Parent=card
	round(view,6)
	local model=Models.build({id=item.id,mutation="Normal"},view)
	for _,d in model:GetDescendants() do
		if d:IsA("BillboardGui") then d:Destroy() end
	end
	local highlight=model:FindFirstChildOfClass("Highlight")
	if highlight then highlight:Destroy() end
	local boxCFrame,size=model:GetBoundingBox()
	local camera=Instance.new("Camera")
	camera.FieldOfView=35
	local center=boxCFrame.Position
	local extent=math.max(size.Y,size.X*0.9)/2*1.12
	local distance=extent/math.tan(math.rad(camera.FieldOfView/2))+size.Z/2
	-- characters face -Z, so the camera sits on the -Z side, slightly above centre
	camera.CFrame=CFrame.lookAt(center+Vector3.new(0,size.Y*0.06,-distance),center)
	camera.Parent=view
	view.CurrentCamera=camera
	return view
end

function Index.create()
	local gui=Instance.new("ScreenGui")
	gui.Name,gui.ResetOnSpawn,gui.IgnoreGuiInset,gui.DisplayOrder="IndexGui",false,true,20
	gui.Enabled=false
	gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
	Index.gui=gui
	local panel=box(gui,"Panel",UDim2.fromScale(0.86,0.9),UDim2.fromScale(0.07,0.05),NAVY,0.04)
	round(panel,16);stroke(panel,GOLD,3)
	text(panel,"Title","INDEX BRAINROT",UDim2.fromScale(0.4,0.075),UDim2.fromScale(0.03,0.02),Color3.fromRGB(255,231,123),Enum.Font.GothamBlack)
	Index.progress=text(panel,"Progress","Koleksi: 0/16",UDim2.fromScale(0.25,0.06),UDim2.fromScale(0.45,0.027),Color3.fromRGB(172,255,164))
	local close=Instance.new("TextButton")
	close.Name,close.Size,close.Position="Tutup",UDim2.fromScale(0.13,0.065),UDim2.fromScale(0.85,0.022)
	close.Text,close.TextSize,close.Font="TUTUP",20,Enum.Font.GothamBlack
	close.BackgroundColor3,close.TextColor3=Color3.fromRGB(255,120,140),Color3.new(1,1,1)
	close.Parent=panel;round(close,12)
	close.Activated:Connect(Index.close)
	-- one row per rarity tier, 16 base characters
	Index.cards={}
	local rowHeight=0.108
	for tier,rarity in Catalog.rarityOrder do
		local y=0.105+(tier-1)*(rowHeight+0.006)
		local row=box(panel,"Tier_"..rarity,UDim2.fromScale(0.96,rowHeight),UDim2.fromScale(0.02,y),Color3.fromRGB(33,29,58),0)
		round(row,10)
		local color=Catalog.colors[rarity]
		text(row,"TierName",rarity:upper(),UDim2.fromScale(0.13,0.5),UDim2.fromScale(0.01,0.25),color,Enum.Font.GothamBlack)
		local slot=0
		for _,item in Catalog.items do
			if item.rarity==rarity and table.find(Catalog.items,item)<=16 then
				local card=box(row,"Card_"..item.id,UDim2.fromScale(0.153,0.84),UDim2.fromScale(0.155+slot*0.1665,0.08),NAVY,0)
				round(card,8);stroke(card,color,2)
				card:SetAttribute("Rarity",rarity)
				local view=portrait(card,item,color)
				local name=text(card,"Name",item.name,UDim2.fromScale(0.6,0.5),UDim2.fromScale(0.38,0.04),CREAM,Enum.Font.GothamBlack)
				local info=text(card,"Info","",UDim2.fromScale(0.6,0.36),UDim2.fromScale(0.38,0.56),Color3.fromRGB(172,255,164))
				Index.cards[item.id]={card=card,name=name,info=info,item=item,color=color,view=view}
				slot+=1
			end
		end
	end
	-- mutation strip
	local mutBar=box(panel,"Mutasi",UDim2.fromScale(0.96,0.075),UDim2.fromScale(0.02,0.795),Color3.fromRGB(33,29,58))
	round(mutBar,10)
	text(mutBar,"Label","MUTASI",UDim2.fromScale(0.13,0.5),UDim2.fromScale(0.01,0.25),GOLD,Enum.Font.GothamBlack)
	Index.mutations={}
	for i,m in MUTATIONS do
		local chip=box(mutBar,"Mut_"..m[1],UDim2.fromScale(0.2,0.78),UDim2.fromScale(0.155+(i-1)*0.2105,0.11),NAVY)
		round(chip,8);stroke(chip,m[3],2)
		local label=text(chip,"Label","",UDim2.fromScale(0.94,0.8),UDim2.fromScale(0.03,0.1),m[3],Enum.Font.GothamBlack)
		Index.mutations[m[1]]={label=label,chip=chip,info=m}
	end
	-- fusion strip
	local fuseBar=box(panel,"FusionStrip",UDim2.fromScale(0.96,0.125),UDim2.fromScale(0.02,0.876),Color3.fromRGB(33,29,58))
	round(fuseBar,10)
	text(fuseBar,"Label","FUSION",UDim2.fromScale(0.13,0.4),UDim2.fromScale(0.01,0.3),GOLD,Enum.Font.GothamBlack)
	Index.recipes={}
	local entries={}
	for _,r in Catalog.recipes do table.insert(entries,{Catalog.byId[r[1]].name.." + "..Catalog.byId[r[2]].name,r[3]}) end
	table.insert(entries,{"Legendary + Legendary","maharaja"})
	for i,e in entries do
		local card=box(fuseBar,"Resep_"..i,UDim2.fromScale(0.1,0.84),UDim2.fromScale(0.145+(i-1)*0.1215,0.08),NAVY)
		round(card,6);stroke(card,Color3.fromRGB(255,198,119),1)
		text(card,"Bahan",e[1],UDim2.fromScale(0.94,0.52),UDim2.fromScale(0.03,0.03),Color3.fromRGB(200,196,225))
		local result=text(card,"Hasil","",UDim2.fromScale(0.94,0.4),UDim2.fromScale(0.03,0.56),CREAM,Enum.Font.GothamBlack)
		table.insert(Index.recipes,{result=result,id=e[2]})
	end
	Index.render()
end

function Index.render()
	if not Index.gui then return end
	local data=Index.data
	local count=0
	for id,entry in Index.cards do
		local owned=data.owned[id] or 0
		local seen=data.seen[id] or owned>0
		if seen then count+=1 end
		entry.view.ImageColor3=seen and Color3.new(1,1,1) or Color3.fromRGB(8,8,14) -- unseen characters show as silhouettes
		if seen then
			entry.name.Text,entry.name.TextColor3=entry.item.name,CREAM
			entry.info.Text=Money.rate(entry.item.rate).."  ·  x"..owned
			entry.info.TextColor3=owned>0 and Color3.fromRGB(172,255,164) or Color3.fromRGB(255,224,150)
			entry.card.BackgroundColor3=Color3.fromRGB(58,52,98)
		else
			entry.name.Text,entry.name.TextColor3="???",GREY
			entry.info.Text,entry.info.TextColor3="$?/s",GREY
			entry.card.BackgroundColor3=Color3.fromRGB(37,34,52)
		end
		entry.card.UIStroke.Color=seen and entry.color or GREY
	end
	Index.progress.Text="Koleksi: "..count.."/16"
	for name,entry in Index.mutations do
		local held=data.heldMut[name] or 0
		local ever=data.seenMut[name] or held>0
		entry.label.Text=name.." "..entry.info[2]..(ever and ("  ✓ x"..held) or "")
		entry.label.TextColor3=ever and entry.info[3] or GREY
		entry.chip.UIStroke.Color=ever and entry.info[3] or GREY
	end
	for _,recipe in Index.recipes do
		local known=data.seen[recipe.id] or (data.owned[recipe.id] or 0)>0
		recipe.result.Text=known and ("→ "..Catalog.byId[recipe.id].name) or "→ ???"
		recipe.result.TextColor3=known and Color3.fromRGB(172,255,164) or GREY
	end
end

function Index.setData(collection)
	if not collection then return end
	Index.data=collection
	Index.render()
end
function Index.open() if Index.gui then Index.render();Index.gui.Enabled=true end end
function Index.close() if Index.gui then Index.gui.Enabled=false end end
function Index.toggle() if Index.gui.Enabled then Index.close() else Index.open() end end
return Index
