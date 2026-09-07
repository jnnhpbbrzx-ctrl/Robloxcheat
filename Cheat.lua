-- Загрузка Fluent UI (Красивый интерфейс с анимациями)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Создание главного окна
local Window = Fluent:CreateWindow({
    Title = "FTAP Ultimate Hub",
    SubTitle = "Target, Exploits & Defense",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Создание вкладок
local Tabs = {
    Main = Window:AddTab({ Title = "Основное (Цель)", Icon = "user" }),
    Combat = Window:AddTab({ Title = "Функции FTAP", Icon = "zap" }),
    Protection = Window:AddTab({ Title = "Защита", Icon = "shield" }),
    Detection = Window:AddTab({ Title = "Детектор", Icon = "eye" })
}

local Services = {
    Players = game:GetService("Players"),
    VirtualUser = game:GetService("VirtualUser"),
    RunService = game:GetService("RunService"),
    Workspace = game:GetService("Workspace")
}

local LocalPlayer = Services.Players.LocalPlayer
local SelectedPlayerName = nil

-- Функция получения списка игроков
local function GetPlayerNames()
    local names = {}
    for _, p in ipairs(Services.Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

-- ==========================================
-- ВКЛАДКА 1: ОСНОВНОЕ (Выбор цели)
-- ==========================================

local PlayerDropdown = Tabs.Main:AddDropdown("TargetSelect", {
    Title = "Выберите цель из списка",
    Values = GetPlayerNames(),
    Multi = false,
    Default = nil,
})

PlayerDropdown:OnChanged(function(Value)
    SelectedPlayerName = Value
end)

Tabs.Main:AddButton({
    Title = "Обновить список игроков",
    Callback = function()
        PlayerDropdown:SetValues(GetPlayerNames())
        Fluent:Notify({ Title = "Успешно", Content = "Список игроков обновлен!", Duration = 2 })
    end
})

Tabs.Main:AddButton({
    Title = "Сместить голову к паху мишени",
    Callback = function()
        if not SelectedPlayerName then
            Fluent:Notify({ Title = "Ошибка", Content = "Сначала выберите игрока из списка!", Duration = 3 })
            return
        end

        local target = Services.Players:FindFirstChild(SelectedPlayerName)
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            local torso = target.Character:FindFirstChild("LowerTorso") or target.Character:FindFirstChild("Torso")
            
            if head and torso then
                local neck = head:FindFirstChildOfClass("Motor6D")
                if neck then
                    neck.C0 = CFrame.new(0, -1.2, -0.5) * CFrame.Angles(math.rad(90), 0, 0)
                    Fluent:Notify({ Title = "Успешно", Content = "Смещение применилось к " .. target.Name, Duration = 3 })
                end
            end
        else
            Fluent:Notify({ Title = "Ошибка", Content = "Персонаж мишени не найден!", Duration = 3 })
        end
    end
})

-- ==========================================
-- ВКЛАДКА 2: ФУНКЦИИ FTAP (Супер-бросок, Anti-Grab)
-- ==========================================

-- 1. Anti-Grab (Защита от захвата)
local AntiGrabToggle = Tabs.Combat:AddToggle("AntiGrab", { Title = "Anti-Grab (Нельзя схватить)", Default = false })

Services.RunService.Stepped:Connect(function()
    if AntiGrabToggle.Value and LocalPlayer.Character then
        for _, child in ipairs(LocalPlayer.Character:GetChildren()) do
            -- Удаляем физические связки, если вас кто-то пытается схватить
            if child:IsA("WeldConstraint") or child:IsA("Weld") or child:IsA("RopeConstraint") then
                child:Destroy()
            end
        end
    end
end)

-- 2. Супер-сила броска (Усиление импульса предметов/людей)
local SuperThrowToggle = Tabs.Combat:AddToggle("SuperThrow", { Title = "Супер-сила физики (Super Push)", Default = false })

Services.RunService.RenderStepped:Connect(function()
    if SuperThrowToggle.Value and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            -- Добавляет физический импульс при толкании предметов и людей
            root.Velocity = root.Velocity * 1.05
        end
    end
end)

-- ==========================================
-- ВКЛАДКА 3: ЗАЩИТА (Anti-AFK, Anti-Kick, Anti-Exploit)
-- ==========================================

-- 1. Anti-AFK
local AntiAFKToggle = Tabs.Protection:AddToggle("AntiAFK", { Title = "Anti-AFK (Защита от таймаута)", Default = true })

LocalPlayer.Idled:Connect(function()
    if AntiAFKToggle.Value then
        Services.VirtualUser:CaptureController()
        Services.VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)

-- 2. Anti-Kick Protection (Авто-респавн и защита)
local AntiKickToggle = Tabs.Protection:AddToggle("AntiKick", { Title = "Anti-Kick & Auto-Respawn", Default = true })

-- Безопасный респавн при попытке взаимодействия с нежелательными скриптами
local function TriggerRespawn()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
    end
end

-- ==========================================
-- ВКЛАДКА 4: ДЕТЕКТОР ЛАГОВ
-- ==========================================

local LagDetectorToggle = Tabs.Detection:AddToggle("LagDetector", { Title = "Мониторинг лагов на сервере", Default = true })

task.spawn(function()
    while true do
        task.wait(4)
        if LagDetectorToggle.Value then
            local fps = Services.Workspace:GetRealPhysicsFPS()
            if fps < 22 then
                for _, p in ipairs(Services.Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and #p.Character:GetChildren() > 40 then
                        Fluent:Notify({
                            Title = "Детектор лагов",
                            Content = "Возможный лагер: " .. p.Name .. " (Спам объектами)",
                            Duration = 4
                        })
                        break
                    end
                end
            end
        end
    end
end)

-- Авто-обновление списков
Services.Players.PlayerAdded:Connect(function() PlayerDropdown:SetValues(GetPlayerNames()) end)
Services.Players.PlayerRemoving:Connect(function() PlayerDropdown:SetValues(GetPlayerNames()) end)

Fluent:Notify({
    Title = "FTAP Hub Загружен!",
    Content = "Нажмите Left Control, чтобы скрыть или открыть панель.",
    Duration = 5
})
