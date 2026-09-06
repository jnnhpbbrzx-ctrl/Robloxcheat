-- =====================================================
-- ROCKET ULTRA v9.0
-- КРАСИВОЕ МЕНЮ С ВКЛАДКАМИ
-- БЕЗ СКРОЛЛИНГА — ВСЁ НА ОДНОМ ЭКРАНЕ
-- =====================================================

-- 1. ОСНОВНЫЕ СЕРВИСЫ
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 2. ПРОВЕРКА ПЕРСОНАЖА
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- =====================================================
-- 3. ПЕРЕМЕННЫЕ
-- =====================================================
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
local antiFall = false
local antiFallConnection = nil
local espEnabled = false
local espHighlights = {}
local aimbotEnabled = false
local aimbotConnection = nil
local freezeAll = false
local freezeConnection = nil
local thirdPerson = false
local thirdPersonConnection = nil
local antiKick = false
local antiKickConnection = nil
local grabEnabled = false
local grabTarget = nil
local grabConnection = nil
local grabBodyVelocity = nil
local grabFaceConnection = nil
local currentTab = "MAIN"

-- =====================================================
-- 4. СОЗДАНИЕ ГУИ
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ROCKET_GUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- ГЛАВНОЕ ОКНО
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 500, 0, 480)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 0, 22)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 0, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

-- ТЕНЬ ОКНА
local Shadow = Instance.new("Frame")
Shadow.Parent = MainFrame
Shadow.Size = UDim2.new(1, 0, 1, 0)
Shadow.Position = UDim2.new(0, 5, 0, 5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.ZIndex = 0

-- ЗАГОЛОВОК
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ROCKET ULTRA v9.0"
Title.TextColor3 = Color3.fromRGB(220, 150, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- НЕОНОВАЯ ПОДСВЕТКА ЗАГОЛОВКА
local Glow = Instance.new("Frame")
Glow.Parent = TopBar
Glow.Size = UDim2.new(1, 0, 0, 2)
Glow.Position = UDim2.new(0, 0, 1, 0)
Glow.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
Glow.BackgroundTransparency = 0.3

-- КНОПКА ЗАКРЫТИЯ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 20)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- =====================================================
-- 5. БОКОВАЯ ПАНЕЛЬ (ВКЛАДКИ)
-- =====================================================
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 110, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 0, 30)
Sidebar.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = Sidebar
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 6)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ ВКЛАДКИ
local function CreateTabButton(text, icon, tabName)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.Size = UDim2.new(0.85, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80, 0, 150)
    btn.Text = icon .. "\n" .. text
    btn.TextColor3 = Color3.fromRGB(200, 170, 220)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.TextWrapped = true
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.TextYAlignment = Enum.TextYAlignment.Center

    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0.1
        btn.BorderColor3 = Color3.fromRGB(150, 0, 255)
        btn.TextColor3 = Color3.fromRGB(255, 200, 255)
    end)

    btn.MouseLeave:Connect(function()
        if currentTab ~= tabName then
            btn.BackgroundTransparency = 0.3
            btn.BorderColor3 = Color3.fromRGB(80, 0, 150)
            btn.TextColor3 = Color3.fromRGB(200, 170, 220)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
        for _, b in pairs(tabButtons) do
            b.BackgroundTransparency = 0.3
            b.BorderColor3 = Color3.fromRGB(80, 0, 150)
            b.TextColor3 = Color3.fromRGB(200, 170, 220)
        end
        btn.BackgroundTransparency = 0.05
        btn.BorderColor3 = Color3.fromRGB(200, 0, 255)
        btn.TextColor3 = Color3.fromRGB(255, 200, 255)
    end)

    return btn
end

-- =====================================================
-- 6. ОСНОВНАЯ ОБЛАСТЬ КОНТЕНТА
-- =====================================================
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -120, 1, -45)
ContentArea.Position = UDim2.new(0, 115, 0, 45)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 0, 35)
ContentArea.BorderSizePixel = 0

