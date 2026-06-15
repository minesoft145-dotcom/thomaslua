-- thomaslua Cheat Menu
-- iOS 26 Liquid Glass UI Style
-- Toggle: Right Shift

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ===========================================
-- CHEAT VARIABLES
-- ===========================================

local InfiniteJumpEnabled = false
local InfiniteJumpCooldown = 0.3  -- Безопасное значение по умолчанию (0.3 секунды между прыжками)
local LastJumpTime = 0
local ESPEnabled = false
local ChamsEnabled = false
local SpeedEnabled = false
local ChatSpamEnabled = false
local JumpCircleEnabled = false
local ChinaHatEnabled = false
local FakePlayerEnabled = false
local AntiRagdollEnabled = false
local ESPHighlights = {}
local ChamsFolder = nil
local JumpCircles = {}
local ChinaHats = {}
local FakePlayer = nil
local DefaultWalkSpeed = 16
local SpeedMultiplier = 2


-- ESP/Chams Colors
local ESPColor = Color3.fromRGB(255, 0, 0)
local ChamsColor = Color3.fromRGB(255, 0, 255)
local JumpCircleColor = Color3.fromRGB(0, 255, 255)
local ChinaHatColor = Color3.fromRGB(255, 255, 0)

-- Color Picker State
local ActiveColorPicker = nil

-- Создаем главный GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThomasLuaCheat"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Проверяем, где можем разместить GUI
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- Переменная для отслеживания состояния меню
local menuOpen = false

-- ===========================================
-- WATERMARK (Left Top Corner)
-- ===========================================

local WatermarkFrame = Instance.new("Frame")
WatermarkFrame.Name = "Watermark"
WatermarkFrame.Size = UDim2.new(0, 180, 0, 45)
WatermarkFrame.Position = UDim2.new(0, 20, 0, 20)
WatermarkFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
WatermarkFrame.BackgroundTransparency = 0.15
WatermarkFrame.BorderSizePixel = 0
WatermarkFrame.Parent = ScreenGui

local WatermarkGlass = Instance.new("Frame")
WatermarkGlass.Size = UDim2.new(1, 0, 1, 0)
WatermarkGlass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WatermarkGlass.BackgroundTransparency = 0.92
WatermarkGlass.BorderSizePixel = 0
WatermarkGlass.Parent = WatermarkFrame

local WatermarkCorner = Instance.new("UICorner")
WatermarkCorner.CornerRadius = UDim.new(0, 12)
WatermarkCorner.Parent = WatermarkFrame

local WatermarkGlassCorner = Instance.new("UICorner")
WatermarkGlassCorner.CornerRadius = UDim.new(0, 12)
WatermarkGlassCorner.Parent = WatermarkGlass

local WatermarkGradient = Instance.new("UIGradient")
WatermarkGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 180, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 200))
}
WatermarkGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.85),
    NumberSequenceKeypoint.new(0.5, 0.9),
    NumberSequenceKeypoint.new(1, 0.85)
}
WatermarkGradient.Rotation = 45
WatermarkGradient.Parent = WatermarkGlass

local WatermarkGlow = Instance.new("Frame")
WatermarkGlow.Size = UDim2.new(1, -4, 1, -4)
WatermarkGlow.Position = UDim2.new(0, 2, 0, 2)
WatermarkGlow.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
WatermarkGlow.BackgroundTransparency = 0.95
WatermarkGlow.BorderSizePixel = 0
WatermarkGlow.Parent = WatermarkFrame

local WatermarkGlowCorner = Instance.new("UICorner")
WatermarkGlowCorner.CornerRadius = UDim.new(0, 10)
WatermarkGlowCorner.Parent = WatermarkGlow

local WatermarkText = Instance.new("TextLabel")
WatermarkText.Size = UDim2.new(1, -20, 1, 0)
WatermarkText.Position = UDim2.new(0, 10, 0, 0)
WatermarkText.BackgroundTransparency = 1
WatermarkText.Font = Enum.Font.GothamBold
WatermarkText.Text = "thomaslua"
WatermarkText.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkText.TextSize = 18
WatermarkText.TextXAlignment = Enum.TextXAlignment.Left
WatermarkText.TextStrokeTransparency = 0.8
WatermarkText.Parent = WatermarkFrame

spawn(function()
    while task.wait(0.1) do
        if WatermarkGradient and WatermarkGradient.Parent then
            WatermarkGradient.Rotation = WatermarkGradient.Rotation + 1
        else
            break
        end
    end
end)

-- ===========================================
-- MAIN MENU (Liquid Glass Design)
-- ===========================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 640)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -320)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 24)
MainCorner.Parent = MainFrame

local GlassLayer1 = Instance.new("Frame")
GlassLayer1.Size = UDim2.new(1, 0, 1, 0)
GlassLayer1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlassLayer1.BackgroundTransparency = 0.88
GlassLayer1.BorderSizePixel = 0
GlassLayer1.Parent = MainFrame

local GlassCorner1 = Instance.new("UICorner")
GlassCorner1.CornerRadius = UDim.new(0, 24)
GlassCorner1.Parent = GlassLayer1

local GlassLayer2 = Instance.new("Frame")
GlassLayer2.Size = UDim2.new(1, -2, 1, -2)
GlassLayer2.Position = UDim2.new(0, 1, 0, 1)
GlassLayer2.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
GlassLayer2.BackgroundTransparency = 0.93
GlassLayer2.BorderSizePixel = 0
GlassLayer2.Parent = MainFrame

