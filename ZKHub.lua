-- ZK HUB v4 - Visuals & ESP avançado (LocalScript)
-- Cole este script em StarterGui ou StarterPlayerScripts no Roblox Studio.
-- Observações:
-- - Este script faz alterações CLIENT-SIDE (Highlights, LocalTransparencyModifier, BillboardGuis, Beams).
-- - Para ESP BRAINROT tenta detectar Models/Parts com "Brainrot" no nome, ou com NumberValue/IntValue chamado
--   "ValuePerSecond", "Value", "DPS" (ajuste conforme o jogo real).
-- - ESP TEMPO tenta detectar objetos com NumberValue chamado "Time", "TimeRemaining" ou "Timer".
-- - Se o jogo usa nomes/estrutura diferente, ajuste os detectores (funções isBrainrotCandidate / isTimeCandidate).
-- - O painel é movível arrastando a barra superior; o ícone de abrir é estilizado (diamante/azul).
-- - Fecha/abre clicando no ícone ou pressionando Control (Esquerdo/Direito).
-- - Categoria "VIZUAL" contém: ESP PLAYER, ESP BRAINROT, ESP TEMPO, RAIO X.
-- - Use com responsabilidade; adapte os detectores ao seu jogo.

-- Anti-duplicação
pcall(function()
	if getgenv then
		if getgenv().ZK_HUB_V4_LOADED then return end
		getgenv().ZK_HUB_V4_LOADED = true
	end
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

-- Theme (diamond-blue / aqua)
local DIAMOND = Color3.fromRGB(24, 216, 221)   -- cor mais viva tipo "diamante"
local DIAMOND_DARK = Color3.fromRGB(6, 120, 122)
local GOLD = Color3.fromRGB(255, 200, 40)
local WHITE = Color3.fromRGB(255,255,255)
local PANEL_BG = Color3.fromRGB(8, 14, 20)
local TEXT = Color3.fromRGB(235,245,244)

-- Sizes
local isTouch = UserInputService.TouchEnabled
local ICON_SIZE = isTouch and UDim2.new(0,72,0,72) or UDim2.new(0,120,0,120)
local PANEL_DEFAULT_SIZE = isTouch and UDim2.new(0,560,0,360) or UDim2.new(0,1080,0,680)
local PANEL_MIN_SIZE = Vector2.new(420, 260)
local PANEL_MAX_SIZE = Vector2.new(1600, 1000)

local TWEEN = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Cleanup existing
local old = playerGui:FindFirstChild("ZKHubGui")
if old then old:Destroy() end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZKHubGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 9999
screenGui.Parent = playerGui

-- ---------- Icon (quadradinho com ZK) ----------
local icon = Instance.new("TextButton")
icon.Name = "ZKIcon"
icon.Size = ICON_SIZE
icon.Position = UDim2.new(0.03, 0, 0.38, 0)
icon.AnchorPoint = Vector2.new(0,0)
icon.BackgroundColor3 = DIAMOND_DARK
icon.BorderSizePixel = 0
icon.Text = "ZK"
icon.Font = Enum.Font.GothamBlack
icon.TextSize = isTouch and 20 or 44
icon.TextColor3 = TEXT
icon.AutoButtonColor = true
icon.ZIndex = 50
icon.Parent = screenGui

local iconCorner = Instance.new("UICorner", icon)
iconCorner.CornerRadius = UDim.new(0, 16)
local iconStroke = Instance.new("UIStroke", icon)
iconStroke.Color = DIAMOND
iconStroke.Thickness = 4

-- icon shadow
local iconShadow = Instance.new("Frame", icon)
iconShadow.Name = "Shadow"
iconShadow.Size = UDim2.new(1,10,1,10)
iconShadow.Position = UDim2.new(0,-5,0,-5)
iconShadow.BackgroundColor3 = Color3.new(0,0,0)
iconShadow.BackgroundTransparency = 0.82
iconShadow.BorderSizePixel = 0
iconShadow.ZIndex = icon.ZIndex - 1
local iconShadowCorner = Instance.new("UICorner", iconShadow)
iconShadowCorner.CornerRadius = UDim.new(0,16)

-- nice gradient on icon
local iconGrad = Instance.new("UIGradient", icon)
iconGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(14,170,175)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(26,226,232))
}
iconGrad.Rotation = 45

