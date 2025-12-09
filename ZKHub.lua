--============================================================
-- ZK HUB - DiamondTech UI Atualizado
--============================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- REMOVE ANTIGO
local old = playerGui:FindFirstChild("ZKHUB")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "ZKHUB"
gui.IgnoreGuiInset = true
gui.Parent = playerGui

----------------------------------------------------------
-- BOTÃO ABRIR (ZK) COM PULSO SUAVE
----------------------------------------------------------
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 70, 0, 70)
openBtn.Position = UDim2.new(0.12, 0, 0.40, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
openBtn.Text = "ZK"
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.TextSize = 38
openBtn.Font = Enum.Font.GothamBlack
openBtn.Parent = gui
local btnCorner = Instance.new("UICorner", openBtn)
btnCorner.CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200,255,255)
stroke.Thickness = 2
stroke.Parent = openBtn

-- Efeito pulsante suave
local pulseCircles = {}
for i=1,3 do
    local pulse = Instance.new("Frame")
    pulse.Size = UDim2.new(1,0,1,0)
    pulse.Position = UDim2.new(0,0,0,0)
    pulse.BackgroundColor3 = Color3.fromRGB(0,150,255)
    pulse.BackgroundTransparency = 0.7 - (i*0.2)
    pulse.ZIndex = 0
    pulse.Parent = openBtn
    pulseCl = Instance.new("UICorner", pulse)
    pulseCl.CornerRadius = UDim.new(1,0)
    table.insert(pulseCircles,pulse)
end

for i,pulse in ipairs(pulseCircles) do
    coroutine.wrap(function()
        while true do
            local targetSize = UDim2.new(1.3,0,1.3,0)
            local targetPos = UDim2.new(-0.15,0,-0.15,0)
            local tween = TweenService:Create(pulse, TweenInfo.new(1.4 + i*0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Size = targetSize,
                Position = targetPos
            })
            tween:Play()
            tween.Completed:Wait()
        end
    end)()
end

----------------------------------------------------------
-- PAINEL (draggable, com contorno fino)
----------------------------------------------------------
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 500, 0, 350)
panel.BackgroundColor3 = Color3.fromRGB(10,25,40)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.Position = UDim2.new(0.5,0,-1,0)
panel.Parent = gui
local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0,15)

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(0,150,255)
panelStroke.Thickness = 2
panelStroke.Parent = panel

----------------------------------------------------------
-- CABEÇALHO COM DEGRADÊ HORIZONTAL
----------------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "ZK HUB"
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

-- Criando Degradê Horizontal para título
local grad = Instance.new("UIGradient")
grad.Rotation = 0
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150,220,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,120,255))
}
grad.Parent = title

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1,-50,0,10)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 24
closeBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = panel
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

----------------------------------------------------------
-- MENU LATERAL
----------------------------------------------------------
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 150, 1, -60)
menu.Position = UDim2.new(0,10,0,60)
menu.BackgroundColor3 = Color3.fromRGB(15,30,50)
menu.Parent = panel
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,10)

local list = Instance.new("UIListLayout")
list.Parent = menu
list.Padding = UDim.new(0,10)

----------------------------------------------------------
-- ÁREA DE CONTEÚDO
----------------------------------------------------------
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
    btn.BackgroundTransparency = 0.8
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBlack
    btn.Parent = menu
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.Visible = false
    frame.Parent = content

    btn.MouseButton1Click:Connect(function()
        if currentCategory then currentCategory.Visible = false end
        frame.Visible = true
        currentCategory = frame
    end)

    return frame
end

----------------------------------------------------------
-- CATEGORIAS EXEMPLO
----------------------------------------------------------
local cat1 = newCategory("Principal")
newCategory("Visual")
newCategory("Jogador")
newCategory("Mundo")
newCategory("Extras")

----------------------------------------------------------
-- EXEMPLO DE TEXTO INTERNO
----------------------------------------------------------
local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0,200,0,40)
espLabel.Position = UDim2.new(0,20,0,20)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP Player"
espLabel.TextColor3 = Color3.fromRGB(200,255,255)
espLabel.TextSize = 20
espLabel.Font = Enum.Font.GothamBold
espLabel.Parent = cat1

----------------------------------------------------------
-- FUNÇÃO ESP PLAYER SIMPLES
----------------------------------------------------------
local espEnabled = false

local espSwitch = Instance.new("TextButton")
espSwitch.Size = UDim2.new(0,80,0,40)
espSwitch.Position = UDim2.new(0,230,0,20)
espSwitch.BackgroundColor3 = Color3.fromRGB(40,70,90)
espSwitch.Text = "OFF"
espSwitch.TextColor3 = Color3.fromRGB(255,255,255)
espSwitch.TextSize = 18
espSwitch.Font = Enum.Font.GothamBlack
espSwitch.Parent = cat1
Instance.new("UICorner", espSwitch).CornerRadius = UDim.new(1,0)

function applyESP(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.ForceField
            part.Color = Color3.fromRGB(0,150,255)
            part.Transparency = 0.6
        end
    end
end

function removeESP(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Plastic
            part.Transparency = 0
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                applyESP(p.Character)
            end
        end
    end
end)

espSwitch.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espSwitch.Text = espEnabled and "ON" or "OFF"
    espSwitch.BackgroundColor3 = espEnabled and Color3.fromRGB(0,150,255) or Color3.fromRGB(40,70,90)
end)

----------------------------------------------------------
-- ANIMAÇÃO DO PAINEL
----------------------------------------------------------
local openPos = UDim2.new(0.5,0,0.5,0)
local closePos = UDim2.new(0.5,0,-1,0)
local info = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local isOpen = false
local function toggle()
    isOpen = not isOpen
    TweenService:Create(panel, info, {Position = isOpen and openPos or closePos}):Play()
end

openBtn.MouseButton1Click:Connect(toggle)
closeBtn.MouseButton1Click:Connect(toggle)

----------------------------------------------------------
-- ABRIR COM CONTROLS
----------------------------------------------------------
UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        toggle()
    end
end)

----------------------------------------------------------
-- DRAGGABLE BOTÃO
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
openBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        openBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

----------------------------------------------------------
-- DRAGGABLE PAINEL
----------------------------------------------------------
local dragging2 = false
local dragStart2, startPos2
panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = true
        dragStart2 = input.Position
        startPos2 = panel.Position
    end
end)
panel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging2 and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart2
        panel.Position = UDim2.new(
            startPos2.X.Scale, startPos2.X.Offset + delta.X,
            startPos2.Y.Scale, startPos2.Y.Offset + delta.Y
        )
    end
end)
