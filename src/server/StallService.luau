local Catalog=require(game.ReplicatedStorage.Shared.Catalog)
local Models=require(game.ReplicatedStorage.Shared.BrainrotModels)
local Economy=require(script.Parent.EconomyService)
local World=require(script.Parent.World)
local Stalls={plots={},views={}}
function Stalls.freeSlots(profile)
	local n=0
	for _,stall in profile.stalls do if not stall.catch then n+=1 end end
	return n
end
function Stalls.placeBrainrot(profile,index)
	local stall=profile.stalls[index]
	if not stall or stall.catch or not profile.carry then return false end
	stall.catch,profile.carry=profile.carry,nil
	return true
end
function Stalls.upgradeStilts(profile,index)
	local stall=profile.stalls[index]
	if not stall or stall.level>=5 then return false end
	if not Economy.spendCash(profile,Catalog.stiltPrices[stall.level+1]) then return false end
	stall.level+=1
	return true
end
function Stalls.lockStall(profile,index,now)
	local stall=profile.stalls[index]
	if not stall or (stall.readyAt or 0)>now then return false end
	if not Economy.spendCash(profile,50) then return false end
	stall.lockUntil,stall.readyAt=now+60,now+90
	return true
end
function Stalls.select(profile,index)
	if not profile.stalls[index].catch then return end
	profile.selection=profile.selection or {}
	local at=table.find(profile.selection,index)
	if at then table.remove(profile.selection,at)
	elseif #profile.selection<2 then table.insert(profile.selection,index)
	else profile.selection={index} end
end
function Stalls.refresh(player,profile,context)
	local plot=Stalls.plots[player]
	if not plot then
		local occupied={}
		for _,p in Stalls.plots do occupied[p.number]=true end
		local number=1
		while occupied[number] do number+=1 end
		plot={number=number,origin=Vector3.new(number%2==1 and -76 or 77,0,-54+math.floor((number-1)/2)*43)}
		Stalls.plots[player]=plot
	end
	if Stalls.views[player] then Stalls.views[player]:Destroy() end
	local folder=Instance.new("Folder")
	folder.Name="Lapak_"..player.UserId
	folder.Parent=context.world.root
	Stalls.views[player]=folder
	for index,stall in profile.stalls do
		local pos=plot.origin+Vector3.new(((index-1)%3-1)*11,stall.level==5 and 17 or (stall.level-1)*3+2,math.floor((index-1)/3)*11)
		stall.position=pos
		local base=Models.part(folder,"Pedestal_"..index,Vector3.new(9,1,9),CFrame.new(pos),Color3.fromRGB(255,196,128))
		base.CanCollide=true
		local rim=Models.part(folder,"PedestalGlow",Vector3.new(9.3,0.25,9.3),CFrame.new(pos+Vector3.new(0,0.65,0)),stall.catch and Catalog.colors[Catalog.byId[stall.catch.id].rarity] or Color3.fromRGB(129,233,219),Enum.Material.Neon)
		local glow=Instance.new("PointLight");glow.Color=rim.Color;glow.Range=13;glow.Brightness=1.2;glow.Parent=rim
		for _,dx in {-3,3} do
			Models.part(folder,"Tiang",Vector3.new(0.8,pos.Y,0.8),CFrame.new(pos.X+dx,pos.Y/2,pos.Z),Color3.fromRGB(108,82,118))
		end
		local selected=profile.selection and table.find(profile.selection,index)
		Models.label(base,player.DisplayName.." · "..index,"L"..stall.level..(selected and " · BAHAN ✓" or ""),Color3.fromRGB(255,245,208),1)
		if stall.catch then
			local model=Models.build(stall.catch,folder)
			model:PivotTo(CFrame.new(pos+Vector3.new(0,2.6,0)))
			model:SetAttribute("Idle",true)
		end
		-- Ground-level controls remain reachable even when the pedestal is elevated.
		local control=Models.part(folder,"Kontrol_"..index,Vector3.new(2,2,1),CFrame.new(pos.X,2,pos.Z+5),Color3.fromRGB(95,207,193),Enum.Material.Neon)
		local function mine(visitor,action)
			if visitor~=player then return end
			action()
			context.changed(player)
		end
		World.prompt(control,"Taruh bawaan",Enum.KeyCode.E,function(visitor) mine(visitor,function() Stalls.placeBrainrot(profile,index) end) end)
		World.prompt(control,"Tiang "..(stall.level<5 and "$"..Catalog.stiltPrices[stall.level+1] or "MAX"),Enum.KeyCode.R,function(visitor) mine(visitor,function() Stalls.upgradeStilts(profile,index) end) end)
		World.prompt(control,"Kunci $50 / 60 detik",Enum.KeyCode.T,function(visitor) mine(visitor,function() Stalls.lockStall(profile,index,os.clock()) end) end)
		World.prompt(control,"Pilih bahan fusion",Enum.KeyCode.F,function(visitor) mine(visitor,function() Stalls.select(profile,index) end) end)
	end
end
function Stalls.remove(player)
	if Stalls.views[player] then Stalls.views[player]:Destroy() end
	Stalls.views[player],Stalls.plots[player]=nil,nil
end
return Stalls
