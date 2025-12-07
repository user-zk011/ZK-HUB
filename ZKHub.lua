-- ZK HUB - Versão com categorias (LocalScript)
-- Cole em StarterGui ou StarterPlayerScripts no Roblox Studio.
-- IMPORTANTE: Para garantir que a logo apareça em runtime, faça upload no Asset Manager
-- e substitua IMAGE_RBX_ASSET por "rbxassetid://<ID>".

-- Anti-duplicação
pcall(function()
	if getgenv then
		if getgenv().ZK_LOADED then return end
		getgenv().ZK_LOADED = true
	end
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

-- Detecta se é dispositivo com touch; se não for, usa layout maior (PC)
local isTouch = UserInputService.TouchEnabled

-- Configs de tamanho (maior no PC)
local OPEN_BTN_SIZE = isTouch and UDim2.new(0, 64, 0, 64) or UDim2.new(0, 80, 0, 80)
local MAIN_SIZE = isTouch and UDim2.new(0, 480, 0, 320) or UDim2.new(0, 860, 0, 560)
local MAIN_SHOW_POS = UDim2.new(0.5, -MAIN_SIZE.X.Offset/2, 0.5, -MAIN_SIZE.Y.Offset/2)
local MAIN_HIDDEN_POS = UDim2.new(0.5, -MAIN_SIZE.X.Offset/2, -1.2, 0)
local TWEEN_INFO = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Tema aqua/verde-água
local THEME = Color3.fromRGB(64, 224, 208)
local BORDER_LIGHT = Color3.fromRGB(175, 255, 250)
local TITLE_COLOR = Color3.fromRGB(230, 255, 252)
local PANEL_BG = Color3.fromRGB(8, 14, 20)

-- Substitua por "rbxassetid://<ID>" depois de subir a imagem ao Asset Manager.
local IMAGE_RBX_ASSET = "rbxassetid://0" -- troque aqui
local IMAGE_URL_FALLBACK = "https://cdn.ereemby.com/attachments/17631336254632667imagem.png"

-- Limpeza (útil para testes repetidos no Studio)
local existing = playerGui:FindFirstChild("ZKHubGui")
if existing then existing:Destroy() end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZKHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui
ScreenGui.IgnoreGuiInset = true

-- ---------- Open Button ----------
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = OPEN_BTN_SIZE
OpenButton.Position = UDim2.new(0.03, 0, 0.38, 0)
OpenButton.AnchorPoint = Vector2.new(0, 0)
OpenButton.BackgroundColor3 = THEME
OpenButton.BorderSizePixel = 0
OpenButton.AutoButtonColor = true
OpenButton.Image = ""
OpenButton.ZIndex = 50
OpenButton.Parent = ScreenGui

local openCorner = Instance.new("UICorner", OpenButton)
openCorner.CornerRadius = UDim.new(1, 0)

local openStroke = Instance.new("UIStroke", OpenButton)
openStroke.Color = BORDER_LIGHT
openStroke.Thickness = 3

local openShadow = Instance.new("Frame", OpenButton)
openShadow.Name = "OpenShadow"
openShadow.Size = UDim2.new(1, 10, 1, 10)
openShadow.Position = UDim2.new(0, -5, 0, -5)
openShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
openShadow.BackgroundTransparency = 0.82
openShadow.BorderSizePixel = 0
openShadow.ZIndex = OpenButton.ZIndex - 1
local openShadowCorner = Instance.new("UICorner", openShadow)
openShadowCorner.CornerRadius = UDim.new(1,0)

local logo = Instance.new("ImageLabel", OpenButton)
logo.Name = "Logo"
logo.Size = UDim2.new(0, math.min(OPEN_BTN_SIZE.X.Offset-12, 64), 0, math.min(OPEN_BTN_SIZE.Y.Offset-12, 64))
logo.Position = UDim2.new(0.5, 0, 0.5, 0)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.BackgroundTransparency = 1
logo.Image = IMAGE_RBX_ASSET ~= "rbxassetid://0" and IMAGE_RBX_ASSET or IMAGE_URL_FALLBACK
logo.ScaleType = Enum.ScaleType.Fit
logo.ZIndex = OpenButton.ZIndex + 1

local logoCorner = Instance.new("UICorner", logo)
logoCorner.CornerRadius = UDim.new(1, 0)

local logoFallback = Instance.new("TextLabel", OpenButton)
logoFallback.Name = "LogoFallback"
logoFallback.Size = logo.Size
logoFallback.Position = logo.Position
logoFallback.AnchorPoint = logo.AnchorPoint
logoFallback.BackgroundColor3 = Color3.fromRGB(10,120,110)
logoFallback.BackgroundTransparency = 0
logoFallback.Font = Enum.Font.GothamBold
logoFallback.Text = "ZK"
logoFallback.TextColor3 = Color3.fromRGB(220,255,250)
logoFallback.TextScaled = true
logoFallback.Visible = false
local logoFallbackCorner = Instance.new("UICorner", logoFallback)
logoFallbackCorner.CornerRadius = UDim.new(1,0)

-- ---------- Main Panel (com sombra e borda) ----------
local MainShadow = Instance.new("Frame", ScreenGui)
MainShadow.Name = "MainShadow"
MainShadow.Size = MAIN_SIZE + UDim2.new(0, 16, 0, 16)
MainShadow.Position = UDim2.new(MAIN_SHOW_POS.X.Scale, MAIN_SHOW_POS.X.Offset - 8, MAIN_SHOW_POS.Y.Scale, MAIN_SHOW_POS.Y.Offset - 8)
MainShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainShadow.BackgroundTransparency = 0.8
MainShadow.BorderSizePixel = 0
MainShadow.Visible = false
local MainShadowCorner = Instance.new("UICorner", MainShadow)
MainShadowCorner.CornerRadius = UDim.new(0, 20)

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = MAIN_SIZE
Main.Position = MAIN_HIDDEN_POS
Main.AnchorPoint = Vector2.new(0,0)
Main.BackgroundColor3 = PANEL_BG
Main.BorderSizePixel = 0
Main.Visible = false
Main.ZIndex = 40

local UICornerMain = Instance.new("UICorner", Main)
UICornerMain.CornerRadius = UDim.new(0, 20)

local border = Instance.new("UIStroke", Main)
border.Color = THEME
border.Thickness = isTouch and 3 or 5

local uiGradient = Instance.new("UIGradient", Main)
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(14,20,28)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8,14,20))
}
uiGradient.Rotation = 90

