-- ZK HUB - Versão final solicitada (LocalScript)
-- Cole este script em StarterGui ou StarterPlayerScripts no Roblox Studio.
-- O ícone é um quadradinho arredondado com "ZK". O painel é maior, com contorno aqua,
-- título "ZK HUB - ROUBE UM BRAINROT" com mesma cor do contorno. Não há botão X.
-- Fecha/abre apenas quando o jogador clicar no ícone ou apertar Control (esquerdo ou direito).
-- Adicionei categorias (Categoria 1..7). Na Categoria 1 há um toggle "ESP PLAYER" que ativa
-- Highlights locais nos personagens (efeito verde-água opaco com traço branco fino).
-- O ESP é feito via Instance.new("Highlight") para ser client-side (não altera permanentemente o servidor).

-- Anti-duplicação
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
local THEME = Color3.fromRGB(64, 224, 208) -- verde-água
local BORDER_LIGHT = Color3.fromRGB(175, 255, 250)
local TITLE_COLOR = THEME
local PANEL_BG = Color3.fromRGB(8, 14, 20)
local TEXT_COLOR = Color3.fromRGB(220, 240, 238)

-- Tamanhos e configurações (maior que antes)
local isTouch = UserInputService.TouchEnabled
local OPEN_SIZE = isTouch and UDim2.new(0, 70, 0, 70) or UDim2.new(0, 92, 0, 92)
local PANEL_SIZE = isTouch and UDim2.new(0, 540, 0, 360) or UDim2.new(0, 980, 0, 620)
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
ScreenGui.Parent = playerGui

-- ---------- Ícone (quadradinho arredondado com ZK) ----------
local Icon = Instance.new("TextButton")
Icon.Name = "ZKIcon"
Icon.Size = OPEN_SIZE
Icon.Position = UDim2.new(0.03, 0, 0.38, 0)
Icon.AnchorPoint = Vector2.new(0,0)
Icon.BackgroundColor3 = PANEL_BG
Icon.BackgroundTransparency = 0
Icon.BorderSizePixel = 0
Icon.AutoButtonColor = true
Icon.Text = "ZK"
Icon.Font = Enum.Font.GothamBlack
Icon.TextSize = isTouch and 22 or 26
Icon.TextColor3 = TEXT_COLOR
Icon.Parent = ScreenGui
Icon.ZIndex = 50

local iconCorner = Instance.new("UICorner", Icon)
iconCorner.CornerRadius = UDim.new(0, 12)

local iconStroke = Instance.new("UIStroke", Icon)
iconStroke.Color = THEME
iconStroke.Thickness = isTouch and 3 or 4

-- Make icon draggable on PC
local dragging = false
local dragInput, dragStart, startPos
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
		Icon.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- ---------- Painel principal ----------
local Panel = Instance.new("Frame")
Panel.Name = "ZKPanel"
Panel.Size = PANEL_SIZE
Panel.Position = PANEL_HIDDEN_POS
Panel.AnchorPoint = Vector2.new(0,0)
Panel.BackgroundColor3 = PANEL_BG
Panel.BorderSizePixel = 0
Panel.Visible = false
Panel.Parent = ScreenGui
Panel.ZIndex = 40

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

-- Top title (sem X)
local Title = Instance.new("TextLabel", Panel)
Title.Name = "Title"
Title.Size = UDim2.new(1, -32, 0, 56)
Title.Position = UDim2.new(0, 16, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "ZK HUB - ROUBE UM BRAINROT"
Title.Font = Enum.Font.GothamBold
Title.TextSize = isTouch and 18 or 24
Title.TextColor3 = TITLE_COLOR
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ---------- Layout: left categories, right content ----------
local leftWidth = isTouch and 180 or 240
local leftPanel = Instance.new("Frame", Panel)
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, leftWidth, 1, -92)
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
leftList.Size = UDim2.new(1, -16, 1, -16)
leftList.Position = UDim2.new(0, 8, 0, 8)
leftList.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout", leftList)
listLayout.Padding = UDim.new(0, 8)
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Categories: Categoria 1..7 (placeholders)
local categories = {}
for i = 1, 7 do
	categories[i] = "Categoria "..i
end

local categoryButtons = {}
local selectedCategory = categories[1]

-- Right content area
local contentArea = Instance.new("Frame", Panel)
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -leftWidth - 56, 1, -92)
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
contentCardStroke.Color = Color3.fromRGB(14,24,30)
contentCardStroke.Thickness = 1

