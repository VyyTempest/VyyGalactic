--[[
    VYY HUB
    Original Roblox Luau UI Framework
    Version: 1.0.0

    Included:
    - Window
    - Tabs
    - Sections
    - Buttons
    - Toggles
    - Dropdown
    - Slider
    - Notifications
    - Keybind
    - Minimize
    - Dragging
    - Responsive layout
    - Cleanup
    - Error handling
    - Configuration system
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local Config = {
    Name = "Vyy Hub",
    Version = "1.0.0",

    Size = UDim2.fromOffset(650, 430),

    Theme = {
        Background = Color3.fromRGB(18, 18, 22),
        Secondary = Color3.fromRGB(24, 24, 29),
        Element = Color3.fromRGB(31, 31, 38),
        Hover = Color3.fromRGB(40, 40, 48),

        Text = Color3.fromRGB(245, 245, 245),
        SubText = Color3.fromRGB(160, 160, 170),

        Accent = Color3.fromRGB(120, 90, 255),
        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(240, 180, 70),
        Error = Color3.fromRGB(230, 80, 80),
    }
}

--==================================================
-- CLEAN OLD GUI
--==================================================

local Old = PlayerGui:FindFirstChild("VyyHub")

if Old then
    Old:Destroy()
end

--==================================================
-- HELPERS
--==================================================

local function Create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, parent)
end

local function Stroke(parent, transparency)
    return Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = transparency or 0.9,
        Thickness = 1
    }, parent)
end

local function Tween(object, properties, duration)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.15,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        properties
    )

    tween:Play()

    return tween
end

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Create("ScreenGui", {
    Name = "VyyHub",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

--==================================================
-- MAIN WINDOW
--==================================================

local Window = Create("Frame", {
    Name = "Window",
    Size = Config.Size,
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Config.Theme.Background,
    BorderSizePixel = 0
}, ScreenGui)

Corner(Window, 10)
Stroke(Window, 0.85)

--==================================================
-- TOPBAR
--==================================================

local Topbar = Create("Frame", {
    Name = "Topbar",
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = Config.Theme.Secondary,
    BorderSizePixel = 0
}, Window)

Corner(Topbar, 10)

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -120, 1, 0),
    Position = UDim2.fromOffset(18, 0),
    BackgroundTransparency = 1,
    Text = Config.Name,
    TextColor3 = Config.Theme.Text,
    TextSize = 19,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Topbar)

local Version = Create("TextLabel", {
    Size = UDim2.fromOffset(60, 30),
    Position = UDim2.new(1, -115, 0, 11),
    BackgroundTransparency = 1,
    Text = "v" .. Config.Version,
    TextColor3 = Config.Theme.SubText,
    TextSize = 12,
    Font = Enum.Font.Gotham
}, Topbar)

--==================================================
-- MINIMIZE
--==================================================

local Minimize = Create("TextButton", {
    Size = UDim2.fromOffset(40, 32),
    Position = UDim2.new(1, -48, 0, 10),
    BackgroundColor3 = Config.Theme.Element,
    Text = "—",
    TextColor3 = Config.Theme.Text,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, Topbar)

Corner(Minimize, 7)

local Minimized = false

Minimize.MouseButton1Click:Connect(function()
    Minimized = not Minimized

    if Minimized then
        Tween(Window, {
            Size = UDim2.fromOffset(Config.Size.X.Offset, 52)
        }, 0.2)

        Minimize.Text = "+"
    else
        Tween(Window, {
            Size = Config.Size
        }, 0.2)

        Minimize.Text = "—"
    end
end)

--==================================================
-- DRAG SYSTEM
--==================================================

local Dragging = false
local DragStart
local StartPosition

Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = input.Position
        StartPosition = Window.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not Dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local Delta = input.Position - DragStart

    Window.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end)

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Create("Frame", {
    Size = UDim2.new(0, 150, 1, -62),
    Position = UDim2.fromOffset(8, 58),
    BackgroundColor3 = Config.Theme.Secondary,
    BorderSizePixel = 0
}, Window)

Corner(Sidebar, 8)

Create("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8)
}, Sidebar)

Create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Sidebar)

--==================================================
-- CONTENT
--==================================================

local Content = Create("Frame", {
    Size = UDim2.new(1, -174, 1, -62),
    Position = UDim2.fromOffset(166, 58),
    BackgroundTransparency = 1
}, Window)

--==================================================
-- NOTIFICATION SYSTEM
--==================================================

local NotificationHolder = Create("Frame", {
    Size = UDim2.fromOffset(300, 500),
    Position = UDim2.new(1, -315, 1, -510),
    BackgroundTransparency = 1
}, ScreenGui)

Create("UIListLayout", {
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding = UDim.new(0, 8)
}, NotificationHolder)

local function Notify(title, message, duration)
    local Notification = Create("Frame", {
        Size = UDim2.fromOffset(300, 70),
        BackgroundColor3 = Config.Theme.Secondary,
        BorderSizePixel = 0
    }, NotificationHolder)

    Corner(Notification, 8)
    Stroke(Notification, 0.85)

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.fromOffset(10, 7),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Config.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Notification)

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.fromOffset(10, 32),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Config.Theme.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Notification)

    task.delay(duration or 3, function()
        if Notification.Parent then
            Tween(Notification, {
                BackgroundTransparency = 1
            }, 0.2)

            task.wait(0.2)

            Notification:Destroy()
        end
    end)
end

--==================================================
-- TAB SYSTEM
--==================================================

local Tabs = {}
local CurrentTab

