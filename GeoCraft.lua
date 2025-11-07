-- GeoCraft.lua
-- This script will be the main entry point for the plugin
-- It will create the UI and handle the main logic

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetService = game:GetService("AssetService")

-- [[ ENHANCED THEME & STYLING ]] --
-- Modern Glassmorphism Theme with Gradient Effects and Premium Aesthetics
local Theme = {
	-- Main Colors with Gradient Support
	Background = Color3.fromRGB(25, 25, 30),        -- Deep dark base
	BackgroundGradient = Color3.fromRGB(35, 35, 40), -- Gradient end

	local function createLoadingSpinner(parent, size)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0, size or Responsive.getSizes().spinnerSize, 0, size or Responsive.getSizes().spinnerSize)
		container.BackgroundTransparency = 1
		container.Parent = parent

		local spinner = Instance.new("Frame")
		spinner.Size = UDim2.new(1, 0, 1, 0)
		spinner.BackgroundTransparency = 1
		spinner.Parent = container

		-- Create spinner segments
		local segments = {}
		for i = 1, 8 do
			local segment = Instance.new("Frame")
			segment.Size = UDim2.new(0.15, 0, 0.15, 0)
			segment.Position = UDim2.new(0.5, 0, 0.1, 0)
			segment.AnchorPoint = Vector2.new(0.5, 0.5)
			segment.BackgroundColor3 = Theme.Primary
			segment.BackgroundTransparency = 1 - (i / 8)
			segment.BorderSizePixel = 0
			segment.Parent = spinner

			local rotation = i * 45
			local angle = math.rad(rotation)
			local radius = (size or Responsive.getSizes().spinnerSize) * 0.35
			segment.Position = UDim2.new(0.5 + math.sin(angle) * 0.35, 0, 0.5 - math.cos(angle) * 0.35, 0)
			segment.Rotation = rotation

			table.insert(segments, segment)
		end

		-- Animate rotation
		local function startSpinAnimation()
			local spinTween = TweenService:Create(spinner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {
				Rotation = 360
			})
			spinTween:Play()
			return spinTween
		end

		-- Animate segment opacity
		local function startSegmentAnimation()
			for i, segment in ipairs(segments) do
				local delay = (i - 1) * 0.1
				local function animateSegment()
					local fadeTween = TweenService:Create(segment, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
						BackgroundTransparency = 0.8
					})
					fadeTween:Play()
					fadeTween.Completed:Connect(function()
						local showTween = TweenService:Create(segment, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
							BackgroundTransparency = 0.2
						})
						showTween:Play()
					end)
				end

				-- Start animation with delay
				local connection
				connection = game:GetService("RunService").Heartbeat:Connect(function()
					connection:Disconnect()
					animateSegment()
				end)
			end
		end

		local spinTween = startSpinAnimation()
		startSegmentAnimation()

		local function show()
			container.Visible = true
		end

		local function hide()
			container.Visible = false
			if spinTween then
				spinTween:Cancel()
			end
		end

		return show, hide
	end color
	ContentBackground = Color3.fromRGB(40, 40, 45), -- Glassmorphism base
	ContentBackgroundAlpha = 0.85,                    -- Transparency for glass effect
	HeaderBackground = Color3.fromRGB(30, 30, 35),   -- Header with subtle gradient
	HeaderGradient = Color3.fromRGB(45, 45, 50),     -- Header gradient end
	InputBackground = Color3.fromRGB(20, 20, 25),    -- Deep input fields
	InputBackgroundHover = Color3.fromRGB(28, 28, 33),-- Input hover state
	DefaultButton = Color3.fromRGB(55, 55, 60),    -- Modern button base
	ButtonHover = Color3.fromRGB(70, 70, 75),       -- Button hover state
	ButtonPressed = Color3.fromRGB(45, 45, 50),     -- Button pressed state

	-- Text Colors with Better Hierarchy
	Text = Color3.fromRGB(240, 240, 245),           -- Primary text - bright
	TextLight = Color3.fromRGB(255, 255, 255),       -- Headers and important text
	TextMuted = Color3.fromRGB(140, 140, 150),       -- Secondary text
	TextDisabled = Color3.fromRGB(100, 100, 110),    -- Disabled text
	TextAccent = Color3.fromRGB(100, 180, 255),      -- Accent text

	-- Enhanced Accent Colors
	Primary = Color3.fromRGB(0, 150, 255),          -- Vibrant blue
	PrimaryGradient = Color3.fromRGB(100, 200, 255), -- Blue gradient
	Success = Color3.fromRGB(50, 205, 50),           -- Fresh green
	SuccessGradient = Color3.fromRGB(100, 255, 100), -- Green gradient
	Danger = Color3.fromRGB(255, 80, 80),            -- Vibrant red
	DangerGradient = Color3.fromRGB(255, 120, 120),  -- Red gradient
	Warning = Color3.fromRGB(255, 180, 60),          -- Warm orange
	WarningGradient = Color3.fromRGB(255, 200, 100), -- Orange gradient
	Selected = Color3.fromRGB(80, 170, 255),         -- Selection highlight

	-- Special Effects
	GlowColor = Color3.fromRGB(100, 180, 255),       -- Glow effect color
	BorderColor = Color3.fromRGB(60, 60, 70),        -- Subtle borders
	BorderHighlight = Color3.fromRGB(120, 120, 130),-- Highlighted borders
	ShadowColor = Color3.fromRGB(0, 0, 0),            -- Shadow base

	-- Typography Hierarchy
	Font = Enum.Font.SourceSans,
	FontBold = Enum.Font.SourceSansBold,
	FontLight = Enum.Font.SourceSansLight,
	HeaderFontSize = 24,
	TitleFontSize = 18,
	BodyFontSize = 14,
	SmallFontSize = 12,

	-- Modern UI Properties
	CornerRadius = UDim.new(0, Responsive.getSizes().cornerRadius),                    -- Larger radius for modern feel
	LargeCornerRadius = UDim.new(0, Responsive.getSizes().largeCornerRadius),              -- For cards and containers
	SmallCornerRadius = UDim.new(0, Responsive.getSizes().smallCornerRadius),               -- For small elements

	-- Animation Settings
	AnimationSpeed = 0.2,                             -- Smooth animations
	HoverAnimationSpeed = 0.15,                        -- Quick hover responses

	-- Spacing System
	PaddingSmall = UDim.new(0, Responsive.getSizes().paddingSmall),
	PaddingMedium = UDim.new(0, Responsive.getSizes().paddingMedium),
	PaddingLarge = UDim.new(0, Responsive.getSizes().paddingLarge),
	MarginSmall = UDim.new(0, Responsive.getSizes().marginSmall),
	MarginMedium = UDim.new(0, Responsive.getSizes().marginMedium),
	MarginLarge = UDim.new(0, Responsive.getSizes().marginLarge),
}
-- [[ END THEME ]] --

-- [[ RESPONSIVE LAYOUT SYSTEM ]] --

local Responsive = {}

-- Get screen dimensions
function Responsive.getScreenSize()
	local guiService = game:GetService("GuiService")
	local screenSize = workspace.CurrentCamera.ViewportSize
	return screenSize
end

-- Calculate responsive sizes based on screen dimensions
function Responsive.getSizes()
	local screenSize = Responsive.getScreenSize()
	local width, height = screenSize.X, screenSize.Y

	-- Define breakpoints
	local isSmall = width < 800 or height < 600
	local isMedium = width >= 800 and width < 1200 and height >= 600 and height < 800
	local isLarge = width >= 1200 and height >= 800

	-- Responsive sizing based on screen size
	local sizes = {
		-- Header heights
		headerHeight = isSmall and 150 or isMedium and 180 or 200,

		-- Content heights
		contentHeight = isSmall and 0.6 or isMedium and 0.65 or 0.7,

		-- Action bar heights
		actionBarHeight = isSmall and 40 or 50,

		-- Card padding
		cardPadding = isSmall and 12 or isMedium and 16 or 20,

		-- Text sizes
		headerFontSize = isSmall and 20 or isMedium and 22 or 24,
		titleFontSize = isSmall and 14 or isMedium and 16 or 18,
		bodyFontSize = isSmall and 12 or isMedium and 13 or 14,
		smallFontSize = isSmall and 10 or 11,

		-- Spacing
		paddingSmall = isSmall and 4 or isMedium and 6 or 8,
		paddingMedium = isSmall and 6 or isMedium and 8 or 12,
		paddingLarge = isSmall and 10 or isMedium and 14 or 18,

		-- Component sizes
		buttonHeight = isSmall and 32 or isMedium and 40 or 44,
		inputHeight = isSmall and 24 or isMedium and 28 or 30,
		sliderHeight = isSmall and 40 or isMedium and 50 or 60,

		-- Layout direction
		isPortrait = height > width,
		isLandscape = width > height,

		-- Screen category
		isSmall = isSmall,
		isMedium = isMedium,
		isLarge = isLarge,
	}

	return sizes
end

-- Calculate responsive position
function Responsive.getPosition(elementType, index, total)
	local sizes = Responsive.getSizes()
	local screenSize = Responsive.getScreenSize()

	if elementType == "card" then
		local cardWidth = (screenSize.X - (sizes.paddingLarge * 2) - (sizes.paddingMedium * (total - 1))) / total
		return UDim2.new(0, sizes.paddingLarge + (index - 1) * (cardWidth + sizes.paddingMedium), 0, 0)
	elseif elementType == "button" then
		local buttonWidth = (screenSize.X - (sizes.paddingLarge * 2) - (sizes.paddingMedium * (total - 1))) / total
		return UDim2.new(0, sizes.paddingLarge + (index - 1) * (buttonWidth + sizes.paddingMedium), 1, -sizes.actionBarHeight - sizes.paddingMedium)
	end

	return UDim2.new(0, 0, 0, 0)
end

