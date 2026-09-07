--[[
    ROCKET ADMIN PANEL
    Single-file Roblox Studio admin panel
    Place this LocalScript in StarterPlayerScripts.

    Server-side actions should be validated on the server.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

----------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------

local Config = {
    AdminUserIds = {
        [123456789] = true, -- CHANGE THIS
    },

    Size = Vector2.new(900, 560),

    Colors = {
        Background = Color3.fromRGB(13, 14, 18),
        Panel = Color3.fromRGB(18, 19, 24),
        Panel2 = Color3.fromRGB(23, 24, 30),
        Element = Color3.fromRGB(28, 30, 37),

        Text = Color3.fromRGB(235, 237, 242),
        Muted = Color3.fromRGB(140, 144, 155),

        Accent = Color3.fromRGB(126, 92, 255),
        AccentDark = Color3.fromRGB(91, 65, 190),

        Danger = Color3.fromRGB(220, 75, 85),
        Success = Color3.fromRGB(75, 190, 125),
    }
}

----------------------------------------------------------------
-- ADMIN CHECK
----------------------------------------------------------------

if not Config.AdminUserIds[LocalPlayer.UserId] then
    return
end

----------------------------------------------------------------
-- REMOTE
----------------------------------------------------------------

local Remote = ReplicatedStorage:FindFirstChild("RocketAdmin")

if not Remote then
    Remote = Instance.new("RemoteEvent")
    Remote.Name = "RocketAdmin"
    Remote.Parent = ReplicatedStorage
end

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------

local function New(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

local function Corner(parent, radius)
    return New("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, parent)
end

local function Stroke(parent, color, transparency)
    return New("UIStroke", {
        Color = color or Config.Colors.Element,
        Transparency = transparency or 0,
        Thickness = 1
    }, parent)
end

local function Tween(object, properties, duration)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.18,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    )

    tween:Play()

    return tween
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------

local Gui = New("ScreenGui", {
    Name = "RocketAdmin",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, LocalPlayer:WaitForChild("PlayerGui"))

----------------------------------------------------------------
-- MAIN
----------------------------------------------------------------

local Main = New("Frame", {
    Size = UDim2.fromOffset(Config.Size.X, Config.Size.Y),
    Position = UDim2.new(0.5, -Config.Size.X / 2, 0.5, -Config.Size.Y / 2),
    BackgroundColor3 = Config.Colors.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, Gui)

Corner(Main, 14)
Stroke(Main, Color3.fromRGB(45, 47, 57))

----------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------

local Sidebar = New("Frame", {
    Size = UDim2.new(0, 64, 1, 0),
    BackgroundColor3 = Config.Colors.Panel,
    BorderSizePixel = 0
}, Main)

local SidebarLayout = New("UIListLayout", {
    Padding = UDim.new(0, 8),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
}, Sidebar)

New("UIPadding", {
    PaddingTop = UDim.new(0, 18),
    PaddingBottom = UDim.new(0, 18)
}, Sidebar)

----------------------------------------------------------------
-- CONTENT
----------------------------------------------------------------

local Content = New("Frame", {
    Size = UDim2.new(1, -64, 1, 0),
    Position = UDim2.new(0, 64, 0, 0),
    BackgroundTransparency = 1
}, Main)

----------------------------------------------------------------
-- HEADER
----------------------------------------------------------------

local Header = New("Frame", {
    Size = UDim2.new(1, 0, 0, 64),
    BackgroundTransparency = 1
}, Content)

local HeaderTitle = New("TextLabel", {
    Position = UDim2.fromOffset(24, 17),
    Size = UDim2.fromOffset(400, 30),
    BackgroundTransparency = 1,
    Text = "Players",
    TextColor3 = Config.Colors.Text,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

----------------------------------------------------------------
-- CONTENT CONTAINER
----------------------------------------------------------------

local PageContainer = New("Frame", {
    Position = UDim2.fromOffset(18, 64),
    Size = UDim2.new(1, -36, 1, -82),
    BackgroundTransparency = 1
}, Content)

----------------------------------------------------------------
-- PAGES
----------------------------------------------------------------

local Pages = {}

local function CreatePage(name)
    local page = New("Frame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false
    }, PageContainer)

    Pages[name] = page

    return page
end

local function ShowPage(name)
    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end

    HeaderTitle.Text = name
end

----------------------------------------------------------------
-- SIDEBAR BUTTON
----------------------------------------------------------------

local CurrentPage

local function SidebarButton(icon, pageName)
    local Button = New("TextButton", {
        Size = UDim2.fromOffset(42, 42),
        BackgroundColor3 = Config.Colors.Element,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = icon,
        TextColor3 = Config.Colors.Muted,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        LayoutOrder = #Sidebar:GetChildren()
    }, Sidebar)

    Corner(Button, 9)

    Button.MouseEnter:Connect(function()
        if CurrentPage ~= pageName then
            Tween(Button, {
                BackgroundTransparency = 0,
                TextColor3 = Config.Colors.Text
            })
        end
    end)

    Button.MouseLeave:Connect(function()
        if CurrentPage ~= pageName then
            Tween(Button, {
                BackgroundTransparency = 1,
                TextColor3 = Config.Colors.Muted
            })
        end
    end)

    Button.MouseButton1Click:Connect(function()

        CurrentPage = pageName

        for _, child in ipairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                Tween(child, {
                    BackgroundTransparency = child == Button and 0 or 1,
                    TextColor3 = child == Button
                        and Config.Colors.Text
                        or Config.Colors.Muted
                })
            end
        end

        ShowPage(pageName)
    end)

    return Button
end

----------------------------------------------------------------
-- PLAYERS PAGE
----------------------------------------------------------------

local PlayersPage = CreatePage("Players")

local PlayerList = New("ScrollingFrame", {
    Size = UDim2.new(0.42, -8, 1, 0),
    BackgroundColor3 = Config.Colors.Panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Config.Colors.Accent,
    CanvasSize = UDim2.new()
}, PlayersPage)

Corner(PlayerList, 10)

local PlayerLayout = New("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
}, PlayerList)

New("UIPadding", {
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10)
}, PlayerList)

local SelectedPlayer = nil

local Details = New("Frame", {
    Position = UDim2.new(0.42, 8, 0, 0),
    Size = UDim2.new(0.58, -8, 1, 0),
    BackgroundColor3 = Config.Colors.Panel,
    BorderSizePixel = 0
}, PlayersPage)

Corner(Details, 10)

local SelectedName = New("TextLabel", {
    Position = UDim2.fromOffset(18, 16),
    Size = UDim2.new(1, -36, 0, 30),
    BackgroundTransparency = 1,
    Text = "No player selected",
    TextColor3 = Config.Colors.Text,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Details)

local SelectedStatus = New("TextLabel", {
    Position = UDim2.fromOffset(18, 48),
    Size = UDim2.new(1, -36, 0, 22),
    BackgroundTransparency = 1,
    Text = "Select a player from the list",
    TextColor3 = Config.Colors.Muted,
    TextSize = 13,
    Font = Enum.Font.Gotham
}, Details)

local Actions = New("Frame", {
    Position = UDim2.fromOffset(18, 88),
    Size = UDim2.new(1, -36, 1, -106),
    BackgroundTransparency = 1
}, Details)

New("UIGridLayout", {
    CellSize = UDim2.new(0.48, 0, 0, 42),
    CellPadding = UDim2.new(0, 8, 0, 8)
}, Actions)

local function ActionButton(text, callback, danger)
    local Button = New("TextButton", {
        BackgroundColor3 = danger
            and Config.Colors.Danger
            or Config.Colors.Element,

        Text = text,
        TextColor3 = Config.Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
        BorderSizePixel = 0
    }, Actions)

    Corner(Button, 8)

    Button.MouseEnter:Connect(function()
        Tween(Button, {
            BackgroundColor3 = danger
                and Color3.fromRGB(240, 85, 95)
                or Config.Colors.Accent
        })
    end)

    Button.MouseLeave:Connect(function()
        Tween(Button, {
            BackgroundColor3 = danger
                and Config.Colors.Danger
                or Config.Colors.Element
        })
    end)

    Button.MouseButton1Click:Connect(function()
        if SelectedPlayer then
            callback(SelectedPlayer)
        end
    end)

    return Button
end

ActionButton("Reset", function(target)
    Remote:FireServer("Reset", target.UserId)
end)

ActionButton("Bring", function(target)
    Remote:FireServer("Bring", target.UserId)
end)

ActionButton("Teleport", function(target)
    Remote:FireServer("Teleport", target.UserId)
end)

ActionButton("Freeze", function(target)
    Remote:FireServer("Freeze", target.UserId, true)
end)

ActionButton("Unfreeze", function(target)
    Remote:FireServer("Freeze", target.UserId, false)
end)

ActionButton("Kill", function(target)
    Remote:FireServer("Kill", target.UserId)
end, true)

ActionButton("Respawn", function(target)
    Remote:FireServer("Respawn", target.UserId)
end)

ActionButton("Spectate", function(target)
    Remote:FireServer("Spectate", target.UserId)
end)

----------------------------------------------------------------
-- PLAYER LIST
----------------------------------------------------------------

local function ClearPlayerList()
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function CreatePlayerEntry(player)
    local Button = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Config.Colors.Element,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0
    }, PlayerList)

    Corner(Button, 8)

    local Name = New("TextLabel", {
        Position = UDim2.fromOffset(12, 6),
        Size = UDim2.new(1, -24, 0, 19),
        BackgroundTransparency = 1,
        Text = player.DisplayName,
        TextColor3 = Config.Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Button)

    local Username = New("TextLabel", {
        Position = UDim2.fromOffset(12, 25),
        Size = UDim2.new(1, -24, 0, 17),
        BackgroundTransparency = 1,
        Text = "@" .. player.Name,
        TextColor3 = Config.Colors.Muted,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Button)

    Button.MouseButton1Click:Connect(function()
        SelectedPlayer = player

        SelectedName.Text = player.DisplayName
        SelectedStatus.Text = "@" .. player.Name

        for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Config.Colors.Element
            end
        end

        Button.BackgroundColor3 = Config.Colors.AccentDark
    end)
end

local function RefreshPlayers()
    ClearPlayerList()

    for _, player in ipairs(Players:GetPlayers()) do
        CreatePlayerEntry(player)
    end

    task.wait()

    PlayerList.CanvasSize = UDim2.fromOffset(
        0,
        PlayerLayout.AbsoluteContentSize.Y + 20
    )
end

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(function(player)
    if SelectedPlayer == player then
        SelectedPlayer = nil
        SelectedName.Text = "No player selected"
        SelectedStatus.Text = "Select a player from the list"
    end

    RefreshPlayers()
end)

RefreshPlayers()

----------------------------------------------------------------
-- SELF PAGE
----------------------------------------------------------------

local SelfPage = CreatePage("Self")

local SelfLayout = New("UIGridLayout", {
    CellSize = UDim2.new(0.31, 0, 0, 48),
    CellPadding = UDim2.new(0, 8, 0, 8)
}, SelfPage)

local function SelfButton(text, callback)
    local Button = New("TextButton", {
        BackgroundColor3 = Config.Colors.Element,
        Text = text,
        TextColor3 = Config.Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0,
        AutoButtonColor = false
    }, SelfPage)

    Corner(Button, 8)

    Button.MouseEnter:Connect(function()
        Tween(Button, {
            BackgroundColor3 = Config.Colors.Accent
        })
    end)

    Button.MouseLeave:Connect(function()
        Tween(Button, {
            BackgroundColor3 = Config.Colors.Element
        })
    end)

    Button.MouseButton1Click:Connect(callback)

    return Button
end

SelfButton("Respawn", function()
    Remote:FireServer("SelfRespawn")
end)

SelfButton("Heal", function()
    Remote:FireServer("SelfHeal")
end)

SelfButton("Full Health", function()
    Remote:FireServer("SelfFullHealth")
end)

SelfButton("Reset Character", function()
    Remote:FireServer("SelfReset")
end)

SelfButton("Toggle WalkSpeed", function()
    Remote:FireServer("ToggleWalkSpeed")
end)

SelfButton("Toggle JumpPower", function()
    Remote:FireServer("ToggleJumpPower")
end)

----------------------------------------------------------------
-- WORLD PAGE
----------------------------------------------------------------

local WorldPage = CreatePage("World")

local WorldLayout = New("UIGridLayout", {
    CellSize = UDim2.new(0.31, 0, 0, 48),
    CellPadding = UDim2.new(0, 8, 0, 8)
}, WorldPage)

local function WorldButton(text, callback)
    local Button = New("TextButton", {
        BackgroundColor3 = Config.Colors.Element,
        Text = text,
        TextColor3 = Config.Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0
    }, WorldPage)

    Corner(Button, 8)

    Button.MouseButton1Click:Connect(callback)

    return Button
end

WorldButton("Day", function()
    Remote:FireServer("SetTime", 14)
end)

WorldButton("Night", function()
    Remote:FireServer("SetTime", 0)
end)

WorldButton("Freeze Time", function()
    Remote:FireServer("FreezeTime", true)
end)

WorldButton("Unfreeze Time", function()
    Remote:FireServer("FreezeTime", false)
end)

WorldButton("Clear Weather", function()
    Remote:FireServer("ClearWeather")
end)

WorldButton("Reset World", function()
    Remote:FireServer("ResetWorld")
end)

----------------------------------------------------------------
-- TOOLS PAGE
----------------------------------------------------------------

local ToolsPage = CreatePage("Tools")

local ToolsLayout = New("UIGridLayout", {
    CellSize = UDim2.new(0.31, 0, 0, 48),
    CellPadding = UDim2.new(0, 8, 0, 8)
}, ToolsPage)

local tools = {
    "Sword",
    "Flashlight",
    "Grapple",
    "Medkit",
    "Radar",
    "Scanner",
    "Shield",
    "AdminTool"
}

for _, toolName in ipairs(tools) do
    local Button = New("TextButton", {
        BackgroundColor3 = Config.Colors.Element,
        Text = toolName,
        TextColor3 = Config.Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0
    }, ToolsPage)

    Corner(Button, 8)

    Button.MouseButton1Click:Connect(function()
        Remote:FireServer(
            "GiveTool",
            LocalPlayer.UserId,
            toolName
        )
    end)
end

----------------------------------------------------------------
-- MARKET PAGE
----------------------------------------------------------------

local MarketPage = CreatePage("Market")

local MarketList = New("ScrollingFrame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3
}, MarketPage)

local MarketLayout = New("UIGridLayout", {
    CellSize = UDim2.new(0.31, 0, 0, 110),
    CellPadding = UDim2.new(0, 8, 0, 8)
}, MarketList)

local marketItems = {
    {Name = "Starter Sword", Price = 100, Id = "StarterSword"},
    {Name = "Energy Blade", Price = 500, Id = "EnergyBlade"},
    {Name = "Gravity Tool", Price = 750, Id = "GravityTool"},
    {Name = "Shield", Price = 1200, Id = "Shield"},
    {Name = "Rare Tool", Price = 2500, Id = "RareTool"},
    {Name = "Premium Item", Price = 5000, Id = "PremiumItem"},
}

for _, item in ipairs(marketItems) do

    local Card = New("Frame", {
        BackgroundColor3 = Config.Colors.Panel,
        BorderSizePixel = 0
    }, MarketList)

    Corner(Card, 10)

    New("TextLabel", {
        Position = UDim2.fromOffset(12, 10),
        Size = UDim2.new(1, -24, 0, 22),
        BackgroundTransparency = 1,
        Text = item.Name,
        TextColor3 = Config.Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Card)

    New("TextLabel", {
        Position = UDim2.fromOffset(12, 36),
        Size = UDim2.new(1, -24, 0, 18),
        BackgroundTransparency = 1,
        Text = tostring(item.Price),
        TextColor3 = Config.Colors.Muted,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Card)

    local Buy = New("TextButton", {
        Position = UDim2.fromOffset(12, 67),
        Size = UDim2.new(1, -24, 0, 30),
        BackgroundColor3 = Config.Colors.Accent,
        Text = "Buy",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0
    }, Card)

    Corner(Buy, 7)

    Buy.MouseButton1Click:Connect(function()
        -- Server MUST validate the actual item price.
        Remote:FireServer("BuyItem", item.Id)
    end)
end

----------------------------------------------------------------
-- LOGS PAGE
----------------------------------------------------------------

local LogsPage = CreatePage("Logs")

local Logs = New("ScrollingFrame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Config.Colors.Panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 3
}, LogsPage)

Corner(Logs, 10)

local LogsLayout = New("UIListLayout", {
    Padding = UDim.new(0, 4)
}, Logs)

local function AddLog(message)
    New("TextLabel", {
        Size = UDim2.new(1, -20, 0, 26),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Config.Colors.Muted,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Logs)

    Logs.CanvasSize = UDim2.fromOffset(
        0,
        LogsLayout.AbsoluteContentSize.Y + 10
    )
end

AddLog("Admin panel initialized.")
AddLog("Ready.")

----------------------------------------------------------------
-- SETTINGS PAGE
----------------------------------------------------------------

local SettingsPage = CreatePage("Settings")

local SettingsLayout = New("UIGridLayout", {
    CellSize = UDim2.new(0.31, 0, 0, 48),
    CellPadding = UDim2.new(0, 8, 0, 8)
}, SettingsPage)

local function SettingButton(text, callback)
    local Button = New("TextButton", {
        BackgroundColor3 = Config.Colors.Element,
        Text = text,
        TextColor3 = Config.Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0
    }, SettingsPage)

    Corner(Button, 8)

    Button.MouseButton1Click:Connect(callback)

    return Button
end

SettingButton("Refresh Players", RefreshPlayers)

SettingButton("Toggle UI", function()
    Main.Visible = not Main.Visible
end)

SettingButton("Destroy UI", function()
    Gui:Destroy()
end)

----------------------------------------------------------------
-- ICON-ONLY TABS
--
-- ASCII characters are deliberately used here so the sidebar
-- contains no labels or emoji.
----------------------------------------------------------------

SidebarButton("P", "Players")
SidebarButton("S", "Self")
SidebarButton("W", "World")
SidebarButton("T", "Tools")
SidebarButton("M", "Market")
SidebarButton("L", "Logs")
SidebarButton("C", "Settings")

----------------------------------------------------------------
-- OPEN DEFAULT PAGE
----------------------------------------------------------------

ShowPage("Players")
CurrentPage = "Players"

for _, child in ipairs(Sidebar:GetChildren()) do
    if child:IsA("TextButton") then
        if child.Text == "P" then
            child.BackgroundTransparency = 0
            child.TextColor3 = Config.Colors.Text
        end
    end
end

----------------------------------------------------------------
-- DRAGGING
----------------------------------------------------------------

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true

        dragStart = input.Position
        startPosition = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)

    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end)
