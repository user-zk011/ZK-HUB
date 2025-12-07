-- ZK HUB - Versão final ajustada (LocalScript)
-- Cole este script em StarterGui (ou StarterPlayerScripts) no Roblox Studio.
-- IMPORTANTE: Para garantir que a imagem apareça em runtime, faça upload da imagem no Roblox e troque IMAGE_RBX_ASSET
-- por "rbxassetid://<ID>". Eu incluí uma tentativa de PreloadAsync para detectar falha e mostrar um fallback legível.

-- Como pegar rbxassetid de uma imagem:
-- 1) No Roblox Studio -> View -> Asset Manager.
-- 2) Clique com o direito em "Images" -> "Add Image..." -> envie sua imagem.
-- 3) Depois de enviada, clique com o direito na imagem -> "Copy Asset ID". Use "rbxassetid://<ID>".

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

-- CONFIG
local OPEN_BTN_SIZE = UDim2.new(0, 70, 0, 70)
local MAIN_SIZE = UDim2.new(0, 520, 0, 360) -- painel maior
local MAIN_SHOW_POS = UDim2.new(0.5, -260, 0.5, -180)
local MAIN_HIDDEN_POS = UDim2.new(0.5, -260, -1.0, 0)
local TWEEN_INFO = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Tema aqua/verde-água mais vivo
local THEME = Color3.fromRGB(64, 224, 208)
local THEME_DARK = Color3.fromRGB(10, 120, 110)
local BORDER_LIGHT = Color3.fromRGB(175, 255, 250)
local TITLE_COLOR = Color3.fromRGB(230, 255, 252)
local PANEL_BG = Color3.fromRGB(8, 14, 20) -- fundo do painel

-- Substitua por "rbxassetid://<ID>" após upload no Asset Manager.
local IMAGE_RBX_ASSET = "rbxassetid://0" -- troque para rbxassetid do seu upload, ex: "rbxassetid://123456789"

-- Se quiser testar com URL direto (nem sempre carrega em runtime), coloque a URL aqui:
local IMAGE_URL_FALLBACK = "https://cdn.ereemby.com/attachments/17631336254632667imagem.png"

-- cleanup (útil no Studio)
local existing = playerGui:FindFirstChild("ZKHubGui")
if existing then existing:Destroy() end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZKHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui
ScreenGui.IgnoreGuiInset = true

-- ---------- Open Button (circular, com logo) ----------
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = OPEN_BTN_SIZE
OpenButton.Position = UDim2.new(0.03, 0, 0.38, 0)
OpenButton.BackgroundColor3 = THEME
OpenButton.BackgroundTransparency = 0
OpenButton.BorderSizePixel = 0
OpenButton.AutoButtonColor = true
OpenButton.Image = "" -- sem imagem de background
OpenButton.Parent = ScreenGui
OpenButton.AnchorPoint = Vector2.new(0, 0)
OpenButton.ZIndex = 5

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = OpenButton

-- Glow / borda clara
local openStroke = Instance.new("UIStroke")
openStroke.Color = BORDER_LIGHT
openStroke.Thickness = 3
openStroke.Transparency = 0
openStroke.Parent = OpenButton

-- Drop shadow (separate frame behind)
local openShadow = Instance.new("Frame")
openShadow.Name = "OpenShadow"
openShadow.Size = UDim2.new(1, 10, 1, 10)
openShadow.Position = UDim2.new(0, -5, 0, -5)
openShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
openShadow.BackgroundTransparency = 0.85
openShadow.BorderSizePixel = 0
openShadow.ZIndex = OpenButton.ZIndex - 1
openShadow.Parent = OpenButton
local openShadowCorner = Instance.new("UICorner")
openShadowCorner.CornerRadius = UDim.new(1,0)
openShadowCorner.Parent = openShadow

-- Logo container (visível sempre; imagem pode ou não carregar)
local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 48, 0, 48)
logo.Position = UDim2.new(0.5, 0, 0.5, 0)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.BackgroundTransparency = 1
logo.Image = IMAGE_RBX_ASSET ~= "rbxassetid://0" and IMAGE_RBX_ASSET or IMAGE_URL_FALLBACK
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = OpenButton
logo.ZIndex = OpenButton.ZIndex + 1

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logo

-- fallback text (mostra iniciais se a imagem falhar)
local logoFallback = Instance.new("TextLabel")
logoFallback.Name = "LogoFallback"
logoFallback.Size = UDim2.new(0, 48, 0, 48)
logoFallback.Position = logo.Position
logoFallback.AnchorPoint = logo.AnchorPoint
logoFallback.BackgroundColor3 = Color3.fromRGB(10,120,110)
logoFallback.BackgroundTransparency = 0
logoFallback.Font = Enum.Font.GothamBold
logoFallback.Text = "ZK"
logoFallback.TextColor3 = Color3.fromRGB(220,255,250)
logoFallback.TextScaled = true
logoFallback.Visible = false
logoFallback.Parent = OpenButton
local logoFallbackCorner = Instance.new("UICorner")
logoFallbackCorner.CornerRadius = UDim.new(1,0)
logoFallbackCorner.Parent = logoFallback