-- ---------- Panel ----------
local panel = Instance.new("Frame")
panel.Name = "ZKPanel"
panel.Size = PANEL_DEFAULT_SIZE
panel.Position = UDim2.new(0.5, -PANEL_DEFAULT_SIZE.X.Offset/2, 0.5, -PANEL_DEFAULT_SIZE.Y.Offset/2)
panel.AnchorPoint = Vector2.new(0,0)
panel.BackgroundColor3 = PANEL_BG
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 60
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0, 18)
local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = DIAMOND
panelStroke.Thickness = isTouch and 3 or 5
local panelGrad = Instance.new("UIGradient", panel)
panelGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(12,18,26)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(6,12,18))
}
panelGrad.Rotation = 90

-- Title bar (draggable)
local titleBar = Instance.new("Frame", panel)
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 64)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundTransparency = 1
titleBar.ZIndex = panel.ZIndex + 2

local title = Instance.new("TextLabel", titleBar)
title.Name = "Title"
title.Size = UDim2.new(1, -32, 1, 0)
title.Position = UDim2.new(0, 16, 0, 12)
title.BackgroundTransparency = 1
title.Text = "ZK HUB - ROUBE UM BRAINROT"
title.Font = Enum.Font.GothamBold
title.TextSize = isTouch and 18 or 24
title.TextColor3 = DIAMOND
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = panel.ZIndex + 3

-- Make panel draggable by titleBar
do
	local dragging = false
	local dragInput, dragStart, startPos
	titleBar.InputBegan:Connect(function(input)
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
	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Resize grip bottom-right
local resizeGrip = Instance.new("Frame", panel)
resizeGrip.Name = "ResizeGrip"
resizeGrip.Size = UDim2.new(0, 28, 0, 28)
resizeGrip.Position = UDim2.new(1, -36, 1, -36)
resizeGrip.BackgroundColor3 = Color3.fromRGB(14,18,24)
resizeGrip.BorderSizePixel = 0
resizeGrip.ZIndex = panel.ZIndex + 2
local resizeIcon = Instance.new("TextLabel", resizeGrip)
resizeIcon.Size = UDim2.new(1,0,1,0)
resizeIcon.BackgroundTransparency = 1
resizeIcon.Text = "◢"
resizeIcon.Font = Enum.Font.GothamSemibold
resizeIcon.TextColor3 = Color3.fromRGB(140,170,165)
resizeIcon.TextScaled = true

do
	local resizing = false
	local startMouse, startSize
	resizeGrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			startMouse = input.Position
			startSize = Vector2.new(panel.AbsoluteSize.X, panel.AbsoluteSize.Y)
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then resizing = false end
			end)
		end
	end)
	resizeGrip.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then resizeMouse = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if resizing and input == resizeMouse then
			local delta = input.Position - startMouse
			local newSize = startSize + Vector2.new(delta.X, delta.Y)
			newSize = Vector2.new(math.clamp(newSize.X, PANEL_MIN_SIZE.X, PANEL_MAX_SIZE.X), math.clamp(newSize.Y, PANEL_MIN_SIZE.Y, PANEL_MAX_SIZE.Y))
			panel.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
			-- reposition resizeGrip
			resizeGrip.Position = UDim2.new(1, -36, 1, -36)
		end
	end)
end

-- Left categories + right content
local leftWidth = isTouch and 180 or 260
local leftPanel = Instance.new("Frame", panel)
leftPanel.Name = "Left"
leftPanel.Size = UDim2.new(0, leftWidth, 1, -96)
leftPanel.Position = UDim2.new(0, 16, 0, 72)
leftPanel.BackgroundTransparency = 1
leftPanel.ZIndex = panel.ZIndex + 2

local leftBg = Instance.new("Frame", leftPanel)
leftBg.Size = UDim2.new(1, 0, 1, 0)
leftBg.BackgroundColor3 = Color3.fromRGB(6,10,14)
leftBg.BorderSizePixel = 0
local leftCorner = Instance.new("UICorner", leftBg)
leftCorner.CornerRadius = UDim.new(0,12)
local leftStroke = Instance.new("UIStroke", leftBg)
leftStroke.Color = Color3.fromRGB(18,26,32)
leftStroke.Thickness = 1