local GlassCorner2 = Instance.new("UICorner")
GlassCorner2.CornerRadius = UDim.new(0, 23)
GlassCorner2.Parent = GlassLayer2

local AnimatedGradient = Instance.new("Frame")
AnimatedGradient.Size = UDim2.new(1, 0, 1, 0)
AnimatedGradient.BackgroundTransparency = 1
AnimatedGradient.BorderSizePixel = 0
AnimatedGradient.Parent = GlassLayer1

local GradientUI = Instance.new("UIGradient")
GradientUI.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 150, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 180))
}
GradientUI.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.88),
    NumberSequenceKeypoint.new(0.5, 0.93),
    NumberSequenceKeypoint.new(1, 0.88)
}
GradientUI.Rotation = 0
GradientUI.Parent = AnimatedGradient

spawn(function()
    while task.wait(0.1) do
        if GradientUI and GradientUI.Parent then
            GradientUI.Rotation = GradientUI.Rotation + 2
        else
            break
        end
    end
end)

-- ===========================================
-- HEADER BAR
-- ===========================================

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Header.BackgroundTransparency = 0.4
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 24)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "thomaslua"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0.7
Title.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 38, 0, 38)
CloseButton.Position = UDim2.new(1, -48, 0, 8.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.BackgroundTransparency = 0.25
CloseButton.BorderSizePixel = 0
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.AutoButtonColor = false
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- ===========================================
-- CONTENT AREA
-- ===========================================

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -30, 1, -85)
ContentFrame.Position = UDim2.new(0, 15, 0, 65)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local FunctionsContainer = Instance.new("ScrollingFrame")
FunctionsContainer.Size = UDim2.new(1, 0, 1, 0)
FunctionsContainer.BackgroundTransparency = 1
FunctionsContainer.BorderSizePixel = 0
FunctionsContainer.ScrollBarThickness = 4
FunctionsContainer.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 255)
FunctionsContainer.ScrollBarImageTransparency = 0.5
FunctionsContainer.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = FunctionsContainer

-- Function to create cheat toggle
local function createCheatToggle(name, description)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -8, 0, 65)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    ToggleFrame.BackgroundTransparency = 0.35
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = FunctionsContainer
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 16)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleGlass = Instance.new("Frame")
    ToggleGlass.Size = UDim2.new(1, 0, 1, 0)
    ToggleGlass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleGlass.BackgroundTransparency = 0.92
    ToggleGlass.BorderSizePixel = 0
    ToggleGlass.Parent = ToggleFrame
    
    local ToggleGlassCorner = Instance.new("UICorner")
    ToggleGlassCorner.CornerRadius = UDim.new(0, 16)
    ToggleGlassCorner.Parent = ToggleGlass
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -80, 0, 25)
    NameLabel.Position = UDim2.new(0, 15, 0, 8)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Text = name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextSize = 15
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = ToggleFrame
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -80, 0, 20)
    DescLabel.Position = UDim2.new(0, 15, 0, 33)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = description
    DescLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    DescLabel.TextSize = 12
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextTransparency = 0.3
    DescLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 50, 0, 28)
    ToggleButton.Position = UDim2.new(1, -60, 0.5, -14)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ToggleButton.BackgroundTransparency = 0.3
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleButton
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0, 24, 0, 24)
    ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleButton
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = ToggleIndicator
    
    return ToggleFrame
end

