-- =====================================================
-- ROCKET ULTRA v7.1
-- С ПРОКРУТКОЙ (SCROLLING) МЕНЮ
-- АНТИ-КИК + ГРАБ С АНИМАЦИЕЙ
-- =====================================================

-- 1. ОСНОВНЫЕ СЕРВИСЫ
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

-- 2. ПРОВЕРКА ПЕРСОНАЖА
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- =====================================================
-- 3. СОЗДАНИЕ ГУИ С ПРОКРУТКОЙ
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ROCKET_GUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- ГЛАВНОЕ ОКНО (БОЛЬШЕ, ЧТОБЫ ПОМЕСТИТЬ ВСЁ)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 450, 0, 550)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 0, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
Title.BorderColor3 = Color3.fromRGB(150, 0, 255)
Title.Text = "ROCKET ULTRA v7.1"
Title.TextColor3 = Color3.fromRGB(200, 100, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- КНОПКА ЗАКРЫТИЯ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 20)
CloseBtn.BorderColor3 = Color3.fromRGB(150, 0, 255)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- =====================================================
-- 4. СКРОЛЛИНГ-ФРЕЙМ (ОСНОВНАЯ ПРОКРУТКА)
-- =====================================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(5, 0, 10)
ScrollFrame.BackgroundTransparency = 0.5
ScrollFrame.BorderColor3 = Color3.fromRGB(100, 0, 200)
ScrollFrame.BorderSizePixel = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- АВТОМАТИЧЕСКИ РАСШИРЯЕТСЯ
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 255)
ScrollFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
ScrollFrame.ScrollBarImageTransparency = 0.3
ScrollFrame.MouseWheelScrollIncrement = 15

-- UIListLayout ДЛЯ АВТОМАТИЧЕСКОГО РАСПОЛОЖЕНИЯ
local UIList = Instance.new("UIListLayout")
UIList.Parent = ScrollFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- =====================================================
-- 5. ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ КНОПОК
-- =====================================================
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(12, 0, 25)
    btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    btn.BorderSizePixel = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 150, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.MouseButton1Click:Connect(callback)
    
    -- ЭФФЕКТ ПРИ НАВЕДЕНИИ
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
        btn.BorderColor3 = Color3.fromRGB(200, 0, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(12, 0, 25)
        btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    end)
    return btn
end

local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(12, 0, 25)
    btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    btn.BorderSizePixel = 1
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(220, 150, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.BorderColor3 = state and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(120, 0, 255)
        callback(state)
    end)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
        btn.BorderColor3 = Color3.fromRGB(200, 0, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(12, 0, 25)
        btn.BorderColor3 = Color3.fromRGB(120, 0, 255)
    end)
    return btn
end

local function CreateTextBox(text, placeholder, callback)
    local box = Instance.new("TextBox")
    box.Parent = ScrollFrame
    box.Size = UDim2.new(0.95, 0, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
    box.BorderColor3 = Color3.fromRGB(120, 0, 255)
    box.BorderSizePixel = 1
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

local function CreateSeparator(text)
    local sep = Instance.new("TextLabel")
    sep.Parent = ScrollFrame
    sep.Size = UDim2.new(0.95, 0, 0, 25)
    sep.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    sep.BackgroundTransparency = 0.5
    sep.BorderSizePixel = 0
    sep.Text = "───── " .. text .. " ─────"
    sep.TextColor3 = Color3.fromRGB(150, 100, 200)
    sep.TextScaled = true
    sep.Font = Enum.Font.GothamBold
    return sep
end

-- =====================================================
-- 6. ПЕРЕМЕННЫЕ
-- =====================================================
local flying = false
local flySpeed = 60
local flyBodyVelocity = nil
local flyConnection = nil
local noclip = false
local noclipConnection = nil
local speedHack = false
local speedMultiplier = 3
local speedConnection = nil
local godMode = false
local godModeConnection = nil
local infiniteJump = false
local infiniteJumpConnection = nil
local antiFall = false
local antiFallConnection = nil
local espEnabled = false
local espHighlights = {}
local aimbotEnabled = false
local aimbotConnection = nil
local freezeAll = false
local freezeConnection = nil
local thirdPerson = false
local thirdPersonConnection = nil
local antiKick = false
local antiKickConnection = nil
local grabEnabled = false
local grabTarget = nil
local grabConnection = nil
local grabBodyVelocity = nil
local grabFaceConnection = nil

-- =====================================================
-- 7. ФУНКЦИИ
-- =====================================================

-- FLY
local function StartFly()
    if flying then return end
    flying = true
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = true end
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = root
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying or not root then flyConnection:Disconnect() return end
        local move = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end
        if move.Magnitude > 0 then move = move.Unit * flySpeed end
        flyBodyVelocity.Velocity = move
    end)
