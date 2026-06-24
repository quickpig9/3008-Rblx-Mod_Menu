local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 1. Main Container (Cleaning old GUI)
local oldGui = playerGui:FindFirstChild("Mod Menu")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mod Menu"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 9999999
screenGui.Parent = playerGui

-- 2. Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 380)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = mainFrame

-- TopBar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
topBar.BorderSizePixel = 0
topBar.ZIndex = 11
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 10)
topBarCorner.Parent = topBar

local topBarLine = Instance.new("Frame")
topBarLine.Size = UDim2.new(1, 0, 0, 5)
topBarLine.Position = UDim2.new(0, 0, 1, -5)
topBarLine.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
topBarLine.BorderSizePixel = 0
topBarLine.ZIndex = 11
topBarLine.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "3008 Mod Menu v1.5.1"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 12
titleLabel.Parent = topBar

-- Tabs Panel (Left Side)
local tabsPanel = Instance.new("Frame")
tabsPanel.Name = "TabsPanel"
tabsPanel.Size = UDim2.new(0, 120, 1, -40)
tabsPanel.Position = UDim2.new(0, 0, 0, 40)
tabsPanel.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
tabsPanel.BorderSizePixel = 0
tabsPanel.ZIndex = 11
tabsPanel.Parent = mainFrame

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Padding = UDim.new(0, 4)
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabsLayout.Parent = tabsPanel

local tabsPadding = Instance.new("UIPadding")
tabsPadding.PaddingTop = UDim.new(0, 10)
tabsPadding.Parent = tabsPanel

-- Pages Container (Right Side)
local pagesContainer = Instance.new("Frame")
pagesContainer.Name = "PagesContainer"
pagesContainer.Size = UDim2.new(1, -130, 1, -50)
pagesContainer.Position = UDim2.new(0, 125, 0, 45)
pagesContainer.BackgroundTransparency = 1
pagesContainer.ZIndex = 11
pagesContainer.Parent = mainFrame

local activeTabColor = Color3.fromRGB(0, 150, 255)
local inactiveTabColor = Color3.fromRGB(45, 45, 50)

local tabs = {}
local pages = {}

local function createTab(name, layoutOrder)
	local tabButton = Instance.new("TextButton")
	tabButton.Name = name .. "Tab"
	tabButton.Size = UDim2.new(0.9, 0, 0, 32)
	tabButton.BackgroundColor3 = inactiveTabColor
	tabButton.Text = name
	tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
	tabButton.Font = Enum.Font.GothamBold
	tabButton.TextSize = 13
	tabButton.BorderSizePixel = 0
	tabButton.LayoutOrder = layoutOrder
	tabButton.ZIndex = 12
	tabButton.Parent = tabsPanel

	local tCorner = Instance.new("UICorner")
	tCorner.CornerRadius = UDim.new(0, 6)
	tCorner.Parent = tabButton

	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = name .. "Page"
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.Visible = false
	scrollFrame.ScrollBarThickness = 4
	scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollFrame.ZIndex = 12
	scrollFrame.Parent = pagesContainer

	local pLayout = Instance.new("UIListLayout")
	pLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pLayout.Padding = UDim.new(0, 8)
	pLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	pLayout.Parent = scrollFrame

	tabButton.MouseButton1Click:Connect(function()
		for _, t in pairs(tabs) do
			t.BackgroundColor3 = inactiveTabColor
			t.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
		for _, p in pairs(pages) do p.Visible = false end
		
		tabButton.BackgroundColor3 = activeTabColor
		tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		scrollFrame.Visible = true
	end)

	tabs[name] = tabButton
	pages[name] = scrollFrame
	return scrollFrame
end

-- GENERATING TABS
local pageMain = createTab("Main", 1)
local pageVisuals = createTab("Visuals", 2)
local pageOther = createTab("Other", 3)
local pageWhatsNew = createTab("What's new", 4)

