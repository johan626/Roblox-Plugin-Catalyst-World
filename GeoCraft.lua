-- GeoCraft.lua
-- This script will be the main entry point for the plugin
-- It will create the UI and handle the main logic

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetService = game:GetService("AssetService")

-- [[ THEME & STYLING ]] --
-- Centralized color palette and UI styling parameters
-- New Theme: "Modern & Functional" (Neutral Dark Mode with Blue Accent)
local Theme = {
	-- Main Colors
	Background = Color3.fromRGB(36, 36, 39),        -- Softer dark grey
	ContentBackground = Color3.fromRGB(42, 42, 46), -- Lighter grey for content areas
	HeaderBackground = Color3.fromRGB(55, 55, 60),   -- Header bar color
	InputBackground = Color3.fromRGB(30, 30, 33),    -- Input fields background
	DefaultButton = Color3.fromRGB(60, 60, 65),      -- Default state for buttons

	-- Text Colors
	Text = Color3.fromRGB(230, 230, 235),       -- Primary text color, bright off-white
	TextLight = Color3.fromRGB(255, 255, 255),     -- For titles or important text
	TextMuted = Color3.fromRGB(160, 160, 170),     -- For less important text or hints

	-- Accent Colors
	Primary = Color3.fromRGB(0, 122, 204),        -- Professional Blue
	Success = Color3.fromRGB(30, 180, 100),        -- Softer green
	Danger = Color3.fromRGB(230, 70, 70),          -- Softer red
	Warning = Color3.fromRGB(240, 170, 60),        -- Softer orange
	Selected = Color3.fromRGB(0, 122, 204),       -- Professional Blue for selected items

	-- UI Properties
	CornerRadius = UDim.new(0, 4),
	Font = Enum.Font.SourceSans,
	FontBold = Enum.Font.SourceSansBold,
}
-- [[ END THEME ]] --

-- Create the main plugin widget
local dockWidget = plugin:CreateDockWidgetPluginGui(
	"GeoCraft",
	DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float, -- Initial state
		false,						 -- Enabled
		false,						 -- Override publisher name
		225,						 -- Width
		400,						 -- Height
		225,						 -- Min width
		400							 -- Min height
	)
)

dockWidget.Title = "GeoCraft - Terrain Generator"

-- Create the UI elements inside the widget
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.Parent = dockWidget

-- New structure
mainFrame.LayoutOrder = -1 -- Ensure it's not affected by any lingering layouts

-- Header Frame (for preview)
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 180)
headerFrame.BackgroundColor3 = Theme.Background
headerFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Text = "GeoCraft"
titleLabel.Font = Theme.FontBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Theme.TextLight
titleLabel.BackgroundColor3 = Theme.HeaderBackground
titleLabel.Parent = headerFrame

-- Tab Navigation Frame
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -10, 0, 30)
tabFrame.Position = UDim2.new(0, 5, 0, 185)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame
local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabFrame

-- Tab Content Container (this will hold the different pages)
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -10, 1, -270) -- Adjusted size
contentContainer.Position = UDim2.new(0, 5, 0, 220)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- Action Bar Frame (fixed at the bottom)
local actionBarFrame = Instance.new("Frame")
actionBarFrame.Size = UDim2.new(1, -10, 0, 40)
actionBarFrame.Position = UDim2.new(0, 5, 1, -45)
actionBarFrame.BackgroundTransparency = 1
actionBarFrame.Parent = mainFrame

local actionBarLayout = Instance.new("UIListLayout")
actionBarLayout.FillDirection = Enum.FillDirection.Horizontal
actionBarLayout.Padding = UDim.new(0, 5)
actionBarLayout.Parent = actionBarFrame

-- Create a ViewportFrame for the 3D preview
local previewFrame = Instance.new("ViewportFrame")
previewFrame.Size = UDim2.new(1, -10, 1, -35)
previewFrame.Position = UDim2.new(0, 5, 0, 30)
previewFrame.BackgroundColor3 = Theme.InputBackground
previewFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
previewFrame.Parent = headerFrame
local previewCorner = Instance.new("UICorner")
previewCorner.CornerRadius = Theme.CornerRadius
previewCorner.Parent = previewFrame

local previewWorldModel = Instance.new("Model")
previewWorldModel.Parent = previewFrame

local previewCamera = Instance.new("Camera")
previewCamera.Parent = previewWorldModel
previewFrame.CurrentCamera = previewCamera
previewCamera.CFrame = CFrame.new(Vector3.new(0, 100, 150), Vector3.new(0, 0, 0))

local previewTerrainPart = Instance.new("Part")
previewTerrainPart.Anchored = true
previewTerrainPart.Size = Vector3.new(200, 1, 200)
previewTerrainPart.Position = Vector3.new(0, 0, 0)
previewTerrainPart.Color = Color3.fromRGB(80, 80, 80)
previewTerrainPart.Material = Enum.Material.Plastic
previewTerrainPart.Parent = previewWorldModel

-- UI Helper Functions

-- [[!]] FUNGSI createSlider LAMA DIGANTI DENGAN VERSI BARU (DENGAN TEXTBOX)
-- Updated createSlider for the "Futuristic & Professional" theme
local function createSlider(parent, text, min, max, default)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 40)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 2)
	layout.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 15)
	label.Text = text .. ": " .. default
	label.Font = Theme.Font
	label.TextColor3 = Theme.TextMuted -- Muted for less emphasis
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local inputRow = Instance.new("Frame")
	inputRow.Size = UDim2.new(1, 0, 0, 20)
	inputRow.BackgroundTransparency = 1
	inputRow.Parent = container

	local rowLayout = Instance.new("UIListLayout")
	rowLayout.FillDirection = Enum.FillDirection.Horizontal
	rowLayout.Padding = UDim.new(0, 5)
	rowLayout.Parent = inputRow

	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(0.75, -5, 1, 0)
	sliderFrame.BackgroundColor3 = Theme.InputBackground
	sliderFrame.Parent = inputRow
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = Theme.CornerRadius
	sliderCorner.Parent = sliderFrame
	local sliderStroke = Instance.new("UIStroke") -- Add a stroke for a high-tech feel
	sliderStroke.Color = Theme.HeaderBackground
	sliderStroke.Thickness = 1
	sliderStroke.Parent = sliderFrame

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = Theme.Primary
	fill.BorderSizePixel = 0
	fill.Parent = sliderFrame
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = Theme.CornerRadius
	fillCorner.Parent = fill

	local knob = Instance.new("Frame") -- Changed to a Frame for a sleeker look
	knob.Size = UDim2.new(0, 4, 1, 4) -- Thinner, taller bar
	knob.BackgroundColor3 = Theme.TextLight
	knob.BorderSizePixel = 0
	knob.ZIndex = 2
	knob.Parent = sliderFrame
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(0, 2)
	knobCorner.Parent = knob

	local valueBox = Instance.new("TextBox")
	valueBox.Size = UDim2.new(0.25, 0, 1, 0)
	valueBox.BackgroundColor3 = Theme.InputBackground
	valueBox.TextColor3 = Theme.Text
	valueBox.Font = Theme.FontBold -- Bolder font for the value
	valueBox.Parent = inputRow
	local valueBoxCorner = Instance.new("UICorner")
	valueBoxCorner.CornerRadius = Theme.CornerRadius
	valueBoxCorner.Parent = valueBox
	local valueBoxStroke = Instance.new("UIStroke")
	valueBoxStroke.Color = Theme.HeaderBackground
	valueBoxStroke.Thickness = 1
	valueBoxStroke.Parent = valueBox

	local value = default
	local setValue
	local dragging = false

	local function updateVisuals(percentage)
		fill.Size = UDim2.new(percentage, 0, 1, 0)
		knob.Position = UDim2.new(percentage, -2, -0.1, 0) -- Centered on the bar
	end

	local inputService = game:GetService("UserInputService")
	sliderFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			sliderStroke.Color = Theme.Primary -- Neon glow effect on click
			sliderStroke.Thickness = 1.5
		end
	end)

	inputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			sliderStroke.Color = Theme.HeaderBackground -- Revert to normal
			sliderStroke.Thickness = 1
		end
	end)

	sliderFrame.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local relativeX = input.Position.X - sliderFrame.AbsolutePosition.X
			local percentage = math.clamp(relativeX / sliderFrame.AbsoluteSize.X, 0, 1)
			local newValue = min + (max - min) * percentage
			setValue(math.floor(newValue + 0.5), true)
		end
	end)

	valueBox.FocusLost:Connect(function(enterPressed)
		local num = tonumber(valueBox.Text)
		if num then
			setValue(math.clamp(num, min, max), true)
		else
			setValue(value, false)
		end
		valueBoxStroke.Color = Theme.HeaderBackground
	end)

	valueBox.Focused:Connect(function()
		valueBoxStroke.Color = Theme.Primary
	end)

	setValue = function(newValue, updateSliderVisuals)
		value = math.clamp(newValue, min, max)
		local percentage = (value - min) / (max - min)

		label.Text = text .. ": "
		valueBox.Text = string.format("%.0f", value)

		if updateSliderVisuals then
			updateVisuals(percentage)
		end
	end

	setValue(default, true)

	return function() return value end, setValue
