local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 1. СОЗДАНИЕ WINDOWS-ПОДОБНОГО ИНТЕРФЕЙСА
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WinClassicHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Серый цвет
MainFrame.BackgroundTransparency = 0.15 -- Слегка прозрачный
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
Title.Text = "Ultimate Injector - Windows Edition"
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
    btn.Size = UDim2.new(0, 112, 1, 0)
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
local Tab2Btn, Page2 = CreateTab("⚔️ FE Combat", false)
local Tab3Btn, Page3 = CreateTab("🎬 Анимации", false)
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

-- Вкладка 1: Таргет (Список игроков)
local TargetBox = Instance.new("TextBox")
TargetBox.Size = UDim2.new(1, 0, 0, 30)
TargetBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBox.PlaceholderText = "Введите часть ника игрока..."
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

-- Вкладка 2: FE Combat (Флинг / FE Кик / Anti-Grab)
local KickBtn = Instance.new("TextButton")
KickBtn.Size = UDim2.new(1, 0, 0, 35)
KickBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
KickBtn.Text = "FE Kick (Fling/Убить мишень)"
KickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KickBtn.Font = Enum.Font.SourceSansBold
KickBtn.TextSize = 14
KickBtn.Parent = Page2

KickBtn.MouseButton1Click:Connect(function()
    local target = GetPlayer(TargetBox.Text)
    if target and target.Character and LocalPlayer.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and myRoot then
            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "FlingSpin"
            Spin.Parent = myRoot
            Spin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            Spin.AngularVelocity = Vector3.new(0, 99999, 0)
            
            local oldPos = myRoot.CFrame
            for i = 1, 20 do
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 0)
                task.wait(0.05)
            end
            Spin:Destroy()
            myRoot.CFrame = oldPos
        end
    end
end)

local AntiGrabBtn = Instance.new("TextButton")
AntiGrabBtn.Size = UDim2.new(1, 0, 0, 35)
AntiGrabBtn.Position = UDim2.new(0, 0, 0, 45)
AntiGrabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
AntiGrabBtn.Text = "Включить Anti-Grab (Нельзя схватить)"
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
            if v:IsA("Weld") or v:IsA("WeldConstraint") then v:Destroy() end
        end
    end
end)

-- Вкладка 3: Анимации
local AnimBox = Instance.new("TextBox")
AnimBox.Size = UDim2.new(1, 0, 0, 30)
AnimBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AnimBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AnimBox.PlaceholderText = "Введите ID Анимации (например: 1827491)"
AnimBox.Text = ""
AnimBox.Parent = Page3

local PlayAnimBtn = Instance.new("TextButton")
PlayAnimBtn.Size = UDim2.new(1, 0, 0, 35)
PlayAnimBtn.Position = UDim2.new(0, 0, 0, 40)
PlayAnimBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
PlayAnimBtn.Text = "Воспроизвести"
PlayAnimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayAnimBtn.Font = Enum.Font.SourceSansBold
PlayAnimBtn.TextSize = 14
PlayAnimBtn.Parent = Page3

PlayAnimBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. AnimBox.Text
        local track = LocalPlayer.Character.Humanoid:LoadAnimation(anim)
        track:Play()
    end
end)

-- Вкладка 4: Разное (F10 Camera info)
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, 0, 1, 0)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Нажмите F10 для переключения 3-го лица\n(Обход принудительного 1-го лица)\n\nНажмите RIGHT SHIFT чтобы скрыть меню."
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.SourceSans
InfoText.TextSize = 14
InfoText.Parent = Page4

-- ==========================================
-- 4. ГЛОБАЛЬНЫЕ БИНДЫ (F10 и скрытие меню)
-- ==========================================
local isThirdPerson = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- F10: Принудительное 3 лицо (Обход фильтра камеры)
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