-- Function to create color picker button
local function createColorPicker(parent, yOffset, defaultColor, callback)
    local ColorButton = Instance.new("TextButton")
    ColorButton.Size = UDim2.new(0, 30, 0, 20)
    ColorButton.Position = UDim2.new(1, -95, 0, yOffset)
    ColorButton.BackgroundColor3 = defaultColor
    ColorButton.BorderSizePixel = 0
    ColorButton.Text = ""
    ColorButton.Parent = parent
    
    local ColorCorner = Instance.new("UICorner")
    ColorCorner.CornerRadius = UDim.new(0, 6)
    ColorCorner.Parent = ColorButton
    
    -- RGB Color Picker Menu (рендерится в ScreenGui чтобы быть поверх всего)
    local ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Name = "ColorPickerFrame"
    ColorPickerFrame.Size = UDim2.new(0, 200, 0, 150)
    ColorPickerFrame.Position = UDim2.new(0, 0, 0, 0)
    ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    ColorPickerFrame.BackgroundTransparency = 0.1
    ColorPickerFrame.BorderSizePixel = 0
    ColorPickerFrame.Visible = false
    ColorPickerFrame.ZIndex = 1000  -- Очень высокий ZIndex чтобы быть поверх всего
    ColorPickerFrame.Parent = ScreenGui  -- Рендерим в ScreenGui, не в ColorButton
    
    local PickerCorner = Instance.new("UICorner")
    PickerCorner.CornerRadius = UDim.new(0, 12)
    PickerCorner.Parent = ColorPickerFrame
    
    -- Glass effect
    local PickerGlass = Instance.new("Frame")
    PickerGlass.Size = UDim2.new(1, 0, 1, 0)
    PickerGlass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PickerGlass.BackgroundTransparency = 0.9
    PickerGlass.BorderSizePixel = 0
    PickerGlass.ZIndex = 1001
    PickerGlass.Parent = ColorPickerFrame
    
    local PickerGlassCorner = Instance.new("UICorner")
    PickerGlassCorner.CornerRadius = UDim.new(0, 12)
    PickerGlassCorner.Parent = PickerGlass
    
    local currentR = defaultColor.R * 255
    local currentG = defaultColor.G * 255
    local currentB = defaultColor.B * 255
    
    -- Function to create slider
    local function createSlider(name, yPos, color, defaultValue)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 30, 0, 20)
        label.Position = UDim2.new(0, 10, 0, yPos)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = name
        label.TextColor3 = color
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 1002
        label.Parent = ColorPickerFrame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(0, 110, 0, 6)
        sliderBg.Position = UDim2.new(0, 45, 0, yPos + 7)
        sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        sliderBg.BorderSizePixel = 0
        sliderBg.ZIndex = 1002
        sliderBg.Parent = ColorPickerFrame
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(1, 0)
        sliderCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(defaultValue / 255, 0, 1, 0)
        sliderFill.BackgroundColor3 = color
        sliderFill.BorderSizePixel = 0
        sliderFill.ZIndex = 1003
        sliderFill.Parent = sliderBg
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = sliderFill
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 35, 0, 20)
        valueLabel.Position = UDim2.new(0, 160, 0, yPos)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.Text = tostring(math.floor(defaultValue))
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.TextSize = 12
        valueLabel.ZIndex = 1002
        valueLabel.Parent = ColorPickerFrame
        
        local dragging = false
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = input.Position.X
                local sliderPos = sliderBg.AbsolutePosition.X
                local sliderSize = sliderBg.AbsoluteSize.X
                local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
                
                sliderFill.Size = UDim2.new(value, 0, 1, 0)
                local numValue = math.floor(value * 255)
                valueLabel.Text = tostring(numValue)
                
                if name == "R" then currentR = numValue
                elseif name == "G" then currentG = numValue
                elseif name == "B" then currentB = numValue
                end
                
                local newColor = Color3.fromRGB(currentR, currentG, currentB)
                ColorButton.BackgroundColor3 = newColor
                callback(newColor)
            end
        end)
        
        return {slider = sliderFill, label = valueLabel}
    end
    
    createSlider("R", 15, Color3.fromRGB(255, 80, 80), currentR)
    createSlider("G", 50, Color3.fromRGB(80, 255, 80), currentG)
    createSlider("B", 85, Color3.fromRGB(80, 80, 255), currentB)
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 180, 0, 30)
    closeBtn.Position = UDim2.new(0, 10, 0, 115)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "Close"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.ZIndex = 1002
    closeBtn.Parent = ColorPickerFrame
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        ColorPickerFrame.Visible = false
        ActiveColorPicker = nil
    end)
    
    -- Функция для определения лучшей позиции (чтобы не выходить за экран)
    local function updatePickerPosition()
        local buttonPos = ColorButton.AbsolutePosition
        local buttonSize = ColorButton.AbsoluteSize
        local pickerSize = ColorPickerFrame.AbsoluteSize
        local screenSize = ColorButton.AbsoluteSize -- workspace.CurrentCamera.ViewportSize
        
        -- Позиция справа от кнопки
        local posX = buttonPos.X + buttonSize.X + 10
        local posY = buttonPos.Y
        
        -- Проверяем выход за правый край экрана
        if posX + pickerSize.X > workspace.CurrentCamera.ViewportSize.X then
            -- Показываем слева от кнопки
            posX = buttonPos.X - pickerSize.X - 10
        end
        
        -- Проверяем выход за нижний край экрана
        if posY + pickerSize.Y > workspace.CurrentCamera.ViewportSize.Y then
            -- Сдвигаем вверх
            posY = workspace.CurrentCamera.ViewportSize.Y - pickerSize.Y - 10
        end
        
        -- Проверяем выход за верхний край
        if posY < 0 then
            posY = 10
        end
        
        -- Проверяем выход за левый край
        if posX < 0 then
            posX = 10
        end
        
        ColorPickerFrame.Position = UDim2.new(0, posX, 0, posY)
    end
    
    ColorButton.MouseButton1Click:Connect(function()
        if ActiveColorPicker and ActiveColorPicker ~= ColorPickerFrame then
            ActiveColorPicker.Visible = false
        end
        
        ColorPickerFrame.Visible = not ColorPickerFrame.Visible
        
        if ColorPickerFrame.Visible then
            updatePickerPosition()  -- Обновляем позицию при открытии
        end
        
        ActiveColorPicker = ColorPickerFrame.Visible and ColorPickerFrame or nil
    end)

    
    return ColorButton
end

-- ===========================================
-- INFINITE JUMP (with cooldown settings)
-- ===========================================
local InfiniteJumpToggle = createCheatToggle("Infinite Jump", "Jump infinitely (CD: 0.3s)")
local InfJumpButton = InfiniteJumpToggle:FindFirstChild("ToggleButton")
local InfJumpDesc = InfiniteJumpToggle:FindFirstChildOfClass("TextLabel")

-- Cooldown buttons
local CDDecreaseBtn = Instance.new("TextButton")
CDDecreaseBtn.Size = UDim2.new(0, 25, 0, 20)
CDDecreaseBtn.Position = UDim2.new(1, -120, 0, 22)
CDDecreaseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
CDDecreaseBtn.Text = "-"
CDDecreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CDDecreaseBtn.Font = Enum.Font.GothamBold
CDDecreaseBtn.TextSize = 16
CDDecreaseBtn.Parent = InfiniteJumpToggle