local leftList = Instance.new("Frame", leftBg)
leftList.Size = UDim2.new(1, -16, 1, -16)
leftList.Position = UDim2.new(0, 8, 0, 8)
leftList.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout", leftList)
listLayout.Padding = UDim.new(0,8)
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content area (right)
local contentArea = Instance.new("Frame", panel)
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -leftWidth - 56, 1, -96)
contentArea.Position = UDim2.new(0, leftWidth + 32, 0, 72)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = panel.ZIndex + 2

local contentCard = Instance.new("Frame", contentArea)
contentCard.Size = UDim2.new(1,0,1,0)
contentCard.BackgroundColor3 = Color3.fromRGB(6,10,14)
contentCard.BorderSizePixel = 0
local contentCorner = Instance.new("UICorner", contentCard)
contentCorner.CornerRadius = UDim.new(0,12)
local contentStroke = Instance.new("UIStroke", contentCard)
contentStroke.Color = Color3.fromRGB(14,24,30)
contentStroke.Thickness = 1

local contentHeader = Instance.new("Frame", contentCard)
contentHeader.Size = UDim2.new(1, -24, 0, 44)
contentHeader.Position = UDim2.new(0,12,0,12)
contentHeader.BackgroundTransparency = 1

local contentTitle = Instance.new("TextLabel", contentHeader)
contentTitle.Size = UDim2.new(1,0,1,0)
contentTitle.BackgroundTransparency = 1
contentTitle.Font = Enum.Font.GothamSemibold
contentTitle.TextSize = isTouch and 18 or 20
contentTitle.TextColor3 = DIAMOND
contentTitle.TextXAlignment = Enum.TextXAlignment.Left

local contentBody = Instance.new("TextLabel", contentCard)
contentBody.Size = UDim2.new(1, -24, 1, -72)
contentBody.Position = UDim2.new(0,12,0,68)
contentBody.BackgroundTransparency = 1
contentBody.Font = Enum.Font.Gotham
contentBody.TextSize = 16
contentBody.TextColor3 = TEXT
contentBody.TextXAlignment = Enum.TextXAlignment.Left
contentBody.TextYAlignment = Enum.TextYAlignment.Top
contentBody.TextWrapped = true

-- Categories: exactly 5
local categories = {"PRINCIPAL", "ROUBO", "JOGADOR", "VIZUAL", "SERVIDOR"}
local catButtons = {}
local selectedCat = categories[1]

local function setCategory(name)
	selectedCat = name
	contentTitle.Text = name
	contentBody.Text = "Categoria selecionada: "..name.."\n\n(Opções aparecerão aqui.)"
	-- show/hide visual controls
	if name == "VIZUAL" then
		visualControls.Visible = true
	else
		visualControls.Visible = false
	end
	-- style buttons
	for _,b in ipairs(catButtons) do
		if b._name == name then
			b.BackgroundTransparency = 0
			b.BackgroundColor3 = DIAMOND
			b.TextColor3 = Color3.fromRGB(8,12,14)
		else
			b.BackgroundTransparency = 1
			b.TextColor3 = Color3.fromRGB(180,200,210)
		end
	end
end

for i,name in ipairs(categories) do
	local b = Instance.new("TextButton", leftList)
	b.Name = "Cat_"..i
	b.Size = UDim2.new(1, -12, 0, isTouch and 44 or 48)
	b.LayoutOrder = i
	b.Position = UDim2.new(0,8,0,0)
	b.BackgroundTransparency = 1
	b.Text = name
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = isTouch and 16 or 18
	b.TextColor3 = Color3.fromRGB(180,200,210)
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.AutoButtonColor = true
	b.ZIndex = leftList.ZIndex + 1
	local c = Instance.new("UICorner", b)
	c.CornerRadius = UDim.new(0,8)
	b._name = name
	b.MouseButton1Click:Connect(function()
		setCategory(name)
	end)
	table.insert(catButtons, b)
end

-- Select initial
setCategory(categories[1])

