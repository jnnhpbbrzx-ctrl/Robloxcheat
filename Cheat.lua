-- Загрузка библиотеки Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Создание главного окна
local Window = Fluent:CreateWindow({
    Title = "Ultimate Control Panel",
    SubTitle = "Main, Protection & Utilities",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 480),
    Theme = "Dark"
})

-- Создание вкладок
local Tabs = {
    Main = Window:AddTab({ Title = "Основное", Icon = "user" }),
    Protection = Window:AddTab({ Title = "Защита", Icon = "shield" }),
    Detection = Window:AddTab({ Title = "Детектор", Icon = "eye" })
}

local Services = {
    Players = game:GetService("Players"),
    VirtualUser = game:GetService("VirtualUser"),
    RunService = game:GetService("RunService")
}

local LocalPlayer = Services.Players.LocalPlayer
local SelectedPlayerName = nil

-- Глобальные флаги настроек
_G.AntiAFKEnabled = true
_G.AntiKickEnabled = true
_G.AutoRespawnOnKick = true
_G.ExploitGuardEnabled = true
_G.MonitorLag = false

-- ==========================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ==========================================

-- Получение списка имен всех игроков, кроме себя
local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

-- Функция принудительного респавна персонажа
local function TriggerRespawn()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        end
        LocalPlayer.Character:ClearAllChildren()
    end
end

-- ==========================================
-- ВКЛАДКА: ОСНОВНОЕ (Выбор цели и таргетинг)
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
        Fluent:Notify({ Title = "Список обновлен", Content = "Текущий список игроков перезагружен.", Duration = 2 })
    end
})

Tabs.Main:AddButton({
    Title = "Применить смещение к цели",
    Callback = function()
        if not SelectedPlayerName then
            Fluent:Notify({ Title = "Ошибка", Content = "Сначала выберите игрока из списка!", Duration = 3 })
            return
        end

        local targetPlayer = Services.Players:FindFirstChild(SelectedPlayerName)
        if not targetPlayer or not targetPlayer.Character then
            Fluent:Notify({ Title = "Ошибка", Content = "Персонаж мишени не найден!", Duration = 3 })
            return
        end

        local head = targetPlayer.Character:FindFirstChild("Head")
        local torso = targetPlayer.Character:FindFirstChild("LowerTorso") or targetPlayer.Character:FindFirstChild("Torso")

        if head and torso then
            local neck = head:FindFirstChildOfClass("Motor6D")
            if neck then
                -- Локальное смещение кости головы к области паха/торса
                neck.C0 = CFrame.new(0, -1.2, -0.5) * CFrame.Angles(math.rad(90), 0, 0)
                Fluent:Notify({ Title = "Успешно", Content = "Смещение применилось к " .. targetPlayer.Name, Duration = 3 })
            else
                Fluent:Notify({ Title = "Ошибка", Content = "У модели отсутствует Motor6D головы!", Duration = 3 })
            end
        else
            Fluent:Notify({ Title = "Ошибка", Content = "Не удалось найти необходимые кости мишени!", Duration = 3 })
        end
    end
})

-- ==========================================
-- ВКЛАДКА: ЗАЩИТА (Anti-AFK, Anti-Kick, Anti-Exploit)
-- ==========================================

-- 1. Anti-AFK
local AntiAFKToggle = Tabs.Protection:AddToggle("AntiAFK", { Title = "Anti-AFK Protection", Default = true })
AntiAFKToggle:OnChanged(function(Value)
    _G.AntiAFKEnabled = Value
end)

LocalPlayer.Idled:Connect(function()
    if _G.AntiAFKEnabled then
        Services.VirtualUser:CaptureController()
        Services.VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)

-- 2. Anti-Kick + Auto-Respawn
local AntiKickToggle = Tabs.Protection:AddToggle("AntiKick", { Title = "Anti-Kick (Client Intercept)", Default = true })
AntiKickToggle:OnChanged(function(Value)
    _G.AntiKickEnabled = Value
end)

local AutoRespawnToggle = Tabs.Protection:AddToggle("AutoRespawn", { Title = "Респавн при попытке кика", Default = true })
AutoRespawnToggle:OnChanged(function(Value)
    _G.AutoRespawnOnKick = Value
end)

if hookmetamethod then
    local oldNamecall
    local oldIndex

    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if _G.AntiKickEnabled and tostring(method):lower() == "kick" and (self == LocalPlayer or self == Services.Players) then
            Fluent:Notify({ Title = "Защита", Content = "Заблокирован вызов Player:Kick()", Duration = 4 })
            if _G.AutoRespawnOnKick then
                task.spawn(TriggerRespawn)
            end
            return nil
        end
        return oldNamecall(self, ...)
    end)

    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if _G.AntiKickEnabled and tostring(key):lower() == "kick" and (self == LocalPlayer or self == Services.Players) then
            return function()
                Fluent:Notify({ Title = "Защита", Content = "Заблокировано обращение к .Kick()", Duration = 4 })
                if _G.AutoRespawnOnKick then
                    task.spawn(TriggerRespawn)
                end
                return nil
            end
        end
        return oldIndex(self, key)
    end)
end

-- 3. Anti-Exploit Guard (Защита от стороннего захвата/взрывов персонажа)
local ExploitGuardToggle = Tabs.Protection:AddToggle("ExploitGuard", { Title = "Anti-Exploit / Structure Protection", Default = true })
ExploitGuardToggle:OnChanged(function(Value)
    _G.ExploitGuardEnabled = Value
end)

task.spawn(function()
    while task.wait(2) do
        if _G.ExploitGuardEnabled and LocalPlayer.Character then
            for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
                -- Удаление сторонних нежелательных физ-объектов, которые могут вызывать взрывы или фриз
                if child:IsA("BodyVelocity") or child:IsA("BodyThrust") or child:IsA("RocketPropulsion") then
                    child:Destroy()
                end
            end
        end
    end
end)

-- ==========================================
-- ВКЛАДКА: ДЕТЕКТОР (Мониторинг лагов)
-- ==========================================

local LagDetectorToggle = Tabs.Detection:AddToggle("LagDetector", { Title = "Мониторинг пинга игроков", Default = false })
LagDetectorToggle:OnChanged(function(Value)
    _G.MonitorLag = Value
    
    task.spawn(function()
        while _G.MonitorLag do
            for _, player in ipairs(Services.Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local ping = player:GetNetworkPing() * 2000
                    if ping > 500 then
                        Fluent:Notify({
                            Title = "Высокий пинг",
                            Content = player.Name .. " (@" .. player.DisplayName .. "): " .. math.floor(ping) .. " ms",
                            Duration = 3
                        })
                    end
                end
            end
            task.wait(6)
        end
    end)
end)

-- ==========================================
-- АВТОМАТИЧЕСКАЯ СИНХРОНИЗАЦИЯ И ИНИЦИАЛИЗАЦИЯ
-- ==========================================

Services.Players.PlayerAdded:Connect(function()
    PlayerDropdown:SetValues(GetPlayerNames())
end)

Services.Players.PlayerRemoving:Connect(function(player)
    if SelectedPlayerName == player.Name then
        SelectedPlayerName = nil
    end
    PlayerDropdown:SetValues(GetPlayerNames())
end)

-- Готово
Fluent:Notify({
    Title = "Скрипт полностью инициализирован",
    Content = "Все системы защиты и функционал загружены.",
    Duration = 4
})
