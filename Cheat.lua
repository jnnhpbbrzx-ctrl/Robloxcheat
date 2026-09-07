-- ==============================================================================
-- ULTIMATE WINDOWS CLASSIC HUB (ROBLOX LUA SCRIPT)
-- Интерфейс создается по центру строго поверх всех GUI и инвентаря.
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Защита от дублирования скрипта
if LocalPlayer.PlayerGui:FindFirstChild("UltimateWindowsHub") then
    LocalPlayer.PlayerGui.UltimateWindowsHub:Destroy()
end

-- ==========================================
-- 1. ГЛАВНОЕ ОКНО (ПОВЕРХ ВСЕХ GUI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateWindowsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999999 -- Выше любых внутриигровых меню, инвентаря и кнопок 'E'
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190) -- Центр экрана
MainFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
MainFrame.BackgroundTransparency = 0.15 -- Полупрозрачный серый стиль Windows
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(24, 24, 24)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Верхняя панель заголовка
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💻 Windows Classic Control Panel [v3.0 Ultimate]"
Title.TextColor3 = Color3.fromRGB(230, 230, 230)
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 14
Title.Parent = TopBar

-- ==========================================
-- 2. СИСТЕМА ВКЛАДОК НА ИКОНКАХ С АНИМАЦИЕЙ
-- ==========================================
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 36)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabContainer.BorderSizePixel = 1
TabContainer.BorderColor3 = Color3.fromRGB(20, 20, 20)
TabContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = TabContainer

local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, 0, 1, -66)
PagesContainer.Position = UDim2.new(0, 0, 0, 66)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local tabs = {}
local pages = {}

local function CreateTab(iconName, tabIndex)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 1, 0)
    btn.BackgroundColor3 = (tabIndex == 1) and Color3.fromRGB(65, 65, 65) or Color3.fromRGB(42, 42, 42)
    btn.Text = iconName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = TabContainer

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Position = UDim2.new(0, 0, 0, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 350)
    page.ScrollBarThickness = 4
    page.Visible = (tabIndex == 1)
    page.Parent = PagesContainer

    table.insert(tabs, btn)
    table.insert(pages, page)

    btn.MouseButton1Click:Connect(function()
        for i, tBtn in ipairs(tabs) do
            TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}):Play()
            pages[i].Visible = false
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}):Play()
        page.Visible = true
    end)

    return page
end

local Page1 = CreateTab("🎯 Таргет", 1)
local Page2 = CreateTab("🛡️ Защита", 2)
local Page3 = CreateTab("👁️ Детектор", 3)
local Page4 = CreateTab("⚙️ Разное", 4)


-- ==============================================================================
-- 3. СОДЕРЖИМОЕ ВКЛАДОК (ФУНКЦИОНАЛ)
-- ==============================================================================

-- --- ВКЛАДКА 1: ТАРГЕТ И ИГРОКИ ---
local SelectedTargetName = nil

local TargetTitle = Instance.new("TextLabel")
TargetTitle.Size = UDim2.new(1, -20, 0, 20)
TargetTitle.Position = UDim2.new(0, 10, 0, 10)
TargetTitle.BackgroundTransparency = 1
TargetTitle.Text = "Выберите жертву из списка сервера:"
TargetTitle.TextColor3 = Color3.fromRGB(210, 210, 210)
TargetTitle.Font = Enum.Font.SourceSansBold
TargetTitle.TextSize = 13
TargetTitle.TextXAlignment = Enum.TextXAlignment.Left
TargetTitle.Parent = Page1

local PlayersScroll = Instance.new("ScrollingFrame")
PlayersScroll.Size = UDim2.new(1, -20, 0, 120)
PlayersScroll.Position = UDim2.new(0, 10, 0, 35)
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
            pBtn.Size = UDim2.new(1, 0, 0, 26)
            pBtn.BackgroundColor3 = (SelectedTargetName == p.Name) and Color3.fromRGB(70, 110, 160) or Color3.fromRGB(50, 50, 50)
            pBtn.Text = "  " .. p.Name
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.TextSize = 13
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
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

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, -20, 0, 30)
RefreshBtn.Position = UDim2.new(0, 10, 0, 165)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
RefreshBtn.Text = "🔄 Обновить список игроков"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 13
RefreshBtn.Parent = Page1
RefreshBtn.MouseButton1Click:Connect(UpdatePlayerList)

local ApplyPosBtn = Instance.new("TextButton")
ApplyPosBtn.Size = UDim2.new(1, -20, 0, 35)
ApplyPosBtn.Position = UDim2.new(0, 10, 0, 205)
ApplyPosBtn.BackgroundColor3 = Color3.fromRGB(120, 45, 45)
ApplyPosBtn.Text = "💥 Сместить голову цели к паху"
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


-- --- ВКЛАДКА 2: ЗАЩИТА (Anti-Grab & Anti-AFK) ---
local AntiGrabActive = false
local AntiGrabBtn = Instance.new("TextButton")
AntiGrabBtn.Size = UDim2.new(1, -20, 0, 38)
AntiGrabBtn.Position = UDim2.new(0, 10, 0, 15)
AntiGrabBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
AntiGrabBtn.Text = "🛡️ Anti-Grab [ВЫКЛ]"
AntiGrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiGrabBtn.Font = Enum.Font.SourceSansBold
AntiGrabBtn.TextSize = 14
AntiGrabBtn.Parent = Page2

