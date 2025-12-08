-- ZK HUB - Versão corrigida e estilizada (LocalScript)
-- Cole em StarterGui ou StarterPlayerScripts

pcall(function()
	if getgenv then
		if getgenv().ZK_HUB_LOADED then return end
		getgenv().ZK_HUB_LOADED = true
	end
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

-- Tema
local THEME = Color3.fromRGB(64, 224, 208)
local PANEL_BG = Color3.fromRGB(8, 14, 20)
local TEXT_COLOR = Color3.fromRGB(230, 245, 244)

-- Tamanhos
local isTouch = UserInputService.TouchEnabled
local OPEN_SIZE = isTouch and UDim2.new(0, 70, 0, 70) or UDim2.new(0, 110, 0, 110)
local PANEL_SIZE = isTouch and UDim2.new(0, 540, 0, 360) or UDim2.new(0, 1050, 0, 700)
local PANEL_MIN_SIZE = Vector2.new(400, 260)
local PANEL_MAX_SIZE = Vector2.new(1600, 1000)
local PANEL_SHOW_POS = UDim2.new(0.5, -PANEL_SIZE.X.Offset/2, 0.5, -PANEL_SIZE.Y.Offset/2)
local PANEL_HIDDEN_POS = UDim2.new(0.5, -PANEL_SIZE.X.Offset/2, -1.2, 0)
local TWEEN = TweenInfo.new(0.30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Cleanup antigo
local existing = playerGui:FindFirstChild("ZKHubGui")
if existing then existing:Destroy() end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZKHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = playerGui

-- Ícone ZK
local Icon = Instance.new("TextButton")
Icon.Name = "ZKIcon"
Icon.Size = OPEN_SIZE
Icon.Position = UDim2.new(0.03, 0, 0.38, 0)
Icon.AnchorPoint = Vector2.new(0,0)
Icon.BackgroundColor3 = PANEL_BG
Icon.BorderSizePixel = 0
Icon.AutoButtonColor = true
Icon.Text = "ZK"
Icon.Font = Enum.Font.GothamBlack
Icon.TextSize = isTouch and 22 or 36
Icon.TextScaled = false
Icon.ZIndex = 100
Icon.Parent = ScreenGui

local iconCorner = Instance.new("UICorner", Icon)
iconCorner.CornerRadius = UDim.new(0, 14)
local iconStroke = Instance.new("UIStroke", Icon)
iconStroke.Color = THEME
iconStroke.Thickness = isTouch and 3 or 4

-- Degradê no ícone
local iconGradient = Instance.new("UIGradient", Icon)
iconGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,0))
}
iconGradient.Rotation = 45

-- Arrastar ícone
do
	local dragging, dragInput, dragStart, startPos
	Icon.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Icon.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	Icon.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			Icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Painel principal
local Panel = Instance.new("Frame")
Panel.Name = "ZKPanel"
Panel.Size = PANEL_SIZE
Panel.Position = PANEL_HIDDEN_POS
Panel.AnchorPoint = Vector2.new(0,0)
Panel.BackgroundColor3 = PANEL_BG
Panel.BorderSizePixel = 0
Panel.Visible = false
Panel.ZIndex = 200
Panel.Parent = ScreenGui

local panelCorner = Instance.new("UICorner", Panel)
panelCorner.CornerRadius = UDim.new(0, 18)

local panelStroke = Instance.new("UIStroke", Panel)
panelStroke.Color = THEME
panelStroke.Thickness = isTouch and 3 or 5

local panelGradient = Instance.new("UIGradient", Panel)
panelGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(14,20,28)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8,14,20))
}
panelGradient.Rotation = 90

-- Título do painel com degradê
local Title = Instance.new("TextLabel", Panel)
Title.Name = "Title"
Title.Size = UDim2.new(1, -32, 0, 56)
Title.Position = UDim2.new(0, 16, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "ZK HUB - ROUBE UM BRAINROT"
Title.Font = Enum.Font.GothamBold
Title.TextSize = isTouch and 18 or 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = Panel.ZIndex + 2

local titleGradient = Instance.new("UIGradient", Title)
titleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,128,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,0,128)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,128,255))
}
titleGradient.Rotation = 90