-- Get responsive corner radius
function Responsive.getCornerRadius(size)
	local sizes = Responsive.getSizes()
	if size == "small" then
		return UDim.new(0, sizes.isSmall and 2 or sizes.isMedium and 3 or 4)
	elseif size == "medium" then
		return UDim.new(0, sizes.isSmall and 4 or sizes.isMedium and 6 or 8)
	elseif size == "large" then
		return UDim.new(0, sizes.isSmall and 6 or sizes.isMedium and 8 or 12)
	end
	return UDim.new(0, Responsive.getSizes().spacingSmall)
end

-- [[ END RESPONSIVE LAYOUT SYSTEM ]] --

-- [[ RESPONSIVE UPDATE FUNCTIONS ]] --

local function updateResponsiveLayout()
	local sizes = Responsive.getSizes()

	-- Update header frame
	headerFrame.Size = UDim2.new(1, 0, 0, sizes.headerHeight)

	-- Update tab frame
	tabFrame.Size = UDim2.new(1, -sizes.paddingLarge * 2, 0, sizes.buttonHeight)
	tabFrame.Position = UDim2.new(0, sizes.paddingLarge, 0, sizes.headerHeight + sizes.paddingMedium)

	-- Update content container
	contentContainer.Size = UDim2.new(1, -sizes.paddingLarge * 2, sizes.contentHeight, -sizes.headerHeight - sizes.actionBarHeight - (sizes.paddingMedium * 3))
	contentContainer.Position = UDim2.new(0, sizes.paddingLarge, 0, sizes.headerHeight + sizes.buttonHeight + (sizes.paddingMedium * 2))

	-- Update action bar
	actionBarFrame.Size = UDim2.new(1, -sizes.paddingLarge * 2, 0, sizes.actionBarHeight)
	actionBarFrame.Position = UDim2.new(0, sizes.paddingLarge, 1, -sizes.actionBarHeight - sizes.paddingMedium)

	-- Update preview frame
	previewFrame.Size = UDim2.new(1, -sizes.paddingLarge * 2, 1, -sizes.buttonHeight - sizes.paddingSmall)
	previewFrame.Position = UDim2.new(0, sizes.paddingLarge, 0, sizes.buttonHeight)

	-- Update tab layout padding
	tabLayout.Padding = UDim.new(0, sizes.paddingSmall)

	-- Update action bar layout padding
	actionBarLayout.Padding = UDim.new(0, sizes.paddingMedium)

	-- Update title font size
	titleLabel.TextSize = sizes.headerFontSize

	-- Update preview corner radius
	previewCorner.CornerRadius = Responsive.getCornerRadius("large")
end

-- [[ END RESPONSIVE UPDATE FUNCTIONS ]] --

-- [[ MODERN UI HELPER FUNCTIONS ]] --

-- Create gradient background
local function createGradientFrame(parent, color1, color2, direction)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = color1
	frame.Parent = parent

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1),
		ColorSequenceKeypoint.new(1, color2)
	})
	gradient.Rotation = direction or 90
	gradient.Parent = frame

	return frame
end

-- Create glassmorphism effect
local function createGlassFrame(parent, transparency)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Theme.ContentBackground
	frame.BackgroundTransparency = transparency or Theme.ContentBackgroundAlpha
	frame.Parent = parent

	-- Add blur effect border
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.BorderColor
	stroke.Thickness = 1
	stroke.Transparency = 0.3
	stroke.Parent = frame

	-- Add corner radius
	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.CornerRadius
	corner.Parent = frame

	return frame
end

-- Create modern button with enhanced animations and feedback
local function createModernButton(parent, text, style)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.Text = text
	button.Font = Theme.FontBold
	button.TextSize = Responsive.getSizes().bodyFontSize
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.AutoButtonColor = false
	button.Parent = parent

	-- Style-based colors and effects
	local baseColor, hoverColor, pressedColor, gradientStart, gradientEnd, glowColor
	if style == "primary" then
		baseColor = Theme.Primary
		hoverColor = Theme.PrimaryGradient
		pressedColor = Color3.fromRGB(0, 120, 200)
		gradientStart = Theme.PrimaryGradientStart
		gradientEnd = Theme.PrimaryGradientEnd
		glowColor = Theme.PrimaryGlow
	elseif style == "success" then
		baseColor = Theme.Success
		hoverColor = Theme.SuccessGradient
		pressedColor = Color3.fromRGB(40, 180, 40)
		gradientStart = Theme.SuccessGradientStart
		gradientEnd = Theme.SuccessGradientEnd
		glowColor = Theme.SuccessGlow
	elseif style == "danger" then
		baseColor = Theme.Danger
		hoverColor = Theme.DangerGradient
		pressedColor = Color3.fromRGB(220, 60, 60)
		gradientStart = Theme.DangerGradientStart
		gradientEnd = Theme.DangerGradientEnd
		glowColor = Theme.DangerGlow
	else
		baseColor = Theme.DefaultButton
		hoverColor = Theme.ButtonHover
		pressedColor = Theme.ButtonPressed
		gradientStart = Theme.DefaultGradientStart
		gradientEnd = Theme.DefaultGradientEnd
		glowColor = Theme.DefaultGlow
	end

	-- Create gradient background
	local gradientFrame = Instance.new("Frame")
	gradientFrame.Size = UDim2.new(1, 0, 1, 0)
	gradientFrame.BackgroundColor3 = baseColor
	gradientFrame.ZIndex = 1
	gradientFrame.Parent = button

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, gradientStart),
		ColorSequenceKeypoint.new(1, gradientEnd)
	})
	gradient.Rotation = 135
	gradient.Parent = gradientFrame

	-- Modern styling
	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.MediumCornerRadius
	corner.Parent = gradientFrame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.BorderColor
	stroke.Thickness = 1
	stroke.Transparency = 0.3
	stroke.Parent = gradientFrame

	-- Glow effect
	local glow = Instance.new("Frame")
	glow.Size = UDim2.new(1, 4, 1, 4)
	glow.Position = UDim2.new(0, -2, 0, -2)
	glow.BackgroundColor3 = glowColor
	glow.BackgroundTransparency = 0.8
	glow.ZIndex = 0
	glow.Parent = gradientFrame

	local glowCorner = Instance.new("UICorner")
	glowCorner.CornerRadius = Theme.MediumCornerRadius
	glowCorner.Parent = glow

	-- Text label with shadow effect
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Text = text
	textLabel.Font = Theme.FontBold
	textLabel.TextSize = Responsive.getSizes().bodyFontSize
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.BackgroundTransparency = 1
	textLabel.ZIndex = 2
	textLabel.Parent = button

	-- Text shadow
	local textShadow = textLabel:Clone()
	textShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
	textShadow.TextTransparency = 0.5
	textShadow.Position = UDim2.new(0, Responsive.getSizes().textShadowOffset, 0, Responsive.getSizes().textShadowOffset)
	textShadow.ZIndex = 1
	textShadow.Parent = button

	-- Animation functions
	local tweenService = game:GetService("TweenService")

	local function animateMultiple(objects, properties, speed)
		for _, obj in pairs(objects) do
			tweenService:Create(obj, TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties):Play()
		end
	end

	-- Enhanced hover effects
	button.MouseEnter:Connect(function()
		animateMultiple({gradientFrame, glow}, {
			BackgroundColor3 = hoverColor,
			BackgroundTransparency = 0.6
		}, Theme.HoverAnimationSpeed)

		animateMultiple({stroke}, {
			Color = Theme.BorderHighlight,
			Transparency = 0.1
		}, Theme.HoverAnimationSpeed)

		-- Scale effect
		tweenService:Create(gradientFrame, TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(1.02, 0, 1.02, 0),
			Position = UDim2.new(-0.01, 0, -0.01, 0)
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		animateMultiple({gradientFrame, glow}, {
			BackgroundColor3 = baseColor,
			BackgroundTransparency = 0.8
		}, Theme.HoverAnimationSpeed)

		animateMultiple({stroke}, {
			Color = Theme.BorderColor,
			Transparency = 0.3
		}, Theme.HoverAnimationSpeed)

		-- Reset scale
		tweenService:Create(gradientFrame, TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0)
		}):Play()
	end)

	button.MouseButton1Down:Connect(function()
		animateMultiple({gradientFrame}, {
			BackgroundColor3 = pressedColor
		}, 0.1)

		-- Pressed scale effect
		tweenService:Create(gradientFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.98, 0, 0.98, 0),
			Position = UDim2.new(0.01, 0, 0.01, 0)
		}):Play()
	end)

	button.MouseButton1Up:Connect(function()
		animateMultiple({gradientFrame}, {
			BackgroundColor3 = hoverColor
		}, Theme.HoverAnimationSpeed)

		-- Release scale effect
		tweenService:Create(gradientFrame, TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(1.02, 0, 1.02, 0),
			Position = UDim2.new(-0.01, 0, -0.01, 0)
		}):Play()
	end)

	return button
end

-- Create modern card container
local function createCard(parent, title)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, Responsive.getSizes().cardHeight)
	card.BackgroundColor3 = Theme.ContentBackground
	card.Parent = parent

	-- Glassmorphism effect
	card.BackgroundTransparency = 0.1

	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.LargeCornerRadius
	corner.Parent = card

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.BorderColor
	stroke.Thickness = 1
	stroke.Transparency = 0.4
	stroke.Parent = card

	-- Add shadow effect
	local shadow = Instance.new("Frame")
	shadow.Size = UDim2.new(1, 4, 1, 4)
	shadow.Position = UDim2.new(0, Responsive.getSizes().shadowOffset, 0, Responsive.getSizes().shadowOffset)
	shadow.BackgroundColor3 = Theme.ShadowColor
	shadow.BackgroundTransparency = 0.8
	shadow.ZIndex = -1
	shadow.Parent = card

	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = Theme.LargeCornerRadius
	shadowCorner.Parent = shadow

	if title then
		local header = Instance.new("TextLabel")
		header.Size = UDim2.new(1, -20, 0, Responsive.getSizes().cardHeaderHeight)
		header.Position = UDim2.new(0, Responsive.getSizes().headerPadding, 0, 0)
		header.Text = title
		header.Font = Theme.FontBold
		header.TextSize = Theme.TitleFontSize
		header.TextColor3 = Theme.TextLight
		header.TextXAlignment = Enum.TextXAlignment.Left
		header.Parent = card
	end

	return card
