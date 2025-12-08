-- ZK HUB - Fix do botão e do painel
-- Coloque este LocalScript em StarterGui ou StarterPlayerScripts no Roblox Studio.
-- O script:
-- - Botão de abrir redondo com "ZK" maior.
-- - Painel central redimensionável e arrastável (pela titlebar).
-- - Abrir/fechar ao clicar no ícone OU ao pressionar LeftControl/RightControl (funciona mesmo se a tecla for processada).
-- - Contraste melhorado para que textos apareçam.
-- - Aba "VIZUAL" contendo apenas a opção ESP PLAYER (toggle) — ESP mais vivo e visível mesmo em novos jogadores.
-- Observação: ESP usa Highlight.DepthMode = AlwaysOnTop (quando disponível). Pode depender do cliente/versão.

-- Anti-duplicação
pcall(function()
	if getgenv then
		if getgenv().ZK_HUB_FIX_LOADED then return end
		getgenv().ZK_HUB_FIX_LOADED = true
	end
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

-- Theme
local DIAMOND = Color3.fromRGB(24, 216, 221)
local PANEL_BG = Color3.fromRGB(10, 14, 18)
local TEXT = Color3.fromRGB(230, 245, 244)
local VALUE_GREEN = Color3.fromRGB(120, 255, 140)
local GOLD = Color3.fromRGB(255, 200, 40)
local WHITE = Color3.fromRGB(255,255,255)

-- Sizes
local isTouch = UserInputService.TouchEnabled
local ICON_SIZE = isTouch and UDim2.new(0,72,0,72) or UDim2.new(0,120,0,120)
local PANEL_SIZE = isTouch and UDim2.new(0,560,0,360) or UDim2.new(0,1000,0,640)
local PANEL_MIN = Vector2.new(420,260)
local PANEL_MAX = Vector2.new(1600,1000)
local TWEEN = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Cleanup old UI if exists
local old = playerGui:FindFirstChild("ZKHubGui")
if old then old:Destroy() end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZKHubGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 9999
screenGui.Parent = playerGui

-- ---------- Icon (redondo com "ZK") ----------
local icon = Instance.new("TextButton")
icon.Name = "ZKIcon"
icon.Size = ICON_SIZE
icon.Position = UDim2.new(0.03, 0, 0.38, 0)
icon.AnchorPoint = Vector2.new(0,0)
icon.BackgroundColor3 = DIAMOND
icon.BorderSizePixel = 0
icon.Text = "ZK"
icon.Font = Enum.Font.GothamBlack
icon.TextSize = isTouch and 20 or 40
icon.TextColor3 = Color3.fromRGB(8,12,14) -- dark text to contrast with bright diamond
icon.AutoButtonColor = true
icon.ZIndex = 50
icon.Parent = screenGui

local iconCorner = Instance.new("UICorner", icon)
iconCorner.CornerRadius = UDim.new(1, 0)

local iconStroke = Instance.new("UIStroke", icon)
iconStroke.Color = Color3.fromRGB(210, 255, 250)
iconStroke.Thickness = 3

local iconGrad = Instance.new("UIGradient", icon)
iconGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(14,170,175)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(26,226,232))
}
iconGrad.Rotation = 45

-- Make icon draggable on PC
do
	local dragging = false
	local dragInput, dragStart, startPos
	icon.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = icon.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	icon.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- ---------- Panel ----------
local panel = Instance.new("Frame")
panel.Name = "ZKPanel"
panel.Size = PANEL_SIZE
-- Use AnchorPoint 0.5 to make centering simpler
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, -1.0, 0) -- hidden above screen initially
panel.BackgroundColor3 = PANEL_BG
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 60
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0, 16)

local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = DIAMOND
panelStroke.Thickness = isTouch and 3 or 5

local panelGrad = Instance.new("UIGradient", panel)
panelGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(12,18,26)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8,14,20))
}
panelGrad.Rotation = 90

-- Titlebar (draggable) + title text
local titleBar = Instance.new("Frame", panel)
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 64)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundTransparency = 1
titleBar.ZIndex = panel.ZIndex + 2

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -32, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 12)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ZK HUB - ROUBE UM BRAINROT"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = isTouch and 18 or 24
titleLabel.TextColor3 = DIAMOND
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = panel.ZIndex + 3

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
			-- convert pixel delta to absolute offset based on screen size
			panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Resize grip bottom-right (so user can change size)
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
	local startMousePos, startSize
	local resizeMouse
	resizeGrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			startMousePos = input.Position
			startSize = Vector2.new(panel.AbsoluteSize.X, panel.AbsoluteSize.Y)
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
				end
			end)
		end
	end)
	resizeGrip.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			resizeMouse = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if resizing and input == resizeMouse then
			local delta = input.Position - startMousePos
			local newSize = startSize + Vector2.new(delta.X, delta.Y)
			newSize = Vector2.new(math.clamp(newSize.X, PANEL_MIN.X, PANEL_MAX.X), math.clamp(newSize.Y, PANEL_MIN.Y, PANEL_MAX.Y))
			panel.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
			-- keep center anchor
			panel.Position = UDim2.new(0.5, 0, 0.5, 0)
			resizeGrip.Position = UDim2.new(1, -36, 1, -36)
		end
	end)
