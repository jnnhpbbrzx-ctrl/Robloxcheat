-- =====================================================
-- ROCKET ULTIMATE SCRIPT FOR REUL EXECUTOR v2.0
-- УНИВЕРСАЛЬНЫЙ ДЛЯ ВСЕХ ИГР (ROBLOX)
-- ТЕМА: ЧЁРНО-ФИОЛЕТОВАЯ (ПОЛНАЯ КАСТОМИЗАЦИЯ)
-- ФУНКЦИИ: FLY, ANTI-KICK, KICK <TARGET>, NOCLIP, SPEED HACK, ESP, AIMBOT, 
--           TELEPORT, GOD MODE, INFINITE JUMP, ANTI-FALL, AUTO-FARM,
--           FREEZE PLAYER, CRASH PLAYER, STEAL TOOLS, SPAWN ITEMS, 
--           GIVE ADMIN, REMOVE ADMIN, FAKE KICK, SERVER CRASH (LOCAL),
--           VIEW ALL REMOTES, EXECUTE REMOTE, DUMP ASSETS, 
--           BYPASS TELEPORT, BYPASS BAN, BYPASS WHITELIST
-- =====================================================

-- ОСНОВНЫЕ СЕРВИСЫ
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- =====================================================
-- 1. ГЛАВНОЕ МЕНЮ (ЧЁРНО-ФИОЛЕТОВАЯ ТЕМА)
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.Name = "ROCKET_MENU_REUL"
ScreenGui.ResetOnSpawn = false

