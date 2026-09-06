--[[
    FTAP IMMORTAL v4.0
    НЕУБИВАЕМАЯ ПАНЕЛЬ
    Пересоздается после любого удаления
    Работает через 5 разных систем защиты
--]]

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local teleportService = game:GetService("TeleportService")
local guiService = game:GetService("GuiService")
local userInputService = game:GetService("UserInputService")

-- ===== СИСТЕМА 1: ПЕРЕХВАТ УДАЛЕНИЯ =====
local function protectFromDeletion()
    local gui = player.PlayerGui:FindFirstChild("FTAP_Panel")
    if gui then
        gui.AncestryChanged:Connect(function()
            if not gui.Parent then
                wait(0.1)
                gui.Parent = player.PlayerGui
            end
        end)
    end
end

-- ===== СИСТЕМА 2: ПЕРЕСОЗДАНИЕ =====
local function recreatePanel()
    -- Удаляем старую панель если есть
    local oldGui = player.PlayerGui:FindFirstChild("FTAP_Panel")
    if oldGui then oldGui:Destroy() end
    
    -- ===== СОЗДАНИЕ GUI =====
    local gui = Instance.new("ScreenGui")
    gui.Name = "FTAP_Panel"
    gui.Parent = player:WaitForChild("PlayerGui")
    gui.Enabled = true
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 700)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -350)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.BackgroundTransparency = 0.02
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ZIndex = 9999
    mainFrame.Parent = gui
    
    -- Неоновый бордер
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 4, 1, 4)
    border.Position = UDim2.new(0, -2, 0, -2)
    border.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
    border.BackgroundTransparency = 0.7
    border.ZIndex = 9998
    border.Parent = mainFrame
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    title.Text = "🚀 FTAP IMMORTAL v4.0"
    title.TextColor3 = Color3.fromRGB(255, 50, 150)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 26
    title.ZIndex = 9999
    title.Parent = mainFrame
    
    -- Кнопка закрытия (только сворачивание)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -45, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 22
    closeBtn.ZIndex = 9999
    closeBtn.Parent = mainFrame
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)
    
    -- Скроллинг
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -60)
    scroll.Position = UDim2.new(0, 5, 0, 55)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
    scroll.ScrollBarThickness = 12
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 128)
    scroll.ZIndex = 9999
    scroll.Parent = mainFrame
    
    -- ===== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ =====
    local function createButton(text, y, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 45)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 70)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 18
        btn.ZIndex = 9999
        btn.Parent = scroll
        btn.MouseButton1Click:Connect(callback)
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 70)
        end)
        return btn
    end
    
    local function createSlider(text, y, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 60)
        frame.Position = UDim2.new(0, 5, 0, y)
        frame.BackgroundTransparency = 1
        frame.ZIndex = 9999
        frame.Parent = scroll
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0, 25)
        label.Text = text .. ": " .. tostring(default)
        label.TextColor3 = Color3.fromRGB(220, 220, 240)
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.BackgroundTransparency = 1
        label.ZIndex = 9999
        label.Parent = frame
        
        local slider = Instance.new("UISlider")
        slider.Size = UDim2.new(0.8, 0, 0, 22)
        slider.Position = UDim2.new(0, 0, 0, 30)
        slider.MinValue = min
        slider.MaxValue = max
        slider.Value = default
        slider.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
        slider.ZIndex = 9999
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
        frame.Size = UDim2.new(1, -10, 0, 45)
        frame.Position = UDim2.new(0, 5, 0, y)
        frame.BackgroundTransparency = 1
        frame.ZIndex = 9999
        frame.Parent = scroll
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220, 220, 240)
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.BackgroundTransparency = 1
        label.ZIndex = 9999
        label.Parent = frame
        
        local dropdown = Instance.new("TextButton")
        dropdown.Size = UDim2.new(0.5, 0, 1, 0)
        dropdown.Position = UDim2.new(0.45, 0, 0, 0)
        dropdown.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
        dropdown.Text = items[1]
        dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdown.Font = Enum.Font.Gotham
        dropdown.TextSize = 16
        dropdown.ZIndex = 9999
        dropdown.Parent = frame
        
        local index = 1
        dropdown.MouseButton1Click:Connect(function()
            index = index % #items + 1
            dropdown.Text = items[index]
            callback(items[index])
        end)
        return dropdown
    end
    
    -- ===== ПЕРЕМЕННЫЕ =====
    local antiLagActive = false
    local antiExplosionActive = false
    local antiKickActive = false
    local kickTarget = ""
    local masturbateSpeed = 1
    local masturbateConnections = {}
    local explosionConnection = nil
    
    -- ===== ФУНКЦИИ =====
    
    -- 1. Анти-лаг
    createButton("🔧 Anti-Lag (Toggle)", 10, Color3.fromRGB(40, 80, 180), function()
        antiLagActive = not antiLagActive
        if antiLagActive then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Trail") then
                    v.Enabled = false
                end
                if v:IsA("Light") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                    v.Enabled = false
                end
            end
            lighting.Brightness = 2.5
            lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            lighting.Ambient = Color3.fromRGB(150, 150, 150)
            lighting.GlobalShadows = false
        else
            lighting.Brightness = 1
            lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
            lighting.Ambient = Color3.fromRGB(0, 0, 0)
            lighting.GlobalShadows = true
        end
    end)
    
    -- 2. Анти-взрыв
    createButton("💥 Anti-Explosion (Toggle)", 65, Color3.fromRGB(180, 50, 50), function()
        antiExplosionActive = not antiExplosionActive
        if antiExplosionActive then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Explosion") then
                    v:Destroy()
                end
            end
            explosionConnection = runService.Heartbeat:Connect(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Explosion") then
                        v:Destroy()
                    end
                end
            end)
        else
            if explosionConnection then
                explosionConnection:Disconnect()
                explosionConnection = nil
            end
        end
    end)
    
    -- 3. Анти-кик УЛЬТРА
    createButton("🛡️ Anti-Kick (ULTRA)", 120, Color3.fromRGB(40, 180, 80), function()
        antiKickActive = not antiKickActive
        if antiKickActive then
            -- Полная блокировка всех методов кика
            local function blockAllKicks()
                local oldPlayersKick = players.Kick
                players.Kick = function() end
                
                local oldPlayerKick = player.Kick
                player.Kick = function() end
                
                local oldTeleport = teleportService.Teleport
                teleportService.Teleport = function() end
                
                guiService.GuiEnabled = true
                
                for _, v in pairs(player:GetChildren()) do
                    if v:IsA("ScreenGui") and v.Name == "RobloxGui" then
                        v:Destroy()
                    end
                end
                
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") then
                        local name = v.Name:lower()
                        if name:find("kick") or name:find("ban") or name:find("antihack") or name:find("exploit") then
                            v.OnClientEvent = function() end
                            v.FireServer = function() end
                        end
                    end
                    if v:IsA("RemoteFunction") then
                        v.InvokeServer = function() end
                    end
                end
                
                runService.Heartbeat:Connect(function()
                    local mouse = player:GetMouse()
                    mouse.X = mouse.X + 0.001
                end)
                
                local coreGui = game:GetService("CoreGui")
                for _, v in pairs(coreGui:GetChildren()) do
                    if v:IsA("ScreenGui") then
                        v.Enabled = false
                    end
                end
            end
            
            blockAllKicks()
            
            spawn(function()
                while antiKickActive do
                    wait(5)
                    blockAllKicks()
                end
            end)
        end
    end)
    
    -- 4. Кик игрока
    local kickInput = Instance.new("TextBox")
    kickInput.Size = UDim2.new(1, -10, 0, 38)
    kickInput.Position = UDim2.new(0, 5, 0, 178)
    kickInput.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    kickInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    kickInput.Font = Enum.Font.Gotham
    kickInput.TextSize = 16
    kickInput.PlaceholderText = "👤 Введите имя игрока для кика"
    kickInput.ZIndex = 9999
    kickInput.Parent = scroll
    kickInput:GetPropertyChangedSignal("Text"):Connect(function()
        kickTarget = kickInput.Text
    end)
    
    createButton("👢 Kick Selected Player", 228, Color3.fromRGB(200, 40, 40), function()
        if kickTarget ~= "" then
            local target = players:FindFirstChild(kickTarget)
            if target then
                target:Kick("Kicked by FTAP IMMORTAL v4.0")
            end
        end
    end)
    
    -- 5. Анимации дрочки
    createDropdown("💦 Masturbation Speed", 286, {"Slow", "Medium", "Fast", "Turbo", "INSANE"}, function(val)
        if val == "Slow" then masturbateSpeed = 0.3
        elseif val == "Medium" then masturbateSpeed = 0.7
        elseif val == "Fast" then masturbateSpeed = 1.5
        elseif val == "Turbo" then masturbateSpeed = 3.0
        elseif val == "INSANE" then masturbateSpeed = 6.0 end
    end)
    
    createButton("🎭 Start Masturbate", 344, Color3.fromRGB(200, 80, 180), function()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        
        for _, conn in pairs(masturbateConnections) do
            conn:Disconnect()
        end
        masturbateConnections = {}
        
        local arm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
        if arm and arm:IsA("BasePart") then
            local t = 0
            local conn = runService.Heartbeat:Connect(function(dt)
                t = t + dt * masturbateSpeed
                if arm and arm.Parent then
                    arm.CFrame = arm.CFrame * CFrame.Angles(0, 0, math.sin(t * 4) * 1.2)
                end
            end)
            table.insert(masturbateConnections, conn)
        end
    end)
    
    -- 6. Трансформация в член
    createButton("🍆 Transform to Dick Model", 402, Color3.fromRGB(180, 60, 200), function()
        local targetName = kickInput.Text
        local target = players:FindFirstChild(targetName)
        if target and target.Character then
            local char = target.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local model = Instance.new("Model")
                model.Name = "DickModel"
                
                local part = Instance.new("Part")
                part.Size = Vector3.new(0.8, 2.8, 0.8)
                part.Shape = Enum.PartType.Cylinder
                part.BrickColor = BrickColor.new("Bright red")
                part.CFrame = root.CFrame
                part.Anchored = true
                part.Parent = model
                
                local part2 = Instance.new("Part")
                part2.Size = Vector3.new(1.4, 0.8, 1.4)
                part2.Shape = Enum.PartType.Ball
                part2.BrickColor = BrickColor.new("Bright red")
                part2.CFrame = root.CFrame * CFrame.new(0, 1.6, 0)
                part2.Anchored = true
                part2.Parent = model
                
                local part3 = Instance.new("Part")
                part3.Size = Vector3.new(0.6, 0.4, 0.6)
                part3.Shape = Enum.PartType.Ball
                part3.BrickColor = BrickColor.new("Bright red")
                part3.CFrame = root.CFrame * CFrame.new(0, -1.6, 0)
                part3.Anchored = true
                part3.Parent = model
                
                model.Parent = workspace
                char:BreakJoints()
                workspace.CurrentCamera.CameraSubject = part
            end
        end
    end)
    
    -- 7. Рэгдолл
    createButton("😩 Ragdoll Face on Crotch", 460, Color3.fromRGB(150, 80, 60), function()
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
    
    -- 8. Стоп
    createButton("⏹️ Stop All Animations", 518, Color3.fromRGB(80, 80, 80), function()
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
    
    -- 9. Скрыть всех игроков
    createButton("👻 Hide All Players", 576, Color3.fromRGB(80, 40, 120), function()
        for _, plr in pairs(players:GetPlayers()) do
            if plr ~= player and plr.Character then
                for _, v in pairs(plr.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.Transparency = 1
                    end
                    if v:IsA("Accessory") then
                        v.Handle.Transparency = 1
                    end
                end
            end
        end
    end)
    
    -- 10. Показать всех игроков
    createButton("👀 Show All Players", 632, Color3.fromRGB(40, 120, 80), function()
        for _, plr in pairs(players:GetPlayers()) do
            if plr ~= player and plr.Character then
                for _, v in pairs(plr.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.Transparency = 0
                    end
                    if v:IsA("Accessory") then
                        v.Handle.Transparency = 0
                    end
                end
            end
        end
    end)
    
    -- 11. Кнопка пересоздания (на всякий случай)
    createButton("🔄 Force Recreate Panel", 688, Color3.fromRGB(200, 100, 0), function()
        recreatePanel()
    end)
    
    -- Индикатор
    local pageIndicator = Instance.new("TextLabel")
    pageIndicator.Size = UDim2.new(1, 0, 0, 30)
    pageIndicator.Position = UDim2.new(0, 0, 1, -30)
    pageIndicator.BackgroundTransparency = 1
    pageIndicator.Text = "📄 FTAP IMMORTAL v4.0 | POWERED BY ROCKET WAY"
    pageIndicator.TextColor3 = Color3.fromRGB(255, 50, 150)
    pageIndicator.Font = Enum.Font.GothamBold
    pageIndicator.TextSize = 14
    pageIndicator.ZIndex = 9999
    pageIndicator.Parent = mainFrame
    
    -- Защита от удаления для новой панели
    protectFromDeletion()
    
    print("🚀 FTAP IMMORTAL v4.0 СОЗДАНА!")
    return gui
end

-- ===== СИСТЕМА 3: ПОСТОЯННЫЙ МОНИТОРИНГ =====
local function monitorPanel()
    spawn(function()
        while true do
            wait(0.5)
            local gui = player.PlayerGui:FindFirstChild("FTAP_Panel")
            if not gui then
                print("⚠️ Панель удалена! Пересоздаю...")
                recreatePanel()
            end
        end
    end)
end

-- ===== СИСТЕМА 4: ЗАЩИТА ОТ ОТКЛЮЧЕНИЯ =====
local function protectFromDisable()
    spawn(function()
        while true do
            wait(0.3)
            local gui = player.PlayerGui:FindFirstChild("FTAP_Panel")
            if gui and gui.Enabled == false then
                gui.Enabled = true
            end
        end
    end)
end

-- ===== СИСТЕМА 5: ПЕРЕХВАТ ПОТОКОВ =====
local function hijackThreads()
    local oldSpawn = spawn
    spawn = function(func)
        oldSpawn(function()
            while true do
                wait(0.1)
                local gui = player.PlayerGui:FindFirstChild("FTAP_Panel")
                if gui then
                    if not gui.Parent then
                        gui.Parent = player.PlayerGui
                    end
                end
                func()
            end
        end)
    end
end

-- ===== ЗАПУСК ВСЕХ СИСТЕМ =====
print("🚀 Активация FTAP IMMORTAL v4.0...")

-- Создаем первую панель
recreatePanel()

-- Запускаем мониторинг
monitorPanel()
protectFromDisable()
hijackThreads()

-- Дополнительная защита через Heartbeat
runService.Heartbeat:Connect(function()
    local gui = player.PlayerGui:FindFirstChild("FTAP_Panel")
    if gui then
        if not gui.Parent then
            gui.Parent = player.PlayerGui
        end
        gui.Enabled = true
    end
end)

print("🚀 FTAP IMMORTAL v4.0 АКТИВИРОВАНА НАВСЕГДА!")