-- Top title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -32, 0, 56)
Title.Position = UDim2.new(0, 16, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "ZK HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = isTouch and 20 or 26
Title.TextColor3 = TITLE_COLOR
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local Close = Instance.new("TextButton", Main)
Close.Name = "Close"
Close.Size = UDim2.new(0, 48, 0, 48)
Close.Position = UDim2.new(1, -72, 0, 16)
Close.BackgroundColor3 = THEME
Close.AutoButtonColor = true
Close.BorderSizePixel = 0
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextScaled = true
Close.TextColor3 = Color3.fromRGB(8, 12, 14)
local CloseCorner = Instance.new("UICorner", Close)
CloseCorner.CornerRadius = UDim.new(1,0)
local CloseStroke = Instance.new("UIStroke", Close)
CloseStroke.Color = BORDER_LIGHT
CloseStroke.Thickness = 2

-- Content layout: left categories + right content area
local leftWidth = isTouch and 160 or 200
local leftPanel = Instance.new("Frame", Main)
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, leftWidth, 1, -96)
leftPanel.Position = UDim2.new(0, 16, 0, 72)
leftPanel.BackgroundTransparency = 1

local leftBg = Instance.new("Frame", leftPanel)
leftBg.Size = UDim2.new(1, 0, 1, 0)
leftBg.Position = UDim2.new(0,0,0,0)
leftBg.BackgroundColor3 = Color3.fromRGB(6,10,14)
leftBg.BorderSizePixel = 0
local leftBgCorner = Instance.new("UICorner", leftBg)
leftBgCorner.CornerRadius = UDim.new(0, 12)
local leftBgStroke = Instance.new("UIStroke", leftBg)
leftBgStroke.Color = Color3.fromRGB(20,28,36)
leftBgStroke.Thickness = 1
leftBgStroke.Transparency = 0.6

