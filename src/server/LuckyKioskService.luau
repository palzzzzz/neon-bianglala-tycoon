local Money=require(game.ReplicatedStorage.Shared.Money)
local Kiosk={busy=false,rng=Random.new(),prizes={}}
function Kiosk.create(context,Economy,Catalog,Models,Stalls,World)
	local base=Models.part(context.world.root,"KiosLotre",Vector3.new(17,4,9),CFrame.new(32,2,55),Color3.fromRGB(174,113,221))
	base.CanCollide=true
	local roof=Models.part(context.world.root,"KiosRoof",Vector3.new(19,1,11),CFrame.new(32,11,55),Color3.fromRGB(255,186,100))
	Models.label(roof,"KIOS LOTRE","putar, siapa tahu Maharaja lewat",Color3.fromRGB(255,239,170),3)
	local board=Models.part(context.world.root,"PeluangLotre",Vector3.new(18,6,0.5),CFrame.new(32,7,50),Color3.fromRGB(53,43,78))
	local gui=Instance.new("SurfaceGui");gui.Face=Enum.NormalId.Front;gui.CanvasSize=Vector2.new(900,300);gui.Parent=board
	local text=Instance.new("TextLabel");text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1
	text.Font,text.TextSize,text.TextColor3=Enum.Font.GothamBold,30,Color3.new(1,1,1)
	text.Text="UANG GAME SAJA · "..Money.format(Catalog.lotteryBasePrice).." × 2^cabang\nCommon 55% · Rare 27% · Epic 11%\nLegendary 4,5% · Mythic 2% · JACKPOT 0,5%\nJackpot = Rainbow ×20 · God hanya dari fusion\nJaminan Epic 15 / Legendary 40 · lihat HUD pribadi"
	text.Parent=gui
	local bulbs={}
	for i=1,8 do bulbs[i]=Models.part(context.world.root,"LampuLotre",Vector3.one*0.8,CFrame.new(23+i*2,10,49.5),Color3.fromHSV(i/8,0.7,1),Enum.Material.Neon,Enum.PartType.Ball) end
	local podium=Models.part(context.world.root,"PodiumLotre",Vector3.new(7,1,7),CFrame.new(32,0.5,43),Color3.fromRGB(255,215,103),Enum.Material.Neon)
	podium.CanCollide=true
	local function revealSpinResult(player,profile)
		if not profile.pendingPrize then return end
		if Kiosk.prizes[player] then Kiosk.prizes[player]:Destroy() end
		local prize=Models.build(profile.pendingPrize,context.world.root)
		prize.Name="HadiahLotre_"..player.UserId
		prize:PivotTo(CFrame.new(32,3.3,43))
		Kiosk.prizes[player]=prize
		World.prompt(prize.PrimaryPart,"Ambil hadiah "..player.DisplayName,Enum.KeyCode.E,function(visitor)
			if visitor~=player or profile.carry or not profile.pendingPrize or Stalls.freeSlots(profile)<1 then return end
			profile.carry,profile.pendingPrize=profile.pendingPrize,nil
			prize:Destroy();Kiosk.prizes[player]=nil
			context.changed(player)
		end,14)
		context.fx:FireAllClients("fusion",podium.Position)
		context.tell(player,"HASIL LOTRE: "..Catalog.byId[profile.pendingPrize.id].name.." · "..profile.pendingPrize.mutation)
	end
	Kiosk.revealSpinResult=revealSpinResult
	function Kiosk.spinLuckyKiosk(player)
		local profile=context.data.profiles[player]
		if not profile then return false end
		if profile.spinning then return false end
		if profile.pendingPrize then revealSpinResult(player,profile);return false end
		if Kiosk.busy or profile.spinning or profile.carry or Stalls.freeSlots(profile)<1 then context.tell(player,"Kosongkan bawaan dan satu pedestal; tunggu putaran selesai.");return false end
		local price=Catalog.lotteryBasePrice*2^profile.branches
		if not Economy.spendCash(profile,price) then context.tell(player,"Lotre perlu "..Money.format(price).." uang game.");return false end
		local rarity,jackpot=Economy.rollGachaRarity(profile,Kiosk.rng)
		Economy.pityStep(profile,rarity)
		profile.pendingPrize={id=Catalog.pick(rarity,Kiosk.rng),mutation=jackpot and "Rainbow" or "Normal"}
		profile.spinning,Kiosk.busy=true,true
		task.spawn(function()
			local silhouette=Models.part(context.world.root,"RodaHadiah",Vector3.one*3,CFrame.new(32,5,43),Catalog.colors.Common,Enum.Material.Neon,Enum.PartType.Ball)
			local sequence={0.08,0.09,0.1,0.11,0.12,0.15,0.18,0.22,0.28,0.35,0.5,0.82}
			for i,delay in sequence do
				local color=Catalog.colors[Catalog.rarityOrder[(i-1)%5+1]]
				silhouette.Color=color
				for j,bulb in bulbs do bulb.Color=j==(i-1)%8+1 and Color3.new(1,1,1) or color end
				task.wait(delay)
			end
			silhouette:Destroy()
			profile.spinning,Kiosk.busy=false,false
			if context.data.profiles[player]==profile then revealSpinResult(player,profile) end
		end)
		return true
	end
	World.prompt(base,"Putar Lotre / ambil hasil",Enum.KeyCode.E,Kiosk.spinLuckyKiosk,16)
	game.Players.PlayerRemoving:Connect(function(player)
		if Kiosk.prizes[player] then Kiosk.prizes[player]:Destroy();Kiosk.prizes[player]=nil end
	end)
end
return Kiosk
