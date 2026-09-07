local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local SelectedPlayerName = nil

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LightweightPanel_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Кнопка сворачивания/разворачивания панели (Всегда видна на экране)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Text = "Панель"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = ScreenGui

-- Главный контейнер
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 310)
MainFrame.Position = UDim2.new(0.05, 90, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Логика скрытия/открытия
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Control Panel (Lite)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Список игроков
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 0, 120)
ScrollFrame.Position = UDim2.new(0, 10, 0, 40)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = ScrollFrame
UIList.Padding = UDim.new(0, 3)

-- Кнопка действия
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(1, -20, 0, 35)
ApplyBtn.Position = UDim2.new(0, 10, 0, 170)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ApplyBtn.Text = "Применить смещение"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.Font = Enum.Font.SourceSansBold
ApplyBtn.TextSize = 13
ApplyBtn.Parent = MainFrame

-- Встроенная плашка уведомлений (Находится внутри самой панели)
local NotifyBox = Instance.new("TextLabel")
NotifyBox.Size = UDim2.new(1, -20, 0, 85)
NotifyBox.Position = UDim2.new(0, 10, 0, 215)
NotifyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
NotifyBox.BorderSizePixel = 0
NotifyBox.TextColor3 = Color3.fromRGB(255, 220, 100)
NotifyBox.TextWrapped = true
NotifyBox.TextSize = 11
NotifyBox.Font = Enum.Font.SourceSans
NotifyBox.Text = "Статус: Готов к работе."
NotifyBox.Parent = MainFrame

local function SetStatus(text)
    NotifyBox.Text = text
end

-- ==========================================
-- ОБНОВЛЕНИЕ СПИСКА ИГРОКОВ (БЕЗ ФРИЗОВ)
-- ==========================================

local function RefreshList()
    for _, item in ipairs(ScrollFrame:GetChildren()) do
        if item:IsA("TextButton") then
            item:Destroy()
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 22)
            btn.BackgroundColor3 = (SelectedPlayerName == p.Name) and Color3.fromRGB(70, 120, 180) or Color3.fromRGB(55, 55, 55)
            btn.Text = p.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 12
            btn.Font = Enum.Font.SourceSans
            btn.Parent = ScrollFrame

            btn.MouseButton1Click:Connect(function()
                SelectedPlayerName = p.Name
                RefreshList()
            end)
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(RefreshList)
Players.PlayerRemoving:Connect(RefreshList)

-- Отложенный первый запуск обновления списка для исключения старт-фриза
task.defer(RefreshList)

-- ==========================================
-- СМЕЩЕНИЕ КОСТЕЙ
-- ==========================================

ApplyBtn.MouseButton1Click:Connect(function()
    if not SelectedPlayerName then
        SetStatus("Ошибка: Сначала выберите игрока из списка!")
        return
    end

    local target = Players:FindFirstChild(SelectedPlayerName)
    if target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        local torso = target.Character:FindFirstChild("LowerTorso") or target.Character:FindFirstChild("Torso")
        
        if head and torso then
            local neck = head:FindFirstChildOfClass("Motor6D")
            if neck then
                neck.C0 = CFrame.new(0, -1.2, -0.5) * CFrame.Angles(math.rad(90), 0, 0)
                SetStatus("Успешно: Смещение применено к " .. target.Name)
            end
        end
    else
        SetStatus("Ошибка: Модель игрока не найдена!")
    end
end)

-- ==========================================
-- ANTI-AFK
-- ==========================================

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
end)

-- ==========================================
-- ЛЕГКИЙ ДЕТЕКТОР ЛАГОВ (БЕЗ НАГРУЗКИ)
-- ==========================================

task.spawn(function()
    while task.wait(5) do
        local fps = workspace:GetRealPhysicsFPS()
        if fps < 25 then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    -- Проверка количества предметов без глубокого рекурсивного перебора
                    local partsCount = #p.Character:GetChildren()
                    if partsCount > 50 then
                        SetStatus("Внимание: Возможные лаги от " .. p.Name .. " (много объектов)")
                        break
                    end
                end
            end
        end
    end
end)
