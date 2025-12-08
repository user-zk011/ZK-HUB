-- ZK HUB Melhorado com ESP Player e visual moderno
-- Cole no StarterGui ou StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

-- Configurações visuais
local OPEN_BTN_SIZE = UDim2.new(0, 70, 0, 70)
local OPEN_BTN_POS = UDim2.new(0, 60, 0.4, 0) -- mais para direita

local MAIN_SIZE = UDim2.new(0, 480, 0, 340)
local MAIN_SHOW_POS = UDim2.new(0.5, -240, 0.5, -170)
local MAIN_HIDDEN_POS = UDim2.new(0.5, -240, -0.9, 0)

local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Cores (estilo da imagem enviada)
local COLOR_BG = Color3.fromRGB(15, 23, 34)
local COLOR_HIGHLIGHT = Color3.fromRGB(45, 60, 90)
local COLOR_TEXT = Color3.fromRGB(170, 210, 230)
local COLOR_ACTIVE = Color3.fromRGB(30, 150, 240)
local COLOR_TOGGLE_BG = Color3.fromRGB(30, 30, 30)
local COLOR_TOGGLE_ON = Color3.fromRGB(50, 180, 255)
local COLOR_TOGGLE_OFF = Color3.fromRGB(60, 60, 60)

-- Evitar duplicação
local guiName = "ZKHubGui"
local existing = playerGui:FindFirstChild(guiName)
if existing then existing:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui
ScreenGui.IgnoreGuiInset = true

-- Botão abrir (arrastável)
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = OPEN_BTN_SIZE
OpenButton.Position = OPEN_BTN_POS
OpenButton.AnchorPoint = Vector2.new(0, 0)
OpenButton.BackgroundColor3 = COLOR_ACTIVE
OpenButton.AutoButtonColor = true
OpenButton.BorderSizePixel = 0
OpenButton.Image = "" -- sem imagem para poder colorir todo

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = OpenButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = COLOR_HIGHLIGHT
openStroke.Thickness = 3
openStroke.Parent = OpenButton

-- Sombra por trás
local openShadow = Instance.new("Frame")
openShadow.Name = "OpenShadow"
openShadow.Size = UDim2.new(1, 10, 1, 10)
openShadow.Position = UDim2.new(0, -5, 0, -5)
openShadow.BackgroundColor3 = Color3.new(0,0,0)
openShadow.BackgroundTransparency = 0.8
openShadow.ZIndex = OpenButton.ZIndex - 1
openShadow.Parent = OpenButton
local openShadowCorner = Instance.new("UICorner")
openShadowCorner.CornerRadius = UDim.new(1, 0)
openShadowCorner.Parent = openShadow

-- Texto "ZK" no botão para estilo (pode mudar pra algo mais personalizado)
local openText = Instance.new("TextLabel")
openText.Size = UDim2.new(1, 0, 1, 0)
openText.BackgroundTransparency = 1
openText.Text = "ZK"
openText.Font = Enum.Font.GothamBlack
openText.TextColor3 = COLOR_TEXT
openText.TextScaled = true
openText.Parent = OpenButton

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
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = Main

-- Borda sutil
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLOR_HIGHLIGHT
mainStroke.Thickness = 3
mainStroke.Parent = Main

-- Título do painel
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -24, 0, 44)
Title.Position = UDim2.new(0, 12, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "ZK HUB - Steal a Brainrot"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = COLOR_TEXT
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Botão fechar (canto superior direito)
local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 36, 0, 36)
Close.Position = UDim2.new(1, -48, 0, 12)
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
TabsFrame.Size = UDim2.new(0, 110, 1, -80)
TabsFrame.Position = UDim2.new(0, 12, 0, 58)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = Main

-- Lista de abas (nome e ID)
local tabs = {
	{ Name = "Main" },
	{ Name = "Stealer" },
	{ Name = "Helper" },
	{ Name = "Player" },
	{ Name = "Finder" }
}

-- Container conteúdo das abas
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -140, 1, -80)
ContentFrame.Position = UDim2.new(0, 130, 0, 58)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Main

-- Criar abas e conteúdo vazio
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
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.Position = UDim2.new(0, 0, 0, (i-1)*40)
	btn.BackgroundColor3 = COLOR_BG
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.GothamBold
	btn.Text = tab.Name
	btn.TextColor3 = Color3.fromRGB(120, 140, 160)
	btn.TextSize = 18
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

-- Selecionar primeira aba inicial
selectTab(1)

-- Fechar painel ao clicar no X
Close.MouseButton1Click:Connect(function()
	hidePanel()
end)

-- Funções para mostrar/ocultar painel com animação
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

-- Abrir/fechar pelo botão
OpenButton.MouseButton1Click:Connect(function()
	togglePanel()
end)

-- Permitir arrastar o botão
local dragging = false
local dragInput, dragStart, startPos

local function updateOpenButton(input)
	local delta = input.Position - dragStart
	local newX = startPos.X.Offset + delta.X
	local newY = startPos.Y.Offset + delta.Y

	-- Limitar posição dentro da tela (mais simples)
	newX = math.clamp(newX, 10, workspace.CurrentCamera.ViewportSize.X - OpenButton.AbsoluteSize.X - 10)
	newY = math.clamp(newY, 10, workspace.CurrentCamera.ViewportSize.Y - OpenButton.AbsoluteSize.Y - 10)

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

-- Atalhos teclado para abrir/fechar (especificar quais)
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

-- === Conteúdo da aba Player (index 4) - ESP Player ===
local espEnabled = false
local espFolder = Instance.new("Folder", workspace)
espFolder.Name = "ZK_ESP_Folder"

local function createEspForPlayer(targetPlayer)
	if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

	-- Evitar duplicados
	local existing = espFolder:FindFirstChild(targetPlayer.Name)
	if existing then existing:Destroy() end

	local char = targetPlayer.Character

	-- Criar Box (contorno) e camada azul translúcida sobre o personagem
	-- Usaremos Highlights que funciona melhor para contorno
	local highlight = Instance.new("Highlight")
	highlight.Name = targetPlayer.Name
	highlight.Adornee = char
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.OutlineColor = Color3.new(1, 1, 1) -- branco forte
	highlight.OutlineTransparency = 0
	highlight.FillColor = Color3.fromRGB(64, 224, 208) -- azul claro
	highlight.FillTransparency = 0.9 -- opacidade 90% (presta atenção: 0 é opaco, 1 é invisível)

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

-- Atualizar ESP sempre que personagem aparecer
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

-- Atualização periódica para garantir ESP ativo/desativo
RunService.Heartbeat:Connect(function()
	updateAllEsp()
end)

-- Criar toggle personalizado (toggle button estilo imagem)
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

	-- Custom event "ToggleChanged"
	toggleFrame.ToggleChanged = Instance.new("BindableEvent")
	toggleFrame.ToggleChanged.Event:Connect(function(state)
		-- Placeholder
	end)

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

-- Prepara conteúdo da aba Player para ESP toggle

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
		-- Remove todos highlights quando desativar
		for _, child in pairs(espFolder:GetChildren()) do
			if child:IsA("Highlight") then
				child:Destroy()
			end
		end
	end
end)

-- Inicializa o toggle desligado
espToggle:Set(false)

return
