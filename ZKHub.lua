--===========================================================
-- ZK HUB - PAINEL NEON FUTURISTA FINAL
--===========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove antigo
local old = playerGui:FindFirstChild("ZKHUB")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "ZKHUB"
gui.IgnoreGuiInset = true
gui.Parent = playerGui

----------------------------------------------------------
-- BOTÃO ZK COM PULSAÇÃO
----------------------------------------------------------

local openBtn = Instance.new("Frame")
openBtn.Size = UDim2.new(0, 110, 0, 110)
openBtn.Position = UDim2.new(0.10, 0, 0.40, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(100,180,255)
btnStroke.Thickness = 4
btnStroke.Parent = openBtn

-- PULSO (Glow)
local function createPulse()
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1,0,1,0)
    p.Position = UDim2.new(0,0,0,0)
    p.BackgroundColor3 = Color3.fromRGB(0,140,255)
    p.BackgroundTransparency = 0.6
    p.ZIndex = 0
    p.Parent = openBtn
    Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)

    TweenService:Create(p, TweenInfo.new(1.4, Enum.EasingStyle.Linear), {
        Size = UDim2.new(1.7,0,1.7,0),
        BackgroundTransparency = 1
    }):Play()

    task.delay(1.4, function()
        p:Destroy()
    end)
end

task.spawn(function()
    while true do
        createPulse()
        task.wait(1.1)
    end
end)

-- TEXTO ZK
local zk = Instance.new("TextLabel")
zk.Size = UDim2.new(1,0,1,0)
zk.BackgroundTransparency = 1
zk.Text = "ZK"
zk.TextColor3 = Color3.fromRGB(255,255,255)
zk.TextSize = 54
zk.Font = Enum.Font.SourceSansBold
zk.Parent = openBtn

----------------------------------------------------------
-- PAINEL PRINCIPAL
----------------------------------------------------------

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 720, 0, 480)
panel.Position = UDim2.new(0.5,0,-1,0)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(8, 18, 28)
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)

local pStroke = Instance.new("UIStroke")
pStroke.Color = Color3.fromRGB(0,170,255)
pStroke.Thickness = 3
pStroke.Parent = panel

----------------------------------------------------------
-- TÍTULO
----------------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,50)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "ZK HUB - ROUBE UM BRAINROT"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 28
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local titleStroke = Instance.new("UIStroke")
titleStroke.Thickness = 1.8
titleStroke.Color = Color3.fromRGB(0,160,255)
titleStroke.Parent = title

----------------------------------------------------------
-- BOTÃO X
----------------------------------------------------------

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,45,0,45)
closeBtn.Position = UDim2.new(1,-55,0,10)
closeBtn.Text = "X"
closeBtn.TextSize = 26
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = panel
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

----------------------------------------------------------
-- MENU LATERAL
----------------------------------------------------------

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0,170,1,-70)
menu.Position = UDim2.new(0,10,0,60)
menu.BackgroundColor3 = Color3.fromRGB(12,25,40)
menu.Parent = panel
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,10)

local menuList = Instance.new("UIListLayout")
menuList.Parent = menu
menuList.Padding = UDim.new(0,10)

----------------------------------------------------------
-- ÁREA DE CONTEÚDO
----------------------------------------------------------

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-200,1,-70)
content.Position = UDim2.new(0,190,0,60)
content.BackgroundTransparency = 1
content.Parent = panel

local categories = {}
local activeCat = nil

local function newCategory(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,40)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    btn.BackgroundTransparency = 0.6
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = menu
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.Visible = false
    frame.BackgroundTransparency = 1
    frame.Parent = content

    btn.MouseButton1Click:Connect(function()
        if activeCat then activeCat.Visible = false end
        frame.Visible = true
        activeCat = frame
    end)

    return frame
end

local cat1 = newCategory("Principal")
local cat2 = newCategory("Visual")
local cat3 = newCategory("Jogador")
local cat4 = newCategory("Mundo")
local cat5 = newCategory("Extras")

----------------------------------------------------------
-- TOGGLE MODERNO (SLIDER)
----------------------------------------------------------

local function createToggle(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0,200,0,40)
    label.Position = UDim2.new(0,10,0,10)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 20
    label.Font = Enum.Font.SourceSansBold
    label.Parent = parent

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0,60,0,28)
    bg.Position = UDim2.new(0,220,0,10)
    bg.BackgroundColor3 = Color3.fromRGB(60,60,60)
    bg.Parent = parent
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)

    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0,26,0,26)
    ball.Position = UDim2.new(0,1,0,1)
    ball.BackgroundColor3 = Color3.fromRGB(255,255,255)
    ball.Parent = bg
    Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

    local toggled = false

    local function toggle()
        toggled = not toggled

        TweenService:Create(ball, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Position = toggled and UDim2.new(1,-27,0,1) or UDim2.new(0,1,0,1),
            BackgroundColor3 = toggled and Color3.fromRGB(0,160,255) or Color3.fromRGB(255,255,255)
        }):Play()

        return toggled
    end

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle()
        end
    end)

    return toggle
end

----------------------------------------------------------
-- ESP HIGHLIGHT
----------------------------------------------------------

local espToggle = createToggle(cat1, "ESP Player")
local espOn = false
local highlights = {}

function enableESP()
    espOn = true

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            if p.Character then
                local h = Instance.new("Highlight")
                h.FillColor = Color3.fromRGB(0,140,255)
                h.FillTransparency = 0.7
                h.OutlineColor = Color3.fromRGB(0,200,255)
                h.OutlineTransparency = 0
                h.Parent = p.Character
                highlights[p] = h
            end
        end
    end
end

function disableESP()
    espOn = false

    for _, h in pairs(highlights) do
        if h then h:Destroy() end
    end

    highlights = {}
end

cat1.ChildAdded:Connect(function()
    -- auto update
end)

RunService.RenderStepped:Connect(function()
    if espOn then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                if not highlights[p] then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(0,140,255)
                    h.FillTransparency = 0.7
                    h.OutlineColor = Color3.fromRGB(0,200,255)
                    h.OutlineTransparency = 0
                    h.Parent = p.Character
                    highlights[p] = h
                end
            end
        end
    end
end)

espToggle:Connect(function(state)
    if state then
        enableESP()
    else
        disableESP()
    end
end)

----------------------------------------------------------
-- ABRIR E FECHAR PAINEL
----------------------------------------------------------

local openPos = UDim2.new(0.5,0,0.5,0)
local closedPos = UDim2.new(0.5,0,-1,0)

local function togglePanel()
    TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        Position = panel.Position == openPos and closedPos or openPos
    }):Play()
end

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        togglePanel()
    end
end)

closeBtn.MouseButton1Click:Connect(togglePanel)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        togglePanel()
    end
end)

----------------------------------------------------------
-- BOTÃO ABRIR DRAGGABLE
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
    if dragging then
        local delta = input.Position - dragStart
        openBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

----------------------------------------------------------
-- PAINEL DRAGGABLE
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
    if dragging2 then
        local delta = input.Position - dragStart2
        panel.Position = UDim2.new(
            startPos2.X.Scale, startPos2.X.Offset + delta.X,
            startPos2.Y.Scale, startPos2.Y.Offset + delta.Y
        )
    end
end)