end

local function StopFly()
    flying = false
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    local char = Player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- NOCLIP
local function ToggleNoclip(state)
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
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
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

-- SPEED
local function ToggleSpeed(state)
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
        if speedConnection then speedConnection:Disconnect() speedConnection = nil end
        local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end

-- GOD MODE
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
                hum.BreakJointsOnDeath = false
            end
        end)
        local char = Player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum.BreakJointsOnDeath = false
            end
        end
    else
        if godModeConnection then godModeConnection:Disconnect() godModeConnection = nil end
        local char = Player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = 100
                hum.Health = 100
                hum.BreakJointsOnDeath = true
            end
        end
    end
end

-- INFINITE JUMP
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
        if infiniteJumpConnection then infiniteJumpConnection:Disconnect() infiniteJumpConnection = nil end
    end
end

-- ANTI-FALL
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
                    char.HumanoidRootPart.Position = Vector3.new(pos.X, 20, pos.Z)
                end
            end
        end)
    else
        if antiFallConnection then antiFallConnection:Disconnect() antiFallConnection = nil end
    end
end

-- ESP
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
                    highlight.FillTransparency = 0.25
                    highlight.OutlineColor = Color3.fromRGB(200, 0, 255)
                    highlight.OutlineTransparency = 0.1
                    table.insert(espHighlights, highlight)
                end
            end
        end
    else
        for _, h in pairs(espHighlights) do
            if h and h.Parent then h:Destroy() end
        end
        espHighlights = {}
    end
end

-- AIMBOT
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
        if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    end
end

-- FREEZE ALL
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
        if freezeConnection then freezeConnection:Disconnect() freezeConnection = nil end
    end
end

-- THIRD PERSON
local function ToggleThirdPerson(state)
    thirdPerson = state
    if thirdPerson then
        if thirdPersonConnection then thirdPersonConnection:Disconnect() end
        thirdPersonConnection = RunService.RenderStepped:Connect(function()
            if not thirdPerson then thirdPersonConnection:Disconnect() return end
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local cam = workspace.CurrentCamera
                local root = char.HumanoidRootPart
                local offset = Vector3.new(0, 5, 15)
                local targetPos = root.Position + offset
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = CFrame.new(targetPos, root.Position)
            end
        end)
    else
        if thirdPersonConnection then thirdPersonConnection:Disconnect() thirdPersonConnection = nil end
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

-- ANTI-KICK
local function ToggleAntiKick(state)
    antiKick = state
    if antiKick then
        if antiKickConnection then antiKickConnection:Disconnect() end
        antiKickConnection = Player:WaitForChild("Kick"):Connect(function()
            if antiKick then
                print("ROCKET: KICK BLOCKED")
                wait(0.1)
                Player.Character = Player.CharacterAdded:Wait()
                wait(0.2)
                local char = Player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.MaxHealth = math.huge
                        hum.Health = math.huge
                    end
                end
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
                end)
            end
        end)
        Player.CharacterAdded:Connect(function(char)
            if antiKick then
                wait(0.5)
                char:WaitForChild("Humanoid").MaxHealth = math.huge
                char.Humanoid.Health = math.huge
            end
        end)
        pcall(function()
            local banValues = Player:GetChildren()
            for _, v in pairs(banValues) do
                if v.Name:lower():find("ban") or v.Name:lower():find("banned") then
                    v:Destroy()
                end
            end
        end)
        print("ROCKET: ANTI-KICK ACTIVATED")
    else
        if antiKickConnection then
            antiKickConnection:Disconnect()
            antiKickConnection = nil
        end
        print("ROCKET: ANTI-KICK DEACTIVATED")
    end
