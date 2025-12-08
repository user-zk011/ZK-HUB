-- ZK HUB - Ajustes finais (LocalScript)
-- Cole em StarterGui (ou StarterPlayerScripts) no Roblox Studio.
-- Correções e melhorias solicitadas:
-- 1) ESP agora aparece "através de tudo" usando Highlight.DepthMode = AlwaysOnTop.
-- 2) ESP aplica a jogadores que entrarem depois de ligado (PlayerAdded + CharacterAdded).
-- 3) Ícone "ZK" maior.
-- 4) Painel redimensionável (segure e arraste o canto inferior direito para redimensionar).
-- 5) Garantia de visibilidade: DisplayOrder / ZIndex altos para evitar sobreposição.
-- 6) Sem X no canto; fecha apenas ao clicar no ícone ou apertar Control.
-- 7) Melhor contraste dos textos para aparecerem corretamente.

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
local TEXT_COLOR = Color3.fromRGB(230, 245, 244)

-- Tamanhos iniciais (maiores por padrão para PC)
local isTouch = UserInputService.TouchEnabled
local OPEN_SIZE = isTouch and UDim2.new(0, 70, 0, 70) or UDim2.new(0, 110, 0, 110) -- ícone maior no PC
local PANEL_SIZE = isTouch and UDim2.new(0, 540, 0, 360) or UDim2.new(0, 1050, 0, 700)
local PANEL_MIN_SIZE = Vector2.new(400, 260)
local PANEL_MAX_SIZE = Vector2.new(1600, 1000)
local PANEL_SHOW_POS = UDim2.new(0.5, -PANEL_SIZE.X.Offset/2, 0.5, -PANEL_SIZE.Y.Offset/2)
local PANEL_HIDDEN_POS = UDim2.new(0.5, -PANEL_SIZE.X.Offset/2, -1.2, 0)
local TWEEN = TweenInfo.new(0.30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- cleanup antiga UI
local existing = playerGui:FindFirstChild("ZKHubGui")
if existing then existing:Destroy() end

-- ScreenGui (DisplayOrder alto para evitar ser coberto)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZKHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = playerGui

-- ---------- Ícone (quadrado arredondado com "ZK") ----------
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
Icon.TextColor3 = TEXT_COLOR
Icon.TextScaled = false
Icon.ZIndex = 100
Icon.Parent = ScreenGui

local iconCorner = Instance.new("UICorner", Icon)
iconCorner.CornerRadius = UDim.new(0, 14)

local iconStroke = Instance.new("UIStroke", Icon)
iconStroke.Color = THEME
iconStroke.Thickness = isTouch and 3 or 4

-- Ícone arrastável no PC
do
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
			Icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- ---------- Painel principal ----------
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

-- Top title (sem botão X)
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
Title.ZIndex = Panel.ZIndex + 1

-- ---------- Layout: categorias (esquerda) / conteúdo (direita) ----------
local leftWidth = isTouch and 180 or 260
local leftPanel = Instance.new("Frame", Panel)
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, leftWidth, 1, -92)
leftPanel.Position = UDim2.new(0, 16, 0, 72)
leftPanel.BackgroundTransparency = 1
leftPanel.ZIndex = Panel.ZIndex + 1

local leftBg = Instance.new("Frame", leftPanel)
leftBg.Size = UDim2.new(1, 0, 1, 0)
leftBg.BackgroundColor3 = Color3.fromRGB(6,10,14)
leftBg.BorderSizePixel = 0
leftBg.ZIndex = leftPanel.ZIndex
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
leftList.ZIndex = leftBg.ZIndex

local listLayout = Instance.new("UIListLayout", leftList)
listLayout.Padding = UDim.new(0, 8)
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Right content area
local contentArea = Instance.new("Frame", Panel)
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -leftWidth - 56, 1, -92)
contentArea.Position = UDim2.new(0, leftWidth + 32, 0, 72)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = Panel.ZIndex + 1