local CDIncreaseBtn = Instance.new("TextButton")
CDIncreaseBtn.Size = UDim2.new(0, 25, 0, 20)
CDIncreaseBtn.Position = UDim2.new(1, -90, 0, 22)
CDIncreaseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
CDIncreaseBtn.Text = "+"
CDIncreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CDIncreaseBtn.Font = Enum.Font.GothamBold
CDIncreaseBtn.TextSize = 16
CDIncreaseBtn.Parent = InfiniteJumpToggle

for _, btn in pairs({CDDecreaseBtn, CDIncreaseBtn}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
end

CDDecreaseBtn.MouseButton1Click:Connect(function()
    InfiniteJumpCooldown = math.max(0.1, InfiniteJumpCooldown - 0.1)
    InfiniteJumpToggle:FindFirstChild("TextLabel", true).Text = string.format("Jump infinitely (CD: %.1fs)", InfiniteJumpCooldown)
end)

CDIncreaseBtn.MouseButton1Click:Connect(function()
    InfiniteJumpCooldown = math.min(2, InfiniteJumpCooldown + 0.1)
    InfiniteJumpToggle:FindFirstChild("TextLabel", true).Text = string.format("Jump infinitely (CD: %.1fs)", InfiniteJumpCooldown)
end)

InfJumpButton.MouseButton1Click:Connect(function()
    InfiniteJumpEnabled = not InfiniteJumpEnabled
    
    local indicator = InfJumpButton:FindFirstChildOfClass("Frame")
    
    if InfiniteJumpEnabled then
        TweenService:Create(InfJumpButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(80, 150, 255)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -26, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    else
        TweenService:Create(InfJumpButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        }):Play()
    end
end)

-- Более безопасная реализация инфинити джампа (обходит античит)
local function SafeInfiniteJump()
    if not InfiniteJumpEnabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Проверяем кулдаун
    local currentTime = tick()
    if currentTime - LastJumpTime < InfiniteJumpCooldown then
        return
    end
    
    -- Более безопасный метод: используем AssemblyLinearVelocity вместо ChangeState
    -- Это выглядит как естественный прыжок для античита
    local success = pcall(function()
        -- Проверяем что персонаж не на земле (чтобы не спамить прыжки)
        local isInAir = humanoid:GetState() == Enum.HumanoidStateType.Freefall or 
                        humanoid:GetState() == Enum.HumanoidStateType.Flying
        
        if isInAir then
            -- Применяем физический импульс вверх (более естественно для античита)
            local currentVelocity = rootPart.AssemblyLinearVelocity
            local jumpPower = humanoid.JumpPower or 50
            
            -- Используем полную силу прыжка
            rootPart.AssemblyLinearVelocity = Vector3.new(
                currentVelocity.X,
                jumpPower,
                currentVelocity.Z
            )
            
            LastJumpTime = currentTime
        else
            -- Если на земле, используем обычный прыжок
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            LastJumpTime = currentTime
        end
    end)
    
    if not success then
        -- Fallback на старый метод если новый не работает
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        LastJumpTime = currentTime
    end
end

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character then
        SafeInfiniteJump()
    end
end)

-- ===========================================
-- ESP (Highlight Outline)
-- ===========================================
local ESPToggle = createCheatToggle("ESP Players", "See player outlines through walls")
local ESPButton = ESPToggle:FindFirstChild("ToggleButton")

-- Color picker for ESP
createColorPicker(ESPToggle, 22, ESPColor, function(newColor)
    ESPColor = newColor
    -- Update existing highlights
    for _, highlight in pairs(ESPHighlights) do
        if highlight and highlight.Parent then
            highlight.OutlineColor = newColor
        end
    end
end)

local function createESPHighlight(player)
    if player == LocalPlayer then return end
    
    local function addHighlight(character)
        if ESPHighlights[player.Name] then
            ESPHighlights[player.Name]:Destroy()
        end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_" .. player.Name
        highlight.Adornee = character
        highlight.FillColor = ESPColor
        highlight.FillTransparency = 1  -- Полностью прозрачная заливка (только контур)
        highlight.OutlineColor = ESPColor
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        
        ESPHighlights[player.Name] = highlight
    end
    
    if player.Character then
        addHighlight(player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        if ESPEnabled then
            wait(0.1)
            addHighlight(character)
        end
    end)
end

local function removeESPHighlight(player)
    if ESPHighlights[player.Name] then
        ESPHighlights[player.Name]:Destroy()
        ESPHighlights[player.Name] = nil
    end
end

ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    
    local indicator = ESPButton:FindFirstChildOfClass("Frame")
    
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            createESPHighlight(player)
        end
        
        Players.PlayerAdded:Connect(function(player)
            if ESPEnabled then
                createESPHighlight(player)
            end
        end)
        
        TweenService:Create(ESPButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(80, 150, 255)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -26, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    else
        for _, player in pairs(Players:GetPlayers()) do
            removeESPHighlight(player)
        end
        
        TweenService:Create(ESPButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        }):Play()
    end
end)

-- ===========================================
-- CHAMS (Proper Player Outline)
-- ===========================================
local ChamsToggle = createCheatToggle("Chams", "See players with colored overlay")
local ChamsButton = ChamsToggle:FindFirstChild("ToggleButton")

-- Color picker for Chams
createColorPicker(ChamsToggle, 22, ChamsColor, function(newColor)
    ChamsColor = newColor
    -- Update existing chams
    if ChamsFolder then
        for _, cham in pairs(ChamsFolder:GetChildren()) do
            if cham:IsA("BasePart") then
                cham.Color = newColor
            end
        end
    end
end)

