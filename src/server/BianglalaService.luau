local Catalog=require(game.ReplicatedStorage.Shared.Catalog)
local Models=require(game.ReplicatedStorage.Shared.BrainrotModels)
local Money=require(game.ReplicatedStorage.Shared.Money)
local World=require(script.Parent.World)
local Claim=require(script.Parent.ClaimService)
local Wheel={gondolas={},rng=Random.new()}
function Wheel.stockGondola(gondola,context)
	local upper=gondola.base.Position.Y>70
	local r=Wheel.rng:NextNumber()
	local rarity
	if upper then rarity=r<0.08 and "Mythic" or r<0.35 and "Legendary" or "Epic"
	else rarity=r<0.78 and "Common" or "Rare" end
	local id=Catalog.pick(rarity,Wheel.rng)
	-- A dependable inexpensive starting point is always available on cabin one.
	if gondola.index==1 then id="kangkung" end
	gondola.catch={id=id,mutation="Normal"}
	gondola.display=Models.build(gondola.catch,gondola.model)
	gondola.display:PivotTo(gondola.base.CFrame*CFrame.new(0,2.7,0))
	gondola.prompt.ActionText="Klaim "..Money.format(Catalog.byId[id].price)
	gondola.prompt.ObjectText=Catalog.byId[id].name
	gondola.prompt.Enabled=true
end
function Wheel.create(context)
	for i=1,12 do
		local model=Instance.new("Model")
		model.Name="Gondola_"..i
		local base=Models.part(model,"Deck",Vector3.new(9,0.8,7),CFrame.new(),Color3.fromHSV(i/12,0.45,1),Enum.Material.Neon)
		base.CanCollide=true
		model.PrimaryPart=base
		Models.part(model,"Canopy",Vector3.new(10,0.6,8),CFrame.new(0,8,0),base.Color)
		for side=-1,1,2 do Models.part(model,"Hanger",Vector3.new(0.35,8,0.35),CFrame.new(side*4,4,2.8),Color3.fromRGB(255,235,184)) end
		model.Parent=context.world.root
		local gondola={model=model,base=base,index=i}
		gondola.prompt=World.prompt(base,"Klaim",Enum.KeyCode.E,function(player) Claim.claimFromGondola(player,gondola,context) end,14)
		table.insert(Wheel.gondolas,gondola)
	end
	Wheel.spinBianglala(0,context)
	for _,gondola in Wheel.gondolas do Wheel.stockGondola(gondola,context) end
end
function Wheel.spinBianglala(elapsed,context)
	for _,gondola in Wheel.gondolas do
		local a=(gondola.index-1)*math.pi/6-math.pi/2+elapsed*math.pi/30
		local position=context.world.center+Vector3.new(math.cos(a)*40,math.sin(a)*40,4)
		local previous=gondola.base.Position
		gondola.model:PivotTo(CFrame.new(position))
		if elapsed>0 then
			for player in context.data.profiles do
				local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if root then
					local delta=root.Position-previous
					if math.abs(delta.X)<4.5 and math.abs(delta.Z)<3.5 and delta.Y>0 and delta.Y<4.5 then
						root.CFrame+=position-previous
					end
				end
			end
		end
		if not gondola.catch and gondola.restockAt and elapsed>=gondola.restockAt then Wheel.stockGondola(gondola,context) end
	end
end
return Wheel