-- Left categories
local leftWidth = isTouch and 180 or 260
local leftPanel = Instance.new("Frame", Panel)
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, leftWidth, 1, -92)
leftPanel.Position = UDim2.new(0, 16, 0, 72)
leftPanel.BackgroundTransparency = 1
leftPanel.ZIndex = Panel.ZIndex + 1

local leftBg = Instance.new("Frame", leftPanel)
leftBg.Size = UDim2.new(1,0,1,0)
leftBg.BackgroundColor3 = Color3.fromRGB(6,10,14)
leftBg.BorderSizePixel = 0
leftBg.ZIndex = leftPanel.ZIndex
local leftCorner = Instance.new("UICorner", leftBg)
leftCorner.CornerRadius = UDim.new(0,12)
local leftStroke = Instance.new("UIStroke", leftBg)
leftStroke.Color = Color3.fromRGB(20,28,36)
leftStroke.Thickness = 1
leftStroke.Transparency = 0.6

local leftList = Instance.new("Frame", leftBg)
leftList.Size = UDim2.new(1,-16,1,-16)
leftList.Position = UDim2.new(0,8,0,8)
leftList.BackgroundTransparency = 1
leftList.ZIndex = leftBg.ZIndex

local listLayout = Instance.new("UIListLayout", leftList)
listLayout.Padding = UDim.new(0,8)
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Right content
local contentArea = Instance.new("Frame", Panel)
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1,-leftWidth-56,1,-92)
contentArea.Position = UDim2.new(0,leftWidth+32,0,72)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = Panel.ZIndex + 1

local contentCard = Instance.new("Frame", contentArea)
contentCard.Size = UDim2.new(1,0,1,0)
contentCard.BackgroundColor3 = Color3.fromRGB(6,10,14)
contentCard.BorderSizePixel = 0
contentCard.ZIndex = contentArea.ZIndex
local contentCorner = Instance.new("UICorner", contentCard)
contentCorner.CornerRadius = UDim.new(0,12)
local contentStroke = Instance.new("UIStroke", contentCard)
contentStroke.Color = Color3.fromRGB(14,24,30)
contentStroke.Thickness = 1

-- Content header
local contentHeader = Instance.new("Frame", contentCard)
contentHeader.Size = UDim2.new(1,-24,0,44)
contentHeader.Position = UDim2.new(0,12,0,12)
contentHeader.BackgroundTransparency = 1

local contentTitle = Instance.new("TextLabel", contentHeader)
contentTitle.Size = UDim2.new(1,0,1,0)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Categoria 1"
contentTitle.Font = Enum.Font.GothamSemibold
contentTitle.TextSize = isTouch and 18 or 20
contentTitle.TextColor3 = THEME
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.ZIndex = contentCard.ZIndex + 1

local contentBody = Instance.new("TextLabel", contentCard)
contentBody.Size = UDim2.new(1,-24,1,-72)
contentBody.Position = UDim2.new(0,12,0,68)
contentBody.BackgroundTransparency = 1
contentBody.Text = "(Aqui ficarão as opções da categoria.)"
contentBody.Font = Enum.Font.Gotham
contentBody.TextSize = 16
contentBody.TextColor3 = TEXT_COLOR
contentBody.TextXAlignment = Enum.TextXAlignment.Left
contentBody.TextYAlignment = Enum.TextYAlignment.Top
contentBody.TextWrapped = true
contentBody.ZIndex = contentCard.ZIndex + 1

-- Categories
local categories = {}
for i=1,7 do categories[i] = "Categoria "..i end
local categoryButtons = {}
local selectedCategory = categories[1]