-- ГРАДИЕНТНЫЙ ФОН
local ContentGradient = Instance.new("UIGradient")
ContentGradient.Parent = ContentArea
ContentGradient.Rotation = 30
ContentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 0, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 0, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 0, 35))
})

-- =====================================================
-- 7. ФУНКЦИИ ДЛЯ СОЗДАНИЯ ЭЛЕМЕНТОВ В КОНТЕНТЕ
-- =====================================================
local function ClearContent()
    for _, child in pairs(ContentArea:GetChildren()) do
        if child ~= ContentGradient then
            child:Destroy()
        end
    end
end

local function CreateToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Parent = ContentArea
    frame.Size = UDim2.new(0.92, 0, 0, 42)
    frame.Position = UDim2.new(0.04, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(80, 0, 150)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 190, 240)
    label.TextScaled = true
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0.25, 0, 0.8, 0)
    btn.Position = UDim2.new(0.72, 0, 0.1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(100, 0, 200)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(200, 150, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BorderColor3 = state and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(100, 0, 200)
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 80, 30) or Color3.fromRGB(40, 0, 80)
        callback(state)
    end)

    return frame
end

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentArea
    btn.Size = UDim2.new(0.92, 0, 0, 42)
    btn.Position = UDim2.new(0.04, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(100, 0, 200)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 190, 240)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold

    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0.2
        btn.BorderColor3 = Color3.fromRGB(200, 0, 255)
    end)

    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.5
        btn.BorderColor3 = Color3.fromRGB(100, 0, 200)
    end)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateTextBox(text, placeholder, callback)
    local box = Instance.new("TextBox")
    box.Parent = ContentArea
    box.Size = UDim2.new(0.92, 0, 0, 38)
    box.Position = UDim2.new(0.04, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    box.BackgroundTransparency = 0.4
    box.BorderSizePixel = 1
    box.BorderColor3 = Color3.fromRGB(100, 0, 200)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(220, 190, 240)
    box.TextScaled = true
    box.Font = Enum.Font.GothamMedium
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(box.Text)
        end
    end)
    return box
end

local function CreateHeader(text)
    local header = Instance.new("TextLabel")
    header.Parent = ContentArea
    header.Size = UDim2.new(0.92, 0, 0, 30)
    header.Position = UDim2.new(0.04, 0, 0, 0)
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

local function CreateSeparator()
    local sep = Instance.new("Frame")
    sep.Parent = ContentArea
    sep.Size = UDim2.new(0.92, 0, 0, 1)
    sep.Position = UDim2.new(0.04, 0, 0, 0)
    sep.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    sep.BackgroundTransparency = 0.6
    return sep
end

-- =====================================================
-- 8. ФУНКЦИИ
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

-- ANTI-FALL
local function ToggleAntiFall(state)
    antiFall = state
    if antiFall then
        if antiFallConnection then antiFallConnection:Disconnect() end
        antiFallConnection = RunService.RenderStepped:Connect(function()
            if not antiFall then antiFallConnection:Disconnect() return end
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                if pos.Y < -30 then
                    char.HumanoidRootPart.Position = Vector3.new(pos.X, 20, pos.Z)
                end
            end
        end)
    else
        if antiFallConnection then antiFallConnection:Disconnect() antiFallConnection = nil end
    end
end

-- ESP
local function ToggleESP(state)
    espEnabled = state
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                local char = plr.Character
                if char then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = char
                    highlight.Adornee = char
                    highlight.FillColor = Color3.fromRGB(150, 0, 255)
                    highlight.FillTransparency = 0.25
                    highlight.OutlineColor = Color3.fromRGB(200, 0, 255)
                    highlight.OutlineTransparency = 0.1
                    table.insert(espHighlights, highlight)
                end
            end
        end
    else
        for _, h in pairs(espHighlights) do
            if h and h.Parent then h:Destroy() end
        end
        espHighlights = {}
    end
end