local contentCard = Instance.new("Frame", contentArea)
contentCard.Size = UDim2.new(1, 0, 1, 0)
contentCard.Position = UDim2.new(0,0,0,0)
contentCard.BackgroundColor3 = Color3.fromRGB(6,10,14)
contentCard.BorderSizePixel = 0
contentCard.ZIndex = contentArea.ZIndex
local contentCardCorner = Instance.new("UICorner", contentCard)
contentCardCorner.CornerRadius = UDim.new(0, 12)
local contentCardStroke = Instance.new("UIStroke", contentCard)
contentCardStroke.Color = Color3.fromRGB(14,24,30)
contentCardStroke.Thickness = 1

-- Header + body inside content
local contentHeader = Instance.new("Frame", contentCard)
contentHeader.Size = UDim2.new(1, -24, 0, 44)
contentHeader.Position = UDim2.new(0, 12, 0, 12)
contentHeader.BackgroundTransparency = 1

local contentTitle = Instance.new("TextLabel", contentHeader)
contentTitle.Size = UDim2.new(1, 0, 1, 0)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Categoria 1"
contentTitle.Font = Enum.Font.GothamSemibold
contentTitle.TextSize = isTouch and 18 or 20
contentTitle.TextColor3 = THEME
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.ZIndex = contentCard.ZIndex + 1

local contentBody = Instance.new("TextLabel", contentCard)
contentBody.Size = UDim2.new(1, -24, 1, -72)
contentBody.Position = UDim2.new(0, 12, 0, 68)
contentBody.BackgroundTransparency = 1
contentBody.Text = "Categoria selecionada: Categoria 1\n\n(Aqui ficarão as opções desta categoria.)"
contentBody.Font = Enum.Font.Gotham
contentBody.TextSize = 16
contentBody.TextColor3 = TEXT_COLOR
contentBody.TextXAlignment = Enum.TextXAlignment.Left
contentBody.TextYAlignment = Enum.TextYAlignment.Top
contentBody.TextWrapped = true
contentBody.ZIndex = contentCard.ZIndex + 1

-- ---------- Categories (Categoria 1..7) ----------
local categories = {}
for i = 1, 7 do categories[i] = "Categoria "..i end
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
	btn.Size = UDim2.new(1, -12, 0, isTouch and 44 or 48)
	btn.Position = UDim2.new(0, 8, 0, 0)
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
	btnCorner.CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		clearCategoryStyles()
		btn.BackgroundTransparency = 0
		btn.BackgroundColor3 = THEME
		btn.TextColor3 = Color3.fromRGB(8,12,14)
		selectedCategory = name
		contentTitle.Text = name
		contentBody.Text = "Categoria selecionada: "..name.."\n\n(Aqui vão as opções da categoria — somente ESP implementado na Categoria 1.)"
		-- show/hide ESP controls
		if name == "Categoria 1" then
			espControls.Visible = true
		else
			espControls.Visible = false
		end
	end)

	table.insert(categoryButtons, btn)
end

-- Select initial
if categoryButtons[1] then
	categoryButtons[1].BackgroundTransparency = 0
	categoryButtons[1].BackgroundColor3 = THEME
	categoryButtons[1].TextColor3 = Color3.fromRGB(8,12,14)
end

-- ---------- ESP (Categoria 1) ----------
local espEnabled = false
local highlights = {} -- map player -> Highlight instance

local function createHighlightForPlayer(pl)
	if not pl or pl == player then return end
	-- If there is an existing highlight for this player, destroy it first
	if highlights[pl] then
		pcall(function() highlights[pl]:Destroy() end)
		highlights[pl] = nil
	end
	local char = pl.Character
	if not char or not char.Parent then return end
	local ok, h = pcall(function()
		local highlight = Instance.new("Highlight")
		highlight.Name = "ZK_ESP"
		highlight.Parent = char
		-- fill aqua (opaco o suficiente), thin white outline
		highlight.FillColor = THEME
		highlight.OutlineColor = Color3.fromRGB(255,255,255)
		-- FillTransparency closer to 0 = more solid; we want somewhat transparent so you can see body.
		highlight.FillTransparency = 0.6 -- opaco, but ainda dá para ver quando perto
		highlight.OutlineTransparency = 0.15
		-- Mostrar sempre por cima (através de tudo)
		pcall(function()
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		end)
		return highlight
	end)
	if ok and h then
		highlights[pl] = h
	end
