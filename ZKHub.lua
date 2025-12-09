--============================================================
-- ZK HUB - DiamondTech UI (Botão com pulso + Painel funcional)
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

-- SCREEN GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ZKHUB"
gui.IgnoreGuiInset = true
gui.Parent = playerGui

--============================================================
-- BOTÃO ZK COM PULSO
--============================================================
local openBtn = Instance.new("Frame")
openBtn.Size = UDim2.new(0, 60, 0, 60) -- tamanho menor
openBtn.Position = UDim2.new(0.1,0,0.4,0)
openBtn.AnchorPoint = Vector2.new(0.5,0.5)
openBtn.BackgroundTransparency = 1
openBtn.Parent = gui

-- CIRCULO PULSANTE ATRÁS (3 círculos)
local pulseCircles = {}
for i=1,3 do
    local pulse = Instance.new("Frame")
    pulse.Size = UDim2.new(1,0,1,0)
    pulse.Position = UDim2.new(0,0,0,0)
    pulse.BackgroundColor3 = Color3.fromRGB(0,255,255)
    pulse.BackgroundTransparency = 0.8 - (i*0.2)
    pulse.ZIndex = 0
    pulse.Parent = openBtn
    local corner = Instance.new("UICorner", pulse)
    corner.CornerRadius = UDim.new(1,0)
    table.insert(pulseCircles, pulse)
end

-- CIRCULO PRINCIPAL
local mainCircle = Instance.new("Frame")
mainCircle.Size = UDim2.new(1,0,1,0)
mainCircle.Position = UDim2.new(0,0,0,0)
mainCircle.BackgroundColor3 = Color3.fromRGB(0,255,255)
mainCircle.ZIndex = 1
mainCircle.Parent = openBtn
local corner = Instance.new("UICorner", mainCircle)
corner.CornerRadius = UDim.new(1,0)

-- TEXTO ZK
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.Text = "ZK"
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Font = Enum.Font.GothamBlack
label.TextSize = 30
label.Parent = mainCircle

-- ANIMAÇÃO PULSO
for i,pulse in ipairs(pulseCircles) do
    coroutine.wrap(function()
        while true do
            pulse:TweenSizeAndPosition(
                UDim2.new(1.4,0,1.4,0),
                UDim2.new(-0.2,0,-0.2,0),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                1 + i*0.2,
                true
            )
            wait(1 + i*0.2)
            pulse:TweenSizeAndPosition(
                UDim2.new(1,0,1,0),
                UDim2.new(0,0,0,0),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                1 + i*0.2,
                true
            )
            wait(1 + i*0.2)
        end
    end)()
end

--============================================================
-- PAINEL
--============================================================
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 500, 0, 350) -- proporcional
panel.Position = UDim2.new(0.5,0,-1,0) -- escondido inicialmente
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(10,15,25)
panel.Parent = gui
local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0,12)

-- CABEÇALHO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,40)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "ZK HUB"
title.TextColor3 = Color3.fromRGB(200,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,40,0,40)
closeBtn.Position = UDim2.new(1,-50,0,10)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 24
closeBtn.BackgroundColor3 = Color3.fromRGB(0,255,255)
closeBtn.TextColor3 = Color3.fromRGB(0,0,0)
closeBtn.Parent = panel
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(1,0)

--============================================================
-- FUNÇÃO ABRIR/FECHAR PAINEL
--============================================================
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local openPos = UDim2.new(0.5,0,0.5,0)
local closePos = UDim2.new(0.5,0,-1,0)
local isOpen = false

local function togglePanel()
    isOpen = not isOpen
    TweenService:Create(panel, tweenInfo, {Position = isOpen and openPos or closePos}):Play()
end

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        togglePanel()
    end
end)
closeBtn.MouseButton1Click:Connect(togglePanel)

UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        togglePanel()
    end
end)

--============================================================
-- BOTÃO ZK ARRASTÁVEL
--============================================================
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

--============================================================
-- PAINEL ARRASTÁVEL
--============================================================
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