end

-- [[ END MODERN UI HELPERS ]] --

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

dockWidget.Title = "GeoCraft - Catalyst World"

-- Create the main UI container with modern design
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.Parent = dockWidget

-- Add gradient background
local backgroundGradient = createGradientFrame(mainFrame, Theme.Background, Theme.BackgroundGradient, 135)

-- Modern layout structure with proper spacing
local mainLayout = Instance.new("UIListLayout")
mainLayout.FillDirection = Enum.FillDirection.Vertical
mainLayout.Padding = Theme.PaddingMedium
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainLayout.Parent = mainFrame

-- Get responsive sizes
local responsiveSizes = Responsive.getSizes()

-- Modern Header Frame with glassmorphism
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, responsiveSizes.headerHeight)
headerFrame.BackgroundTransparency = 1
headerFrame.LayoutOrder = 1
headerFrame.Parent = mainFrame

-- Create glass header background
local headerGlass = createGlassFrame(headerFrame, 0.9)
headerGlass.Size = UDim2.new(1, 0, 0, Responsive.getSizes().headerGlassHeight)

-- Modern title with better typography
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().headerGlassHeight)
titleLabel.Text = "Catalyst World"
titleLabel.Font = Theme.FontBold
titleLabel.TextSize = responsiveSizes.headerFontSize
titleLabel.TextColor3 = Theme.TextLight
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = headerFrame

-- Modern Tab Navigation with glass cards
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -responsiveSizes.paddingLarge * 2, 0, responsiveSizes.buttonHeight)
tabFrame.Position = UDim2.new(0, responsiveSizes.paddingLarge, 0, responsiveSizes.headerHeight + responsiveSizes.paddingMedium)
tabFrame.BackgroundTransparency = 1
tabFrame.LayoutOrder = 2
tabFrame.Parent = mainFrame

-- Glass tab container
local tabGlassContainer = createGlassFrame(tabFrame, 0.8)
tabGlassContainer.Size = UDim2.new(1, 0, 1, 0)

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, responsiveSizes.paddingSmall)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Parent = tabGlassContainer

-- Modern Content Container with card-based layout
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -responsiveSizes.paddingLarge * 2, responsiveSizes.contentHeight, -responsiveSizes.headerHeight - responsiveSizes.actionBarHeight - (responsiveSizes.paddingMedium * 3))
contentContainer.Position = UDim2.new(0, responsiveSizes.paddingLarge, 0, responsiveSizes.headerHeight + responsiveSizes.buttonHeight + (responsiveSizes.paddingMedium * 2))
contentContainer.BackgroundTransparency = 1
contentContainer.LayoutOrder = 3
contentContainer.Parent = mainFrame

-- Glass content background
local contentGlass = createGlassFrame(contentContainer, 0.85)
contentGlass.Size = UDim2.new(1, 0, 1, 0)

-- Modern Action Bar with glass design
local actionBarFrame = Instance.new("Frame")
actionBarFrame.Size = UDim2.new(1, -responsiveSizes.paddingLarge * 2, 0, responsiveSizes.actionBarHeight)
actionBarFrame.Position = UDim2.new(0, responsiveSizes.paddingLarge, 1, -responsiveSizes.actionBarHeight - responsiveSizes.paddingMedium)
actionBarFrame.BackgroundTransparency = 1
actionBarFrame.LayoutOrder = 4
actionBarFrame.Parent = mainFrame

-- Glass action bar background
local actionBarGlass = createGlassFrame(actionBarFrame, 0.7)
actionBarGlass.Size = UDim2.new(1, 0, 1, 0)

local actionBarLayout = Instance.new("UIListLayout")
actionBarLayout.FillDirection = Enum.FillDirection.Horizontal
actionBarLayout.Padding = UDim.new(0, responsiveSizes.paddingMedium)
actionBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
actionBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
actionBarLayout.Parent = actionBarGlass

-- Modern 3D Preview Frame with glassmorphism
local previewFrame = Instance.new("ViewportFrame")
previewFrame.Size = UDim2.new(1, -responsiveSizes.paddingLarge * 2, 1, -responsiveSizes.buttonHeight - responsiveSizes.paddingSmall)
previewFrame.Position = UDim2.new(0, responsiveSizes.paddingLarge, 0, responsiveSizes.buttonHeight)
previewFrame.BackgroundColor3 = Theme.InputBackground
previewFrame.BackgroundTransparency = 0.3
previewFrame.BorderSizePixel = 0
previewFrame.Parent = headerFrame

local previewCorner = Instance.new("UICorner")
previewCorner.CornerRadius = Responsive.getCornerRadius("large")
previewCorner.Parent = previewFrame

-- Add glass border effect
local previewStroke = Instance.new("UIStroke")
previewStroke.Color = Theme.BorderColor
previewStroke.Thickness = 1
previewStroke.Transparency = 0.5
previewStroke.Parent = previewFrame

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

-- Add screen size change listener for responsive layout
local function setupResponsiveLayout()
	-- Initial layout update
	updateResponsiveLayout()

	-- Listen for screen size changes
	local runService = game:GetService("RunService")
	local lastScreenSize = workspace.CurrentCamera.ViewportSize

	runService.Heartbeat:Connect(function()
		local currentScreenSize = workspace.CurrentCamera.ViewportSize
		if currentScreenSize ~= lastScreenSize then
			lastScreenSize = currentScreenSize
			updateResponsiveLayout()
		end
	end)
end

-- Initialize responsive layout
setupResponsiveLayout()

-- UI Helper Functions

