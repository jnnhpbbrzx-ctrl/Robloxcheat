local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 1. СОЗДАНИЕ ОКНА (ПОВЕРХ ВСЕХ GUI И ИНВЕНТАРЯ)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateWindowsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999999 -- Гарантирует, что меню поверх всех окон и кнопок 'E'
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 360)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BackgroundTransparency = 0.15 -- Полупрозрачный серый стиль Windows
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Ultimate Control Panel [Fixed & Top Mode]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 14
Title.Parent = TopBar

-- ==========================================
-- 2. СИСТЕМА ВКЛАДОК (TABS)
-- ==========================================
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 32)
TabContainer.Position = UDim2.new(0, 0, 0, 28)
TabContainer.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
TabContainer.BorderSizePixel = 1
TabContainer.BorderColor3 = Color3.fromRGB(20, 20, 20)
TabContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = TabContainer

local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, 0, 1, -60)
Pages.Position = UDim2.new(0, 0, 0, 60)
Pages.BackgroundTransparency = 1
Pages.Parent = MainFrame

local function CreateTab(name, isFirst)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 125, 1, 0)
    btn.BackgroundColor3 = isFirst and Color3.fromRGB(65, 65, 65) or Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = TabContainer

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 250)
    page.Visible = isFirst
    page.Parent = Pages

    return btn, page
end

local Tab1Btn, Page1 = CreateTab("🎯 Таргет", true)
local Tab2Btn, Page2 = CreateTab("🛡️ Защита", false)
local Tab3Btn, Page3 = CreateTab("👁️ Детектор", false)
local Tab4Btn, Page4 = CreateTab("⚙️ Разное", false)

local tabs = { {Tab1Btn, Page1}, {Tab2Btn, Page2}, {Tab3Btn, Page3}, {Tab4Btn, Page4} }

for _, tabData in ipairs(tabs) do
    tabData[1].MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do
            t[1].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            t[2].Visible = false
        end
        tabData[1].BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        tabData[2].Visible = true
    end)
end

-- ==========================================
-- 3. НАПОЛНЕНИЕ ВКЛАДОК
-- ==========================================

-- Вкладка 1: Таргет (Выбор из списка)
local SelectedTargetName = nil

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, 0, 0, 20)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Список игроков на сервере:"
TargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetLabel.Font = Enum.Font.SourceSansBold
TargetLabel.TextSize = 13
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Parent = Page1

local PlayersScroll = Instance.new("ScrollingFrame")
PlayersScroll.Size = UDim2.new(1, 0, 0, 120)
PlayersScroll.Position = UDim2.new(0, 0, 0, 25)
PlayersScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayersScroll.BorderSizePixel = 1
PlayersScroll.Parent = Page1

local PlayersLayout = Instance.new("UIListLayout")
PlayersLayout.Parent = PlayersScroll
PlayersLayout.Padding = UDim.new(0, 2)

local function UpdatePlayerList()
    for _, child in ipairs(PlayersScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, 0, 0, 25)
            pBtn.BackgroundColor3 = (SelectedTargetName == p.Name) and Color3.fromRGB(70, 120, 170) or Color3.fromRGB(50, 50, 50)
            pBtn.Text = p.Name
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.TextSize = 13
            pBtn.Parent = PlayersScroll
            
            pBtn.MouseButton1Click:Connect(function()
                SelectedTargetName = p.Name
                UpdatePlayerList()
            end)
        end
    end
    PlayersScroll.CanvasSize = UDim2.new(0, 0, 0, PlayersLayout.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

local RefreshPlayersBtn = Instance.new("TextButton")
RefreshPlayersBtn.Size = UDim2.new(1, 0, 0, 30)
RefreshPlayersBtn.Position = UDim2.new(0, 0, 0, 155)
RefreshPlayersBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
RefreshPlayersBtn.Text = "Обновить список"
RefreshPlayersBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshPlayersBtn.Font = Enum.Font.SourceSansBold
RefreshPlayersBtn.TextSize = 13
RefreshPlayersBtn.Parent = Page1

RefreshPlayersBtn.MouseButton1Click:Connect(UpdatePlayerList)

local ApplyPosBtn = Instance.new("TextButton")
ApplyPosBtn.Size = UDim2.new(1, 0, 0, 35)
ApplyPosBtn.Position = UDim2.new(0, 0, 0, 195)
ApplyPosBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
ApplyPosBtn.Text = "Сместить голову цели к паху"
ApplyPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyPosBtn.Font = Enum.Font.SourceSansBold
ApplyPosBtn.TextSize = 13
ApplyPosBtn.Parent = Page1

ApplyPosBtn.MouseButton1Click:Connect(function()
    if not SelectedTargetName then return end
    local target = Players:FindFirstChild(SelectedTargetName)
    if target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        local torso = target.Character:FindFirstChild("LowerTorso") or target.Character:FindFirstChild("Torso")
        local neck = head and head:FindFirstChildOfClass("Motor6D")
        if neck and torso then
            neck.C0 = CFrame.new(0, -1.2, -0.5) * CFrame.Angles(math.rad(90), 0, 0)
        end
    end
end)


-- Вкладка 2: Защита (Мощный Anti-Grab и Anti-AFK)
local AntiGrabStatus = false
local AntiGrabBtn = Instance.new("TextButton")
AntiGrabBtn.Size = UDim2.new(1, 0, 0, 35)
AntiGrabBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AntiGrabBtn.Text = "Anti-Grab [ВЫКЛ]"
AntiGrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiGrabBtn.Font = Enum.Font.SourceSansBold
AntiGrabBtn.TextSize = 14
AntiGrabBtn.Parent = Page2

AntiGrabBtn.MouseButton1Click:Connect(function()
    AntiGrabStatus = not AntiGrabStatus
    AntiGrabBtn.Text = AntiGrabStatus and "Anti-Grab [ВКЛ]" or "Anti-Grab [ВЫКЛ]"
    AntiGrabBtn.BackgroundColor3 = AntiGrabStatus and Color3.fromRGB(50, 130, 50) or Color3.fromRGB(70, 70, 70)
end)

-- Улучшенный цикл Anti-Grab: мгновенно уничтожает захваты и чужие привязки
RunService.Stepped:Connect(function()
    if AntiGrabStatus and LocalPlayer.Character then
        for _, obj in ipairs(LocalPlayer.Character:GetDescendants()) do
            if obj:IsA("Weld") or obj:IsA("WeldConstraint") or obj:IsA("RopeConstraint") or obj:IsA("TouchTransmitter") then
                -- Удаляем всё, что пытается связать вас с чужими руками или предметами
                if obj.Parent ~= LocalPlayer.Character then
                    obj:Destroy()
                end
            end
        end
    end
end)

-- Anti-AFK
local AntiAfkBtn = Instance.new("TextButton")
AntiAfkBtn.Size = UDim2.new(1, 0, 0, 35)
AntiAfkBtn.Position = UDim2.new(0, 0, 0, 45)
AntiAfkBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 50)
AntiAfkBtn.Text = "Anti-AFK [ВКЛ]"
AntiAfkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkBtn.Font = Enum.Font.SourceSansBold
AntiAfkBtn.TextSize = 14
AntiAfkBtn.Parent = Page2

