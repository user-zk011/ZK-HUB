--============================================================
-- ZK HUB - FUTURE EDITION (Círculo Futurista + ESP Real)
--============================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- REMOVE HUB ANTIGO
local old = playerGui:FindFirstChild("ZKHUB")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "ZKHUB"
gui.IgnoreGuiInset = true
gui.Parent = playerGui

----------------------------------------------------------
-- BOTÃO ABRIR (CÍRCULO FUTURISTA + ZK DEGRADÊ)
----------------------------------------------------------

local openBtn = Instance.new("Frame")
openBtn.Size = UDim2.new(0, 110, 0, 110)
openBtn.Position = UDim2.new(0.10, 0, 0.40, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(5, 10, 25)
openBtn.Parent = gui

local openCorner = Instance.new("UICorner", openBtn)
openCorner.CornerRadius = UDim.new(1, 0)

-- BRILHO EXTERNO
local glowStroke = Instance.new("UIStroke")
glowStroke.Color = Color3.fromRGB(0, 200, 255)
glowStroke.Thickness = 6
glowStroke.Parent = openBtn

-- CÍRCULO INTERNO
local innerStroke = Instance.new("UIStroke")
innerStroke.Color = Color3.fromRGB(0, 120, 255)
innerStroke.Thickness = 2
innerStroke.Parent = openBtn

-- TEXTO ZK DEGRADE
local zk = Instance.new("TextLabel")
zk.Size = UDim2.new(1, 0, 1, 0)
zk.BackgroundTransparency = 1
zk.Text = "ZK"
zk.TextSize = 50
zk.Font = Enum.Font.GothamBlack
zk.Parent = openBtn

local grad = Instance.new("UIGradient", zk)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,180,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,80,255))
}

----------------------------------------------------------
-- BOTÃO ABRIR - FUNÇÃO DRAG
----------------------------------------------------------

local dragging = false
local dragStart, startPos

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = openBtn.Position
    end
end)

openBtn.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        openBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

----------------------------------------------------------
-- PAINEL - ESTILO FUTURISTA CÍRCULO AZUL
----------------------------------------------------------

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 550, 0, 380)
panel.BackgroundColor3 = Color3.fromRGB(5, 10, 20)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.Position = UDim2.new(0.5,0,-1,0)
panel.Parent = gui

local pcorner = Instance.new("UICorner", panel)
pcorner.CornerRadius = UDim.new(0, 25)

-- STROKE 1 (AZUL FORTE)
local pStroke1 = Instance.new("UIStroke")
pStroke1.Color = Color3.fromRGB(0,150,255)
pStroke1.Thickness = 5
pStroke1.Parent = panel

-- STROKE 2 (AZUL CLARO GLOW)
local pStroke2 = Instance.new("UIStroke")
pStroke2.Color = Color3.fromRGB(0,220,255)
pStroke2.Thickness = 2
pStroke2.Parent = panel

-- GRADIENTE
local pGrad = Instance.new("UIGradient", panel)
pGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,80,160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,200,255))
}
pGrad.Rotation = 90

----------------------------------------------------------
-- CABEÇALHO
----------------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "ZK HUB - Roube um Brainrot"
title.TextColor3 = Color3.fromRGB(0,200,255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1,-50,0,10)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 24
closeBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
closeBtn.Parent = panel
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

----------------------------------------------------------
-- MENU
----------------------------------------------------------

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 150, 1, -60)
menu.Position = UDim2.new(0,10,0,60)
menu.BackgroundColor3 = Color3.fromRGB(8,17,30)
menu.Parent = panel
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,10)

local list = Instance.new("UIListLayout", menu)
list.Padding = UDim.new(0,10)

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-180,1,-60)
content.Position = UDim2.new(0,170,0,60)
content.BackgroundTransparency = 1
content.Parent = panel

local categories = {}
local currentCategory = nil

function newCategory(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    btn.Text = name
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.GothamBlack
    btn.BackgroundTransparency = 0.2
    btn.Parent = menu
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.Visible = false
    frame.Parent = content

    btn.MouseButton1Click:Connect(function()
        if currentCategory then currentCategory.Visible = false end
        currentCategory = frame
        frame.Visible = true
    end)

    return frame
end

----------------------------------------------------------
-- CATEGORIA PRINCIPAL
----------------------------------------------------------

local catMain = newCategory("Principal")

----------------------------------------------------------
-- ESP PLAYER REAL (FUNÇÃO CERTA)
----------------------------------------------------------

local espEnabled = false

local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0,200,0,40)
espLabel.Position = UDim2.new(0,20,0,20)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP Player"
espLabel.TextColor3 = Color3.fromRGB(0,200,255)
espLabel.TextSize = 20
espLabel.Font = Enum.Font.GothamBold
espLabel.Parent = catMain

local espSwitch = Instance.new("TextButton")
espSwitch.Size = UDim2.new(0,80,0,40)
espSwitch.Position = UDim2.new(0,230,0,20)
espSwitch.BackgroundColor3 = Color3.fromRGB(40,70,90)
espSwitch.Text = "OFF"
espSwitch.TextColor3 = Color3.fromRGB(255,255,255)
espSwitch.TextSize = 18
espSwitch.Font = Enum.Font.GothamBlack
espSwitch.Parent = catMain
Instance.new("UICorner", espSwitch).CornerRadius = UDim.new(1,0)

-----------------------------
-- FUNÇÕES DO ESP REAL
-----------------------------

function applyESP(char)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.ForceField
            part.Color = Color3.fromRGB(0,150,255)
            part.Transparency = 0.1
        end
    end
end

function removeESP(char)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Plastic
            part.Transparency = 0
        end
    end
end

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                applyESP(p.Character)
            end
        end
    end
end)

espSwitch.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espSwitch.Text = espEnabled and "ON" or "OFF"
    espSwitch.BackgroundColor3 = espEnabled and Color3.fromRGB(0,200,255) or Color3.fromRGB(40,70,90)
end)

----------------------------------------------------------
-- ANIMAÇÃO DO PAINEL
----------------------------------------------------------

local openPos = UDim2.new(0.5,0,0.5,0)
local closePos = UDim2.new(0.5,0,-1,0)
local anim = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local isOpen = false

local function toggle()
    isOpen = not isOpen
    TweenService:Create(panel, anim, {Position = isOpen and openPos or closePos}):Play()
end

openBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        toggle()
    end
end)

closeBtn.MouseButton1Click:Connect(toggle)

UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        toggle()
    end
end)