-- Modern createSlider with enhanced design and animations
local function createModernSlider(parent, text, min, max, default, decimals)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, Responsive.getSizes().sliderHeight)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.Padding = Theme.PaddingSmall
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = container

	-- Modern label with better typography
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, Responsive.getSizes().labelHeight)
	label.Text = text .. ": " .. default
	label.Font = Theme.FontBold
	label.TextSize = Responsive.getSizes().bodyFontSize
	label.TextColor3 = Theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.LayoutOrder = 1
	label.Parent = container

	local inputRow = Instance.new("Frame")
	inputRow.Size = UDim2.new(1, 0, 0, Responsive.getSizes().inputRowHeight)
	inputRow.BackgroundTransparency = 1
	inputRow.LayoutOrder = 2
	inputRow.Parent = container

	local rowLayout = Instance.new("UIListLayout")
	rowLayout.FillDirection = Enum.FillDirection.Horizontal
	rowLayout.Padding = Theme.PaddingMedium
	rowLayout.Parent = inputRow

	-- Modern slider frame with glass effect
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(0.7, -Responsive.getSizes().paddingMedium, 1, 0)
	sliderFrame.BackgroundColor3 = Theme.ContentBackground
	sliderFrame.BackgroundTransparency = 0.4
	sliderFrame.Parent = inputRow
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = Responsive.getCornerRadius("large")
	sliderCorner.Parent = sliderFrame

	-- Glass border effect
	local sliderStroke = Instance.new("UIStroke")
	sliderStroke.Color = Theme.BorderColor
	sliderStroke.Thickness = 1
	sliderStroke.Transparency = 0.6
	sliderStroke.Parent = sliderFrame

	-- Modern gradient fill
	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = Theme.PrimaryGradientStart
	fill.BorderSizePixel = 0
	fill.Parent = sliderFrame
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = Responsive.getCornerRadius("large")
	fillCorner.Parent = fill

	-- Gradient effect for fill
	local fillGradient = Instance.new("UIGradient")
	fillGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Theme.PrimaryGradientStart),
		ColorSequenceKeypoint.new(1, Theme.PrimaryGradientEnd)
	})
	fillGradient.Parent = fill

	-- Modern circular knob
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, Responsive.getSizes().knobSize, 0, Responsive.getSizes().knobSize)
	knob.BackgroundColor3 = Theme.TextLight
	knob.BorderSizePixel = 0
	knob.ZIndex = 2
	knob.Parent = sliderFrame
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	-- Knob shadow for depth
	local knobShadow = Instance.new("Frame")
	knobShadow.Size = UDim2.new(0, Responsive.getSizes().knobSize + 4, 0, Responsive.getSizes().knobSize + 4)
	knobShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	knobShadow.BackgroundTransparency = 0.8
	knobShadow.ZIndex = 1
	knobShadow.Parent = sliderFrame
	local knobShadowCorner = Instance.new("UICorner")
	knobShadowCorner.CornerRadius = UDim.new(1, 0)
	knobShadowCorner.Parent = knobShadow

	-- Modern value box with glass design
	local valueBox = Instance.new("TextBox")
	valueBox.Size = UDim2.new(0.3, -Responsive.getSizes().paddingMedium, 1, 0)
	valueBox.BackgroundColor3 = Theme.ContentBackground
	valueBox.BackgroundTransparency = 0.3
	valueBox.TextColor3 = Theme.Text
	valueBox.Font = Theme.FontBold
	valueBox.TextSize = Responsive.getSizes().bodyFontSize
	valueBox.PlaceholderText = "Value"
	valueBox.Parent = inputRow
	local valueBoxCorner = Instance.new("UICorner")
	valueBoxCorner.CornerRadius = Responsive.getCornerRadius("medium")
	valueBoxCorner.Parent = valueBox

	local valueBoxStroke = Instance.new("UIStroke")
	valueBoxStroke.Color = Theme.BorderColor
	valueBoxStroke.Thickness = 1
	valueBoxStroke.Transparency = 0.6
	valueBoxStroke.Parent = valueBox

	local value = default
	local setValue
	local dragging = false
	local tweenService = game:GetService("TweenService")

	local function updateVisuals(percentage)
		fill.Size = UDim2.new(percentage, 0, 1, 0)
		knob.Position = UDim2.new(percentage, -8, 0.5, -8) -- Centered
		knobShadow.Position = UDim2.new(percentage, -10, 0.5, -10)

		-- Smooth animation for knob
		tweenService:Create(knob, TweenInfo.new(0.1), {Position = UDim2.new(percentage, -8, 0.5, -8)}):Play()
		tweenService:Create(knobShadow, TweenInfo.new(0.1), {Position = UDim2.new(percentage, -10, 0.5, -10)}):Play()
	end

	-- Enhanced input handling with smooth animations
	sliderFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			-- Animate to active state
			tweenService:Create(sliderStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
				Color = Theme.Primary,
				Transparency = 0.2
			}):Play()
			tweenService:Create(knob, TweenInfo.new(Theme.HoverAnimationSpeed), {
				Size = UDim2.new(0, Responsive.getSizes().sliderKnobSize, 0, Responsive.getSizes().sliderKnobSize)
			}):Play()
		end
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			-- Animate back to normal state
			tweenService:Create(sliderStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
				Color = Theme.BorderColor,
				Transparency = 0.6
			}):Play()
			tweenService:Create(knob, TweenInfo.new(Theme.HoverAnimationSpeed), {
				Size = UDim2.new(0, Responsive.getSizes().sliderKnobSize, 0, Responsive.getSizes().sliderKnobSize)
			}):Play()
		end
	end)

	sliderFrame.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local relativeX = input.Position.X - sliderFrame.AbsolutePosition.X
			local percentage = math.clamp(relativeX / sliderFrame.AbsoluteSize.X, 0, 1)
			local newValue = min + (max - min) * percentage
			setValue(decimals and newValue or math.floor(newValue + 0.5), true)
		end
	end)

	-- Enhanced value box interactions with validation feedback
	valueBox.FocusLost:Connect(function(enterPressed)
		local num = tonumber(valueBox.Text)
		if num then
			if num >= min and num <= max then
				-- Valid input - success state
				setValue(math.clamp(num, min, max), true)
				tweenService:Create(valueBoxStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
					Color = Theme.Success,
					Transparency = 0.3
				}):Play()
			else
				-- Invalid range - error state
				setValue(value, false)
				tweenService:Create(valueBoxStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
					Color = Theme.Danger,
					Transparency = 0.3
				}):Play()
				-- Show validation message
				local validationLabel = Instance.new("TextLabel")
				validationLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().validationLabelHeight)
				validationLabel.Position = UDim2.new(0, 0, 1, Responsive.getSizes().validationLabelOffset)
				validationLabel.Text = "Value must be between " .. min .. " and " .. max
				validationLabel.Font = Theme.Font
				validationLabel.TextSize = Responsive.getSizes().smallFontSize
				validationLabel.TextColor3 = Theme.Danger
				validationLabel.TextXAlignment = Enum.TextXAlignment.Left
				validationLabel.BackgroundTransparency = 1
				validationLabel.Name = "ValidationLabel"
				validationLabel.Parent = container

				-- Fade out after 2 seconds
				local fadeTween = tweenService:Create(validationLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 1.5), {
					TextTransparency = 1
				})
				fadeTween:Play()
				fadeTween.Completed:Connect(function()
					validationLabel:Destroy()
				end)
			end
		else
			-- Invalid input - error state
			setValue(value, false)
			tweenService:Create(valueBoxStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
				Color = Theme.Danger,
				Transparency = 0.3
			}):Play()

			-- Show validation message
			local validationLabel = Instance.new("TextLabel")
			validationLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().validationLabelHeight)
			validationLabel.Position = UDim2.new(0, 0, 1, Responsive.getSizes().validationLabelOffset)
			validationLabel.Text = "Please enter a valid number"
			validationLabel.Font = Theme.Font
			validationLabel.TextSize = Responsive.getSizes().smallFontSize
			validationLabel.TextColor3 = Theme.Danger
			validationLabel.TextXAlignment = Enum.TextXAlignment.Left
			validationLabel.BackgroundTransparency = 1
			validationLabel.Name = "ValidationLabel"
			validationLabel.Parent = container

			-- Fade out after 2 seconds
			local fadeTween = tweenService:Create(validationLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 1.5), {
				TextTransparency = 1
			})
			fadeTween:Play()
			fadeTween.Completed:Connect(function()
				validationLabel:Destroy()
			end)
		end

		-- Animate back to normal state after delay
		wait(2)
		tweenService:Create(valueBoxStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
			Color = Theme.BorderColor,
			Transparency = 0.6
		}):Play()
	end)

	valueBox.Focused:Connect(function()
		-- Animate to focused state
		tweenService:Create(valueBoxStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
			Color = Theme.Primary,
			Transparency = 0.3
		}):Play()
	end)

	setValue = function(newValue, updateSliderVisuals)
		value = math.clamp(newValue, min, max)
		local percentage = (value - min) / (max - min)

		label.Text = text .. ": " .. (decimals and string.format("%.2f", value) or string.format("%.0f", value))
		valueBox.Text = decimals and string.format("%.2f", value) or string.format("%.0f", value)

		if updateSliderVisuals then
			updateVisuals(percentage)
		end
	end

	setValue(default, true)

	return function() return value end, setValue
end

