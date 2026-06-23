local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 1. Główny kontener (Mod Menu)
local oldGui = playerGui:FindFirstChild("Mod Menu")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mod Menu"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 9999999
screenGui.Parent = playerGui

-- 2. Główna ramka
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 360)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

-- 3. Tytuł (ZMIENIONO NA: 3008 Mod Menu)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -90, 0, 45)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "3008 Mod Menu"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 11
titleLabel.Parent = mainFrame

-- 4. Przewijana zawartość
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ContentScroll"
scrollFrame.Size = UDim2.new(0.92, 0, 1, -60)
scrollFrame.Position = UDim2.new(0.5, 0, 0, 50)
scrollFrame.AnchorPoint = Vector2.new(0.5, 0)
scrollFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
scrollFrame.BorderSizePixel = 0
scrollFrame.Visible = true
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 105)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ZIndex = 11
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = scrollFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 8)
listPadding.PaddingBottom = UDim.new(0, 8)
listPadding.Parent = scrollFrame

-- ====================================================================
-- TEKST CYKLU
-- ====================================================================
local cycleTextLabel = Instance.new("TextLabel")
cycleTextLabel.Name = "CycleTextLabel"
cycleTextLabel.Size = UDim2.new(0.9, 0, 0, 30)
cycleTextLabel.BackgroundTransparency = 1
cycleTextLabel.Text = "Cycles End : Szukanie..."
cycleTextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
cycleTextLabel.TextSize = 15
cycleTextLabel.Font = Enum.Font.GothamBold
cycleTextLabel.TextXAlignment = Enum.TextXAlignment.Left
cycleTextLabel.LayoutOrder = 0
cycleTextLabel.ZIndex = 12
cycleTextLabel.Parent = scrollFrame

local function findCorrectTextBox()
	local descendants = playerGui:GetDescendants()
	for _, obj in ipairs(descendants) do
		if obj.Name == "TimeLeft" then
			local inputFrame = obj:FindFirstChild("Input")
			if inputFrame then
				local textBox = inputFrame:FindFirstChild("TextBox")
				if textBox and textBox:IsA("TextBox") then
					return textBox
				end
			end
		end
	end
	return nil
end

task.spawn(function()
	task.wait(0.2)
	local targetTextBox = findCorrectTextBox()
	if targetTextBox then
		local function refreshText()
			cycleTextLabel.Text = "Cycles End : " .. targetTextBox.Text
		end
		refreshText()
		targetTextBox:GetPropertyChangedSignal("Text"):Connect(refreshText)
	else
		cycleTextLabel.Text = "Cycles End : Nie znaleziono bazy"
	end
end)

-- ====================================================================
-- PETLA SPEED / JUMPPOWER
-- ====================================================================
local customSpeed = 16
local customJumpPower = 40

local statsConnection = RunService.Heartbeat:Connect(function()
	local character = localPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			if humanoid.WalkSpeed ~= customSpeed then
				humanoid.WalkSpeed = customSpeed
			end
			if humanoid.JumpPower ~= customJumpPower then
				humanoid.UseJumpPower = true
				humanoid.JumpPower = customJumpPower
			end
		end
	end
end)

