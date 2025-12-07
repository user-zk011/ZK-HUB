-- ⛔ Anti-duplicação
if getgenv().ZK_LOADED then return end
getgenv().ZK_LOADED = true

-- UI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

-- Botão de abrir
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(0.03, 0, 0.4, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 80, 200)
OpenButton.Text = "≡"
OpenButton.TextScaled = true
OpenButton.TextColor3 = Color3.fromRGB(255,255,255)
OpenButton.Parent = ScreenGui
OpenButton.BackgroundTransparency = 0.2
OpenButton.AutoButtonColor = true

-- Retângulo do MENU
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 260)
Main.Position = UDim2.new(0.5, -190, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(12, 22, 36) -- azul escuro cinza
Main.BorderColor3 = Color3.fromRGB(100, 170, 255) -- azul claro
Main.BorderSizePixel = 3
Main.Visible = false
Main.Parent = ScreenGui

-- Cantos arredondados
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "ZK HUB"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(180, 220, 255)
Title.Parent = Main

-- Botão fechar
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -40, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(100, 170, 255)
Close.Text = "X"
Close.TextScaled = true
Close.TextColor3 = Color3.fromRGB(0,0,0)
Close.Parent = Main

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = Close

-- Comportamentos
OpenButton.MouseButton1Click:Connect(function()
	Main.Visible = true
end)

Close.MouseButton1Click:Connect(function()
	Main.Visible = false
end)
