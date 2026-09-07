--[[
    ROCKET UI
    Single-file lightweight Roblox UI - improved input handling
    Designed for low-end hardware.

    Features:
      - Icon sidebar
      - Player selector
      - Search
      - Player information
      - Self page
      - Camera page
      - Market page
      - Settings
      - Logs
      - F10 third-person toggle
      - Drag window
      - Minimize button
      - SafeUpdate wrapper
      - No RenderStepped loops for UI
      - Mouse-focus manager for E menu toggle
      - High DisplayOrder for top-layer UI
      - Input cleanup on destroy/focus changes
]]

------------------------------------------------------------
-- SERVICES
------------------------------------------------------------

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

------------------------------------------------------------
-- CONFIG
------------------------------------------------------------

local CFG = {
    Width = 760,
    Height = 480,

    F10Camera = true,
    ToggleKey = Enum.KeyCode.E,
    CloseKey = Enum.KeyCode.F10,
    ForceMouseOnOpen = true,

    Colors = {
        Background = Color3.fromRGB(12, 13, 17),
        Sidebar = Color3.fromRGB(17, 18, 23),
        Panel = Color3.fromRGB(20, 21, 27),
        Element = Color3.fromRGB(28, 30, 38),
        ElementHover = Color3.fromRGB(39, 41, 52),

        Accent = Color3.fromRGB(115, 87, 255),
        AccentDark = Color3.fromRGB(83, 62, 190),

        Text = Color3.fromRGB(240, 242, 247),
        Muted = Color3.fromRGB(145, 149, 160),

        Success = Color3.fromRGB(70, 190, 125),
        Danger = Color3.fromRGB(220, 75, 85),
    }
}

------------------------------------------------------------
-- STATE
------------------------------------------------------------

local State = {
    Open = true,
    Page = "Players",

    SelectedPlayer = nil,

    ThirdPerson = false,
    ThirdDistance = 10,

    WalkSpeedEnabled = false,
    JumpEnabled = false,

    Logs = {},

    Connections = {}
}

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------

local function safe(fn)
    local ok, result = pcall(fn)

    if not ok then
        warn("[ROCKET]", result)
    end

    return ok, result
end

local function create(class, props, parent)
    local obj = Instance.new(class)

    for key, value in pairs(props or {}) do
        obj[key] = value
    end

    obj.Parent = parent

    return obj
end

local function corner(obj, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, obj)
end

local function stroke(obj, color, transparency)
    create("UIStroke", {
        Color = color or CFG.Colors.Element,
        Transparency = transparency or 0,
        Thickness = 1
    }, obj)
end

local function tween(obj, properties, duration)
    local ok, result = pcall(function()
        local t = TweenService:Create(
            obj,
            TweenInfo.new(
                duration or 0.15,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            properties
        )

        t:Play()

        return t
    end)

    if ok then
        return result
    end
end

local function log(message)
    table.insert(
        State.Logs,
        os.date("%H:%M:%S") .. "  " .. tostring(message)
    )

    if #State.Logs > 100 then
        table.remove(State.Logs, 1)
    end
end

------------------------------------------------------------
-- GUI
------------------------------------------------------------

local old = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("RocketUI")

if old then
    old:Destroy()
end

local GUI = create("ScreenGui", {
    Name = "RocketUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 1000000,
    Enabled = true
}, LocalPlayer.PlayerGui)

------------------------------------------------------------
-- MAIN
------------------------------------------------------------

local Main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(CFG.Width, CFG.Height),
    Position = UDim2.new(
        0.5,
        -CFG.Width / 2,
        0.5,
        -CFG.Height / 2
    ),
    BackgroundColor3 = CFG.Colors.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, GUI)

corner(Main, 12)
stroke(Main, Color3.fromRGB(45, 47, 58))

------------------------------------------------------------
-- SIDEBAR
------------------------------------------------------------

local Sidebar = create("Frame", {
    Size = UDim2.fromOffset(58, CFG.Height),
    BackgroundColor3 = CFG.Colors.Sidebar,
    BorderSizePixel = 0
}, Main)

local SidebarLayout = create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 7),
    HorizontalAlignment = Enum.HorizontalAlignment.Center
}, Sidebar)

create("UIPadding", {
    PaddingTop = UDim.new(0, 12)
}, Sidebar)