local function createChams(player)
    if player == LocalPlayer then return end
    
    local function addChamsToCharacter(character)
        local function applyCham(part)
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local cham = part:Clone()
                cham.Name = player.Name .. "_" .. part.Name .. "_Cham"
                cham.CanCollide = false
                cham.Anchored = false
                cham.Material = Enum.Material.Neon
                cham.Color = ChamsColor
                cham.Transparency = 0.3
                cham.CastShadow = false
                cham.CanQuery = false
                cham.Massless = true
                
                -- Удаляем все дочерние объекты кроме Mesh
                for _, child in pairs(cham:GetChildren()) do
                    if not child:IsA("SpecialMesh") and not child:IsA("Mesh") and not child:IsA("DataModelMesh") then
                        child:Destroy()
                    end
                end
                
                -- Создаем Weld для точной синхронизации
                local weld = Instance.new("Weld")
                weld.Part0 = part
                weld.Part1 = cham
                weld.C0 = CFrame.new()
                weld.C1 = CFrame.new()
                weld.Parent = cham
                
                cham.Parent = ChamsFolder
                
                return cham
            end
        end
        
        -- Удаляем старые чамсы если есть
        if ChamsFolder then
            for _, cham in pairs(ChamsFolder:GetChildren()) do
                if cham.Name:find(player.Name) then
                    cham:Destroy()
                end
            end
        end
        
        -- Применяем чамсы только к основным частям тела
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and (
                part.Name == "Head" or 
                part.Name == "Torso" or 
                part.Name == "UpperTorso" or 
                part.Name == "LowerTorso" or
                part.Name == "Left Arm" or 
                part.Name == "Right Arm" or
                part.Name == "LeftUpperArm" or
                part.Name == "RightUpperArm" or
                part.Name == "LeftLowerArm" or
                part.Name == "RightLowerArm" or
                part.Name == "LeftHand" or
                part.Name == "RightHand" or
                part.Name == "Left Leg" or 
                part.Name == "Right Leg" or
                part.Name == "LeftUpperLeg" or
                part.Name == "RightUpperLeg" or
                part.Name == "LeftLowerLeg" or
                part.Name == "RightLowerLeg" or
                part.Name == "LeftFoot" or
                part.Name == "RightFoot"
            ) then
                applyCham(part)
            end
        end
    end
    
    if player.Character then
        addChamsToCharacter(player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        if ChamsEnabled then
            wait(0.1)
            addChamsToCharacter(character)
        end
    end)
end

ChamsButton.MouseButton1Click:Connect(function()
    ChamsEnabled = not ChamsEnabled
    
    local indicator = ChamsButton:FindFirstChildOfClass("Frame")
    
    if ChamsEnabled then
        -- Создаем папку для чамсов
        ChamsFolder = Instance.new("Folder")
        ChamsFolder.Name = "ChamsFolder"
        ChamsFolder.Parent = workspace
        
        for _, player in pairs(Players:GetPlayers()) do
            createChams(player)
        end
        
        Players.PlayerAdded:Connect(function(player)
            if ChamsEnabled then
                createChams(player)
            end
        end)
        
        TweenService:Create(ChamsButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(80, 150, 255)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -26, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    else
        if ChamsFolder then
            ChamsFolder:Destroy()
            ChamsFolder = nil
        end
        
        TweenService:Create(ChamsButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        }):Play()
    end
end)

-- ===========================================
-- SPEED
-- ===========================================
local SpeedToggle = createCheatToggle("Speed Hack", "Run faster (2x speed)")
local SpeedButton = SpeedToggle:FindFirstChild("ToggleButton")

-- Speed multiplier buttons
local SpeedDecreaseBtn = Instance.new("TextButton")
SpeedDecreaseBtn.Size = UDim2.new(0, 25, 0, 20)
SpeedDecreaseBtn.Position = UDim2.new(1, -120, 0, 22)
SpeedDecreaseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
SpeedDecreaseBtn.Text = "-"
SpeedDecreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedDecreaseBtn.Font = Enum.Font.GothamBold
SpeedDecreaseBtn.TextSize = 16
SpeedDecreaseBtn.Parent = SpeedToggle

local SpeedIncreaseBtn = Instance.new("TextButton")
SpeedIncreaseBtn.Size = UDim2.new(0, 25, 0, 20)
SpeedIncreaseBtn.Position = UDim2.new(1, -90, 0, 22)
SpeedIncreaseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
SpeedIncreaseBtn.Text = "+"
SpeedIncreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedIncreaseBtn.Font = Enum.Font.GothamBold
SpeedIncreaseBtn.TextSize = 16
SpeedIncreaseBtn.Parent = SpeedToggle

for _, btn in pairs({SpeedDecreaseBtn, SpeedIncreaseBtn}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
end

SpeedDecreaseBtn.MouseButton1Click:Connect(function()
    SpeedMultiplier = math.max(1, SpeedMultiplier - 0.5)
    SpeedToggle:FindFirstChild("TextLabel", true).Text = string.format("Run faster (%.1fx speed)", SpeedMultiplier)
    
    if SpeedEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = DefaultWalkSpeed * SpeedMultiplier
        end
    end
end)

SpeedIncreaseBtn.MouseButton1Click:Connect(function()
    SpeedMultiplier = math.min(10, SpeedMultiplier + 0.5)
    SpeedToggle:FindFirstChild("TextLabel", true).Text = string.format("Run faster (%.1fx speed)", SpeedMultiplier)
    
    if SpeedEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = DefaultWalkSpeed * SpeedMultiplier
        end
    end
end)

SpeedButton.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    
    local indicator = SpeedButton:FindFirstChildOfClass("Frame")
    
    if SpeedEnabled then
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                DefaultWalkSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = DefaultWalkSpeed * SpeedMultiplier
            end
        end
        
        LocalPlayer.CharacterAdded:Connect(function(character)
            if SpeedEnabled then
                wait(0.1)
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = DefaultWalkSpeed * SpeedMultiplier
                end
            end
        end)
        
        TweenService:Create(SpeedButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(80, 150, 255)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -26, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = DefaultWalkSpeed
            end
        end
        
        TweenService:Create(SpeedButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        }):Play()
    end
end)