-- ---------- VISUAL CONTROLS (only visible when VIZUAL selected) ----------
local visualControls = Instance.new("Frame", contentCard)
visualControls.Name = "VisualControls"
visualControls.Size = UDim2.new(1, -24, 0, 140)
visualControls.Position = UDim2.new(0, 12, 0, 12)
visualControls.BackgroundTransparency = 1
visualControls.ZIndex = contentCard.ZIndex + 1
visualControls.Visible = false

-- helper to create a compact row: label + toggle
local function makeToggleRow(parent, x, labelText)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 44)
	row.Position = UDim2.new(0, 0, 0, x)
	row.BackgroundTransparency = 1

	local lbl = Instance.new("TextLabel", row)
	lbl.Size = UDim2.new(0.6, 0, 1, 0)
	lbl.Position = UDim2.new(0, 4, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 16
	lbl.Text = labelText
	lbl.TextColor3 = TEXT
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local btn = Instance.new("TextButton", row)
	btn.Size = UDim2.new(0, 120, 0, 36)
	btn.Position = UDim2.new(1, -124, 0.5, -18)
	btn.BackgroundColor3 = Color3.fromRGB(20,28,34)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Text = "OFF"
	btn.TextColor3 = Color3.fromRGB(200,220,215)
	btn.AutoButtonColor = true
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 8)
	local btnStroke = Instance.new("UIStroke", btn)
	btnStroke.Color = Color3.fromRGB(40,50,60)
	return row, lbl, btn
end

-- Rows: ESP PLAYER, ESP BRAINROT, ESP TEMPO, RAIO X
local row1 = makeToggleRow(visualControls, 0, "ESP PLAYER (Visual)")
local row2 = makeToggleRow(visualControls, 48, "ESP BRAINROT (Destaque o melhor)")
local row3 = makeToggleRow(visualControls, 96, "ESP TEMPO (Bases / Timers)")
local row4 = makeToggleRow(visualControls, 144, "RAIO X (Diminar objetos)")

-- ESP state
local espPlayersOn = false
local espBrainrotOn = false
local espTempoOn = false
local raioXOn = false

