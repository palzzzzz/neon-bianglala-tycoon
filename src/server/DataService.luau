local RunService=game:GetService("RunService")
local DataStoreService=game:GetService("DataStoreService")
local Data={profiles={}, leases={}}
local store=DataStoreService:GetDataStore("BianglalaProfilesV2")
local owner=game.JobId ~= "" and game.JobId or "studio"
function Data.fresh()
	local profile={cash=25,lifetime=0,branches=0,stalls={},epicPity=0,legendPity=0}
	for i=1,6 do profile.stalls[i]={level=1} end
	return profile
end
function Data.loadPlayer(player)
	local profile
	if RunService:IsStudio() then profile=Data.fresh()
	else
		local ok, result=pcall(function()
			return store:UpdateAsync(tostring(player.UserId),function(saved)
				if saved and saved.lease and saved.lease.owner~=owner and saved.lease.untilTime>os.time() then return nil end
				local record=saved or {profile=Data.fresh()}
				record.lease={owner=owner,untilTime=os.time()+180}
				return record
			end)
		end)
		if not ok or not result then player:Kick("Data pasar belum tersedia. Coba masuk lagi sebentar."); return nil end
		profile=result.profile
	end
	Data.profiles[player]=profile
	return profile
end
function Data.savePlayer(player,release)
	local profile=Data.profiles[player]
	if not profile then return true end
	if RunService:IsStudio() then return true end
	local packed={cash=profile.cash,lifetime=profile.lifetime,branches=profile.branches,stalls={},epicPity=profile.epicPity,legendPity=profile.legendPity}
	for i,stall in profile.stalls do packed.stalls[i]={level=stall.level,catch=stall.catch} end
	-- A carried purchase is returned to a free pedestal on the next join.
	packed.carry=profile.carry
	packed.pendingPrize=profile.pendingPrize
	local ok, result=pcall(function()
		return store:UpdateAsync(tostring(player.UserId),function(saved)
			if not saved or not saved.lease or saved.lease.owner~=owner then return nil end
			return {profile=packed,lease=not release and {owner=owner,untilTime=os.time()+180} or nil}
		end)
	end)
	if not ok or not result then warn("Profile save failed for user",player.UserId); return false end
	return true
end
return Data
