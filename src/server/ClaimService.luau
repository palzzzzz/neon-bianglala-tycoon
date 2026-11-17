local Catalog=require(game.ReplicatedStorage.Shared.Catalog)
local Models=require(game.ReplicatedStorage.Shared.BrainrotModels)
local Economy=require(script.Parent.EconomyService)
local Stalls=require(script.Parent.StallService)
local Claim={carried={}}
function Claim.carryBrainrot(player,profile,context)
	if Claim.carried[player] then Claim.carried[player]:Destroy();Claim.carried[player]=nil end
	if profile.carry and player.Character then
		local model=Models.build(profile.carry,context.world.root)
		model.Name="Bawaan_"..player.UserId
		Claim.carried[player]=model
	end
end
function Claim.claimFromGondola(player,gondola,context)
	local profile=context.data.profiles[player]
	if not profile or profile.carry or profile.spinning or not gondola.catch then return false end
	if Stalls.freeSlots(profile)<1 then context.tell(player,"Lapak penuh. Fusion atau buka cabang dahulu.");return false end
	local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root or (root.Position-gondola.base.Position).Magnitude>17 then return false end
	local price=Catalog.byId[gondola.catch.id].price
	if not Economy.spendCash(profile,price) then context.tell(player,"Butuh $"..price.." untuk gondola ini.");return false end
	profile.carry=gondola.catch
	gondola.catch=nil
	gondola.restockAt=context.elapsed+12
	if gondola.display then gondola.display:Destroy();gondola.display=nil end
	gondola.prompt.Enabled=false
	context.changed(player)
	context.fx:FireAllClients("claim",gondola.base.Position)
	return true
end
function Claim.update()
	for player,model in Claim.carried do
		local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if root then model:PivotTo(root.CFrame*CFrame.new(0,6,0)) end
	end
end
return Claim