-- ===========================================
-- ANTI-RAGDOLL
-- ===========================================
local AntiRagdollToggle = createCheatToggle("Anti-Ragdoll", "Never fall down when hit")
local AntiRagdollButton = AntiRagdollToggle:FindFirstChild("ToggleButton")

local function enableAntiRagdoll(character)
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Предотвращаем все состояния ragdoll
    local connection
    connection = humanoid.StateChanged:Connect(function(oldState, newState)
        if not AntiRagdollEnabled then
            if connection then connection:Disconnect() end
            return
        end
        
        -- Блокируем ragdoll состояния
        if newState == Enum.HumanoidStateType.Ragdoll or 
           newState == Enum.HumanoidStateType.FallingDown or
           newState == Enum.HumanoidStateType.PlatformStanding then
            -- Принудительно возвращаем в нормальное состояние
            task.wait()
            if humanoid and humanoid.Parent then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end)
    
    -- Дополнительная защита через постоянную проверку
    spawn(function()
        while AntiRagdollEnabled and character.Parent and humanoid.Parent do
            task.wait(0.1)
            
            if AntiRagdollEnabled then
                local currentState = humanoid:GetState()
                
                -- Если в ragdoll состоянии - сразу исправляем
                if currentState == Enum.HumanoidStateType.Ragdoll or 
                   currentState == Enum.HumanoidStateType.FallingDown or
                   currentState == Enum.HumanoidStateType.PlatformStanding then
                    pcall(function()
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end)
                end
                
                -- Также убираждаем все BodyGyro, BodyPosition и подобное что может быть добавлено
                for _, obj in pairs(character:GetDescendants()) do
                    if obj:IsA("BodyGyro") or obj:IsA("BodyPosition") or 
                       obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") then
                        pcall(function() obj:Destroy() end)
                    end
                end
            else
                break
            end
        end
    end)
end

AntiRagdollButton.MouseButton1Click:Connect(function()
    AntiRagdollEnabled = not AntiRagdollEnabled
    local indicator = AntiRagdollButton:FindFirstChildOfClass("Frame")
    
    if AntiRagdollEnabled then
        -- Применяем к текущему персонажу
        if LocalPlayer.Character then
            enableAntiRagdoll(LocalPlayer.Character)
        end
        
        -- Применяем к новым персонажам при респавне
        LocalPlayer.CharacterAdded:Connect(function(character)
            if AntiRagdollEnabled then
                task.wait(0.5)
                enableAntiRagdoll(character)
            end
        end)
        
        TweenService:Create(AntiRagdollButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(80, 150, 255)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -26, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    else
        TweenService:Create(AntiRagdollButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        }):Play()
    end
end)

-- ===========================================
-- JUMP CIRCLE
-- ===========================================
local JumpCircleToggle = createCheatToggle("Jump Circle", "Show circle when you jump")
local JumpCircleButton = JumpCircleToggle:FindFirstChild("ToggleButton")

createColorPicker(JumpCircleToggle, 22, JumpCircleColor, function(newColor)
    JumpCircleColor = newColor
end)

local function createJumpCircle(position)
    local circle = Instance.new("Part")
    circle.Name = "JumpCircle"
    circle.Shape = Enum.PartType.Cylinder
    circle.Size = Vector3.new(0.2, 6, 6)
    circle.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
    circle.Anchored = true
    circle.CanCollide = false
    circle.Material = Enum.Material.Neon
    circle.Color = JumpCircleColor
    circle.Transparency = 0
    circle.CastShadow = false
    circle.Parent = workspace
    
    spawn(function()
        local startSize = Vector3.new(0.2, 6, 6)
        local endSize = Vector3.new(0.2, 15, 15)
        local duration = 0.5
        local elapsed = 0
        
        while elapsed < duration do
            elapsed = elapsed + RunService.RenderStepped:Wait()
            local alpha = elapsed / duration
            circle.Size = startSize:Lerp(endSize, alpha)
            circle.Transparency = alpha
        end
        
        circle:Destroy()
    end)
end

