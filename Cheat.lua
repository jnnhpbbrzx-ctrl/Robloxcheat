-- =====================================================
-- ROCKET ULTRA v9.1
-- УНИВЕРСАЛЬНАЯ ВЕРСИЯ
-- РАБОТАЕТ В ЛЮБОМ ЭКЗЕКЬЮТОРЕ
-- =====================================================

-- 1. ОСНОВНЫЕ СЕРВИСЫ
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

-- 2. ОЖИДАНИЕ ЗАГРУЗКИ ПЕРСОНАЖА
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- 3. ПЕРЕМЕННЫЕ
local flying = false
local flySpeed = 60
local flyBodyVelocity = nil
local flyConnection = nil
local noclip = false
local noclipConnection = nil
local speedHack = false
local speedMultiplier = 3
local speedConnection = nil
local godMode = false
local godModeConnection = nil
local infiniteJump = false
local infiniteJumpConnection = nil
local antiKick = false
local antiKickConnection = nil

-- =====================================================
-- 4. СОЗДАНИЕ ГУИ (РАБОТАЕТ В ЛЮБОМ ЭКЗЕКЬЮТОРЕ)
-- =====================================================

-- ПЫТАЕМСЯ СОЗДАТЬ В CoreGui, ЕСЛИ НЕ ПОЛУЧАЕТСЯ — В PlayerGui
local guiParent = pcall(function()
    return game:GetService("CoreGui")
end) and game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ROCKET_GUI"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false

-- ОСНОВНОЕ ОКНО
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 380, 0, 450)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 0, 255)
MainFrame.Active = true
MainFrame.Draggable = true

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
Title.Text = "ROCKET ULTRA v9.1"
Title.TextColor3 = Color3.fromRGB(200, 100, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- КНОПКА ЗАКРЫТИЯ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- БОКОВАЯ ПАНЕЛЬ (ВКЛАДКИ)
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 100, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 0, 30)
Sidebar.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = Sidebar
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ОСНОВНАЯ ОБЛАСТЬ
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -110, 1, -45)
ContentArea.Position = UDim2.new(0, 105, 0, 45)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 0, 35)
ContentArea.BorderSizePixel = 0

-- =====================================================
-- 5. ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ
-- =====================================================
local currentTab = "MAIN"

local function ClearContent()
    for _, child in pairs(ContentArea:GetChildren()) do
        child:Destroy()
    end
end

local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentArea
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(100, 0, 200)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(220, 180, 240)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.BorderColor3 = state and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(100, 0, 200)
        callback(state)
    end)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    end)

    return btn
end

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentArea
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(100, 0, 200)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 180, 240)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.MouseButton1Click:Connect(callback)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
        btn.BorderColor3 = Color3.fromRGB(200, 0, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
        btn.BorderColor3 = Color3.fromRGB(100, 0, 200)
    end)

    return btn
end

local function CreateHeader(text)
    local header = Instance.new("TextLabel")
    header.Parent = ContentArea
    header.Size = UDim2.new(0.9, 0, 0, 28)
    header.Position = UDim2.new(0.05, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
    header.BackgroundTransparency = 0.7
    header.BorderSizePixel = 0
    header.Text = "▸ " .. text
    header.TextColor3 = Color3.fromRGB(200, 150, 255)
    header.TextScaled = true
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    return header
end

local function CreateTabButton(text, tabName)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80, 0, 150)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 170, 220)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 0, 70)
        btn.BorderColor3 = Color3.fromRGB(150, 0, 255)
    end)

    btn.MouseLeave:Connect(function()
        if currentTab ~= tabName then
            btn.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
            btn.BorderColor3 = Color3.fromRGB(80, 0, 150)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
            b.BorderColor3 = Color3.fromRGB(80, 0, 150)
            b.TextColor3 = Color3.fromRGB(200, 170, 220)
        end
        btn.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
        btn.BorderColor3 = Color3.fromRGB(200, 0, 255)
        btn.TextColor3 = Color3.fromRGB(255, 200, 255)
    end)

    return btn
end

-- =====================================================
-- 6. ФУНКЦИИ
-- =====================================================

-- FLY
local function StartFly()
    if flying then return end
    flying = true
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = true end
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = root
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying or not root then flyConnection:Disconnect() return end
        local move = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end
        if move.Magnitude > 0 then move = move.Unit * flySpeed end
        flyBodyVelocity.Velocity = move
    end)
end