end

-- GRAB
local function GrabPlayer(targetName)
    local target = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower()) then
            target = plr
            break
        end
    end
    
    if not target or target == Player then
        print("ROCKET: Target not found")
        return
    end
    
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        print("ROCKET: Target has no character")
        return
    end
    
    grabTarget = target
    grabEnabled = not grabEnabled
    
    if grabEnabled then
        print("ROCKET: Grabbing " .. target.Name .. " (face to crotch)")
        
        local targetRoot = target.Character.HumanoidRootPart
        local targetHead = target.Character:FindFirstChild("Head")
        local targetTorso = target.Character:FindFirstChild("Torso") or target.Character:FindFirstChild("UpperTorso")
        
        local targetHum = target.Character:FindFirstChild("Humanoid")
        if targetHum then
            targetHum.PlatformStand = true
        end
        
        grabBodyVelocity = Instance.new("BodyVelocity")
        grabBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        grabBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        grabBodyVelocity.Parent = targetRoot
        
        grabConnection = RunService.RenderStepped:Connect(function()
            if not grabEnabled or not grabTarget or not grabTarget.Character then
                grabEnabled = false
                if grabConnection then grabConnection:Disconnect() grabConnection = nil end
                if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
                if grabFaceConnection then grabFaceConnection:Disconnect() grabFaceConnection = nil end
                return
            end
            
            local playerRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            local targetRoot = grabTarget.Character:FindFirstChild("HumanoidRootPart")
            
            if not playerRoot or not targetRoot then return end
            
            local distance = (playerRoot.Position - targetRoot.Position).Magnitude
            local crotchPosition = playerRoot.Position + Vector3.new(0, -1.5, 0)
            
            if distance > 3 then
                local force = (crotchPosition - targetRoot.Position).Unit * math.min(distance * 10, 200)
                grabBodyVelocity.Velocity = force
            elseif distance < 1.5 then
                grabBodyVelocity.Velocity = -(crotchPosition - targetRoot.Position).Unit * 20
            else
                grabBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                targetRoot.Velocity = Vector3.new(0, 0, 0)
                targetRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                
                local lookDirection = (playerRoot.Position - targetRoot.Position).Unit
                targetRoot.CFrame = CFrame.new(targetRoot.Position, targetRoot.Position + lookDirection)
                
                if targetHead then
                    targetHead.CFrame = CFrame.new(targetHead.Position, crotchPosition)
                end
                if targetTorso then
                    targetTorso.CFrame = CFrame.new(targetTorso.Position, crotchPosition) * CFrame.Angles(0.5, 0, 0)
                end
            end
        end)
        
        grabFaceConnection = RunService.Heartbeat:Connect(function()
            if not grabEnabled or not grabTarget or not grabTarget.Character then
                grabFaceConnection:Disconnect()
                return
            end
            local targetRoot = grabTarget.Character:FindFirstChild("HumanoidRootPart")
            local playerRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot and playerRoot then
                local crotchPos = playerRoot.Position + Vector3.new(0, -1.5, 0)
                targetRoot.CFrame = CFrame.new(targetRoot.Position, crotchPos)
            end
        end)
        
        print("ROCKET: Grab activated on " .. target.Name .. " (face to crotch)")
    else
        if grabConnection then grabConnection:Disconnect() grabConnection = nil end
        if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
        if grabFaceConnection then grabFaceConnection:Disconnect() grabFaceConnection = nil end
        
        if grabTarget and grabTarget.Character then
            local targetHum = grabTarget.Character:FindFirstChild("Humanoid")
            if targetHum then
                targetHum.PlatformStand = false
            end
            local targetRoot = grabTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                targetRoot.Velocity = Vector3.new(0, 0, 0)
                targetRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
        
        print("ROCKET: Grab deactivated")
        grabTarget = nil
    end