-- AIMBOT
local function ToggleAimbot(state)
    aimbotEnabled = state
    if aimbotEnabled then
        if aimbotConnection then aimbotConnection:Disconnect() end
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if not aimbotEnabled then aimbotConnection:Disconnect() return end
            local nearest = nil
            local minDist = math.huge
            local char = Player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player then
                    local targetChar = plr.Character
                    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                        local dist = (root.Position - targetChar.HumanoidRootPart.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearest = targetChar.HumanoidRootPart
                        end
                    end
                end
            end
            if nearest then
                root.CFrame = CFrame.new(root.Position, nearest.Position)
            end
        end)
    else
        if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    end
end

-- FREEZE ALL
local function ToggleFreezeAll(state)
    freezeAll = state
    if freezeAll then
        if freezeConnection then freezeConnection:Disconnect() end
        freezeConnection = RunService.RenderStepped:Connect(function()
            if not freezeAll then freezeConnection:Disconnect() return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player then
                    local char = plr.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    else
        if freezeConnection then freezeConnection:Disconnect() freezeConnection = nil end
    end
end

-- THIRD PERSON
local function ToggleThirdPerson(state)
    thirdPerson = state
    if thirdPerson then
        if thirdPersonConnection then thirdPersonConnection:Disconnect() end
        thirdPersonConnection = RunService.RenderStepped:Connect(function()
            if not thirdPerson then thirdPersonConnection:Disconnect() return end
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local cam = workspace.CurrentCamera
                local root = char.HumanoidRootPart
                local offset = Vector3.new(0, 5, 15)
                local targetPos = root.Position + offset
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = CFrame.new(targetPos, root.Position)
            end
        end)
    else
        if thirdPersonConnection then thirdPersonConnection:Disconnect() thirdPersonConnection = nil end
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
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

-- GRAB
local function GrabPlayer(targetName)
    local target = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower()) then
            target = plr
            break
        end
    end

    if not target or target == Player then
        print("ROCKET: Target not found")
        return
    end

    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        print("ROCKET: Target has no character")
        return
    end

    grabTarget = target
    grabEnabled = not grabEnabled

    if grabEnabled then
        local targetRoot = target.Character.HumanoidRootPart
        local targetHead = target.Character:FindFirstChild("Head")
        local targetTorso = target.Character:FindFirstChild("Torso") or target.Character:FindFirstChild("UpperTorso")

        local targetHum = target.Character:FindFirstChild("Humanoid")
        if targetHum then
            targetHum.PlatformStand = true
        end

        grabBodyVelocity = Instance.new("BodyVelocity")
        grabBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        grabBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        grabBodyVelocity.Parent = targetRoot

        grabConnection = RunService.RenderStepped:Connect(function()
            if not grabEnabled or not grabTarget or not grabTarget.Character then
                grabEnabled = false
                if grabConnection then grabConnection:Disconnect() grabConnection = nil end
                if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
                if grabFaceConnection then grabFaceConnection:Disconnect() grabFaceConnection = nil end
                return
            end

            local playerRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            local targetRoot = grabTarget.Character:FindFirstChild("HumanoidRootPart")

            if not playerRoot or not targetRoot then return end

            local distance = (playerRoot.Position - targetRoot.Position).Magnitude
            local crotchPosition = playerRoot.Position + Vector3.new(0, -1.5, 0)

            if distance > 3 then
                local force = (crotchPosition - targetRoot.Position).Unit * math.min(distance * 10, 200)
                grabBodyVelocity.Velocity = force
            elseif distance < 1.5 then
                grabBodyVelocity.Velocity = -(crotchPosition - targetRoot.Position).Unit * 20
            else
                grabBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                targetRoot.Velocity = Vector3.new(0, 0, 0)
                targetRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                local lookDirection = (playerRoot.Position - targetRoot.Position).Unit
                targetRoot.CFrame = CFrame.new(targetRoot.Position, targetRoot.Position + lookDirection)

                if targetHead then
                    targetHead.CFrame = CFrame.new(targetHead.Position, crotchPosition)
                end
                if targetTorso then
                    targetTorso.CFrame = CFrame.new(targetTorso.Position, crotchPosition) * CFrame.Angles(0.5, 0, 0)
                end
            end
        end)

        grabFaceConnection = RunService.Heartbeat:Connect(function()
            if not grabEnabled or not grabTarget or not grabTarget.Character then
                grabFaceConnection:Disconnect()
                return
            end
            local targetRoot = grabTarget.Character:FindFirstChild("HumanoidRootPart")
            local playerRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot and playerRoot then
                local crotchPos = playerRoot.Position + Vector3.new(0, -1.5, 0)
                targetRoot.CFrame = CFrame.new(targetRoot.Position, crotchPos)
            end
        end)

        print("ROCKET: Grab activated on " .. target.Name)
    else
        if grabConnection then grabConnection:Disconnect() grabConnection = nil end
        if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
        if grabFaceConnection then grabFaceConnection:Disconnect() grabFaceConnection = nil end

        if grabTarget and grabTarget.Character then
            local targetHum = grabTarget.Character:FindFirstChild("Humanoid")
            if targetHum then
                targetHum.PlatformStand = false
            end
            local targetRoot = grabTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                targetRoot.Velocity = Vector3.new(0, 0, 0)
                targetRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end

        print("ROCKET: Grab deactivated")
        grabTarget = nil
    end