local antiAfkActive = true
AntiAfkBtn.MouseButton1Click:Connect(function()
    antiAfkActive = not antiAfkActive
    AntiAfkBtn.Text = antiAfkActive and "Anti-AFK [ВКЛ]" or "Anti-AFK [ВЫКЛ]"
    AntiAfkBtn.BackgroundColor3 = antiAfkActive and Color3.fromRGB(50, 130, 50) or Color3.fromRGB(70, 70, 70)
end)

LocalPlayer.Idled:Connect(function()
    if antiAfkActive then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)


-- Вкладка 3: Детектор (Анти-лаг от читеров/спамеров)
local DetectorLabel = Instance.new("TextLabel")
DetectorLabel.Size = UDim2.new(1, 0, 0, 40)
DetectorLabel.BackgroundTransparency = 1
DetectorLabel.Text = "Автоматически выводит в чат/уведомление ник того, кто устраивает лаги на сервере."
DetectorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
DetectorLabel.Font = Enum.Font.SourceSans
DetectorLabel.TextSize = 13
DetectorLabel.TextWrapped = true
DetectorLabel.Parent = Page3

local AlertBox = Instance.new("TextLabel")
AlertBox.Size = UDim2.new(1, 0, 0, 60)
AlertBox.Position = UDim2.new(0, 0, 0, 50)
AlertBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AlertBox.TextColor3 = Color3.fromRGB(255, 200, 50)
AlertBox.Text = "Статус детектора: Активен (Сканирует...)"
AlertBox.Font = Enum.Font.SourceSansBold
AlertBox.TextSize = 12
AlertBox.TextWrapped = true
AlertBox.Parent = Page3

task.spawn(function()
    while true do
        task.wait(3)
        local fps = workspace:GetRealPhysicsFPS()
        if fps < 25 then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local count = #p.Character:GetDescendants()
                    if count > 120 then
                        AlertBox.Text = "ВНИМАНИЕ ЛАГИ!\nИгрок: " .p.Name .." спамит объектами ("..count..")"
                    end
                end
            end
        else
            AlertBox.Text = "Статус детектора: Сервер стабилен (FPS: "..math.floor(fps)..")"
        end
    end
end)


-- Вкладка 4: Разное (Камера и управление)
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, 0, 1, 0)
InfoText.BackgroundTransparency = 1
InfoText.Text = "• Нажмите F10 для обхода вида от 3-го лица\n• Нажмите Right Shift чтобы скрыть/открыть меню\n• Окно закреплено поверх всех меню и инвентаря"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.SourceSans
InfoText.TextSize = 13
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.Parent = Page4


-- ==========================================
-- 4. ГЛОБАЛЬНЫЕ КЛАВИШИ БИНДЫ
-- ==========================================
local isThirdPerson = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- F10: Принудительное 3 лицо (Обход камеры)
    if input.KeyCode == Enum.KeyCode.F10 then
        if LocalPlayer.Character then
            isThirdPerson = not isThirdPerson
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = isThirdPerson and 128 or 0.5
            LocalPlayer.CameraMinZoomDistance = isThirdPerson and 10 or 0.5
        end
    end
    
    -- Right Shift: Скрыть/Показать окно
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
