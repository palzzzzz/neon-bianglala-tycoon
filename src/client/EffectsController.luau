local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Effects={}
function Effects.claimPop(position,color,count)
	for i=1,count do
		local p=Instance.new("Part")
		p.Size,p.Shape=Vector3.one*0.45,Enum.PartType.Ball
		p.Anchored,p.CanCollide,p.CanTouch=true,false,false
		p.Material,p.Color=Enum.Material.Neon,color
		p.Position=position+Vector3.new(0,2,0)
		p.Parent=workspace
		local a=i*math.pi*2/count
		TweenService:Create(p,TweenInfo.new(0.8),{Position=p.Position+Vector3.new(math.cos(a)*5,3,math.sin(a)*5),Transparency=1}):Play()
		Debris:AddItem(p,0.9)
	end
end
function Effects.fusionBurst(position) Effects.claimPop(position,Color3.fromRGB(255,106,224),28) end
function Effects.rarityAura(model,time)
	if model:GetAttribute("Mutation")=="Rainbow" then
		local highlight=model:FindFirstChildOfClass("Highlight")
		if highlight then highlight.OutlineColor=Color3.fromHSV(time%4/4,0.8,1) end
	end
end
function Effects.receive(kind,position)
	if kind=="hit" then
		local sound=Instance.new("Sound")
		sound.SoundId="rbxasset://sounds/impact_water.mp3"
		sound.Volume,sound.PlaybackSpeed=0.6,1.8
		sound.Parent=workspace
		sound:Play()
		Debris:AddItem(sound,2)
	end
	if kind=="fusion" then Effects.fusionBurst(position)
	else Effects.claimPop(position,Color3.fromRGB(255,222,110),12) end
end
return Effects