end
-- [[!]] AKHIR DARI FUNGSI createSlider BARU

-- Updated createSegmentedControl for the "Futuristic & Professional" theme
local function createSegmentedControl(parent, options)
	local selectedValue = options[1]
	local onSelectionChangedCallbacks = {}

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 25) -- Increased height for better feel
	container.BackgroundColor3 = Theme.InputBackground
	container.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.CornerRadius
	corner.Parent = container
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.HeaderBackground
	stroke.Parent = container

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Parent = container

	local selector = Instance.new("Frame")
	selector.Size = UDim2.new(1 / #options, 0, 1, 0)
	selector.BackgroundColor3 = Theme.Primary
	selector.BorderColor3 = Theme.Primary
	selector.BorderSizePixel = 0
	selector.ZIndex = 2
	selector.Parent = container
	local selectorCorner = Instance.new("UICorner")
	selectorCorner.CornerRadius = Theme.CornerRadius
	selectorCorner.Parent = selector

	local textContainer = Instance.new("Frame")
	textContainer.Size = UDim2.new(1, 0, 1, 0)
	textContainer.BackgroundTransparency = 1
	textContainer.ZIndex = 3
	textContainer.Parent = container
	local textLayout = Instance.new("UIListLayout")
	textLayout.FillDirection = Enum.FillDirection.Horizontal
	textLayout.Parent = textContainer

	local optionButtons = {}

	for i, optionText in ipairs(options) do
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1 / #options, 0, 1, 0)
		button.Text = optionText
		button.BackgroundTransparency = 1
		button.TextColor3 = Theme.Text
		button.Font = Theme.FontBold
		button.TextSize = 12
		button.ZIndex = 4
		button.Parent = textContainer

		button.MouseButton1Click:Connect(function()
			selectedValue = optionText
			local targetPosition = UDim2.new((i - 1) / #options, 0, 0, 0)
			selector:TweenPosition(targetPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			for _, callback in ipairs(onSelectionChangedCallbacks) do
				callback(selectedValue)
			end
		end)

		optionButtons[optionText] = button
	end

	local function setValue(newValue)
		if optionButtons[newValue] then
			selectedValue = newValue
			local index = table.find(options, newValue)
			if index then
				local targetPosition = UDim2.new((index - 1) / #options, 0, 0, 0)
				selector.Position = targetPosition
			end
		end
	end

	local function onSelectionChanged(callback)
		table.insert(onSelectionChangedCallbacks, callback)
	end

	setValue(selectedValue) -- Set initial position

	return function() return selectedValue end, setValue, onSelectionChanged
end

-- Updated createCheckbox to a modern "Toggle Switch" for the new theme
local function createCheckbox(parent, text, default)
	local isChecked = default or false

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 25)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -50, 1, 0) -- Leave space for the switch
	label.Text = text
	label.Font = Theme.Font
	label.TextColor3 = Theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	-- The toggle switch track
	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, 40, 0, 20)
	switch.Text = ""
	switch.BackgroundColor3 = isChecked and Theme.Primary or Theme.InputBackground
	switch.Parent = container
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(0, 10) -- Make it pill-shaped
	switchCorner.Parent = switch
	local switchStroke = Instance.new("UIStroke")
	switchStroke.Color = Theme.HeaderBackground
	switchStroke.Parent = switch

	-- The knob that moves
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = isChecked and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
	knob.BackgroundColor3 = Theme.TextLight
	knob.Parent = switch
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0) -- Make it a circle
	knobCorner.Parent = knob

	local function updateState()
		local targetColor = isChecked and Theme.Primary or Theme.InputBackground
		local targetPosition = isChecked and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		game:GetService("TweenService"):Create(switch, tweenInfo, { BackgroundColor3 = targetColor }):Play()
		game:GetService("TweenService"):Create(knob, tweenInfo, { Position = targetPosition }):Play()
	end

	switch.MouseButton1Click:Connect(function()
		isChecked = not isChecked
		updateState()
	end)

	local function setValue(newValue)
		isChecked = newValue
		updateState()
	end

	return function() return isChecked end, setValue
end

local function createDropdown(parent, initialOptions)
	local options = initialOptions or {}
	local selectedValue = options[1] or "Select..."

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 20)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local mainButton = Instance.new("TextButton")
	mainButton.Size = UDim2.new(1, 0, 1, 0)
	mainButton.Text = selectedValue
	mainButton.BackgroundColor3 = Theme.DefaultButton
	mainButton.TextColor3 = Theme.Text
	mainButton.Parent = container
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = Theme.CornerRadius
	buttonCorner.Parent = mainButton

	local optionsList = Instance.new("ScrollingFrame")
	optionsList.Size = UDim2.new(1, 0, 0, 80)
	optionsList.Position = UDim2.new(0, 0, 1, 0)
	optionsList.BackgroundColor3 = Theme.DefaultButton
	optionsList.BorderSizePixel = 1
	optionsList.BorderColor3 = Theme.InputBackground
	optionsList.Visible = false
	optionsList.Parent = mainButton
	optionsList.ZIndex = 2
	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = Theme.CornerRadius
	listCorner.Parent = optionsList

	local listLayout = Instance.new("UIListLayout")
	listLayout.Parent = optionsList

	local function updateOptions(newOptions)
		options = newOptions
		for _, child in ipairs(optionsList:GetChildren()) do
			if not child:IsA("UIListLayout") then
				child:Destroy()
			end
		end

		for _, optionText in ipairs(options) do
			local optionButton = Instance.new("TextButton")
			optionButton.Size = UDim2.new(1, 0, 0, 20)
			optionButton.Text = optionText
			optionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			optionButton.TextColor3 = Theme.Text
			optionButton.Parent = optionsList

			optionButton.MouseButton1Click:Connect(function()
				selectedValue = optionText
				mainButton.Text = selectedValue
				optionsList.Visible = false
			end)
		end

		if #options > 0 then
			selectedValue = options[1]
			mainButton.Text = selectedValue
		else
			selectedValue = nil
			mainButton.Text = "No Terrain Found"
		end
	end

	mainButton.MouseButton1Click:Connect(function()
		optionsList.Visible = not optionsList.Visible
	end)

	updateOptions(options)

	local function setValue(newValue)
		selectedValue = newValue
		mainButton.Text = selectedValue or "Select..."
	end

	return function() return selectedValue end, setValue, updateOptions
end

local function createProgressBar(parent)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 20)
	container.BackgroundColor3 = Theme.InputBackground
	container.BorderSizePixel = 0
	container.Visible = false
	container.Parent = parent
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = Theme.CornerRadius
	containerCorner.Parent = container

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Theme.Primary
	fill.BorderSizePixel = 0
	fill.Parent = container
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = Theme.CornerRadius
	fillCorner.Parent = fill

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Text = "Generating..."
	label.Font = Theme.Font
	label.TextColor3 = Theme.TextLight
	label.BackgroundTransparency = 1
	label.ZIndex = 2
	label.Parent = container

	local function updateProgress(percentage, text)
		container.Visible = true
		fill.Size = UDim2.new(percentage, 0, 1, 0)
		label.Text = text or string.format("Generating... %.0f%%", percentage * 100)
	end

	local function hide()
		container.Visible = false
	end

	return updateProgress, hide
