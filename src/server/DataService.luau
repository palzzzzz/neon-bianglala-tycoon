local RunService=game:GetService("RunService")
local DataStoreService=game:GetService("DataStoreService")
local Data={profiles={}, leases={}}
-- Studio playtests of an unpublished place cannot open DataStores; profiles are in-memory there anyway.
local storeOk,store=pcall(function() return DataStoreService:GetDataStore("BianglalaProfilesV2") end)
if not storeOk then store=nil end
local owner=game.JobId ~= "" and game.JobId or "studio"
function Data.fresh()
	local profile={cash=25,lifetime=0,branches=0,stalls={},epicPity=0,legendPity=0}
	for i=1,6 do profile.stalls[i]={level=1} end
	return profile
end
-- Lifetime collection book: marks every brainrot/mutation the player has ever held
-- (carried, placed, or fused). Called from context.changed after every state change.
function Data.track(profile)
	profile.seen=profile.seen or {}
	profile.seenMut=profile.seenMut or {}
	local function note(catch)
		if not catch then return end
		profile.seen[catch.id]=true
		local mutation=catch.mutation or "Normal"
		if mutation~="Normal" then profile.seenMut[mutation]=true end
	end
	note(profile.carry)
	note(profile.pendingPrize)
	for _,stall in profile.stalls do note(stall.catch) end
end
-- Snapshot sent to the client: current holdings (carried + placed) plus lifetime flags.
function Data.collection(profile)
	local owned,heldMut={},{}
	local function count(catch)
		if not catch then return end
		owned[catch.id]=(owned[catch.id] or 0)+1
		local mutation=catch.mutation or "Normal"
		if mutation~="Normal" then heldMut[mutation]=(heldMut[mutation] or 0)+1 end
	end
	count(profile.carry)
	for _,stall in profile.stalls do count(stall.catch) end
	return {owned=owned,seen=profile.seen or {},heldMut=heldMut,seenMut=profile.seenMut or {}}
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
	profile.seen,profile.seenMut=profile.seen or {},profile.seenMut or {}
	Data.profiles[player]=profile
	return profile
end
function Data.savePlayer(player,release)
	local profile=Data.profiles[player]
	if not profile then return true end
	if RunService:IsStudio() then return true end
	local packed={cash=profile.cash,lifetime=profile.lifetime,branches=profile.branches,stalls={},epicPity=profile.epicPity,legendPity=profile.legendPity,seen=profile.seen,seenMut=profile.seenMut}
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