------------------------------------------------------------
-- CONTENT
------------------------------------------------------------

local Content = create("Frame", {
    Position = UDim2.fromOffset(58, 0),
    Size = UDim2.new(1, -58, 1, 0),
    BackgroundTransparency = 1
}, Main)

------------------------------------------------------------
-- HEADER
------------------------------------------------------------

local Header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 55),
    BackgroundTransparency = 1
}, Content)

local HeaderTitle = create("TextLabel", {
    Position = UDim2.fromOffset(18, 13),
    Size = UDim2.new(1, -100, 0, 30),
    BackgroundTransparency = 1,
    Text = "Players",
    TextColor3 = CFG.Colors.Text,
    TextSize = 19,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

local Minimize = create("TextButton", {
    Position = UDim2.new(1, -72, 0, 12),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = CFG.Colors.Element,
    BorderSizePixel = 0,
    Text = "−",
    TextColor3 = CFG.Colors.Text,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, Header)

corner(Minimize, 7)

local Close = create("TextButton", {
    Position = UDim2.new(1, -38, 0, 12),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = CFG.Colors.Element,
    BorderSizePixel = 0,
    Text = "×",
    TextColor3 = CFG.Colors.Text,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, Header)

corner(Close, 7)

------------------------------------------------------------
-- INPUT / MOUSE MANAGER
------------------------------------------------------------

local InputState = {
    MenuOpen = true,
    PreviousMouseBehavior = Enum.MouseBehavior.Default,
    PreviousMouseIcon = true,
    InputBound = false,
}

local function setMouseForMenu(open)
    InputState.MenuOpen = open

    if not CFG.ForceMouseOnOpen then
        return
    end

    if open then
        InputState.PreviousMouseBehavior = UserInputService.MouseBehavior
        InputState.PreviousMouseIcon = UserInputService.MouseIconEnabled

        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true

        pcall(function()
            UserInputService.ModalEnabled = true
        end)
    else
        pcall(function()
            UserInputService.ModalEnabled = false
        end)

        UserInputService.MouseIconEnabled = InputState.PreviousMouseIcon

        if State.ThirdPerson then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        else
            UserInputService.MouseBehavior = InputState.PreviousMouseBehavior
        end
    end
end

local function setMenuVisible(visible)
    State.Open = visible
    Main.Visible = visible
    setMouseForMenu(visible)
end

local function toggleMenu()
    setMenuVisible(not State.Open)
end

local function sinkToggle(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        toggleMenu()
    end

    return Enum.ContextActionResult.Sink
end

pcall(function()
    ContextActionService:BindActionAtPriority(
        "Rocket_Menu_Toggle",
        sinkToggle,
        false,
        Enum.ContextActionPriority.High.Value,
        CFG.ToggleKey
    )

    InputState.InputBound = true
end)

------------------------------------------------------------
-- PAGES
------------------------------------------------------------

local PageHolder = create("Frame", {
    Position = UDim2.fromOffset(14, 55),
    Size = UDim2.new(1, -28, 1, -69),
    BackgroundTransparency = 1
}, Content)

local Pages = {}

local function page(name)
    local p = create("Frame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false
    }, PageHolder)

    Pages[name] = p

    return p
end

local function showPage(name)
    for n, p in pairs(Pages) do
        p.Visible = (n == name)
    end

    State.Page = name
    HeaderTitle.Text = name
end

------------------------------------------------------------
-- SIDEBAR BUTTON
------------------------------------------------------------

local SidebarButtons = {}

local function tab(icon, name, order)
    local b = create("TextButton", {
        Size = UDim2.fromOffset(38, 38),
        BackgroundColor3 = CFG.Colors.Element,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        Text = icon,
        TextColor3 = CFG.Colors.Muted,
        TextSize = 15,
        Font = Enum.Font.GothamBold,

        AutoButtonColor = false,
        LayoutOrder = order
    }, Sidebar)

    corner(b, 8)

    SidebarButtons[name] = b

    b.MouseEnter:Connect(function()
        if State.Page ~= name then
            tween(b, {
                BackgroundTransparency = 0,
                BackgroundColor3 = CFG.Colors.ElementHover,
                TextColor3 = CFG.Colors.Text
            })
        end
    end)

    b.MouseLeave:Connect(function()
        if State.Page ~= name then
            tween(b, {
                BackgroundTransparency = 1,
                TextColor3 = CFG.Colors.Muted
            })
        end
    end)

    b.MouseButton1Click:Connect(function()
        showPage(name)

        for tabName, button in pairs(SidebarButtons) do
            if tabName == name then
                tween(button, {
                    BackgroundTransparency = 0,
                    BackgroundColor3 = CFG.Colors.Accent,
                    TextColor3 = CFG.Colors.Text
                })
            else
                tween(button, {
                    BackgroundTransparency = 1,
                    TextColor3 = CFG.Colors.Muted
                })
            end
        end
    end)

    return b
end

------------------------------------------------------------
-- PLAYER PAGE
------------------------------------------------------------

local PlayerPage = page("Players")

local Left = create("Frame", {
    Size = UDim2.new(0.40, -6, 1, 0),
    BackgroundColor3 = CFG.Colors.Panel,
    BorderSizePixel = 0
}, PlayerPage)

corner(Left, 9)

local Search = create("TextBox", {
    Position = UDim2.fromOffset(10, 10),
    Size = UDim2.new(1, -20, 0, 34),

    BackgroundColor3 = CFG.Colors.Element,
    BorderSizePixel = 0,

    PlaceholderText = "Search",
    PlaceholderColor3 = CFG.Colors.Muted,

    Text = "",
    TextColor3 = CFG.Colors.Text,
    TextSize = 12,
    Font = Enum.Font.Gotham,

    ClearTextOnFocus = false
}, Left)

corner(Search, 7)

local PlayerScroll = create("ScrollingFrame", {
    Position = UDim2.fromOffset(10, 52),
    Size = UDim2.new(1, -20, 1, -62),

    BackgroundTransparency = 1,
    BorderSizePixel = 0,

    ScrollBarThickness = 2,
    ScrollBarImageColor3 = CFG.Colors.Accent,

    CanvasSize = UDim2.new(0, 0, 0, 0),

    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, Left)

local PlayerLayout = create("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, PlayerScroll)

------------------------------------------------------------
-- PLAYER DETAILS
------------------------------------------------------------

local Right = create("Frame", {
    Position = UDim2.new(0.40, 6, 0, 0),
    Size = UDim2.new(0.60, -6, 1, 0),
    BackgroundColor3 = CFG.Colors.Panel,
    BorderSizePixel = 0
}, PlayerPage)

corner(Right, 9)

local PlayerTitle = create("TextLabel", {
    Position = UDim2.fromOffset(18, 16),
    Size = UDim2.new(1, -36, 0, 25),

    BackgroundTransparency = 1,

    Text = "No player selected",
    TextColor3 = CFG.Colors.Text,
    TextSize = 17,
    Font = Enum.Font.GothamBold,

    TextXAlignment = Enum.TextXAlignment.Left
}, Right)

local PlayerSubtitle = create("TextLabel", {
    Position = UDim2.fromOffset(18, 42),
    Size = UDim2.new(1, -36, 0, 20),

    BackgroundTransparency = 1,

    Text = "",
    TextColor3 = CFG.Colors.Muted,
    TextSize = 11,
    Font = Enum.Font.Gotham,

    TextXAlignment = Enum.TextXAlignment.Left
}, Right)

local ActionGrid = create("Frame", {
    Position = UDim2.fromOffset(18, 82),
    Size = UDim2.new(1, -36, 1, -100),

    BackgroundTransparency = 1
}, Right)

create("UIGridLayout", {
    CellSize = UDim2.new(0.48, 0, 0, 40),
    CellPadding = UDim2.fromOffset(7, 7)
}, ActionGrid)

------------------------------------------------------------
-- LOCAL ACTION BUTTON
------------------------------------------------------------

local function actionButton(text, callback, danger)

    local b = create("TextButton", {
        BackgroundColor3 = danger
            and CFG.Colors.Danger
            or CFG.Colors.Element,

        Text = text,
        TextColor3 = CFG.Colors.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,

        BorderSizePixel = 0,
        AutoButtonColor = false
    }, ActionGrid)

    corner(b, 7)

    b.MouseEnter:Connect(function()
        tween(b, {
            BackgroundColor3 =
                danger
                and Color3.fromRGB(240, 85, 95)
                or CFG.Colors.ElementHover
        })
    end)

    b.MouseLeave:Connect(function()
        tween(b, {
            BackgroundColor3 =
                danger
                and CFG.Colors.Danger
                or CFG.Colors.Element
        })
    end)

    b.MouseButton1Click:Connect(function()
        if State.SelectedPlayer then
            safe(function()
                callback(State.SelectedPlayer)
            end)
        end
    end)

    return b
end

------------------------------------------------------------
-- PLAYER ACTIONS
------------------------------------------------------------

actionButton("Reset", function(player)
    log("Reset requested: " .. player.Name)

    -- Hook your own server-side admin RemoteEvent here.
end)

actionButton("Bring", function(player)
    log("Bring requested: " .. player.Name)
end)

actionButton("Teleport", function(player)

    local myCharacter = LocalPlayer.Character
    local targetCharacter = player.Character

    if not myCharacter or not targetCharacter then
        return
    end

    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")

    if myRoot and targetRoot then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(3, 0, 0)
        log("Teleported to " .. player.Name)
    end
end)

actionButton("Freeze", function(player)
    log("Freeze requested: " .. player.Name)
end)

actionButton("Unfreeze", function(player)
    log("Unfreeze requested: " .. player.Name)
end)

actionButton("Respawn", function(player)
    log("Respawn requested: " .. player.Name)
end)

actionButton("Spectate", function(player)

    local camera = workspace.CurrentCamera
    local character = player.Character

    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        camera.CameraSubject = humanoid
        log("Spectating " .. player.Name)
    end
end)

actionButton("Reset Camera", function()

    local character = LocalPlayer.Character

    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        workspace.CurrentCamera.CameraSubject = humanoid
    end
end)

------------------------------------------------------------
-- PLAYER LIST
------------------------------------------------------------

local function clearPlayerEntries()

    for _, child in ipairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function addPlayerEntry(player)

    local query = string.lower(Search.Text)

    if query ~= "" then

        local nameMatch =
            string.find(string.lower(player.Name), query, 1, true)

        local displayMatch =
            string.find(string.lower(player.DisplayName), query, 1, true)

        if not nameMatch and not displayMatch then
            return
        end
    end

    local b = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 44),

        BackgroundColor3 = CFG.Colors.Element,
        BorderSizePixel = 0,

        Text = "",
        AutoButtonColor = false
    }, PlayerScroll)

    corner(b, 7)

    local name = create("TextLabel", {
        Position = UDim2.fromOffset(10, 5),
        Size = UDim2.new(1, -20, 0, 18),

        BackgroundTransparency = 1,

        Text = player.DisplayName,
        TextColor3 = CFG.Colors.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,

        TextXAlignment = Enum.TextXAlignment.Left
    }, b)

    local username = create("TextLabel", {
        Position = UDim2.fromOffset(10, 23),
        Size = UDim2.new(1, -20, 0, 15),

        BackgroundTransparency = 1,

        Text = "@" .. player.Name,
        TextColor3 = CFG.Colors.Muted,
        TextSize = 10,
        Font = Enum.Font.Gotham,

        TextXAlignment = Enum.TextXAlignment.Left
    }, b)

    b.MouseEnter:Connect(function()
        if State.SelectedPlayer ~= player then
            tween(b, {
                BackgroundColor3 = CFG.Colors.ElementHover
            })
        end
    end)

    b.MouseLeave:Connect(function()
        if State.SelectedPlayer ~= player then
            tween(b, {
                BackgroundColor3 = CFG.Colors.Element
            })
        end
    end)

    b.MouseButton1Click:Connect(function()

        State.SelectedPlayer = player

        PlayerTitle.Text = player.DisplayName
        PlayerSubtitle.Text =
            "@" .. player.Name ..
            "  •  UserId " ..
            tostring(player.UserId)

        for _, child in ipairs(PlayerScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = CFG.Colors.Element
            end
        end

        b.BackgroundColor3 = CFG.Colors.AccentDark

        log("Selected " .. player.Name)
    end)
end

local function refreshPlayers()

    clearPlayerEntries()

    for _, player in ipairs(Players:GetPlayers()) do
        addPlayerEntry(player)
    end
end

Search:GetPropertyChangedSignal("Text"):Connect(refreshPlayers)

Players.PlayerAdded:Connect(function()
    task.defer(refreshPlayers)
end)

Players.PlayerRemoving:Connect(function(player)

    if State.SelectedPlayer == player then
        State.SelectedPlayer = nil
        PlayerTitle.Text = "No player selected"
        PlayerSubtitle.Text = ""
    end

    task.defer(refreshPlayers)
end)

refreshPlayers()

------------------------------------------------------------
-- SELF PAGE
------------------------------------------------------------

local SelfPage = page("Self")

local SelfGrid = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1
}, SelfPage)

create("UIGridLayout", {
    CellSize = UDim2.new(0.31, 0, 0, 44),
    CellPadding = UDim2.fromOffset(8, 8)
}, SelfGrid)

local function selfButton(text, callback)

    local b = create("TextButton", {
        BackgroundColor3 = CFG.Colors.Element,
        BorderSizePixel = 0,

        Text = text,
        TextColor3 = CFG.Colors.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,

        AutoButtonColor = false
    }, SelfGrid)

    corner(b, 7)

    b.MouseEnter:Connect(function()
        tween(b, {
            BackgroundColor3 = CFG.Colors.ElementHover
        })
    end)

    b.MouseLeave:Connect(function()
        tween(b, {
            BackgroundColor3 = CFG.Colors.Element
        })
    end)

    b.MouseButton1Click:Connect(function()
        safe(callback)
    end)

    return b
end

selfButton("Heal", function()

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.Health = hum.MaxHealth
        log("Heal")
    end
end)

selfButton("Respawn", function()
    LocalPlayer:LoadCharacter()
    log("Respawn")
end)

selfButton("Reset Camera", function()

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        workspace.CurrentCamera.CameraSubject = hum
    end
end)

selfButton("WalkSpeed", function()

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not hum then
        return
    end

    State.WalkSpeedEnabled = not State.WalkSpeedEnabled

    hum.WalkSpeed =
        State.WalkSpeedEnabled
        and 24
        or 16

    log("WalkSpeed = " .. tostring(hum.WalkSpeed))
end)

selfButton("JumpPower", function()

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not hum then
        return
    end

    State.JumpEnabled = not State.JumpEnabled

    hum.UseJumpPower = true

    hum.JumpPower =
        State.JumpEnabled
        and 70
        or 50

    log("JumpPower = " .. tostring(hum.JumpPower))
end)

------------------------------------------------------------
-- CAMERA PAGE
------------------------------------------------------------

local CameraPage = page("Camera")

local CameraGrid = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1
}, CameraPage)

