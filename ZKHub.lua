-- ZK HUB - Versão futurista com degrade, ESP funcional e UI organizada
-- Cole no StarterGui ou StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

-- Configurações visuais e tamanhos
local OPEN_BTN_SIZE = UDim2.new(0, 70, 0, 70)
local OPEN_BTN_POS = UDim2.new(0, 60, 0.4, 0) -- botão mais para direita

local MAIN_SIZE = UDim2.new(0, 500, 0, 360)
local MAIN_SHOW_POS = UDim2.new(0.5, -250, 0.5, -180)
local MAIN_HIDDEN_POS = UDim2.new(0.5, -250, -0.9, 0)

local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Cores base para estilo futurista
local COLOR_BG = Color3.fromRGB(15, 23, 34) -- fundo escuro
local COLOR_HIGHLIGHT = Color3.fromRGB(45, 60, 90) -- azul escuro para destaques
local COLOR_TEXT = Color3.fromRGB(170, 210, 230) -- texto principal
local COLOR_ACTIVE = Color3.fromRGB(30, 150, 240) -- azul vivo
local COLOR_TOGGLE_BG = Color3.fromRGB(30, 30, 30)
local COLOR_TOGGLE_ON = Color3.fromRGB(50, 180, 255)
local COLOR_TOGGLE_OFF = Color3.fromRGB(60, 60, 60)

-- Evitar duplicação do GUI
local guiName = "ZKHubGui"
local existing = playerGui:FindFirstChild(guiName)
if existing then existing:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui
ScreenGui.IgnoreGuiInset = true

-- Função para criar texto com degrade
local function createGradientText(parent, text, size, pos, font, textSize, alignment)
	local label = Instance.new("TextLabel")
	label.Size = size
	label.Position = pos
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = font or Enum.Font.GothamBlack
	label.TextSize = textSize or 28
	label.TextXAlignment = alignment or Enum.TextXAlignment.Left
	label.TextColor3 = Color3.new(1,1,1)
	label.Parent = parent

	-- Degrade via UIGradient na TextLabel não funciona, então criamos um Frame com TextLabel branco e um Frame transparente em cima com gradiente para "mascarar" o texto.
	-- Aqui simplificamos: aplicamos o UIGradient na TextLabel TextColor3, para simular degrade.
	local gradient = Instance.new("UIGradient")
	gradient.Rotation = 90
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)), -- cyan
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 220)),
	}
	gradient.Parent = label

	return label
end

-- Botão abrir, arredondado, texto ZK com degrade
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = OPEN_BTN_SIZE
OpenButton.Position = OPEN_BTN_POS
OpenButton.AnchorPoint = Vector2.new(0, 0)
OpenButton.BackgroundColor3 = COLOR_ACTIVE
OpenButton.AutoButtonColor = true
OpenButton.BorderSizePixel = 0
OpenButton.Image = "" -- sem imagem

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = OpenButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = COLOR_HIGHLIGHT
openStroke.Thickness = 3
openStroke.Parent = OpenButton

-- Sombra atrás do botão
local openShadow = Instance.new("Frame")
openShadow.Name = "OpenShadow"
openShadow.Size = UDim2.new(1, 12, 1, 12)
openShadow.Position = UDim2.new(0, -6, 0, -6)
openShadow.BackgroundColor3 = Color3.new(0, 0, 0)
openShadow.BackgroundTransparency = 0.8
openShadow.ZIndex = OpenButton.ZIndex - 1
openShadow.Parent = OpenButton
local openShadowCorner = Instance.new("UICorner")
openShadowCorner.CornerRadius = UDim.new(1, 0)
openShadowCorner.Parent = openShadow

-- Texto ZK com degrade no botão
local openText = createGradientText(OpenButton, "ZK", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.Font.GothamBlack, 32, Enum.TextXAlignment.Center)
openText.TextScaled = true

OpenButton.Parent = ScreenGui

-- Painel principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = MAIN_SIZE
Main.Position = MAIN_HIDDEN_POS
Main.AnchorPoint = Vector2.new(0, 0)
Main.BackgroundColor3 = COLOR_BG
Main.BorderSizePixel = 0
Main.Visible = false
Main.ZIndex = 2
Main.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = Main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLOR_HIGHLIGHT
mainStroke.Thickness = 3
mainStroke.Parent = Main

-- Texto do topo esquerdo do painel com degrade
local titleLabel = createGradientText(Main, "ZK HUB - Roube um Brainrot", UDim2.new(1, -24, 0, 44), UDim2.new(0, 12, 0, 12), Enum.Font.GothamBold, 22, Enum.TextXAlignment.Left)