local leftList = Instance.new("Frame", leftBg)
leftList.Size = UDim2.new(1, -12, 1, -12)
leftList.Position = UDim2.new(0, 6, 0, 6)
leftList.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", leftList)
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Categories (labels only)
local categories = {"Main","Stealer","Helper","Player","Finder","Server","Discord"}
local categoryButtons = {}
local selectedCategory = "Main"

local function setSelectedCategory(name)
	selectedCategory = name
	-- Update buttons visuals
	for _,btn in ipairs(categoryButtons) do
		if btn._name == name then
			btn.BackgroundTransparency = 0
			btn.BackgroundColor3 = THEME
			btn.TextColor3 = Color3.fromRGB(8,12,14)
		else
			btn.BackgroundTransparency = 1
			btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
			btn.TextColor3 = Color3.fromRGB(180,200,210)
		end
	end
	-- Update content title
	if contentTitle then
		contentTitle.Text = name
	end
	-- Clear content placeholder (no functions added)
	if contentBody then
		-- simple placeholder text per category
		contentBody.Text = "Categoria selecionada: "..name.."\n\n(Aqui vão as opções da categoria — nenhuma função foi adicionada.)"
	end
end

for i, name in ipairs(categories) do
	local btn = Instance.new("TextButton")
	btn.Name = "Cat_"..name
	btn.Size = UDim2.new(1, -12, 0, isTouch and 44 or 48)
	btn.BackgroundTransparency = 1
	btn.Text = name
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = isTouch and 16 or 18
	btn.TextColor3 = Color3.fromRGB(180,200,210)
	btn.AutoButtonColor = true
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Position = UDim2.new(0, 8, 0, 0)
	btn.Parent = leftList
	btn.LayoutOrder = i
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 8)
	-- store name for easy check
	btn._name = name

	btn.MouseButton1Click:Connect(function()
		setSelectedCategory(name)
	end)

	table.insert(categoryButtons, btn)
end

-- Right content area
local contentArea = Instance.new("Frame", Main)
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -leftWidth - 56, 1, -96)
contentArea.Position = UDim2.new(0, leftWidth + 32, 0, 72)
contentArea.BackgroundTransparency = 1

local contentCard = Instance.new("Frame", contentArea)
contentCard.Size = UDim2.new(1, 0, 1, 0)
contentCard.Position = UDim2.new(0,0,0,0)
contentCard.BackgroundColor3 = Color3.fromRGB(6,10,14)
contentCard.BorderSizePixel = 0
local contentCardCorner = Instance.new("UICorner", contentCard)
contentCardCorner.CornerRadius = UDim.new(0, 12)
local contentCardStroke = Instance.new("UIStroke", contentCard)
contentCardStroke.Color = Color3.fromRGB(14, 24, 30)
contentCardStroke.Thickness = 1

-- Content header (shows category title)
local contentHeader = Instance.new("Frame", contentCard)
contentHeader.Size = UDim2.new(1, -24, 0, 44)
contentHeader.Position = UDim2.new(0, 12, 0, 12)
contentHeader.BackgroundTransparency = 1

local contentTitle = Instance.new("TextLabel", contentHeader)
contentTitle.Size = UDim2.new(1, 0, 1, 0)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = selectedCategory
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextSize = isTouch and 18 or 20
contentTitle.TextColor3 = THEME
contentTitle.TextXAlignment = Enum.TextXAlignment.Left