-- Enable Default Tab
tabs["Main"].BackgroundColor3 = activeTabColor
tabs["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)
pages["Main"].Visible = true

-- Helper function to create buttons
local function createMenuButton(name, text, layoutOrder, parentPage, callback)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0.95, 0, 0, 36)
	button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 13
	button.BorderSizePixel = 0
	button.LayoutOrder = layoutOrder
	button.ZIndex = 13
	button.Parent = parentPage

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 6)
	bCorner.Parent = button

	button.MouseButton1Click:Connect(function() callback(button) end)
	return button
end

-- Safely finding the game clock
local function findCorrectTextBox()
	local found = nil
	pcall(function()
		for _, obj in ipairs(playerGui:GetDescendants()) do
			if obj.Name == "TimeLeft" then
				local inputFrame = obj:FindFirstChild("Input")
				if inputFrame then
					local textBox = inputFrame:FindFirstChild("TextBox")
					if textBox and textBox:IsA("TextBox") then found = textBox break end
				end
			end
		end
	end)
	return found
end

-- ====================================================================
-- TAB CODE: WHAT'S NEW
-- ====================================================================
local function addLogLabel(text, font, size, color, order)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.95, 0, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = color
	lbl.TextSize = size
	lbl.Font = font
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.LayoutOrder = order
	lbl.ZIndex = 13
	lbl.Parent = pageWhatsNew
end

-- Version 1.1.0 Features
addLogLabel(" VERSION 1.1.0 (Features)", Enum.Font.GothamBold, 14, Color3.fromRGB(0, 150, 255), 1)
addLogLabel("• Added feature: Speed & Jump Power Sliders", Enum.Font.GothamSemibold, 12, Color3.fromRGB(230, 230, 230), 2)
addLogLabel("• Added feature: FullBright (Headlight)", Enum.Font.GothamSemibold, 12, Color3.fromRGB(230, 230, 230), 3)
addLogLabel("• Added feature: Infinite Admin (Yield)", Enum.Font.GothamSemibold, 12, Color3.fromRGB(230, 230, 230), 4)
addLogLabel("• Added feature: Trans Walk (Pass through transparent objects)", Enum.Font.GothamSemibold, 12, Color3.fromRGB(230, 230, 230), 5)
addLogLabel("• Added feature: ESP (Highlight Players/NPCs)", Enum.Font.GothamSemibold, 12, Color3.fromRGB(230, 230, 230), 6)
addLogLabel("• Added system: CloseButton (X) & MinimizeButton (-)", Enum.Font.GothamSemibold, 12, Color3.fromRGB(230, 230, 230), 7)

-- Spacing
addLogLabel("", Enum.Font.Gotham, 10, Color3.fromRGB(255,255,255), 8)

-- Patches and fixes
addLogLabel(" LATEST FIXES (v1.5.1)", Enum.Font.GothamBold, 13, Color3.fromRGB(50, 180, 50), 9)
addLogLabel("• Fixed Slider Bug:", Enum.Font.GothamBold, 11, Color3.fromRGB(255, 215, 0), 10)
addLogLabel("  Fixed incorrect parent assignment that broke Speed and Jump Sliders.", Enum.Font.Gotham, 11, Color3.fromRGB(200, 200, 200), 11)
addLogLabel("• Rebuilt Anti-Fall system:", Enum.Font.GothamBold, 11, Color3.fromRGB(255, 215, 0), 12)
addLogLabel("  The script automatically disables freefall state and returns", Enum.Font.Gotham, 11, Color3.fromRGB(200, 200, 200), 13)
addLogLabel("  to full normalcy as soon as you touch a part/ground!", Enum.Font.Gotham, 11, Color3.fromRGB(200, 200, 200), 14)


