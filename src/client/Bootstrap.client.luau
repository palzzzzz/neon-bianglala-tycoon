local Hud = require(script.Parent.HudController).build()
local Effects = require(script.Parent.EffectsController)
local event = game.ReplicatedStorage:WaitForChild("PasarEvent")
local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local previousIncome = 0

local function faceMarket(character)
	local root = character:WaitForChild("HumanoidRootPart")
	task.wait(0.2)
	workspace.CurrentCamera.CFrame = CFrame.lookAt(root.Position + Vector3.new(0, 10, -20), root.Position + Vector3.new(0, 6, 18))
end
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(faceMarket)
if player.Character then task.spawn(faceMarket, player.Character) end

event.OnClientEvent:Connect(function(kind, payload)
	if kind == "state" then
		Hud.render(payload)
		if payload.income > 0 and payload.income ~= previousIncome then Effects.claimPop(Hud.gui, "+" .. Catalog.money(payload.income) .. "/s") end
		previousIncome = payload.income
	elseif kind == "notice" then
		Hud.notice.Text = payload.text
		if payload.effect == "claim" then Effects.claimPop(Hud.gui, "DAPAT!") end
		if payload.effect == "fusion" then Effects.fusionBurst(Hud.gui) end
	end
end)

Effects.rarityAura()
