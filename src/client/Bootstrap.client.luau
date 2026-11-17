local Hud = require(script.Parent.HudController).build()
local Effects = require(script.Parent.EffectsController)
local event = game.ReplicatedStorage:WaitForChild("PasarEvent")
local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local previousIncome = 0

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