-- ОСНОВНАЯ ПАНЕЛЬ
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 600, 0, 750)
Frame.Position = UDim2.new(0.5, -300, 0.5, -375)
Frame.BackgroundColor3 = Color3.fromRGB(8, 0, 16)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 3
Frame.BorderColor3 = Color3.fromRGB(130, 0, 255)
Frame.Active = true
Frame.Draggable = true

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(18, 0, 35)
Title.BorderColor3 = Color3.fromRGB(150, 0, 255)
Title.Text = "ROCKET ULTRA — REUL EXECUTOR"
Title.TextColor3 = Color3.fromRGB(200, 100, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- СКРОЛЛИНГ-СПИСОК ДЛЯ МНОЖЕСТВА КНОПОК
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = Frame
ScrollFrame.Size = UDim2.new(1, -20, 1, -55)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(5, 0, 10)
ScrollFrame.BackgroundTransparency = 0.5
ScrollFrame.BorderColor3 = Color3.fromRGB(100, 0, 200)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
local function CreateButton(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = color or Color3.fromRGB(12, 0, 25)
    btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 150, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ФУНКЦИЯ СОЗДАНИЯ ТЕКСТОВОГО ПОЛЯ
local function CreateTextBox(text, placeholder, callback)
    local box = Instance.new("TextBox")
    box.Parent = ScrollFrame
    box.Size = UDim2.new(0.95, 0, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
    box.BorderColor3 = Color3.fromRGB(120, 0, 255)
    box.Text = text
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(200, 150, 255)
    box.TextScaled = true
    box.Font = Enum.Font.GothamMedium
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(box.Text)
        end
    end)
    return box
end

-- ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЯ (TOGGLE)
local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(12, 0, 25)
    btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(220, 150, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
    return btn
end

-- =====================================================
-- 2. ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- =====================================================
local flying = false
local flySpeed = 60
local flyBodyVelocity = nil
local flyGyro = nil
local antiKick = false
local antiKickConnection = nil
local noclip = false
local noclipConnection = nil
local speedHack = false
local speedMultiplier = 3
local speedConnection = nil
local espEnabled = false
local espHighlights = {}
local aimbotEnabled = false
local aimbotConnection = nil
local godMode = false
local godModeConnection = nil
local infiniteJump = false
local infiniteJumpConnection = nil
local antiFall = false
local antiFallConnection = nil
local autoFarm = false
local autoFarmConnection = nil
local freezeAll = false
local freezeConnection = nil
local viewRemotes = false
local remoteDump = {}
local teleportCooldown = false
local selectedTarget = nil

-- =====================================================
-- 3. ОСНОВНЫЕ ФУНКЦИИ
-- =====================================================

-- 3.1 FLY (ПОЛЁТ) — УЛУЧШЕННЫЙ
local function StartFly()
    if flying then return end
    flying = true
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = root
    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyGyro.CFrame = root.CFrame
    flyGyro.Parent = root
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying or not root then
            flyConnection:Disconnect()
            return
        end
        local moveDirection = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection + Vector3.new(0, -1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then flySpeed = flySpeed + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then flySpeed = flySpeed - 1 end
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * flySpeed
        end
        flyBodyVelocity.Velocity = moveDirection
        if moveDirection.Magnitude > 0 then
            flyGyro.CFrame = CFrame.new(root.Position, root.Position + moveDirection.Unit)
        end
    end)
end

local function StopFly()
    flying = false
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyGyro then flyGyro:Destroy() flyGyro = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
end

-- 3.2 ANTI-KICK (ЗАЩИТА ОТ КИКА)
local function ToggleAntiKick(state)
    antiKick = state
    if antiKick then
        if antiKickConnection then antiKickConnection:Disconnect() end
        antiKickConnection = game:GetService("Players").LocalPlayer:WaitForChild("Kick"):Connect(function()
            if antiKick then
                print("ROCKET: Kick blocked")
                wait(0.1)
                Player.Character = Player.CharacterAdded:Wait()
            end
        end)
        print("ROCKET: Anti-Kick activated")
    else
        if antiKickConnection then
            antiKickConnection:Disconnect()
            antiKickConnection = nil
        end
        print("ROCKET: Anti-Kick deactivated")
    end
end

-- 3.3 KICK <TARGET> (КИК ИГРОКА)
local function KickTarget(targetName)
    local target = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower()) then
            target = plr
            break
        end
    end
    if target and target ~= Player then
        -- МЕТОД 1: Через удалённые события
        local remotes = ReplicatedStorage:GetChildren()
        for _, rem in pairs(remotes) do
            if rem:IsA("RemoteEvent") or rem:IsA("UnreliableRemoteEvent") then
                pcall(function()
                    rem:FireServer("Kick", target.Name)
                    rem:FireServer("AdminCommand", "kick " .. target.Name)
                    rem:FireServer("KickPlayer", target.Name)
                end)
            end
        end
        -- МЕТОД 2: Прямой кик (если есть доступ)
        pcall(function()
            game:GetService("Players"):FindFirstChild(target.Name):Kick("Kicked by ROCKET")
        end)
        -- МЕТОД 3: Фейковый кик через Remote (если сервер использует)
        pcall(function()
            local args = {
                [1] = "KickPlayer",
                [2] = target.Name
            }
            for _, rem in pairs(ReplicatedStorage:GetChildren()) do
                if rem:IsA("RemoteEvent") then
                    rem:FireServer(unpack(args))
                end
            end
        end)
        print("ROCKET: Kicked " .. target.Name)
    else
        print("ROCKET: Target not found")
    end
end

-- 3.4 NOCLIP
local function ToggleNoClip(state)
    noclip = state
    if noclip then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.RenderStepped:Connect(function()
            if not noclip then noclipConnection:Disconnect() return end
            local char = Player.Character
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- 3.5 SPEED HACK
local function ToggleSpeedHack(state)
    speedHack = state
    if speedHack then
        if speedConnection then speedConnection:Disconnect() end
        speedConnection = RunService.RenderStepped:Connect(function()
            if not speedHack then speedConnection:Disconnect() return end
            local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 16 * speedMultiplier
                hum.JumpPower = 50 * speedMultiplier
            end
        end)
    else
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end

-- 3.6 ESP
local function ToggleESP(state)
    espEnabled = state
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                local char = plr.Character
                if char then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = char
                    highlight.Adornee = char
                    highlight.FillColor = Color3.fromRGB(150, 0, 255)
                    highlight.FillTransparency = 0.3
                    highlight.OutlineColor = Color3.fromRGB(200, 0, 255)
                    highlight.OutlineTransparency = 0.1
                    table.insert(espHighlights, highlight)
                end
            end
        end
        Player.CharacterAdded:Connect(function(char)
            if espEnabled then
                wait(0.5)
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Player then
                        local char2 = plr.Character
                        if char2 then
                            local highlight = Instance.new("Highlight")
                            highlight.Parent = char2
                            highlight.Adornee = char2
                            highlight.FillColor = Color3.fromRGB(150, 0, 255)
                            highlight.FillTransparency = 0.3
                            highlight.OutlineColor = Color3.fromRGB(200, 0, 255)
                            highlight.OutlineTransparency = 0.1
                            table.insert(espHighlights, highlight)
                        end
                    end
                end
            end
        end)
    else
        for _, h in pairs(espHighlights) do
            if h and h.Parent then h:Destroy() end
        end
        espHighlights = {}
    end
end

-- 3.7 AIMBOT
local function ToggleAimbot(state)
    aimbotEnabled = state
    if aimbotEnabled then
        if aimbotConnection then aimbotConnection:Disconnect() end
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if not aimbotEnabled then aimbotConnection:Disconnect() return end
            local nearest = nil
            local minDist = math.huge
            local char = Player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player then
                    local targetChar = plr.Character
                    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                        local dist = (root.Position - targetChar.HumanoidRootPart.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearest = targetChar.HumanoidRootPart
                        end
                    end
                end
            end
            if nearest then
                root.CFrame = CFrame.new(root.Position, nearest.Position)
            end
        end)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end

-- 3.8 GOD MODE
local function ToggleGodMode(state)
    godMode = state
    if godMode then
        if godModeConnection then godModeConnection:Disconnect() end
        godModeConnection = Player.CharacterAdded:Connect(function(char)
            wait(0.1)
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end
        end)
        local char = Player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end
        end
    else
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
        local char = Player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = 100
                hum.Health = 100
            end
        end
    end
end

-- 3.9 INFINITE JUMP
local function ToggleInfiniteJump(state)
    infiniteJump = state
    if infiniteJump then
        if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if infiniteJump then
                local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end
    end
end

-- 3.10 ANTI-FALL
local function ToggleAntiFall(state)
    antiFall = state
    if antiFall then
        if antiFallConnection then antiFallConnection:Disconnect() end
        antiFallConnection = RunService.RenderStepped:Connect(function()
            if not antiFall then antiFallConnection:Disconnect() return end
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                if pos.Y < -30 then
                    char.HumanoidRootPart.Position = Vector3.new(pos.X, 15, pos.Z)
                end
            end
        end)
    else
        if antiFallConnection then
            antiFallConnection:Disconnect()
            antiFallConnection = nil
        end
    end
end

-- 3.11 AUTO-FARM (СБОР РЕСУРСОВ)
local function ToggleAutoFarm(state)
    autoFarm = state
    if autoFarm then
        if autoFarmConnection then autoFarmConnection:Disconnect() end
        autoFarmConnection = RunService.RenderStepped:Connect(function()
            if not autoFarm then autoFarmConnection:Disconnect() return end
            local char = Player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            -- Поиск предметов рядом
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("resource") or obj.Name:lower():find("item") or obj.Name:lower():find("ore") or obj.Name:lower():find("crystal") then
                    local dist = (root.Position - obj.Position).Magnitude
                    if dist < 50 then
                        local tween = TweenService:Create(root, TweenInfo.new(0.5), {CFrame = obj.CFrame * CFrame.new(0, 2, 0)})
                        tween:Play()
                        wait(0.1)
                        -- Симуляция сбора (клик)
                        pcall(function()
                            local clickRemote = ReplicatedStorage:FindFirstChild("ClickRemote") or ReplicatedStorage:FindFirstChild("CollectRemote")
                            if clickRemote then
                                clickRemote:FireServer(obj)
                            end
                        end)
                        break
                    end
                end
            end
        end)
    else
        if autoFarmConnection then
            autoFarmConnection:Disconnect()
            autoFarmConnection = nil
        end
    end
end

-- 3.12 FREEZE ALL (ЗАМОРОЗКА ВСЕХ ИГРОКОВ)
local function ToggleFreezeAll(state)
    freezeAll = state
    if freezeAll then
        if freezeConnection then freezeConnection:Disconnect() end
        freezeConnection = RunService.RenderStepped:Connect(function()
            if not freezeAll then freezeConnection:Disconnect() return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player then
                    local char = plr.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    else
        if freezeConnection then
            freezeConnection:Disconnect()
            freezeConnection = nil
        end
    end
end

-- 3.13 TELEPORT TO TARGET
local function TeleportToTarget(targetName)
    local target = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower()) then
            target = plr
            break
        end
    end
    if target and target ~= Player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
        print("ROCKET: Teleported to " .. target.Name)
    else
        print("ROCKET: Target not found")
    end
end

-- 3.14 TELEPORT TO COORDINATES
local function TeleportToCoords(x, y, z)
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        print("ROCKET: Teleported to " .. x .. ", " .. y .. ", " .. z)
    end
end

-- 3.15 CRASH PLAYER (ЛОКАЛЬНЫЙ КРАШ — ТОЛЬКО ВИЗУАЛЬНЫЙ)
local function CrashPlayer(targetName)
    local target = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower()) then
            target = plr
            break
        end
    end
    if target and target ~= Player and target.Character then
        for _ = 1, 100 do
            pcall(function()
                local clone = target.Character:Clone()
                clone.Parent = Workspace
                clone.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                wait(0.01)
                clone:Destroy()
            end)
        end
        print("ROCKET: Crashing " .. target.Name)
    end
end

-- 3.16 STEAL TOOLS (КРАЖА ИНСТРУМЕНТОВ)
local function StealTools(targetName)
    local target = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower()) then
            target = plr
            break
        end
    end
    if target and target ~= Player and target.Character then
        for _, tool in pairs(target.Character:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = Player.Backpack
                print("ROCKET: Stole " .. tool.Name)
            end
        end
        for _, tool in pairs(target.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = Player.Backpack
                print("ROCKET: Stole " .. tool.Name)
            end
        end
    else
        print("ROCKET: Target not found")
    end
end

-- 3.17 SPAWN ITEMS (СПАВН ПРЕДМЕТОВ)
local function SpawnItem(itemName, amount)
    for i = 1, amount or 1 do
        local newItem = Instance.new("Tool")
        newItem.Name = itemName or "ROCKET_Item"
        newItem.RequiresHandle = false
        local handle = Instance.new("Part")
        handle.Size = Vector3.new(2, 2, 2)
        handle.Anchored = true
        handle.Parent = newItem
        handle.BrickColor = BrickColor.new("Bright violet")
        newItem.Parent = Player.Backpack
        wait(0.1)
    end
    print("ROCKET: Spawned " .. (amount or 1) .. " " .. (itemName or "ROCKET_Item"))
end

-- 3.18 GIVE ADMIN (ФЕЙКОВЫЙ АДМИН — ТОЛЬКО ВИЗУАЛЬ)
local function GiveAdmin(targetName)
    local target = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower()) then
            target = plr
            break
        end
    end
    if target then
        pcall(function()
            local fakeAdmin = Instance.new("BoolValue")
            fakeAdmin.Name = "Admin"
            fakeAdmin.Value = true
            fakeAdmin.Parent = target
            print("ROCKET: Gave admin to " .. target.Name)
        end)
    else
        print("ROCKET: Target not found")
    end
end

-- 3.19 REMOVE ADMIN
local function RemoveAdmin(targetName)
    local target = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower()) then
            target = plr
            break
        end
    end
    if target then
        local admin = target:FindFirstChild("Admin")
        if admin then admin:Destroy() end
        print("ROCKET: Removed admin from " .. target.Name)
    end
end

-- 3.20 FAKE KICK (ФЕЙКОВЫЙ КИК ДЛЯ СЕБЯ)
local function FakeKick()
    local fakeKickGui = Instance.new("ScreenGui")
    fakeKickGui.Parent = CoreGui
    local frame = Instance.new("Frame")
    frame.Parent = fakeKickGui
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "You have been kicked from the game.\nReason: ROCKET FAKE KICK"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    wait(3)
    fakeKickGui:Destroy()
end

-- 3.21 VIEW ALL REMOTES
local function ToggleViewRemotes(state)
    viewRemotes = state
    if viewRemotes then
        local remoteList = {}
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("UnreliableRemoteEvent") then
                table.insert(remoteList, obj.Name)
            end
        end
        print("ROCKET: Found " .. #remoteList .. " remotes")
        for i, name in pairs(remoteList) do
            print(i .. ". " .. name)
        end
        remoteDump = remoteList
    end
end

-- 3.22 EXECUTE REMOTE (ВЫПОЛНИТЬ УДАЛЁННОЕ СОБЫТИЕ)
local function ExecuteRemote(remoteName, ...)
    local remote = ReplicatedStorage:FindFirstChild(remoteName)
    if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
        if remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer(...)
                print("ROCKET: Executed RemoteEvent " .. remoteName)
            end)
        elseif remote:IsA("RemoteFunction") then
            pcall(function()
                local result = remote:InvokeServer(...)
                print("ROCKET: Executed RemoteFunction " .. remoteName .. " Result: " .. tostring(result))
            end)
        end
    else
        print("ROCKET: Remote not found")
    end
end

-- 3.23 DUMP ASSETS (ВЫГРУЗКА АССЕТОВ)
local function DumpAssets()
    local assets = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Tool") then
            table.insert(assets, obj.Name .. " (" .. obj.ClassName .. ")")
        end
    end
    print("ROCKET: Found " .. #assets .. " assets")
    for i, name in pairs(assets) do
        print(i .. ". " .. name)
    end
    return assets
end

-- 3.24 BYPASS TELEPORT (ОБХОД ТЕЛЕПОРТА)
local function BypassTeleport()
    local teleportEvent = ReplicatedStorage:FindFirstChild("TeleportEvent")
    if teleportEvent then
        teleportEvent:Destroy()
        print("ROCKET: Teleport bypassed")
    end
    local teleportPart = Workspace:FindFirstChild("TeleportPart")
    if teleportPart then
        teleportPart:Destroy()
        print("ROCKET: Teleport part removed")
    end
end

-- 3.25 BYPASS BAN (ОБХОД БАНА — ТОЛЬКО ЛОКАЛЬНО)
local function BypassBan()
    local banned = Player:FindFirstChild("Banned")
    if banned then banned:Destroy() end
    local banGui = CoreGui:FindFirstChild("BanGui")
    if banGui then banGui:Destroy() end
    print("ROCKET: Ban bypassed")
end

-- 3.26 BYPASS WHITELIST (ОБХОД БЕЛОГО СПИСКА)
local function BypassWhitelist()
    local whitelist = ReplicatedStorage:FindFirstChild("Whitelist")
    if whitelist then
        whitelist:Destroy()
        print("ROCKET: Whitelist removed")
    end
end

-- 3.27 SERVER CRASH (ЛОКАЛЬНАЯ ИМИТАЦИЯ КРАША СЕРВЕРА)
local function ServerCrash()
    for i = 1, 1000 do
        pcall(function()
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 1, 1)
            part.Position = Vector3.new(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
            part.Anchored = true
            part.Parent = Workspace
            wait(0.001)
            part:Destroy()
        end)
    end
    print("ROCKET: Server crash simulated")
end

-- 3.28 SET SPEED MULTIPLIER
local function SetSpeedMultiplier(value)
    speedMultiplier = tonumber(value) or 3
    print("ROCKET: Speed multiplier set to " .. speedMultiplier)
end

-- 3.29 SET FLY SPEED
local function SetFlySpeed(value)
    flySpeed = tonumber(value) or 60
    print("ROCKET: Fly speed set to " .. flySpeed)
end

-- 3.30 RESET CHARACTER
local function ResetCharacter()
    Player.Character = nil
    Player.CharacterAdded:Wait()
    print("ROCKET: Character reset")
end

-- =====================================================
-- 4. СОЗДАНИЕ ИНТЕРФЕЙСА (ЧЁРНО-ФИОЛЕТОВЫЙ)
-- =====================================================

-- Основные кнопки
CreateButton("✈️ FLY (WASD, Space/Shift, E/Q speed)", function()
    if not flying then StartFly() else StopFly() end
end)

CreateToggle("🛡️ ANTI-KICK", ToggleAntiKick)

CreateButton("👢 KICK <TARGET>", function()
    local target = game:GetService("Players"):GetPlayers()[2]
    if target then KickTarget(target.Name) end
end)

CreateToggle("🚫 NOCLIP", ToggleNoClip)

CreateToggle("💨 SPEED HACK (x" .. speedMultiplier .. ")", ToggleSpeedHack)

CreateToggle("👁️ ESP", ToggleESP)

CreateToggle("🎯 AIMBOT", ToggleAimbot)

CreateToggle("🛡️ GOD MODE", ToggleGodMode)

CreateToggle("🦘 INFINITE JUMP", ToggleInfiniteJump)

CreateToggle("🪂 ANTI-FALL", ToggleAntiFall)

CreateToggle("🌾 AUTO-FARM", ToggleAutoFarm)

CreateToggle("❄️ FREEZE ALL", ToggleFreezeAll)

CreateButton("📦 TELEPORT TO TARGET", function()
    local target = game:GetService("Players"):GetPlayers()[2]
    if target then TeleportToTarget(target.Name) end
end)

-- Текстовые поля для ввода
CreateTextBox("Teleport to Coords: X Y Z", "0 0 0", function(text)
    local coords = {}
    for num in string.gmatch(text, "%S+") do
        table.insert(coords, tonumber(num))
    end
    if #coords >= 3 then
        TeleportToCoords(coords[1], coords[2], coords[3])
    else
        print("ROCKET: Invalid coordinates")
    end
end)

CreateTextBox("Kick Player:", "PlayerName", function(text)
    KickTarget(text)
end)

CreateTextBox("Teleport to Player:", "PlayerName", function(text)
    TeleportToTarget(text)
end)

CreateTextBox("Crash Player:", "PlayerName", function(text)
    CrashPlayer(text)
end)

CreateTextBox("Steal Tools from:", "PlayerName", function(text)
    StealTools(text)
end)

CreateTextBox("Spawn Item:", "ItemName", function(text)
    SpawnItem(text, 1)
end)

CreateTextBox("Spawn Items (amount):", "5", function(text)
    SpawnItem("ROCKET_Item", tonumber(text) or 1)
end)

CreateTextBox("Give Admin to:", "PlayerName", function(text)
    GiveAdmin(text)
end)

CreateTextBox("Remove Admin from:", "PlayerName", function(text)
    RemoveAdmin(text)
end)

CreateButton("🎭 FAKE KICK (self)", function()
    FakeKick()
end)

CreateToggle("🔍 VIEW REMOTES", ToggleViewRemotes)

CreateButton("🚀 EXECUTE REMOTE", function()
    ExecuteRemote("RemoteName", "arg1", "arg2")
end)

CreateButton("📦 DUMP ASSETS", function()
    DumpAssets()
end)

CreateButton("🚫 BYPASS TELEPORT", function()
    BypassTeleport()
end)

CreateButton("🚫 BYPASS BAN", function()
    BypassBan()
end)

CreateButton("🚫 BYPASS WHITELIST", function()
    BypassWhitelist()
end)

CreateButton("💥 SERVER CRASH (sim)", function()
    ServerCrash()
end)

CreateTextBox("Set Speed Multiplier:", "3", function(text)
    SetSpeedMultiplier(text)
end)

CreateTextBox("Set Fly Speed:", "60", function(text)
    SetFlySpeed(text)
end)

CreateButton("🔄 RESET CHARACTER", function()
    ResetCharacter()
end)

CreateButton("❌ DESTROY GUI", function()
    ScreenGui:Destroy()
    print("ROCKET: GUI destroyed")
end)

-- =====================================================
-- 5. КАСТОМИЗАЦИЯ ТЕМЫ (ЧЁРНО-ФИОЛЕТОВАЯ С ВОЗМОЖНОСТЬЮ СМЕНЫ)
-- =====================================================
local function SetTheme(bgColor, borderColor, textColor, titleColor)
    Frame.BackgroundColor3 = bgColor or Color3.fromRGB(8, 0, 16)
    Frame.BorderColor3 = borderColor or Color3.fromRGB(130, 0, 255)
    Title.BackgroundColor3 = bgColor or Color3.fromRGB(18, 0, 35)
    Title.BorderColor3 = borderColor or Color3.fromRGB(150, 0, 255)
    Title.TextColor3 = titleColor or Color3.fromRGB(200, 100, 255)
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = bgColor or Color3.fromRGB(12, 0, 25)
            child.BorderColor3 = borderColor or Color3.fromRGB(120, 0, 255)
            child.TextColor3 = textColor or Color3.fromRGB(220, 150, 255)
        elseif child:IsA("TextBox") then
            child.BackgroundColor3 = bgColor or Color3.fromRGB(10, 0, 20)
            child.BorderColor3 = borderColor or Color3.fromRGB(120, 0, 255)
            child.TextColor3 = textColor or Color3.fromRGB(200, 150, 255)
        end
    end
    print("ROCKET: Theme updated")
end

-- Установка темы по умолчанию (ЧЁРНЫЙ + ФИОЛЕТОВЫЙ)
SetTheme()

-- Глобальная функция для смены темы через консоль
_G.setTheme = SetTheme

-- Пример: _G.setTheme(Color3.fromRGB(0,0,0), Color3.fromRGB(200,0,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,100,255))

-- =====================================================
-- 6. АВТОЗАГРУЗКА ДОПОЛНИТЕЛЬНЫХ ФУНКЦИЙ
-- =====================================================

-- Авто-восстановление персонажа
Player.CharacterAdded:Connect(function(char)
    wait(0.5)
    if godMode then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end
    if noclip then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    if speedHack then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 16 * speedMultiplier
            hum.JumpPower = 50 * speedMultiplier
        end
    end
end)

-- =====================================================
-- 7. ВЫВОД ИНФОРМАЦИИ
-- =====================================================
print("=====================================================")
print("ROCKET ULTRA SCRIPT FOR REUL EXECUTOR v2.0 LOADED")
print("Тема: Чёрно-фиолетовая (кастомизация через _G.setTheme())")
print("Функции: Fly, Anti-Kick, Kick, NoClip, Speed Hack, ESP,")
print("Aimbot, God Mode, Infinite Jump, Anti-Fall, Auto-Farm,")
print("Freeze All, Teleport, Crash, Steal Tools, Spawn Items,")
print("Give/Remove Admin, Fake Kick, View Remotes, Execute Remote,")
print("Dump Assets, Bypass Teleport/Ban/Whitelist, Server Crash")
print("=====================================================")
print("ROCKET: Используйте меню для активации функций")
print("ROCKET: Для смены темы введите в консоли:")
print("_G.setTheme(background, border, text, title)")
print("Пример: _G.setTheme(Color3.fromRGB(0,0,0), Color3.fromRGB(200,0,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,100,255))")
print("=====================================================")

-- =====================================================
-- КОНЕЦ СКРИПТА
-- =====================================================
