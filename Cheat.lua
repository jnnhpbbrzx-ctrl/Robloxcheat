-- ==========================================
-- ЛЕГКИЙ ИНТЕРФЕЙС БЕЗ ВНЕШНИХ БИБЛИОТЕК
-- ==========================================

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local SelectedPlayerName = nil

-- Создание компактного UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LightweightPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 260)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Panel (Lite Mode)"
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
ApplyBtn.Position = UDim2.new(0, 10, 1, -55)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ApplyBtn.Text = "Применить смещение"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.Font = Enum.Font.SourceSansBold
ApplyBtn.TextSize = 13
ApplyBtn.Parent = MainFrame

-- Окно уведомлений (выходит сбоку)
local NotifyFrame = Instance.new("Frame")
NotifyFrame.Size = UDim2.new(0, 220, 0, 50)
NotifyFrame.Position = UDim2.new(1, 10, 0, 0)
NotifyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NotifyFrame.BorderSizePixel = 0
NotifyFrame.Visible = false
NotifyFrame.Parent = MainFrame

local NotifyText = Instance.new("TextLabel")
NotifyText.Size = UDim2.new(1, -10, 1, 0)
NotifyText.Position = UDim2.new(0, 5, 0, 0)
NotifyText.BackgroundTransparency = 1
NotifyText.TextColor3 = Color3.fromRGB(255, 220, 100)
NotifyText.TextWrapped = true
NotifyText.TextSize = 12
NotifyText.Font = Enum.Font.SourceSans
NotifyText.Parent = NotifyFrame

local function ShowNotify(text)
    NotifyText.Text = text
    NotifyFrame.Visible = true
    task.delay(4, function()
        NotifyFrame.Visible = false
    end)
end

-- ==========================================
-- ОБНОВЛЕНИЕ СПИСКА ИГРОКОВ
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
RefreshList()

-- ==========================================
-- СМЕЩЕНИЕ КОСТЕЙ
-- ==========================================

ApplyBtn.MouseButton1Click:Connect(function()
    if not SelectedPlayerName then
        ShowNotify("Сначала выберите игрока из списка!")
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
                ShowNotify("Смещение применено к " .. target.Name)
            end
        end
    end
end)

-- ==========================================
-- БЕЗОПАСНЫЙ ANTI-AFK (БЕЗ НАГРУЗКИ)
-- ==========================================

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
end)

-- ==========================================
-- ДЕТЕКТОР ЛАГОВ И СПАМА
-- ==========================================

local lastCheck = tick()
local frameCount = 0

RunService.Heartbeat:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    
    -- Проверка раз в 3 секунды
    if now - lastCheck >= 3 then
        local fps = frameCount / (now - lastCheck)
        frameCount = 0
        lastCheck = now

        -- Если FPS падает ниже 20, ищем подозрительного игрока
        if fps < 20 then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    -- Если у игрока слишком много элементов в модели (спам частями/инструментами)
                    if #p.Character:GetDescendants() > 150 then
                        ShowNotify("Возможные лаги от: " .. p.Name .. " (Спам объектами)")
                        break
                    end
                end
            end
        end
    end
end)
