local Catalog=require(game.ReplicatedStorage.Shared.Catalog)
local Models=require(game.ReplicatedStorage.Shared.BrainrotModels)
local Money=require(game.ReplicatedStorage.Shared.Money)
local Rats={active={},lastSpawn=-20}
local rng=Random.new()
function Rats.ratKingPickTarget(context)
	local target,best=nil,-1
	local Economy=require(script.Parent.EconomyService)
	for player,profile in context.data.profiles do
		local _,rates=Economy.rates(profile,context.elapsed)
		for i,stall in profile.stalls do
			if stall.catch and rates[i]>best then best=rates[i];target={player=player,profile=profile,stall=stall,rate=rates[i]} end
		end
	end
	return target
end
function Rats.ratKingFlee(context,defeated)
	local king=Rats.king
	if not king or king.flee then return end
	king.flee=true
	if defeated then
		context.announce("TIKUS RAJA KALAH! Pungut hujan koin di plaza!")
		Rats.ratKingRewardDrop(context,king)
	else context.announce("Tikus Raja kabur membawa hasil curian!") end
end
function Rats.ratKingRewardDrop(context,king)
	local Economy=require(script.Parent.EconomyService)
	local Stalls=require(script.Parent.StallService)
	local World=require(script.Parent.World)
	local target=Rats.ratKingPickTarget(context)
	local reward=60*(target and target.rate or king.target.rate)
	for i=1,12 do
		local angle=i*math.pi/6
		local pos=Vector3.new(math.cos(angle)*14,3,25+math.sin(angle)*14)
		local coin=Models.part(context.world.root,"KoinRaja",Vector3.new(2,2,0.5),CFrame.new(pos),Color3.fromRGB(255,210,64),Enum.Material.Neon,Enum.PartType.Cylinder)
		Models.label(coin,"KOIN RAJA",Money.format(reward/12),Color3.fromRGB(255,237,123),2)
		local claimed=false
		local function collect(player)
			local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			local profile=context.data.profiles[player]
			if claimed or not profile or not root or (root.Position-pos).Magnitude>18 then return end
			claimed=true
			Economy.addCash(profile,reward/12,true)
			context.fx:FireAllClients("coin",pos)
			coin:Destroy()
		end
		local click=Instance.new("ClickDetector");click.MaxActivationDistance=18;click.Parent=coin;click.MouseClick:Connect(collect)
		World.prompt(coin,"Pungut koin",Enum.KeyCode.E,collect)
		game:GetService("Debris"):AddItem(coin,90)
	end
	if rng:NextNumber()<0.35 then
		local roll=rng:NextNumber()
		local rarity=roll<0.1 and "Mythic" or roll<0.4 and "Legendary" or "Epic"
		local catch={id=Catalog.pick(rarity,rng),mutation="Normal"}
		local prize=Models.build(catch,context.world.root)
		prize:PivotTo(CFrame.new(0,5,25))
		local claimed=false
		World.prompt(prize.PrimaryPart,"Hadiah Raja GRATIS",Enum.KeyCode.E,function(player)
			local profile=context.data.profiles[player]
			if claimed or not profile or profile.carry or profile.spinning or Stalls.freeSlots(profile)<1 then return end
			claimed=true;profile.carry=catch;prize:Destroy();context.changed(player)
		end,15)
		game:GetService("Debris"):AddItem(prize,90)
	end
end
function Rats.hitRatKing(player,context)
	local king=Rats.king
	if not king or king.flee then return false end
	local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root or (root.Position-king.position).Magnitude>24 then return false end
	local now=os.clock()
	if now-(king.hits[player] or 0)<0.14 then return false end
	king.hits[player]=now
	king.hp-=1
	king.shakeUntil=now+0.15
	king.bar.Size=UDim2.fromScale(king.hp/25,1)
	king.text.Text="TIKUS RAJA  "..king.hp.." / 25"
	context.fx:FireAllClients("hit",king.position)
	if king.hp==0 then Rats.ratKingFlee(context,true) end
	return true
end
function Rats.spawnRatKing(context)
	if Rats.king then return end
	local target=Rats.ratKingPickTarget(context)
	if not target then context.announce("Tikus Raja mengendus pasar kosong lalu pergi.");return end
	local model=Rats.makeRat(context)
	model.Name="TikusRaja"
	for i=-1,1 do Models.part(model,"Crown",Vector3.new(0.5,1,0.6),CFrame.new(i*0.65,3.1,0)*CFrame.Angles(0,0,0.16),Color3.fromRGB(255,210,64),Enum.Material.Neon) end
	Models.part(model,"MoneySack",Vector3.new(2.2,2.3,2),CFrame.new(0,2,1.2),Color3.fromRGB(213,171,91),nil,Enum.PartType.Ball)
	model:ScaleTo(3)
	local pos=Vector3.new(0,5,88)
	model:PivotTo(CFrame.new(pos))
	local gui=Instance.new("BillboardGui")
	gui.Name,gui.Size,gui.StudsOffset="BossHealth",UDim2.fromOffset(330,75),Vector3.new(0,9,0)
	gui.AlwaysOnTop,gui.MaxDistance,gui.Parent=true,200,model.PrimaryPart
	local title=Instance.new("TextLabel")
	title.Size,title.BackgroundTransparency,title.Text=UDim2.fromScale(1,0.55),1,"TIKUS RAJA  25 / 25"
	title.Font,title.TextSize,title.TextColor3,title.TextStrokeTransparency=Enum.Font.GothamBlack,25,Color3.new(1,1,1),0
	title.Parent=gui
	local track=Instance.new("Frame");track.Position=UDim2.fromScale(0,0.6);track.Size=UDim2.fromScale(1,0.3);track.BackgroundColor3=Color3.fromRGB(67,36,67);track.Parent=gui
	local bar=Instance.new("Frame");bar.Size=UDim2.fromScale(1,1);bar.BackgroundColor3=Color3.fromRGB(255,100,129);bar.Parent=track
	Rats.king={model=model,target=target,position=pos,home=pos,hp=25,hits={},bar=bar,text=title}
	for _,part in model:GetChildren() do
		if part:IsA("BasePart") then
			local click=Instance.new("ClickDetector");click.MaxActivationDistance=24;click.Parent=part
			click.MouseClick:Connect(function(player) Rats.hitRatKing(player,context) end)
		end
	end
	context.announce("TIKUS RAJA DATANG! Klik / ketuk badannya 25 kali!")
