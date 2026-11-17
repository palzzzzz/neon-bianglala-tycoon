local Players=game:GetService("Players")
local Catalog=require(game.ReplicatedStorage.Shared.Catalog)
local Hud={}
function Hud.create()
	local gui=Instance.new("ScreenGui")
	gui.Name,gui.ResetOnSpawn="PasarHUD",false
	gui.IgnoreGuiInset=true
	gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
	local function panel(name,size,position,text,color)
		local label=Instance.new("TextLabel")
		label.Name,label.Size,label.Position=name,size,position
		label.BackgroundColor3=Color3.fromRGB(44,39,74)
		label.BackgroundTransparency=0.1
		label.TextColor3=color or Color3.fromRGB(255,244,216)
		label.Text,label.TextSize,label.Font=text,20,Enum.Font.GothamBold
		label.TextWrapped=true
		label.Parent=gui
		local round=Instance.new("UICorner");round.CornerRadius=UDim.new(0,12);round.Parent=label
		local stroke=Instance.new("UIStroke");stroke.Color=Color3.fromRGB(255,198,119);stroke.Thickness=2;stroke.Parent=label
		stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
		return label
	end
	Hud.cash=panel("Cash",UDim2.fromScale(0.23,0.11),UDim2.fromScale(0.75,0.08),"$25  |  +$0/s")
	Hud.gauge=panel("Tide",UDim2.fromScale(0.23,0.1),UDim2.fromScale(0.75,0.2),"ROB 0 / TIANG 1")
	Hud.timer=panel("GondolaTimer",UDim2.fromScale(0.4,0.075),UDim2.fromScale(0.3,0.055),"GONDOLA BERIKUTNYA: 5",Color3.fromRGB(255,231,123))
	Hud.timer.TextSize=26
	Hud.next=panel("NextStep",UDim2.fromScale(0.68,0.07),UDim2.fromScale(0.16,0.8),"LANGKAH BERIKUTNYA: Klaim gondola pertama")
	Hud.pity=panel("Pity",UDim2.fromScale(0.23,0.1),UDim2.fromScale(0.75,0.32),"Jaminan Epic: 0/15")
	Hud.banner=panel("Notice",UDim2.fromScale(0.53,0.065),UDim2.fromScale(0.2,0.18),"SELAMAT DATANG DI PASAR!")
	Hud.help=panel("Controls",UDim2.fromScale(0.42,0.07),UDim2.fromScale(0.02,0.9),"E klaim / taruh · R tiang · T kunci · F bahan")
	Hud.recipe=panel("Recipes",UDim2.fromScale(0.6,0.58),UDim2.fromScale(0.2,0.28),"")
	Hud.recipe.Visible=false
	Hud.recipe.TextSize=17
	local lines={"RESEP GEROBAK FUSION"}
	for _,r in Catalog.recipes do table.insert(lines,Catalog.byId[r[1]].name.." + "..Catalog.byId[r[2]].name.." → "..Catalog.byId[r[3]].name) end
	table.insert(lines,"Legendary + Legendary → Maharaja 30% / Epic 70%")
	table.insert(lines,"Mutasi: Gold 4% · Diamond 2% · Sambal-Lava 1,5% · Rainbow 0,5%")
	Hud.recipe.Text=table.concat(lines,"\n\n")
	local button=Instance.new("TextButton")
	button.Size,button.Position=UDim2.fromScale(0.16,0.06),UDim2.fromScale(0.82,0.9)
	button.Text,button.TextSize,button.Font="RESEP FUSION",17,Enum.Font.GothamBold
	button.BackgroundColor3,button.TextColor3=Color3.fromRGB(255,204,116),Color3.fromRGB(46,40,68)
	button.Parent=gui
	button.Activated:Connect(function() Hud.recipe.Visible=not Hud.recipe.Visible end)
	Hud.gui=gui
	task.delay(6,function() if not Hud.lastNotice then Hud.banner.Visible=false end end)
end
function Hud.renderCash(cash) Hud.cash.Text="$"..string.format("%.0f",cash) end
function Hud.renderIncomeRate(rate,branches)
	Hud.cash.Text..="\n+$"..string.format("%.1f",rate).."/s · CABANG "..branches
end
function Hud.showTideWarning(message)
	Hud.banner.Text=message
	Hud.banner.Visible=true
	local stamp=os.clock()
	Hud.lastNotice=stamp
	task.delay(6,function() if Hud.lastNotice==stamp then Hud.banner.Visible=false end end)
end
function Hud.renderStiltGauge(state)
	Hud.gauge.Text="ROB "..math.ceil(state.water).." / TIANG "..state.stilt.."\n"..(state.night and "MALAM" or "SENJA").." · KUNCI "..math.ceil(state.lock).."d"
end
function Hud.update(state)
	Hud.renderCash(state.cash)
	Hud.renderIncomeRate(state.rate,state.branches)
	Hud.renderStiltGauge(state)
	Hud.timer.Text="GONDOLA BERIKUTNYA: "..state.gondola
	Hud.pity.Text="Jaminan Epic: "..state.epicPity.."/15\nLegendary: "..state.legendPity.."/40"
	local market=workspace:FindFirstChild("Market")
	local board=market and market:FindFirstChild("PeluangLotre")
	local surface=board and board:FindFirstChildOfClass("SurfaceGui")
	if surface then
		local text=surface:FindFirstChildOfClass("TextLabel")
		if text then
			local original=text:GetAttribute("OriginalText") or text.Text
			text:SetAttribute("OriginalText",original)
			text.Text=original:gsub("Jaminan Epic 15 / Legendary 40 · lihat HUD pribadi","Jaminan Epic: "..state.epicPity.."/15 · Legendary: "..state.legendPity.."/40")
		end
	end
	local nextStep
	if state.boss then nextStep="KEJAR TIKUS RAJA — klik / ketuk badannya!"
	elseif state.carry then nextStep="Bawa "..Catalog.byId[state.carry.id].name.." ke pedestal kosong [E]"
	elseif state.spinning then nextStep="Lampu berputar… tunggu hadiah Kios Lotre!"
	elseif state.pendingPrize then nextStep="Ambil hadiahmu di podium Kios Lotre [E]"
	elseif (state.night or state.phase>150) and state.stilt<5 then nextStep="Naikkan tiang sebelum Banjir Rob [R]"
	elseif #state.selection==2 then nextStep="Bawa pilihanmu ke Gerobak Fusion [E]"
	elseif state.rate<=0 then nextStep="Klaim Kakek Kangkung $10 dari gondola [E]"
	else nextStep="Putar Kios Lotre — jaminan Epic "..state.epicPity.."/15" end
	Hud.next.Text="LANGKAH BERIKUTNYA: "..nextStep
end
return Hud