AntiGrabBtn.MouseButton1Click:Connect(function()
    AntiGrabActive = not AntiGrabActive
    AntiGrabBtn.Text = AntiGrabActive and "🛡️ Anti-Grab [ВКЛ]" or "🛡️ Anti-Grab [ВЫКЛ]"
    AntiGrabBtn.BackgroundColor3 = AntiGrabActive and Color3.fromRGB(45, 120, 45) or Color3.fromRGB(75, 75, 75)
end)

RunService.Stepped:Connect(function()
    if AntiGrabActive and LocalPlayer.Character then
        for _, obj in ipairs(LocalPlayer.Character:GetDescendants()) do
            if obj:IsA("Weld") or obj:IsA("WeldConstraint") or obj:IsA("RopeConstraint") or obj:IsA("TouchTransmitter") then
                if obj.Parent ~= LocalPlayer.Character then
                    obj:Destroy()
                end
            end
        end
    end
end)

local AntiAfkActive = true
local AntiAfkBtn = Instance.new("TextButton")
AntiAfkBtn.Size = UDim2.new(1, -20, 0, 38)
AntiAfkBtn.Position = UDim2.new(0, 10, 0, 65)
AntiAfkBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 45)
AntiAfkBtn.Text = "⏰ Anti-AFK [ВКЛ]"
AntiAfkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkBtn.Font = Enum.Font.SourceSansBold
AntiAfkBtn.TextSize = 14
AntiAfkBtn.Parent = Page2

AntiAfkBtn.MouseButton1Click:Connect(function()
    AntiAfkActive = not AntiAfkActive
    AntiAfkBtn.Text = AntiAfkActive and "⏰ Anti-AFK [ВКЛ]" or "⏰ Anti-AFK [ВЫКЛ]"
    AntiAfkBtn.BackgroundColor3 = AntiAfkActive and Color3.fromRGB(45, 120, 45) or Color3.fromRGB(75, 75, 75)
end)

LocalPlayer.Idled:Connect(function()
    if AntiAfkActive then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)


-- --- ВКЛАДКА 3: ДЕТЕКТОР ЛАГОВ И ЧИТЕРОВ ---
local DetectorInfo = Instance.new("TextLabel")
DetectorInfo.Size = UDim2.new(1, -20, 0, 50)
DetectorInfo.Position = UDim2.new(0, 10, 0, 10)
DetectorInfo.BackgroundTransparency = 1
DetectorInfo.Text = "Автоматический сканер производительности. Находит игроков, устраивающих нагрузку на сервере."
DetectorInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
DetectorInfo.Font = Enum.Font.SourceSans
DetectorInfo.TextSize = 13
DetectorInfo.TextWrapped = true
DetectorInfo.TextXAlignment = Enum.TextXAlignment.Left
DetectorInfo.Parent = Page3

local DetectorStatusBox = Instance.new("TextLabel")
DetectorStatusBox.Size = UDim2.new(1, -20, 0, 70)
DetectorStatusBox.Position = UDim2.new(0, 10, 0, 70)
DetectorStatusBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DetectorStatusBox.TextColor3 = Color3.fromRGB(255, 210, 60)
DetectorStatusBox.Text = "Статус: Сканирование сети...\nFPS в норме."
DetectorStatusBox.Font = Enum.Font.SourceSansBold
DetectorStatusBox.TextSize = 13
DetectorStatusBox.TextWrapped = true
DetectorStatusBox.Parent = Page3

task.spawn(function()
    while true do
        task.wait(3)
        local fps = workspace:GetRealPhysicsFPS()
        if fps < 26 then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local count = #p.Character:GetDescendants()
                    if count > 140 then
                        DetectorStatusBox.Text = "⚠️ ОБНАРУЖЕН ЛАГЕР!\nИгрок: " .. p.Name .. " спамит деталями ("..count..")"
                    end
                end
            end
        else
            DetectorStatusBox.Text = "Статус: Сервер стабилен\nТекущий FPS: " .. math.floor(fps)
        end
    end
end)


-- --- ВКЛАДКА 4: РАЗНОЕ И СИСТЕМНЫЕ КНОПКИ ---
local InfoHelp = Instance.new("TextLabel")
InfoHelp.Size = UDim2.new(1, -20, 0, 150)
InfoHelp.Position = UDim2.new(0, 10, 0, 10)
InfoHelp.BackgroundTransparency = 1
InfoHelp.Text = "📌 ГОРЯЧИЕ КЛАВИШИ И ПРАВИЛА:\n\n• [F10] — Обход фиксации камеры (Принудительное 3-е лицо / Снятие ограничения зума).\n• [Right Shift] — Полное скрытие / открытие этого окна.\n\nИнтерфейс работает в режиме 'Always on Top', поэтому он виден поверх любых встроенных меню игры."
InfoHelp.TextColor3 = Color3.fromRGB(210, 210, 210)
InfoHelp.Font = Enum.Font.SourceSans
InfoHelp.TextSize = 13
InfoHelp.TextXAlignment = Enum.TextXAlignment.Left
InfoHelp.TextYAlignment = Enum.TextYAlignment.Top
InfoHelp.TextWrapped = true
InfoHelp.Parent = Page4


-- ==============================================================================
-- 4. ГЛОБАЛЬНЫЕ БИНДЫ КЛАВИШ (F10 и Right Shift)
-- ==============================================================================
local isThirdPerson = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- F10: Принудительное 3-е лицо (Обход локального вида)
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