JumpCircleButton.MouseButton1Click:Connect(function()
    JumpCircleEnabled = not JumpCircleEnabled
    local indicator = JumpCircleButton:FindFirstChildOfClass("Frame")
    
    if JumpCircleEnabled then
        LocalPlayer.CharacterAdded:Connect(function(character)
            if JumpCircleEnabled then
                local humanoid = character:WaitForChild("Humanoid")
                local rootPart = character:WaitForChild("HumanoidRootPart")
                humanoid.StateChanged:Connect(function(oldState, newState)
                    if JumpCircleEnabled and newState == Enum.HumanoidStateType.Jumping then
                        createJumpCircle(rootPart.Position - Vector3.new(0, 3, 0))
                    end
                end)
            end
        end)
        
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart then
                humanoid.StateChanged:Connect(function(oldState, newState)
                    if JumpCircleEnabled and newState == Enum.HumanoidStateType.Jumping then
                        createJumpCircle(rootPart.Position - Vector3.new(0, 3, 0))
                    end
                end)
            end
        end
        
        TweenService:Create(JumpCircleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(80, 150, 255)}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -26, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        TweenService:Create(JumpCircleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end
end)

-- ===========================================
-- CHINA HAT
-- ===========================================
local ChinaHatToggle = createCheatToggle("China Hat", "Spinning hat above your head")
local ChinaHatButton = ChinaHatToggle:FindFirstChild("ToggleButton")

createColorPicker(ChinaHatToggle, 22, ChinaHatColor, function(newColor)
    ChinaHatColor = newColor
    for _, hat in pairs(ChinaHats) do
        if hat and hat.Parent then hat.Color = newColor end
    end
end)

local function createChinaHat(character)
    local rootPart = character:WaitForChild("HumanoidRootPart")
    for _, hat in pairs(ChinaHats) do
        if hat then hat:Destroy() end
    end
    ChinaHats = {}
    
    local hat = Instance.new("Part")
    hat.Name = "ChinaHat"
    hat.Shape = Enum.PartType.Cylinder
    hat.Size = Vector3.new(0.3, 8, 8)
    hat.Material = Enum.Material.Neon
    hat.Color = ChinaHatColor
    hat.Transparency = 0.2
    hat.CanCollide = false
    hat.CastShadow = false
    hat.Anchored = false
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1778999"
    mesh.Scale = Vector3.new(5, 2, 5)
    mesh.Parent = hat
    
    hat.Parent = character
    
    local weld = Instance.new("Weld")
    weld.Part0 = rootPart
    weld.Part1 = hat
    weld.C0 = CFrame.new(0, 3, 0)
    weld.Parent = hat
    
    table.insert(ChinaHats, hat)
    
    spawn(function()
        while task.wait(0.1) and ChinaHatEnabled and hat.Parent do
            if hat and hat.Parent then
                hat.CFrame = hat.CFrame * CFrame.Angles(0, math.rad(10), 0)
            else
                break
            end
        end
    end)
end

ChinaHatButton.MouseButton1Click:Connect(function()
    ChinaHatEnabled = not ChinaHatEnabled
    local indicator = ChinaHatButton:FindFirstChildOfClass("Frame")
    
    if ChinaHatEnabled then
        if LocalPlayer.Character then createChinaHat(LocalPlayer.Character) end
        LocalPlayer.CharacterAdded:Connect(function(character)
            if ChinaHatEnabled then wait(0.1) createChinaHat(character) end
        end)
        TweenService:Create(ChinaHatButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(80, 150, 255)}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -26, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        for _, hat in pairs(ChinaHats) do if hat then hat:Destroy() end end
        ChinaHats = {}
        TweenService:Create(ChinaHatButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end
end)

-- ===========================================
-- FAKE PLAYER (for testing visuals)
-- ===========================================
local FakePlayerToggle = createCheatToggle("Fake Player", "Spawn fake player to test visuals")
local FakePlayerButton = FakePlayerToggle:FindFirstChild("ToggleButton")

local function createFakePlayer()
    if FakePlayer then
        FakePlayer:Destroy()
    end
    
    -- Создаем модель поддельного игрока
    local model = Instance.new("Model")
    model.Name = "FakePlayer_" .. LocalPlayer.Name
    
    -- Создаем HumanoidRootPart
    local rootPart = Instance.new("Part")
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2, 2, 1)
    rootPart.Transparency = 1
    rootPart.CanCollide = false
    rootPart.Anchored = true
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        rootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(5, 0, 0)
    else
        rootPart.CFrame = CFrame.new(0, 5, 0)
    end
    
    rootPart.Parent = model
    
    -- Клонируем персонажа игрока
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local clone = part:Clone()
                clone.Anchored = true
                clone.CanCollide = false
                
                -- Удаляем скрипты и ненужные объекты
                for _, child in pairs(clone:GetChildren()) do
                    if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("Motor6D") then
                        child:Destroy()
                    end
                end
                
                clone.Parent = model
            elseif part:IsA("Accessory") or part:IsA("Hat") then
                local clone = part:Clone()
                clone.Parent = model
            end
        end
        
        -- Копируем Humanoid
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local fakeHumanoid = Instance.new("Humanoid")
            fakeHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            fakeHumanoid.Parent = model
        end
    end
    
    model.Parent = workspace
    FakePlayer = model
    
    -- Применяем визуалы к фейк игроку
    if ESPEnabled then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_FakePlayer"
        highlight.Adornee = model
        highlight.FillColor = ESPColor
        highlight.FillTransparency = 1
        highlight.OutlineColor = ESPColor
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = model
    end
    
    if ChamsEnabled then
        for _, part in pairs(model:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local cham = part:Clone()
                cham.Name = "Cham_" .. part.Name
                cham.Material = Enum.Material.Neon
                cham.Color = ChamsColor
                cham.Transparency = 0.3
                cham.CanCollide = false
                cham.Anchored = true
                cham.CFrame = part.CFrame
                cham.Parent = ChamsFolder or workspace
            end
        end
    end
    
    if ChinaHatEnabled then
        local hat = Instance.new("Part")
        hat.Name = "ChinaHat"
        hat.Shape = Enum.PartType.Cylinder
        hat.Size = Vector3.new(0.3, 8, 8)
        hat.Material = Enum.Material.Neon
        hat.Color = ChinaHatColor
        hat.Transparency = 0.2
        hat.CanCollide = false
        hat.Anchored = true
        hat.CFrame = rootPart.CFrame * CFrame.new(0, 3, 0)
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://1778999"
        mesh.Scale = Vector3.new(5, 2, 5)
        mesh.Parent = hat
        
        hat.Parent = model
        
        -- Вращение
        spawn(function()
            while FakePlayerEnabled and hat.Parent do
                hat.CFrame = hat.CFrame * CFrame.Angles(0, math.rad(5), 0)
                wait(0.03)
            end
        end)
    end
end

FakePlayerButton.MouseButton1Click:Connect(function()
    FakePlayerEnabled = not FakePlayerEnabled
    local indicator = FakePlayerButton:FindFirstChildOfClass("Frame")
    
    if FakePlayerEnabled then
        createFakePlayer()
        
        TweenService:Create(FakePlayerButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(80, 150, 255)}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -26, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        if FakePlayer then
            FakePlayer:Destroy()
            FakePlayer = nil
        end
        
        TweenService:Create(FakePlayerButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end
end)

-- ===========================================
-- CHAT SPAM
-- ===========================================
local ChatSpamToggle = createCheatToggle("Chat Spam", "Spam 'ThomasLua The Best'")
local ChatSpamButton = ChatSpamToggle:FindFirstChild("ToggleButton")

ChatSpamButton.MouseButton1Click:Connect(function()
    ChatSpamEnabled = not ChatSpamEnabled
    
    local indicator = ChatSpamButton:FindFirstChildOfClass("Frame")
    
    if ChatSpamEnabled then
        spawn(function()
            while ChatSpamEnabled do
                wait(3)
                
                if ChatSpamEnabled then
                    pcall(function()
                        if ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
                            local chatEvent = ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
                            if chatEvent then
                                chatEvent:FireServer("ThomasLua The Best", "All")
                            end
                        end
                        
                        local TextChatService = game:GetService("TextChatService")
                        if TextChatService then
                            local textChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                            if textChannel then
                                textChannel:SendAsync("ThomasLua The Best")
                            end
                        end
                    end)
                end
            end
        end)
        
        TweenService:Create(ChatSpamButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(80, 150, 255)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -26, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    else
        TweenService:Create(ChatSpamButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        }):Play()
    end
end)

-- ===========================================
-- MENU TOGGLE & INTERACTIONS
-- ===========================================

local function toggleMenu()
    menuOpen = not menuOpen
    
    if menuOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainFrame.BackgroundTransparency = 1
        
        TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 480, 0, 640),
            Position = UDim2.new(0.5, -240, 0.5, -320),
            BackgroundTransparency = 0.25
        }):Play()
        
        for _, layer in pairs({GlassLayer1, GlassLayer2}) do
            layer.BackgroundTransparency = 1
            TweenService:Create(layer, TweenInfo.new(0.6), {
                BackgroundTransparency = layer == GlassLayer1 and 0.88 or 0.93
            }):Play()
        end
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        
        for _, layer in pairs({GlassLayer1, GlassLayer2}) do
            TweenService:Create(layer, TweenInfo.new(0.4), {
                BackgroundTransparency = 1
            }):Play()
        end
        
        wait(0.4)
        MainFrame.Visible = false
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightShift then
            toggleMenu()
        end
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 42, 0, 42)
    }):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.25,
        Size = UDim2.new(0, 38, 0, 38)
    }):Play()