-- Updated createSegmentedControl for the "Futuristic & Professional" theme
local function createSegmentedControl(parent, options)
	local selectedValue = options[1]
	local onSelectionChangedCallbacks = {}

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, Responsive.getSizes().segmentedControlHeight) -- Increased height for better feel
	container.BackgroundColor3 = Theme.InputBackground
	container.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = Responsive.getCornerRadius("small")
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
	selectorCorner.CornerRadius = Responsive.getCornerRadius("small")
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
		button.TextSize = Responsive.getSizes().smallFontSize
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
	container.Size = UDim2.new(1, 0, 0, Responsive.getSizes().checkboxHeight)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -Responsive.getSizes().switchWidth, 1, 0) -- Leave space for the switch
	label.Text = text
	label.Font = Theme.Font
	label.TextSize = Responsive.getSizes().bodyFontSize
	label.TextColor3 = Theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	-- The toggle switch track
	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, Responsive.getSizes().switchWidth, 0, Responsive.getSizes().switchHeight)
	switch.Text = ""
	switch.BackgroundColor3 = isChecked and Theme.Primary or Theme.InputBackground
	switch.Parent = container
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(0, Responsive.getSizes().switchHeight/2) -- Make it pill-shaped
	switchCorner.Parent = switch
	local switchStroke = Instance.new("UIStroke")
	switchStroke.Color = Theme.HeaderBackground
	switchStroke.Parent = switch

	-- The knob that moves
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, Responsive.getSizes().knobSize, 0, Responsive.getSizes().knobSize)
	knob.Position = isChecked and UDim2.new(1, -(Responsive.getSizes().knobSize + Responsive.getSizes().knobOffset), 0, Responsive.getSizes().knobOffset) or UDim2.new(0, Responsive.getSizes().knobOffset, 0, Responsive.getSizes().knobOffset)
	knob.BackgroundColor3 = Theme.TextLight
	knob.Parent = switch
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0) -- Make it a circle
	knobCorner.Parent = knob

	local function updateState()
		local targetColor = isChecked and Theme.Primary or Theme.InputBackground
		local targetPosition = isChecked and UDim2.new(1, -Responsive.getSizes().switchKnobSize - 2, 0, 2) or UDim2.new(0, 2, 0, 2)
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		game:GetService("TweenService"):Create(switch, tweenInfo, { BackgroundColor3 = targetColor }):Play()
		game:GetService("TweenService"):Create(knob, tweenInfo, { Position = targetPosition }):Play()
	end

	-- Hover effects for checkbox
	switch.MouseEnter:Connect(function()
		local tweenService = game:GetService("TweenService")
		local tweenInfo = TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		-- Scale up the switch slightly
		tweenService:Create(switch, tweenInfo, { Size = UDim2.new(0, Responsive.getSizes().switchWidth + 2, 0, Responsive.getSizes().switchHeight + 2) }):Play()
		tweenService:Create(knob, tweenInfo, { Size = UDim2.new(0, Responsive.getSizes().knobSize + 2, 0, Responsive.getSizes().knobSize + 2) }):Play()

		-- Brighten the stroke
		tweenService:Create(switchStroke, tweenInfo, { 
			Color = Theme.BorderHighlight,
			Transparency = 0.2
		}):Play()
	end)

	switch.MouseLeave:Connect(function()
		local tweenService = game:GetService("TweenService")
		local tweenInfo = TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		-- Reset scale
		tweenService:Create(switch, tweenInfo, { Size = UDim2.new(0, Responsive.getSizes().switchWidth, 0, Responsive.getSizes().switchHeight) }):Play()
		tweenService:Create(knob, tweenInfo, { Size = UDim2.new(0, Responsive.getSizes().knobSize, 0, Responsive.getSizes().knobSize) }):Play()

		-- Reset stroke
		tweenService:Create(switchStroke, tweenInfo, { 
			Color = Theme.HeaderBackground,
			Transparency = 0
		}):Play()
	end)

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
	container.Size = UDim2.new(1, 0, 0, Responsive.getSizes().dropdownHeight)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local mainButton = Instance.new("TextButton")
	mainButton.Size = UDim2.new(1, 0, 1, 0)
	mainButton.Text = selectedValue
	mainButton.BackgroundColor3 = Theme.DefaultButton
	mainButton.TextColor3 = Theme.Text
	mainButton.TextSize = Responsive.getSizes().bodyFontSize
	mainButton.Parent = container
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = Responsive.getCornerRadius("small")
	buttonCorner.Parent = mainButton

	-- Add stroke for hover effects
	local buttonStroke = Instance.new("UIStroke")
	buttonStroke.Color = Theme.BorderColor
	buttonStroke.Thickness = 1
	buttonStroke.Transparency = 0.5
	buttonStroke.Parent = mainButton

	local optionsList = Instance.new("ScrollingFrame")
	optionsList.Size = UDim2.new(1, 0, 0, Responsive.getSizes().dropdownListHeight)
	optionsList.Position = UDim2.new(0, 0, 1, 0)
	optionsList.BackgroundColor3 = Theme.DefaultButton
	optionsList.BorderSizePixel = 1
	optionsList.BorderColor3 = Theme.InputBackground
	optionsList.Visible = false
	optionsList.Parent = mainButton
	optionsList.ZIndex = 2
	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = Responsive.getCornerRadius("small")
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
			optionButton.Size = UDim2.new(1, 0, 0, Responsive.getSizes().dropdownItemHeight)
			optionButton.Text = optionText
			optionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			optionButton.TextColor3 = Theme.Text
			optionButton.TextSize = Responsive.getSizes().bodyFontSize
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

	-- Hover effects for dropdown
	mainButton.MouseEnter:Connect(function()
		local tweenService = game:GetService("TweenService")
		local tweenInfo = TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		-- Scale up slightly
		tweenService:Create(mainButton, tweenInfo, { 
			Size = UDim2.new(1, 2, 1, 2),
			Position = UDim2.new(0, -1, 0, -1)
		}):Play()

		-- Brighten stroke
		tweenService:Create(buttonStroke, tweenInfo, { 
			Color = Theme.BorderHighlight,
			Transparency = 0.2
		}):Play()

		-- Brighten background
		tweenService:Create(mainButton, tweenInfo, { 
			BackgroundColor3 = Theme.ButtonHover
		}):Play()
	end)

	mainButton.MouseLeave:Connect(function()
		local tweenService = game:GetService("TweenService")
		local tweenInfo = TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		-- Reset scale
		tweenService:Create(mainButton, tweenInfo, { 
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0)
		}):Play()

		-- Reset stroke
		tweenService:Create(buttonStroke, tweenInfo, { 
			Color = Theme.BorderColor,
			Transparency = 0.5
		}):Play()

		-- Reset background
		tweenService:Create(mainButton, tweenInfo, { 
			BackgroundColor3 = Theme.DefaultButton
		}):Play()
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
	container.Size = UDim2.new(1, 0, 0, Responsive.getSizes().progressBarHeight)
	container.BackgroundColor3 = Theme.ContentBackground
	container.BorderSizePixel = 0
	container.Visible = false
	container.Parent = parent
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = Responsive.getCornerRadius("large")
	containerCorner.Parent = container

	local containerStroke = Instance.new("UIStroke")
	containerStroke.Color = Theme.BorderColor
	containerStroke.Thickness = 1
	containerStroke.Transparency = 0.3
	containerStroke.Parent = container

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Theme.Primary
	fill.BorderSizePixel = 0
	fill.Parent = container
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = Theme.LargeCornerRadius
	fillCorner.Parent = fill

	local fillGradient = Instance.new("UIGradient")
	fillGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Theme.PrimaryGradientStart),
		ColorSequenceKeypoint.new(1, Theme.PrimaryGradientEnd)
	})
	fillGradient.Parent = fill

	local fillGlow = Instance.new("Frame")
	fillGlow.Size = UDim2.new(1, 0, 1, 0)
	fillGlow.BackgroundTransparency = 0.8
	fillGlow.BackgroundColor3 = Theme.Primary
	fillGlow.BorderSizePixel = 0
	fillGlow.Parent = fill
	local glowCorner = Instance.new("UICorner")
	glowCorner.CornerRadius = Theme.LargeCornerRadius
	glowCorner.Parent = fillGlow

	local fillGlowGradient = Instance.new("UIGradient")
	fillGlowGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Theme.Primary),
		ColorSequenceKeypoint.new(0.5, Theme.TextLight),
		ColorSequenceKeypoint.new(1, Theme.Primary)
	})
	fillGlowGradient.Offset = Vector2.new(-1, 0)
	fillGlowGradient.Parent = fillGlow

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Text = "Generating..."
	label.Font = Theme.FontBold
	label.TextSize = Responsive.getSizes().bodyFontSize
	label.TextColor3 = Theme.Text
	label.BackgroundTransparency = 1
	label.ZIndex = 2
	label.Parent = container

	local loadingDots = Instance.new("TextLabel")
	loadingDots.Size = UDim2.new(1, 0, 1, 0)
	loadingDots.Text = ""
	loadingDots.Font = Theme.FontBold
	loadingDots.TextSize = Responsive.getSizes().bodyFontSize
	loadingDots.TextColor3 = Theme.TextMuted
	loadingDots.BackgroundTransparency = 1
	loadingDots.ZIndex = 3
	loadingDots.Parent = container

	local function updateProgress(percentage, text)
		container.Visible = true
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		game:GetService("TweenService"):Create(fill, tweenInfo, { Size = UDim2.new(percentage, 0, 1, 0) }):Play()

		if percentage < 1 then
			label.Text = text or string.format("Generating... %.0f%%", percentage * 100)
			loadingDots.Text = ""

			-- Animate loading dots
			local dots = 0
			local dotConnection
			dotConnection = game:GetService("RunService").Heartbeat:Connect(function()
				dots = (dots + 1) % 4
				loadingDots.Text = string.rep(".", dots)
			end)

			-- Stop dots animation when progress reaches 100%
			if percentage >= 1 then
				dotConnection:Disconnect()
			end
		else
			label.Text = "Complete!"
			loadingDots.Text = "✓"
		end
	end

	local function hide()
		container.Visible = false
	end

	-- Add pulsing animation to the fill glow
	local function startGlowAnimation()
		local glowTween = TweenService:Create(fillGlowGradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {
			Offset = Vector2.new(1, 0)
		})
		glowTween:Play()
	end

	startGlowAnimation()

	return updateProgress, hide
end

local function createLoadingSpinner(parent, size)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, size or 24, 0, size or 24)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local spinner = Instance.new("Frame")
	spinner.Size = UDim2.new(1, 0, 1, 0)
	spinner.BackgroundTransparency = 1
	spinner.Parent = container

	-- Create spinner segments
	local segments = {}
	for i = 1, 8 do
		local segment = Instance.new("Frame")
		segment.Size = UDim2.new(0.15, 0, 0.15, 0)
		segment.Position = UDim2.new(0.5, 0, 0.1, 0)
		segment.AnchorPoint = Vector2.new(0.5, 0.5)
		segment.BackgroundColor3 = Theme.Primary
		segment.BackgroundTransparency = 1 - (i / 8)
		segment.BorderSizePixel = 0
		segment.Parent = spinner

		local rotation = i * 45
		local angle = math.rad(rotation)
		local radius = (size or 24) * 0.35
		segment.Position = UDim2.new(0.5 + math.sin(angle) * 0.35, 0, 0.5 - math.cos(angle) * 0.35, 0)
		segment.Rotation = rotation

		table.insert(segments, segment)
	end

	-- Animate rotation
	local function startSpinAnimation()
		local spinTween = TweenService:Create(spinner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {
			Rotation = 360
		})
		spinTween:Play()
		return spinTween
	end

	-- Animate segment opacity
	local function startSegmentAnimation()
		for i, segment in ipairs(segments) do
			local delay = (i - 1) * 0.1
			local function animateSegment()
				local fadeTween = TweenService:Create(segment, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
					BackgroundTransparency = 0.8
				})
				fadeTween:Play()
				fadeTween.Completed:Connect(function()
					local showTween = TweenService:Create(segment, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
						BackgroundTransparency = 0.2
					})
					showTween:Play()
				end)
			end

			-- Start animation with delay
			local connection
			connection = game:GetService("RunService").Heartbeat:Connect(function()
				connection:Disconnect()
				animateSegment()
			end)
		end
	end

	local spinTween = startSpinAnimation()
	startSegmentAnimation()

	local function show()
		container.Visible = true
	end

	local function hide()
		container.Visible = false
		if spinTween then
			spinTween:Cancel()
		end
	end

	return show, hide
end

