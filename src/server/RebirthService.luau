local Stall = require(script.Parent.StallService)
local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local Rebirth = {}

function Rebirth.rebirthOpenBranch(player, profile, plotIndex, notify)
	local required = 250000 * 10 ^ profile.branches
	if profile.lifetime < required then notify(player, "Butuh lifetime " .. Catalog.money(required) .. " untuk cabang berikutnya.") return end
	profile.branches += 1
	profile.cash = 25
	profile.carried = nil
	profile.selected = {}
	profile.stalls = {}
	for i = 1, 6 + profile.branches * 2 do profile.stalls[i] = {level = 1, lockedUntil = 0, cooldownUntil = 0} end
	Stall.plots[player].folder:Destroy()
	Stall.buildPlot(player, profile, plotIndex, notify)
	notify(player, "CABANG " .. profile.branches .. "! Income ×" .. (profile.branches + 1) .. " dan dua lapak baru.", "fusion")
end

return Rebirth