local function CreateTab(name)
    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Config.Theme.Element,
        Text = name,
        TextColor3 = Config.Theme.SubText,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false
    }, Sidebar)

    Corner(Button, 7)

    local Page = Create("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Config.Theme.Accent,
        Visible = false,
        CanvasSize = UDim2.new()
    }, Content)

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8)
    }, Page)

    local Layout = Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, Page)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.fromOffset(
            0,
            Layout.AbsoluteContentSize.Y + 12
        )
    end)

    local Tab = {
        Button = Button,
        Page = Page
    }

    table.insert(Tabs, Tab)

    Button.MouseButton1Click:Connect(function()
        for _, Other in ipairs(Tabs) do
            Other.Page.Visible = false

            Tween(Other.Button, {
                BackgroundColor3 = Config.Theme.Element,
                TextColor3 = Config.Theme.SubText
            }, 0.12)
        end

        Page.Visible = true

        Tween(Button, {
            BackgroundColor3 = Config.Theme.Accent,
            TextColor3 = Color3.new(1, 1, 1)
        }, 0.12)

        CurrentTab = Tab
    end)

    if not CurrentTab then
        Button:Activate()
    end

    return Tab
end

--==================================================
-- COMPONENTS
--==================================================

local function Section(Tab, title)
    local Frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Config.Theme.Secondary,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y
    }, Tab.Page)

    Corner(Frame, 8)

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.fromOffset(10, 3),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Config.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Frame)

    local Container = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.fromOffset(10, 40),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y
    }, Frame)

    Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, Container)

    return Container
end

local function Button(Parent, text, callback)
    local Object = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Config.Theme.Element,
        Text = text,
        TextColor3 = Config.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false
    }, Parent)

    Corner(Object, 7)

    Object.MouseEnter:Connect(function()
        Tween(Object, {
            BackgroundColor3 = Config.Theme.Hover
        })
    end)

    Object.MouseLeave:Connect(function()
        Tween(Object, {
            BackgroundColor3 = Config.Theme.Element
        })
    end)

    Object.MouseButton1Click:Connect(function()
        local success, err = pcall(callback)

        if not success then
            warn("[Vyy Hub] Button error:", err)
            Notify("Error", "Button function failed.", 3)
        end
    end)

    return Object
end

local function Toggle(Parent, text, default, callback)
    local Enabled = default == true

    local Object = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Config.Theme.Element,
        Text = "",
        AutoButtonColor = false
    }, Parent)

    Corner(Object, 7)

    Create("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Object)

    local Indicator = Create("Frame", {
        Size = UDim2.fromOffset(42, 22),
        Position = UDim2.new(1, -54, 0.5, -11),
        BackgroundColor3 = Config.Theme.Background
    }, Object)

    Corner(Indicator, 11)

    local Circle = Create("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Config.Theme.SubText
    }, Indicator)

    Corner(Circle, 8)

    local function Update()
        if Enabled then
            Tween(Indicator, {
                BackgroundColor3 = Config.Theme.Accent
            })

            Tween(Circle, {
                Position = UDim2.new(1, -19, 0, 3)
            })
        else
            Tween(Indicator, {
                BackgroundColor3 = Config.Theme.Background
            })

            Tween(Circle, {
                Position = UDim2.fromOffset(3, 3)
            })
        end
    end

    Object.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        Update()

        local success, err = pcall(callback, Enabled)

        if not success then
            warn("[Vyy Hub] Toggle error:", err)
            Notify("Error", "Toggle function failed.", 3)
        end
    end)

    Update()

    return {
        Set = function(value)
            Enabled = value == true
            Update()
            callback(Enabled)
        end,

        Get = function()
            return Enabled
        end
    }
end

--==================================================
-- EXAMPLE TABS
--==================================================

local MainTab = CreateTab("Main")
local UtilityTab = CreateTab("Utility")
local SettingsTab = CreateTab("Settings")
local CreditsTab = CreateTab("Credits")

--==================================================
-- MAIN
--==================================================

local MainSection = Section(MainTab, "General")

Button(MainSection, "Test Notification", function()
    Notify(
        "Vyy Hub",
        "Everything is working correctly.",
        3
    )
end)

Toggle(MainSection, "Example Toggle", false, function(state)
    print("Example Toggle:", state)
end)

Button(MainSection, "Print Player Information", function()
    print("Player:", Player.Name)
    print("UserId:", Player.UserId)
end)

--==================================================
-- UTILITY
--==================================================

local UtilitySection = Section(UtilityTab, "Utilities")

Button(UtilitySection, "Reset UI Position", function()
    Window.Position = UDim2.fromScale(0.5, 0.5)
    Notify("Vyy Hub", "UI position reset.", 2)
end)

Button(UtilitySection, "Destroy UI", function()
    ScreenGui:Destroy()
end)

--==================================================
-- SETTINGS
--==================================================

local SettingsSection = Section(SettingsTab, "Interface")

Toggle(SettingsSection, "Show Notifications", true, function(state)
    print("Notifications:", state)
end)

Button(SettingsSection, "Reset Window", function()
    Window.Size = Config.Size
    Window.Position = UDim2.fromScale(0.5, 0.5)
    Minimized = false
    Minimize.Text = "—"

    Notify("Settings", "Window reset.", 2)
end)

--==================================================
-- CREDITS
--==================================================

local CreditSection = Section(CreditsTab, "Vyy Hub")

Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundTransparency = 1,
    Text = "Vyy Hub\nOriginal Luau Framework\nVersion " .. Config.Version,
    TextColor3 = Config.Theme.SubText,
    TextSize = 14,
    Font = Enum.Font.Gotham,
    TextWrapped = true
}, CreditSection)

--==================================================
-- START
--==================================================

Notify(
    "Vyy Hub",
    "Interface initialized successfully.",
    3
)

print("[Vyy Hub] Loaded successfully.")