-- ====================================================================
-- TAB CODE: MAIN
-- ====================================================================
local versionTextLabel = Instance.new("TextLabel")
versionTextLabel.Size = UDim2.new(0.95, 0, 0, 18)
versionTextLabel.BackgroundTransparency = 1
versionTextLabel.Text = "Status: Script Active"
versionTextLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
versionTextLabel.TextSize = 11
versionTextLabel.Font = Enum.Font.GothamSemibold
versionTextLabel.TextXAlignment = Enum.TextXAlignment.Left
versionTextLabel.LayoutOrder = 1
versionTextLabel.ZIndex = 13
versionTextLabel.Parent = pageMain

local cycleTextLabel = Instance.new("TextLabel")
cycleTextLabel.Size = UDim2.new(0.95, 0, 0, 25)
cycleTextLabel.BackgroundTransparency = 1
cycleTextLabel.Text = "Cycles End: Searching..."
cycleTextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
cycleTextLabel.TextSize = 13
cycleTextLabel.Font = Enum.Font.GothamBold
cycleTextLabel.TextXAlignment = Enum.TextXAlignment.Left
cycleTextLabel.LayoutOrder = 2
cycleTextLabel.ZIndex = 13
cycleTextLabel.Parent = pageMain

-- Fake Watch
local watchEnabled = false
local watchConnection = nil
local function formatSecondsToTime(textSeconds)
	local totalSeconds = tonumber(textSeconds)
	if not totalSeconds then return textSeconds end
	return string.format("%d:%02d", math.floor(totalSeconds / 60), totalSeconds % 60)
end

createMenuButton("WatchBtn", "Fake Watch: OFF", 3, pageMain, function(btn)
	watchEnabled = not watchEnabled
	local gamepassClock = nil
	pcall(function() gamepassClock = playerGui.MainGui.TopBar.Calendar.Gamepass_Clock end)

	if watchEnabled then
		btn.Text = "Fake Watch: ON" btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		if gamepassClock then
			gamepassClock.Visible = true
			local targetTextBox = findCorrectTextBox()
			if targetTextBox then
				local function updateClockText() if watchEnabled then gamepassClock.Text = formatSecondsToTime(targetTextBox.Text) end end
				updateClockText()
				watchConnection = targetTextBox:GetPropertyChangedSignal("Text"):Connect(updateClockText)
			end
		end
	else
		btn.Text = "Fake Watch: OFF" btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		if watchConnection then watchConnection:Disconnect() watchConnection = nil end
		if gamepassClock then gamepassClock.Visible = false end
	end
end)

-- Fake Nickname Panel
local nickContainer = Instance.new("Frame")
nickContainer.Size = UDim2.new(0.95, 0, 0, 36)
nickContainer.BackgroundTransparency = 1
nickContainer.LayoutOrder = 4
nickContainer.ZIndex = 13
nickContainer.Parent = pageMain

local nickTextBox = Instance.new("TextBox")
nickTextBox.Size = UDim2.new(0.6, -4, 1, 0)
nickTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
nickTextBox.Text = "New Nickname"
nickTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nickTextBox.Font = Enum.Font.GothamBold
nickTextBox.TextSize = 12
nickTextBox.BorderSizePixel = 0
nickTextBox.ZIndex = 14
nickTextBox.Parent = nickContainer
Instance.new("UICorner", nickTextBox).CornerRadius = UDim.new(0, 6)

local nickBtn = Instance.new("TextButton")
nickBtn.Size = UDim2.new(0.4, -4, 1, 0)
nickBtn.Position = UDim2.new(0.6, 4, 0, 0)
nickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
nickBtn.Text = "Nick: OFF"
nickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nickBtn.Font = Enum.Font.GothamBold
nickBtn.TextSize = 12
nickBtn.BorderSizePixel = 0
nickBtn.ZIndex = 14
nickBtn.Parent = nickContainer
Instance.new("UICorner", nickBtn).CornerRadius = UDim.new(0, 6)

local nickEnabled = false
local nickConnection = nil
local originalNickText = ""