end

local function removeHighlightForPlayer(pl)
	if highlights[pl] then
		pcall(function() highlights[pl]:Destroy() end)
		highlights[pl] = nil
	end
end

local function enableESP()
	if espEnabled then return end
	espEnabled = true
	-- create for existing players
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= player then
			-- if character exists
			if pl.Character and pl.Character.Parent then
				createHighlightForPlayer(pl)
			end
			-- Listen for future character spawns for this player
			pl.CharacterAdded:Connect(function(char)
				-- small wait to ensure character parts exist
				task.wait(0.05)
				if espEnabled then createHighlightForPlayer(pl) end
			end)
		end
	end
	-- Also handle future players joining
	Players.PlayerAdded:Connect(function(pl)
		if pl ~= player then
			pl.CharacterAdded:Connect(function(char)
				task.wait(0.05)
				if espEnabled then createHighlightForPlayer(pl) end
			end)
		end
	end)
end

local function disableESP()
	if not espEnabled then return end
	espEnabled = false
	for pl, h in pairs(highlights) do
		pcall(function() h:Destroy() end)
		highlights[pl] = nil
	end
end

-- Ensure players already in game get hooked to CharacterAdded to handle respawns
for _, pl in ipairs(Players:GetPlayers()) do
	pl.CharacterAdded:Connect(function(char)
		task.wait(0.05)
		if espEnabled and pl ~= player then createHighlightForPlayer(pl) end
	end)
end

Players.PlayerRemoving:Connect(function(pl)
	removeHighlightForPlayer(pl)
end)

-- ---------- ESP Controls UI (inside content area, only visible for Categoria 1) ----------
local espControls = Instance.new("Frame", contentCard)
espControls.Name = "ESPControls"
espControls.Size = UDim2.new(1, -24, 0, 80)
espControls.Position = UDim2.new(0, 12, 0, 12)
espControls.BackgroundTransparency = 1
espControls.ZIndex = contentCard.ZIndex + 1
espControls.Visible = true -- visible by default since Categoria 1 selected

local espLabel = Instance.new("TextLabel", espControls)
espLabel.Size = UDim2.new(0.5, 0, 1, 0)
espLabel.Position = UDim2.new(0,0,0,0)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP PLAYER"
espLabel.Font = Enum.Font.GothamBold
espLabel.TextSize = 18
espLabel.TextColor3 = TEXT_COLOR
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.ZIndex = espControls.ZIndex + 1

local espToggle = Instance.new("TextButton", espControls)
espToggle.Name = "ESP_Toggle"
espToggle.Size = UDim2.new(0, 140, 0, 42)
espToggle.Position = UDim2.new(1, -144, 0.5, -21)
espToggle.BackgroundColor3 = Color3.fromRGB(20,28,34)
espToggle.BorderSizePixel = 0
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 16
espToggle.TextColor3 = Color3.fromRGB(200,220,215)
espToggle.Text = "OFF"
espToggle.ZIndex = espControls.ZIndex + 1
local espToggleCorner = Instance.new("UICorner", espToggle)
espToggleCorner.CornerRadius = UDim.new(0, 10)
local espToggleStroke = Instance.new("UIStroke", espToggle)
espToggleStroke.Color = Color3.fromRGB(40,50,60)

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

-- ---------- Resize grip (canto inferior direito) ----------
local resizeGrip = Instance.new("Frame", Panel)
resizeGrip.Name = "ResizeGrip"
resizeGrip.Size = UDim2.new(0, 28, 0, 28)
resizeGrip.Position = UDim2.new(1, -34, 1, -34)
resizeGrip.AnchorPoint = Vector2.new(0,0)
resizeGrip.BackgroundColor3 = Color3.fromRGB(20,28,34)
resizeGrip.BorderSizePixel = 0
resizeGrip.ZIndex = Panel.ZIndex + 2
local resizeCorner = Instance.new("UICorner", resizeGrip)
resizeCorner.CornerRadius = UDim.new(0, 8)
local gripIcon = Instance.new("TextLabel", resizeGrip)
gripIcon.Size = UDim2.new(1,0,1,0)
gripIcon.BackgroundTransparency = 1
gripIcon.Text = "◢"
gripIcon.Font = Enum.Font.GothamSemibold
gripIcon.TextColor3 = Color3.fromRGB(140,170,165)
gripIcon.TextScaled = true
gripIcon.ZIndex = resizeGrip.ZIndex + 1

