local Catalog=require(game.ReplicatedStorage.Shared.Catalog)
local Tide=require(script.Parent.TideService)
local Economy={}
function Economy.rollGachaRarity(profile,rng)
	local roll=rng:NextNumber()*100
	local jackpot=roll>=99.5
	local rarity=roll<55 and "Common" or roll<82 and "Rare" or roll<93 and "Epic" or roll<97.5 and "Legendary" or "Mythic"
	if jackpot then
		local base=rng:NextNumber()*99.5
		rarity=base<55 and "Common" or base<82 and "Rare" or base<93 and "Epic" or base<97.5 and "Legendary" or "Mythic"
	end
	if (profile.legendPity or 0)>=39 and Catalog.rank(rarity)<4 then rarity="Legendary"
	elseif (profile.epicPity or 0)>=14 and Catalog.rank(rarity)<3 then rarity="Epic" end
	return rarity,jackpot
end
function Economy.pityStep(profile,rarity)
	local rank=Catalog.rank(rarity)
	profile.epicPity=rank>=3 and 0 or (profile.epicPity or 0)+1
	profile.legendPity=rank>=4 and 0 or (profile.legendPity or 0)+1
end
function Economy.addCash(profile,amount,earned)
	assert(amount>=0 and amount<math.huge,"Invalid cash award")
	profile.cash+=amount
	if earned then profile.lifetime+=amount end
end
function Economy.spendCash(profile,amount)
	if amount<0 or profile.cash<amount then return false end
	profile.cash-=amount
	return true
end
function Economy.rates(profile,elapsed)
	local rates,commonCount,dancing={},0,false
	for _,stall in profile.stalls do
		if stall.catch then
			local item=Catalog.byId[stall.catch.id]
			if item.rarity=="Common" then commonCount+=1 end
			if item.effect=="dance" and not Tide.isStallFlooded(stall) and elapsed%10<5 then dancing=true end
		end
	end
	local total=0
	for i,stall in profile.stalls do
		local rate=0
		if stall.catch then
			local item=Catalog.byId[stall.catch.id]
			if not Tide.isStallFlooded(stall) or item.effect=="waterproof" then
				rate=Catalog.income(stall.catch)
				if item.effect=="commonBonus" then rate+=commonCount*2000 end
				if item.rarity=="Common" then
					for _,j in {i-1,i+1} do
						local neighbor=profile.stalls[j]
						if neighbor and neighbor.catch and neighbor.catch.id=="baksokangkung" and not Tide.isStallFlooded(neighbor) then rate*=1.5;break end
					end
				end
				rate*=1+profile.branches
				if dancing then rate*=1.1 end
			end
		end
		rates[i]=rate
		total+=rate
	end
	return total,rates
end
function Economy.collectIncomeTick(profile,elapsed)
	local amount=Economy.rates(profile,elapsed)
	Economy.addCash(profile,amount,true)
	return amount
end
return Economy
