local Players = game:GetService("Players")
local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local Hud = {}
local cream = Color3.fromRGB(255, 235, 199)
local dark = Color3.fromRGB(28, 23, 47)
local teal = Color3.fromRGB(83, 239, 220)

local function label(parent, text, pos, size, fontSize, color)
	local item = Instance.new("TextLabel")
	item.Position, item.Size = pos, size
	item.BackgroundTransparency = 1
	item.Text = text
	item.TextColor3 = color or cream
	item.Font = Enum.Font.FredokaOne
	item.TextSize = fontSize
	item.TextXAlignment = Enum.TextXAlignment.Left
	item.Parent = parent
	return item
end

local function panel(parent, pos, size)
	local frame = Instance.new("Frame")
	frame.Position, frame.Size = pos, size
	frame.BackgroundColor3 = dark
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = frame
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(118, 81, 133)
	stroke.Thickness = 1.5
	stroke.Parent = frame
	return frame
end

function Hud.build()
	local gui = Instance.new("ScreenGui")
	gui.Name = "PasarHUD"
	gui.ResetOnSpawn = false
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	Hud.gui = gui
	local money = panel(gui, UDim2.new(1, -304, 0, 14), UDim2.fromOffset(286, 105))
	label(money, "DOMPET PASAR", UDim2.fromOffset(18, 10), UDim2.fromOffset(250, 20), 14, teal)
	Hud.cash = label(money, "$25", UDim2.fromOffset(18, 31), UDim2.fromOffset(250, 43), 36)
	Hud.income = label(money, "+$0/s  •  CABANG 0", UDim2.fromOffset(18, 77), UDim2.fromOffset(250, 20), 16, teal)
	local clock = panel(gui, UDim2.new(0.5, -145, 0, 14), UDim2.fromOffset(290, 65))
	Hud.clock = label(clock, "SENJA DI PASAR", UDim2.fromOffset(14, 8), UDim2.fromOffset(270, 24), 19)
	Hud.tide = label(clock, "ROB 0 / TIANG 1", UDim2.fromOffset(14, 36), UDim2.fromOffset(270, 22), 15, teal)
	Hud.banner = label(gui, "", UDim2.new(0.5, -320, 0, 120), UDim2.fromOffset(640, 70), 31, teal)
	Hud.banner.TextXAlignment = Enum.TextXAlignment.Center
	Hud.banner.TextStrokeTransparency = 0.25
	Hud.notice = label(gui, "Naik platform di kanan roda. E klaim gondola, lalu E di lapakmu.", UDim2.new(0.5, -410, 1, -92), UDim2.fromOffset(820, 32), 20)
	Hud.notice.TextXAlignment = Enum.TextXAlignment.Center
	Hud.notice.TextStrokeTransparency = 0.15
	local bottom = panel(gui, UDim2.new(0.5, -380, 1, -52), UDim2.fromOffset(760, 42))
	Hud.carry = label(bottom, "E KLAIM / TARUH     F BAHAN     R TIANG     T KUNCI", UDim2.fromOffset(18, 10), UDim2.fromOffset(730, 23), 16)
	local recipeButton = Instance.new("TextButton")
	recipeButton.Size = UDim2.fromOffset(144, 43)
	recipeButton.Position = UDim2.fromOffset(18, 18)
	recipeButton.Text = "RESEP FUSION"
	recipeButton.Font = Enum.Font.FredokaOne
	recipeButton.TextSize = 16
	recipeButton.TextColor3 = cream
	recipeButton.BackgroundColor3 = dark
	recipeButton.Parent = gui
	Hud.recipes = panel(gui, UDim2.fromOffset(18, 73), UDim2.fromOffset(420, 340))
	Hud.recipes.Visible = false
	local rows = {"GEROBAK FUSION • pilih 2 lapak dengan F", ""}
	for _, recipe in Catalog.Recipes do
		table.insert(rows, Catalog.Characters[recipe[1]].name .. " + " .. Catalog.Characters[recipe[2]].name)
		table.insert(rows, "→ " .. Catalog.Characters[recipe[3]].name)
	end
	table.insert(rows, "2 Legendary → Molen 30% / Epic 70%")
	table.insert(rows, "Mutasi: Gold 4% • Diamond 2% • Lava 1.5% • Rainbow 0.5%")
	local recipes = label(Hud.recipes, table.concat(rows, "\n"), UDim2.fromOffset(14, 12), UDim2.fromOffset(393, 315), 15)
	recipes.TextYAlignment = Enum.TextYAlignment.Top
	recipeButton.Activated:Connect(function() Hud.recipes.Visible = not Hud.recipes.Visible end)
	Hud.stalls = panel(gui, UDim2.new(1, -220, 0, 132), UDim2.fromOffset(202, 210))
	Hud.stallText = label(Hud.stalls, "LAPAKMU\nMenunggu profil...", UDim2.fromOffset(12, 12), UDim2.fromOffset(180, 190), 15)
	Hud.stallText.TextYAlignment = Enum.TextYAlignment.Top
	Hud.lowest = 1
	return Hud
end

function Hud.renderCash(value)
	Hud.cash.Text = Catalog.money(value)
end

function Hud.renderIncomeRate(rate, branches)
	Hud.income.Text = "+" .. Catalog.money(rate) .. "/s  •  CABANG " .. branches
end

function Hud.renderStiltGauge(state)
	local rows = {"LAPAKMU • " .. #state.stalls .. " SLOT"}
	local lowest = 5
	for i, stall in state.stalls do
		lowest = math.min(lowest, stall.level)
		local seconds = math.max(0, math.ceil(stall.lockedUntil - workspace:GetServerTimeNow()))
		local status = stall.flooded and "TERENDAM" or stall.item and "AKTIF" or "KOSONG"
		if seconds > 0 then status = "KUNCI " .. seconds .. "s" end
		table.insert(rows, i .. "  L" .. stall.level .. "  " .. status)
	end
	Hud.lowest = lowest
	Hud.stallText.Text = table.concat(rows, "\n")
	Hud.stalls.Size = UDim2.fromOffset(202, 52 + #state.stalls * 20)
	Hud.stallText.Size = UDim2.new(1, -24, 1, -24)
end

function Hud.showTideWarning()
	local level = workspace:GetAttribute("TideLevel") or 0
	local night = workspace:GetAttribute("Night")
	local seconds = workspace:GetAttribute("CycleRemaining") or 180
	Hud.clock.Text = (night and "MALAM • SURUT " or "SENJA • ROB DALAM ") .. seconds .. "s"
	Hud.tide.Text = "AIR " .. level .. " / 5  •  TIANG TERENDAH L" .. Hud.lowest
	Hud.banner.Text = night and (level >= 3 and "BANJIR ROB RISING!\nKUNCI & NAIKKAN TIANG" or "BANJIR ROB RISING!") or ""
end

function Hud.render(state)
	Hud.renderCash(state.cash)
	Hud.renderIncomeRate(state.income, state.branches)
	Hud.renderStiltGauge(state)
	if state.carried then
		Hud.carry.Text = "MEMBAWA " .. Catalog.Characters[state.carried.id].name .. " • E di lapak kosong"
	elseif #state.selected > 0 then
		Hud.carry.Text = "BAHAN: LAPAK " .. table.concat(state.selected, " + ") .. " • E di Gerobak Fusion"
	else Hud.carry.Text = "E KLAIM / TARUH     F BAHAN     R TIANG     T KUNCI" end
	Hud.showTideWarning()
end

return Hud