do
	local resizing = false
	local startMousePos
	local startSize
	local startPos
	resizeGrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			startMousePos = input.Position
			startSize = Vector2.new(Panel.AbsoluteSize.X, Panel.AbsoluteSize.Y)
			startPos = Panel.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
				end
			end)
		end
	end)
	resizeGrip.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			resizeMouse = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if resizing and input == resizeMouse then
			local delta = input.Position - startMousePos
			local newSize = startSize + Vector2.new(delta.X, delta.Y)
			-- clamp
			newSize = Vector2.new(
				math.clamp(newSize.X, PANEL_MIN_SIZE.X, PANEL_MAX_SIZE.X),
				math.clamp(newSize.Y, PANEL_MIN_SIZE.Y, PANEL_MAX_SIZE.Y)
			)
			Panel.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
			-- update show/hidden positions so center logic keeps working
			PANEL_SHOW_POS = UDim2.new(0.5, -newSize.X/2, 0.5, -newSize.Y/2)
			PANEL_HIDDEN_POS = UDim2.new(0.5, -newSize.X/2, -1.2, 0)
			-- reposition shadow/resizeGrip
			resizeGrip.Position = UDim2.new(1, -34, 1, -34)
		end
	end)
end

-- ---------- Open/Close logic ----------
local panelVisible = false

local function showPanel()
	if panelVisible then return end
	Panel.Position = PANEL_HIDDEN_POS
	Panel.Visible = true
	TweenService:Create(Panel, TWEEN, {Position = PANEL_SHOW_POS}):Play()
	panelVisible = true
	-- show ESP controls only if Categoria 1 selected
	espControls.Visible = (selectedCategory == "Categoria 1")
end

local function hidePanel()
	if not panelVisible then return end
	TweenService:Create(Panel, TWEEN, {Position = PANEL_HIDDEN_POS}):Play()
	delay(TWEEN.Time, function() Panel.Visible = false end)
	panelVisible = false
	espControls.Visible = false
end

local function togglePanel()
	if panelVisible then hidePanel() else showPanel() end
end

Icon.MouseButton1Click:Connect(function()
	local a = TweenService:Create(Icon, TweenInfo.new(0.08), {Size = UDim2.new(0, OPEN_SIZE.X.Offset-10, 0, OPEN_SIZE.Y.Offset-10)})
	a:Play()
	a.Completed:Wait()
	TweenService:Create(Icon, TweenInfo.new(0.12), {Size = OPEN_SIZE}):Play()
	togglePanel()
end)

-- Control key toggle (Left or Right)
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
			togglePanel()
		end
	end
end)

-- ---------- Ensure new players/respawns covered for ESP if enabled ----------
-- The createHighlightForPlayer function will be called on CharacterAdded handlers above when enabling ESP,
-- but also make sure if ESP is enabled and a player joins while ESP is on, we apply it:
Players.PlayerAdded:Connect(function(pl)
	pl.CharacterAdded:Connect(function()
		task.wait(0.05)
		if espEnabled and pl ~= player then
			createHighlightForPlayer(pl)
		end
	end)
end)

-- Also ensure existing players' characters get highlights immediately if ESP is enabled later
-- (handled already in enableESP by iterating Players:GetPlayers).

-- ---------- Inicialização ----------
-- ensure UI text visible and on top
Title.ZIndex = Panel.ZIndex + 1
contentTitle.ZIndex = Panel.ZIndex + 2
contentBody.ZIndex = Panel.ZIndex + 2

-- show ESP controls only for initial category 1
espControls.Visible = true

-- finished
