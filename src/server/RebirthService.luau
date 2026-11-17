local Rebirth={}
function Rebirth.requirement(profile)
	return 250000*10^profile.branches
end
function Rebirth.rebirthOpenBranch(profile)
	if profile.spinning or profile.pendingPrize or profile.lifetime<Rebirth.requirement(profile) then return false end
	profile.branches+=1
	profile.cash,profile.carry,profile.selection=25,nil,{}
	profile.stalls={}
	for i=1,6+profile.branches*2 do profile.stalls[i]={level=1} end
	return true
end
return Rebirth
