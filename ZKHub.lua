--[[  
███████╗██╗  ██╗    ██╗  ██╗██╗   ██╗██████╗ 
██╔════╝██║ ██╔╝    ██║ ██╔╝██║   ██║██╔══██╗
█████╗  █████╔╝     █████╔╝ ██║   ██║██████╔╝
██╔══╝  ██╔═██╗     ██╔═██╗ ██║   ██║██╔══██╗
███████╗██║  ██╗    ██║  ██╗╚██████╔╝██║  ██║
╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ 
       ZK HUB – DIAMOND TECH EDITION
]]

-- Segurança anti-duplicação
if getgenv then
    if getgenv().ZK_HUB_DIAMOND_LOADED then return end
    getgenv().ZK_HUB_DIAMOND_LOADED = true
end

-- Serviços
local Players       = game:GetService("Players")
local UIS           = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local player        = Players.LocalPlayer
local playerGui     = player:WaitForChild("PlayerGui")

-- Tema (Diamond Tech)
local NEON          = Color3.fromRGB(20, 215, 255)
local NEON_DARK     = Color3.fromRGB(10, 105, 130)
local BG_DARK       = Color3.fromRGB(8, 11, 15)
local BG_CARD       = Color3.fromRGB(12, 16, 22)
local TEXT          = Color3.fromRGB(220, 240, 255)

-- Tween padrão
local TWEEN         = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

------------------------------------------------------------
-- FUNÇÃO DE CRIAR BORDA NEON
------------------------------------------------------------
local function ApplyGlow(obj, thickness)
    local s = Instance.new("UIStroke")
    s.Color = NEON
    s.Thickness = thickness or 2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Outside
    s.Parent = obj
    return s
end

------------------------------------------------------------
-- LIMPA GUI ANTIGA
------------------------------------------------------------
local old = playerGui:FindFirstChild("ZKHubDiamond")
if old then old:Destroy() end

------------------------------------------------------------
-- GUI PRINCIPAL
------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ZKHubDiamond"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = playerGui

------------------------------------------------------------
-- ÍCONE (BOTÃO REDONDO)
------------------------------------------------------------
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 88, 0, 88)
icon.Position = UDim2.new(0.035, 0, 0.4, 0)
icon.BackgroundColor3 = NEON
icon.Text = "ZK"
icon.TextSize = 38
icon.Font = Enum.Font.GothamBlack
icon.TextColor3 = Color3.fromRGB(5,10,15)
icon.Parent = gui

Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
ApplyGlow(icon, 3)

-- Ícone arrastável
do
    local dragging = false
    local dragStart, startPos

    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = icon.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            icon.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    icon.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

------------------------------------------------------------
-- PAINEL PRINCIPAL
------------------------------------------------------------
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 900, 0, 560)
panel.Position = UDim2.new(0.5, 0, -1.1, 0)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.BackgroundColor3 = BG_DARK
panel.Visible = false
panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
ApplyGlow(panel, 4)

------------------------------------------------------------
-- TITLEBAR
------------------------------------------------------------
local titlebar = Instance.new("Frame")
titlebar.Size = UDim2.new(1, 0, 0, 55)
titlebar.BackgroundColor3 = BG_CARD
titlebar.Parent = panel
Instance.new("UICorner", titlebar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ZK HUB — Diamond Tech"
title.Font = Enum.Font.GothamSemibold
title.TextColor3 = NEON
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titlebar

-- Arrastar painel pelo titlebar
do
    local dragging = false
    local dragStart, startPos

    titlebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = panel.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    titlebar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

------------------------------------------------------------
-- SIDEBAR (CATEGORIAS)
------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 220, 1, -65)
sidebar.Position = UDim2.new(0, 15, 0, 60)
sidebar.BackgroundColor3 = BG_CARD
sidebar.Parent = panel
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
ApplyGlow(sidebar, 1)

local list = Instance.new("UIListLayout", sidebar)
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder

local categories = {"PRINCIPAL","ROUBO","JOGADOR","VIZUAL","SERVIDOR"}
local buttons = {}

