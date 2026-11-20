-- Indonesian night-market collection; numeric balance follows the design tables (money scaled x1000).
local Catalog = {}
Catalog.rarityOrder = {"Common", "Rare", "Epic", "Legendary", "Mythic", "Brainrot God"}
Catalog.colors = {
	Common = Color3.fromRGB(151, 241, 126), Rare = Color3.fromRGB(76, 177, 255),
	Epic = Color3.fromRGB(189, 108, 255), Legendary = Color3.fromRGB(255, 211, 72),
	Mythic = Color3.fromRGB(255, 93, 192), ["Brainrot God"] = Color3.fromRGB(118, 255, 231),
}
Catalog.items = {
	{id="kangkung", name="Chimpanzini Daunini", rarity="Common", price=10000, rate=1000, shape="greens", color=Color3.fromRGB(85,176,94)},
	{id="lemper", name="Boneca Lemperlabu", rarity="Common", price=15000, rate=1000, shape="parcel", color=Color3.fromRGB(93,196,119)},
	{id="boba", name="Ballerina Bobaccina", rarity="Common", price=25000, rate=2000, shape="cup", color=Color3.fromRGB(207,156,111)},
	{id="pentol", name="Tripi Tropi Pentola", rarity="Common", price=35000, rate=2000, shape="skewer", color=Color3.fromRGB(239,199,147)},
	{id="nangka", name="Tigrrullini Nangkallini", rarity="Common", price=50000, rate=3000, shape="fruit", color=Color3.fromRGB(225,218,83)},
	{id="sate", name="Frigo Satelo", rarity="Rare", price=150000, rate=6000, shape="crown", color=Color3.fromRGB(239,181,55)},
	{id="rendang", name="La Vaca Rendangita", rarity="Rare", price=220000, rate=8000, shape="pot", color=Color3.fromRGB(166,71,53)},
	{id="koplo", name="Tung Tung Tung Subuh", rarity="Rare", price=300000, rate=10000, shape="speaker", color=Color3.fromRGB(70,116,228)},
	{id="parkir", name="Zibra Zubra Parkirini", rarity="Rare", price=400000, rate=12000, shape="whistle", color=Color3.fromRGB(255,147,54)},
	{id="naga", name="Nagadiro Crocodilo", rarity="Epic", price=1200000, rate=30000, shape="dragon", color=Color3.fromRGB(112,211,122)},
	{id="pocong", name="Brr Brr Pocongpim", rarity="Epic", price=2000000, rate=48000, shape="ghost", color=Color3.fromRGB(245,237,227)},
	{id="rujak", name="Rujaccino Assassino", rarity="Epic", price=3000000, rate=70000, shape="mortar", color=Color3.fromRGB(143,124,151)},
	{id="durian", name="Lirili Durila", rarity="Legendary", price=12000000, rate=250000, shape="spikes", color=Color3.fromRGB(255,196,45)},
	{id="pinisi", name="Tralalero Velala", rarity="Legendary", price=25000000, rate=500000, shape="ship", color=Color3.fromRGB(189,115,66)},
	{id="phoenix", name="Bombombini Fenixini", rarity="Mythic", price=90000000, rate=1800000, shape="bird", color=Color3.fromRGB(255,83,169)},
	{id="maharaja", name="Tralalero Halolala", rarity="Brainrot God", price=0, rate=7500000, shape="halo", color=Color3.fromRGB(255,186,94)},
	{id="lemperboba", name="Boneca Bobaccina", rarity="Rare", price=0, rate=14000, shape="cup", color=Color3.fromRGB(125,221,117), effect="commonBonus"},
	{id="baksokangkung", name="Tripi Tropi Daunini", rarity="Rare", price=0, rate=16000, shape="greens", color=Color3.fromRGB(92,192,121), effect="neighbor"},
	{id="sategoyang", name="Tung Tung Satelo", rarity="Epic", price=0, rate=85000, shape="speaker", color=Color3.fromRGB(255,182,64), effect="dance"},
	{id="nagarujak", name="Nagadiro Rujakdilo", rarity="Legendary", price=0, rate=620000, shape="dragon", color=Color3.fromRGB(244,128,61), effect="mutation"},
	{id="pocongphoenix", name="Brr Brr Fenixini", rarity="Mythic", price=0, rate=2400000, shape="ghost", color=Color3.fromRGB(255,145,195), effect="waterproof"},
	{id="pinisidurian", name="Tralalero Durila", rarity="Mythic", price=0, rate=2600000, shape="ship", color=Color3.fromRGB(233,197,64), effect="waterproof"},
}
Catalog.byId = {}
for _, item in Catalog.items do Catalog.byId[item.id] = item end
Catalog.recipes = {
	{"boba", "lemper", "lemperboba"}, {"kangkung", "pentol", "baksokangkung"},
	{"sate", "koplo", "sategoyang"}, {"naga", "rujak", "nagarujak"},
	{"pocong", "phoenix", "pocongphoenix"}, {"durian", "pinisi", "pinisidurian"},
}
-- Eight mutations, ordered by strength. chance = spawn weight on a fusion roll (rarer = stronger).
Catalog.mutations = {
	{name="Silver", mult=1.5, chance=0.06, color=Color3.fromRGB(205,212,224), label="x1.5"},
	{name="Gold", mult=2, chance=0.04, color=Color3.fromRGB(255,207,69), label="x2"},
	{name="Frozen", mult=4, chance=0.03, color=Color3.fromRGB(140,226,255), label="x4"},
	{name="Diamond", mult=5, chance=0.02, color=Color3.fromRGB(123,243,255), label="x5"},
	{name="Toxic", mult=7, chance=0.018, color=Color3.fromRGB(96,255,64), label="x7"},
	{name="Sambal-Lava", mult=9, chance=0.015, color=Color3.fromRGB(255,98,62), label="x9"},
	{name="Galaxy", mult=12, chance=0.008, color=Color3.fromRGB(88,38,158), label="x12"},
	{name="Rainbow", mult=20, chance=0.005, color=Color3.fromRGB(255,130,230), label="x20"},
}
Catalog.multipliers = {Normal=1}
Catalog.mutationByName = {}
for _, m in Catalog.mutations do
	Catalog.multipliers[m.name] = m.mult
	Catalog.mutationByName[m.name] = m
end
Catalog.stiltPrices = {0, 200000, 1500000, 8000000, 40000000}
Catalog.lockPrice = 50000
Catalog.startingCash = 25000
Catalog.lotteryBasePrice = 250000
Catalog.rebirthBase = 250000000
function Catalog.rank(rarity)
	return table.find(Catalog.rarityOrder, rarity) or 1
end
function Catalog.pick(rarity, rng)
	local pool = {}
	for index = 1, 15 do
		local item = Catalog.items[index]
		if item.rarity == rarity then table.insert(pool, item.id) end
	end
	return pool[rng:NextInteger(1, #pool)]
end
function Catalog.income(catch)
	return Catalog.byId[catch.id].rate * (Catalog.multipliers[catch.mutation or "Normal"] or 1)
end
return Catalog