local highlightsPlayers = {} -- player -> highlight
local highlightsBrainrots = {} -- model -> highlight + ui
local timeGuis = {} -- object -> billboard
local raioXModified = {} -- part -> originalLocalTransparency (we'll store 0 revert)

-- Utility: safe CreateHighlight
local function createHighlightForModel(model, fillColor, outlineColor, fillTransparency, outlineTransparency, alwaysOnTop)
	if not model then return nil end
	local ok, h = pcall(function()
		local highlight = Instance.new("Highlight")
		highlight.Name = "ZK_ESP"
		highlight.Parent = model
		highlight.FillColor = fillColor
		highlight.OutlineColor = outlineColor
		highlight.FillTransparency = fillTransparency
		highlight.OutlineTransparency = outlineTransparency
		pcall(function()
			highlight.DepthMode = alwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
		end)
		return highlight
	end)
	if ok then return h end
	return nil
end

-- ESP PLAYER functions
local function addPlayerHighlight(pl)
	if not pl or pl == player then return end
	if highlightsPlayers[pl] then return end
	if not pl.Character or not pl.Character.Parent then return end
	local h = createHighlightForModel(pl.Character, DIAMOND, WHITE, 0.45, 0.12, true) -- more vivid, through everything
	if h then highlightsPlayers[pl] = h end
end

local function removePlayerHighlight(pl)
	if highlightsPlayers[pl] then
		pcall(function() highlightsPlayers[pl]:Destroy() end)
		highlightsPlayers[pl] = nil
	end
end

local function enableEspPlayers()
	if espPlayersOn then return end
	espPlayersOn = true
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= player and pl.Character and pl.Character.Parent then
			addPlayerHighlight(pl)
		end
		-- attach CharacterAdded
		pl.CharacterAdded:Connect(function(char)
			if espPlayersOn and pl ~= player then
				task.wait(0.05)
				addPlayerHighlight(pl)
			end
		end)
	end
	Players.PlayerAdded:Connect(function(pl)
		pl.CharacterAdded:Connect(function(char)
			if espPlayersOn and pl ~= player then
				task.wait(0.05)
				addPlayerHighlight(pl)
			end
		end)
	end)
end

local function disableEspPlayers()
	if not espPlayersOn then return end
	espPlayersOn = false
	for pl, h in pairs(highlightsPlayers) do
		pcall(function() h:Destroy() end)
		highlightsPlayers[pl] = nil
	end
end

-- Helper: find brainrot candidates
local function isBrainrotCandidate(obj)
	-- check by name
	if obj.Name:lower():find("brainrot") then return true end
	-- check if model has a NumberValue with likely names
	for _,v in ipairs(obj:GetChildren()) do
		if v:IsA("NumberValue") or v:IsA("IntValue") then
			local n = v.Name:lower()
			if n:find("valuepersecond") or n:find("value") or n:find("dps") or n:find("coinspersecond") then
				return true
			end
		end
	end
	return false
end

-- helper: get display name and DPS value for a brainrot model
local function getBrainrotInfo(model)
	-- try common fields
	local name = model.Name
	local value = nil
	for _,v in ipairs(model:GetChildren()) do
		if (v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("DoubleConstrainedValue")) then
			local n = v.Name:lower()
			if n:find("valuepersecond") or n:find("dps") or n:find("value") or n:find("amount") or n:find("coins") then
				value = v.Value
				break
			end
		end
	end
	-- fallback: check Attributes
	local attr = model:GetAttribute("ValuePerSecond") or model:GetAttribute("Value") or model:GetAttribute("DPS")
	if not value and attr then value = attr end
	return name, value
end

-- Create UI label above a model (name + value)
local function createBillboardForModel(model, displayName, value, color)
	if not model then return nil end
	local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
	if not primary then return nil end
	local bb = Instance.new("BillboardGui")
	bb.Name = "ZK_BB"
	bb.Adornee = primary
	bb.Size = UDim2.new(0,200,0,60)
	bb.StudsOffset = Vector3.new(0, 2.5, 0)
	bb.AlwaysOnTop = true
	bb.MaxDistance = 200
	bb.Parent = primary

	local frame = Instance.new("Frame", bb)
	frame.Size = UDim2.new(1,0,1,0)
	frame.BackgroundTransparency = 1

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 24)
	title.Position = UDim2.new(0,0,0,0)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.Text = displayName or model.Name
	title.TextColor3 = color or DIAMOND
	title.TextScaled = false
	title.TextXAlignment = Enum.TextXAlignment.Center

	local valLabel = Instance.new("TextLabel", frame)
	valLabel.Size = UDim2.new(1, 0, 0, 20)
	valLabel.Position = UDim2.new(0,0,0,28)
	valLabel.BackgroundTransparency = 1
	valLabel.Font = Enum.Font.Gotham
	valLabel.TextSize = 16
	if value then
		valLabel.Text = tostring(value).. " /s"
		valLabel.TextColor3 = Color3.fromRGB(120, 255, 140) -- green value
	else
		valLabel.Text = "valor desconhecido"
		valLabel.TextColor3 = Color3.fromRGB(200,200,200)
	end
	valLabel.TextXAlignment = Enum.TextXAlignment.Center

	return bb
end

-- Beam (rainbow line) between player and target
local beams = {} -- model -> {beam, attachments...}
local function createBeamFromPlayerToModel(pl, model)
	if not pl.Character or not pl.Character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
	local targetPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
	if not targetPart then return end

	-- remove old beam for this model if exists
	if beams[model] then
		pcall(function() 
			for _,o in ipairs(beams[model]) do if o and o.Parent then o:Destroy() end end
		end)
		beams[model] = nil
	end

	-- Create attachments
	local att1 = Instance.new("Attachment", hrp)
	att1.Name = "ZKBeamAtt1"
	att1.Position = Vector3.new(0,0.5,0)
	local att2 = Instance.new("Attachment", targetPart)
	att2.Name = "ZKBeamAtt2"
	att2.Position = Vector3.new(0, (targetPart.Size.Y/2)+0.5, 0)

	local beamPart = Instance.new("Part")
	beamPart.Name = "ZKBeamPart"
	beamPart.Size = Vector3.new(0.2,0.2,0.2)
	beamPart.Transparency = 1
	beamPart.CanCollide = false
	beamPart.Anchored = true
	beamPart.Parent = workspace

	local beam = Instance.new("Beam", beamPart)
	beam.Attachment0 = att1
	beam.Attachment1 = att2
	beam.Width0 = 0.06
	beam.Width1 = 0.06
	beam.FaceCamera = true
	beam.LightEmission = 1
	beam.Texture = ""
	-- initial rainbow color sequence
	beam.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,255))
	}
	-- store and animate color
	beams[model] = {beam=beam, att1=att1, att2=att2, part=beamPart, offset=0}
