local Catalog = require(game.ReplicatedStorage.Shared.Catalog)
local Models = require(game.ReplicatedStorage.Shared.BrainrotModels)
local World = require(script.Parent.World)
local Economy = require(script.Parent.EconomyService)
local Stall = {plots = {}}

function Stall.refresh(player, profile, index)
	local plot = Stall.plots[player]
	local slot = plot.slots[index]
	local data = profile.stalls[index]
	local y = 2 + (data.level - 1) * 3.5
	slot.pedestal.Position = slot.origin + Vector3.new(0, y, 0)
	slot.pillar.Size = Vector3.new(6, y, 6)
	slot.pillar.Position = slot.origin + Vector3.new(0, y / 2, 0)
	if slot.model then slot.model:Destroy() slot.model = nil end
	if data.item then
		slot.model = Models.create(data.item, plot.folder)
		slot.model:PivotTo(CFrame.new(slot.origin + Vector3.new(0, y + 3, 0)))
		slot.model:SetAttribute("IdleBase", slot.model:GetPivot())
		slot.model:SetAttribute("Dancing", Catalog.Characters[data.item.id].effect == "dance")
	end
	slot.label.Text = "LAPAK " .. index .. " • L" .. data.level .. "\n" .. (data.item and Catalog.money(Catalog.rate(data.item)) .. "/s" or "E: TARUH")
	slot.pedestal.Color = data.lockedUntil > workspace:GetServerTimeNow() and Color3.fromRGB(66, 235, 216) or Color3.fromRGB(244, 182, 80)
end

function Stall.placeBrainrot(player, profile, index, notify)
	local stall = profile.stalls[index]
	if profile.carried and not stall.item then
		stall.item, profile.carried = profile.carried, nil
		Stall.refresh(player, profile, index)
		notify(player, "Sudah di lapak. Income mulai berdetak!", "claim")
	elseif stall.item and not profile.carried then
		profile.carried, stall.item = stall.item, nil
		profile.selected = {}
		Stall.refresh(player, profile, index)
		notify(player, "Dibawa. Taruh di lapak kosong dengan E.")
	else
		notify(player, "Bawa satu karakter, lalu pilih lapak kosong.")
	end
end

function Stall.upgradeStilts(player, profile, index, notify)
	local stall = profile.stalls[index]
	if stall.level >= 5 then notify(player, "Tiang sudah aman penuh!") return end
	local cost = Catalog.StiltCosts[stall.level + 1]
	if not Economy.spendCash(profile, cost) then notify(player, "Butuh " .. Catalog.money(cost) .. " untuk tiang berikutnya.") return end
	stall.level += 1
	Stall.refresh(player, profile, index)
	notify(player, "Tiang naik ke L" .. stall.level, "claim")
end

function Stall.lockStall(player, profile, index, notify)
	local stall = profile.stalls[index]
	local now = workspace:GetServerTimeNow()
	if now < stall.cooldownUntil then notify(player, "Kunci belum siap lagi.") return end
	if not Economy.spendCash(profile, 50) then notify(player, "Kunci membutuhkan $50.") return end
	stall.lockedUntil = now + 60
	stall.cooldownUntil = now + 90
	Stall.refresh(player, profile, index)
	notify(player, "Terkunci 60 detik. Tikus akan kecele.")
end

function Stall.buildPlot(player, profile, plotIndex, notify)
	local folder = Instance.new("Folder")
	folder.Name = "Lapak_" .. player.UserId
	folder.Parent = World.root
	local origin = Vector3.new((plotIndex - 1) % 3 * 65 - 65, 0, 40 + math.floor((plotIndex - 1) / 3) * 40)
	local plot = {folder = folder, slots = {}, origin = origin}
	Stall.plots[player] = plot
	World.sign(folder, player.DisplayName .. " • PASAR\nE taruh/ambil   F bahan   R tiang   T kunci", Vector3.new(28, 5, 1), CFrame.new(origin + Vector3.new(0, 7, 13)), Color3.fromRGB(255, 210, 103))
	for i, _ in profile.stalls do
		local pos = origin + Vector3.new(((i - 1) % 3 - 1) * 10, 0, math.floor((i - 1) / 3) * 11)
		local pillar = World.part(folder, "Tiang" .. i, Vector3.new(6, 2, 6), CFrame.new(pos + Vector3.new(0, 1, 0)), Color3.fromRGB(106, 65, 80), Enum.Material.WoodPlanks)
		local pedestal = World.part(folder, "Pedestal" .. i, Vector3.new(8, 0.7, 8), CFrame.new(pos + Vector3.new(0, 2, 0)), Color3.fromRGB(244, 182, 80))
		local control, label = World.sign(folder, "", Vector3.new(7, 2, 0.5), CFrame.new(pos + Vector3.new(0, 2, -4.5)), Color3.fromRGB(255, 230, 170))
		plot.slots[i] = {origin = pos, pedestal = pedestal, pillar = pillar, label = label, control = control}
		local function own(visitor, callback)
			if visitor ~= player then notify(visitor, "Ini lapak pemain lain.") return end
			local root = visitor.Character and visitor.Character:FindFirstChild("HumanoidRootPart")
			if root and (root.Position - control.Position).Magnitude <= 17 then callback() end
		end
		World.prompt(control, "Taruh / ambil", "Lapak " .. i, Enum.KeyCode.E, function(visitor) own(visitor, function() Stall.placeBrainrot(player, profile, i, notify) end) end)
		World.prompt(control, "Naikkan tiang", "Lapak " .. i, Enum.KeyCode.R, function(visitor) own(visitor, function() Stall.upgradeStilts(player, profile, i, notify) end) end)
		World.prompt(control, "Kunci $50", "Lapak " .. i, Enum.KeyCode.T, function(visitor) own(visitor, function() Stall.lockStall(player, profile, i, notify) end) end)
		World.prompt(control, "Pilih bahan fusion", "Lapak " .. i, Enum.KeyCode.F, function(visitor)
			own(visitor, function()
				if not profile.stalls[i].item then return end
				local found = table.find(profile.selected, i)
				if found then table.remove(profile.selected, found) else
					if #profile.selected == 2 then table.remove(profile.selected, 1) end
					table.insert(profile.selected, i)
				end
				notify(player, "Bahan dipilih: " .. table.concat(profile.selected, " + ") .. ". Pergi ke Gerobak Fusion.")
			end)
		end)
		Stall.refresh(player, profile, i)
	end
	return plot
end

return Stall
