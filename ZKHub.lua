-- ZKHub.lua
-- Só funciona no jogo “Steal a Brainrot”
if game.PlaceId ~= 109983668079237 then return end  

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZKHubGui"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- Botão circular flutuante
local btn = Instance.new("ImageButton")
btn.Size = UDim2.new(0, 60, 0, 60)
btn.AnchorPoint = Vector2.new(1, 1)
btn.Position = UDim2.new(1, -20, 1, -20)
btn.BackgroundTransparency = 1
btn.Image = "https://cdn.ereemby.com/attachments/17631336254632667imagem.png"
btn.ScaleType = Enum.ScaleType.Fit
btn.Parent = screenGui

-- Painel principal
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0.6, 0, 0.6, 0)  -- vai ajustar conforme tela
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.Position = UDim2.new(0.5, 0, 0.5, 0)
panel.BackgroundColor3 = Color3.fromRGB(12, 22, 36)
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = screenGui

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 12)

local border = Instance.new("UIStroke", panel)
border.Color = Color3.fromRGB(100,170,255)
border.Thickness = 2
border.Transparency = 0.5

-- Barra para mover
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,30)
topBar.BackgroundTransparency = 1
topBar.Parent = panel

-- Exemplo de título
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,36)
title.Position = UDim2.new(0,0,0,4)
title.BackgroundTransparency = 1
title.Text = "ZK HUB"
title.TextColor3 = Color3.fromRGB(180,220,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Estado
local open = false

-- Função toggle
local function toggle()
    open = not open
    panel.Visible = open
end

btn.MouseButton1Click:Connect(toggle)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        toggle()
    end
end)

-- Drag funcionalidade
local dragging = false
local dragStart
local startPos

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
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

-- Responsividade (opcional: ajusta tamanho se mobile)
local function onResize()
    local vw = workspace.CurrentCamera.ViewportSize.X
    local vh = workspace.CurrentCamera.ViewportSize.Y
    if vw < 600 then
        panel.Size = UDim2.new(0.9, 0, 0.7, 0)
    else
        panel.Size = UDim2.new(0.6, 0, 0.6, 0)
    end
end

RunService:GetPropertyChangedSignal("RenderStepped"):Connect(onResize)
onResize()