-- ---------- Main Panel (com sombra, borda aqua, gradiente) ----------
local MainShadow = Instance.new("Frame")
MainShadow.Name = "MainShadow"
MainShadow.Size = MAIN_SIZE + UDim2.new(0, 10, 0, 10)
MainShadow.Position = UDim2.new(MAIN_SHOW_POS.X.Scale, MAIN_SHOW_POS.X.Offset - 5, MAIN_SHOW_POS.Y.Scale, MAIN_SHOW_POS.Y.Offset - 5)
MainShadow.AnchorPoint = Vector2.new(0,0)
MainShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainShadow.BackgroundTransparency = 0.82
MainShadow.BorderSizePixel = 0
MainShadow.Visible = false
MainShadow.Parent = ScreenGui
local MainShadowCorner = Instance.new("UICorner")
MainShadowCorner.CornerRadius = UDim.new(0, 18)
MainShadowCorner.Parent = MainShadow

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = MAIN_SIZE
Main.Position = MAIN_HIDDEN_POS
Main.AnchorPoint = Vector2.new(0,0)
Main.BackgroundColor3 = PANEL_BG
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui
Main.ZIndex = 4

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 18)
UICornerMain.Parent = Main

-- Borda viva aqua
local border = Instance.new("UIStroke")
border.Color = THEME
border.Thickness = 4
border.Parent = Main

-- Gradiente sutil
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(14,20,28)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8,14,20))
}
uiGradient.Rotation = 90
uiGradient.Parent = Main

-- Top title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -28, 0, 52)
Title.Position = UDim2.new(0, 16, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "ZK HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = TITLE_COLOR
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Close circular button (melhor X)
local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 44, 0, 44)
Close.Position = UDim2.new(1, -64, 0, 14)
Close.BackgroundColor3 = THEME
Close.AutoButtonColor = true
Close.BorderSizePixel = 0
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextScaled = true
Close.TextColor3 = Color3.fromRGB(8, 12, 14)
Close.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = Close

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = BORDER_LIGHT
CloseStroke.Thickness = 2
CloseStroke.Parent = Close

-- content container
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -32, 1, -92)
content.Position = UDim2.new(0, 16, 0, 70)
content.BackgroundTransparency = 1
content.Parent = Main

local exampleText = Instance.new("TextLabel")
exampleText.Size = UDim2.new(1, 0, 0, 28)
exampleText.Position = UDim2.new(0, 0, 0, 0)
exampleText.BackgroundTransparency = 1
exampleText.Text = "Bem-vindo ao ZK HUB — adicione seus botões/abas aqui."
exampleText.TextColor3 = Color3.fromRGB(200, 240, 235)
exampleText.Font = Enum.Font.Gotham
exampleText.TextSize = 16
exampleText.TextXAlignment = Enum.TextXAlignment.Left
exampleText.Parent = content

-- ---------- Estado e funções ----------
local isVisible = false
local shownPos = MAIN_SHOW_POS
local hiddenPos = MAIN_HIDDEN_POS

local function showPanel()
	if isVisible then return end
	Main.Position = hiddenPos
	Main.Visible = true
	MainShadow.Visible = true
	TweenService:Create(Main, TWEEN_INFO, {Position = shownPos}):Play()
	TweenService:Create(MainShadow, TWEEN_INFO, {Position = UDim2.new(shownPos.X.Scale, shownPos.X.Offset - 5, shownPos.Y.Scale, shownPos.Y.Offset - 5)}):Play()
	isVisible = true
end

local function hidePanel()
	if not isVisible then return end
	TweenService:Create(Main, TWEEN_INFO, {Position = hiddenPos}):Play()
	TweenService:Create(MainShadow, TWEEN_INFO, {Position = UDim2.new(hiddenPos.X.Scale, hiddenPos.X.Offset - 5, hiddenPos.Y.Scale, hiddenPos.Y.Offset - 5)}):Play()
	delay(TWEEN_INFO.Time, function()
		Main.Visible = false
		MainShadow.Visible = false
	end)
	isVisible = false
end

local function togglePanel()
	if isVisible then hidePanel() else showPanel() end
end

-- ---------- Button interactions ----------
OpenButton.MouseButton1Click:Connect(function()
	-- clique com pequena animação
	local t1 = TweenService:Create(OpenButton, TweenInfo.new(0.08), {Size = UDim2.new(0, 62, 0, 62)})
	t1:Play()
	t1.Completed:Wait()
	local t2 = TweenService:Create(OpenButton, TweenInfo.new(0.12), {Size = OPEN_BTN_SIZE})
	t2:Play()
	togglePanel()
end)
Close.MouseButton1Click:Connect(function()
	hidePanel()
end)

-- Arrastar do OpenButton (PC)
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
	-- also move shadow with it
	openShadow.Position = UDim2.new(0, -5, 0, -5)
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

-- Atalho RightControl para abrir/fechar (PC)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightControl then
		togglePanel()
	end
end)

-- ---------- Try preload image; show fallback if fails ----------
spawn(function()
	local assetToTry = nil
	if IMAGE_RBX_ASSET and IMAGE_RBX_ASSET ~= "rbxassetid://0" then
		assetToTry = IMAGE_RBX_ASSET
	else
		-- if no rbx id set, try external url (may fail on normal client)
		assetToTry = IMAGE_URL_FALLBACK
	end

	-- set the image so Studio shows it; then try to preload
	logo.Image = assetToTry

	local ok, err = pcall(function()
		ContentProvider:PreloadAsync({logo})
	end)
	if not ok then
		-- preload failed: use fallback text and hide image
		logo.Visible = false
		logoFallback.Visible = true
	else
		-- preload succeeded: ensure logo visible, hide fallback
		logo.Visible = true
		logoFallback.Visible = false
	end
end)

-- Inicial: animações suaves de entrada do botão
TweenService:Create(OpenButton, TweenInfo.new(0.45, Enum.EasingStyle.Back), {Position = OpenButton.Position}):Play()

-- FIM
