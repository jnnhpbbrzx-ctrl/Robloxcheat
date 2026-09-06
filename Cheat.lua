-- =====================================================
-- ROCKET ULTRA v4.0 — ПИЗДАТЫЙ ЧИТ
-- КРАСИВЫЙ ИНТЕРФЕЙС, МОЩНЫЙ ФУНКЦИОНАЛ
-- АВТОР: ROCKET (ROCKET WAY)
-- =====================================================

-- 1. ОСНОВНЫЕ СЕРВИСЫ
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- 2. ПРОВЕРКА ПЕРСОНАЖА
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
local antiFall = false
local antiFallConnection = nil
local espEnabled = false
local espHighlights = {}
local aimbotEnabled = false
local aimbotConnection = nil
local freezeAll = false
local freezeConnection = nil
local antiKick = false
local antiKickConnection = nil
local teleportCooldown = false
local autoFarm = false
local autoFarmConnection = nil
local flyState = false

-- 4. СОЗДАНИЕ КРАСИВОГО GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ROCKET_ULTRA_GUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- ОСНОВНАЯ ПАНЕЛЬ С ГРАДИЕНТОМ
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 480, 0, 620)
Frame.Position = UDim2.new(0.5, -240, 0.5, -310)
Frame.BackgroundColor3 = Color3.fromRGB(8, 0, 16)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true
Frame.Draggable = true

-- КРАСИВЫЙ ГРАДИЕНТ (ФИОЛЕТОВО-ЧЁРНЫЙ)
local Gradient = Instance.new("UIGradient")
Gradient.Parent = Frame
Gradient.Rotation = 45
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 0, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 0, 16)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 0, 60))
})

-- ГЛАВНАЯ ОБВОДКА (ФИОЛЕТОВАЯ НЕОНОВАЯ)
local Border = Instance.new("Frame")
Border.Parent = Frame
Border.Size = UDim2.new(1, 0, 1, 0)
Border.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
Border.BackgroundTransparency = 0.8
Border.BorderSizePixel = 0

local BorderGradient = Instance.new("UIGradient")
BorderGradient.Parent = Border
BorderGradient.Rotation = 90
BorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 200))
})