end

-- =====================================================
-- 9. ВКЛАДКИ
-- =====================================================

-- ВКЛАДКА MAIN
local function TabMain()
    ClearContent()
    local y = 8

    local header1 = CreateHeader("MAIN FUNCTIONS")
    header1.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 35

    local flyToggle = CreateToggle("FLY (WASD + Space/Shift)", function(state)
        if state then StartFly() else StopFly() end
    end)
    flyToggle.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 47

    local noclipToggle = CreateToggle("NOCLIP", ToggleNoclip)
    noclipToggle.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 47

    local speedToggle = CreateToggle("SPEED HACK", ToggleSpeed)
    speedToggle.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 47

    local godToggle = CreateToggle("GOD MODE", ToggleGodMode)
    godToggle.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 47

    local jumpToggle = CreateToggle("INFINITE JUMP", ToggleInfiniteJump)
    jumpToggle.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 47

    local fallToggle = CreateToggle("ANTI-FALL", ToggleAntiFall)
    fallToggle.Position = UDim2.new(0.04, 0, 0, y)
end

-- ВКЛАДКА VISUALS
local function TabVisuals()
    ClearContent()
    local y = 8

    local header1 = CreateHeader("VISUAL FUNCTIONS")
    header1.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 35

    local espToggle = CreateToggle("ESP (PLAYER HIGHLIGHT)", ToggleESP)
    espToggle.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 47

    local aimbotToggle = CreateToggle("AIMBOT", ToggleAimbot)
    aimbotToggle.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 47

    local freezeToggle = CreateToggle("FREEZE ALL PLAYERS", ToggleFreezeAll)
    freezeToggle.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 47

    local thirdToggle = CreateToggle("THIRD PERSON", ToggleThirdPerson)
    thirdToggle.Position = UDim2.new(0.04, 0, 0, y)
end

-- ВКЛАДКА PLAYER
local function TabPlayer()
    ClearContent()
    local y = 8

    local header1 = CreateHeader("ANTI-KICK")
    header1.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 35

    local kickToggle = CreateToggle("ANTI-KICK PROTECTION", ToggleAntiKick)
    kickToggle.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 47

    local header2 = CreateHeader("GRAB PLAYER")
    header2.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 35

    local grabBtn = CreateButton("GRAB TARGET", function()
        local target = Players:GetPlayers()[2]
        if target then
            GrabPlayer(target.Name)
        end
    end)
    grabBtn.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 47

    local grabBox = CreateTextBox("", "Enter player name", function(text)
        if text and text ~= "" then
            GrabPlayer(text)
        end
    end)
    grabBox.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 43

    local releaseBtn = CreateButton("RELEASE TARGET", function()
        if grabEnabled then
            grabEnabled = false
            if grabConnection then grabConnection:Disconnect() grabConnection = nil end
            if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
            if grabFaceConnection then grabFaceConnection:Disconnect() grabFaceConnection = nil end
            if grabTarget and grabTarget.Character then
                local targetHum = grabTarget.Character:FindFirstChild("Humanoid")
                if targetHum then targetHum.PlatformStand = false end
            end
            grabTarget = nil
        end
    end)
    releaseBtn.Position = UDim2.new(0.04, 0, 0, y)