create("UIGridLayout", {
    CellSize = UDim2.new(0.31, 0, 0, 44),
    CellPadding = UDim2.fromOffset(8, 8)
}, CameraGrid)

local function cameraButton(text, callback)

    local b = create("TextButton", {
        BackgroundColor3 = CFG.Colors.Element,
        BorderSizePixel = 0,

        Text = text,
        TextColor3 = CFG.Colors.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium
    }, CameraGrid)

    corner(b, 7)

    b.MouseButton1Click:Connect(function()
        safe(callback)
    end)

    return b
end

local function setThirdPerson(enabled)

    local camera = workspace.CurrentCamera

    State.ThirdPerson = enabled

    if enabled then

        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        camera.CameraType = Enum.CameraType.Custom

        LocalPlayer.CameraMinZoomDistance = 5
        LocalPlayer.CameraMaxZoomDistance = State.ThirdDistance

        log("Third person enabled")

    else

        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 12

        log("Third person disabled")
    end
end

cameraButton("Third Person", function()
    setThirdPerson(not State.ThirdPerson)
end)

cameraButton("Distance +", function()

    State.ThirdDistance = math.clamp(
        State.ThirdDistance + 2,
        5,
        30
    )

    LocalPlayer.CameraMaxZoomDistance = State.ThirdDistance

    log("Camera distance = " .. State.ThirdDistance)
end)