end

-- Left categories + right content area
local leftWidth = isTouch and 180 or 260
local leftPanel = Instance.new("Frame", panel)
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, leftWidth, 1, -96)
leftPanel.Position = UDim2.new(0, 16, 0, 72)
leftPanel.BackgroundTransparency = 1
leftPanel.ZIndex = panel.ZIndex + 2

local leftBg = Instance.new("Frame", leftPanel)
leftBg.Size = UDim2.new(1,0,1,0)
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

local UIListLayout = Instance.new("UIListLayout", leftList)
UIListLayout.Padding = UDim.new(0,8)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content area
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
contentHeader.Position = UDim2.new(0, 12, 0, 12)
contentHeader.BackgroundTransparency = 1

local contentTitle = Instance.new("TextLabel", contentHeader)
contentTitle.Size = UDim2.new(1, 0, 1, 0)
contentTitle.BackgroundTransparency = 1
contentTitle.Font = Enum.Font.GothamSemibold
contentTitle.TextSize = isTouch and 18 or 20
contentTitle.TextColor3 = DIAMOND
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.ZIndex = contentCard.ZIndex + 1

local contentBody = Instance.new("TextLabel", contentCard)
contentBody.Size = UDim2.new(1, -24, 1, -72)
contentBody.Position = UDim2.new(0, 12, 0, 68)
contentBody.BackgroundTransparency = 1
contentBody.Font = Enum.Font.Gotham
contentBody.TextSize = 16
contentBody.TextColor3 = TEXT
contentBody.TextXAlignment = Enum.TextXAlignment.Left
contentBody.TextYAlignment = Enum.TextYAlignment.Top
contentBody.TextWrapped = true
contentBody.ZIndex = contentCard.ZIndex + 1

-- Categories: PRINCIPAL, ROUBO, JOGADOR, VIZUAL, SERVIDOR
local categories = {"PRINCIPAL", "ROUBO", "JOGADOR", "VIZUAL", "SERVIDOR"}
local catButtons = {}
local selectedCat = categories[1]

local function clearCatStyles()
	for _,b in ipairs(catButtons) do
		b.BackgroundTransparency = 1
		b.TextColor3 = Color3.fromRGB(180,200,210)
	end
end

local function setCategory(name)
	selectedCat = name
	contentTitle.Text = name
	contentBody.Text = "Categoria selecionada: "..name.."\n\n(Use as opções desta categoria.)"

	-- evita erro se visualControls ainda não existir
	if visualControls ~= nil then
		visualControls.Visible = (name == "VIZUAL")
	end

	for _, b in ipairs(catButtons) do
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
	local btn = Instance.new("TextButton", leftList)
	btn.Name = "Cat_"..i
	btn.Size = UDim2.new(1, -12, 0, isTouch and 44 or 48)
	btn.LayoutOrder = i
	btn.Position = UDim2.new(0, 8, 0, 0)
	btn.BackgroundTransparency = 1
	btn.Text = name
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = isTouch and 16 or 18
	btn.TextColor3 = Color3.fromRGB(180,200,210)
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.AutoButtonColor = true
	btn.ZIndex = leftList.ZIndex + 1
	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0,8)
	btn._name = name
	btn.MouseButton1Click:Connect(function()
		setCategory(name)
	end)
	table.insert(catButtons, btn)
end

-- initial selection
setCategory("PRINCIPAL")

-- ---------- Visual Controls (only visible on VIZUAL) ----------
local visualControls = Instance.new("Frame", contentCard)
visualControls.Name = "VisualControls"
visualControls.Size = UDim2.new(1, -24, 0, 160)
visualControls.Position = UDim2.new(0, 12, 0, 12)
visualControls.BackgroundTransparency = 1
visualControls.ZIndex = contentCard.ZIndex + 1
visualControls.Visible = false

