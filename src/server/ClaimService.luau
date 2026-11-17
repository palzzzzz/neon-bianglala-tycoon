local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local Models = require(game.ReplicatedStorage.Shared.BrainrotModels)
local Economy = require(script.Parent.EconomyService)
local Claim = {carriedModels = {}}

function Claim.claimFromGondola(player, profile, gondola, notify)
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root or (root.Position - gondola.floor.Position).Magnitude > 17 then return end
	if not gondola.item then return end
	if profile.carried then notify(player, "Taruh karakter yang dibawa dulu.") return end
	local empty = false
	for _, stall in profile.stalls do if not stall.item then empty = true break end end
	if not empty then notify(player, "Lapak penuh. Fusion dua karakter untuk ruang baru.") return end
	local cost = Catalog.Characters[gondola.item.id].price
	if not Economy.spendCash(profile, cost) then notify(player, "Butuh " .. Catalog.money(cost) .. " untuk " .. Catalog.Characters[gondola.item.id].name) return end
	profile.carried = gondola.item
	gondola.item = nil
	if gondola.character then gondola.character:Destroy() gondola.character = nil end
	gondola.prompt.Enabled = false
	gondola.restockAt = workspace:GetServerTimeNow() + 8
	notify(player, "Dapat! Bawa ke lapakmu lalu tekan E.", "claim")
end

function Claim.carryBrainrot(player, profile)
	local existing = Claim.carriedModels[player]
	if existing and existing.item ~= profile.carried then existing.model:Destroy() Claim.carriedModels[player] = nil existing = nil end
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if profile.carried and root then
		if not existing then
			existing = {item = profile.carried, model = Models.create(profile.carried, workspace)}
			existing.model:ScaleTo(0.7)
			Claim.carriedModels[player] = existing
		end
		existing.model:PivotTo(root.CFrame * CFrame.new(2.8, 1, 0))
	end
end

return Claim