end

-- [[!]] FUNGSI BARU createTerrainSelector
local function createTerrainSelector(parent)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 80) -- Memberi ruang untuk daftar gulir
	container.BackgroundTransparency = 1
	container.Parent = parent

	local selectedTerrainName = nil
	local selectedButton = nil

	local function update(terrainObjects)
		-- Hapus UI sebelumnya
		for _, child in ipairs(container:GetChildren()) do
			child:Destroy()
		end
		selectedButton = nil

		if #terrainObjects == 0 then
			selectedTerrainName = nil
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 20)
			label.Text = "Harap tambahkan Terrain ke Workspace."
			label.Font = Enum.Font.SourceSans
			label.TextColor3 = Color3.fromRGB(255, 180, 180) -- Warna peringatan
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

		elseif #terrainObjects == 1 then
			selectedTerrainName = terrainObjects[1]
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 20)
			label.Text = "Target: " .. selectedTerrainName
			label.Font = Enum.Font.SourceSansBold
			label.TextColor3 = Color3.fromRGB(220, 220, 220)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

		else
			-- Lebih dari satu, buat daftar
			selectedTerrainName = terrainObjects[1] -- Pilih yang pertama sebagai default

			local listFrame = Instance.new("ScrollingFrame")
			listFrame.Size = UDim2.new(1, 0, 1, 0)
			listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			listFrame.Parent = container

			local listLayout = Instance.new("UIListLayout")
			listLayout.Padding = UDim.new(0, 2)
			listLayout.Parent = listFrame

			for _, terrainName in ipairs(terrainObjects) do
				local button = Instance.new("TextButton")
				button.Size = UDim2.new(1, -10, 0, 25)
				button.Text = terrainName
				button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
				button.TextColor3 = Color3.fromRGB(255, 255, 255)
				button.Parent = listFrame

				if terrainName == selectedTerrainName then
					button.BackgroundColor3 = Color3.fromRGB(0, 122, 204)
					selectedButton = button
				end

				button.MouseButton1Click:Connect(function()
					selectedTerrainName = terrainName
					if selectedButton then
						selectedButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					end
					button.BackgroundColor3 = Color3.fromRGB(0, 122, 204)
					selectedButton = button
				end)
			end
		end
	end

	local getter = function()
		return selectedTerrainName
	end

	return getter, update
end
-- [[!]] AKHIR DARI FUNGSI createTerrainSelector

-- [[!]] FUNGSI BARU createBiomeCardSelector
local function createBiomeCardSelector(parent, biomePresetDefs, onSelectionChanged)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 60) -- Ketinggian untuk kartu
	container.BackgroundTransparency = 1
	container.Parent = parent

	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0, 70, 0, 50) -- Ukuran kartu
	gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
	gridLayout.FillDirection = Enum.FillDirection.Horizontal
	gridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	gridLayout.Parent = container

	local selectedPresetName = nil
	local selectedButton = nil

	-- Definisi visual untuk kartu (bisa diperluas dengan Ikon)
	local cardVisuals = {
		["Default"] = {Color = Color3.fromRGB(80, 150, 80)}, -- Hijau
		["Gurun (Desert)"] = {Color = Color3.fromRGB(200, 180, 100)}, -- Kuning Pasir
		["Tundra"] = {Color = Color3.fromRGB(200, 200, 210)}, -- Putih kebiruan
	}

	local presetNames = {}
	for name, _ in pairs(biomePresetDefs) do
		table.insert(presetNames, name)
	end
	table.sort(presetNames) -- Pastikan urutan konsisten

	if #presetNames > 0 then
		selectedPresetName = presetNames[1] -- Pilih default
	end

	for _, presetName in ipairs(presetNames) do
		local card = Instance.new("TextButton")
		card.Size = UDim2.new(0, 70, 0, 50)
		card.Text = presetName
		card.Font = Enum.Font.SourceSansBold
		card.TextSize = 12
		card.TextColor3 = Color3.fromRGB(255, 255, 255)
		card.BackgroundColor3 = cardVisuals[presetName] and cardVisuals[presetName].Color or Color3.fromRGB(80, 80, 80)
		card.AutoButtonColor = false
		card.Parent = gridLayout

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(30, 30, 30)
		stroke.Thickness = 1
		stroke.Parent = card

		if presetName == selectedPresetName then
			stroke.Color = Color3.fromRGB(0, 150, 255)
			stroke.Thickness = 2
			selectedButton = card
		end

		card.MouseButton1Click:Connect(function()
			if selectedButton then
				local oldStroke = selectedButton:FindFirstChild("UIStroke")
				if oldStroke then
					oldStroke.Color = Color3.fromRGB(30, 30, 30)
					oldStroke.Thickness = 1
				end
			end

			selectedPresetName = presetName
			selectedButton = card

			stroke.Color = Color3.fromRGB(0, 150, 255)
			stroke.Thickness = 2

			onSelectionChanged(selectedPresetName) -- Panggil callback!
		end)
	end

	local getter = function()
		return selectedPresetName
	end

	local setter = function(newValue)
		-- (Logika untuk mengatur secara eksternal jika diperlukan)
	end

	return getter, setter
end
-- [[!]] AKHIR DARI FUNGSI createBiomeCardSelector
local PresetManager = require(script:WaitForChild("PresetManager"))
-- [[!]] FUNGSI BARU createPresetManagerUI
local function createPresetManagerUI(parent, gatherSettingsFunc, applySettingsFunc)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 150) -- Ketinggian untuk manajer
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.Parent = container

	local label = Instance.new("TextLabel")
	label.Text = "Settings Presets:"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Font = Enum.Font.SourceSansBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	-- Daftar untuk preset yang ada
	local listFrame = Instance.new("ScrollingFrame")
	listFrame.Size = UDim2.new(1, 0, 1, -60) -- Ketinggian dikurangi bagian "Save"
	listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	listFrame.Parent = container

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = listFrame

	-- Bagian "Save New"
	local saveFrame = Instance.new("Frame")
	saveFrame.Size = UDim2.new(1, 0, 0, 30)
	saveFrame.BackgroundTransparency = 1
	saveFrame.Parent = container

	local saveLayout = Instance.new("UIListLayout")
	saveLayout.FillDirection = Enum.FillDirection.Horizontal
	saveLayout.Padding = UDim.new(0, 5)
	saveLayout.Parent = saveFrame

	local presetNameInput = Instance.new("TextBox")
	presetNameInput.Size = UDim2.new(0.6, -5, 1, 0)
	presetNameInput.PlaceholderText = "Nama Preset Baru..."
	presetNameInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	presetNameInput.TextColor3 = Color3.fromRGB(220, 220, 220)
	presetNameInput.Parent = saveFrame

	local savePresetButton = Instance.new("TextButton")
	savePresetButton.Size = UDim2.new(0.4, 0, 1, 0)
	savePresetButton.Text = "Simpan"
	savePresetButton.BackgroundColor3 = Color3.fromRGB(0, 122, 204)
	savePresetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	savePresetButton.Parent = saveFrame

	-- Fungsi untuk mengisi ulang daftar
	local function refreshPresetList()
		for _, child in ipairs(listFrame:GetChildren()) do
			if child:IsA("GuiObject") and not child:IsA("UIListLayout") then
				child:Destroy()
			end
		end

		local names = PresetManager.getPresetNames()
		if #names == 0 then
			local noPresetLabel = Instance.new("TextLabel")
			noPresetLabel.Size = UDim2.new(1, -10, 0, 25)
			noPresetLabel.Text = "Belum ada preset yang disimpan."
			noPresetLabel.Font = Enum.Font.SourceSansItalic
			noPresetLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
			noPresetLabel.Parent = listFrame
		end

		for _, name in ipairs(names) do
			local itemFrame = Instance.new("Frame")
			itemFrame.Size = UDim2.new(1, 0, 0, 25)
			itemFrame.BackgroundTransparency = 1
			itemFrame.Parent = listFrame

			local itemLayout = Instance.new("UIListLayout")
			itemLayout.FillDirection = Enum.FillDirection.Horizontal
			itemLayout.Padding = UDim.new(0, 5)
			itemLayout.Parent = itemFrame

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
			nameLabel.Text = name
			nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.Font = Enum.Font.SourceSans
			nameLabel.Parent = itemFrame

			local loadButton = Instance.new("TextButton")
			loadButton.Size = UDim2.new(0.25, -5, 1, 0)
			loadButton.Text = "Muat"
			loadButton.TextSize = 12
			loadButton.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
			loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			loadButton.Parent = itemFrame

			local deleteButton = Instance.new("TextButton")
			deleteButton.Size = UDim2.new(0.25, 0, 1, 0)
			deleteButton.Text = "Hapus"
			deleteButton.TextSize = 12
			deleteButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
			deleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			deleteButton.Parent = itemFrame

			-- Koneksi event
			loadButton.MouseButton1Click:Connect(function()
				local settings = PresetManager.loadPreset(name)
				applySettingsFunc(settings)
			end)

			deleteButton.MouseButton1Click:Connect(function()
				PresetManager.deletePreset(name)
				refreshPresetList() -- Segarkan daftar
			end)
		end
	end

	-- Koneksi tombol simpan
	savePresetButton.MouseButton1Click:Connect(function()
		local name = presetNameInput.Text
		if name and name ~= "" then
			local settings = gatherSettingsFunc()
			PresetManager.savePreset(name, settings)
			refreshPresetList() -- Segarkan daftar
			presetNameInput.Text = "" -- Kosongkan input
		else
			warn("Harap masukkan nama untuk preset.")
		end
	end)

	refreshPresetList() -- Panggilan awal