end

-- =====================================================
-- 8. СОЗДАНИЕ КНОПОК В ГУИ (С ПРОКРУТКОЙ)
-- =====================================================

-- РАЗДЕЛИТЕЛИ ДЛЯ ГРУППИРОВКИ
CreateSeparator("MAIN FUNCTIONS")

CreateToggle("FLY (WASD + Space/Shift)", function(state)
    if state then StartFly() else StopFly() end
end)

CreateToggle("NOCLIP", ToggleNoclip)
CreateToggle("SPEED HACK", ToggleSpeed)
CreateToggle("GOD MODE", ToggleGodMode)
CreateToggle("INFINITE JUMP", ToggleInfiniteJump)
CreateToggle("ANTI-FALL", ToggleAntiFall)

CreateSeparator("VISUALS")

CreateToggle("ESP", ToggleESP)
CreateToggle("AIMBOT", ToggleAimbot)
CreateToggle("FREEZE ALL", ToggleFreezeAll)
CreateToggle("THIRD PERSON", ToggleThirdPerson)

CreateSeparator("PROTECTION")

CreateToggle("ANTI-KICK", ToggleAntiKick)

CreateSeparator("GRAB")

CreateButton("GRAB TARGET (FACE TO CROTCH)", function()
    local target = Players:GetPlayers()[2]
    if target then
        GrabPlayer(target.Name)
    else
        print("ROCKET: No target found")
    end
end)

CreateTextBox("GRAB BY NAME", "Player name", function(text)
    if text and text ~= "" then
        GrabPlayer(text)
    end
end)

CreateButton("RELEASE TARGET", function()
    if grabEnabled then
        grabEnabled = false
        if grabConnection then grabConnection:Disconnect() grabConnection = nil end
        if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
        if grabFaceConnection then grabFaceConnection:Disconnect() grabFaceConnection = nil end
        if grabTarget and grabTarget.Character then
            local targetHum = grabTarget.Character:FindFirstChild("Humanoid")
            if targetHum then targetHum.PlatformStand = false end
        end
        grabTarget = nil
        print("ROCKET: Target released")
    end
end)

CreateSeparator("UTILITY")

CreateButton("RESET CHARACTER", function()
    Player.Character = nil
    Player.CharacterAdded:Wait()
end)

-- =====================================================
-- 9. АВТОВОССТАНОВЛЕНИЕ
-- =====================================================
Player.CharacterAdded:Connect(function(char)
    wait(0.5)
    if godMode then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum.BreakJointsOnDeath = false
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
    if flying then
        wait(0.2)
        StartFly()
    end
end)

-- =====================================================
-- 10. КОНСОЛЬНЫЕ КОМАНДЫ
-- =====================================================
_G.grab = function(name)
    if name then
        GrabPlayer(name)
    else
        local target = Players:GetPlayers()[2]
        if target then GrabPlayer(target.Name) end
    end
end

_G.release = function()
    if grabEnabled then
        grabEnabled = false
        if grabConnection then grabConnection:Disconnect() grabConnection = nil end
        if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
        if grabFaceConnection then grabFaceConnection:Disconnect() grabFaceConnection = nil end
        if grabTarget and grabTarget.Character then
            local targetHum = grabTarget.Character:FindFirstChild("Humanoid")
            if targetHum then targetHum.PlatformStand = false end
        end
        grabTarget = nil
        print("ROCKET: Target released")
    end
end

_G.antikick = function(state)
    ToggleAntiKick(state or true)
end

-- =====================================================
-- 11. ВЫВОД
-- =====================================================
print("==========================================")
print("ROCKET ULTRA v7.1 LOADED")
print("SCROLLING MENU - USE MOUSE WHEEL")
print("ANTI-KICK + GRAB FACE TO CROTCH")
print("==========================================")
print("COMMANDS:")
print("_G.grab('name') - grab player")
print("_G.grab() - grab second player")
print("_G.release() - release target")
print("_G.antikick(true/false) - toggle anti-kick")
print("==========================================")

-- =====================================================
-- КОНЕЦ
-- =====================================================
