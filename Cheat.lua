--[[
    FTAP Cheat Panel v2.0
    Разработчик: Rocket Way
    Дата: 20.09.2026
    Описание: Полная чит-панель для плейса FTAP
    Функции: Анти-лаг, Анти-взрыв, Анти-кик (ультра), Кик игроков,
             Анимации (дрочка с интенсивностью, трансформация в член, рэгдолл)
    Интерфейс: Скроллинг, красивые цвета, перетаскивание
--]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local teleportService = game:GetService("TeleportService")
local guiService = game:GetService("GuiService")

-- ===== СОЗДАНИЕ GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "FTAP_Panel"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 650)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -325)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Заголовок с градиентом
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
title.Text = "🚀 FTAP PANEL v2.0"
title.TextColor3 = Color3.fromRGB(255, 180, 80)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = mainFrame

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Скроллинг-контейнер
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -55)
scroll.Position = UDim2.new(0, 5, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 850)
scroll.ScrollBarThickness = 10
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
scroll.Parent = mainFrame

-- ===== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ =====
local function createButton(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 18
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createSlider(text, y, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 55)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = scroll
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 25)
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local slider = Instance.new("UISlider")
    slider.Size = UDim2.new(0.8, 0, 0, 20)
    slider.Position = UDim2.new(0, 0, 0, 28)
    slider.MinValue = min
    slider.MaxValue = max
    slider.Value = default
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    slider.Parent = frame
    
    local value = slider.Value
    slider.Changed:Connect(function(val)
        value = val
        label.Text = text .. ": " .. string.format("%.1f", val)
        callback(val)
    end)
    return slider
end

local function createDropdown(text, y, items, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = scroll
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0.5, 0, 1, 0)
    dropdown.Position = UDim2.new(0.45, 0, 0, 0)
    dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    dropdown.Text = items[1]
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 16
    dropdown.Parent = frame
    
    local index = 1
    dropdown.MouseButton1Click:Connect(function()
        index = index % #items + 1
        dropdown.Text = items[index]
        callback(items[index])
    end)
    return dropdown
end

-- ===== ПЕРЕМЕННЫЕ ДЛЯ ФУНКЦИЙ =====
local antiLagActive = false
local antiExplosionActive = false
local antiKickActive = false
local kickTarget = ""
local masturbateSpeed = 1
local masturbateConnections = {}

-- ===== ФУНКЦИИ ЧИТА =====

-- 1. Анти-лаг
createButton("🔧 Anti-Lag (Toggle)", 10, Color3.fromRGB(40, 80, 120), function()
    antiLagActive = not antiLagActive
    if antiLagActive then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            end
            if v:IsA("Light") or v:IsA("PointLight") or v:IsA("SpotLight") then
                v.Enabled = false
            end
        end
        lighting.Brightness = 2
        lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        lighting.Ambient = Color3.fromRGB(120, 120, 120)
    else
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end
end)

-- 2. Анти-взрыв
createButton("💥 Anti-Explosion", 62, Color3.fromRGB(180, 60, 60), function()
    antiExplosionActive = not antiExplosionActive
    if antiExplosionActive then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Explosion") then
                v:Destroy()
            end
        end
        local conn
        conn = runService.Heartbeat:Connect(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Explosion") then
                    v:Destroy()
                end
            end
        end)
        _G.antiExplosionConnection = conn
    else
        if _G.antiExplosionConnection then
            _G.antiExplosionConnection:Disconnect()
            _G.antiExplosionConnection = nil
        end
    end
end)

-- 3. Анти-кик (ультра)
createButton("🛡️ Anti-Kick (ULTRA)", 114, Color3.fromRGB(40, 150, 80), function()
    antiKickActive = not antiKickActive
    if antiKickActive then
        -- Перехват всех методов кика
        local oldKick = players.Kick
        players.Kick = function() end
        
        local oldPlayerKick = player.Kick
        player.Kick = function() end
        
        -- Блокировка телепортации
        local oldTeleport = teleportService.Teleport
        teleportService.Teleport = function() end
        
        -- Блокировка GuiService
        guiService.GuiEnabled = true
        
        -- Удаление системных GUI
        for _, v in pairs(player:GetChildren()) do
            if v:IsA("ScreenGui") and v.Name == "RobloxGui" then
                v:Destroy()
            end
        end
        
        -- Блокировка удаленных событий
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local name = v.Name:lower()
                if name:find("kick") or name:find("ban") or name:find("antihack") then
                    local oldEvent = v.OnClientEvent
                    v.OnClientEvent = function() end
                end
            end
        end
        
        -- Защита от таймаута
        runService.Heartbeat:Connect(function()
            player:GetMouse().X = player:GetMouse().X + 0.001
        end)
        
        -- Блокировка вызова через другие сервисы
        local oldLoad = game.Loaded
        game.Loaded = function() end
    end
end)