end

-- animate beams rainbow by rotating hue
local function shiftColor(c, h)
	-- convert RGB to HSV, shift H, convert back
	local h0, s, v = Color3.toHSV(c)
	h0 = (h0 + h) % 1
	return Color3.fromHSV(h0, s, v)
end

RunService.Heartbeat:Connect(function(dt)
	-- animate beams
	for model,data in pairs(beams) do
		if data.beam and data.beam.Parent then
			data.offset = (data.offset + dt*0.1) % 1
			local cs = ColorSequence.new{
				ColorSequenceKeypoint.new(0, shiftColor(DIAMOND, data.offset)),
				ColorSequenceKeypoint.new(0.5, shiftColor(DIAMOND, data.offset + 0.33)),
				ColorSequenceKeypoint.new(1, shiftColor(DIAMOND, data.offset + 0.66))
			}
			pcall(function() data.beam.Color = cs end)
		end
	end
end)

-- find brainrots in workspace
local function scanBrainrots()
	local found = {}
	for _,obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") then
			if isBrainrotCandidate(obj) then
				table.insert(found, obj)
			end
		end
	end
	return found
end

-- Manage brainrot highlights + labels + beam to local player
local function enableEspBrainrots()
	if espBrainrotOn then return end
	espBrainrotOn = true
	-- scan and add
	local list = scanBrainrots()
	for _,m in ipairs(list) do
		if not highlightsBrainrots[m] then
			local h = createHighlightForModel(m, DIAMOND, WHITE, 0.45, 0.12, true)
			local name, val = getBrainrotInfo(m)
			local bb = createBillboardForModel(m, name, val, GOLD)
			-- beam from me to best brainrot will be created separately when marking best
			highlightsBrainrots[m] = {highlight = h, billboard = bb}
		end
	end
	-- listen to future models appearing
	workspace.DescendantAdded:Connect(function(obj)
		if obj:IsA("Model") and isBrainrotCandidate(obj) then
			task.wait(0.05)
			if espBrainrotOn and not highlightsBrainrots[obj] then
				local h = createHighlightForModel(obj, DIAMOND, WHITE, 0.45, 0.12, true)
				local name, val = getBrainrotInfo(obj)
				local bb = createBillboardForModel(obj, name, val, GOLD)
				highlightsBrainrots[obj] = {highlight = h, billboard = bb}
			end
		end
	end)
	-- pick best brainrot (highest value) and create golden highlight & beam
	local function updateBest()
		local best, bestVal = nil, -math.huge
		for m,info in pairs(highlightsBrainrots) do
			if m and m.Parent then
				local _, v = getBrainrotInfo(m)
				if type(v) == "number" and v > bestVal then
					bestVal = v
					best = m
				end
			end
		end
		-- mark all brainrots as diamond blue except best becomes gold
		for m,info in pairs(highlightsBrainrots) do
			if info.highlight and info.highlight.Parent then
				if m == best then
					info.highlight.FillColor = GOLD
					info.highlight.OutlineColor = WHITE
					-- ensure billboard color
					if info.billboard and info.billboard.Parent then
						for _,c in ipairs(info.billboard:GetDescendants()) do
							if c:IsA("TextLabel") and c.Name ~= nil then
								c.TextColor3 = GOLD
							end
						end
					end
					-- create beam from player to best
					createBeamFromPlayer(player, m)
				else
					info.highlight.FillColor = DIAMOND
					info.highlight.OutlineColor = WHITE
				end
			end
		end
	end

	-- call once and every 3s to update best
	spawn(function()
		while espBrainrotOn do
			updateBest()
			task.wait(3)
		end
	end)