end
-- [[!]] AKHIR DARI FUNGSI createPresetManagerUI

local function createMaterialCheckboxes(parent, materials)
	local selectedMaterials = {}
	local getters = {}

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 40)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 15)
	label.Text = "Place Assets On:"
	label.Font = Enum.Font.SourceSans
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local checkboxesContainer = Instance.new("Frame")
	checkboxesContainer.Size = UDim2.new(1, 0, 0, 20)
	checkboxesContainer.BackgroundTransparency = 1
	checkboxesContainer.Parent = container

	local checkboxLayout = Instance.new("UIListLayout")
	checkboxLayout.FillDirection = Enum.FillDirection.Horizontal
	checkboxLayout.Parent = checkboxesContainer

	for _, materialName in ipairs(materials) do
		local getIsChecked, setIsChecked = createCheckbox(checkboxesContainer, materialName, materialName == "Grass")
		getters[materialName] = getIsChecked
		selectedMaterials[materialName] = setIsChecked
	end

	local function getValues()
		local enabledMaterials = {}
		for materialName, getIsChecked in pairs(getters) do
			if getIsChecked() then
				table.insert(enabledMaterials, Enum.Material[materialName])
			end
		end
		return enabledMaterials
	end

	local function setValues(enabledMaterials)
		for materialName, setIsChecked in pairs(selectedMaterials) do
			local isEnabled = table.find(enabledMaterials, Enum.Material[materialName])
			setIsChecked(isEnabled and true or false)
		end
	end

	return getValues, setValues
end

-- [[!]] FUNGSI BARU createSectionHeader
-- Updated createSectionHeader for a cleaner, more subtle look
local function createSectionHeader(parent, text)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 20)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 2)
	layout.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 15)
	label.Text = text
	label.Font = Theme.FontBold
	label.TextColor3 = Theme.Primary -- Use accent color for emphasis
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.Parent = container

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 1)
	line.BackgroundColor3 = Theme.HeaderBackground -- Subtle separator line
	line.Parent = container

	return container
end
-- [[!]] AKHIR DARI FUNGSI createSectionHeader

-- Tab Creation Logic
local tabs = {}
local activeTab = nil

local function switchTab(tabToActivate)
	if activeTab == tabToActivate then return end

	-- Deactivate the old tab
	if activeTab then
		activeTab.button.BackgroundColor3 = Theme.DefaultButton
		activeTab.content.Visible = false
	end

	-- Activate the new tab
	tabToActivate.button.BackgroundColor3 = Theme.Primary
	tabToActivate.content.Visible = true
	activeTab = tabToActivate
end

local function createTab(name)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 50, 1, 0) -- Fixed width for now
	button.Text = name
	button.Font = Theme.FontBold
	button.TextColor3 = Theme.TextLight
	button.BackgroundColor3 = Theme.DefaultButton
	button.Parent = tabFrame
	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.CornerRadius
	corner.Parent = button

	local content = Instance.new("ScrollingFrame")
	content.Size = UDim2.new(1, 0, 1, 0)
	content.BackgroundTransparency = 1
	content.Visible = false
	content.Parent = contentContainer
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.Parent = content

	local tabData = {button = button, content = content}
	tabs[name] = tabData

	button.MouseButton1Click:Connect(function()
		switchTab(tabData)
	end)

	return content
end

-- Create the tabs
local globalSettingsContent = createTab("Global")
local landformsContent = createTab("Landforms")
local hydrologyContent = createTab("Hydrology")
local biomesContent = createTab("Biomes")
local sculptContent = createTab("Sculpt")

-- Set the initial active tab
switchTab(tabs["Global"])


-- Add UI elements for the Global Settings tab
local targetTerrainLabel = Instance.new("TextLabel")
targetTerrainLabel.Text = "Target Terrain:"
targetTerrainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
targetTerrainLabel.Size = UDim2.new(1, 0, 0, 20)
targetTerrainLabel.Parent = globalSettingsContent

local getTargetTerrain, updateTargetTerrainUI = createTerrainSelector(globalSettingsContent)

-- Function to find all terrain objects in workspace
local function findAndupdateTerrainObjects()
	local terrainObjects = {}
	for _, child in ipairs(workspace:GetChildren()) do
		if child:IsA("Terrain") then
			table.insert(terrainObjects, child.Name)
		end
	end
	updateTargetTerrainUI(terrainObjects)
end

-- Initial population
findAndupdateTerrainObjects()

-- Auto-update when workspace changes
workspace.ChildAdded:Connect(function(child)
	if child:IsA("Terrain") then
		findAndupdateTerrainObjects()
	end
end)

workspace.ChildRemoved:Connect(function(child)
	if child:IsA("Terrain") then
		findAndupdateTerrainObjects()
	end
end)


local sizeXLabel = Instance.new("TextLabel")
sizeXLabel.Text = "Size X:"
sizeXLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeXLabel.Size = UDim2.new(1, 0, 0, 20)
sizeXLabel.Parent = globalSettingsContent

sizeXInput = Instance.new("TextBox")
sizeXInput.Size = UDim2.new(1, 0, 0, 20)
sizeXInput.Text = "256"
sizeXInput.BackgroundColor3 = Theme.InputBackground
sizeXInput.TextColor3 = Theme.Text
sizeXInput.Parent = globalSettingsContent
local sizeXCorner = Instance.new("UICorner")
sizeXCorner.CornerRadius = Theme.CornerRadius
sizeXCorner.Parent = sizeXInput

local sizeZLabel = Instance.new("TextLabel")
sizeZLabel.Text = "Size Z:"
sizeZLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeZLabel.Size = UDim2.new(1, 0, 0, 20)
sizeZLabel.Parent = globalSettingsContent

sizeZInput = Instance.new("TextBox")
sizeZInput.Size = UDim2.new(1, 0, 0, 20)
sizeZInput.Text = "256"
sizeZInput.BackgroundColor3 = Theme.InputBackground
sizeZInput.TextColor3 = Theme.Text
sizeZInput.Parent = globalSettingsContent
local sizeZCorner = Instance.new("UICorner")
sizeZCorner.CornerRadius = Theme.CornerRadius
sizeZCorner.Parent = sizeZInput

