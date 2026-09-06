-- =====================================================
-- ROCKET ULTRA v3.1 — ГАРАНТИРОВАННО ВИДИМЫЙ ЧИТ
-- ИСПОЛЬЗУЕТ CoreGui (ПОВЕРХ ВСЕГО)
-- =====================================================

-- 1. ОСНОВНЫЕ СЕРВИСЫ
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

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

-- 4. СОЗДАНИЕ GUI В CoreGui (ГАРАНТИРОВАННО ВИДИМО)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ROCKET_ULTRA_GUI"
ScreenGui.Parent = CoreGui  -- <--- ГЛАВНОЕ ИЗМЕНЕНИЕ
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true  -- <--- ИГНОРИРУЕТ ОТСТУПЫ ЭКРАНА

-- ОСНОВНАЯ ПАНЕЛЬ
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 500)
Frame.Position = UDim2.new(0.5, -200, 0.5, -250)
Frame.BackgroundColor3 = Color3.fromRGB(8, 0, 16)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 3
Frame.BorderColor3 = Color3.fromRGB(130, 0, 255)
Frame.Active = true
Frame.Draggable = true

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(18, 0, 35)
Title.BorderColor3 = Color3.fromRGB(150, 0, 255)
Title.Text = "ROCKET ULTRA v3.1"
Title.TextColor3 = Color3.fromRGB(200, 100, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- КНОПКА ЗАКРЫТИЯ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Frame
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 20)
CloseBtn.BorderColor3 = Color3.fromRGB(150, 0, 255)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- СКРОЛЛИНГ-СПИСОК
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = Frame
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(5, 0, 10)
ScrollFrame.BackgroundTransparency = 0.5
ScrollFrame.BorderColor3 = Color3.fromRGB(100, 0, 200)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- ФУНКЦИЯ КНОПКИ
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(12, 0, 25)
    btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 150, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ФУНКЦИЯ ПЕРЕКЛЮЧАТЕЛЯ
local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(12, 0, 25)
    btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(220, 150, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
    return btn
end

-- ФУНКЦИЯ ПОЛЯ ВВОДА
local function CreateTextBox(text, placeholder, callback)
    local box = Instance.new("TextBox")
    box.Parent = ScrollFrame
    box.Size = UDim2.new(0.95, 0, 0, 26)
    box.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
    box.BorderColor3 = Color3.fromRGB(120, 0, 255)
    box.Text = text
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(200, 150, 255)
    box.TextScaled = true
    box.Font = Enum.Font.GothamMedium
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(box.Text)
        end
    end)
    return box
end

-- =====================================================
-- 5. ФУНКЦИИ ЧИТА
-- =====================================================

-- FLY
local function StartFly()
    if flying then return end
    flying = true
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
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
end

CreateToggle("✈️ FLY (WASD + Space/Shift)", function(state)
    if state then StartFly() else StopFly() end
end)

-- NOCLIP
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

-- SPEED HACK
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

-- GOD MODE
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
            end
        end)
        local char = Player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
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
            end
        end
    end
end)

-- INFINITE JUMP
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

-- ANTI-FALL
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
                    char.HumanoidRootPart.Position = Vector3.new(pos.X, 15, pos.Z)
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

-- ESP
CreateToggle("👁️ ESP", function(state)
    espEnabled = state
    if espEnabled then
        local Players = game:GetService("Players")
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                local char = plr.Character
                if char then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = char
                    highlight.Adornee = char
                    highlight.FillColor = Color3.fromRGB(150, 0, 255)
                    highlight.FillTransparency = 0.3
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

-- AIMBOT
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
            local Players = game:GetService("Players")
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

-- FREEZE ALL
CreateToggle("❄️ FREEZE ALL", function(state)
    freezeAll = state
    if freezeAll then
        if freezeConnection then freezeConnection:Disconnect() end
        freezeConnection = RunService.RenderStepped:Connect(function()
            if not freezeAll then freezeConnection:Disconnect() return end
            local Players = game:GetService("Players")
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

-- TELEPORT TO TARGET
CreateButton("📦 TELEPORT TO TARGET", function()
    local target = game:GetService("Players"):GetPlayers()[2]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
            print("ROCKET: Teleported to " .. target.Name)
        end
    else
        print("ROCKET: Target not found")
    end
end)

-- TELEPORT TO COORDS
CreateTextBox("📌 Teleport to X Y Z", "0 50 0", function(text)
    local coords = {}
    for num in string.gmatch(text, "%S+") do
        table.insert(coords, tonumber(num))
    end
    if #coords >= 3 then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
            print("ROCKET: Teleported to " .. coords[1] .. ", " .. coords[2] .. ", " .. coords[3])
        end
    else
        print("ROCKET: Invalid coordinates")
    end
end)

-- RESET CHARACTER
CreateButton("🔄 RESET CHARACTER", function()
    Player.Character = nil
    Player.CharacterAdded:Wait()
    print("ROCKET: Character reset")
end)

-- SET SPEED MULTIPLIER
CreateTextBox("⚡ Set Speed Multiplier", "3", function(text)
    local value = tonumber(text)
    if value and value > 0 then
        speedMultiplier = value
        print("ROCKET: Speed multiplier set to " .. speedMultiplier)
        for _, child in pairs(ScrollFrame:GetChildren()) do
            if child:IsA("TextButton") and child.Text:find("SPEED HACK") then
                child.Text = "💨 SPEED HACK (x" .. speedMultiplier .. ")"
            end
        end
    else
        print("ROCKET: Invalid value")
    end
end)

-- SET FLY SPEED
CreateTextBox("✈️ Set Fly Speed", "60", function(text)
    local value = tonumber(text)
    if value and value > 0 then
        flySpeed = value
        print("ROCKET: Fly speed set to " .. flySpeed)
    else
        print("ROCKET: Invalid value")
    end
end)

-- =====================================================
-- 6. АВТОВОССТАНОВЛЕНИЕ
-- =====================================================
Player.CharacterAdded:Connect(function(char)
    wait(0.5)
    if godMode then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
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
end)

-- =====================================================
-- 7. ВЫВОД В КОНСОЛЬ
-- =====================================================
print("==========================================")
print("ROCKET ULTRA v3.1 ЗАГРУЖЕН!")
print("GUI создан в CoreGui — поверх всего.")
print("Если не видно — нажмите F9 и проверьте ошибки.")
print("==========================================")

-- =====================================================
-- КОНЕЦ СКРИПТА
-- =====================================================