end

local function disableEspBrainrots()
	if not espBrainrotOn then return end
	espBrainrotOn = false
	-- destroy highlights, billboards, beams
	for m,info in pairs(highlightsBrainrots) do
		pcall(function()
			if info.highlight then info.highlight:Destroy() end
			if info.billboard then info.billboard:Destroy() end
		end)
	end
	highlightsBrainrots = {}
	-- destroy beams
	for m,data in pairs(beams) do
		for _,obj in ipairs(data) do pcall(function() if obj then obj:Destroy() end end) end
		beams[m] = nil
	end
end

-- ESP TEMPO (scan for objects with NumberValue named Time/Timer/TimeRemaining)
local function isTimeCandidate(obj)
	for _,v in ipairs(obj:GetChildren()) do
		if v:IsA("NumberValue") or v:IsA("IntValue") then
			local n = v.Name:lower()
			if n:find("time") or n:find("timer") or n:find("cooldown") or n:find("remaining") then
				return true
			end
		end
	end
	return false
end

local function findTimeValue(obj)
	for _,v in ipairs(obj:GetChildren()) do
		if (v:IsA("NumberValue") or v:IsA("IntValue")) then
			local n = v.Name:lower()
			if n:find("time") or n:find("timer") or n:find("cooldown") or n:find("remaining") then
				return v
			end
		end
	end
	return nil
end

local function enableEspTempo()
	if espTempoOn then return end
	espTempoOn = true
	-- scan workspace for candidates
	for _,obj in ipairs(workspace:GetDescendants()) do
		if (obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart")) and isTimeCandidate(obj) then
			local primary = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true) or obj.PrimaryPart
			if primary then
				-- create billboard
				local tv = findTimeValue(obj)
				local bb = Instance.new("BillboardGui")
				bb.Name = "ZK_TIME"
				bb.Adornee = primary
				bb.Size = UDim2.new(0,140,0,40)
				bb.StudsOffset = Vector3.new(0, 2, 0)
				bb.AlwaysOnTop = true
				bb.Parent = primary
				local f = Instance.new("Frame", bb)
				f.Size = UDim2.new(1,0,1,0)
				f.BackgroundTransparency = 1
				local lbl = Instance.new("TextLabel", f)
				lbl.Size = UDim2.new(1,0,1,0)
				lbl.BackgroundTransparency = 1
				lbl.Font = Enum.Font.GothamBold
				lbl.TextSize = 16
				lbl.TextColor3 = Color3.fromRGB(255,255,255)
				lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
				lbl.TextStrokeTransparency = 0.4
				lbl.Text = tv and tostring(math.floor(tv.Value)).."s" or "tempo"
				timeGuis[primary] = {gui = bb, valueObj = tv}
			end
		end
	end
	-- update loop
	spawn(function()
		while espTempoOn do
			for primary,dat in pairs(timeGuis) do
				if dat.valueObj and dat.gui and dat.gui.Parent then
					local lbl = dat.gui:FindFirstChildOfClass("Frame") and dat.gui.Frame:FindFirstChildWhichIsA("TextLabel")
					if lbl then
						pcall(function()
							lbl.Text = tostring(math.floor(dat.valueObj.Value)).."s"
						end)
					end
				end
			end
			task.wait(0.7)
		end
	end)
end

local function disableEspTempo()
	if not espTempoOn then return end
	espTempoOn = false
	for primary,dat in pairs(timeGuis) do
		pcall(function() if dat.gui then dat.gui:Destroy() end end)
	end
	timeGuis = {}
end

-- RAIO X: lower transparency of world objects (client-side) using LocalTransparencyModifier
local function enableRaioX()
	if raioXOn then return end
	raioXOn = true
	for _,obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character or workspace.Terrain) then
			-- avoid changing player's characters
			local ok, _ = pcall(function()
				-- store previous (we store 0 - but can store custom attr if needed)
				raioXModified[obj] = true
				obj.LocalTransparencyModifier = math.clamp(obj.LocalTransparencyModifier + 0.45, 0, 1)
			end)
		end
	end
end