-- Botão fechar (canto superior direito)
local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 38, 0, 38)
Close.Position = UDim2.new(1, -54, 0, 12)
Close.AnchorPoint = Vector2.new(0, 0)
Close.BackgroundColor3 = COLOR_ACTIVE
Close.BorderSizePixel = 0
Close.Text = "✕"
Close.TextColor3 = COLOR_BG
Close.Font = Enum.Font.GothamBold
Close.TextScaled = true
Close.Parent = Main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = Close

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = COLOR_HIGHLIGHT
closeStroke.Thickness = 2
closeStroke.Parent = Close

-- Container abas esquerda
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0, 120, 1, -80)
TabsFrame.Position = UDim2.new(0, 12, 0, 58)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = Main

-- Lista de abas
local tabs = {
	{ Name = "Main" },
	{ Name = "Stealer" },
	{ Name = "Helper" },
	{ Name = "Player" },
	{ Name = "Finder" }
}

-- Container conteúdo das abas
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -150, 1, -80)
ContentFrame.Position = UDim2.new(0, 140, 0, 58)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Main

-- Criar abas e conteúdo
local tabButtons = {}
local tabContents = {}

local function clearContent()
	for _, frame in pairs(tabContents) do
		frame.Visible = false
	end
end

local function selectTab(index)
	clearContent()
	for i, btn in ipairs(tabButtons) do
		btn.BackgroundColor3 = (i == index) and COLOR_HIGHLIGHT or COLOR_BG
		btn.TextColor3 = (i == index) and COLOR_TEXT or Color3.fromRGB(120, 140, 160)
	end
	tabContents[index].Visible = true
end

for i, tab in ipairs(tabs) do
	local btn = Instance.new("TextButton")
	btn.Name = "TabBtn"..tab.Name
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.Position = UDim2.new(0, 0, 0, (i-1)*44)
	btn.BackgroundColor3 = COLOR_BG
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.GothamBold
	btn.Text = tab.Name
	btn.TextColor3 = Color3.fromRGB(120, 140, 160)
	btn.TextSize = 20
	btn.Parent = TabsFrame

	tabButtons[i] = btn

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, 0)
	content.Position = UDim2.new(0, 0, 0, 0)
	content.BackgroundTransparency = 1
	content.Visible = false
	content.Parent = ContentFrame

	tabContents[i] = content

	btn.MouseButton1Click:Connect(function()
		selectTab(i)
	end)
end

-- Selecionar primeira aba ao iniciar
selectTab(1)

-- Função mostrar e esconder painel animado
local isVisible = false

local function showPanel()
	if isVisible then return end
	Main.Position = MAIN_HIDDEN_POS
	Main.Visible = true
	TweenService:Create(Main, TWEEN_INFO, {Position = MAIN_SHOW_POS}):Play()
	isVisible = true
end

local function hidePanel()
	if not isVisible then return end
	TweenService:Create(Main, TWEEN_INFO, {Position = MAIN_HIDDEN_POS}):Play()
	delay(TWEEN_INFO.Time, function()
		Main.Visible = false
	end)
	isVisible = false
end

local function togglePanel()
	if isVisible then hidePanel() else showPanel() end
end

-- Botão abrir/fechar
OpenButton.MouseButton1Click:Connect(togglePanel)
Close.MouseButton1Click:Connect(hidePanel)

-- Permitir arrastar botão abrir
local dragging = false
local dragInput, dragStart, startPos

local function updateOpenButton(input)
	local delta = input.Position - dragStart
	local newX = startPos.X.Offset + delta.X
	local newY = startPos.Y.Offset + delta.Y

	-- Limitar dentro da tela
	local viewport = workspace.CurrentCamera.ViewportSize
	newX = math.clamp(newX, 10, viewport.X - OpenButton.AbsoluteSize.X - 10)
	newY = math.clamp(newY, 10, viewport.Y - OpenButton.AbsoluteSize.Y - 10)

	OpenButton.Position = UDim2.new(0, newX, 0, newY)
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

-- Atalhos para abrir/fechar painel (somente teclas control, shift e alt)
local allowedKeys = {
	Enum.KeyCode.LeftControl,
	Enum.KeyCode.RightControl,
	Enum.KeyCode.LeftShift,
	Enum.KeyCode.RightShift,
	Enum.KeyCode.LeftAlt,
	Enum.KeyCode.RightAlt,
}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		for _, key in ipairs(allowedKeys) do
			if input.KeyCode == key then
				togglePanel()
				break
			end
		end
	end
