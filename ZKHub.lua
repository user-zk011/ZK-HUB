--==-----------------------------------------------------------
-- ZK HUB – DiamondTech Version (Draggable + ESP + Categories)
--==-----------------------------------------------------------

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove versões antigas
local old = playerGui:FindFirstChild("ZKHUB")
if old then old:Destroy() end

-- Tela principal
local gui = Instance.new("ScreenGui")
gui.Name = "ZKHUB"
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-------------------------------------------------------------
-- BOTÃO DE ABRIR
-------------------------------------------------------------
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 80, 0, 80)
openBtn.Position = UDim2.new(0.12, 0, 0.40, 0)   -- MAIS À DIREITA
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

-------------------------------------------------------------
-- PAINEL PRINCIPAL (draggable)
-------------------------------------------------------------
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 550, 0, 380)
panel.BackgroundColor3 = Color3.fromRGB(10,20,30)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, -1, 0)
panel.Parent = gui
panel.Visible = true
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)

local ps = Instance.new("UIStroke")
ps.Color = Color3.fromRGB(0,255,255)
ps.Thickness = 3
ps.Parent = panel

-------------------------------------------------------------
-- TÍTULO
-------------------------------------------------------------
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

-------------------------------------------------------------
-- BOTÃO FECHAR
-------------------------------------------------------------
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

-------------------------------------------------------------
-- MENU LATERAL (categorias)
-------------------------------------------------------------
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 130, 1, -60)
menu.Position = UDim2.new(0, 10, 0, 60)
menu.BackgroundColor3 = Color3.fromRGB(14,26,40)
menu.Parent = panel
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,10)

local ms = Instance.new("UIStroke")
ms.Color = Color3.fromRGB(0,255,255)
ms.Thickness = 2
ms.Parent = menu

local list = Instance.new("UIListLayout")
list.Parent = menu
list.Padding = UDim.new(0,10)

local categories = {}
local currentCategory = nil

-------------------------------------------------------------
-- ÁREA DE CONTEÚDO
-------------------------------------------------------------
local content = Instance.new("Frame")
content.Size = UDim2.new(1,-160,1,-60)
content.Position = UDim2.new(0,150,0,60)
content.BackgroundTransparency = 1
content.Parent = panel

-------------------------------------------------------------
-- FUNÇÃO PARA CRIAR CATEGORIA
-------------------------------------------------------------
local function newCategory(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(0,255,255)
    btn.BackgroundTransparency = 0.8
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBlack
    btn.Parent = menu
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.Parent = content
    frame.BackgroundTransparency = 1
    frame.Visible = false

    btn.MouseButton1Click:Connect(function()
        if currentCategory then currentCategory.Visible = false end
        frame.Visible = true
        currentCategory = frame
    end)

    return frame
end

-------------------------------------------------------------
-- CRIAR 5 CATEGORIAS
-------------------------------------------------------------
local cat1 = newCategory("Principal")
local cat2 = newCategory("Visual")
local cat3 = newCategory("Jogador")
local cat4 = newCategory("Mundo")
local cat5 = newCategory("Extras")

-------------------------------------------------------------
-- CATEGORIA 1 → ESP PLAYER
-------------------------------------------------------------
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0,200,0,40)
espToggle.Position = UDim2.new(0,20,0,20)
espToggle.BackgroundColor3 = Color3.fromRGB(0,255,255)
espToggle.Text = "ESP Player: OFF"
espToggle.TextColor3 = Color3.fromRGB(0,0,0)
espToggle.TextSize = 18
espToggle.Font = Enum.Font.GothamBlack
espToggle.Parent = cat1
Instance.new("UICorner", espToggle).CornerRadius = UDim.new(0,8)

local espEnabled = false
local espFolder = Instance.new("Folder", gui)

local function createESP(target)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(3,6,3)
    box.Color3 = Color3.fromRGB(180,255,255)
    box.Transparency = 0.4
    box.AlwaysOnTop = true
    box.Adornee = target
    box.Parent = espFolder

    local line = Instance.new("BillboardGui")
    line.Size = UDim2.new(0,4,0,50)
    line.AlwaysOnTop = true
    line.Adornee = target
    line.Parent = espFolder

    local lr = Instance.new("Frame")
    lr.Size = UDim2.new(1,0,1,0)
    lr.BackgroundColor3 = Color3.fromRGB(255,255,255)
    lr.BackgroundTransparency = 0.3
    lr.Parent = line
end

local function updateESP()
    espFolder:ClearAllChildren()
    if not espEnabled then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            createESP(p.Character.HumanoidRootPart)
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = espEnabled and "ESP Player: ON" or "ESP Player: OFF"
end)

-------------------------------------------------------------
-- ANIMAÇÃO DO PAINEL
-------------------------------------------------------------
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

-------------------------------------------------------------
-- ABRIR COM VÁRIAS TECLAS
-------------------------------------------------------------
local validKeys = {
    [Enum.KeyCode.LeftControl] = true,
    [Enum.KeyCode.RightControl] = true,
    [Enum.KeyCode.F] = true,
    [Enum.KeyCode.Q] = true,
}

UIS.InputBegan:Connect(function(i,gpe)
    if gpe then return end
    if validKeys[i.KeyCode] then
        toggle()
    end
end)

-------------------------------------------------------------
-- BOTÃO DRAGGABLE
-------------------------------------------------------------
local dragging = false
local dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    openBtn.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = openBtn.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        update(input)
    end
end)

-------------------------------------------------------------
-- PAINEL DRAGGABLE
-------------------------------------------------------------
local dragging2 = false
local startDrag2, startPos2

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = true
        startDrag2 = input.Position
        startPos2 = panel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging2 = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging2 and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - startDrag2
        panel.Position = UDim2.new(
            startPos2.X.Scale, startPos2.X.Offset + delta.X,
            startPos2.Y.Scale, startPos2.Y.Offset + delta.Y
        )
    end
end)