local function clearCategoryStyles()
	for _, b in ipairs(categoryButtons) do
		b.BackgroundTransparency = 1
		b.TextColor3 = Color3.fromRGB(180,200,210)
	end
end

for i,name in ipairs(categories) do
	local btn = Instance.new("TextButton")
	btn.Name = "Cat_"..i
	btn.Size = UDim2.new(1,-12,0,isTouch and 44 or 48)
	btn.Position = UDim2.new(0,8,0,0)
	btn.BackgroundTransparency = 1
	btn.Text = name
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = isTouch and 16 or 18
	btn.TextColor3 = Color3.fromRGB(180,200,210)
	btn.AutoButtonColor = true
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.LayoutOrder = i
	btn.Parent = leftList
	btn.ZIndex = leftList.ZIndex
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0,8)

	btn.MouseButton1Click:Connect(function()
		clearCategoryStyles()
		btn.BackgroundTransparency = 0
		btn.BackgroundColor3 = THEME
		btn.TextColor3 = Color3.fromRGB(8,12,14)
		selectedCategory = name
		contentTitle.Text = name
		contentBody.Text = "Categoria selecionada: "..name.."\n\n(Aqui vão as opções — ESP apenas Categoria 1.)"
		espControls.Visible = (name == "Categoria 1")
	end)
	table.insert(categoryButtons,btn)
end

if categoryButtons[1] then
	categoryButtons[1].BackgroundTransparency = 0
	categoryButtons[1].BackgroundColor3 = THEME
	categoryButtons[1].TextColor3 = Color3.fromRGB(8,12,14)
end

-- ---------- ESP ----------
local espEnabled = false
local highlights = {}

local function createHighlightForPlayer(pl)
	if not pl or pl == player then return end
	if highlights[pl] then pcall(function() highlights[pl]:Destroy() end) end
	local char = pl.Character
	if not char or not char.Parent then return end
	local ok,h = pcall(function()
		local highlight = Instance.new("Highlight")
		highlight.Name = "ZK_ESP"
		highlight.Parent = char
		highlight.FillColor = THEME
		highlight.FillTransparency = 0.1
		highlight.OutlineColor = Color3.fromRGB(255,255,255)
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		return highlight
	end)
	if ok and h then highlights[pl] = h end
end

local function removeHighlightForPlayer(pl)
	if highlights[pl] then pcall(function() highlights[pl]:Destroy() end) highlights[pl] = nil end
end

local function enableESP()
	if espEnabled then return end
	espEnabled = true
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl ~= player then
			if pl.Character and pl.Character.Parent then createHighlightForPlayer(pl) end
			pl.CharacterAdded:Connect(function() task.wait(0.05) if espEnabled then createHighlightForPlayer(pl) end end)
		end
	end
	Players.PlayerAdded:Connect(function(pl)
		if pl ~= player then
			pl.CharacterAdded:Connect(function() task.wait(0.05) if espEnabled then createHighlightForPlayer(pl) end end)
		end
	end)
end

local function disableESP()
	if not espEnabled then return end
	espEnabled = false
	for pl,h in pairs(highlights) do pcall(function() h:Destroy() end) end
	highlights = {}
end

for _,pl in ipairs(Players:GetPlayers()) do
	pl.CharacterAdded:Connect(function() task.wait(0.05) if espEnabled and pl ~= player then createHighlightForPlayer(pl) end end)
end
Players.PlayerRemoving:Connect(removeHighlightForPlayer)

-- ---------- ESP Controls ----------
local espControls = Instance.new("Frame", contentCard)
espControls.Name = "ESPControls"
espControls.Size = UDim2.new(1,-24,0,80)
espControls.Position = UDim2.new(0,12,0,12)
espControls.BackgroundTransparency = 1
espControls.ZIndex = contentCard.ZIndex + 1
espControls.Visible = true

local espLabel = Instance.new("TextLabel", espControls)
espLabel.Size = UDim2.new(0.5,0,1,0)
espLabel.Position = UDim2.new(0,0,0,0)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP PLAYER"
espLabel.Font = Enum.Font.GothamBold
espLabel.TextSize = 18
espLabel.TextColor3 = TEXT_COLOR
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.ZIndex = espControls.ZIndex + 1

