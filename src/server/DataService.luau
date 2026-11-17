local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local Data = {profiles = {}}
local store
if not RunService:IsStudio() then
	store = DataStoreService:GetDataStore("BianglalaBrainrot_v1")
end

function Data.loadPlayer(player)
	local profile = {cash = 25, lifetime = 0, branches = 0, stalls = {}, carried = nil}
	if not RunService:IsStudio() then
		local ok, saved = pcall(function() return store:GetAsync(tostring(player.UserId)) end)
		if not ok then return nil, "Profil belum bisa dimuat. Masuk ulang agar progres aman." end
		if type(saved) == "table" then
			profile.cash = tonumber(saved.cash) or 25
			profile.lifetime = tonumber(saved.lifetime) or 0
			profile.branches = math.max(0, math.floor(tonumber(saved.branches) or 0))
			profile.stalls = type(saved.stalls) == "table" and saved.stalls or {}
			profile.carried = saved.carried
		end
	end
	for i = 1, 6 + profile.branches * 2 do
		profile.stalls[i] = profile.stalls[i] or {level = 1}
		profile.stalls[i].lockedUntil = 0
		profile.stalls[i].cooldownUntil = 0
	end
	profile.selected = {}
	Data.profiles[player] = profile
	return profile
end

function Data.savePlayer(player)
	local p = Data.profiles[player]
	if not p or RunService:IsStudio() then return true end
	local stalls = {}
	for i, stall in p.stalls do stalls[i] = {level = stall.level, item = stall.item} end
	local snapshot = {cash = p.cash, lifetime = p.lifetime, branches = p.branches, stalls = stalls, carried = p.carried}
	local ok, err = pcall(function()
		store:UpdateAsync(tostring(player.UserId), function() return snapshot end)
	end)
	if not ok then warn("Save failed for", player.UserId, err) end
	return ok
end

return Data