local seedLabel = Instance.new("TextLabel")
seedLabel.Text = "Seed:"
seedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
seedLabel.Size = UDim2.new(1, 0, 0, 20)
seedLabel.Parent = globalSettingsContent

seedInput = Instance.new("TextBox")
seedInput.Size = UDim2.new(1, 0, 0, 20)
seedInput.Text = "0"
seedInput.BackgroundColor3 = Theme.InputBackground
seedInput.TextColor3 = Theme.Text
seedInput.Parent = globalSettingsContent
local seedCorner = Instance.new("UICorner")
seedCorner.CornerRadius = Theme.CornerRadius
seedCorner.Parent = seedInput

local noiseAlgorithmLabel = Instance.new("TextLabel")
noiseAlgorithmLabel.Text = "Noise Algorithm:"
noiseAlgorithmLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
noiseAlgorithmLabel.Size = UDim2.new(1, 0, 0, 20)
noiseAlgorithmLabel.Parent = globalSettingsContent

local getNoiseAlgorithm, setNoiseAlgorithm = createSegmentedControl(globalSettingsContent, {"Default (Roblox)", "Custom Perlin"})

local generateButton = Instance.new("TextButton")
generateButton.Size = UDim2.new(0.6, -5, 1, 0)
generateButton.Text = "GENERATE"
generateButton.BackgroundColor3 = Theme.Success
generateButton.TextColor3 = Theme.TextLight
generateButton.Font = Theme.FontBold
generateButton.Parent = actionBarFrame
local genBtnCorner = Instance.new("UICorner")
genBtnCorner.CornerRadius = Theme.CornerRadius
genBtnCorner.Parent = generateButton

local deleteButton = Instance.new("TextButton")
deleteButton.Size = UDim2.new(0.4, 0, 1, 0)
deleteButton.Text = "Delete"
deleteButton.BackgroundColor3 = Theme.Danger
deleteButton.TextColor3 = Theme.TextLight
deleteButton.Font = Theme.FontBold
deleteButton.Parent = actionBarFrame
local delBtnCorner = Instance.new("UICorner")
delBtnCorner.CornerRadius = Theme.CornerRadius
delBtnCorner.Parent = deleteButton

deleteButton.MouseButton1Click:Connect(function()
	local targetTerrainName = getTargetTerrain()
	if not targetTerrainName then
		warn("No target terrain selected for deletion.")
		return
	end

	local targetTerrain = workspace:FindFirstChild(targetTerrainName)
	if not targetTerrain or not targetTerrain:IsA("Terrain") then
		warn("Selected target terrain '" .. targetTerrainName .. "' not found or is not a Terrain object.")
		return
	end

	local sizeX = tonumber(sizeXInput.Text) or 256
	local sizeZ = tonumber(sizeZInput.Text) or 256

	local corner1 = Vector3.new(-sizeX * 2, -1000, -sizeZ * 2)
	local corner2 = Vector3.new(sizeX * 2, 1000, sizeZ * 2)
	local regionToClear = Region3.new(
		Vector3.new(math.min(corner1.X, corner2.X), math.min(corner1.Y, corner2.Y), math.min(corner1.Z, corner2.Z)),
		Vector3.new(math.max(corner1.X, corner2.X), math.max(corner1.Y, corner2.Y), math.max(corner1.Z, corner2.Z))
	)

	print("Clearing terrain in region: " .. tostring(regionToClear.CFrame) .. " with size " .. tostring(regionToClear.Size))
	targetTerrain:Clear()
	print("Terrain cleared.")
end)

local updateProgressBar, hideProgressBar = createProgressBar(globalSettingsContent)

-- Helper function to combine two Region3s
local function combineRegions(region1, region2)
	if not region1 then return region2 end
	if not region2 then return region1 end

	local r1_min = region1.CFrame.p - (region1.Size / 2)
	local r1_max = region1.CFrame.p + (region1.Size / 2)
	local r2_min = region2.CFrame.p - (region2.Size / 2)
	local r2_max = region2.CFrame.p + (region2.Size / 2)

	local combined_min = Vector3.new(
		math.min(r1_min.X, r2_min.X),
		math.min(r1_min.Y, r2_min.Y),
		math.min(r1_min.Z, r2_min.Z)
	)

	local combined_max = Vector3.new(
		math.max(r1_max.X, r2_max.X),
		math.max(r1_max.Y, r2_max.Y),
		math.max(r1_max.Z, r2_max.Z)
	)

	return Region3.new(combined_min, combined_max)
end

-- Biome Preset Definitions
local biomePresets = {
	["Default"] = {
		baseMaterial = Enum.Material.Grass,
		rules = {
			{ name = "Snow", material = Enum.Material.Snow, minAltitude = 80 },
			{ name = "Rock", material = Enum.Material.Rock, minSteepness = 45 },
			{ name = "Sand", material = Enum.Material.Sand, nearWater = { maxDistance = 8 } }
		}
	},
	["Gurun (Desert)"] = {
		baseMaterial = Enum.Material.Sand,
		rules = {
			{ name = "Rock", material = Enum.Material.Rock, minSteepness = 30 },
			{ name = "Ground", material = Enum.Material.Ground, minAltitude = 100 }
		}
	},
	["Tundra"] = {
		baseMaterial = Enum.Material.Snow,
		rules = {
			{ name = "Grass", material = Enum.Material.Grass, maxTemperature = 25 },
			{ name = "Rock", material = Enum.Material.Rock, minSteepness = 40 }
		}
	}
}

-- Add UI elements for the Landforms tab
createSectionHeader(landformsContent, "Base Shape")
local baseTypeLabel = Instance.new("TextLabel")
baseTypeLabel.Text = "Base Type:"
baseTypeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
baseTypeLabel.Size = UDim2.new(1, 0, 0, 20)
baseTypeLabel.Parent = landformsContent
local getBaseType, setBaseType = createSegmentedControl(landformsContent, {"Hills", "Mountains", "Plains", "Islands", "Canyons", "Volcanoes"})
local getIntensity, setIntensity = createSlider(landformsContent, "Intensity", 10, 200, 50)
local getFrequency, setFrequency = createSlider(landformsContent, "Frequency", 1, 20, 5)

createSectionHeader(landformsContent, "Landform Modifiers")
local getEnableErosion, setEnableErosion = createCheckbox(landformsContent, "Enable Hydraulic Erosion", false)
local getErosionIterations, setErosionIterations = createSlider(landformsContent, "Erosion Iterations", 1000, 50000, 10000)
local getEnableCaves, setEnableCaves = createCheckbox(landformsContent, "Enable Caves", false)
local getCaveDensity, setCaveDensity = createSlider(landformsContent, "Cave Density", 1, 10, 5)
local getCaveScale, setCaveScale = createSlider(landformsContent, "Cave Scale", 1, 10, 5)
local getEnableTerracing, setEnableTerracing = createCheckbox(landformsContent, "Enable Terracing", false)
local getTerraceHeight, setTerraceHeight = createSlider(landformsContent, "Terrace Height", 2, 20, 8)

-- Add UI elements for the Hydrology tab
createSectionHeader(hydrologyContent, "Water Level")
local getSeaLevel, setSeaLevel = createSlider(hydrologyContent, "Sea Level", 0, 100, 0)
createSectionHeader(hydrologyContent, "Water Features")
local getEnableLakes, setEnableLakes = createCheckbox(hydrologyContent, "Enable Lake Generation", true)
local getEnableWaterfalls, setEnableWaterfalls = createCheckbox(hydrologyContent, "Enable Waterfalls", true)
createSectionHeader(hydrologyContent, "River Generation")
local getShouldCreateRivers, setShouldCreateRivers = createCheckbox(hydrologyContent, "Create Rivers", false)
local getRiverCount, setRiverCount = createSlider(hydrologyContent, "River Count", 1, 10, 3)
local getRiverDepth, setRiverDepth = createSlider(hydrologyContent, "River Depth", 1, 20, 5)

