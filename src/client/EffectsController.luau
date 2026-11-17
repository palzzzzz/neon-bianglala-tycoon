local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Effects = {}

function Effects.claimPop(gui, text, color)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromOffset(320, 55)
	label.Position = UDim2.new(0.5, -160, 0.4, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Color3.fromRGB(100, 255, 210)
	label.Font = Enum.Font.FredokaOne
	label.TextSize = 32
	label.TextStrokeTransparency = 0.2
	label.Parent = gui
	TweenService:Create(label, TweenInfo.new(1.3), {Position = UDim2.new(0.5, -160, 0.3, 0), TextTransparency = 1, TextStrokeTransparency = 1}):Play()
	game:GetService("Debris"):AddItem(label, 1.4)
end

function Effects.fusionBurst(gui)
	for i = 1, 18 do
		local dot = Instance.new("Frame")
		dot.Size = UDim2.fromOffset(8, 18)
		dot.Position = UDim2.fromScale(0.5, 0.4)
		dot.BackgroundColor3 = Color3.fromHSV(i / 18, 0.8, 1)
		dot.BorderSizePixel = 0
		dot.Parent = gui
		local a = i / 18 * math.pi * 2
		TweenService:Create(dot, TweenInfo.new(1), {Position = UDim2.new(0.5, math.cos(a) * 250, 0.4, math.sin(a) * 200), Rotation = i * 80, BackgroundTransparency = 1}):Play()
		game:GetService("Debris"):AddItem(dot, 1.1)
	end
end

function Effects.rarityAura()
	local models = {}
	local function track(instance)
		if instance:IsA("Model") and instance:GetAttribute("IdleBase") then models[instance] = true end
	end
	for _, instance in workspace:GetDescendants() do track(instance) end
	workspace.DescendantAdded:Connect(function(instance)
		if instance:IsA("Model") then
			instance:GetAttributeChangedSignal("IdleBase"):Connect(function() track(instance) end)
			track(instance)
		end
	end)
	RunService.RenderStepped:Connect(function()
		local t = workspace:GetServerTimeNow()
		for model in models do
			if not model.Parent then models[model] = nil else
				local base = model:GetAttribute("IdleBase")
				local dance = model:GetAttribute("Dancing")
				model:PivotTo(base * CFrame.new(0, math.sin(t * (dance and 7 or 2)) * 0.22, 0) * CFrame.Angles(0, math.sin(t * 2) * (dance and 0.35 or 0.06), 0))
			end
		end
	end)
end

return Effects
