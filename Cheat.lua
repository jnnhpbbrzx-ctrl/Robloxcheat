-- LocalScript в StarterPlayerScripts или внутри ScreenGui
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Создаём GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FTAP_CheatPanel"
gui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Text = "FTAP PANEL v1.0"
title.TextColor3 = Color3.fromRGB(255, 200, 100)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = mainFrame

-- Скроллинг-контейнер
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -60)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
scroll.ScrollBarThickness = 8
scroll.Parent = mainFrame

local function addButton(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function addSlider(text, y, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 20)
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.Parent = frame

    local slider = Instance.new("UISlider")
    slider.Size = UDim2.new(0.8, 0, 0, 20)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.MinValue = min
    slider.MaxValue = max
    slider.Value = default
    slider.Parent = frame
    slider.Changed:Connect(function(val)
        label.Text = text .. ": " .. math.round(val)
        callback(val)
    end)
    return slider
end

local function addDropdown(text, y, items, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.Parent = frame

    local drop = Instance.new("TextBox")
    drop.Size = UDim2.new(0.6, 0, 1, 0)
    drop.Position = UDim2.new(0.35, 0, 0, 0)
    drop.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    drop.Text = items[1]
    drop.TextColor3 = Color3.fromRGB(255, 255, 255)
    drop.Font = Enum.Font.Gotham
    drop.TextSize = 16
    drop.Parent = frame
    -- Простой выбор по клику (циклический)
    local idx = 1
    drop.MouseButton1Click:Connect(function()
        idx = idx % #items + 1
        drop.Text = items[idx]
        callback(items[idx])
    end)
    return drop
end

-- ========== Функции чита ==========

-- Анти-лаг (отключает частицы, дождь, свет)
local antiLag = false
addButton("Anti-Lag (Toggle)", 10, function()
    antiLag = not antiLag
    if antiLag then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            end
            if v:IsA("Light") or v:IsA("PointLight") or v:IsA("SpotLight") then
                v.Enabled = false
            end
        end
        game.Lighting.Brightness = 1.5
        game.Lighting.OutdoorAmbient = Color3.fromRGB(150,150,150)
    else
        -- восстановление (упрощённо)
        game.Lighting.Brightness = 1
        game.Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
    end
end)

-- Анти-взрыв (отключает взрывы от игроков)
addButton("Anti-Explosion", 60, function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Explosion") then
            v:Destroy()
        end
    end
    -- перехват новых взрывов
    local conn
    if not _G.antiExplosion then
        _G.antiExplosion = true
        conn = game:GetService("RunService").Heartbeat:Connect(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Explosion") then
                    v:Destroy()
                end
            end
        end)
    else
        _G.antiExplosion = false
        if conn then conn:Disconnect() end
    end
end)

-- Анти-кик (максимально агрессивный обход всех киков)
addButton("Anti-Kick (ULTRA)", 110, function()
    -- Блокируем стандартные кики
    local lps = game:GetService("LocalPlayer")
    local plrs = game:GetService("Players")
    local ts = game:GetService("TeleportService")
    local guiService = game:GetService("GuiService")

    -- Перехват Kick
    local oldKick = plrs.Kick
    plrs.Kick = function() end

    -- Блокировка Teleport (если кик через телепорт)
    local oldTeleport = ts.Teleport
    ts.Teleport = function() end

    -- Блокировка GuiService кика (бан)
    guiService.GuiEnabled = true

    -- Обход через CoreGui
    for _, v in pairs(player:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == "RobloxGui" then
            v:Destroy()
        end
    end

    -- Перехват OnClientKick (если есть)
    local remotes = game:GetDescendants()
    for _, v in pairs(remotes) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("kick") then
            v.OnClientEvent:Connect(function()
                return
            end)
        end
    end

    -- Спам heartbeat чтобы не выкинуло по таймауту
    game:GetService("RunService").Heartbeat:Connect(function()
        -- ложная активность
        player:GetMouse().X = player:GetMouse().X + 0.01
    end)

    -- Отключаем проверку античит-сервера (если есть)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("antihack") then
            v.OnClientEvent:Connect(function() end)
        end
    end

    player:Kick = function() end
    game.Players.Kick = function() end
end)

-- Кик выбранного игрока (Blobman)
local kickTarget = ""
addButton("Kick Selected Player", 160, function()
    local target = kickTarget
    if target ~= "" then
        local plr = game.Players:FindFirstChild(target)
        if plr then
            plr:Kick("Kicked by FTAP")
        end
    end
end)

-- Список игроков для выбора (обновляемый)
local playerListBox = Instance.new("TextBox")
playerListBox.Size = UDim2.new(1, -10, 0, 30)
playerListBox.Position = UDim2.new(0, 5, 0, 210)
playerListBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
playerListBox.TextColor3 = Color3.fromRGB(255, 255, 255)
playerListBox.Font = Enum.Font.Gotham
playerListBox.TextSize = 16
playerListBox.PlaceholderText = "Enter player name"
playerListBox.Parent = scroll
playerListBox:GetPropertyChangedSignal("Text"):Connect(function()
    kickTarget = playerListBox.Text
end)

-- Анимации
local animationFrame = Instance.new("Frame")
animationFrame.Size = UDim2.new(1, -10, 0, 180)
animationFrame.Position = UDim2.new(0, 5, 0, 250)
animationFrame.BackgroundTransparency = 1
animationFrame.Parent = scroll

-- Выбор анимации дрочки
local masturbateAnims = {"Slow", "Medium", "Fast", "Turbo"}
local masturbateIntensity = 1
addDropdown("Masturbation Intensity", 260, masturbateAnims, function(val)
    local speed = 1
    if val == "Slow" then speed = 0.5
    elseif val == "Medium" then speed = 1
    elseif val == "Fast" then speed = 2
    elseif val == "Turbo" then speed = 4 end
    masturbateIntensity = speed
end)

-- Кнопка "Play Masturbate"
addButton("Play Masturbate Animation", 310, function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    -- Создаём анимацию движения руки (дрочка)
    local animTrack = hum:LoadAnimation(Instance.new("Animation"))
    animTrack:SetAttribute("Speed", masturbateIntensity)
    -- Воспроизводим с движением руки
    local arm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
    if arm then
        local t = 0
        game:GetService("RunService").Heartbeat:Connect(function(dt)
            t = t + dt * masturbateIntensity
            if arm and arm:IsA("BasePart") then
                arm.CFrame = arm.CFrame * CFrame.Angles(0, 0, math.sin(t)*0.5)
            end
        end)
    end
end)

-- Анимация "другой игрок строится в модельку члена"
addButton("Transform Target into Dick Model", 360, function()
    local targetName = playerListBox.Text
    local target = game.Players:FindFirstChild(targetName)
    if target and target.Character then
        local char = target.Character
        -- Строим примитивную модельку (член)
        local model = Instance.new("Model")
        model.Name = "DickModel"
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.8, 2, 0.8)
        part.Shape = Enum.PartType.Cylinder
        part.BrickColor = BrickColor.new("Bright red")
        part.Position = char.HumanoidRootPart.Position
        part.Anchored = true
        part.Parent = model
        model.Parent = workspace
        -- Удаляем старого персонажа и ставим модель
        char:BreakJoints()
        model:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame)
        -- Привязываем камеру к модели
        game.Workspace.CurrentCamera.CameraSubject = part
    end
end)

-- Рэгдолл "лицом на паху"
addButton("Ragdoll Face on Crotch", 410, function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.PlatformStand = true
        hum.Sit = true
        -- Поворачиваем лицом вниз, на пах
        local root = char.HumanoidRootPart
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(math.rad(90), 0, 0)
        end
        -- Замораживаем все части
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                v.Anchored = true
            end
        end
    end
end)

-- Красивый интерфейс листания (уже есть ScrollingFrame)
-- Добавляем индикатор страницы
local pageIndicator = Instance.new("TextLabel")
pageIndicator.Size = UDim2.new(1, 0, 0, 30)
pageIndicator.Position = UDim2.new(0, 0, 1, -30)
pageIndicator.BackgroundTransparency = 1
pageIndicator.Text = "Page 1/1"
pageIndicator.TextColor3 = Color3.fromRGB(200, 200, 200)
pageIndicator.Font = Enum.Font.Gotham
pageIndicator.TextSize = 14
pageIndicator.Parent = mainFrame

-- Также можно добавить кнопку скрытия/показа панели
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 30)
toggleBtn.Position = UDim2.new(1, -70, 0, 5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "X"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Parent = mainFrame
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
