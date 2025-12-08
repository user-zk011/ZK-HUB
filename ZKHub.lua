local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Limpa antigo
local oldGui = playerGui:FindFirstChild("ZKHUB")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "ZKHUB"
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- CORES
local COLOR_BG = Color3.fromRGB(13,25,37) -- fundo painel
local COLOR_BORDER = Color3.fromRGB(0,184,255) -- azul neon
local COLOR_TEXT = Color3.fromRGB(168,219,254) -- azul claro texto
local COLOR_TOGGLE_BG = Color3.fromRGB(34,44,54) -- fundo toggle OFF
local COLOR_TOGGLE_ON = Color3.fromRGB(0,184,255) -- toggle ON

-- FUNÇÃO PARA CRIAR UICORNER FACIL
local function createUICorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

-- FUNÇÃO PARA CRIAR UIStroke
local function createUIStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 2
    s.Parent = parent
    return s
end

-- #########################
-- BOTÃO ABRIR - MODERNO
-- #########################
local openBtn = Instance.new("Frame")
openBtn.Size = UDim2.new(0, 70, 0, 70)
openBtn.Position = UDim2.new(0.15, 0, 0.40, 0) -- mais pra direita
openBtn.BackgroundColor3 = COLOR_BG
openBtn.Parent = gui
createUICorner(openBtn, 35)
createUIStroke(openBtn, COLOR_BORDER, 2)

local openText = Instance.new("TextLabel")
openText.Text = "ZK"
openText.Font = Enum.Font.GothamBold
openText.TextColor3 = COLOR_TEXT
openText.TextSize = 30
openText.BackgroundTransparency = 1
openText.Size = UDim2.new(1,0,1,0)
openText.Parent = openBtn
openText.AnchorPoint = Vector2.new(0.5, 0.5)
openText.Position = UDim2.new(0.5, 0, 0.5, 0)

-- Sombras sutis no botão
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1,12,1,12)
shadow.Position = UDim2.new(0,-6,0,-6)
shadow.BackgroundColor3 = Color3.new(0,0,0)
shadow.BackgroundTransparency = 0.9
shadow.ZIndex = openBtn.ZIndex - 1
shadow.Parent = openBtn
createUICorner(shadow, 40)

-- BOTÃO ABRIR: clique
local function tweenOpenBtnHover(state)
    local goal = {}
    if state then
        goal.BackgroundColor3 = COLOR_BORDER
        goal.TextColor3 = Color3.new(1,1,1)
    else
        goal.BackgroundColor3 = COLOR_BG
        goal.TextColor3 = COLOR_TEXT
    end
    TweenService:Create(openBtn, TweenInfo.new(0.25), {BackgroundColor3 = goal.BackgroundColor3}):Play()
    TweenService:Create(openText, TweenInfo.new(0.25), {TextColor3 = goal.TextColor3}):Play()
end

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        tweenOpenBtnHover(true)
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        togglePanel()
    end
end)
openBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        tweenOpenBtnHover(false)
    end
end)

-- Draggable openBtn
local dragging, dragInput, dragStart, startPos
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
openBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        openBtn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- #########################
-- PAINEL PRINCIPAL
-- #########################
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 530, 0, 370)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, -1, 0)
panel.BackgroundColor3 = COLOR_BG
panel.Parent = gui
createUICorner(panel, 14)
createUIStroke(panel, COLOR_BORDER, 2)

-- Draggable painel
local draggingPanel, dragInputPanel, dragStartPanel, startPosPanel
panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingPanel = true
        dragStartPanel = input.Position
        startPosPanel = panel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingPanel = false
            end
        end)
    end
end)
panel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInputPanel = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInputPanel and draggingPanel then
        local delta = input.Position - dragStartPanel
        panel.Position = UDim2.new(
            startPosPanel.X.Scale,
            startPosPanel.X.Offset + delta.X,
            startPosPanel.Y.Scale,
            startPosPanel.Y.Offset + delta.Y
        )
    end
end)