local function makeRow(parent, y, labelText)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 44)
	row.Position = UDim2.new(0, 0, 0, y)
	row.BackgroundTransparency = 1
	local lbl = Instance.new("TextLabel", row)
	lbl.Size = UDim2.new(0.6, 0, 1, 0)
	lbl.Position = UDim2.new(0, 6, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 16
	lbl.Text = labelText
	lbl.TextColor3 = TEXT
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local toggle = Instance.new("TextButton", row)
	toggle.Size = UDim2.new(0, 120, 0, 36)
	toggle.Position = UDim2.new(1, -126, 0.5, -18)
	toggle.BackgroundColor3 = Color3.fromRGB(20,28,34)
	toggle.BorderSizePixel = 0
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 16
	toggle.Text = "OFF"
	toggle.TextColor3 = Color3.fromRGB(200,220,215)
	local tcorner = Instance.new("UICorner", toggle)
	tcorner.CornerRadius = UDim.new(0,8)
	local tstroke = Instance.new("UIStroke", toggle)
	tstroke.Color = Color3.fromRGB(40,50,60)
	return row, lbl, toggle
end

local row1, lbl1, toggle1 = makeRow(visualControls, 0, "ESP PLAYER")
-- Additional visual options previously requested (ESP BRAINROT, ESP TEMPO, RAIO X) omitted here to keep UI minimal;
-- they can be added similarly if you want.

-- ---------- Simple ESP PLAYER implementation ----------
local espOn = false
local highlights = {} -- player -> highlight

local function createHighlightForPlayer(pl)
	if not pl or pl == player then return end
	if highlights[pl] then return end
	if not pl.Character or not pl.Character.Parent then return end
	local ok, h = pcall(function()
		local highlight = Instance.new("Highlight")
		highlight.Name = "ZK_ESP"
		highlight.Parent = pl.Character
		highlight.FillColor = DIAMOND
		highlight.OutlineColor = WHITE
		highlight.FillTransparency = 0.45 -- semi transparent so you can see inside
		highlight.OutlineTransparency = 0.08
		pcall(function()
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		end)
		return highlight
	end)
	if ok and h then highlights[pl] = h end
end

local function destroyHighlightForPlayer(pl)
	if highlights[pl] then
		pcall(function() highlights[pl]:Destroy() end)
		highlights[pl] = nil
	end
end

local function enableESPPlayers()
	if espOn then return end
	espOn = true
	-- for existing players
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl ~= player then
			-- if character exists
			if pl.Character and pl.Character.Parent then
				createHighlightForPlayer(pl)
			end
			-- hook future char loads
			pl.CharacterAdded:Connect(function(char)
				if espOn and pl ~= player then
					task.wait(0.05)
					createHighlightForPlayer(pl)
				end
			end)
		end
	end
	-- new players joining
	Players.PlayerAdded:Connect(function(pl)
		if pl ~= player then
			pl.CharacterAdded:Connect(function(char)
				if espOn then
					task.wait(0.05)
					createHighlightForPlayer(pl)
				end
			end)
		end
	end)
end

local function disableESPPlayers()
	if not espOn then return end
	espOn = false
	for pl, h in pairs(highlights) do
		pcall(function() h:Destroy() end)
	end
	highlights = {}
end

toggle1.MouseButton1Click:Connect(function()
	if not espOn then
		enableESPPlayers()
		toggle1.Text = "ON"
		toggle1.BackgroundColor3 = DIAMOND
		toggle1.TextColor3 = Color3.fromRGB(8,12,14)
	else
		disableESPPlayers()
		toggle1.Text = "OFF"
		toggle1.BackgroundColor3 = Color3.fromRGB(20,28,34)
		toggle1.TextColor3 = Color3.fromRGB(200,220,215)
	end
end)

-- Ensure we clean highlights for players who leave
Players.PlayerRemoving:Connect(function(pl)
	destroyHighlightForPlayer(pl)
end)

-- Also hook existing players' CharacterAdded (for respawns)
for _,pl in ipairs(Players:GetPlayers()) do
	pl.CharacterAdded:Connect(function()
		task.wait(0.05)
		if espOn and pl ~= player then
			createHighlightForPlayer(pl)
		end
	end)
end

-- ---------- Open/Close logic (fixed) ----------
local panelVisible = false
local shownPos = UDim2.new(0.5, 0, 0.5, 0)
local hiddenPos = UDim2.new(0.5, 0, -1.2, 0)

local function showPanel()
	if panelVisible then return end
	panelVisible = true
	panel.Visible = true
	panel.AnchorPoint = Vector2.new(0.5, 0.5)
	panel.Position = hiddenPos
	TweenService:Create(panel, TWEEN, {Position = shownPos}):Play()
end

local function hidePanel()
	if not panelVisible then return end
	panelVisible = false
	TweenService:Create(panel, TWEEN, {Position = hiddenPos}):Play()
	delay(TWEEN.Time, function() panel.Visible = false end)
end

local function togglePanel()
	if panelVisible then hidePanel() else showPanel() end
end

-- Click icon toggles
icon.MouseButton1Click:Connect(function()
	-- small click animation
	local s1 = TweenService:Create(icon, TweenInfo.new(0.08), {Size = UDim2.new(0, ICON_SIZE.X.Offset-10, 0, ICON_SIZE.Y.Offset-10)})
	s1:Play()
	s1.Completed:Wait()
	TweenService:Create(icon, TweenInfo.new(0.12), {Size = ICON_SIZE}):Play()
	togglePanel()
end)

-- Control key toggles (Left or Right). We intentionally ignore 'processed' so Control toggles even when UI is focused.
UserInputService.InputBegan:Connect(function(input, processed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
			togglePanel()
		end
	end
end)

-- Ensure panel is centered when resizing or on creation
panel.Position = hiddenPos

-- Bring text and content to front to avoid being invisible
titleLabel.ZIndex = panel.ZIndex + 2
contentTitle.ZIndex = panel.ZIndex + 2
contentBody.ZIndex = panel.ZIndex + 2

-- Finished: this version fixes the open/close issue, makes icon round with big "ZK",
-- improves text contrast, ensures ESP highlights new players, and makes panel movable/resizable.
-- Tell me if you want the additional visual options (ESP Brainrot, ESP Tempo, RAIO X) re-added in this cleaned-up version.