end)

-- === Conteúdo da aba Player (index 4) - ESP Player funcional ===

local espEnabled = false
local espFolder = Instance.new("Folder")
espFolder.Name = "ZK_ESP_Folder"
espFolder.Parent = workspace

-- Cria highlight ESP para o player
local function createEspForPlayer(targetPlayer)
	if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	-- Evitar duplicados
	local existing = espFolder:FindFirstChild(targetPlayer.Name)
	if existing then existing:Destroy() end
	local char = targetPlayer.Character

	local highlight = Instance.new("Highlight")
	highlight.Name = targetPlayer.Name
	highlight.Adornee = char
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.OutlineColor = Color3.new(1,1,1) -- branco contorno
	highlight.OutlineTransparency = 0
	highlight.FillColor = Color3.fromRGB(64, 224, 208) -- azul claro
	highlight.FillTransparency = 0.9 -- opacidade 90%
	highlight.Parent = espFolder

	return highlight
end

local function removeEspForPlayer(targetPlayer)
	local existing = espFolder:FindFirstChild(targetPlayer.Name)
	if existing then
		existing:Destroy()
	end
end

local function updateAllEsp()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			if espEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				if not espFolder:FindFirstChild(plr.Name) then
					createEspForPlayer(plr)
				end
			else
				removeEspForPlayer(plr)
			end
		end
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if espEnabled then
			createEspForPlayer(plr)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	removeEspForPlayer(plr)
end)

RunService.Heartbeat:Connect(function()
	updateAllEsp()
end)

-- Função para criar toggle button moderno
local function createToggle(parent, pos, size, initialState)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Size = size or UDim2.new(0, 50, 0, 24)
	toggleFrame.Position = pos or UDim2.new(0, 0, 0, 0)
	toggleFrame.BackgroundColor3 = COLOR_TOGGLE_BG
	toggleFrame.BorderSizePixel = 0
	toggleFrame.AnchorPoint = Vector2.new(0, 0)
	toggleFrame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = toggleFrame

	local circle = Instance.new("Frame")
	circle.Name = "Circle"
	circle.Size = UDim2.new(0, 20, 0, 20)
	circle.Position = UDim2.new(initialState and 1 or 0, -20, 0.5, -10)
	circle.BackgroundColor3 = initialState and COLOR_TOGGLE_ON or COLOR_TOGGLE_OFF
	circle.BorderSizePixel = 0
	circle.AnchorPoint = Vector2.new(initialState and 1 or 0, 0.5)
	circle.Parent = toggleFrame

	local toggled = initialState

	local function setState(state)
		toggled = state
		local goalPos = UDim2.new(toggled and 1 or 0, -20, 0.5, -10)
		local goalColor = toggled and COLOR_TOGGLE_ON or COLOR_TOGGLE_OFF
		TweenService:Create(circle, TweenInfo.new(0.2), {Position = goalPos, BackgroundColor3 = goalColor}):Play()
	end

	toggleFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			setState(not toggled)
			toggleFrame:Fire("ToggleChanged", toggled)
		end
	end)

	toggleFrame.ToggleChanged = Instance.new("BindableEvent")
	toggleFrame.ToggleChanged.Event:Connect(function(state) end)

	function toggleFrame:Set(state)
		setState(state)
	end

	function toggleFrame:Get()
		return toggled
	end

	function toggleFrame:Fire(eventName, ...)
		if eventName == "ToggleChanged" then
			toggleFrame.ToggleChanged:Fire(...)
		end
	end

	return toggleFrame
end

-- Conteúdo da aba Player: ESP toggle
local playerContent = tabContents[4]

local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0.5, -10, 0, 28)
espLabel.Position = UDim2.new(0, 10, 0, 10)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP Player"
espLabel.Font = Enum.Font.Gotham
espLabel.TextSize = 20
espLabel.TextColor3 = COLOR_TEXT
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.Parent = playerContent

local espToggle = createToggle(playerContent, UDim2.new(0.5, 10, 0, 10), UDim2.new(0, 50, 0, 28), false)
espToggle.Parent = playerContent

espToggle.ToggleChanged.Event:Connect(function(state)
	espEnabled = state
	if not espEnabled then
		-- Remove todos highlights ao desativar
		for _, child in pairs(espFolder:GetChildren()) do
			if child:IsA("Highlight") then
				child:Destroy()
			end
		end
	end
