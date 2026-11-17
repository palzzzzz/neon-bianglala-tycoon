local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local World = require(script.World)
local Data = require(script.DataService)
local Wheel = require(script.BianglalaService)
local Claim = require(script.ClaimService)
local Economy = require(script.EconomyService)
local Tide = require(script.TideService)
local Stall = require(script.StallService)
local Fusion = require(script.FusionService)
local Rats = require(script.RatService)
local Rebirth = require(script.RebirthService)

local event = Instance.new("RemoteEvent")
event.Name = "PasarEvent"
event.Parent = ReplicatedStorage
local function notify(player, message, effect)
	event:FireClient(player, "notice", {text = message, effect = effect})
end

World.build()
Wheel.build(Data.profiles, notify)
local plotNumbers = {}
local occupied = {}

local function near(player, part)
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	return root and (root.Position - part.Position).Magnitude <= 18
end

World.prompt(World.fusion, "Fusion bahan terpilih", "Gerobak Fusion", Enum.KeyCode.E, function(player)
	local p = Data.profiles[player]
	if p and near(player, World.fusion) then Fusion.fuseBrainrots(player, p, notify) end
end)
World.prompt(World.rebirth, "Buka Cabang (reset uang & karakter)", "Income × permanen", Enum.KeyCode.E, function(player)
	local p = Data.profiles[player]
	if p and near(player, World.rebirth) then Rebirth.rebirthOpenBranch(player, p, plotNumbers[player], notify) end
end)

local function join(player)
	local profile, err = Data.loadPlayer(player)
	if not profile then player:Kick(err) return end
	local index = 1
	while occupied[index] do index += 1 end
	occupied[index], plotNumbers[player] = true, index
	Stall.buildPlot(player, profile, index, notify)
	player:SetAttribute("Plot", index)
	local function characterAdded(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = 24
		humanoid.UseJumpPower = true
		humanoid.JumpPower = 58
	end
	player.CharacterAdded:Connect(characterAdded)
	if player.Character then task.spawn(characterAdded, player.Character) end
end

Players.PlayerAdded:Connect(join)
for _, player in Players:GetPlayers() do task.spawn(join, player) end
Players.PlayerRemoving:Connect(function(player)
	Data.savePlayer(player)
	Data.profiles[player] = nil
	if plotNumbers[player] then occupied[plotNumbers[player]] = nil end
	plotNumbers[player] = nil
	if Stall.plots[player] then Stall.plots[player].folder:Destroy() Stall.plots[player] = nil end
	if Claim.carriedModels[player] then Claim.carriedModels[player].model:Destroy() Claim.carriedModels[player] = nil end
end)

local tickAccumulator, motionAccumulator, saveAccumulator = 0, 0, 0
RunService.Heartbeat:Connect(function(dt)
	tickAccumulator += dt
	motionAccumulator += dt
	saveAccumulator += dt
	if motionAccumulator >= 1 / 20 then
		local elapsed = motionAccumulator
		motionAccumulator = 0
		Wheel.spinBianglala(elapsed)
		Tide.update(elapsed, World)
		Rats.update(elapsed, Tide.night, Data.profiles, notify)
		for player, profile in Data.profiles do Claim.carryBrainrot(player, profile) end
	end
	if tickAccumulator >= 1 then
		tickAccumulator -= 1
		for player, profile in Data.profiles do
			local income = Economy.collectIncomeTick(profile)
			local stalls = {}
			for index, stall in profile.stalls do
				stalls[index] = {level = stall.level, item = stall.item, lockedUntil = stall.lockedUntil, flooded = Tide.isStallFlooded(stall)}
				local slot = Stall.plots[player].slots[index]
				slot.pedestal.Color = stall.lockedUntil > workspace:GetServerTimeNow() and Color3.fromRGB(66, 235, 216) or Color3.fromRGB(244, 182, 80)
			end
			event:FireClient(player, "state", {cash = profile.cash, income = income, lifetime = profile.lifetime, branches = profile.branches, carried = profile.carried, selected = profile.selected, stalls = stalls})
		end
	end
	if saveAccumulator >= 60 then
		saveAccumulator = 0
		for player in Data.profiles do task.spawn(Data.savePlayer, player) end
	end
end)

game:BindToClose(function()
	for player in Data.profiles do Data.savePlayer(player) end
end)