end

-- ВКЛАДКА SETTINGS
local function TabSettings()
    ClearContent()
    local y = 8

    local header1 = CreateHeader("SETTINGS")
    header1.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 35

    local speedBox = CreateTextBox("", "Set speed multiplier (default: 3)", function(text)
        local value = tonumber(text)
        if value and value > 0 and value < 100 then
            speedMultiplier = value
        end
    end)
    speedBox.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 43

    local flyBox = CreateTextBox("", "Set fly speed (default: 60)", function(text)
        local value = tonumber(text)
        if value and value > 0 and value < 500 then
            flySpeed = value
        end
    end)
    flyBox.Position = UDim2.new(0.04, 0, 0, y)
    y = y + 43

    local resetBtn = CreateButton("RESET CHARACTER", function()
        Player.Character = nil
        Player.CharacterAdded:Wait()
    end)
    resetBtn.Position = UDim2.new(0.04, 0, 0, y)
end

-- =====================================================
-- 10. СИСТЕМА ПЕРЕКЛЮЧЕНИЯ ВКЛАДОК
-- =====================================================
local tabButtons = {}

local function SwitchTab(tabName)
    currentTab = tabName
    if tabName == "MAIN" then TabMain()
    elseif tabName == "VISUALS" then TabVisuals()
    elseif tabName == "PLAYER" then TabPlayer()
    elseif tabName == "SETTINGS" then TabSettings()
    end
end

-- СОЗДАНИЕ КНОПОК ВКЛАДОК
local btn1 = CreateTabButton("MAIN", "🏠", "MAIN")
local btn2 = CreateTabButton("VISUAL", "👁️", "VISUALS")
local btn3 = CreateTabButton("PLAYER", "👤", "PLAYER")
local btn4 = CreateTabButton("SET", "⚙️", "SETTINGS")

tabButtons = {btn1, btn2, btn3, btn4}

-- АКТИВИРУЕМ ПЕРВУЮ ВКЛАДКУ
btn1.BackgroundTransparency = 0.05
btn1.BorderColor3 = Color3.fromRGB(200, 0, 255)
btn1.TextColor3 = Color3.fromRGB(255, 200, 255)
SwitchTab("MAIN")

-- =====================================================
-- 11. АВТОВОССТАНОВЛЕНИЕ
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
-- 12. КОНСОЛЬНЫЕ КОМАНДЫ
-- =====================================================
_G.grab = function(name)
    if name then
        GrabPlayer(name)
    else
        local target = Players:GetPlayers()[2]
        if target then GrabPlayer(target.Name) end
    end
end

_G.release = function()
    if grabEnabled then
        grabEnabled = false
        if grabConnection then grabConnection:Disconnect() grabConnection = nil end
        if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
        if grabFaceConnection then grabFaceConnection:Disconnect() grabFaceConnection = nil end
        if grabTarget and grabTarget.Character then
            local targetHum = grabTarget.Character:FindFirstChild("Humanoid")
            if targetHum then targetHum.PlatformStand = false end
        end
        grabTarget = nil
    end
end

_G.antikick = function(state)
    ToggleAntiKick(state or true)
end

-- =====================================================
-- 13. ВЫВОД
-- =====================================================
print("==========================================")
print("ROCKET ULTRA v9.0 LOADED")
print("TAB MENU - NO SCROLLING")
print("==========================================")
print("COMMANDS:")
print("_G.grab('name') - grab player")
print("_G.release() - release target")
print("_G.antikick(true/false) - toggle anti-kick")
print("==========================================")

-- =====================================================
-- КОНЕЦ
-- =====================================================
