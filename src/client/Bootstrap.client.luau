local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Hud=require(script.Parent.HudController)
local Effects=require(script.Parent.EffectsController)
local events=ReplicatedStorage:WaitForChild("MarketEvents")
Hud.create()
if RunService:IsStudio() then
	local captureFrame=nil
	RunService:BindToRenderStep("StudioCaptureCamera",Enum.RenderPriority.Camera.Value+1,function()
		if captureFrame then
			workspace.CurrentCamera.CameraType=Enum.CameraType.Scriptable
			workspace.CurrentCamera.CFrame=captureFrame
		end
	end)
	local cameraBridge=Instance.new("BindableFunction")
	cameraBridge.Name="StudioCamera"
	cameraBridge.OnInvoke=function(position,target)
		local camera=workspace.CurrentCamera
		captureFrame=position and CFrame.lookAt(position,target) or nil
		return camera.ViewportSize
	end
	cameraBridge.Parent=game.Players.LocalPlayer.PlayerGui
end
local Index=require(script.Parent.IndexController)
local Home=require(script.Parent.HomeController)
Index.create()
Home.create(Hud,Index)
Hud.onIndex=Index.toggle
Hud.onHome=function() Home.show() end
events:WaitForChild("State").OnClientEvent:Connect(function(state)
	Index.setData(state.collection)
	Hud.update(state)
end)
-- HOME poster shows once per join, as soon as the avatar has spawned.
task.spawn(function()
	local player=game.Players.LocalPlayer
	if not player.Character then player.CharacterAdded:Wait() end
	task.wait(0.8)
	Home.show()
end)
events:WaitForChild("Notice").OnClientEvent:Connect(Hud.showTideWarning)
events:WaitForChild("Effect").OnClientEvent:Connect(Effects.receive)
local elapsed=0
local animated={}
local scanClock=0
RunService.RenderStepped:Connect(function(dt)
	for model,origin in animated do
		if model.Parent then
			local dance=model:GetAttribute("Dance") and workspace:GetServerTimeNow()%10<5
			model:PivotTo(origin*CFrame.new(0,math.sin(os.clock()*2)*0.12,0)*CFrame.Angles(0,dance and math.sin(os.clock()*8)*0.3 or 0,0))
		else animated[model]=nil end
	end
	elapsed+=dt
	scanClock+=dt
	if elapsed<0.15 then return end
	elapsed=0
	local market=workspace:FindFirstChild("Market")
	if market and scanClock>=1 then
		scanClock=0
		for _,object in market:GetDescendants() do
			if object:IsA("Model") and object:GetAttribute("Mutation") then Effects.rarityAura(object,os.clock()) end
			if object:IsA("Model") and object:GetAttribute("Idle") and not animated[object] then animated[object]=object:GetPivot() end
		end
	end
end)