-- Cabeçalho
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 40)
title.Position = UDim2.new(0, 20, 0, 10)
title.BackgroundTransparency = 1
title.Text = "ZK HUB"
title.TextColor3 = COLOR_TEXT
title.Font = Enum.Font.GothamSemibold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 38, 0, 38)
closeBtn.Position = UDim2.new(1, -52, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(240, 50, 50)
closeBtn.TextSize = 28
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.Parent = panel
createUICorner(closeBtn, 12)
createUIStroke(closeBtn, Color3.fromRGB(240,50,50), 1.5)

closeBtn.MouseButton1Click:Connect(function()
    togglePanel()
end)

-- MENU LATERAL
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 130, 1, -60)
menu.Position = UDim2.new(0, 15, 0, 60)
menu.BackgroundColor3 = Color3.fromRGB(5,14,26)
menu.Parent = panel
createUICorner(menu, 10)

local menuLayout = Instance.new("UIListLayout")
menuLayout.Parent = menu
menuLayout.Padding = UDim.new(0, 10)
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- CATEGORIAS (botões laterais)
local categories = {}
local currentCategory = nil

local function createCategory(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency = 0.7
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 18
    btn.TextColor3 = COLOR_TEXT
    btn.Parent = menu
    createUICorner(btn, 8)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.4}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
    end)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = panel

    btn.MouseButton1Click:Connect(function()
        if currentCategory then
            currentCategory.Visible = false
        end
        frame.Visible = true
        currentCategory = frame
    end)

    categories[name] = frame
    return frame
end

-- Criar categorias do menu
local catMain = createCategory("Main")
createCategory("Stealer")
createCategory("Helper")
createCategory("Player")
createCategory("Finder")
createCategory("Server")
createCategory("Discord")

-- ÁREA DE CONTEÚDO
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -150, 1, -60)
contentFrame.Position = UDim2.new(0, 150, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = panel

-- FUNÇÃO BOTÃO TOGGLE MODERNO
local function createToggle(parent, labelText, initialState, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 18
    label.TextColor3 = COLOR_TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 50, 0, 24)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.2, 0)
    toggleBtn.BackgroundColor3 = COLOR_TOGGLE_BG
    toggleBtn.Parent = container
    createUICorner(toggleBtn, 12)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = UDim2.new(0, 2, 0, 2)
    circle.BackgroundColor3 = Color3.fromRGB(230,230,230)
    circle.Parent = toggleBtn
    createUICorner(circle, 10)

    local toggled = initialState

    local function updateToggle()
        if toggled then
            TweenService:Create(toggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLOR_TOGGLE_ON}):Play()
            TweenService:Create(circle, TweenInfo.new(0.3), {Position = UDim2.new(1, -22, 0, 2)}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLOR_TOGGLE_BG}):Play()
            TweenService:Create(circle, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0, 2)}):Play()
        end
    end

    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggled = not toggled
            updateToggle()
            callback(toggled)
        end
    end)

    updateToggle()
    return container
end

-- ESP PLAYER (com estilo)
local espEnabled = false

local function applyESP(character)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.ForceField
            part.Color = COLOR_TOGGLE_ON
            part.Transparency = 0.6
        end
    end
end

local function removeESP(character)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Plastic
            part.Transparency = 0
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            applyESP(p.Character)
        end
    end
end)

-- Adiciona toggle ESP na categoria Main
createToggle(categories["Main"], "ESP Player", false, function(state)
    espEnabled = state
    if not state then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                removeESP(p.Character)
            end
        end
    end
end)

-- ANIMAÇÃO ABRIR/FECHAR PAINEL
local isOpen = false
local openPos = UDim2.new(0.5, 0, 0.5, 0)
local closedPos = UDim2.new(0.5, 0, -1.2, 0)

local function togglePanel()
    isOpen = not isOpen
    TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = isOpen and openPos or closedPos}):Play()
end

-- ABRIR APENAS COM CONTROLS
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        togglePanel()
    end
end)

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        togglePanel()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    togglePanel()
end)