-- Add UI elements for the Biomes & Vegetation tab
createSectionHeader(biomesContent, "Material Painting")
local getAutoPaint, setAutoPaint = createCheckbox(biomesContent, "Auto Paint Materials", true)
local getShouldBlendBiomes, setShouldBlendBiomes = createCheckbox(biomesContent, "Smooth Biome Borders", true)
local getBiomeBlendIntensity, setBiomeBlendIntensity = createSlider(biomesContent, "Blend Intensity", 0, 1, 0.5)

local biomePresetControlsContainer = Instance.new("Frame")
biomePresetControlsContainer.Size = UDim2.new(1, 0, 0, 200) -- Start with a decent height
biomePresetControlsContainer.BackgroundTransparency = 1
biomePresetControlsContainer.Parent = biomesContent
local biomeControlsLayout = Instance.new("UIListLayout")
biomeControlsLayout.Padding = UDim.new(0, 5)
biomeControlsLayout.Parent = biomePresetControlsContainer

local biomePresetLabel = Instance.new("TextLabel")
biomePresetLabel.Text = "Biome Preset:"
biomePresetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
biomePresetLabel.Size = UDim2.new(1, 0, 0, 20)
biomePresetLabel.Parent = biomePresetControlsContainer

local updateBiomeControls
local getSelectedBiomePreset, setSelectedBiomePreset = createBiomeCardSelector(biomePresetControlsContainer, biomePresets, function(presetName)
	updateBiomeControls()
end)

local activeBiomeControlGetters = {}
local dynamicControlsContainer = Instance.new("Frame")
dynamicControlsContainer.BackgroundTransparency = 1
dynamicControlsContainer.Size = UDim2.new(1, 0, 1, 0) -- Adjust size as needed
dynamicControlsContainer.LayoutOrder = 3 -- Ensure it appears after the dropdown
dynamicControlsContainer.Parent = biomePresetControlsContainer
local dynamicControlsLayout = Instance.new("UIListLayout")
dynamicControlsLayout.Padding = UDim.new(0, 5)
dynamicControlsLayout.Parent = dynamicControlsContainer

