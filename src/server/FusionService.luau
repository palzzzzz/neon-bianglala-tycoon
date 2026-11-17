local Catalog=require(game.ReplicatedStorage.Shared.Catalog)
local Fusion={rng=Random.new()}
function Fusion.rollMutation(boost,rng)
	local r=(rng or Fusion.rng):NextNumber()
	local weight=boost and 2 or 1
	if r<0.005*weight then return "Rainbow" end
	if r<0.020*weight then return "Sambal-Lava" end
	if r<0.040*weight then return "Diamond" end
	if r<0.080*weight then return "Gold" end
	return "Normal"
end
function Fusion.fuseBrainrots(profile)
	if profile.carry or profile.spinning or not profile.selection or #profile.selection~=2 then return false,"Pilih dua lapak [F], kosongkan bawaan." end
	local a,b=profile.stalls[profile.selection[1]],profile.stalls[profile.selection[2]]
	if not a or not b or a==b or not a.catch or not b.catch then return false,"Bahan tidak tersedia." end
	local result
	for _,recipe in Catalog.recipes do
		if (a.catch.id==recipe[1] and b.catch.id==recipe[2]) or (a.catch.id==recipe[2] and b.catch.id==recipe[1]) then result=recipe[3];break end
	end
	if not result and Catalog.byId[a.catch.id].rarity=="Legendary" and Catalog.byId[b.catch.id].rarity=="Legendary" then
		result=Fusion.rng:NextNumber()<0.3 and "maharaja" or Catalog.pick("Epic",Fusion.rng)
	end
	if not result then return false,"Pasangan ini belum punya resep." end
	local boost=false
	for _,stall in profile.stalls do if stall.catch and stall.catch.id=="nagarujak" then boost=true end end
	a.catch={id=result,mutation=Fusion.rollMutation(boost)}
	b.catch=nil
	profile.selection={}
	return true,Catalog.byId[result].name
end
return Fusion
