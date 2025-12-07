-- ZK HUB - Versão melhorada (LocalScript)
-- Cole este script em StarterGui (ou StarterPlayerScripts) no Roblox Studio.
-- Observação: se você fez upload da imagem para Roblox, troque IMAGE_URL por "rbxassetid://<ID>".

-- Anti-duplicação (suporta ambientes com/sem getgenv)
local already = false
pcall(function()
	if getgenv and getgenv().ZK_LOADED then
		already = true
	end
end)
if already then return end
pcall(function()
	if getgenv then getgenv().ZK_LOADED = true end
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIGURAÇÕES
local OPEN_BTN_SIZE = UDim2.new(0, 60, 0, 60)
local MAIN_SIZE = UDim2.new(0, 380, 0, 260)
local MAIN_SHOW_POS = UDim2.new(0.5, -190, 0.5, -130)
local MAIN_HIDDEN_POS = UDim2.new(0.5, -190, -0.8, 0)
local TWEEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- URL da logo (substitua por rbxassetid://#### se fizer upload)
local IMAGE_URL = "https://cdn.ereemby.com/attachments/17631336254632667imagem.png"

-- Limpeza útil no Studio (testes repetidos)
local existing = playerGui:FindFirstChild("ZKHubGui")
if existing then existing:Destroy() end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZKHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui
ScreenGui.IgnoreGuiInset = true

-- Botão redondo (open/close) - pode ser arrastado no PC
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = OPEN_BTN_SIZE
OpenButton.Position = UDim2.new(0.03, 0, 0.4, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 80, 200)
OpenButton.BackgroundTransparency = 0.12
OpenButton.BorderSizePixel = 0
OpenButton.AutoButtonColor = true
OpenButton.Image = "" -- imagem do próprio botão (vazio porque temos ImageLabel)
OpenButton.Parent = ScreenGui
OpenButton.AnchorPoint = Vector2.new(0, 0)

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0) -- totalmente circular
openCorner.Parent = OpenButton

-- Borda azul clara sutil no botão
local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(150, 200, 255)
openStroke.Thickness = 2
openStroke.Transparency = 0
openStroke.Parent = OpenButton

-- Logo central no botão (substituir IMAGE_URL caso necessário)
local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0.5, 0, 0.5, 0)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.BackgroundTransparency = 1
logo.Image = IMAGE_URL
logo.Parent = OpenButton

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logo

-- Pequena sombra/efeito atrás do logo (opcional)
local logoShadow = Instance.new("UIStroke")
logoShadow.Parent = logo
logoShadow.Color = Color3.fromRGB(10,10,10)
logoShadow.Thickness = 1
logoShadow.Transparency = 0.6

-- Main panel (painel central)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = MAIN_SIZE
Main.Position = MAIN_HIDDEN_POS
Main.AnchorPoint = Vector2.new(0,0)
Main.BackgroundColor3 = Color3.fromRGB(12, 22, 36) -- azul escuro cinza
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui

-- Cantos arredondados
local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = Main

-- Borda clara azul usando UIStroke
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(150, 200, 255) -- azul claro
border.Thickness = 2
border.Parent = Main

-- Gradiente sutil no fundo
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20,28,40)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(16,24,36))
}
uiGradient.Rotation = 90
uiGradient.Parent = Main

-- Sombra interna (simula profundidade)
local innerStroke = Instance.new("UIStroke")
innerStroke.Color = Color3.fromRGB(8, 14, 22)
innerStroke.Thickness = 1
innerStroke.Transparency = 0.6
innerStroke.Parent = Main

-- Título estilizado
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "ZK HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(200, 235, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Botão de fechar estilizado
local Close = Instance.new("ImageButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 36, 0, 36)
Close.Position = UDim2.new(1, -46, 0, 8)
Close.AnchorPoint = Vector2.new(0,0)
Close.BackgroundColor3 = Color3.fromRGB(100, 170, 255)
Close.BackgroundTransparency = 0
Close.BorderSizePixel = 0
Close.Image = "" -- pode colocar um X como Image
Close.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

local CloseLabel = Instance.new("TextLabel")
CloseLabel.Size = UDim2.new(1,0,1,0)
CloseLabel.BackgroundTransparency = 1
CloseLabel.Text = "✕"
CloseLabel.TextColor3 = Color3.fromRGB(12, 22, 36)
CloseLabel.Font = Enum.Font.GothamBold
CloseLabel.TextScaled = true
CloseLabel.Parent = Close

-- Container de conteúdo
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -64)
content.Position = UDim2.new(0, 10, 0, 54)
content.BackgroundTransparency = 1
content.Parent = Main

-- Exemplo de texto
local exampleText = Instance.new("TextLabel")
exampleText.Size = UDim2.new(1, 0, 0, 24)
exampleText.Position = UDim2.new(0, 0, 0, 0)
exampleText.BackgroundTransparency = 1
exampleText.Text = "Conteúdo do painel aqui..."
exampleText.TextColor3 = Color3.fromRGB(200, 220, 235)
exampleText.Font = Enum.Font.Gotham
exampleText.TextSize = 16
exampleText.TextXAlignment = Enum.TextXAlignment.Left
exampleText.Parent = content

-- Estado e funções de mostrar/ocultar com animação
local isVisible = false
local shownPos = MAIN_SHOW_POS
local hiddenPos = MAIN_HIDDEN_POS

local function showPanel()
	if isVisible then return end
	Main.Position = hiddenPos
	Main.Visible = true
	TweenService:Create(Main, TWEEN_INFO, {Position = shownPos}):Play()
	isVisible = true
end

local function hidePanel()
	if not isVisible then return end
	TweenService:Create(Main, TWEEN_INFO, {Position = hiddenPos}):Play()
	-- delay para esconder após a animação
	delay(TWEEN_INFO.Time, function()
		Main.Visible = false
	end)
	isVisible = false
end

local function togglePanel()
	if isVisible then hidePanel() else showPanel() end
end

-- Clique no botão abre/fecha (com pequena animação no botão)
OpenButton.MouseButton1Click:Connect(function()
	-- animação visual do botão
	local t = TweenService:Create(OpenButton, TweenInfo.new(0.08), {BackgroundTransparency = 0.25})
	t:Play()
	local tween = TweenService:Create(OpenButton, TweenInfo.new(0.08), {BackgroundTransparency = 0.12})
	tween:Play()
	-- alterna painel
	togglePanel()
end)

-- Close button
Close.MouseButton1Click:Connect(function()
	hidePanel()
end)

-- Permitir arrastar o botão (apenas com mouse / PC)
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

-- Atalho RightControl para abrir/fechar (útil no PC)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightControl then
		togglePanel()
	end
end)

-- Inicial: anima o botão levemente
TweenService:Create(OpenButton, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = OpenButton.Position}):Play()

-- FIM