local function createSlider(name, min, max, default, layoutOrder, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = name .. "SliderFrame"
	sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
	sliderFrame.BorderSizePixel = 0
	sliderFrame.LayoutOrder = layoutOrder
	sliderFrame.ZIndex = 12
	sliderFrame.Parent = scrollFrame

	local sCorner = Instance.new("UICorner")
	sCorner.CornerRadius = UDim.new(0, 6)
	sCorner.Parent = sliderFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Position = UDim2.new(0, 10, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = name .. ": " .. tostring(default)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 13
	label.Parent = sliderFrame

	local barBackground = Instance.new("Frame")
	barBackground.Size = UDim2.new(1, -20, 0, 8)
	barBackground.Position = UDim2.new(0, 10, 0, 32)
	barBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	barBackground.BorderSizePixel = 0
	barBackground.ZIndex = 13
	barBackground.Parent = sliderFrame

	local bgCorner = Instance.new("UICorner")
	bgCorner.CornerRadius = UDim.new(0, 4)
	bgCorner.Parent = barBackground

	local barFill = Instance.new("Frame")
	local startPercent = (default - min) / (max - min)
	barFill.Size = UDim2.new(startPercent, 0, 1, 0)
	barFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	barFill.BorderSizePixel = 0
	barFill.ZIndex = 14
	barFill.Parent = barBackground

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 4)
	fillCorner.Parent = barFill

	local sliderButton = Instance.new("TextButton")
	sliderButton.Size = UDim2.new(1, 0, 1, 0)
	sliderButton.BackgroundTransparency = 1
	sliderButton.Text = ""
	sliderButton.ZIndex = 15
	sliderButton.Parent = barBackground

	local isSliding = false

	local function updateSlider(input)
		local inputX = input.Position.X
		local barX = barBackground.AbsolutePosition.X
		local barWidth = barBackground.AbsoluteSize.X
		local percentage = math.clamp((inputX - barX) / barWidth, 0, 1)
		
		barFill.Size = UDim2.new(percentage, 0, 1, 0)
		local rawValue = min + (percentage * (max - min))
		local finalValue = math.round(rawValue)
		
		label.Text = name .. ": " .. tostring(finalValue)
		callback(finalValue)
	end

	sliderButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isSliding = true
			updateSlider(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isSliding = false
		end
	end)
end

createSlider("Speed", 16, 50, 16, 1, function(value) customSpeed = value end)
createSlider("JumpPower", 40, 70, 40, 2, function(value) customJumpPower = value end)

-- ====================================================================
-- Przycisk "Inf Admin"
-- ====================================================================
local infAdminButton = Instance.new("TextButton")
infAdminButton.Name = "InfAdminButton"
infAdminButton.Size = UDim2.new(0.9, 0, 0, 40)
infAdminButton.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
infAdminButton.Text = "Inf Admin"
infAdminButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infAdminButton.Font = Enum.Font.GothamBold
infAdminButton.TextSize = 14
infAdminButton.BorderSizePixel = 0
infAdminButton.LayoutOrder = 3
infAdminButton.ZIndex = 12
infAdminButton.Parent = scrollFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = infAdminButton

infAdminButton.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- ====================================================================
-- Przycisk "Anti-Falldamage"
-- ====================================================================
local antiFallButton = Instance.new("TextButton")
antiFallButton.Name = "AntiFallButton"
antiFallButton.Size = UDim2.new(0.9, 0, 0, 40)
antiFallButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
antiFallButton.Text = "Anti-Fall: OFF"
antiFallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
antiFallButton.Font = Enum.Font.GothamBold
antiFallButton.TextSize = 14
antiFallButton.BorderSizePixel = 0
antiFallButton.LayoutOrder = 4
antiFallButton.ZIndex = 12
antiFallButton.Parent = scrollFrame

local antiFallCorner = Instance.new("UICorner")
antiFallCorner.CornerRadius = UDim.new(0, 6)
antiFallCorner.Parent = antiFallButton

local antiFallEnabled = false
local antiFallConnection = nil

local function startAntiFall()
	antiFallConnection = RunService.PreRender:Connect(function()
		local character = localPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
					humanoid:ChangeState(Enum.HumanoidStateType.Running)
					pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false) end)
				end
			end
		end
	end)
end

local function stopAntiFall()
	if antiFallConnection then antiFallConnection:Disconnect() antiFallConnection = nil end
	local character = localPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true) end) end
	end
end

antiFallButton.MouseButton1Click:Connect(function()
	antiFallEnabled = not antiFallEnabled
	if antiFallEnabled then
		antiFallButton.Text = "Anti-Fall: ON"
		antiFallButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		startAntiFall()
	else
		antiFallButton.Text = "Anti-Fall: OFF"
		antiFallButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		stopAntiFall()
	end
end)

-- ====================================================================
-- ESP (Players = Blue, Npc = Red)
-- ====================================================================
local espButton = Instance.new("TextButton")
espButton.Name = "ESPButton"
espButton.Size = UDim2.new(0.9, 0, 0, 40)
espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espButton.Text = "ESP: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.GothamBold
espButton.TextSize = 14
espButton.BorderSizePixel = 0
espButton.LayoutOrder = 5
espButton.ZIndex = 12
espButton.Parent = scrollFrame

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 6)
espCorner.Parent = espButton

local espEnabled = false
local espConnections = {}

local function isPlayerCharacter(model)
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character == model then return true end
	end
	return false
end

local function applyHighlight(model, isNpc)
	if not model or not model:IsA("Model") or model == localPlayer.Character then return end
	local oldHighlight = model:FindFirstChild("MenuESP")
	if oldHighlight then oldHighlight:Destroy() end

	local highlight = Instance.new("Highlight")
	highlight.Name = "MenuESP"
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 0
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillColor = isNpc and Color3.fromRGB(255, 0, 50) or Color3.fromRGB(0, 150, 255)
	highlight.Parent = model
end

local function checkAndHighlight(object)
	if object:IsA("Model") and object:FindFirstChildOfClass("Humanoid") then
		task.wait(0.05)
		if isPlayerCharacter(object) then applyHighlight(object, false) else applyHighlight(object, true) end
	end
end