-- Content title and body
local contentHeader = Instance.new("Frame", contentCard)
contentHeader.Size = UDim2.new(1, -24, 0, 44)
contentHeader.Position = UDim2.new(0, 12, 0, 12)
contentHeader.BackgroundTransparency = 1

local contentTitle = Instance.new("TextLabel", contentHeader)
contentTitle.Size = UDim2.new(1, 0, 1, 0)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = selectedCategory
contentTitle.Font = Enum.Font.GothamSemibold
contentTitle.TextSize = isTouch and 18 or 20
contentTitle.TextColor3 = THEME
contentTitle.TextXAlignment = Enum.TextXAlignment.Left

local contentBody = Instance.new("TextLabel", contentCard)
contentBody.Size = UDim2.new(1, -24, 1, -72)
contentBody.Position = UDim2.new(0, 12, 0, 68)
contentBody.BackgroundTransparency = 1
contentBody.Text = "Categoria selecionada: "..selectedCategory.."\n\n(Aqui ficarão as opções desta categoria.)"
contentBody.Font = Enum.Font.Gotham
contentBody.TextSize = 16
contentBody.TextColor3 = Color3.fromRGB(180, 220, 215)
contentBody.TextXAlignment = Enum.TextXAlignment.Left
contentBody.TextYAlignment = Enum.TextYAlignment.Top
contentBody.TextWrapped = true

-- Create category buttons
for i, name in ipairs(categories) do
	local btn = Instance.new("TextButton")
	btn.Name = "Cat_"..i
	btn.Size = UDim2.new(1, -12, 0, isTouch and 44 or 48)
	btn.BackgroundTransparency = 1
	btn.Text = name
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = isTouch and 16 or 18
	btn.TextColor3 = Color3.fromRGB(180,200,210)
	btn.AutoButtonColor = true
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.LayoutOrder = i
	btn.Parent = leftList

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		-- update visuals
		for _, b in ipairs(categoryButtons) do
			b.BackgroundTransparency = 1
			b.TextColor3 = Color3.fromRGB(180,200,210)
		end
		btn.BackgroundTransparency = 0
		btn.BackgroundColor3 = THEME
		btn.TextColor3 = Color3.fromRGB(8,12,14)
		-- update content
		selectedCategory = name
		contentTitle.Text = name
		contentBody.Text = "Categoria selecionada: "..name.."\n\n(Aqui vão as opções da categoria — nenhuma função além do ESP foi adicionada, exceto na Categoria 1.)"
		-- show ESP controls only on Category 1
		if name == "Categoria 1" then
			showESPControls()
		else
			hideESPControls()
		end
	end)

	table.insert(categoryButtons, btn)
end

-- Helper to style initial selected button
local function selectInitialCategory()
	local first = categoryButtons[1]
	if first then
		first.BackgroundTransparency = 0
		first.BackgroundColor3 = THEME
		first.TextColor3 = Color3.fromRGB(8,12,14)
	end
end

-- ---------- ESP (Categoria 1) ----------
local espEnabled = false
local highlights = {} -- map player -> Highlight

local function createHighlightForCharacter(character)
	if not character then return nil end
	-- Only create one highlight per model
	local h = Instance.new("Highlight")
	h.Name = "ZK_ESP"
	h.Parent = character
	-- Colors per request: fill aqua (opaco), thin white outline
	h.FillColor = THEME
	h.OutlineColor = Color3.fromRGB(255,255,255)
	h.FillTransparency = 0.55 -- opaco o suficiente para deixar ver quando perto
	h.OutlineTransparency = 0.1
	-- Optionally set DepthMode if available for better visibility (if supported)
	-- pcall to avoid errors on older clients
	pcall(function()
		-- if Enum.HighlightDepthMode exists
		if h.DepthMode then
			h.DepthMode = Enum.HighlightDepthMode.Occluded
		end
	end)
	return h
end

local function enableESP()
	if espEnabled then return end
	espEnabled = true
	-- create for existing players
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= player and pl.Character and pl.Character.Parent then
			if not highlights[pl] then
				local ok, h = pcall(createHighlightForCharacter, pl.Character)
				if ok and h then
					highlights[pl] = h
				end
			end
		end
	end
	-- watch for future chars and players
end

local function disableESP()
	if not espEnabled then return end
	espEnabled = false
	for pl, h in pairs(highlights) do
		if h and h.Parent then
			pcall(function() h:Destroy() end)
		end
		highlights[pl] = nil
	end