end)

local dragging = false
local dragInput, mousePos, framePos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Sine), {
            Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        }):Play()
    end
end)

-- ===========================================
-- LOAD NOTIFICATION
-- ===========================================

local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.new(0, 320, 0, 70)
NotificationFrame.Position = UDim2.new(0.5, -160, 0, -80)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
NotificationFrame.BackgroundTransparency = 0.2
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Parent = ScreenGui

local NotifCorner = Instance.new("UICorner")
NotifCorner.CornerRadius = UDim.new(0, 18)
NotifCorner.Parent = NotificationFrame

local NotifGlass = Instance.new("Frame")
NotifGlass.Size = UDim2.new(1, 0, 1, 0)
NotifGlass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NotifGlass.BackgroundTransparency = 0.9
NotifGlass.BorderSizePixel = 0
NotifGlass.Parent = NotificationFrame

local NotifGlassCorner = Instance.new("UICorner")
NotifGlassCorner.CornerRadius = UDim.new(0, 18)
NotifGlassCorner.Parent = NotifGlass

local NotifText = Instance.new("TextLabel")
NotifText.Size = UDim2.new(1, -30, 1, -20)
NotifText.Position = UDim2.new(0, 15, 0, 10)
NotifText.BackgroundTransparency = 1
NotifText.Font = Enum.Font.GothamBold
NotifText.Text = "thomaslua loaded!\nPress RShift to open menu"
NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotifText.TextSize = 15
NotifText.TextWrapped = true
NotifText.TextStrokeTransparency = 0.8
NotifText.Parent = NotificationFrame

TweenService:Create(NotificationFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
    Position = UDim2.new(0.5, -160, 0, 25)
}):Play()

wait(3.5)

TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Position = UDim2.new(0.5, -160, 0, -80),
    BackgroundTransparency = 1
}):Play()

TweenService:Create(NotifGlass, TweenInfo.new(0.5), {
    BackgroundTransparency = 1
}):Play()

TweenService:Create(NotifText, TweenInfo.new(0.5), {
    TextTransparency = 1
}):Play()

wait(0.5)
NotificationFrame:Destroy()