-- 4. Кик игрока (ввод имени)
local kickInput = Instance.new("TextBox")
kickInput.Size = UDim2.new(1, -10, 0, 35)
kickInput.Position = UDim2.new(0, 5, 0, 168)
kickInput.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
kickInput.TextColor3 = Color3.fromRGB(255, 255, 255)
kickInput.Font = Enum.Font.Gotham
kickInput.TextSize = 16
kickInput.PlaceholderText = "Введите имя игрока для кика"
kickInput.Parent = scroll
kickInput:GetPropertyChangedSignal("Text"):Connect(function()
    kickTarget = kickInput.Text
end)

createButton("👢 Kick Player", 215, Color3.fromRGB(180, 40, 40), function()
    if kickTarget ~= "" then
        local target = players:FindFirstChild(kickTarget)
        if target then
            target:Kick("Kicked by FTAP v2.0")
        end
    end
end)

-- 5. Анимации дрочки
createDropdown("💦 Masturbation Speed", 270, {"Slow", "Medium", "Fast", "Turbo"}, function(val)
    if val == "Slow" then masturbateSpeed = 0.3
    elseif val == "Medium" then masturbateSpeed = 0.7
    elseif val == "Fast" then masturbateSpeed = 1.5
    elseif val == "Turbo" then masturbateSpeed = 3.0 end
end)

createButton("🎭 Play Masturbate", 322, Color3.fromRGB(200, 100, 150), function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    -- Очистка старых анимаций
    for _, conn in pairs(masturbateConnections) do
        conn:Disconnect()
    end
    masturbateConnections = {}
    
    -- Поиск руки
    local arm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
    if arm and arm:IsA("BasePart") then
        local t = 0
        local conn = runService.Heartbeat:Connect(function(dt)
            t = t + dt * masturbateSpeed
            if arm and arm.Parent then
                arm.CFrame = arm.CFrame * CFrame.Angles(0, 0, math.sin(t * 3) * 0.8)
            end
        end)
        table.insert(masturbateConnections, conn)
    end
end)

-- 6. Трансформация в член
createButton("🍆 Transform to Dick", 376, Color3.fromRGB(180, 80, 180), function()
    local targetName = kickInput.Text
    local target = players:FindFirstChild(targetName)
    if target and target.Character then
        local char = target.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            -- Создание модели
            local model = Instance.new("Model")
            model.Name = "DickModel"
            
            local part = Instance.new("Part")
            part.Size = Vector3.new(0.8, 2.5, 0.8)
            part.Shape = Enum.PartType.Cylinder
            part.BrickColor = BrickColor.new("Bright red")
            part.CFrame = root.CFrame
            part.Anchored = true
            part.Parent = model
            
            local part2 = Instance.new("Part")
            part2.Size = Vector3.new(1.2, 0.6, 1.2)
            part2.Shape = Enum.PartType.Ball
            part2.BrickColor = BrickColor.new("Bright red")
            part2.CFrame = root.CFrame * CFrame.new(0, 1.5, 0)
            part2.Anchored = true
            part2.Parent = model
            
            model.Parent = workspace
            char:BreakJoints()
            workspace.CurrentCamera.CameraSubject = part
        end
    end
end)

-- 7. Рэгдолл лицом на паху
createButton("😩 Ragdoll Face on Crotch", 430, Color3.fromRGB(150, 80, 60), function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.PlatformStand = true
        hum.Sit = true
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(math.rad(90), 0, 0)
        end
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                v.Anchored = true
            end
        end
    end
end)

-- 8. Стоп-анимации
createButton("⏹️ Stop All Animations", 484, Color3.fromRGB(80, 80, 80), function()
    for _, conn in pairs(masturbateConnections) do
        conn:Disconnect()
    end
    masturbateConnections = {}
    local char = player.Character
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                v.Anchored = false
            end
        end
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum.Sit = false
        end
    end
end)

-- Индикатор страницы
local pageIndicator = Instance.new("TextLabel")
pageIndicator.Size = UDim2.new(1, 0, 0, 25)
pageIndicator.Position = UDim2.new(0, 0, 1, -25)
pageIndicator.BackgroundTransparency = 1
pageIndicator.Text = "📄 Страница 1/1 | FTAP v2.0"
pageIndicator.TextColor3 = Color3.fromRGB(150, 150, 180)
pageIndicator.Font = Enum.Font.Gotham
pageIndicator.TextSize = 14
pageIndicator.Parent = mainFrame

print("🚀 FTAP Panel v2.0 успешно загружена!")