local espToggle = Instance.new("TextButton", espControls)
espToggle.Size = UDim2.new(0,140,0,42)
espToggle.Position = UDim2.new(1,-144,0.5,-21)
espToggle.BackgroundColor3 = Color3.fromRGB(20,28,34)
espToggle.BorderSizePixel = 0
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 16
espToggle.TextColor3 = Color3.fromRGB(200,220,215)
espToggle.Text = "OFF"
espToggle.ZIndex = espControls.ZIndex + 1
local espCorner = Instance.new("UICorner", espToggle)
espCorner.CornerRadius = UDim.new(0,10)
local espStroke = Instance.new("UIStroke", espToggle)
espStroke.Color = Color3.fromRGB(40,50,60)

espToggle.MouseButton1Click:Connect(function()
	if not espEnabled then
		enableESP()
		espToggle.Text = "ON"
		espToggle.BackgroundColor3 = THEME
		espToggle.TextColor3 = Color3.fromRGB(8,12,14)
	else
		disableESP()
		espToggle.Text = "OFF"
		espToggle.BackgroundColor3 = Color3.fromRGB(20,28,34)
		espToggle.TextColor3 = Color3.fromRGB(200,220,215)
	end
end)

-- ---------- Resize grip ----------
local resizeGrip = Instance.new("Frame", Panel)
resizeGrip.Size = UDim2.new(0,28,0,28)
resizeGrip.Position = UDim2.new(1,-34,1,-34)
resizeGrip.AnchorPoint = Vector2.new(0,0)
resizeGrip.BackgroundColor3 = Color3.fromRGB(20,28,34)
resizeGrip.BorderSizePixel = 0
resizeGrip.ZIndex = Panel.ZIndex + 2
local resizeCorner = Instance.new("UICorner", resizeGrip)
resizeCorner.CornerRadius = UDim.new(0,8)
local gripIcon = Instance.new("TextLabel", resizeGrip)
gripIcon.Size = UDim2.new(1,0,1,0)
gripIcon.BackgroundTransparency = 1
gripIcon.Text = "◢"
gripIcon.Font = Enum.Font.GothamSemibold
gripIcon.TextColor3 = Color3.fromRGB(140,170,165)
gripIcon.TextScaled = true
gripIcon.ZIndex = resizeGrip.ZIndex + 1

local resizing = false
local startPos, startSize
resizeGrip.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = true
		startPos = input.Position
		startSize = Vector2.new(Panel.Size.X.Offset, Panel.Size.Y.Offset)
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				resizing = false
			end
		end)
	end
end)
resizeGrip.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		RunService.RenderStepped:Connect(function()
			if resizing then
				local delta = input.Position - startPos
				local newX = math.clamp(startSize.X + delta.X, PANEL_MIN_SIZE.X, PANEL_MAX_SIZE.X)
				local newY = math.clamp(startSize.Y + delta.Y, PANEL_MIN_SIZE.Y, PANEL_MAX_SIZE.Y)
				Panel.Size = UDim2.new(0,newX,0,newY)
				PANEL_SHOW_POS = UDim2.new(0.5,-newX/2,0.5,-newY/2)
			end
		end)
	end
end)

-- ---------- Abrir/Fechar ----------
local panelOpen = false
local function togglePanel()
	panelOpen = not panelOpen
	if panelOpen then
		Panel.Visible = true
		TweenService:Create(Panel, TWEEN, {Position=PANEL_SHOW_POS}):Play()
	else
		TweenService:Create(Panel, TWEEN, {Position=PANEL_HIDDEN_POS}):Play()
	end
end

Icon.MouseButton1Click:Connect(togglePanel)
UserInputService.InputBegan:Connect(function(input,gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.LeftControl then
		togglePanel()
	end
end)
