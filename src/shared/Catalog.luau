-- Indonesian night-market collection; numeric balance follows the design tables.
local Catalog = {}
Catalog.rarityOrder = {"Common", "Rare", "Epic", "Legendary", "Mythic", "Brainrot God"}
Catalog.colors = {
	Common = Color3.fromRGB(151, 241, 126), Rare = Color3.fromRGB(76, 177, 255),
	Epic = Color3.fromRGB(189, 108, 255), Legendary = Color3.fromRGB(255, 211, 72),
	Mythic = Color3.fromRGB(255, 93, 192), ["Brainrot God"] = Color3.fromRGB(118, 255, 231),
}
Catalog.items = {
	{id="kangkung", name="Kakek Kangkung", rarity="Common", price=10, rate=1, shape="greens", color=Color3.fromRGB(85,176,94)},
	{id="lemper", name="Mpok Lemper", rarity="Common", price=15, rate=1, shape="parcel", color=Color3.fromRGB(93,196,119)},
	{id="boba", name="Bocil Boba", rarity="Common", price=25, rate=2, shape="cup", color=Color3.fromRGB(207,156,111)},
	{id="pentol", name="Pakde Pentol", rarity="Common", price=35, rate=2, shape="skewer", color=Color3.fromRGB(239,199,147)},
	{id="nangka", name="Nenek Nangka", rarity="Common", price=50, rate=3, shape="fruit", color=Color3.fromRGB(225,218,83)},
	{id="sate", name="Sate Sultan", rarity="Rare", price=150, rate=6, shape="crown", color=Color3.fromRGB(239,181,55)},
	{id="rendang", name="Ratu Rendang", rarity="Rare", price=220, rate=8, shape="pot", color=Color3.fromRGB(166,71,53)},
	{id="koplo", name="DJ Dangdut Koplo", rarity="Rare", price=300, rate=10, shape="speaker", color=Color3.fromRGB(70,116,228)},
	{id="parkir", name="Tukang Parkir Sakti", rarity="Rare", price=400, rate=12, shape="whistle", color=Color3.fromRGB(255,147,54)},
	{id="naga", name="Naga Nasi Padang", rarity="Epic", price=1200, rate=30, shape="dragon", color=Color3.fromRGB(112,211,122)},
	{id="pocong", name="Pocong Premium", rarity="Epic", price=2000, rate=48, shape="ghost", color=Color3.fromRGB(245,237,227)},
	{id="rujak", name="Raksasa Rujak", rarity="Epic", price=3000, rate=70, shape="mortar", color=Color3.fromRGB(143,124,151)},
	{id="durian", name="Dewa Durian Emas", rarity="Legendary", price=12000, rate=250, shape="spikes", color=Color3.fromRGB(255,196,45)},
	{id="pinisi", name="Kapal Pinisi Terbang", rarity="Legendary", price=25000, rate=500, shape="ship", color=Color3.fromRGB(189,115,66)},
	{id="phoenix", name="Phoenix Pecel Lele", rarity="Mythic", price=90000, rate=1800, shape="bird", color=Color3.fromRGB(255,83,169)},
	{id="maharaja", name="Maharaja Molen Pelangi", rarity="Brainrot God", price=0, rate=7500, shape="halo", color=Color3.fromRGB(255,186,94)},
	{id="lemperboba", name="Lemper Boba Meledak", rarity="Rare", price=0, rate=14, shape="cup", color=Color3.fromRGB(125,221,117), effect="commonBonus"},
	{id="baksokangkung", name="Bakso Kangkung Berotot", rarity="Rare", price=0, rate=16, shape="greens", color=Color3.fromRGB(92,192,121), effect="neighbor"},
	{id="sategoyang", name="Sate Goyang Sultan", rarity="Epic", price=0, rate=85, shape="speaker", color=Color3.fromRGB(255,182,64), effect="dance"},
	{id="nagarujak", name="Naga Rujak Bumbu Kacang", rarity="Legendary", price=0, rate=620, shape="dragon", color=Color3.fromRGB(244,128,61), effect="mutation"},
	{id="pocongphoenix", name="Pocong Phoenix Sambal Matah", rarity="Mythic", price=0, rate=2400, shape="ghost", color=Color3.fromRGB(255,145,195), effect="waterproof"},
	{id="pinisidurian", name="Pinisi Durian Antariksa", rarity="Mythic", price=0, rate=2600, shape="ship", color=Color3.fromRGB(233,197,64), effect="waterproof"},
}
Catalog.byId = {}
for _, item in Catalog.items do Catalog.byId[item.id] = item end
Catalog.recipes = {
	{"boba", "lemper", "lemperboba"}, {"kangkung", "pentol", "baksokangkung"},
	{"sate", "koplo", "sategoyang"}, {"naga", "rujak", "nagarujak"},
	{"pocong", "phoenix", "pocongphoenix"}, {"durian", "pinisi", "pinisidurian"},
}
Catalog.multipliers = {Normal=1, Gold=2, Diamond=5, ["Sambal-Lava"]=9, Rainbow=20}
Catalog.stiltPrices = {0, 200, 1500, 8000, 40000}
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
