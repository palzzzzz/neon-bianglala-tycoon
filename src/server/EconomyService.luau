local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local Tide = require(script.Parent.TideService)
local Economy = {}

function Economy.spendCash(profile, cost)
	if profile.cash < cost then return false end
	profile.cash -= cost
	return true
end

function Economy.addCash(profile, amount)
	profile.cash += amount
	profile.lifetime += amount
end

function Economy.collectIncomeTick(profile)
	local total, commonBonus, dancing = 0, 0, false
	for _, stall in profile.stalls do
		if stall.item and (not Tide.isStallFlooded(stall) or Catalog.Characters[stall.item.id].waterproof) then
			local effect = Catalog.Characters[stall.item.id].effect
			if effect == "commonBonus" then commonBonus += 2 end
			if effect == "dance" then dancing = true end
		end
	end
	for index, stall in profile.stalls do
		if stall.item then
			local character = Catalog.Characters[stall.item.id]
			if not Tide.isStallFlooded(stall) or character.waterproof then
				local rate = Catalog.rate(stall.item)
				if character.rarity == "Common" then
					rate += commonBonus
					for _, neighborIndex in {index - 1, index + 1} do
						local neighbor = profile.stalls[neighborIndex]
						if neighbor and neighbor.item and Catalog.Characters[neighbor.item.id].effect == "adjacent" and not Tide.isStallFlooded(neighbor) then rate *= 1.5 end
					end
				end
				total += rate
			end
		end
	end
	total *= (1 + profile.branches) * (dancing and 1.1 or 1)
	Economy.addCash(profile, total)
	return total
end

return Economy