-- [[!]] FUNGSI BARU createTerrainSelector
local function createTerrainSelector(parent)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, Responsive.getSizes().dropdownContainerHeight) -- Memberi ruang untuk daftar gulir
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
			label.Size = UDim2.new(1, 0, 0, Responsive.getSizes().sectionHeaderLabelHeight)
			label.Text = "Harap tambahkan Terrain ke Workspace."
			label.Font = Enum.Font.SourceSans
			label.TextColor3 = Color3.fromRGB(255, 180, 180) -- Warna peringatan
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

		elseif #terrainObjects == 1 then
			selectedTerrainName = terrainObjects[1]
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, Responsive.getSizes().sectionHeaderLabelHeight)
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
			listLayout.Padding = UDim.new(0, Responsive.getSizes().listPadding)
			listLayout.Parent = listFrame

			for _, terrainName in ipairs(terrainObjects) do
				local button = Instance.new("TextButton")
				button.Size = UDim2.new(1, -10, 0, Responsive.getSizes().biomeCardHeight)
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
	container.Size = UDim2.new(1, 0, 0, Responsive.getSizes().biomeCardContainerHeight) -- Ketinggian untuk kartu
	container.BackgroundTransparency = 1
	container.Parent = parent

	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0, Responsive.getSizes().biomeCardWidth, 0, Responsive.getSizes().biomeCardHeight) -- Ukuran kartu
	gridLayout.CellPadding = UDim2.new(0, Responsive.getSizes().gridCellPadding, 0, Responsive.getSizes().gridCellPadding)
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
		card.Size = UDim2.new(0, Responsive.getSizes().biomeCardWidth, 0, Responsive.getSizes().biomeCardHeight)
		card.Text = presetName
		card.Font = Enum.Font.SourceSansBold
		card.TextSize = Responsive.getSizes().biomeCardTextSize
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
	container.Size = UDim2.new(1, 0, 0, Responsive.getSizes().presetManagerHeight) -- Ketinggian untuk manajer
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, Responsive.getSizes().layoutPadding)
	layout.Parent = container

	local label = Instance.new("TextLabel")
	label.Text = "Settings Presets:"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Size = UDim2.new(1, 0, 0, Responsive.getSizes().sectionHeaderLabelHeight)
	label.Font = Enum.Font.SourceSansBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	-- Daftar untuk preset yang ada
	local listFrame = Instance.new("ScrollingFrame")
	listFrame.Size = UDim2.new(1, 0, 1, -60) -- Ketinggian dikurangi bagian "Save"
	listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	listFrame.Parent = container

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, Responsive.getSizes().listPadding)
	listLayout.Parent = listFrame

	-- Bagian "Save New"
	local saveFrame = Instance.new("Frame")
	saveFrame.Size = UDim2.new(1, 0, 0, Responsive.getSizes().presetManagerSaveFrameHeight)
	saveFrame.BackgroundTransparency = 1
	saveFrame.Parent = container

	local saveLayout = Instance.new("UIListLayout")
	saveLayout.FillDirection = Enum.FillDirection.Horizontal
	saveLayout.Padding = UDim.new(0, Responsive.getSizes().layoutPadding)
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
			noPresetLabel.Size = UDim2.new(1, -10, 0, Responsive.getSizes().presetManagerItemHeight)
			noPresetLabel.Text = "Belum ada preset yang disimpan."
			noPresetLabel.Font = Enum.Font.SourceSansItalic
			noPresetLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
			noPresetLabel.Parent = listFrame
		end

		for _, name in ipairs(names) do
			local itemFrame = Instance.new("Frame")
			itemFrame.Size = UDim2.new(1, 0, 0, Responsive.getSizes().presetManagerItemHeight)
			itemFrame.BackgroundTransparency = 1
			itemFrame.Parent = listFrame

			local itemLayout = Instance.new("UIListLayout")
			itemLayout.FillDirection = Enum.FillDirection.Horizontal
			itemLayout.Padding = UDim.new(0, Responsive.getSizes().layoutPadding)
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
			loadButton.TextSize = Responsive.getSizes().presetManagerButtonTextSize
			loadButton.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
			loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			loadButton.Parent = itemFrame

			local deleteButton = Instance.new("TextButton")
			deleteButton.Size = UDim2.new(0.25, 0, 1, 0)
			deleteButton.Text = "Hapus"
			deleteButton.TextSize = Responsive.getSizes().presetManagerButtonTextSize
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
	container.Size = UDim2.new(1, 0, 0, Responsive.getSizes().materialCheckboxesContainerHeight)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, Responsive.getSizes().layoutPadding)
	layout.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, Responsive.getSizes().sectionHeaderLabelHeight)
	label.Text = "Place Assets On:"
	label.Font = Enum.Font.SourceSans
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local checkboxesContainer = Instance.new("Frame")
	checkboxesContainer.Size = UDim2.new(1, 0, 0, Responsive.getSizes().checkboxesContainerHeight)
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
	container.Size = UDim2.new(1, 0, 0, Responsive.getSizes().sectionHeaderHeight)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, Responsive.getSizes().paddingSmall)
	layout.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, Responsive.getSizes().sectionHeaderLabelHeight)
	label.Text = text
	label.Font = Theme.FontBold
	label.TextColor3 = Theme.Primary -- Use accent color for emphasis
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.Parent = container

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, Responsive.getSizes().separatorLineHeight)
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

	-- Deactivate the old tab with animations
	if activeTab then
		activeTab.isActive = false
		-- Animate out
		game:GetService("TweenService"):Create(activeTab.button, TweenInfo.new(Theme.TabAnimationSpeed), {
			BackgroundTransparency = 0.3,
			BackgroundColor3 = Theme.ContentBackground
		}):Play()
		game:GetService("TweenService"):Create(activeTab.button.UIStroke, TweenInfo.new(Theme.TabAnimationSpeed), {
			Transparency = 0.5,
			Color = Theme.BorderColor
		}):Play()

		-- Animate icon and text
		local oldIconLabel = activeTab.button:FindFirstChild("Frame"):FindFirstChild("TextLabel")
		local oldTextLabel = activeTab.button:FindFirstChild("Frame"):FindFirstChild("TextLabel", 1)
		if oldIconLabel and oldTextLabel then
			game:GetService("TweenService"):Create(oldIconLabel, TweenInfo.new(Theme.TabAnimationSpeed), {
				TextColor3 = Theme.TextMuted
			}):Play()
			game:GetService("TweenService"):Create(oldTextLabel, TweenInfo.new(Theme.TabAnimationSpeed), {
				TextColor3 = Theme.TextMuted
			}):Play()
		end

		activeTab.content.Visible = false
	end

	-- Activate the new tab with animations
	tabToActivate.isActive = true
	game:GetService("TweenService"):Create(tabToActivate.button, TweenInfo.new(Theme.TabAnimationSpeed), {
		BackgroundTransparency = 0.1,
		BackgroundColor3 = Theme.Primary
	}):Play()
	game:GetService("TweenService"):Create(tabToActivate.button.UIStroke, TweenInfo.new(Theme.TabAnimationSpeed), {
		Transparency = 0,
		Color = Theme.Primary
	}):Play()

	-- Animate icon and text
	local newIconLabel = tabToActivate.button:FindFirstChild("Frame"):FindFirstChild("TextLabel")
	local newTextLabel = tabToActivate.button:FindFirstChild("Frame"):FindFirstChild("TextLabel", 1)
	if newIconLabel and newTextLabel then
		game:GetService("TweenService"):Create(newIconLabel, TweenInfo.new(Theme.TabAnimationSpeed), {
			TextColor3 = Theme.Text
		}):Play()
		game:GetService("TweenService"):Create(newTextLabel, TweenInfo.new(Theme.TabAnimationSpeed), {
			TextColor3 = Theme.Text
		}):Play()
	end

	tabToActivate.content.Visible = true
	activeTab = tabToActivate
end

local function createModernTab(name, icon)
	-- Modern tab button with glass design and icons
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 120, 1, -10)
	button.Position = UDim2.new(0, 0, 0, Responsive.getSizes().buttonOffset)
	button.Text = ""
	button.BackgroundColor3 = Theme.ContentBackground
	button.BackgroundTransparency = 0.3
	button.BorderSizePixel = 0
	button.Parent = tabGlassContainer

	-- Modern styling
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = Theme.SmallCornerRadius
	buttonCorner.Parent = button

	local buttonStroke = Instance.new("UIStroke")
	buttonStroke.Color = Theme.BorderColor
	buttonStroke.Thickness = 1
	buttonStroke.Transparency = 0.5
	buttonStroke.Parent = button

	-- Icon and text container
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, 0, 1, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = button

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.FillDirection = Enum.FillDirection.Horizontal
	contentLayout.Padding = Theme.PaddingSmall
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	contentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	contentLayout.Parent = contentFrame

	-- Icon placeholder (using text as icon for now)
	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size = UDim2.new(0, Responsive.getSizes().tabIconSize, 0, Responsive.getSizes().tabIconSize)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Text = icon or "⚡"
	iconLabel.Font = Theme.FontBold
	iconLabel.TextSize = Responsive.getSizes().bodyFontSize
	iconLabel.TextColor3 = Theme.TextMuted
	iconLabel.Parent = contentFrame

	-- Tab text with improved typography
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0, 0, 0, Responsive.getSizes().tabTextHeight)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = name
	textLabel.Font = Theme.FontBold
	textLabel.TextSize = Responsive.getSizes().bodyFontSize
	textLabel.TextColor3 = Theme.TextMuted
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = contentFrame

	-- Hover animations
	button.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(button, TweenInfo.new(Theme.HoverAnimationSpeed), {
			BackgroundTransparency = 0.1
		}):Play()
		game:GetService("TweenService"):Create(buttonStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
			Transparency = 0.2
		}):Play()
		game:GetService("TweenService"):Create(iconLabel, TweenInfo.new(Theme.HoverAnimationSpeed), {
			TextColor3 = Theme.Text
		}):Play()
		game:GetService("TweenService"):Create(textLabel, TweenInfo.new(Theme.HoverAnimationSpeed), {
			TextColor3 = Theme.Text
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		if not tabData.isActive then
			game:GetService("TweenService"):Create(button, TweenInfo.new(Theme.HoverAnimationSpeed), {
				BackgroundTransparency = 0.3
			}):Play()
			game:GetService("TweenService"):Create(buttonStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
				Transparency = 0.5
			}):Play()
			game:GetService("TweenService"):Create(iconLabel, TweenInfo.new(Theme.HoverAnimationSpeed), {
				TextColor3 = Theme.TextMuted
			}):Play()
			game:GetService("TweenService"):Create(textLabel, TweenInfo.new(Theme.HoverAnimationSpeed), {
				TextColor3 = Theme.TextMuted
			}):Play()
		end
	end)

	-- Modern content container
	local content = Instance.new("ScrollingFrame")
	content.Size = UDim2.new(1, -20, 1, -20)
	content.Position = UDim2.new(0, Responsive.getSizes().contentPadding, 0, Responsive.getSizes().contentPadding)
	content.BackgroundTransparency = 1
	content.ScrollBarThickness = Responsive.getSizes().scrollBarThickness
	content.ScrollBarImageColor3 = Theme.Primary
	content.Visible = false
	content.Parent = contentContainer

	-- Content layout with proper spacing
	local layout = Instance.new("UIListLayout")
	layout.Padding = Theme.PaddingLarge
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = content

	-- Padding for content
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = Theme.PaddingMedium
	padding.PaddingBottom = Theme.PaddingMedium
	padding.PaddingLeft = Theme.PaddingMedium
	padding.PaddingRight = Theme.PaddingMedium
	padding.Parent = content

	local tabData = {button = button, content = content, isActive = false}
	tabs[name] = tabData

	button.MouseButton1Click:Connect(function()
		switchTab(tabData)
	end)

	return content
