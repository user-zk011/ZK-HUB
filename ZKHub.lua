--============================================================
-- ZK HUB - DiamondTech UI Atualizado 2.0
--============================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- REMOVE ANTIGO
local old = PlayerGui:FindFirstChild("ZKHUB")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "ZKHUB"
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

----------------------------------------------------------
-- BOTÃO ABRIR (ZK)
----------------------------------------------------------
local openBtn = Instance.new("Frame")
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0.12,0,0.4,0)
openBtn.BackgroundColor3 = Color3.fromRGB(10,25,40) -- igual painel
openBtn.Parent = gui
local openCorner = Instance.new("UICorner", openBtn)
openCorner.CornerRadius = UDim.new(1,0)

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(0,150,255)
openStroke.Thickness = 2
openStroke.Parent = openBtn

local openTxt = Instance.new("TextLabel")
openTxt.Text = "ZK"
openTxt.Size = UDim2.new(1,0,1,0)
openTxt.BackgroundTransparency = 1
openTxt.TextColor3 = Color3.fromRGB(255,255,255)
openTxt.Font = Enum.Font.GothamBlack
openTxt.TextScaled = true
openTxt.Parent = openBtn

-- efeito pulsante suave atrás do botão
for i=1,3 do
    local pulse = Instance.new("Frame")
    pulse.Size = UDim2.new(1,0,1,0)
    pulse.Position = UDim2.new(0,0,0,0)
    pulse.BackgroundColor3 = Color3.fromRGB(0,150,255)
    pulse.BackgroundTransparency = 0.85 - i*0.2
    pulse.ZIndex = 0
    pulse.Parent = openBtn
    local pulseCorner = Instance.new("UICorner", pulse)
    pulseCorner.CornerRadius = UDim.new(1,0)
    coroutine.wrap(function()
        while true do
            local tween = TweenService:Create(pulse, TweenInfo.new(1.2 + i*0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Size = UDim2.new(1.3,0,1.3,0),
                Position = UDim2.new(-0.15,0,-0.15,0)
            })
            tween:Play()
            tween.Completed:Wait()
        end
    end)()
end

----------------------------------------------------------
-- PAINEL PRINCIPAL
----------------------------------------------------------
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,480,0,340)
panel.Position = UDim2.new(0.5,0,-1,0)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(10,25,40)
panel.Parent = gui
local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0,15)
local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(0,150,255)
panelStroke.Thickness = 2
panelStroke.Parent = panel

----------------------------------------------------------
-- CABEÇALHO
----------------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,40)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "ZK HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,40,0,40)
closeBtn.Position = UDim2.new(1,-50,0,10)
closeBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 24
closeBtn.Parent = panel
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

----------------------------------------------------------
-- MENU LATERAL
----------------------------------------------------------
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0,150,1,-60)
menu.Position = UDim2.new(0,10,0,60)
menu.BackgroundColor3 = Color3.fromRGB(10,25,40)
menu.Parent = panel
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,12)

local list = Instance.new("UIListLayout")
list.Parent = menu
list.Padding = UDim.new(0,10)

----------------------------------------------------------
-- ÁREA DE CONTEÚDO
----------------------------------------------------------
local content = Instance.new("Frame")
content.Size = UDim2.new(1,-180,1,-60)
content.Position = UDim2.new(0,170,0,60)
content.BackgroundColor3 = Color3.fromRGB(10,25,40)
content.Parent = panel
local contentCorner = Instance.new("UICorner", content)
contentCorner.CornerRadius = UDim.new(0,12)
local contentStroke = Instance.new("UIStroke", content)
contentStroke.Color = Color3.fromRGB(0,150,255)
contentStroke.Thickness = 2

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
    frame.BackgroundColor3 = Color3.fromRGB(10,25,40)
    frame.Visible = false
    frame.Parent = content
    local frameCorner = Instance.new("UICorner", frame)
    frameCorner.CornerRadius = UDim.new(0,10)
    local frameStroke = Instance.new("UIStroke", frame)
    frameStroke.Color = Color3.fromRGB(0,150,255)
    frameStroke.Thickness = 2

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
local catVisual = newCategory("Visual")
local catJogador = newCategory("Jogador")

-- EXEMPLO DE OPÇÕES COM SEPARADORES
local function addOption(frame, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-20,0,30)
    lbl.Position = UDim2.new(0,10,0,#frame:GetChildren()*35)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 16
    lbl.Parent = frame

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1,-20,0,2)
    sep.Position = UDim2.new(0,10,0,#frame:GetChildren()*35 + 30)
    sep.BackgroundColor3 = Color3.fromRGB(0,150,255)
    sep.Parent = frame
end

addOption(cat1,"ESP Player")
addOption(cat1,"Speed Hack")
addOption(catVisual,"Glow")
addOption(catVisual,"Trails")

----------------------------------------------------------
-- ESP PLAYER ESTILIZADO
----------------------------------------------------------
local espEnabled = false
local function createESP(p)
    if p.Character and not p.Character:FindFirstChild("ZK_ESP") then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ZK_ESP"
        box.Adornee = p.Character:FindFirstChild("HumanoidRootPart")
        box.Size = Vector3.new(4,6,2)
        box.Transparency = 0.6
        box.Color = BrickColor.new("Bright blue")
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Parent = p.Character:FindFirstChild("HumanoidRootPart")
    end
end

local function removeESP(p)
    if p.Character then
        local esp = p.Character:FindFirstChild("ZK_ESP")
        if esp then esp:Destroy() end
    end
end

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                createESP(p)
            end
        end
    else
        for _,p in pairs(Players:GetPlayers()) do
            removeESP(p)
        end
    end
end)

-- BOTÃO SWITCH ESTILO IPHONE
local espSwitch = Instance.new("Frame")
espSwitch.Size = UDim2.new(0,60,0,30)
espSwitch.Position = UDim2.new(0,220,0,20)
espSwitch.BackgroundColor3 = Color3.fromRGB(255,0,0)
espSwitch.Parent = cat1
local switchCorner = Instance.new("UICorner", espSwitch)
switchCorner.CornerRadius = UDim.new(1,0)

local switchBall = Instance.new("Frame")
switchBall.Size = UDim2.new(0.5,0,1,0)
switchBall.Position = UDim2.new(0,0,0,0)
switchBall.BackgroundColor3 = Color3.fromRGB(255,255,255)
switchBall.Parent = espSwitch
local ballCorner = Instance.new("UICorner", switchBall)
ballCorner.CornerRadius = UDim.new(1,0)

espSwitch.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        espEnabled = not espEnabled
        if espEnabled then
            espSwitch.BackgroundColor3 = Color3.fromRGB(0,200,0)
            switchBall:TweenPosition(UDim2.new(0.5,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        else
            espSwitch.BackgroundColor3 = Color3.fromRGB(200,0,0)
            switchBall:TweenPosition(UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end
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

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggle()
    end
end)
closeBtn.MouseButton1Click:Connect(toggle)

----------------------------------------------------------
-- DRAGGABLE BOTÃO E PAINEL
----------------------------------------------------------
local function makeDraggable(frame)
    local dragging, dragStart, startPos
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
