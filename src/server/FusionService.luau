local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local Stall = require(script.Parent.StallService)
local Fusion = {}
local rng = Random.new()

function Fusion.rollMutation(boost)
	local roll = rng:NextNumber()
	if roll < 0.005 * boost then return "Rainbow" end
	if roll < 0.02 * boost then return "Sambal-Lava" end
	if roll < 0.04 * boost then return "Diamond" end
	if roll < 0.08 * boost then return "Gold" end
	return nil
end

function Fusion.fuseBrainrots(player, profile, notify)
	if #profile.selected ~= 2 then notify(player, "Tekan F di dua lapak berisi untuk memilih bahan.") return end
	local a, b = profile.selected[1], profile.selected[2]
	local first, second = profile.stalls[a].item, profile.stalls[b].item
	if not first or not second or a == b then profile.selected = {} return end
	local result
	for _, recipe in Catalog.Recipes do
		if (first.id == recipe[1] and second.id == recipe[2]) or (first.id == recipe[2] and second.id == recipe[1]) then result = recipe[3] break end
	end
	if not result and Catalog.Characters[first.id].rarity == "Legendary" and Catalog.Characters[second.id].rarity == "Legendary" then
		result = rng:NextNumber() < 0.3 and "Molen" or Catalog.Stock.Epic[rng:NextInteger(1, #Catalog.Stock.Epic)]
	end
	if not result then notify(player, "Belum cocok. Cek daftar resep di panel FUSION.") return end
	local boost = 1
	for _, stall in profile.stalls do if stall.item and Catalog.Characters[stall.item.id].effect == "mutation" then boost = 2 break end end
	profile.stalls[a].item = {id = result, mutation = Fusion.rollMutation(boost)}
	profile.stalls[b].item = nil
	profile.selected = {}
	Stall.refresh(player, profile, a)
	Stall.refresh(player, profile, b)
	notify(player, "FUSION! " .. (profile.stalls[a].item.mutation or "") .. " " .. Catalog.Characters[result].name, "fusion")
end

return Fusion