local function StopFly()
    flying = false
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    local char = Player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- NOCLIP
local function ToggleNoclip(state)
    noclip = state
    if noclip then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.RenderStepped:Connect(function()
            if not noclip then noclipConnection:Disconnect() return end
            local char = Player.Character
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- SPEED
local function ToggleSpeed(state)
    speedHack = state
    if speedHack then
        if speedConnection then speedConnection:Disconnect() end
        speedConnection = RunService.RenderStepped:Connect(function()
            if not speedHack then speedConnection:Disconnect() return end
            local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 16 * speedMultiplier
                hum.JumpPower = 50 * speedMultiplier
            end
        end)
    else
        if speedConnection then speedConnection:Disconnect() speedConnection = nil end
        local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end

-- GOD MODE
local function ToggleGodMode(state)
    godMode = state
    if godMode then
        if godModeConnection then godModeConnection:Disconnect() end
        godModeConnection = Player.CharacterAdded:Connect(function(char)
            wait(0.1)
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum.BreakJointsOnDeath = false
            end
        end)
        local char = Player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum.BreakJointsOnDeath = false
            end
        end
    else
        if godModeConnection then godModeConnection:Disconnect() godModeConnection = nil end
        local char = Player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = 100
                hum.Health = 100
                hum.BreakJointsOnDeath = true
            end
        end
    end
end

-- INFINITE JUMP
local function ToggleInfiniteJump(state)
    infiniteJump = state
    if infiniteJump then
        if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if infiniteJump then
                local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if infiniteJumpConnection then infiniteJumpConnection:Disconnect() infiniteJumpConnection = nil end
    end
end

-- ANTI-KICK
local function ToggleAntiKick(state)
    antiKick = state
    if antiKick then
        if antiKickConnection then antiKickConnection:Disconnect() end
        antiKickConnection = Player:WaitForChild("Kick"):Connect(function()
            if antiKick then
                wait(0.1)
                Player.Character = Player.CharacterAdded:Wait()
                wait(0.2)
                local char = Player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.MaxHealth = math.huge
                        hum.Health = math.huge
                    end
                end
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
                end)
            end
        end)
    else
        if antiKickConnection then
            antiKickConnection:Disconnect()
            antiKickConnection = nil
        end
    end
end

-- =====================================================
-- 7. ВКЛАДКИ
-- =====================================================

-- MAIN
local function TabMain()
    ClearContent()
    local y = 8

    local h1 = CreateHeader("MAIN FUNCTIONS")
    h1.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 33

    local f1 = CreateToggle("FLY (WASD + Space/Shift)", function(state)
        if state then StartFly() else StopFly() end
    end)
    f1.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 43

    local f2 = CreateToggle("NOCLIP", ToggleNoclip)
    f2.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 43

    local f3 = CreateToggle("SPEED HACK", ToggleSpeed)
    f3.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 43

    local f4 = CreateToggle("GOD MODE", ToggleGodMode)
    f4.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 43

    local f5 = CreateToggle("INFINITE JUMP", ToggleInfiniteJump)
    f5.Position = UDim2.new(0.05, 0, 0, y)
end

-- PROTECTION
local function TabProtection()
    ClearContent()
    local y = 8

    local h1 = CreateHeader("PROTECTION")
    h1.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 33

    local f1 = CreateToggle("ANTI-KICK", ToggleAntiKick)
    f1.Position = UDim2.new(0.05, 0, 0, y)
end

-- SETTINGS
local function TabSettings()
    ClearContent()
    local y = 8

    local h1 = CreateHeader("SETTINGS")
    h1.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 33

    local resetBtn = CreateButton("RESET CHARACTER", function()
        Player.Character = nil
        Player.CharacterAdded:Wait()
    end)
    resetBtn.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 43

    local closeBtn = CreateButton("CLOSE GUI", function()
        ScreenGui:Destroy()
    end)
    closeBtn.Position = UDim2.new(0.05, 0, 0, y)
end

-- =====================================================
-- 8. СИСТЕМА ПЕРЕКЛЮЧЕНИЯ
-- =====================================================
local tabButtons = {}

local function SwitchTab(tabName)
    currentTab = tabName
    if tabName == "MAIN" then TabMain()
    elseif tabName == "PROTECTION" then TabProtection()
    elseif tabName == "SETTINGS" then TabSettings()
    end
end

local btn1 = CreateTabButton("MAIN", "MAIN")
local btn2 = CreateTabButton("PROTECT", "PROTECTION")
local btn3 = CreateTabButton("SETTINGS", "SETTINGS")

tabButtons = {btn1, btn2, btn3}

btn1.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
btn1.BorderColor3 = Color3.fromRGB(200, 0, 255)
btn1.TextColor3 = Color3.fromRGB(255, 200, 255)
SwitchTab("MAIN")

-- =====================================================
-- 9. АВТОВОССТАНОВЛЕНИЕ
-- =====================================================
Player.CharacterAdded:Connect(function(char)
    wait(0.5)
    if godMode then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum.BreakJointsOnDeath = false
        end
    end
    if noclip then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    if speedHack then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 16 * speedMultiplier
            hum.JumpPower = 50 * speedMultiplier
        end
    end
    if flying then
        wait(0.2)
        StartFly()
    end
end)

-- =====================================================
-- 10. ВЫВОД
-- =====================================================
print("==========================================")
print("ROCKET ULTRA v9.1 LOADED")
print("GUI should appear in the center")
print("If not visible - check console for errors")
print("==========================================")

-- =====================================================
-- КОНЕЦ
-- =====================================================