local contentBody = Instance.new("TextLabel", contentCard)
contentBody.Size = UDim2.new(1, -24, 1, -72)
contentBody.Position = UDim2.new(0, 12, 0, 68)
contentBody.BackgroundTransparency = 1
contentBody.Text = "Categoria selecionada: "..selectedCategory.."\n\n(Aqui vão as opções da categoria — nenhuma função foi adicionada.)"
contentBody.Font = Enum.Font.Gotham
contentBody.TextSize = 16
contentBody.TextColor3 = Color3.fromRGB(180, 220, 215)
contentBody.TextXAlignment = Enum.TextXAlignment.Left
contentBody.TextYAlignment = Enum.TextYAlignment.Top
contentBody.TextWrapped = true

-- ---------- panel show/hide logic ----------
local isVisible = false
local shownPos = MAIN_SHOW_POS
local hiddenPos = MAIN_HIDDEN_POS

local function showPanel()
	if isVisible then return end
	Main.Position = hiddenPos
	Main.Visible = true
	MainShadow.Position = UDim2.new(shownPos.X.Scale, shownPos.X.Offset - 8, shownPos.Y.Scale, shownPos.Y.Offset - 8)
	MainShadow.Visible = true
	TweenService:Create(Main, TWEEN_INFO, {Position = shownPos}):Play()
	TweenService:Create(MainShadow, TWEEN_INFO, {Position = UDim2.new(shownPos.X.Scale, shownPos.X.Offset - 8, shownPos.Y.Scale, shownPos.Y.Offset - 8)}):Play()
	isVisible = true
end

local function hidePanel()
	if not isVisible then return end
	TweenService:Create(Main, TWEEN_INFO, {Position = hiddenPos}):Play()
	TweenService:Create(MainShadow, TWEEN_INFO, {Position = UDim2.new(hiddenPos.X.Scale, hiddenPos.X.Offset - 8, hiddenPos.Y.Scale, hiddenPos.Y.Offset - 8)}):Play()
	delay(TWEEN_INFO.Time, function()
		Main.Visible = false
		MainShadow.Visible = false
	end)
	isVisible = false
end

local function togglePanel()
	if isVisible then hidePanel() else showPanel() end
end

OpenButton.MouseButton1Click:Connect(function()
	local t1 = TweenService:Create(OpenButton, TweenInfo.new(0.08), {Size = UDim2.new(0, OPEN_BTN_SIZE.X.Offset-8, 0, OPEN_BTN_SIZE.Y.Offset-8)})
	t1:Play()
	t1.Completed:Wait()
	local t2 = TweenService:Create(OpenButton, TweenInfo.new(0.12), {Size = OPEN_BTN_SIZE})
	t2:Play()
	togglePanel()
end)

Close.MouseButton1Click:Connect(function()
	hidePanel()
end)

-- Make OpenButton draggable on PC
local dragging = false
local dragInput, dragStart, startPos
local function updateOpenButton(input)
	local delta = input.Position - dragStart
	OpenButton.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

OpenButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = OpenButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
OpenButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateOpenButton(input)
	end
end)

-- RightControl toggle (PC)
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightControl then
		togglePanel()
	end
end)

-- ---------- Try preload logo; fallback to text if fails ----------
spawn(function()
	local asset = IMAGE_RBX_ASSET ~= "rbxassetid://0" and IMAGE_RBX_ASSET or IMAGE_URL_FALLBACK
	logo.Image = asset
	local ok = true
	local success, err = pcall(function()
		ContentProvider:PreloadAsync({logo})
	end)
	if not success then ok = false end
	if not ok then
		logo.Visible = false
		logoFallback.Visible = true
	else
		logo.Visible = true
		logoFallback.Visible = false
	end
end)

-- Inicial: seleciona categoria padrão e anima botão
setSelectedCategory("Main")
TweenService:Create(OpenButton, TweenInfo.new(0.45, Enum.EasingStyle.Back), {Position = OpenButton.Position}):Play()

-- FIM