local function startEsp()
	for _, obj in ipairs(Workspace:GetDescendants()) do checkAndHighlight(obj) end
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then applyHighlight(player.Character, false) end
		local pConn = player.CharacterAdded:Connect(function(char) applyHighlight(char, false) end)
		table.insert(espConnections, pConn)
	end
	local workspaceConn = Workspace.DescendantAdded:Connect(function(descendant) checkAndHighlight(descendant) end)
	table.insert(espConnections, workspaceConn)
end

local function stopEsp()
	for _, conn in ipairs(espConnections) do if conn then conn:Disconnect() end end
	espConnections = {}
	for _, obj in ipairs(Workspace:GetDescendants()) do
		local highlight = obj:FindFirstChild("MenuESP")
		if highlight then highlight:Destroy() end
	end
end

espButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		espButton.Text = "ESP: ON"
		espButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		startEsp()
	else
		espButton.Text = "ESP: OFF"
		espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		stopEsp()
	end
end)

-- ====================================================================
-- Przycisk "Trans Walk"
-- ====================================================================
local transWalkButton = Instance.new("TextButton")
transWalkButton.Name = "TransWalkButton"
transWalkButton.Size = UDim2.new(0.9, 0, 0, 40)
transWalkButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
transWalkButton.Text = "Trans Walk: OFF"
transWalkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
transWalkButton.Font = Enum.Font.GothamBold
transWalkButton.TextSize = 14
transWalkButton.BorderSizePixel = 0
transWalkButton.LayoutOrder = 6
transWalkButton.ZIndex = 12
transWalkButton.Parent = scrollFrame

local transWalkCorner = Instance.new("UICorner")
transWalkCorner.CornerRadius = UDim.new(0, 6)
transWalkCorner.Parent = transWalkButton

local transWalkEnabled = false
local originalCollisions = {}
local transConnections = {}

local function processPart(part)
	if part:IsA("BasePart") and not part:IsDescendantOf(localPlayer.Character) then
		local trans = part.Transparency
		if trans >= 0.1 and trans <= 0.9999 then
			if originalCollisions[part] == nil then originalCollisions[part] = part.CanCollide end
			part.CanCollide = true
		end
	end
end

local function startTransWalk()
	for _, obj in ipairs(Workspace:GetDescendants()) do processPart(obj) end
	local descConn = Workspace.DescendantAdded:Connect(processPart)
	table.insert(transConnections, descConn)
	for part, _ in pairs(originalCollisions) do
		local propConn = part:GetPropertyChangedSignal("CanCollide"):Connect(function()
			if transWalkEnabled then part.CanCollide = true end
		end)
		table.insert(transConnections, propConn)
	end
end

local function stopTransWalk()
	for _, conn in ipairs(transConnections) do if conn then conn:Disconnect() end end
	transConnections = {}
	for part, originalState in pairs(originalCollisions) do
		if part and part.Parent then pcall(function() part.CanCollide = originalState end) end
	end
	originalCollisions = {}
end

transWalkButton.MouseButton1Click:Connect(function()
	transWalkEnabled = not transWalkEnabled
	if transWalkEnabled then
		transWalkButton.Text = "Trans Walk: ON"
		transWalkButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		startTransWalk()
	else
		transWalkButton.Text = "Trans Walk: OFF"
		transWalkButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		stopTransWalk()
	end
end)
-- ====================================================================

-- 5. Przycisk Zamknięcia (X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -10, 0, 8)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.BorderSizePixel = 0
closeButton.ZIndex = 15
closeButton.Parent = mainFrame

-- 6. Przycisk Minimalizacji (+ / -)
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -45, 0, 8)
minimizeButton.AnchorPoint = Vector2.new(1, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 14
minimizeButton.BorderSizePixel = 0
minimizeButton.ZIndex = 15
minimizeButton.Parent = mainFrame

local isMinimized = false
local maximizedSize = UDim2.new(0, 340, 0, 360)
local minimizedSize = UDim2.new(0, 340, 0, 45)

minimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	local targetSize = isMinimized and minimizedSize or maximizedSize
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	scrollFrame.Visible = not isMinimized
	TweenService:Create(mainFrame, tweenInfo, {Size = targetSize}):Play()
	minimizeButton.Text = isMinimized and "+" or "-"
end)

-- Przeciąganie menu myszką
local dragging = false
local dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

titleLabel.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

closeButton.MouseButton1Click:Connect(function()
	if statsConnection then statsConnection:Disconnect() end
	stopAntiFall()
	stopEsp()
	stopTransWalk()
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local fadeTween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
	fadeTween:Play()
	fadeTween.Completed:Connect(function() screenGui:Destroy() end)
end)