updateBiomeControls = function()
	for _, child in ipairs(dynamicControlsContainer:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	activeBiomeControlGetters = {}

	local selectedPresetName = getSelectedBiomePreset()
	local selectedPreset = biomePresets[selectedPresetName]
	if not selectedPreset then return end

	for i, rule in ipairs(selectedPreset.rules) do
		local ruleLabel = Instance.new("TextLabel")
		ruleLabel.Text = "  Rule: " .. rule.name
		ruleLabel.Font = Enum.Font.SourceSansBold
		ruleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		ruleLabel.TextXAlignment = Enum.TextXAlignment.Left
		ruleLabel.Size = UDim2.new(1, 0, 0, 20)
		ruleLabel.Parent = dynamicControlsContainer

		if rule.minAltitude then
			local getter, setter = createSlider(dynamicControlsContainer, "Min Altitude", 0, 250, rule.minAltitude)
			activeBiomeControlGetters[i .. "_minAltitude"] = {get=getter, set=setter}
		end
		if rule.maxAltitude then
			local getter, setter = createSlider(dynamicControlsContainer, "Max Altitude", 0, 250, rule.maxAltitude)
			activeBiomeControlGetters[i .. "_maxAltitude"] = {get=getter, set=setter}
		end
		if rule.minSteepness then
			local getter, setter = createSlider(dynamicControlsContainer, "Min Steepness", 0, 90, rule.minSteepness)
			activeBiomeControlGetters[i .. "_minSteepness"] = {get=getter, set=setter}
		end
		if rule.maxSteepness then
			local getter, setter = createSlider(dynamicControlsContainer, "Max Steepness", 0, 90, rule.maxSteepness)
			activeBiomeControlGetters[i .. "_maxSteepness"] = {get=getter, set=setter}
		end
		if rule.nearWater then
			local getter, setter = createSlider(dynamicControlsContainer, "Max Water Distance", 1, 50, rule.nearWater.maxDistance)
			activeBiomeControlGetters[i .. "_nearWater_maxDistance"] = {get=getter, set=setter}
		end
		if rule.minTemperature then
			local getter, setter = createSlider(dynamicControlsContainer, "Min Temperature", 0, 100, rule.minTemperature)
			activeBiomeControlGetters[i .. "_minTemperature"] = {get=getter, set=setter}
		end
		if rule.maxTemperature then
			local getter, setter = createSlider(dynamicControlsContainer, "Max Temperature", 0, 100, rule.maxTemperature)
			activeBiomeControlGetters[i .. "_maxTemperature"] = {get=getter, set=setter}
		end
		if rule.minHumidity then
			local getter, setter = createSlider(dynamicControlsContainer, "Min Humidity", 0, 100, rule.minHumidity)
			activeBiomeControlGetters[i .. "_minHumidity"] = {get=getter, set=setter}
		end
		if rule.maxHumidity then
			local getter, setter = createSlider(dynamicControlsContainer, "Max Humidity", 0, 100, rule.maxHumidity)
			activeBiomeControlGetters[i .. "_maxHumidity"] = {get=getter, set=setter}
		end
	end
end

updateBiomeControls()

createSectionHeader(biomesContent, "Asset Placement")
local getPlaceAssets, setPlaceAssets = createCheckbox(biomesContent, "Place Assets", false)
local getAssetPlacementMaterials, setAssetPlacementMaterials = createMaterialCheckboxes(biomesContent, {"Grass", "Ground", "Rock"})

local assetFolderLabel = Instance.new("TextLabel")
assetFolderLabel.Size = UDim2.new(1, 0, 0, 15)
assetFolderLabel.Text = "Asset Folder (in ReplicatedStorage):"
assetFolderLabel.Font = Enum.Font.SourceSans
assetFolderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
assetFolderLabel.TextXAlignment = Enum.TextXAlignment.Left
assetFolderLabel.Parent = biomesContent

assetFolderInput = Instance.new("TextBox")
assetFolderInput.Size = UDim2.new(1, 0, 0, 20)
assetFolderInput.Text = "GeoCraftAssets"
assetFolderInput.Parent = biomesContent

local getForestDensity, setForestDensity = createSlider(biomesContent, "Forest Density", 0, 1, 0.5)

-- Add UI elements for the Sculpt tab
local activateSculptButton = Instance.new("TextButton")
activateSculptButton.Size = UDim2.new(1, 0, 0, 30)
activateSculptButton.Text = "Activate Sculpting Tool"
activateSculptButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
activateSculptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateSculptButton.Parent = sculptContent

createSectionHeader(sculptContent, "Brush Settings")
local getSculptMode, setSculptMode = createSegmentedControl(sculptContent, {"Raise", "Lower", "Erode", "Plant"})
local getBrushSize, setBrushSize = createSlider(sculptContent, "Brush Size", 5, 100, 20)
local getBrushStrength, setBrushStrength = createSlider(sculptContent, "Brush Strength / Density", 1, 20, 5)

createSectionHeader(sculptContent, "Erosion Brush")
local getErosionDroplets, setErosionDroplets = createSlider(sculptContent, "Erosion Droplets", 1000, 50000, 5000)

-- Require the modules
local TerrainGenerator = require(script:WaitForChild("TerrainGenerator"))
local VoxelWriter = require(script:WaitForChild("VoxelWriter"))
local RiverGenerator = require(script:WaitForChild("RiverGenerator"))
local BiomePainter = require(script:WaitForChild("BiomePainter"))
local AssetPlacer = require(script:WaitForChild("AssetPlacer"))
local ErosionSimulator = require(script:WaitForChild("ErosionSimulator"))
local CaveGenerator = require(script:WaitForChild("CaveGenerator"))
local ChunkManager = require(script:WaitForChild("ChunkManager"))
local LakeGenerator = require(script:WaitForChild("LakeGenerator"))
local WaterfallGenerator = require(script:WaitForChild("WaterfallGenerator"))
local SculptingTool = require(script:WaitForChild("SculptingTool"))
local HistoryManager = require(script:WaitForChild("HistoryManager"))

PresetManager.initialize(plugin)
local Noise = require(script:WaitForChild("Noise"))

local gatherAllSettings
local applyAllSettings

gatherAllSettings = function()
	local settings = {}
	settings.sizeX = sizeXInput.Text
	settings.sizeZ = sizeZInput.Text
	settings.seed = seedInput.Text
	settings.baseType = getBaseType()
	settings.intensity = getIntensity()
	settings.frequency = getFrequency()
	settings.enableErosion = getEnableErosion()
	settings.erosionIterations = getErosionIterations()
	settings.enableCaves = getEnableCaves()
	settings.caveDensity = getCaveDensity()
	settings.caveScale = getCaveScale()
	settings.enableTerracing = getEnableTerracing()
	settings.terraceHeight = getTerraceHeight()
	settings.seaLevel = getSeaLevel()
	settings.shouldCreateRivers = getShouldCreateRivers()
	settings.riverCount = getRiverCount()
	settings.riverDepth = getRiverDepth()
	settings.enableLakes = getEnableLakes()
	settings.enableWaterfalls = getEnableWaterfalls()
	settings.autoPaint = getAutoPaint()
	settings.shouldBlendBiomes = getShouldBlendBiomes()
	settings.biomeBlendIntensity = getBiomeBlendIntensity()
	settings.selectedBiomePreset = getSelectedBiomePreset()
	settings.placeAssets = getPlaceAssets()
	settings.assetFolderPath = assetFolderInput.Text
	settings.forestDensity = getForestDensity()
	return settings
end

applyAllSettings = function(settings)
	if not settings then return end
	sizeXInput.Text = settings.sizeX or "256"
	sizeZInput.Text = settings.sizeZ or "256"
	seedInput.Text = settings.seed or "0"
	setBaseType(settings.baseType)
	setIntensity(settings.intensity)
	setFrequency(settings.frequency)
	setEnableErosion(settings.enableErosion)
	setErosionIterations(settings.erosionIterations)
	setEnableCaves(settings.enableCaves)
	setCaveDensity(settings.caveDensity)
	setCaveScale(settings.caveScale)
	setEnableTerracing(settings.enableTerracing)
	setTerraceHeight(settings.terraceHeight)
	setSeaLevel(settings.seaLevel)
	setShouldCreateRivers(settings.shouldCreateRivers)
	setRiverCount(settings.riverCount)
	setRiverDepth(settings.riverDepth)
	setEnableLakes(settings.enableLakes)
	setEnableWaterfalls(settings.enableWaterfalls)
	setAutoPaint(settings.autoPaint)
	setShouldBlendBiomes(settings.shouldBlendBiomes)
	setBiomeBlendIntensity(settings.biomeBlendIntensity)
	setPlaceAssets(settings.placeAssets)
	assetFolderInput.Text = settings.assetFolderPath or "GeoCraftAssets"
	setForestDensity(settings.forestDensity)
	print("Settings preset applied.")
end

-- Connect the generate button to the heightmap generation logic
generateButton.MouseButton1Click:Connect(function()
	local totalWidth = tonumber(sizeXInput.Text) or 256
	local totalHeight = tonumber(sizeZInput.Text) or 256
	local seed = tonumber(seedInput.Text) or 0
	Noise.setAlgorithm(getNoiseAlgorithm())
	local frequency = getFrequency()
	local amplitude = getIntensity()
	local baseType = getBaseType()
	local octaves = 4
	local persistence = 0.5
	local enableErosion = getEnableErosion()
	local erosionIterations = math.floor(getErosionIterations())
	local enableCaves = getEnableCaves()
	local caveDensity = getCaveDensity()
	local caveScale = getCaveScale()
	local enableTerracing = getEnableTerracing()
	local terraceHeight = getTerraceHeight()
	local seaLevel = getSeaLevel()
	local shouldCreateRivers = getShouldCreateRivers()
	local riverCount = math.floor(getRiverCount())
	local riverDepth = getRiverDepth()
	local enableLakes = getEnableLakes()
	local enableWaterfalls = getEnableWaterfalls()
	local shouldAutoPaint = getAutoPaint()
	local shouldBlendBiomes = getShouldBlendBiomes()
	local biomeBlendIntensity = getBiomeBlendIntensity()

	local activePresetName = getSelectedBiomePreset()
	local finalBiomePreset = biomePresets[activePresetName]
	if finalBiomePreset then
		for i, rule in ipairs(finalBiomePreset.rules) do
			if rule.minAltitude and activeBiomeControlGetters[i .. "_minAltitude"] then
				rule.minAltitude = activeBiomeControlGetters[i .. "_minAltitude"].get()
			end
			if rule.maxAltitude and activeBiomeControlGetters[i .. "_maxAltitude"] then
				rule.maxAltitude = activeBiomeControlGetters[i .. "_maxAltitude"].get()
			end
			if rule.minSteepness and activeBiomeControlGetters[i .. "_minSteepness"] then
				rule.minSteepness = activeBiomeControlGetters[i .. "_minSteepness"].get()
			end
			if rule.maxSteepness and activeBiomeControlGetters[i .. "_maxSteepness"] then
				rule.maxSteepness = activeBiomeControlGetters[i .. "_maxSteepness"].get()
			end
			if rule.nearWater and activeBiomeControlGetters[i .. "_nearWater_maxDistance"] then
				rule.nearWater.maxDistance = activeBiomeControlGetters[i .. "_nearWater_maxDistance"].get()
			end
		end
	end

	local shouldPlaceAssets = getPlaceAssets()
	local assetFolderPath = assetFolderInput.Text
	local forestDensity = getForestDensity()

	local chunks = ChunkManager.createChunkList(totalWidth, totalHeight)
	local totalRegion = nil

	local temperatureMap = {}
	local humidityMap = {}
	local climateFrequency = 2
	for x = 1, totalWidth do
		temperatureMap[x] = {}
		humidityMap[x] = {}
		for z = 1, totalHeight do
			temperatureMap[x][z] = (Noise.get(x / 100 * climateFrequency, z / 100 * climateFrequency, seed + 10) + 0.5) * 100
			humidityMap[x][z] = (Noise.get(x / 100 * climateFrequency, z / 100 * climateFrequency, seed + 20) + 0.5) * 100
		end
	end

	updateProgressBar(0, "Starting generation...")
	for i, chunk in ipairs(chunks) do
		local progress = (i - 1) / #chunks
		updateProgressBar(progress, string.format("Processing chunk %d/%d...", i, #chunks))

		local heightmap = TerrainGenerator.generateHeightmap(chunk.width, chunk.depth, seed, frequency, amplitude, octaves, persistence, baseType, chunk.offsetX, chunk.offsetZ, totalWidth, totalHeight)

		if enableTerracing then
			heightmap = TerrainGenerator.applyTerracing(heightmap, terraceHeight)
		end
		if enableLakes then
			heightmap = LakeGenerator.findAndFillLakes(heightmap, seaLevel)
		end

		local maxHeight = 0
		for x = 1, chunk.width do
			for z = 1, chunk.depth do
				if heightmap[x][z] > maxHeight then
					maxHeight = heightmap[x][z]
				end
			end
		end
		local voxelHeight = math.ceil(maxHeight / 4) + 1

		local voxelData = {}
		for x = 1, chunk.width do
			voxelData[x] = {}
			for y = 1, voxelHeight do
				voxelData[x][y] = {}
				for z = 1, chunk.depth do
					local currentHeight = (y - 1) * 4
					if currentHeight < heightmap[x][z] then
						voxelData[x][y][z] = Enum.Material.Rock
					elseif currentHeight < seaLevel then
						voxelData[x][y][z] = Enum.Material.Water
					else
						voxelData[x][y][z] = Enum.Material.Air
					end
				end
			end
		end

		if enableWaterfalls then
			voxelData = WaterfallGenerator.createWaterfalls(voxelData, seaLevel)
		end

		local targetTerrainName = getTargetTerrain()
		if not targetTerrainName then
			warn("No target terrain selected.")
			return
		end

		local targetTerrain = workspace:FindFirstChild(targetTerrainName)
		if not targetTerrain or not targetTerrain:IsA("Terrain") then
			warn("Selected target terrain '" .. targetTerrainName .. "' not found or is not a Terrain object.")
			return
		end

		local position = Vector3.new(-totalWidth * 2 + chunk.offsetX * 4, 0, -totalHeight * 2 + chunk.offsetZ * 4)
		local writeRegion = Region3.new(position, position + Vector3.new(chunk.width * 4, #voxelData[1] * 4, chunk.depth * 4))
		HistoryManager.recordAction(targetTerrain, writeRegion:ExpandToGrid(4))
		local region, seaLevelY = VoxelWriter.writeVoxels(targetTerrain, voxelData, position, seaLevel)

		if region and seaLevelY then
			totalRegion = combineRegions(totalRegion, region)
			if shouldAutoPaint and finalBiomePreset then
				updateProgressBar(progress, string.format("Painting chunk %d/%d...", i, #chunks))
				BiomePainter.paintBiomes(targetTerrain, region, seaLevelY, finalBiomePreset, temperatureMap, humidityMap, chunk.offsetX, chunk.offsetZ, shouldBlendBiomes, biomeBlendIntensity)
			end
			if shouldPlaceAssets then
				updateProgressBar(progress, string.format("Placing assets in chunk %d/%d...", i, #chunks))
				local allowedMaterials = getAssetPlacementMaterials()
				AssetPlacer.placeAssets(targetTerrain, region, assetFolderPath, forestDensity, allowedMaterials)
			end
		end
	end
	print("Generation complete.")
	hideProgressBar()
end)

createPresetManagerUI(globalSettingsContent, gatherAllSettings, applyAllSettings)

local function updatePreview()
	local previewSize = 64
	local settings = gatherAllSettings()
	local heightmap = TerrainGenerator.generateHeightmap(
		previewSize, previewSize, 
		tonumber(settings.seed) or 0, 
		settings.frequency, settings.intensity, 4, 0.5, 
		settings.baseType, 0, 0, previewSize, previewSize
	)
	if settings.enableTerracing then
		heightmap = TerrainGenerator.applyTerracing(heightmap, settings.terraceHeight)
	end
	if settings.enableLakes then
		heightmap = LakeGenerator.findAndFillLakes(heightmap, settings.seaLevel)
	end
	if previewTerrainPart then
		previewTerrainPart:Destroy()
	end
	local editableMesh = AssetService:CreateEditableMesh()
	local scale = 200 / previewSize
	local vertexIds = {}
	for x = 1, previewSize do
		vertexIds[x] = {}
		for z = 1, previewSize do
			local height = heightmap[x][z]
			local position = Vector3.new((x - 1 - previewSize / 2) * scale, height, (z - 1 - previewSize / 2) * scale)
			local vertexId = editableMesh:AddVertex(position)
			vertexIds[x][z] = vertexId
		end
	end
	for x = 1, previewSize - 1 do
		for z = 1, previewSize - 1 do
			local id_tl = vertexIds[x][z]
			local id_tr = vertexIds[x+1][z]
			local id_bl = vertexIds[x][z+1]
			local id_br = vertexIds[x+1][z+1]
			editableMesh:AddTriangle(id_tl, id_bl, id_tr)
			editableMesh:AddTriangle(id_bl, id_br, id_tr)
		end
	end
	local newMeshPart = AssetService:CreateMeshPartAsync(Content.fromObject(editableMesh))
	newMeshPart.Anchored = true
	newMeshPart.Parent = previewWorldModel
	previewTerrainPart = newMeshPart
end

local debounceTime = 0.2
local lastChange = 0
local isDebouncePending = false
local function onSettingsChanged()
	lastChange = tick()
	if isDebouncePending then return end
	isDebouncePending = true
	while tick() - lastChange < debounceTime do
		wait(0.1)
	end
	updatePreview()
	isDebouncePending = false
end

local function connectToDebounce(getter)
	local lastValue = getter()
	game:GetService("RunService").Heartbeat:Connect(function()
		local currentValue = getter()
		if currentValue ~= lastValue then
			lastValue = currentValue
			onSettingsChanged()
		end
	end)
end

sizeXInput.FocusLost:Connect(onSettingsChanged)
sizeZInput.FocusLost:Connect(onSettingsChanged)
seedInput.FocusLost:Connect(onSettingsChanged)
connectToDebounce(getBaseType)
connectToDebounce(getIntensity)
connectToDebounce(getFrequency)
connectToDebounce(getEnableErosion)
connectToDebounce(getErosionIterations)
connectToDebounce(getEnableCaves)
connectToDebounce(getCaveDensity)
connectToDebounce(getCaveScale)
connectToDebounce(getEnableTerracing)
connectToDebounce(getTerraceHeight)
connectToDebounce(getSeaLevel)
connectToDebounce(getShouldCreateRivers)
connectToDebounce(getRiverCount)
connectToDebounce(getRiverDepth)
connectToDebounce(getEnableLakes)
connectToDebounce(getEnableWaterfalls)

onSettingsChanged()

local mainToolbar = plugin:CreateToolbar("GeoCraft Main")
local undoButton = mainToolbar:CreateButton(
	"UndoAction", "Undo the last terrain action", "rbxassetid://13516625299", "Undo"
)
local redoButton = mainToolbar:CreateButton(
	"RedoAction", "Redo the last undone terrain action", "rbxassetid://13516625219", "Redo"
)
undoButton.Click:Connect(function() HistoryManager.undo() end)
redoButton.Click:Connect(function() HistoryManager.redo() end)

local isSculptingActive = false
local mouse = plugin:GetMouse()
local mouseMoveConnection = nil
local button1DownConnection = nil
local sculptingAction = plugin:CreatePluginAction(
	"ActivateSculpting", "Terrain Sculpting", "Activate the terrain sculpting brush", "rbxassetid://10630653034", false
)

local function updateSculptingSettings()
	local targetTerrainName = getTargetTerrain()
	local targetTerrain = targetTerrainName and workspace:FindFirstChild(targetTerrainName)
	SculptingTool.updateSettings({
		targetTerrain = targetTerrain,
		mode = getSculptMode(),
		brushSize = getBrushSize(),
		brushStrength = getBrushStrength(),
		erosionDroplets = getErosionDroplets(),
		assetFolderPath = assetFolderInput.Text,
		allowedMaterials = getAssetPlacementMaterials()
	})
end

local function setSculptingState(shouldBeActive)
	isSculptingActive = shouldBeActive
	if isSculptingActive then
		local targetTerrainName = getTargetTerrain()
		local targetTerrain = targetTerrainName and workspace:FindFirstChild(targetTerrainName)
		if not targetTerrain or not targetTerrain:IsA("Terrain") then
			warn("Cannot activate sculpting: No valid target terrain selected.")
			isSculptingActive = false
		else
			updateSculptingSettings()
			SculptingTool.activate(plugin)
			mouseMoveConnection = mouse.Move:Connect(function() SculptingTool.updateBrush(mouse.UnitRay) end)
			button1DownConnection = mouse.Button1Down:Connect(function() SculptingTool.applyBrush(mouse.UnitRay) end)
		end
	end
	if not isSculptingActive then
		SculptingTool.deactivate()
		if mouseMoveConnection then mouseMoveConnection:Disconnect() end
		if button1DownConnection then button1DownConnection:Disconnect() end
		mouseMoveConnection = nil
		button1DownConnection = nil
	end
	activateSculptButton.Text = isSculptingActive and "Deactivate Sculpting Tool" or "Activate Sculpting Tool"
	activateSculptButton.BackgroundColor3 = isSculptingActive and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 150, 0)
end

activateSculptButton.MouseButton1Click:Connect(function()
	setSculptingState(not isSculptingActive)
end)
sculptingAction.Triggered:Connect(function()
	setSculptingState(not isSculptingActive)
end)

game:GetService("RunService").Heartbeat:Connect(function()
	if isSculptingActive then
		updateSculptingSettings()
	end
end)
