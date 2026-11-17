local Catalog = {}

Catalog.Rarities = {
	Common = Color3.fromRGB(150, 240, 130),
	Rare = Color3.fromRGB(70, 180, 255),
	Epic = Color3.fromRGB(193, 100, 255),
	Legendary = Color3.fromRGB(255, 206, 65),
	Mythic = Color3.fromRGB(255, 65, 165),
	["Brainrot God"] = Color3.fromRGB(255, 245, 210),
}

Catalog.Characters = {
	Kangkung = {name = "Kakek Kangkung", rarity = "Common", price = 10, rate = 1, shape = "greens", color = Color3.fromRGB(93, 166, 66)},
	Lemper = {name = "Mpok Lemper", rarity = "Common", price = 15, rate = 1, shape = "parcel", color = Color3.fromRGB(77, 149, 74)},
	Boba = {name = "Bocil Boba", rarity = "Common", price = 25, rate = 2, shape = "cup", color = Color3.fromRGB(210, 160, 110)},
	Pentol = {name = "Pakde Pentol", rarity = "Common", price = 35, rate = 2, shape = "skewer", color = Color3.fromRGB(220, 171, 112)},
	Nangka = {name = "Nenek Nangka", rarity = "Common", price = 50, rate = 3, shape = "fruit", color = Color3.fromRGB(236, 201, 67)},
	Sultan = {name = "Sate Sultan", rarity = "Rare", price = 150, rate = 6, shape = "skewer", color = Color3.fromRGB(255, 193, 43)},
	Rendang = {name = "Ratu Rendang", rarity = "Rare", price = 220, rate = 8, shape = "pot", color = Color3.fromRGB(156, 63, 42)},
	Koplo = {name = "DJ Dangdut Koplo", rarity = "Rare", price = 300, rate = 10, shape = "speaker", color = Color3.fromRGB(50, 132, 240)},
	Parkir = {name = "Tukang Parkir Sakti", rarity = "Rare", price = 400, rate = 12, shape = "vest", color = Color3.fromRGB(255, 127, 45)},
	Naga = {name = "Naga Nasi Padang", rarity = "Epic", price = 1200, rate = 30, shape = "dragon", color = Color3.fromRGB(140, 211, 79)},
	Pocong = {name = "Pocong Premium", rarity = "Epic", price = 2000, rate = 48, shape = "ghost", color = Color3.fromRGB(239, 231, 244)},
	Rujak = {name = "Raksasa Rujak", rarity = "Epic", price = 3000, rate = 70, shape = "mortar", color = Color3.fromRGB(112, 91, 137)},
	Durian = {name = "Dewa Durian Emas", rarity = "Legendary", price = 12000, rate = 250, shape = "fruit", color = Color3.fromRGB(255, 199, 55)},
	Pinisi = {name = "Kapal Pinisi Terbang", rarity = "Legendary", price = 25000, rate = 500, shape = "boat", color = Color3.fromRGB(225, 152, 60)},
	Phoenix = {name = "Phoenix Pecel Lele", rarity = "Mythic", price = 90000, rate = 1800, shape = "bird", color = Color3.fromRGB(252, 62, 162)},
	Molen = {name = "Maharaja Molen Pelangi", rarity = "Brainrot God", rate = 7500, shape = "rainbow", color = Color3.fromRGB(250, 180, 80)},
	LemperBoba = {name = "Lemper Boba Meledak", rarity = "Rare", rate = 14, shape = "cup", color = Color3.fromRGB(114, 205, 113), effect = "commonBonus"},
	Bakso = {name = "Bakso Kangkung Berotot", rarity = "Rare", rate = 16, shape = "greens", color = Color3.fromRGB(124, 189, 72), effect = "adjacent"},
	Goyang = {name = "Sate Goyang Sultan", rarity = "Epic", rate = 85, shape = "speaker", color = Color3.fromRGB(255, 195, 58), effect = "dance"},
	NagaRujak = {name = "Naga Rujak Bumbu Kacang", rarity = "Legendary", rate = 620, shape = "dragon", color = Color3.fromRGB(226, 100, 49), effect = "mutation"},
	PocongPhoenix = {name = "Pocong Phoenix Sambal Matah", rarity = "Mythic", rate = 2400, shape = "ghost", color = Color3.fromRGB(255, 90, 165), waterproof = true},
	PinisiDurian = {name = "Pinisi Durian Antariksa", rarity = "Mythic", rate = 2600, shape = "boat", color = Color3.fromRGB(181, 91, 255), waterproof = true},
}

Catalog.Recipes = {
	{"Boba", "Lemper", "LemperBoba"},
	{"Kangkung", "Pentol", "Bakso"},
	{"Sultan", "Koplo", "Goyang"},
	{"Naga", "Rujak", "NagaRujak"},
	{"Pocong", "Phoenix", "PocongPhoenix"},
	{"Durian", "Pinisi", "PinisiDurian"},
}

Catalog.Mutations = {Gold = 2, Diamond = 5, ["Sambal-Lava"] = 9, Rainbow = 20}
Catalog.StiltCosts = {0, 200, 1500, 8000, 40000}
Catalog.Stock = {
	Common = {"Kangkung", "Lemper", "Boba", "Pentol", "Nangka"},
	Rare = {"Sultan", "Rendang", "Koplo", "Parkir"},
	Epic = {"Naga", "Pocong", "Rujak"},
	Legendary = {"Durian", "Pinisi"},
	Mythic = {"Phoenix"},
}

function Catalog.rate(item)
	return Catalog.Characters[item.id].rate * (Catalog.Mutations[item.mutation] or 1)
end

function Catalog.money(value)
	if value >= 1e6 then return string.format("$%.2fM", value / 1e6) end
	if value >= 10000 then return string.format("$%.1fK", value / 1000) end
	return "$" .. tostring(math.floor(value))
end

return Catalog