local function getUsernameLabel()
	local lbl = nil
	pcall(function() lbl = playerGui.TopBar.Fake_TopBar.username end)
	return lbl
end

nickBtn.MouseButton1Click:Connect(function()
	nickEnabled = not nickEnabled
	local userLabel = getUsernameLabel()
	if nickEnabled then
		nickBtn.Text = "Nick: ON" nickBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		if userLabel then
			if originalNickText == "" then originalNickText = userLabel.Text end
			userLabel.Text = nickTextBox.Text
			nickConnection = RunService.Heartbeat:Connect(function()
				local currentLabel = getUsernameLabel()
				if currentLabel and currentLabel.Text ~= nickTextBox.Text then currentLabel.Text = nickTextBox.Text end
			end)
		end
	else
		nickBtn.Text = "Nick: OFF" nickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		if nickConnection then nickConnection:Disconnect() nickConnection = nil end
		if userLabel and originalNickText ~= "" then userLabel.Text = originalNickText end
	end
end)

-- Cycle System Loop
task.spawn(function()
	task.wait(0.5)
	local targetTextBox = findCorrectTextBox()
	if targetTextBox then
		local function refreshText() cycleTextLabel.Text = "Cycles End: " .. targetTextBox.Text end
		refreshText() targetTextBox:GetPropertyChangedSignal("Text"):Connect(refreshText)
	else
		cycleTextLabel.Text = "Cycles End: Read Error"
	end
end)

-- Sliders (Speed / Jump Power)
local customSpeed = 16
local customJumpPower = 40

local statsConnection = RunService.Heartbeat:Connect(function()
	local character = localPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			if humanoid.WalkSpeed ~= customSpeed then humanoid.WalkSpeed = customSpeed end
			if humanoid.JumpPower ~= customJumpPower then
				humanoid.UseJumpPower = true humanoid.JumpPower = customJumpPower
			end
		end
	end
end)

local function createSlider(name, min, max, default, layoutOrder, parentPage, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(0.95, 0, 0, 45)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	sliderFrame.BorderSizePixel = 0
	sliderFrame.LayoutOrder = layoutOrder
	sliderFrame.ZIndex = 13
	sliderFrame.Parent = parentPage
	Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 5)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 18)
	label.Position = UDim2.new(0, 10, 0, 4)
	label.BackgroundTransparency = 1
	label.Text = name .. ": " .. tostring(default)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 14
	label.Parent = sliderFrame

	local barBackground = Instance.new("Frame")
	barBackground.Size = UDim2.new(1, -20, 0, 6)
	barBackground.Position = UDim2.new(0, 10, 0, 28)
	barBackground.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	barBackground.BorderSizePixel = 0
	barBackground.ZIndex = 14
	barBackground.Parent = sliderFrame -- NAPRAWIONE: Przypisanie prawidłowego rodzica
	Instance.new("UICorner", barBackground).CornerRadius = UDim.new(0, 3)

	local barFill = Instance.new("Frame")
	barFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	barFill.BackgroundColor3 = activeTabColor
	barFill.BorderSizePixel = 0
	barFill.ZIndex = 15
	barFill.Parent = barBackground
	Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 3)

	local sliderButton = Instance.new("TextButton")
	sliderButton.Size = UDim2.new(1, 0, 1, 0)
	sliderButton.BackgroundTransparency = 1
	sliderButton.Text = ""
	sliderButton.ZIndex = 16
	sliderButton.Parent = barBackground

	local isSliding = false
	local function updateSlider(input)
		local percentage = math.clamp((input.Position.X - barBackground.AbsolutePosition.X) / barBackground.AbsoluteSize.X, 0, 1)
		barFill.Size = UDim2.new(percentage, 0, 1, 0)
		local finalValue = math.round(min + (percentage * (max - min)))
		label.Text = name .. ": " .. tostring(finalValue)
		callback(finalValue)
	end

	sliderButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isSliding = true updateSlider(input) end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isSliding = false end
	end)