end
function Rats.updateKing(dt,context)
	local king=Rats.king
	if not king then return end
	if not king.flee and (not context.data.profiles[king.target.player] or not table.find(king.target.profile.stalls,king.target.stall) or not king.target.stall.catch) then
		king.target=Rats.ratKingPickTarget(context)
		if not king.target then king.flee=true end
	end
	local destination=king.flee and king.home or Vector3.new(king.target.stall.position.X,5,king.target.stall.position.Z)
	local delta=destination-king.position
	if delta.Magnitude<3 then
		if king.flee then king.model:Destroy();Rats.king=nil
		else
			Rats.ratStealAttempt(king.target.profile,king.target.stall,os.clock(),5)
			Rats.ratKingFlee(context,false)
		end
	else
		king.position+=delta.Unit*math.min(delta.Magnitude,dt*(king.flee and 18 or 2.5))
		local shake=(king.shakeUntil or 0)>os.clock() and math.sin(os.clock()*90)*0.15 or 0
		king.model:PivotTo(CFrame.lookAt(king.position,king.position+delta)*CFrame.Angles(0,0,shake))
	end
end
function Rats.makeRat(context)
	local model=Instance.new("Model")
	model.Name="TikusPasar"
	local body=Models.part(model,"Body",Vector3.new(3,1.8,4),CFrame.new(0,1.3,0),Color3.fromRGB(104,93,124),nil,Enum.PartType.Ball)
	model.PrimaryPart=body
	for side=-1,1,2 do
		Models.part(model,"Ear",Vector3.new(1.2,1.2,0.4),CFrame.new(side*1,2.4,-1),Color3.fromRGB(238,153,170),nil,Enum.PartType.Ball)
		Models.part(model,"Eye",Vector3.one*0.35,CFrame.new(side*0.6,1.8,-1.8),Color3.new(1,1,1),Enum.Material.Neon,Enum.PartType.Ball)
	end
	Models.part(model,"Nose",Vector3.one*0.65,CFrame.new(0,1.2,-2.2),Color3.fromRGB(255,142,162),nil,Enum.PartType.Ball)
	Models.part(model,"Tail",Vector3.new(0.3,0.3,4),CFrame.new(0,1,3),Color3.fromRGB(224,147,173))
	model.Parent=context.world.root
	return model
end
function Rats.ratStealAttempt(profile,stall,now,multiplier)
	if not stall.catch then return 0 end
	if not multiplier and (stall.lockUntil or 0)>now then return 0 end
	local amount=math.min(profile.cash,Catalog.income(stall.catch)*20*(multiplier or 1))
	profile.cash-=amount
	return amount
end
function Rats.spawnRat(context)
	local start=Vector3.new(-105,2,-65)
	local target,best
	for player,profile in context.data.profiles do
		for _,stall in profile.stalls do
			if stall.catch and (stall.lockUntil or 0)<=os.clock() then
				local distance=(stall.position-start).Magnitude
				if not best or distance<best then best=distance;target={player=player,profile=profile,stall=stall} end
			end
		end
	end
	if not target then return end
	local model=Rats.makeRat(context)
	model:PivotTo(CFrame.new(start))
	table.insert(Rats.active,{model=model,target=target,position=start,home=start,flee=false})
end
function Rats.update(dt,context)
	if context.tide.isNight and context.elapsed-Rats.lastSpawn>=20 then Rats.lastSpawn=context.elapsed;Rats.spawnRat(context) end
	for i=#Rats.active,1,-1 do
		local rat=Rats.active[i]
		local destination=rat.flee and rat.home or Vector3.new(rat.target.stall.position.X,2,rat.target.stall.position.Z)
		local delta=destination-rat.position
		if delta.Magnitude<2 then
			if rat.flee then rat.model:Destroy();table.remove(Rats.active,i)
			else
				local stolen=Rats.ratStealAttempt(rat.target.profile,rat.target.stall,os.clock())
				context.tell(rat.target.player,stolen>0 and "Tikus mencuri "..Money.format(stolen).."!" or "?! Tikus terpental dari kunci!")
				rat.flee=true
			end
		else
			rat.position+=delta.Unit*math.min(delta.Magnitude,dt*12)
			rat.model:PivotTo(CFrame.lookAt(rat.position,rat.position+delta))
		end
	end
end
return Rats