local function createCategory(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 42)
    b.Position = UDim2.new(0,10,0,0)
    b.BackgroundColor3 = BG_DARK
    b.Text = name
    b.TextSize = 18
    b.Font = Enum.Font.GothamSemibold
    b.TextColor3 = TEXT
    b.Parent = sidebar

    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    ApplyGlow(b, 1)

    table.insert(buttons, b)
    return b
end

for _,v in ipairs(categories) do createCategory(v) end

------------------------------------------------------------
-- ÁREA DE CONTEÚDO
------------------------------------------------------------
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -260, 1, -75)
content.Position = UDim2.new(0, 245, 0, 60)
content.BackgroundColor3 = BG_CARD
content.Parent = panel
Instance.new("UICorner", content).CornerRadius = UDim.new(0,10)
ApplyGlow(content, 1)

local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -20, 0, 40)
contentTitle.Position = UDim2.new(0, 10, 0, 10)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "PRINCIPAL"
contentTitle.TextSize = 22
contentTitle.Font = Enum.Font.GothamSemibold
contentTitle.TextColor3 = NEON
contentTitle.Parent = content

------------------------------------------------------------
-- SISTEMA DE CATEGORIAS
------------------------------------------------------------
local function setCategory(name)
    contentTitle.Text = name
end

for _,b in ipairs(buttons) do
    b.MouseButton1Click:Connect(function()
        setCategory(b.Text)
    end)
end

------------------------------------------------------------
-- ESP PLAYER (Diamond Highlight)
------------------------------------------------------------
local espEnabled = false
local highlights = {}

local function applyESP(plr)
    if plr == player then return end
    if not plr.Character then return end

    if highlights[plr] then
        highlights[plr]:Destroy()
    end

    local h = Instance.new("Highlight")
    h.Parent = plr.Character
    h.FillColor = NEON
    h.OutlineColor = Color3.fromRGB(255,255,255)
    h.FillTransparency = 0.45
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    highlights[plr] = h
end

local function setESP(state)
    espEnabled = state
    if not state then
        for _,h in pairs(highlights) do h:Destroy() end
        highlights = {}
        return
    end

    for _,pl in ipairs(Players:GetPlayers()) do
        applyESP(pl)
        pl.CharacterAdded:Connect(function() task.wait(.1) if espEnabled then applyESP(pl) end end)
    end
end

-- Botão ESP dentro da categoria VIZUAL
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 160, 0, 45)
espButton.Position = UDim2.new(0, 10, 0, 70)
espButton.BackgroundColor3 = BG_DARK
espButton.Text = "ESP PLAYER: OFF"
espButton.TextSize = 18
espButton.Font = Enum.Font.GothamBold
espButton.TextColor3 = TEXT
espButton.Parent = content

Instance.new("UICorner", espButton).CornerRadius = UDim.new(0,8)
ApplyGlow(espButton, 2)

espButton.MouseButton1Click:Connect(function()
    setESP(not espEnabled)
    espButton.Text = espEnabled and "ESP PLAYER: ON" or "ESP PLAYER: OFF"
    espButton.BackgroundColor3 = espEnabled and NEON_DARK or BG_DARK
end)

------------------------------------------------------------
-- SISTEMA DE ABRIR / FECHAR: ÍCONE + CTRL
------------------------------------------------------------
local panelOpen = false
local shownPos = UDim2.new(0.5,0,0.5,0)
local hiddenPos = UDim2.new(0.5,0,-1.1,0)

local function showPanel()
    panel.Visible = true
    TweenService:Create(panel, TWEEN, {Position = shownPos}):Play()
    panelOpen = true
end

local function hidePanel()
    TweenService:Create(panel, TWEEN, {Position = hiddenPos}):Play()
    task.delay(.25, function() panel.Visible = false end)
    panelOpen = false
end

local function togglePanel()
    if panelOpen then hidePanel() else showPanel() end
end

icon.MouseButton1Click:Connect(togglePanel)

UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.LeftControl or i.KeyCode == Enum.KeyCode.RightControl then
        togglePanel()
    end
end)