end

createSlider("Speed", 16, 120, 16, 5, pageMain, function(v) customSpeed = v end)
createSlider("Jump Power", 40, 150, 40, 6, pageMain, function(v) customJumpPower = v end)


-- ====================================================================
-- TAB CODE: VISUALS
-- ====================================================================
local espEnabled = false
local espConnections = {}
local function applyHighlight(model, isNpc)
	if not model or not model:IsA("Model") or model == localPlayer.Character then return end
	local old = model:FindFirstChild("MenuESP") if old then old:Destroy() end
	local highlight = Instance.new("Highlight")
	highlight.Name = "MenuESP"
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillColor = isNpc and Color3.fromRGB(255, 0, 50) or Color3.fromRGB(0, 150, 255)
	highlight.Parent = model
end
local function checkAndHighlight(object)
	if object:IsA("Model") and object:FindFirstChildOfClass("Humanoid") then
		task.wait(0.05)
		if Players:GetPlayerFromCharacter(object) then applyHighlight(object, false) else applyHighlight(object, true) end
	end
end

createMenuButton("ESPBtn", "ESP: OFF", 1, pageVisuals, function(btn)
	espEnabled = not espEnabled
	if espEnabled then
		btn.Text = "ESP: ON" btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		for _, obj in ipairs(Workspace:GetDescendants()) do checkAndHighlight(obj) end
		table.insert(espConnections, Workspace.DescendantAdded:Connect(checkAndHighlight))
	else
		btn.Text = "ESP: OFF" btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		for _, c in ipairs(espConnections) do c:Disconnect() end espConnections = {}
		for _, obj in ipairs(Workspace:GetDescendants()) do local h = obj:FindFirstChild("MenuESP") if h then h:Destroy() end end
	end
end)

-- FullBright
local fbEnabled = false
local headlightConnection = nil
local function removeHeadlight()
	pcall(function() local h = localPlayer.Character.Head:FindFirstChild("HeadlightFB") if h then h:Destroy() end end)
end
local function addHeadlight()
	pcall(function()
		local head = localPlayer.Character.Head
		removeHeadlight()
		local light = Instance.new("PointLight")
		light.Name = "HeadlightFB"
		light.Brightness = 10 light.Range = 250 light.Shadows = false
		light.Parent = head
	end)
end

createMenuButton("FullBrightBtn", "FullBright: OFF", 2, pageVisuals, function(btn)
	fbEnabled = not fbEnabled
	if fbEnabled then
		btn.Text = "FullBright: ON" btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		addHeadlight()
		headlightConnection = localPlayer.CharacterAdded:Connect(function() task.wait(0.5) if fbEnabled then addHeadlight() end end)
	else
		btn.Text = "FullBright: OFF" btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		if headlightConnection then headlightConnection:Disconnect() headlightConnection = nil end
		removeHeadlight()
	end
end)


-- ====================================================================
-- TAB CODE: OTHER
-- ====================================================================
createMenuButton("AdminBtn", "Infinite Admin", 1, pageOther, function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end).BackgroundColor3 = Color3.fromRGB(65, 65, 70)

local transWalkEnabled = false
local originalCollisions = {}
local transConnections = {}
local function processPart(part)
	if part:IsA("BasePart") and not part:IsDescendantOf(localPlayer.Character) then
		pcall(function()
			if part.Transparency >= 0.1 and part.Transparency <= 0.9999 then
				if originalCollisions[part] == nil then originalCollisions[part] = part.CanCollide end
				part.CanCollide = true
			end
		end)
	end
end