cameraButton("Distance −", function()

    State.ThirdDistance = math.clamp(
        State.ThirdDistance - 2,
        5,
        30
    )

    LocalPlayer.CameraMaxZoomDistance = State.ThirdDistance

    log("Camera distance = " .. State.ThirdDistance)
end)

cameraButton("Lock Camera", function()

    local camera = workspace.CurrentCamera

    camera.CameraType =
        camera.CameraType == Enum.CameraType.Scriptable
        and Enum.CameraType.Custom
        or Enum.CameraType.Scriptable

    log("Camera mode changed")
end)

cameraButton("Default Camera", function()

    workspace.CurrentCamera.CameraType =
        Enum.CameraType.Custom

    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 12

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        workspace.CurrentCamera.CameraSubject = hum
    end

    State.ThirdPerson = false

    log("Camera reset")
end)

------------------------------------------------------------
-- MARKET PAGE
------------------------------------------------------------

local MarketPage = page("Market")

local Market = create("ScrollingFrame", {
    Size = UDim2.fromScale(1, 1),

    BackgroundTransparency = 1,
    BorderSizePixel = 0,

    ScrollBarThickness = 2,

    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, MarketPage)

create("UIGridLayout", {
    CellSize = UDim2.new(0.31, 0, 0, 102),
    CellPadding = UDim2.fromOffset(8, 8)
}, Market)

local Items = {
    {"Starter", 100},
    {"Blade", 500},
    {"Shield", 750},
    {"Scanner", 900},
    {"Grapple", 1250},
    {"Rare", 2500},
    {"Epic", 5000},
    {"Legendary", 10000},
    {"Premium", 25000},
}

for _, item in ipairs(Items) do

    local card = create("Frame", {
        BackgroundColor3 = CFG.Colors.Panel,
        BorderSizePixel = 0
    }, Market)

    corner(card, 8)

    create("TextLabel", {
        Position = UDim2.fromOffset(11, 9),
        Size = UDim2.new(1, -22, 0, 20),

        BackgroundTransparency = 1,

        Text = item[1],
        TextColor3 = CFG.Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,

        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    create("TextLabel", {
        Position = UDim2.fromOffset(11, 31),
        Size = UDim2.new(1, -22, 0, 18),

        BackgroundTransparency = 1,

        Text = tostring(item[2]),
        TextColor3 = CFG.Colors.Muted,
        TextSize = 11,
        Font = Enum.Font.Gotham,

        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    local buy = create("TextButton", {
        Position = UDim2.fromOffset(10, 62),
        Size = UDim2.new(1, -20, 0, 29),

        BackgroundColor3 = CFG.Colors.Accent,
        BorderSizePixel = 0,

        Text = "Buy",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 11,
        Font = Enum.Font.GothamBold,

        AutoButtonColor = false
    }, card)

    corner(buy, 6)

    buy.MouseEnter:Connect(function()
        tween(buy, {
            BackgroundColor3 = CFG.Colors.AccentDark
        })
    end)

    buy.MouseLeave:Connect(function()
        tween(buy, {
            BackgroundColor3 = CFG.Colors.Accent
        })
    end)

    buy.MouseButton1Click:Connect(function()
        log("Purchased request: " .. item[1])
    end)
end

------------------------------------------------------------
-- LOGS PAGE
------------------------------------------------------------

local LogsPage = page("Logs")

local LogScroll = create("ScrollingFrame", {
    Size = UDim2.fromScale(1, 1),

    BackgroundColor3 = CFG.Colors.Panel,
    BorderSizePixel = 0,

    ScrollBarThickness = 2,

    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, LogsPage)

corner(LogScroll, 8)

local LogLayout = create("UIListLayout", {
    Padding = UDim.new(0, 2)
}, LogScroll)

local function rebuildLogs()

    for _, child in ipairs(LogScroll:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for _, text in ipairs(State.Logs) do

        create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 24),

            BackgroundTransparency = 1,

            Text = text,
            TextColor3 = CFG.Colors.Muted,
            TextSize = 11,
            Font = Enum.Font.Code,

            TextXAlignment = Enum.TextXAlignment.Left
        }, LogScroll)
    end
end

------------------------------------------------------------
-- SETTINGS
------------------------------------------------------------

local SettingsPage = page("Settings")

local SettingsGrid = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1
}, SettingsPage)

create("UIGridLayout", {
    CellSize = UDim2.new(0.31, 0, 0, 44),
    CellPadding = UDim2.fromOffset(8, 8)
}, SettingsGrid)

local function settingButton(text, callback)

    local b = create("TextButton", {
        BackgroundColor3 = CFG.Colors.Element,
        BorderSizePixel = 0,

        Text = text,
        TextColor3 = CFG.Colors.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium
    }, SettingsGrid)

    corner(b, 7)

    b.MouseButton1Click:Connect(function()
        safe(callback)
    end)
end

settingButton("Refresh Players", refreshPlayers)

settingButton("Clear Logs", function()

    table.clear(State.Logs)
    rebuildLogs()
end)

settingButton("Toggle UI", function()
    toggleMenu()
end)

settingButton("Reset Position", function()

    Main.Position = UDim2.new(
        0.5,
        -CFG.Width / 2,
        0.5,
        -CFG.Height / 2
    )
end)

settingButton("Destroy", function()
    GUI:Destroy()
end)

------------------------------------------------------------
-- TABS
------------------------------------------------------------

tab("P", "Players", 1)
tab("S", "Self", 2)
tab("C", "Camera", 3)
tab("M", "Market", 4)
tab("L", "Logs", 5)
tab("G", "Settings", 6)

showPage("Players")

for name, button in pairs(SidebarButtons) do

    if name == "Players" then

        button.BackgroundTransparency = 0
        button.BackgroundColor3 = CFG.Colors.Accent
        button.TextColor3 = CFG.Colors.Text

    else

        button.BackgroundTransparency = 1
        button.TextColor3 = CFG.Colors.Muted

    end
end

------------------------------------------------------------
-- F10 CAMERA TOGGLE
------------------------------------------------------------

if CFG.F10Camera then
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end

        if input.KeyCode == CFG.CloseKey then
            setThirdPerson(not State.ThirdPerson)
        end
    end)
end

------------------------------------------------------------
-- MINIMIZE
------------------------------------------------------------

Minimize.MouseButton1Click:Connect(function()

    State.Open = not State.Open

    if State.Open then
        Main.Visible = true
        Main.Size = UDim2.fromOffset(1, 55)
        setMouseForMenu(true)

        tween(Main, {
            Size = UDim2.fromOffset(CFG.Width, CFG.Height)
        }, 0.2)
    else
        setMouseForMenu(false)

        tween(Main, {
            Size = UDim2.fromOffset(CFG.Width, 55)
        }, 0.2)
    end
end)

------------------------------------------------------------
-- CLOSE
------------------------------------------------------------

Close.MouseButton1Click:Connect(function()
    GUI.Enabled = false
    setMouseForMenu(false)
end)

------------------------------------------------------------
-- DRAG WINDOW
------------------------------------------------------------

do

    local dragging = false
    local dragStart
    local startPosition

    Header.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            dragging = true
            dragStart = input.Position
            startPosition = Main.Position

            input.Changed:Connect(function()

                if input.UserInputState ==
                    Enum.UserInputState.End then

                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)

        if not dragging then
            return
        end

        if input.UserInputType ~=
            Enum.UserInputType.MouseMovement then
            return
        end

        local delta =
            input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,

            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

------------------------------------------------------------
-- CHARACTER RESPAWN SUPPORT
------------------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function(character)

    task.defer(function()

        local humanoid =
            character:WaitForChild("Humanoid", 8)

        if not humanoid then
            return
        end

        if State.WalkSpeedEnabled then
            humanoid.WalkSpeed = 24
        end

        if State.JumpEnabled then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 70
        end

        if State.ThirdPerson then
            LocalPlayer.CameraMinZoomDistance = 5
            LocalPlayer.CameraMaxZoomDistance =
                State.ThirdDistance
        end

    end)
end)

------------------------------------------------------------
-- INPUT RESTORE AFTER RESPAWN / FOCUS CHANGES
------------------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function()
    task.defer(function()
        if State.Open then
            setMouseForMenu(true)
        end
    end)
end)

pcall(function()
    UserInputService.WindowFocused:Connect(function()
        if State.Open then
            setMouseForMenu(true)
        end
    end)
end)

GUI.Destroying:Connect(function()
    pcall(function()
        ContextActionService:UnbindAction("Rocket_Menu_Toggle")
    end)

    setMouseForMenu(false)
end)

setMouseForMenu(true)

------------------------------------------------------------
-- INITIAL LOGS
------------------------------------------------------------

log("Rocket UI initialized")
log("Player list loaded")
log("F10 camera toggle ready")

------------------------------------------------------------
-- LOG REFRESH
------------------------------------------------------------

task.spawn(function()

    while GUI.Parent do

        task.wait(1)

        if State.Page == "Logs" then
            rebuildLogs()
        end

    end
end)