local function disableRaioX()
	if not raioXOn then return end
	raioXOn = false
	for obj,_ in pairs(raioXModified) do
		pcall(function() if obj and obj.Parent then obj.LocalTransparencyModifier = 0 end end)
	end
	raioXModified = {}
end

-- Toggle handlers for UI
row1[3].MouseButton1Click:Connect(function()
	if not espPlayersOn then
		enableEspPlayers()
		row1[3].Text = "ON"
		row1[3].BackgroundColor3 = DIAMOND
		row1[3].TextColor3 = Color3.fromRGB(8,12,14)
	else
		disableEspPlayers()
		row1[3].Text = "OFF"
		row1[3].BackgroundColor3 = Color3.fromRGB(20,28,34)
		row1[3].TextColor3 = Color3.fromRGB(200,220,215)
	end
end)

row2[3].MouseButton1Click:Connect(function()
	if not espBrainrotOn then
		enableEspBrainrots()
		row2[3].Text = "ON"
		row2[3].BackgroundColor3 = GOLD
		row2[3].TextColor3 = Color3.fromRGB(8,12,14)
	else
		disableEspBrainrots()
		row2[3].Text = "OFF"
		row2[3].BackgroundColor3 = Color3.fromRGB(20,28,34)
		row2[3].TextColor3 = Color3.fromRGB(200,220,215)
	end
end)

row3[3].MouseButton1Click:Connect(function()
	if not espTempoOn then
		enableEspTempo()
		row3[3].Text = "ON"
		row3[3].BackgroundColor3 = DIAMOND
		row3[3].TextColor3 = Color3.fromRGB(8,12,14)
	else
		disableEspTempo()
		row3[3].Text = "OFF"
		row3[3].BackgroundColor3 = Color3.fromRGB(20,28,34)
		row3[3].TextColor3 = Color3.fromRGB(200,220,215)
	end
end)

row4[3].MouseButton1Click:Connect(function()
	if not raioXOn then
		enableRaioX()
		row4[3].Text = "ON"
		row4[3].BackgroundColor3 = DIAMOND
		row4[3].TextColor3 = Color3.fromRGB(8,12,14)
	else
		disableRaioX()
		row4[3].Text = "OFF"
		row4[3].BackgroundColor3 = Color3.fromRGB(20,28,34)
		row4[3].TextColor3 = Color3.fromRGB(200,220,215)
	end
end)

-- ---------- Open/Close logic ----------
local panelVisible = false
local function showPanel()
	if panelVisible then return end
	panel.Visible = true
	panel.Position = UDim2.new(0.5, -panel.Size.X.Offset/2, 0.5, -panel.Size.Y.Offset/2)
	panelVisible = true
end
local function hidePanel()
	if not panelVisible then return end
	panel.Visible = false
	panelVisible = false
end
local function togglePanel()
	if panelVisible then hidePanel() else showPanel() end
end

icon.MouseButton1Click:Connect(function()
	-- click animation
	local a = TweenService:Create(icon, TweenInfo.new(0.08), {Size = UDim2.new(0, ICON_SIZE.X.Offset-10, 0, ICON_SIZE.Y.Offset-10)})
	a:Play()
	a.Completed:Wait()
	TweenService:Create(icon, TweenInfo.new(0.12), {Size = ICON_SIZE}):Play()
	togglePanel()
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
			togglePanel()
		end
	end
end)

-- Ensure new players & respawns handled for ESP players (if turned on)
Players.PlayerAdded:Connect(function(pl)
	pl.CharacterAdded:Connect(function()
		task.wait(0.05)
		if espPlayersOn and pl ~= player then addPlayerHighlight(pl) end
	end)
end)

-- Ensure new brainrots (DescendantAdded path handled inside enableEspBrainrots), but if ESP already on ensure scan
Players.PlayerRemoving:Connect(function(pl)
	-- cleanup highlights for leaving players
	removePlayerHighlight(pl)
end)

-- Finished. Ajuste detectores (isBrainrotCandidate / isTimeCandidate) conforme seu jogo para funcionar 100%.
-- Se quiser que eu reduza/incremente opacidade, troque highlight.FillTransparency valores acima.

-- END
