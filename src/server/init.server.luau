local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local World=require(script.World)
local Data=require(script.DataService)
local Economy=require(script.EconomyService)
local Stalls=require(script.StallService)
local Claim=require(script.ClaimService)
local Wheel=require(script.BianglalaService)
local Tide=require(script.TideService)
local Fusion=require(script.FusionService)
local Rebirth=require(script.RebirthService)
local Rats=require(script.RatService)
local events=Instance.new("Folder")
events.Name,events.Parent="MarketEvents",ReplicatedStorage
local function event(name)
	local remote=Instance.new("RemoteEvent")
	remote.Name,remote.Parent=name,events
	return remote
end
local state,notice,fx=event("State"),event("Notice"),event("Effect")
local context={world=World.create(),data=Data,tide=Tide,elapsed=0,fx=fx}
function context.tell(player,message)
	if player.Parent==Players then notice:FireClient(player,message) end
end
function context.announce(message) notice:FireAllClients(message) end
function context.changed(player)
	local profile=Data.profiles[player]
	if not profile then return end
	Data.track(profile)
	Stalls.refresh(player,profile,context)
	Claim.carryBrainrot(player,profile,context)
end
World.prompt(context.world.fusion,"Fusion dua bahan",Enum.KeyCode.E,function(player)
	local profile=Data.profiles[player]
	if not profile then return end
	local success,message=Fusion.fuseBrainrots(profile)
	context.tell(player,message)
	if success then context.changed(player);fx:FireAllClients("fusion",context.world.fusion.Position) end
end)
World.prompt(context.world.branch,"Buka Cabang",Enum.KeyCode.E,function(player)
	local profile=Data.profiles[player]
	if not profile then return end
	if Rebirth.rebirthOpenBranch(profile) then context.changed(player);context.tell(player,"CABANG BARU! Income ×"..(profile.branches+1))
	else context.tell(player,"Butuh lifetime $"..Rebirth.requirement(profile)) end
end)
Wheel.create(context)
require(script.Runtime).context=context
-- Studio-only inspection bridge for repeatable playtests; absent on live servers.
if RunService:IsStudio() then
	local inspect=Instance.new("BindableFunction")
	inspect.Name="StudioInspect"
	inspect.OnInvoke=function(command,args)
		local player=Players:GetPlayers()[1]
		local profile=player and Data.profiles[player]
		if command=="snapshot" then return {profile=profile,elapsed=context.elapsed,water=Tide.level,boss=Rats.king and Rats.king.hp,rate=profile and Economy.rates(profile,context.elapsed)} end
		if not profile then return nil end
		args=args or {}
		if command=="fixture" then
			for key,value in args do
				if key=="cash" or key=="lifetime" or key=="stalls" or key=="epicPity" or key=="legendPity" then profile[key]=value end
			end
			context.changed(player)
		elseif command=="time" then context.elapsed=args.seconds
		elseif command=="move" then player.Character:PivotTo(CFrame.new(args.x,args.y,args.z))
		elseif command=="claim" then return Claim.claimFromGondola(player,Wheel.gondolas[args.index],context)
		elseif command=="place" then local ok=Stalls.placeBrainrot(profile,args.index);context.changed(player);return ok
		elseif command=="upgrade" then local ok=Stalls.upgradeStilts(profile,args.index);context.changed(player);return ok
		elseif command=="lock" then return Stalls.lockStall(profile,args.index,os.clock())
		elseif command=="select" then Stalls.select(profile,args.index)
		elseif command=="fusion" then local ok,result=Fusion.fuseBrainrots(profile);context.changed(player);return {ok=ok,result=result}
		elseif command=="rebirth" then local ok=Rebirth.rebirthOpenBranch(profile);context.changed(player);return ok
		elseif command=="king" then Rats.spawnRatKing(context)
		elseif command=="hit" then return Rats.hitRatKing(player,context)
		elseif command=="spin" then return require(script.LuckyKioskService).spinLuckyKiosk(player)
		elseif command=="gondola" then
			local cabin=Wheel.gondolas[args.index]
			if cabin.display then cabin.display:Destroy() end
			cabin.catch={id=args.id,mutation=args.mutation or "Normal"}
			cabin.display=require(ReplicatedStorage.Shared.BrainrotModels).build(cabin.catch,cabin.model)
			cabin.display:PivotTo(cabin.base.CFrame*CFrame.new(0,2.7,0))
			cabin.prompt.ActionText="Klaim $"..require(ReplicatedStorage.Shared.Catalog).byId[args.id].price
			cabin.prompt.Enabled=true
		elseif command=="steal" then return Rats.ratStealAttempt(profile,profile.stalls[args.index],os.clock(),args.multiplier)
		end
		return {profile=profile,elapsed=context.elapsed}
	end
	inspect.Parent=game.ServerStorage
end
local function join(player)
	local profile=Data.loadPlayer(player)
	if not profile then return end
	context.changed(player)
	player.CharacterAdded:Connect(function() task.wait(0.5);Claim.carryBrainrot(player,profile,context) end)
end
Players.PlayerAdded:Connect(join)
for _,player in Players:GetPlayers() do task.spawn(join,player) end
Players.PlayerRemoving:Connect(function(player)
	Data.savePlayer(player,true)
	Data.profiles[player]=nil
	Stalls.remove(player)
	if Claim.carried[player] then Claim.carried[player]:Destroy();Claim.carried[player]=nil end
end)
local incomeClock=0
RunService.Heartbeat:Connect(function(dt)
	context.elapsed+=dt
	Wheel.spinBianglala(context.elapsed,context)
	Claim.update()
	local nightStarted=Tide.update(context.elapsed,context.world,context.announce)
	if nightStarted and Tide.night%3==0 then Rats.spawnRatKing(context) end
	Rats.update(dt,context)
	Rats.updateKing(dt,context)
	incomeClock+=dt
	if incomeClock>=1 then
		incomeClock-=1
		for player,profile in Data.profiles do
			local rate=Economy.collectIncomeTick(profile,context.elapsed)
			local lowest,lockRemaining=5,0
			for _,stall in profile.stalls do
				if stall.catch then lowest=math.min(lowest,stall.level) end
				lockRemaining=math.max(lockRemaining,(stall.lockUntil or 0)-os.clock())
			end
			state:FireClient(player,{collection=Data.collection(profile),cash=profile.cash,rate=rate,lifetime=profile.lifetime,branches=profile.branches,
				water=Tide.level,stilt=lowest,night=Tide.isNight,nightNumber=Tide.night,
				phase=context.elapsed%240,lock=math.max(0,lockRemaining),carry=profile.carry,
				epicPity=profile.epicPity,legendPity=profile.legendPity,selection=profile.selection or {},
				gondola=math.ceil(5-context.elapsed%5),boss=Rats.king~=nil and not Rats.king.flee,
				pendingPrize=profile.pendingPrize~=nil,spinning=profile.spinning==true})
		end
	end
end)
task.spawn(function()
	while task.wait(60) do
		for player in Data.profiles do
			if not Data.savePlayer(player,false) then player:Kick("Simpan data tertunda. Masuk lagi untuk melindungi progres.") end
		end
	end
end)
game:BindToClose(function()
	local pending=0
	for player in Data.profiles do pending+=1;task.spawn(function() Data.savePlayer(player,true);pending-=1 end) end
	local deadline=os.clock()+25
	while pending>0 and os.clock()<deadline do task.wait(0.1) end
end)
print("Bianglala replacement-session core ready")
