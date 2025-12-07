-- ZK HUB - Versão ajustada
-- Cole este script em StarterGui (ou StarterPlayerScripts) no Roblox Studio.
-- Se a imagem não aparecer no jogo, faça upload no Roblox e substitua IMAGE_URL por "rbxassetid://<ID>".

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
local OPEN_BTN_SIZE = UDim2.new(0, 64, 0, 64)
local MAIN_SIZE = UDim2.new(0, 440, 0, 320) -- painel maior
local MAIN_SHOW_POS = UDim2.new(0.5, -220, 0.5, -160)
local MAIN_HIDDEN_POS = UDim2.new(0.5, -220, -0.9, 0)
local TWEEN_INFO = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Theme colors (mais vivo, verde-água / aqua)
local THEME = Color3.fromRGB(64, 224, 208)     -- forte aqua
local THEME_DARK = Color3.fromRGB(10, 120, 110) -- tom mais escuro para acentuação
local BORDER_LIGHT = Color3.fromRGB(180, 255, 248)
local TITLE_COLOR = Color3.fromRGB(220, 255, 250)

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
OpenButton.BackgroundColor3 = THEME
OpenButton.BackgroundTransparency = 0
OpenButton.BorderSizePixel = 0
OpenButton.AutoButtonColor = true
OpenButton.Image = "" -- sem imagem de fundo
OpenButton.Parent = ScreenGui
OpenButton.AnchorPoint = Vector2.new(0, 0)

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0) -- totalmente circular
openCorner.Parent = OpenButton

-- Borda azul/água clara no botão
local openStroke = Instance.new("UIStroke")
openStroke.Color = BORDER_LIGHT
openStroke.Thickness = 2
openStroke.Transparency = 0
openStroke.Parent = OpenButton

-- Sombra sutil (fundo translúcido) para destacar
local openShadow = Instance.new("Frame")
openShadow.Name = "OpenShadow"
openShadow.Size = UDim2.new(1, 8, 1, 8)
openShadow.Position = UDim2.new(0, -4, 0, -4)
openShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
openShadow.BackgroundTransparency = 0.85
openShadow.ZIndex = OpenButton.ZIndex - 1
openShadow.Parent = OpenButton
local openShadowCorner = Instance.new("UICorner")
openShadowCorner.CornerRadius = UDim.new(1,0)
openShadowCorner.Parent = openShadow

-- Logo central no botão (garantir que encaixe)
local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 44, 0, 44)
logo.Position = UDim2.new(0.5, 0, 0.5, 0)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.BackgroundTransparency = 1
logo.Image = IMAGE_URL
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = OpenButton

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logo

-- Caso a imagem externa não carregue em runtime, deixe uma cor de fallback no centro
local logoBg = Instance.new("Frame")
logoBg.Size = UDim2.new(0, 44, 0, 44)
logoBg.Position = UDim2.new(0.5, 0, 0.5, 0)
logoBg.AnchorPoint = Vector2.new(0.5, 0.5)
logoBg.BackgroundColor3 = THEME_DARK
logoBg.BackgroundTransparency = 1 -- transparente por padrão (só visual de fallback)
logoBg.ZIndex = logo.ZIndex - 1
logoBg.Parent = OpenButton
local logoBgCorner = Instance.new("UICorner")
logoBgCorner.CornerRadius = UDim.new(1,0)
logoBgCorner.Parent = logoBg

-- Main panel (painel central)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = MAIN_SIZE
Main.Position = MAIN_HIDDEN_POS
Main.AnchorPoint = Vector2.new(0,0)
Main.BackgroundColor3 = Color3.fromRGB(12, 22, 36) -- fundo escuro
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui
Main.ZIndex = 2

-- Cantos arredondados
local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 14)
UICornerMain.Parent = Main

-- Borda clara aqua usando UIStroke (mais moderno)
local border = Instance.new("UIStroke")
border.Color = THEME
border.Thickness = 3
border.Parent = Main

-- Gradiente sutil no fundo (preservando estilo)
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(18,26,38)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(12,20,32))
}
uiGradient.Rotation = 90
uiGradient.Parent = Main

-- Sombra interna leve
local innerStroke = Instance.new("UIStroke")
innerStroke.Color = Color3.fromRGB(6, 12, 18)
innerStroke.Thickness = 1
innerStroke.Transparency = 0.7
innerStroke.Parent = Main

-- Título estilizado (com cor aqua)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -24, 0, 44)
Title.Position = UDim2.new(0, 12, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "ZK HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = TITLE_COLOR
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Botão de fechar estilizado (circular, com X bem visível)
local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -54, 0, 10)
Close.AnchorPoint = Vector2.new(0,0)
Close.BackgroundColor3 = THEME
Close.BackgroundTransparency = 0
Close.BorderSizePixel = 0
Close.AutoButtonColor = true
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(12, 22, 26)
Close.Font = Enum.Font.GothamBold
Close.TextScaled = true
Close.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = Close

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = BORDER_LIGHT
closeStroke.Thickness = 2
closeStroke.Parent = Close

-- Container de conteúdo
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -24, 1, -80)
content.Position = UDim2.new(0, 12, 0, 58)
content.BackgroundTransparency = 1
content.Parent = Main

-- Exemplo de texto
local exampleText = Instance.new("TextLabel")
exampleText.Size = UDim2.new(1, 0, 0, 26)
exampleText.Position = UDim2.new(0, 0, 0, 0)
exampleText.BackgroundTransparency = 1
exampleText.Text = "Conteúdo do painel aqui..."
exampleText.TextColor3 = Color3.fromRGB(200, 230, 225)
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
	-- efeito rápido de clique
	local t1 = TweenService:Create(OpenButton, TweenInfo.new(0.08), {Size = UDim2.new(0, 58, 0, 58)})
	t1:Play()
	t1.Completed:Wait()
	local t2 = TweenService:Create(OpenButton, TweenInfo.new(0.08), {Size = OPEN_BTN_SIZE})
	t2:Play()
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

-- Inicial: animações de entrada leves
OpenButton.Position = OpenButton.Position
TweenService:Create(OpenButton, TweenInfo.new(0.45, Enum.EasingStyle.Back), {Rotation = 0}):Play()

-- FIM