end

-- Create the tabs with modern design and icons
local globalSettingsContent = createModernTab("Global", "⚙️")
local landformsContent = createModernTab("Landforms", "🏔️")
local hydrologyContent = createModernTab("Hydrology", "💧")
local biomesContent = createModernTab("Biomes", "🌿")
local sculptContent = createModernTab("Sculpt", "🔨")

-- Set the initial active tab
switchTab(tabs["Global"])


-- Add UI elements for the Global Settings tab with modern card design

-- Terrain Selection Card
local terrainCard = createCard(globalSettingsContent, "Terrain Selection", 1)

local targetTerrainLabel = Instance.new("TextLabel")
targetTerrainLabel.Text = "Target Terrain:"
targetTerrainLabel.TextColor3 = Theme.Text
targetTerrainLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().labelHeight)
targetTerrainLabel.Font = Theme.Font
targetTerrainLabel.TextSize = Responsive.getSizes().bodyFontSize
targetTerrainLabel.LayoutOrder = 1
targetTerrainLabel.Parent = terrainCard

local getTargetTerrain, updateTargetTerrainUI = createTerrainSelector(terrainCard)
getTargetTerrain().LayoutOrder = 2

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


-- World Settings Card
local worldSettingsCard = createCard(globalSettingsContent, "World Settings", 2)

local sizeXLabel = Instance.new("TextLabel")
sizeXLabel.Text = "Size X:"
sizeXLabel.TextColor3 = Theme.Text
sizeXLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().labelHeight)
sizeXLabel.Font = Theme.Font
sizeXLabel.TextSize = Responsive.getSizes().bodyFontSize
sizeXLabel.LayoutOrder = 1
sizeXLabel.Parent = worldSettingsCard

sizeXInput = Instance.new("TextBox")
sizeXInput.Size = UDim2.new(1, 0, 0, Responsive.getSizes().inputHeight)
sizeXInput.Text = "256"
sizeXInput.BackgroundColor3 = Theme.InputBackground
sizeXInput.TextColor3 = Theme.Text
sizeXInput.Font = Theme.Font
sizeXInput.TextSize = Responsive.getSizes().bodyFontSize
sizeXInput.LayoutOrder = 2
sizeXInput.Parent = worldSettingsCard
sizeXInput.PlaceholderText = "Enter size (64-1024)"
local sizeXCorner = Instance.new("UICorner")
sizeXCorner.CornerRadius = Responsive.getCornerRadius("small")
sizeXCorner.Parent = sizeXInput

-- Add validation stroke
local sizeXStroke = Instance.new("UIStroke")
sizeXStroke.Color = Theme.BorderColor
sizeXStroke.Thickness = 1
sizeXStroke.Transparency = 0.6
sizeXStroke.Parent = sizeXInput

-- Add validation to sizeXInput
sizeXInput.FocusLost:Connect(function()
	local num = tonumber(sizeXInput.Text)
	if num then
		if num >= 64 and num <= 1024 then
			-- Valid input - success state
			tweenService:Create(sizeXStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
				Color = Theme.Success,
				Transparency = 0.3
			}):Play()
		else
			-- Invalid range - error state
			tweenService:Create(sizeXStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
				Color = Theme.Danger,
				Transparency = 0.3
			}):Play()
		end
	else
		-- Invalid input - error state
		tweenService:Create(sizeXStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
			Color = Theme.Danger,
			Transparency = 0.3
		}):Play()
	end

	-- Reset after delay
	wait(2)
	tweenService:Create(sizeXStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
		Color = Theme.BorderColor,
		Transparency = 0.6
	}):Play()
end)

-- Hover effects for sizeXInput
sizeXInput.MouseEnter:Connect(function()
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Scale up slightly
	tweenService:Create(sizeXInput, tweenInfo, { 
		Size = UDim2.new(1, 4, 0, Responsive.getSizes().inputHeight + 2),
		Position = UDim2.new(0, -2, 0, -1)
	}):Play()

	-- Brighten stroke
	tweenService:Create(sizeXStroke, tweenInfo, { 
		Color = Theme.BorderHighlight,
		Transparency = 0.3
	}):Play()

	-- Brighten background
	tweenService:Create(sizeXInput, tweenInfo, { 
		BackgroundColor3 = Theme.InputHover
	}):Play()
end)

sizeXInput.MouseLeave:Connect(function()
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Reset scale
	tweenService:Create(sizeXInput, tweenInfo, { 
		Size = UDim2.new(1, 0, 0, Responsive.getSizes().inputHeight),
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()

	-- Reset stroke
	tweenService:Create(sizeXStroke, tweenInfo, { 
		Color = Theme.BorderColor,
		Transparency = 0.6
	}):Play()

	-- Reset background
	tweenService:Create(sizeXInput, tweenInfo, { 
		BackgroundColor3 = Theme.InputBackground
	}):Play()
end)

local sizeZLabel = Instance.new("TextLabel")
sizeZLabel.Text = "Size Z:"
sizeZLabel.TextColor3 = Theme.Text
sizeZLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().labelHeight)
sizeZLabel.Font = Theme.Font
sizeZLabel.TextSize = Responsive.getSizes().bodyFontSize
sizeZLabel.LayoutOrder = 3
sizeZLabel.Parent = worldSettingsCard

sizeZInput = Instance.new("TextBox")
sizeZInput.Size = UDim2.new(1, 0, 0, Responsive.getSizes().inputHeight)
sizeZInput.Text = "256"
sizeZInput.BackgroundColor3 = Theme.InputBackground
sizeZInput.TextColor3 = Theme.Text
sizeZInput.Font = Theme.Font
sizeZInput.TextSize = Responsive.getSizes().bodyFontSize
sizeZInput.LayoutOrder = 4
sizeZInput.Parent = worldSettingsCard
sizeZInput.PlaceholderText = "Enter size (64-1024)"
local sizeZCorner = Instance.new("UICorner")
sizeZCorner.CornerRadius = Responsive.getCornerRadius("small")
sizeZCorner.Parent = sizeZInput

-- Add validation stroke
local sizeZStroke = Instance.new("UIStroke")
sizeZStroke.Color = Theme.BorderColor
sizeZStroke.Thickness = 1
sizeZStroke.Transparency = 0.6
sizeZStroke.Parent = sizeZInput

-- Add validation to sizeZInput
sizeZInput.FocusLost:Connect(function()
	local num = tonumber(sizeZInput.Text)
	if num then
		if num >= 64 and num <= 1024 then
			-- Valid input - success state
			tweenService:Create(sizeZStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
				Color = Theme.Success,
				Transparency = 0.3
			}):Play()
		else
			-- Invalid range - error state
			tweenService:Create(sizeZStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
				Color = Theme.Danger,
				Transparency = 0.3
			}):Play()
		end
	else
		-- Invalid input - error state
		tweenService:Create(sizeZStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
			Color = Theme.Danger,
			Transparency = 0.3
		}):Play()
	end

	-- Reset after delay
	wait(2)
	tweenService:Create(sizeZStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
		Color = Theme.BorderColor,
		Transparency = 0.6
	}):Play()
end)

-- Hover effects for sizeZInput
sizeZInput.MouseEnter:Connect(function()
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Scale up slightly
	tweenService:Create(sizeZInput, tweenInfo, { 
		Size = UDim2.new(1, 4, 0, Responsive.getSizes().inputHeight + 2),
		Position = UDim2.new(0, -2, 0, -1)
	}):Play()

	-- Brighten stroke
	tweenService:Create(sizeZStroke, tweenInfo, { 
		Color = Theme.BorderHighlight,
		Transparency = 0.3
	}):Play()

	-- Brighten background
	tweenService:Create(sizeZInput, tweenInfo, { 
		BackgroundColor3 = Theme.InputHover
	}):Play()
end)

sizeZInput.MouseLeave:Connect(function()
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Reset scale
	tweenService:Create(sizeZInput, tweenInfo, { 
		Size = UDim2.new(1, 0, 0, Responsive.getSizes().inputHeight),
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()

	-- Reset stroke
	tweenService:Create(sizeZStroke, tweenInfo, { 
		Color = Theme.BorderColor,
		Transparency = 0.6
	}):Play()

	-- Reset background
	tweenService:Create(sizeZInput, tweenInfo, { 
		BackgroundColor3 = Theme.InputBackground
	}):Play()
end)

local seedLabel = Instance.new("TextLabel")
seedLabel.Text = "Seed:"
seedLabel.TextColor3 = Theme.Text
seedLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().labelHeight)
seedLabel.Font = Theme.Font
seedLabel.TextSize = Responsive.getSizes().bodyFontSize
seedLabel.LayoutOrder = 5
seedLabel.Parent = worldSettingsCard

seedInput = Instance.new("TextBox")
seedInput.Size = UDim2.new(1, 0, 0, Responsive.getSizes().inputHeight)
seedInput.Text = "0"
seedInput.BackgroundColor3 = Theme.InputBackground
seedInput.TextColor3 = Theme.Text
seedInput.Font = Theme.Font
seedInput.TextSize = Responsive.getSizes().bodyFontSize
seedInput.LayoutOrder = 6
seedInput.Parent = worldSettingsCard
seedInput.PlaceholderText = "Enter seed number"
local seedCorner = Instance.new("UICorner")
seedCorner.CornerRadius = Responsive.getCornerRadius("small")
seedCorner.Parent = seedInput

-- Add validation stroke
local seedStroke = Instance.new("UIStroke")
seedStroke.Color = Theme.BorderColor
seedStroke.Thickness = 1
seedStroke.Transparency = 0.6
seedStroke.Parent = seedInput

-- Add validation to seedInput
seedInput.FocusLost:Connect(function()
	local num = tonumber(seedInput.Text)
	if num then
		-- Valid input - success state
		tweenService:Create(seedStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
			Color = Theme.Success,
			Transparency = 0.3
		}):Play()
	else
		-- Invalid input - error state
		tweenService:Create(seedStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
			Color = Theme.Danger,
			Transparency = 0.3
		}):Play()
	end

	-- Reset after delay
	wait(2)
	tweenService:Create(seedStroke, TweenInfo.new(Theme.HoverAnimationSpeed), {
		Color = Theme.BorderColor,
		Transparency = 0.6
	}):Play()