createMenuButton("TransWalkBtn", "Trans Walk: OFF", 2, pageOther, function(btn)
	transWalkEnabled = not transWalkEnabled
	if transWalkEnabled then
		btn.Text = "Trans Walk: ON" btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		for _, obj in ipairs(Workspace:GetDescendants()) do processPart(obj) end
		table.insert(transConnections, Workspace.DescendantAdded:Connect(processPart))
	else
		btn.Text = "Trans Walk: OFF" btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		for _, conn in ipairs(transConnections) do conn:Disconnect() end transConnections = {}
		for part, originalState in pairs(originalCollisions) do pcall(function() part.CanCollide = originalState end) end
		originalCollisions = {}
	end
end)

-- Anti-Fall
local antiFallEnabled = false
local antiFallConnection = nil
local isHoldingAntiFall = false

createMenuButton("AntiFallBtn", "Anti-Fall: OFF", 3, pageOther, function(btn)
	antiFallEnabled = not antiFallEnabled
	if antiFallEnabled then
		btn.Text = "Anti-Fall: ON" btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		
		antiFallConnection = RunService.PreRender:Connect(function()
			pcall(function()
				local character = localPlayer.Character
				local hum = character and character:FindFirstChildOfClass("Humanoid")
				if not hum then return end
				
				if hum:GetState() == Enum.HumanoidStateType.Freefall then
					isHoldingAntiFall = true
					hum:ChangeState(Enum.HumanoidStateType.Running)
					hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
				end
				
				if isHoldingAntiFall and hum.FloorMaterial ~= Enum.Material.Air then
					isHoldingAntiFall = false
					hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
				end
			end)
		end)
	else
		btn.Text = "Anti-Fall: OFF" btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		if antiFallConnection then antiFallConnection:Disconnect() antiFallConnection = nil end
		isHoldingAntiFall = false
		pcall(function() localPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall, true) end)
	end
end)


-- ====================================================================
-- FUNCTIONAL UI (Close / Minimize / Drag)
-- ====================================================================
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 26, 0, 26)
closeButton.Position = UDim2.new(1, -10, 0, 7)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 12
closeButton.BorderSizePixel = 0
closeButton.ZIndex = 15
closeButton.Parent = topBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 26, 0, 26)
minimizeButton.Position = UDim2.new(1, -41, 0, 7)
minimizeButton.AnchorPoint = Vector2.new(1, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 12
minimizeButton.BorderSizePixel = 0
minimizeButton.ZIndex = 15
minimizeButton.Parent = topBar
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 6)

local isMinimized = false
local maximizedSize = UDim2.new(0, 450, 0, 380)
local minimizedSize = UDim2.new(0, 450, 0, 40)

minimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	tabsPanel.Visible = not isMinimized
	pagesContainer.Visible = not isMinimized
	TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = isMinimized and minimizedSize or maximizedSize}):Play()
	minimizeButton.Text = isMinimized and "+" or "-"
end)

local dragging, dragInput, dragStart, startPos
titleLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true dragStart = input.Position startPos = mainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
titleLabel.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

closeButton.MouseButton1Click:Connect(function()
	if statsConnection then statsConnection:Disconnect() end
	if headlightConnection then headlightConnection:Disconnect() end
	if antiFallConnection then antiFallConnection:Disconnect() end
	if watchConnection then watchConnection:Disconnect() end
	if nickConnection then nickConnection:Disconnect() end
	for _, c in ipairs(espConnections) do c:Disconnect() end
	for _, conn in ipairs(transConnections) do conn:Disconnect() end
	
	removeHeadlight()
	pcall(function() playerGui.MainGui.TopBar.Calendar.Gamepass_Clock.Visible = false end)
	pcall(function() if originalNickText ~= "" then playerGui.TopBar.Fake_TopBar.username.Text = originalNickText end end)
	
	for _, obj in ipairs(Workspace:GetDescendants()) do local h = obj:FindFirstChild("MenuESP") if h then h:Destroy() end end
	for part, originalState in pairs(originalCollisions) do pcall(function() part.CanCollide = originalState end) end

	local t = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1})
	t:Play() t.Completed:Connect(function() screenGui:Destroy() end)
end)