end

-- Handle player join/leave and character respawn
Players.PlayerAdded:Connect(function(pl)
	-- create highlight if needed when character spawns
	pl.CharacterAdded:Connect(function(char)
		if espEnabled and pl ~= player then
			-- small delay to ensure character loaded
			task.wait(0.1)
			if not highlights[pl] then
				local ok, h = pcall(createHighlightForCharacter, char)
				if ok and h then highlights[pl] = h end
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(pl)
	if highlights[pl] then
		pcall(function() highlights[pl]:Destroy() end)
		highlights[pl] = nil
	end
end)

-- If characters already present, hook CharacterAdded for local players
for _, pl in ipairs(Players:GetPlayers()) do
	pl.CharacterAdded:Connect(function(char)
		if espEnabled and pl ~= player then
			task.wait(0.1)
			if not highlights[pl] then
				local ok, h = pcall(createHighlightForCharacter, char)
				if ok and h then highlights[pl] = h end
			end
		end
	end)
end

-- ---------- ESP Controls UI (inside content area, shown only for Categoria 1) ----------
local espControls = Instance.new("Frame", contentCard)
espControls.Name = "ESPControls"
espControls.Size = UDim2.new(1, -24, 0, 80)
espControls.Position = UDim2.new(0, 12, 0, 12)
espControls.BackgroundTransparency = 1
espControls.Visible = false

local espLabel = Instance.new("TextLabel", espControls)
espLabel.Size = UDim2.new(0.5, 0, 1, 0)
espLabel.Position = UDim2.new(0,0,0,0)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP PLAYER"
espLabel.Font = Enum.Font.GothamBold
espLabel.TextSize = 18
espLabel.TextColor3 = Color3.fromRGB(210,230,225)
espLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Simple toggle button
local espToggle = Instance.new("TextButton", espControls)
espToggle.Name = "ESP_Toggle"
espToggle.Size = UDim2.new(0, 120, 0, 40)
espToggle.Position = UDim2.new(1, -120, 0.5, -20)
espToggle.AnchorPoint = Vector2.new(0,0)
espToggle.BackgroundColor3 = Color3.fromRGB(20,28,34)
espToggle.BorderSizePixel = 0
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 16
espToggle.TextColor3 = Color3.fromRGB(200,220,215)
espToggle.Text = "OFF"
local espToggleCorner = Instance.new("UICorner", espToggle)
espToggleCorner.CornerRadius = UDim.new(0, 8)
local espToggleStroke = Instance.new("UIStroke", espToggle)
espToggleStroke.Color = Color3.fromRGB(40,50,60)
espToggleStroke.Thickness = 1

local function showESPControls()
	espControls.Visible = true
end
local function hideESPControls()
	espControls.Visible = false
end

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

-- ---------- Open/Close logic ----------
local panelVisible = false

local function showPanel()
	if panelVisible then return end
	Panel.Position = PANEL_HIDDEN_POS
	Panel.Visible = true
	TweenService:Create(Panel, TWEEN, {Position = PANEL_SHOW_POS}):Play()
	panelVisible = true
	-- if Categoria 1 selected, show ESP controls
	if selectedCategory == "Categoria 1" then showESPControls() end
end

local function hidePanel()
	if not panelVisible then return end
	TweenService:Create(Panel, TWEEN, {Position = PANEL_HIDDEN_POS}):Play()
	delay(TWEEN.Time, function() Panel.Visible = false end)
	panelVisible = false
	hideESPControls()
end

local function togglePanel()
	if panelVisible then hidePanel() else showPanel() end
end

-- Icon click toggles
Icon.MouseButton1Click:Connect(function()
	-- small click animation
	local a = TweenService:Create(Icon, TweenInfo.new(0.08), {Size = UDim2.new(0, OPEN_SIZE.X.Offset-8, 0, OPEN_SIZE.Y.Offset-8)})
	a:Play()
	a.Completed:Wait()
	TweenService:Create(Icon, TweenInfo.new(0.12), {Size = OPEN_SIZE}):Play()
	togglePanel()
end)

-- Control key toggle (both left and right)
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
			togglePanel()
		end
	end
end)

-- Ensure close when pressing Escape as well? (user asked only Control, so not added)
-- Note: no X button; closing only by Control or Icon click

-- Initialize visuals: select Categoria 1 and set up initial state
selectInitialCategory()
-- show ESP controls if default category is 1
if selectedCategory == "Categoria 1" then
	showESPControls()
end

-- END
