local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 1. СОЗДАНИЕ ОКНА (С ПОЗИЦИЕЙ ПОВЕРХ ВСЕХ GUI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WinClassicHub_Top"
ScreenGui.ResetOnSpawn = false
-- Выставляем максимальный слой, чтобы меню было поверх любых инвентарей и меню игры
ScreenGui.DisplayOrder = 999999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Классический серо-темный цвет
MainFrame.BackgroundTransparency = 0.15 -- Слегка прозрачное
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Windows Control Panel [Always on Top]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 14
Title.Parent = TopBar

-- ==========================================
-- 2. СИСТЕМА ВКЛАДОК (TABS)
-- ==========================================
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 25)
TabContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TabContainer.BorderSizePixel = 1
TabContainer.BorderColor3 = Color3.fromRGB(30, 30, 30)
TabContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = TabContainer

local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, 0, 1, -55)
Pages.Position = UDim2.new(0, 0, 0, 55)
Pages.BackgroundTransparency = 1
Pages.Parent = MainFrame

local function CreateTab(name, isFirst)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.BackgroundColor3 = isFirst and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = TabContainer

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.Visible = isFirst
    page.Parent = Pages

    return btn, page
end

local Tab1Btn, Page1 = CreateTab("🎯 Таргет", true)
local Tab2Btn, Page2 = CreateTab("⚔️ Функции", false)
local Tab3Btn, Page3 = CreateTab("📦 Предметы", false)
local Tab4Btn, Page4 = CreateTab("⚙️ Разное", false)

local tabs = { {Tab1Btn, Page1}, {Tab2Btn, Page2}, {Tab3Btn, Page3}, {Tab4Btn, Page4} }

for _, tabData in ipairs(tabs) do
    tabData[1].MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do
            t[1].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            t[2].Visible = false
        end
        tabData[1].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        tabData[2].Visible = true
    end)
end

-- ==========================================
-- 3. СОДЕРЖИМОЕ ВКЛАДОК
-- ==========================================

-- Вкладка 1: Таргет
local TargetBox = Instance.new("TextBox")
TargetBox.Size = UDim2.new(1, 0, 0, 30)
TargetBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBox.PlaceholderText = "Введите ник игрока..."
TargetBox.Text = ""
TargetBox.Parent = Page1

local ApplyPosBtn = Instance.new("TextButton")
ApplyPosBtn.Size = UDim2.new(1, 0, 0, 35)
ApplyPosBtn.Position = UDim2.new(0, 0, 0, 40)
ApplyPosBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ApplyPosBtn.Text = "Сместить голову к паху"
ApplyPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyPosBtn.Font = Enum.Font.SourceSansBold
ApplyPosBtn.TextSize = 14
ApplyPosBtn.Parent = Page1

local function GetPlayer(str)
    for _, p in ipairs(Players:GetPlayers()) do
        if string.lower(string.sub(p.Name, 1, #str)) == string.lower(str) then return p end
    end
end

ApplyPosBtn.MouseButton1Click:Connect(function()
    local target = GetPlayer(TargetBox.Text)
    if target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        local torso = target.Character:FindFirstChild("LowerTorso") or target.Character:FindFirstChild("Torso")
        local neck = head and head:FindFirstChildOfClass("Motor6D")
        if neck and torso then
            neck.C0 = CFrame.new(0, -1.2, -0.5) * CFrame.Angles(math.rad(90), 0, 0)
        end
    end
end)

-- Вкладка 2: Функции (Anti-Grab и физика)
local AntiGrabBtn = Instance.new("TextButton")
AntiGrabBtn.Size = UDim2.new(1, 0, 0, 35)
AntiGrabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
AntiGrabBtn.Text = "Anti-Grab [ВЫКЛ]"
AntiGrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiGrabBtn.Font = Enum.Font.SourceSansBold
AntiGrabBtn.TextSize = 14
AntiGrabBtn.Parent = Page2

local antiGrabActive = false
AntiGrabBtn.MouseButton1Click:Connect(function()
    antiGrabActive = not antiGrabActive
    AntiGrabBtn.Text = antiGrabActive and "Anti-Grab [ВКЛ]" or "Anti-Grab [ВЫКЛ]"
end)

RunService.RenderStepped:Connect(function()
    if antiGrabActive and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("Weld") or v:IsA("WeldConstraint") or v:IsA("RopeConstraint") then v:Destroy() end
        end
    end
end)

-- Вкладка 3: Предметы (Взаимодействие с инвентарем / экипировкой)
local ItemInfo = Instance.new("TextLabel")
ItemInfo.Size = UDim2.new(1, 0, 0, 50)
ItemInfo.BackgroundTransparency = 1
ItemInfo.Text = "Управление предметами в руках:\n(Скрипт проверяет активный инструмент Backpack)"
ItemInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
ItemInfo.Font = Enum.Font.SourceSans
ItemInfo.TextSize = 13
ItemInfo.Parent = Page3

local EquipToolBtn = Instance.new("TextButton")
EquipToolBtn.Size = UDim2.new(1, 0, 0, 35)
EquipToolBtn.Position = UDim2.new(0, 0, 0, 60)
EquipToolBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
EquipToolBtn.Text = "Взять первый предмет из рюкзака в руку"
EquipToolBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EquipToolBtn.Font = Enum.Font.SourceSansBold
EquipToolBtn.TextSize = 13
EquipToolBtn.Parent = Page3

EquipToolBtn.MouseButton1Click:Connect(function()
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if backpack and humanoid then
        local tool = backpack:FindFirstChildOfClass("Tool")
        if tool then
            humanoid:EquipTool(tool)
        end
    end
end)

-- Вкладка 4: Разное (Камера и скрытие)
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, 0, 1, 0)
InfoText.BackgroundTransparency = 1
InfoText.Text = "• Нажмите F10 для обхода вида от 3-го лица\n• Нажмите Right Shift чтобы скрыть/открыть окно\n• Окно всегда поверх остальных элементов игры"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.SourceSans
InfoText.TextSize = 13
InfoText.Parent = Page4

-- ==========================================
-- 4. ГЛОБАЛЬНЫЕ БИНДЫ
-- ==========================================
local isThirdPerson = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- F10: Принудительное 3 лицо
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