end)

-- Hover effects for seedInput
seedInput.MouseEnter:Connect(function()
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Scale up slightly
	tweenService:Create(seedInput, tweenInfo, { 
		Size = UDim2.new(1, 4, 0, Responsive.getSizes().inputHeight + 2),
		Position = UDim2.new(0, -2, 0, -1)
	}):Play()

	-- Brighten stroke
	tweenService:Create(seedStroke, tweenInfo, { 
		Color = Theme.BorderHighlight,
		Transparency = 0.3
	}):Play()

	-- Brighten background
	tweenService:Create(seedInput, tweenInfo, { 
		BackgroundColor3 = Theme.InputHover
	}):Play()
end)

seedInput.MouseLeave:Connect(function()
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(Theme.HoverAnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Reset scale
	tweenService:Create(seedInput, tweenInfo, { 
		Size = UDim2.new(1, 0, 0, Responsive.getSizes().inputHeight),
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()

	-- Reset stroke
	tweenService:Create(seedStroke, tweenInfo, { 
		Color = Theme.BorderColor,
		Transparency = 0.6
	}):Play()

	-- Reset background
	tweenService:Create(seedInput, tweenInfo, { 
		BackgroundColor3 = Theme.InputBackground
	}):Play()
end)

-- Algorithm Settings Card
local algorithmCard = createCard(globalSettingsContent, "Algorithm Settings", 3)

local noiseAlgorithmLabel = Instance.new("TextLabel")
noiseAlgorithmLabel.Text = "Noise Algorithm:"
noiseAlgorithmLabel.TextColor3 = Theme.Text
noiseAlgorithmLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().labelHeight)
noiseAlgorithmLabel.Font = Theme.Font
noiseAlgorithmLabel.TextSize = Responsive.getSizes().bodyFontSize
noiseAlgorithmLabel.LayoutOrder = 1
noiseAlgorithmLabel.Parent = algorithmCard

local getNoiseAlgorithm, setNoiseAlgorithm = createSegmentedControl(algorithmCard, {"Default (Roblox)", "Custom Perlin"})

-- Modern action buttons using createModernButton
local generateButton = createModernButton(actionBarFrame, "GENERATE", "success", 1)
generateButton.Size = UDim2.new(0.6, -5, 1, 0)

local deleteButton = createModernButton(actionBarFrame, "Delete", "danger", 2)
deleteButton.Size = UDim2.new(0.4, 0, 1, 0)

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

-- Add UI elements for the Landforms tab with consistent card-based layout
local baseShapeCard = createCard(landformsContent, "Base Shape", 1)
local baseTypeLabel = Instance.new("TextLabel")
baseTypeLabel.Text = "Base Type:"
baseTypeLabel.TextColor3 = Theme.Text
baseTypeLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().labelHeight)
baseTypeLabel.Font = Theme.Font
baseTypeLabel.TextSize = Responsive.getSizes().bodyFontSize
baseTypeLabel.Parent = baseShapeCard
local getBaseType, setBaseType = createSegmentedControl(baseShapeCard, {"Hills", "Mountains", "Plains", "Islands", "Canyons", "Volcanoes"})
local getIntensity, setIntensity = createModernSlider(baseShapeCard, "Intensity", 10, 200, 50)
local getFrequency, setFrequency = createModernSlider(baseShapeCard, "Frequency", 1, 20, 5)

local landformModifiersCard = createCard(landformsContent, "Landform Modifiers", 2)
local getEnableErosion, setEnableErosion = createCheckbox(landformModifiersCard, "Enable Hydraulic Erosion", false)
local getErosionIterations, setErosionIterations = createModernSlider(landformModifiersCard, "Erosion Iterations", 1000, 50000, 10000)
local getEnableCaves, setEnableCaves = createCheckbox(landformModifiersCard, "Enable Caves", false)
local getCaveDensity, setCaveDensity = createModernSlider(landformModifiersCard, "Cave Density", 1, 10, 5)
local getCaveScale, setCaveScale = createModernSlider(landformModifiersCard, "Cave Scale", 1, 10, 5)
local getEnableTerracing, setEnableTerracing = createCheckbox(landformModifiersCard, "Enable Terracing", false)
local getTerraceHeight, setTerraceHeight = createModernSlider(landformModifiersCard, "Terrace Height", 2, 20, 8)

-- Add UI elements for the Hydrology tab with consistent card-based layout
local waterLevelCard = createCard(hydrologyContent, "Water Level", 1)
local getSeaLevel, setSeaLevel = createModernSlider(waterLevelCard, "Sea Level", 0, 100, 0)

local waterFeaturesCard = createCard(hydrologyContent, "Water Features", 2)
local getEnableLakes, setEnableLakes = createCheckbox(waterFeaturesCard, "Enable Lake Generation", true)
local getEnableWaterfalls, setEnableWaterfalls = createCheckbox(waterFeaturesCard, "Enable Waterfalls", true)

local riverGenerationCard = createCard(hydrologyContent, "River Generation", 3)
local getShouldCreateRivers, setShouldCreateRivers = createCheckbox(riverGenerationCard, "Create Rivers", false)
local getRiverCount, setRiverCount = createModernSlider(riverGenerationCard, "River Count", 1, 10, 3)
local getRiverDepth, setRiverDepth = createModernSlider(riverGenerationCard, "River Depth", 1, 20, 5)

-- Add UI elements for the Biomes & Vegetation tab with consistent card-based layout
local materialPaintingCard = createCard(biomesContent, "Material Painting", 1)
local getAutoPaint, setAutoPaint = createCheckbox(materialPaintingCard, "Auto Paint Materials", true)
local getShouldBlendBiomes, setShouldBlendBiomes = createCheckbox(materialPaintingCard, "Smooth Biome Borders", true)
local getBiomeBlendIntensity, setBiomeBlendIntensity = createModernSlider(materialPaintingCard, "Blend Intensity", 0, 1, 0.5)

local biomePresetControlsContainer = Instance.new("Frame")
biomePresetControlsContainer.Size = UDim2.new(1, 0, 0, Responsive.getSizes().biomePresetControlsHeight) -- Start with a decent height
biomePresetControlsContainer.BackgroundTransparency = 1
biomePresetControlsContainer.Parent = biomesContent
local biomeControlsLayout = Instance.new("UIListLayout")
biomeControlsLayout.Padding = UDim.new(0, Responsive.getSizes().layoutPadding)
biomeControlsLayout.Parent = biomePresetControlsContainer

local biomePresetLabel = Instance.new("TextLabel")
biomePresetLabel.Text = "Biome Preset:"
biomePresetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
biomePresetLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().labelHeight)
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
dynamicControlsLayout.Padding = UDim.new(0, Responsive.getSizes().layoutPadding)
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
		ruleLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().labelHeight)
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
assetFolderLabel.Size = UDim2.new(1, 0, 0, Responsive.getSizes().labelHeight)
assetFolderLabel.Text = "Asset Folder (in ReplicatedStorage):"
assetFolderLabel.Font = Enum.Font.SourceSans
assetFolderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
assetFolderLabel.TextXAlignment = Enum.TextXAlignment.Left
assetFolderLabel.Parent = biomesContent

assetFolderInput = Instance.new("TextBox")
assetFolderInput.Size = UDim2.new(1, 0, 0, Responsive.getSizes().inputHeight)
assetFolderInput.Text = "GeoCraftAssets"
assetFolderInput.Parent = biomesContent

local getForestDensity, setForestDensity = createSlider(biomesContent, "Forest Density", 0, 1, 0.5)

-- Add UI elements for the Sculpt tab
local activateSculptButton = Instance.new("TextButton")
activateSculptButton.Size = UDim2.new(1, 0, 0, Responsive.getSizes().buttonHeight)
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

-- Connect the generate button to the heightmap generation logic with loading animations
generateButton.MouseButton1Click:Connect(function()
	-- Show loading state on button
	local originalText = generateButton.Text
	local originalColor = generateButton.BackgroundColor3

	generateButton.Text = "Generating..."
	generateButton.BackgroundColor3 = Theme.Warning
	generateButton.AutoButtonColor = false
	generateButton.Active = false

	-- Add loading spinner to button
	local spinnerShow, spinnerHide = createLoadingSpinner(generateButton, 16)
	spinnerShow()

	-- Wrap generation in pcall for error handling
	local success, errorMsg = pcall(function()
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

	-- Handle success/error and reset button state
	if success then
		generateButton.BackgroundColor3 = Theme.Success or Color3.fromRGB(0, 200, 0)
		generateButton.Text = "Complete!"
		wait(1)
	else
		warn("Generation failed: " .. tostring(errorMsg))
		generateButton.BackgroundColor3 = Theme.Error or Color3.fromRGB(200, 0, 0)
		generateButton.Text = "Failed!"
		wait(2)
	end

	-- Reset button state
	spinnerHide()
	generateButton.Text = originalText
	generateButton.BackgroundColor3 = originalColor
	generateButton.AutoButtonColor = true
	generateButton.Active = true
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
