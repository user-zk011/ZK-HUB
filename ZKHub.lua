-- ZK HUB – New Diamond Tech UI (100% funcional)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- REMOVE GUI ANTIGA
local old = playerGui:FindFirstChild("ZKHUB")
if old then old:Destroy() end

-- CRIA GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ZKHUB"
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- BOTÃO DE ABRIR
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 80, 0, 80)
openBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
openBtn.Text = "ZK"
openBtn.TextColor3 = Color3.fromRGB(0,0,0)
openBtn.TextSize = 40
openBtn.Font = Enum.Font.GothamBlack
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200,255,255)
stroke.Thickness = 3
stroke.Parent = openBtn

-- PAINEL
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 500, 0, 350)
panel.BackgroundColor3 = Color3.fromRGB(10,20,30)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, -1, 0) -- COMEÇA FORA DA TELA
panel.Parent = gui
panel.Visible = true
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)

local ps = Instance.new("UIStroke")
ps.Color = Color3.fromRGB(0,255,255)
ps.Thickness = 3
ps.Parent = panel

-- TÍTULO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "ZK HUB"
title.TextColor3 = Color3.fromRGB(200,255,255)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

-- BOTÃO FECHAR
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(0,255,255)
closeBtn.Text = "X"
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(0,0,0)
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.Parent = panel
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

-- ANIMAÇÃO
local openPos = UDim2.new(0.5, 0, 0.5, 0)
local closePos = UDim2.new(0.5, 0, -1, 0)
local info = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local isOpen = false
local function toggle()
	isOpen = not isOpen
	TweenService:Create(panel, info, {Position = isOpen and openPos or closePos}):Play()
end

openBtn.MouseButton1Click:Connect(toggle)
closeBtn.MouseButton1Click:Connect(toggle)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		toggle()
	end
end)