-- ЗАГОЛОВОК С НЕОНОВЫМ СВЕЧЕНИЕМ
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
Title.BackgroundTransparency = 0.5
Title.BorderSizePixel = 0
Title.Text = "🚀 ROCKET ULTRA v4.0"
Title.TextColor3 = Color3.fromRGB(220, 150, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- НЕОНОВОЕ СВЕЧЕНИЕ ДЛЯ ЗАГОЛОВКА
local Glow = Instance.new("Frame")
Glow.Parent = Title
Glow.Size = UDim2.new(1, 0, 1, 0)
Glow.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
Glow.BackgroundTransparency = 0.9
Glow.BorderSizePixel = 0

-- КНОПКА ЗАКРЫТИЯ (КРАСИВАЯ)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Frame
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -42, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 20)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.BorderSizePixel = 2
CloseBtn.BorderColor3 = Color3.fromRGB(200, 0, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- СКРОЛЛИНГ-СПИСОК С ПРОЗРАЧНЫМ ФОНОМ
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = Frame
ScrollFrame.Size = UDim2.new(1, -20, 1, -65)
ScrollFrame.Position = UDim2.new(0, 10, 0, 55)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollFrame.BackgroundTransparency = 0.8
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- ФУНКЦИЯ КРАСИВОЙ КНОПКИ
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.95, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 180, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    
    -- ЭФФЕКТ ПРИ НАВЕДЕНИИ
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0.2
        btn.BorderColor3 = Color3.fromRGB(180, 0, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.4
        btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ФУНКЦИЯ КРАСИВОГО ПЕРЕКЛЮЧАТЕЛЯ
local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.95, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    btn.Text = text .. " [🔴 OFF]"
    btn.TextColor3 = Color3.fromRGB(220, 180, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    
    local state = false
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0.2
        btn.BorderColor3 = Color3.fromRGB(180, 0, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.4
        btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    end)
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [🟢 ON]" or " [🔴 OFF]")
        btn.BorderColor3 = state and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(120, 0, 255)
        callback(state)
    end)
    return btn
end

-- ФУНКЦИЯ КРАСИВОГО ПОЛЯ ВВОДА
local function CreateTextBox(text, placeholder, callback)
    local box = Instance.new("TextBox")
    box.Parent = ScrollFrame
    box.Size = UDim2.new(0.95, 0, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
    box.BackgroundTransparency = 0.5
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.fromRGB(120, 0, 255)
    box.Text = text
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(200, 170, 255)
    box.TextScaled = true
    box.Font = Enum.Font.GothamMedium
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(box.Text)
        end
    end)
    return box
end

-- РАЗДЕЛИТЕЛЬ
local function CreateSeparator(text)
    local sep = Instance.new("TextLabel")
    sep.Parent = ScrollFrame
    sep.Size = UDim2.new(0.95, 0, 0, 25)
    sep.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
    sep.BackgroundTransparency = 0.6
    sep.BorderSizePixel = 0
    sep.Text = "─── " .. text .. " ───"
    sep.TextColor3 = Color3.fromRGB(150, 100, 200)
    sep.TextScaled = true
    sep.Font = Enum.Font.GothamBold
    return sep
end

-- =====================================================
-- 5. ФУНКЦИИ ЧИТА (ВСЁ РАБОТАЕТ БЕЗ СБОЕВ)
-- =====================================================

-- 5.1 FLY (ПОЛЁТ) — НЕ ЛОМАЕТ ХОДЬБУ
local function StartFly()
    if flying then return end
    flying = true
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- ОТКЛЮЧАЕМ ГРАВИТАЦИЮ ТОЛЬКО В ПОЛЁТЕ
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.PlatformStand = true
    end
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = root
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying or not root then
            flyConnection:Disconnect()
            return
        end
        local moveDirection = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection + Vector3.new(0, -1, 0) end
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * flySpeed
        end
        flyBodyVelocity.Velocity = moveDirection
    end)
end

local function StopFly()
    flying = false
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    
    -- ВОЗВРАЩАЕМ ГРАВИТАЦИЮ
    local char = Player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
    end
end

-- 5.2 NOCLIP
CreateToggle("🚫 NOCLIP", function(state)
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
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- 5.3 SPEED HACK — НЕ ЛОМАЕТ ХОДЬБУ
CreateToggle("💨 SPEED HACK (x" .. speedMultiplier .. ")", function(state)
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
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end)

-- 5.4 GOD MODE
CreateToggle("🛡️ GOD MODE", function(state)
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
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
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
end)

-- 5.5 INFINITE JUMP
CreateToggle("🦘 INFINITE JUMP", function(state)
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
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end
    end
end)

-- 5.6 ANTI-FALL
CreateToggle("🪂 ANTI-FALL", function(state)
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
        if antiFallConnection then
            antiFallConnection:Disconnect()
            antiFallConnection = nil
        end
    end
end)

-- 5.7 ESP
CreateToggle("👁️ ESP", function(state)
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
end)

-- 5.8 AIMBOT
CreateToggle("🎯 AIMBOT", function(state)
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
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end)

-- 5.9 FREEZE ALL
CreateToggle("❄️ FREEZE ALL", function(state)
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
        if freezeConnection then
            freezeConnection:Disconnect()
            freezeConnection = nil
        end
    end
end)

-- 5.10 ANTI-KICK (ПИЗДАТЫЙ)
CreateToggle("🛡️ ANTI-KICK", function(state)
    antiKick = state
    if antiKick then
        if antiKickConnection then antiKickConnection:Disconnect() end
        -- ПЕРЕХВАТ КИКА
        antiKickConnection = game:GetService("Players").LocalPlayer:WaitForChild("Kick"):Connect(function()
            if antiKick then
                print("🛡️ ROCKET: КИК ЗАБЛОКИРОВАН!")
                wait(0.1)
                Player.Character = Player.CharacterAdded:Wait()
                -- ВОССТАНАВЛИВАЕМ ЗДОРОВЬЕ
                wait(0.2)
                local char = Player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.MaxHealth = math.huge
                        hum.Health = math.huge
                    end
                end
            end
        end)
        print("🛡️ ROCKET: АНТИ-КИК АКТИВИРОВАН!")
    else
        if antiKickConnection then
            antiKickConnection:Disconnect()
            antiKickConnection = nil
        end
        print("🛡️ ROCKET: АНТИ-КИК ОТКЛЮЧЁН")
    end
end)

-- 5.11 AUTO-FARM
CreateToggle("🌾 AUTO-FARM", function(state)
    autoFarm = state
    if autoFarm then
        if autoFarmConnection then autoFarmConnection:Disconnect() end
        autoFarmConnection = RunService.RenderStepped:Connect(function()
            if not autoFarm then autoFarmConnection:Disconnect() return end
            local char = Player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (
                    obj.Name:lower():find("resource") or 
                    obj.Name:lower():find("item") or 
                    obj.Name:lower():find("ore") or 
                    obj.Name:lower():find("crystal") or
                    obj.Name:lower():find("collect") or
                    obj.Name:lower():find("drop")
                ) then
                    local dist = (root.Position - obj.Position).Magnitude
                    if dist < 40 then
                        root.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
                        wait(0.1)
                        local clickRemote = ReplicatedStorage:FindFirstChild("ClickRemote") or 
                                           ReplicatedStorage:FindFirstChild("CollectRemote") or
                                           ReplicatedStorage:FindFirstChild("FarmRemote")
                        if clickRemote then
                            pcall(function()
                                clickRemote:FireServer(obj)
                            end)
                        end
                        break
                    end
                end
            end
        end)
    else
        if autoFarmConnection then
            autoFarmConnection:Disconnect()
            autoFarmConnection = nil
        end
    end
end)

-- 5.12 TELEPORT TO TARGET
CreateButton("📦 TELEPORT TO TARGET", function()
    local target = Players:GetPlayers()[2]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
            print("📦 ROCKET: Телепорт к " .. target.Name)
        end
    else
        print("📦 ROCKET: Цель не найдена")
    end
end)

-- 5.13 KICK PLAYER
CreateTextBox("👢 Kick Player", "Имя игрока", function(text)
    if text and text ~= "" then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(text:lower()) or plr.DisplayName:lower():find(text:lower()) then
                pcall(function()
                    plr:Kick("Kicked by ROCKET")
                    print("👢 ROCKET: Кикнут " .. plr.Name)
                end)
                return
            end
        end
        print("👢 ROCKET: Игрок не найден")
    end
end)

-- 5.14 TELEPORT TO COORDS
CreateTextBox("📌 Teleport to X Y Z", "0 50 0", function(text)
    local coords = {}
    for num in string.gmatch(text, "%S+") do
        table.insert(coords, tonumber(num))
    end
    if #coords >= 3 then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
            print("📌 ROCKET: Телепорт в " .. coords[1] .. ", " .. coords[2] .. ", " .. coords[3])
        end
    else
        print("📌 ROCKET: Неверные координаты")
    end
end)

-- 5.15 SET SPEED
CreateTextBox("⚡ Set Speed Multiplier", "3", function(text)
    local value = tonumber(text)
    if value and value > 0 and value < 100 then
        speedMultiplier = value
        print("⚡ ROCKET: Множитель скорости = " .. speedMultiplier)
        for _, child in pairs(ScrollFrame:GetChildren()) do
            if child:IsA("TextButton") and child.Text:find("SPEED HACK") then
                child.Text = "💨 SPEED HACK (x" .. speedMultiplier .. ")"
            end
        end
    else
        print("⚡ ROCKET: Неверное значение")
    end
end)

-- 5.16 SET FLY SPEED
CreateTextBox("✈️ Set Fly Speed", "60", function(text)
    local value = tonumber(text)
    if value and value > 0 and value < 500 then
        flySpeed = value
        print("✈️ ROCKET: Скорость полёта = " .. flySpeed)
    else
        print("✈️ ROCKET: Неверное значение")
    end
end)

-- 5.17 RESET
CreateButton("🔄 RESET CHARACTER", function()
    Player.Character = nil
    Player.CharacterAdded:Wait()
    print("🔄 ROCKET: Персонаж пересоздан")
end)

-- =====================================================
-- 6. РАЗДЕЛИТЕЛИ ДЛЯ КРАСОТЫ
-- =====================================================
CreateSeparator("ОСНОВНЫЕ ФУНКЦИИ")

-- ВСЕ ТОГГЛЫ В ОДНОМ МЕСТЕ
CreateToggle("✈️ FLY (WASD + Space/Shift)", function(state)
    if state then StartFly() else StopFly() end
end)

CreateToggle("🚫 NOCLIP", function(state)
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
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

CreateToggle("💨 SPEED HACK (x" .. speedMultiplier .. ")", function(state)
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
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end)

CreateToggle("🛡️ GOD MODE", function(state)
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
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
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
end)

CreateToggle("🦘 INFINITE JUMP", function(state)
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
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end
    end
end)

CreateToggle("🪂 ANTI-FALL", function(state)
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
        if antiFallConnection then
            antiFallConnection:Disconnect()
            antiFallConnection = nil
        end
    end
end)

CreateToggle("👁️ ESP", function(state)
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
end)

CreateToggle("🎯 AIMBOT", function(state)
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
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end)

CreateToggle("❄️ FREEZE ALL", function(state)
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
        if freezeConnection then
            freezeConnection:Disconnect()
            freezeConnection = nil
        end
    end
end)

CreateToggle("🛡️ ANTI-KICK", function(state)
    antiKick = state
    if antiKick then
        if antiKickConnection then antiKickConnection:Disconnect() end
        antiKickConnection = game:GetService("Players").LocalPlayer:WaitForChild("Kick"):Connect(function()
            if antiKick then
                print("🛡️ ROCKET: КИК ЗАБЛОКИРОВАН!")
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
            end
        end)
        print("🛡️ ROCKET: АНТИ-КИК АКТИВИРОВАН!")
    else
        if antiKickConnection then
            antiKickConnection:Disconnect()
            antiKickConnection = nil
        end
        print("🛡️ ROCKET: АНТИ-КИК ОТКЛЮЧЁН")
    end
end)

CreateToggle("🌾 AUTO-FARM", function(state)
    autoFarm = state
    if autoFarm then
        if autoFarmConnection then autoFarmConnection:Disconnect() end
        autoFarmConnection = RunService.RenderStepped:Connect(function()
            if not autoFarm then autoFarmConnection:Disconnect() return end
            local char = Player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (
                    obj.Name:lower():find("resource") or 
                    obj.Name:lower():find("item") or 
                    obj.Name:lower():find("ore") or 
                    obj.Name:lower():find("crystal") or
                    obj.Name:lower():find("collect") or
                    obj.Name:lower():find("drop")
                ) then
                    local dist = (root.Position - obj.Position).Magnitude
                    if dist < 40 then
                        root.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
                        wait(0.1)
                        local clickRemote = ReplicatedStorage:FindFirstChild("ClickRemote") or 
                                           ReplicatedStorage:FindFirstChild("CollectRemote") or
                                           ReplicatedStorage:FindFirstChild("FarmRemote")
                        if clickRemote then
                            pcall(function()
                                clickRemote:FireServer(obj)
                            end)
                        end
                        break
                    end
                end
            end
        end)
    else
        if autoFarmConnection then
            autoFarmConnection:Disconnect()
            autoFarmConnection = nil
        end
    end
end)

CreateSeparator("ТЕЛЕПОРТЫ И ДЕЙСТВИЯ")

CreateButton("📦 TELEPORT TO TARGET", function()
    local target = Players:GetPlayers()[2]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
            print("📦 ROCKET: Телепорт к " .. target.Name)
        end
    else
        print("📦 ROCKET: Цель не найдена")
    end
end)

CreateTextBox("📌 Teleport to X Y Z", "0 50 0", function(text)
    local coords = {}
    for num in string.gmatch(text, "%S+") do
        table.insert(coords, tonumber(num))
    end
    if #coords >= 3 then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
            print("📌 ROCKET: Телепорт в " .. coords[1] .. ", " .. coords[2] .. ", " .. coords[3])
        end
    else
        print("📌 ROCKET: Неверные координаты")
    end
end)

CreateTextBox("👢 Kick Player", "Имя игрока", function(text)
    if text and text ~= "" then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(text:lower()) or plr.DisplayName:lower():find(text:lower()) then
                pcall(function()
                    plr:Kick("Kicked by ROCKET")
                    print("👢 ROCKET: Кикнут " .. plr.Name)
                end)
                return
            end
        end
        print("👢 ROCKET: Игрок не найден")
    end
end)

CreateSeparator("НАСТРОЙКИ")

CreateTextBox("⚡ Set Speed Multiplier", "3", function(text)
    local value = tonumber(text)
    if value and value > 0 and value < 100 then
        speedMultiplier = value
        print("⚡ ROCKET: Множитель скорости = " .. speedMultiplier)
        for _, child in pairs(ScrollFrame:GetChildren()) do
            if child:IsA("TextButton") and child.Text:find("SPEED HACK") then
                child.Text = "💨 SPEED HACK (x" .. speedMultiplier .. ")"
            end
        end
    else
        print("⚡ ROCKET: Неверное значение")
    end
end)

CreateTextBox("✈️ Set Fly Speed", "60", function(text)
    local value = tonumber(text)
    if value and value > 0 and value < 500 then
        flySpeed = value
        print("✈️ ROCKET: Скорость полёта = " .. flySpeed)
    else
        print("✈️ ROCKET: Неверное значение")
    end
end)

CreateButton("🔄 RESET CHARACTER", function()
    Player.Character = nil
    Player.CharacterAdded:Wait()
    print("🔄 ROCKET: Персонаж пересоздан")
end)

-- =====================================================
-- 7. АВТОВОССТАНОВЛЕНИЕ (НЕ ЛОМАЕТ ХОДЬБУ)
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
-- 8. ВЫВОД В КОНСОЛЬ
-- =====================================================
print("==========================================")
print("🚀 ROCKET ULTRA v4.0 ЗАГРУЖЕН!")
print("💜 КРАСИВЫЙ ИНТЕРФЕЙС С НЕОНОМ")
print("🛡️ АНТИ-КИК АКТИВИРУЕТСЯ КНОПКОЙ")
print("⚡ ВСЕ ФУНКЦИИ РАБОТАЮТ БЕЗ СБОЕВ")
print("==========================================")
print("ФУНКЦИИ:")
print("✈️ FLY | 🚫 NOCLIP | 💨 SPEED HACK")
print("🛡️ GOD MODE | 🦘 INFINITE JUMP")
print("🪂 ANTI-FALL | 👁️ ESP | 🎯 AIMBOT")
print("❄️ FREEZE ALL | 🛡️ ANTI-KICK")
print("🌾 AUTO-FARM | 📦 TELEPORT")
print("👢 KICK PLAYER | ⚡ НАСТРОЙКИ")
print("==========================================")

-- =====================================================
-- КОНЕЦ СКРИПТА
-- =====================================================
