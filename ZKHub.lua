--============================================================
-- ZK HUB - DiamondTech UI (Atualizado)
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
-- BOTÃO ABRIR ZK
--============================================================
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,70,0,70) -- maior que o círculo
openBtn.Position = UDim2.new(0.12,0,0.40,0)
openBtn.BackgroundColor3 = Color3.fromRGB(10,20,40)
openBtn.Text = "ZK"
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.TextSize = 36
openBtn.Font = Enum.Font.GothamBlack
openBtn.Parent = gui
local corner = Instance.new("UICorner", openBtn)
corner.CornerRadius = UDim.new(1,0)

-- Efeito radar suave
local radarCircle = {}
for i=1,3 do
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(1,0,1,0)
    circle.Position = UDim2.new(0,0,0,0)
    circle.BackgroundColor3 = Color3.fromRGB(0,170,255)
    circle.BackgroundTransparency = 0.7 + i*0.1 -- 70% até 100%
    circle.BorderSizePixel = 0
    circle.ZIndex = 0
    circle.Parent = openBtn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)
    table.insert(radarCircle,circle)
end

--============================================================
-- PAINEL
--============================================================
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,500,0,360)
panel.Position = UDim2.new(0.5,0,0.5,0)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(10,20,40)
panel.ClipsDescendants = true
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)

-- Contorno fino
local ps = Instance.new("UIStroke")
ps.Color = Color3.fromRGB(0,170,255)
ps.Thickness = 1
ps.Parent = panel

-- Bloqueio de clique atrás
panel.Active = true
panel.Selectable = true

--============================================================
-- CABEÇALHO
--============================================================
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,40)
title.Position = UDim2.new(0,60,0,10)
title.BackgroundTransparency = 1
title.Text = "ZK HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 28
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-40,0,10)
closeBtn.BackgroundColor3 = Color3.fromRGB(10,20,40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 20
closeBtn.Parent = panel
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)
local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(0,170,255)
closeStroke.Thickness = 1
closeStroke.Parent = closeBtn

--============================================================
-- MENU LATERAL
--============================================================
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0,150,1,-60)
menu.Position = UDim2.new(0,10,0,60)
menu.BackgroundTransparency = 1 -- removido fundo cinza
menu.Parent = panel

local list = Instance.new("UIListLayout")
list.Parent = menu
list.Padding = UDim.new(0,8)
list.SortOrder = Enum.SortOrder.LayoutOrder

--============================================================
-- CONTEÚDO
--============================================================
local content = Instance.new("Frame")
content.Size = UDim2.new(1,-180,1,-60)
content.Position = UDim2.new(0,170,0,60)
content.BackgroundColor3 = Color3.fromRGB(10,20,40)
content.Parent = panel
Instance.new("UICorner", content).CornerRadius = UDim.new(0,8)

-- Contorno da área de opções
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(0,170,255)
contentStroke.Thickness = 1
contentStroke.Parent = content

local categories = {}
local currentCategory = nil

function newCategory(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
    btn.BackgroundTransparency = 0.8
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBlack
    btn.Parent = menu
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = content

    btn.MouseButton1Click:Connect(function()
        if currentCategory then currentCategory.Visible = false end
        frame.Visible = true
        currentCategory = frame
    end)

    return frame
end

-- CATEGORIAS
local cat1 = newCategory("Principal")
local cat2 = newCategory("Visual")
local cat3 = newCategory("Jogador")
local cat4 = newCategory("Mundo")
local cat5 = newCategory("Extras")

--============================================================
-- OPÇÃO ESP PLAYER (silhueta real, chamativa)
--============================================================
local espEnabled = false
local espObjects = {}

function createESP(p)
    if espObjects[p] then return end
    if not p.Character then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = p.Character
    highlight.FillColor = Color3.fromRGB(0,200,255)
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.fromRGB(100,255,255)
    highlight.OutlineTransparency = 0.2
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = gui
    espObjects[p] = highlight
end

function removeESP(p)
    if espObjects[p] then
        espObjects[p]:Destroy()
        espObjects[p] = nil
    end
end

-- Cria opção de toggle ESP
local function createOption(parent,name)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,0,40)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6,0,1,0)
    label.Position = UDim2.new(0,0,0,0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0,50,0,25)
    toggle.Position = UDim2.new(0.65,0,0.15,0)
    toggle.BackgroundColor3 = Color3.fromRGB(150,0,0)
    toggle.Parent = container
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0.5,0,1,0)
    knob.Position = UDim2.new(0,0,0,0)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.Parent = toggle
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local enabled = false
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            if enabled then
                toggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
                knob.Position = UDim2.new(0.5,0,0,0)
            else
                toggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
                knob.Position = UDim2.new(0,0,0,0)
            end
            espEnabled = enabled
        end
    end)

    return container
end

createOption(cat1,"ESP Player")

-- Detecta novos jogadores
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        if espEnabled then createESP(p) end
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if espEnabled then
                createESP(p)
            else
                removeESP(p)
            end
        end
    end
end)

--============================================================
-- ABRIR/FECHAR PAINEL (sem deslize, aparece com crescimento)
--============================================================
local isOpen = false
panel.Size = UDim2.new(0,0,0,0) -- começa invisível
local function toggle()
    isOpen = not isOpen
    if isOpen then
        panel.Visible = true
        panel:TweenSize(UDim2.new(0,500,0,360), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
    else
        panel:TweenSize(UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
    end
end

openBtn.MouseButton1Click:Connect(toggle)
closeBtn.MouseButton1Click:Connect(toggle)

-- ABRIR APENAS COM LEFT CONTROL
UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        toggle()
    end
end)

--============================================================
-- DRAGGABLE (corrigido problema de clicar sobre botão)
--============================================================
local function makeDraggable(frame)
    local dragging = false
    local dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(openBtn)
makeDraggable(panel)
