```lua
-- hub_panel.lua
-- Script para Roblox (LocalScript). Coloque em StarterPlayerScripts ou StarterGui.
-- Cria um painel hub retangular, "clear" (parcialmente transparente), cinza-azulado, com bordas arredondadas.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HubPanelGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.Parent = playerGui

-- Criar Frame principal (painel)
local frame = Instance.new("Frame")
frame.Name = "HubPanel"
-- Tamanho em escala para ser responsivo; ajuste conforme desejar.
frame.Size = UDim2.new(0.38, 0, 0.42, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
-- Cor cinza-azulada
frame.BackgroundColor3 = Color3.fromRGB(128, 145, 155)
-- "Clear" (transparência parcial)
frame.BackgroundTransparency = 0.30
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Bordas arredondadas
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 16) -- raio em pixels; aumente ou diminua conforme quiser
uiCorner.Parent = frame

-- Borda sutil (opcional)
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(95, 110, 118)
uiStroke.Thickness = 1
uiStroke.Transparency = 0.25
uiStroke.Parent = frame

-- Gradiente suave para aparência mais "clean"
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 170, 178)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(115, 130, 138))
}
uiGradient.Rotation = 90
uiGradient.Parent = frame

-- Exemplo de título no topo do painel
local title = Instance.new("TextLabel")
title.Name = "HubTitle"
title.Size = UDim2.new(1, -24, 0, 34)
title.Position = UDim2.new(0, 12, 0, 8)
title.AnchorPoint = Vector2.new(0, 0)
title.BackgroundTransparency = 1
title.Text = "Hub"
title.TextColor3 = Color3.fromRGB(245, 248, 250)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Espaço para conteúdo (exemplo - container)
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -24, 1, -58)
content.Position = UDim2.new(0, 12, 0, 50)
content.BackgroundTransparency = 1
content.Parent = frame

-- Aqui você pode adicionar botões, listas ou outros elementos filhos a `content`.

-- Fim do script
