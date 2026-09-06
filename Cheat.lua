-- =====================================================
-- ROCKET ULTRA v6.0
-- SERIOUS VERSION - NO EMOJIS, NO GLITCHES
-- FULLY WORKING WINDOWS UI
-- =====================================================

-- SERVICES
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- CHARACTER CHECK
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- VARIABLES
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
local antiKick = false
local antiKickConnection = nil
local autoFarm = false
local autoFarmConnection = nil
local thirdPerson = false
local thirdPersonConnection = nil
local grabEnabled = false
local grabTarget = nil
local grabConnection = nil
local grabBodyVelocity = nil
local ftapBoostEnabled = false
local ftapConnection = nil
local isDragging = false
local dragStart = nil
local dragStartPos = nil
local minimized = false

-- CREATE GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ROCKET_GUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- MAIN WINDOW
local MainWindow = Instance.new("Frame")
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 780, 0, 580)
MainWindow.Position = UDim2.new(0.5, -390, 0.5, -290)
MainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainWindow.BackgroundTransparency = 0.05
MainWindow.BorderSizePixel = 2
MainWindow.BorderColor3 = Color3.fromRGB(130, 50, 200)
MainWindow.Active = true
MainWindow.ClipsDescendants = true

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Parent = MainWindow
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.BorderSizePixel = 0

local WindowTitle = Instance.new("TextLabel")
WindowTitle.Parent = TopBar
WindowTitle.Size = UDim2.new(1, -90, 1, 0)
WindowTitle.Position = UDim2.new(0, 10, 0, 0)
WindowTitle.BackgroundTransparency = 1
WindowTitle.Text = "ROCKET ULTRA v6.0"
WindowTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
WindowTitle.TextScaled = true
WindowTitle.Font = Enum.Font.GothamBold
WindowTitle.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.Size = UDim2.new(0, 30, 1, 0)
MinimizeBtn.Position = UDim2.new(1, -60, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
MinimizeBtn.TextScaled = true
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainWindow.Size = minimized and UDim2.new(0, 780, 0, 40) or UDim2.new(0, 780, 0, 580)
    MainWindow.Position = minimized and UDim2.new(0.5, -390, 0.1, 0) or UDim2.new(0.5, -390, 0.5, -290)
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- DRAG WINDOW
TopBar.MouseButton1Down:Connect(function(x, y)
    isDragging = true
    dragStart = Vector2.new(x, y)
    dragStartPos = MainWindow.Position
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        MainWindow.Position = UDim2.new(
            dragStartPos.X.Scale,
            dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale,
            dragStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- CONTAINER
local Container = Instance.new("Frame")
Container.Parent = MainWindow
Container.Size = UDim2.new(1, 0, 1, -40)
Container.Position = UDim2.new(0, 0, 0, 40)
Container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Container.BorderSizePixel = 0

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Parent = Container
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
Sidebar.BorderSizePixel = 1
Sidebar.BorderColor3 = Color3.fromRGB(50, 30, 80)

local TabList = Instance.new("UIListLayout")
TabList.Parent = Sidebar
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 8)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- CONTENT AREA
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Parent = Container
ContentArea.Size = UDim2.new(1, -140, 1, 0)
ContentArea.Position = UDim2.new(0, 135, 0, 0)
ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ContentArea.BorderSizePixel = 0
ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentArea.ScrollBarThickness = 4
ContentArea.ScrollBarImageColor3 = Color3.fromRGB(130, 50, 200)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentArea
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- UI FUNCTIONS
local function CreateHeader(text)
    local h = Instance.new("TextLabel")
    h.Parent = ContentArea
    h.Size = UDim2.new(0.95, 0, 0, 28)
    h.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    h.BorderSizePixel = 1
    h.BorderColor3 = Color3.fromRGB(130, 50, 200)
    h.Text = " " .. text
    h.TextColor3 = Color3.fromRGB(220, 180, 255)
    h.TextScaled = true
    h.Font = Enum.Font.GothamBold
    h.TextXAlignment = Enum.TextXAlignment.Left
    return h
end

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentArea
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 40, 100)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 180, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
        btn.BorderColor3 = Color3.fromRGB(130, 50, 200)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.BorderColor3 = Color3.fromRGB(60, 40, 100)
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentArea
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 40, 100)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(220, 180, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    local state = false
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
        btn.BorderColor3 = Color3.fromRGB(130, 50, 200)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.BorderColor3 = Color3.fromRGB(60, 40, 100)
    end)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.BorderColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 40, 100)
        callback(state)
    end)
    return btn
end

local function CreateTextBox(text, placeholder, callback)
    local box = Instance.new("TextBox")
    box.Parent = ContentArea
    box.Size = UDim2.new(0.95, 0, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.BorderSizePixel = 1
    box.BorderColor3 = Color3.fromRGB(60, 40, 100)
    box.Text = text
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(220, 200, 240)
    box.TextScaled = true
    box.Font = Enum.Font.GothamMedium
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(box.Text)
        end
    end)
    return box
end

-- =====================================================
-- CORE FUNCTIONS
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

-- ANTI-KICK
local function ToggleAntiKick(state)
    antiKick = state
    if antiKick then
        if antiKickConnection then antiKickConnection:Disconnect() end
        antiKickConnection = game:GetService("Players").LocalPlayer:WaitForChild("Kick"):Connect(function()
            if antiKick then
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
            end
        end)
    else
        if antiKickConnection then antiKickConnection:Disconnect() antiKickConnection = nil end
    end
end

-- AUTO-FARM
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
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (
                    obj.Name:lower():find("resource") or 
                    obj.Name:lower():find("item") or 
                    obj.Name:lower():find("ore") or 
                    obj.Name:lower():find("crystal") or
                    obj.Name:lower():find("collect") or
                    obj.Name:lower():find("drop")
                ) then
                    local dist = (root.Position - obj.Position).Magnitude
                    if dist < 40 then
                        root.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
                        wait(0.1)
                        local clickRemote = ReplicatedStorage:FindFirstChild("ClickRemote") or 
                                           ReplicatedStorage:FindFirstChild("CollectRemote") or
                                           ReplicatedStorage:FindFirstChild("FarmRemote")
                        if clickRemote then
                            pcall(function() clickRemote:FireServer(obj) end)
                        end
                        break
                    end
                end
            end
        end)
    else
        if autoFarmConnection then autoFarmConnection:Disconnect() autoFarmConnection = nil end
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

-- =====================================================
-- GRAB FUNCTION
-- =====================================================
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
        print("ROCKET: Grabbing " .. target.Name)
        
        local targetRoot = target.Character.HumanoidRootPart
        grabBodyVelocity = Instance.new("BodyVelocity")
        grabBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        grabBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        grabBodyVelocity.Parent = targetRoot
        
        local targetHum = target.Character:FindFirstChild("Humanoid")
        if targetHum then
            targetHum.PlatformStand = true
        end
        
        grabConnection = RunService.RenderStepped:Connect(function()
            if not grabEnabled or not grabTarget or not grabTarget.Character then
                grabEnabled = false
                if grabConnection then grabConnection:Disconnect() grabConnection = nil end
                if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
                return
            end
            
            local playerRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            local targetRoot = grabTarget.Character:FindFirstChild("HumanoidRootPart")
            
            if not playerRoot or not targetRoot then return end
            
            local direction = (playerRoot.Position - targetRoot.Position).Unit
            local distance = (playerRoot.Position - targetRoot.Position).Magnitude
            
            if distance > 3 then
                local force = direction * math.min(distance * 10, 200)
                grabBodyVelocity.Velocity = force
            elseif distance < 2 then
                grabBodyVelocity.Velocity = -direction * 20
            else
                grabBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                targetRoot.Velocity = Vector3.new(0, 0, 0)
                targetRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end)
        
        print("ROCKET: Grab activated on " .. target.Name)
    else
        if grabConnection then grabConnection:Disconnect() grabConnection = nil end
        if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
        
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
-- FTAP BOOST FUNCTION
-- =====================================================
local function ToggleFTAPBoost(state)
    ftapBoostEnabled = state
    
    if ftapBoostEnabled then
        print("ROCKET: FTAP Boost activated")
        
        local function modifyStats()
            local char = Player.Character
            if not char then return end
            
            local function scanAndBoost(obj, depth)
                if depth > 10 then return end
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("NumberValue") or child:IsA("IntValue") or child:IsA("FloatValue") then
                        local newValue = child.Value * 10
                        if newValue < 1000000 then
                            child.Value = newValue
                        end
                    elseif child:IsA("StringValue") then
                        if child.Name:lower():find("level") or 
                           child.Name:lower():find("power") or 
                           child.Name:lower():find("strength") or
                           child.Name:lower():find("rank") then
                            child.Value = "999"
                        end
                    end
                    scanAndBoost(child, depth + 1)
                end
            end
            
            scanAndBoost(char, 0)
            
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum.WalkSpeed = 50
                hum.JumpPower = 100
            end
            
            for _, rem in pairs(ReplicatedStorage:GetDescendants()) do
                if rem:IsA("RemoteEvent") or rem:IsA("RemoteFunction") then
                    pcall(function()
                        if rem.Name:lower():find("boost") or 
                           rem.Name:lower():find("level") or 
                           rem.Name:lower():find("rank") or
                           rem.Name:lower():find("admin") then
                            rem:FireServer("Boost", 999999)
                            rem:FireServer("SetLevel", 999)
                            rem:FireServer("Promote", Player.Name)
                        end
                    end)
                end
            end
        end
        
        ftapConnection = RunService.Heartbeat:Connect(function()
            if not ftapBoostEnabled then 
                ftapConnection:Disconnect() 
                ftapConnection = nil
                return 
            end
            modifyStats()
        end)
        
        modifyStats()
        
    else
        if ftapConnection then
            ftapConnection:Disconnect()
            ftapConnection = nil
        end
        print("ROCKET: FTAP Boost deactivated")
    end
end

-- =====================================================
-- TAB SYSTEM
-- =====================================================
local currentTab = nil
local tabContents = {}

local function SwitchTab(tabName)
    if currentTab == tabName then return end
    currentTab = tabName
    
    for _, child in pairs(ContentArea:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextBox") or child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    if tabContents[tabName] then
        tabContents[tabName]()
    end
end

-- MAIN TAB
local function MainTab()
    CreateHeader("MAIN FUNCTIONS")
    CreateToggle("FLY (WASD + Space/Shift)", function(state)
        if state then StartFly() else StopFly() end
    end)
    CreateToggle("NOCLIP", ToggleNoclip)
    CreateToggle("SPEED HACK", ToggleSpeed)
    CreateToggle("GOD MODE", ToggleGodMode)
    CreateToggle("INFINITE JUMP", ToggleInfiniteJump)
    CreateToggle("ANTI-FALL", ToggleAntiFall)
    CreateToggle("THIRD PERSON", ToggleThirdPerson)
    CreateToggle("ANTI-KICK", ToggleAntiKick)
    
    CreateHeader("FARMING")
    CreateToggle("AUTO-FARM", ToggleAutoFarm)
    
    CreateHeader("TELEPORT")
    CreateButton("TELEPORT TO TARGET", function()
        local target = Players:GetPlayers()[2]
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
            end
        end
    end)
    CreateTextBox("TELEPORT TO XYZ", "0 50 0", function(text)
        local coords = {}
        for num in string.gmatch(text, "%S+") do
            table.insert(coords, tonumber(num))
        end
        if #coords >= 3 then
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
            end
        end
    end)
end

-- VISUALS TAB
local function VisualsTab()
    CreateHeader("VISUAL FUNCTIONS")
    CreateToggle("ESP (PLAYER HIGHLIGHT)", ToggleESP)
    CreateToggle("AIMBOT", ToggleAimbot)
    CreateToggle("FREEZE ALL PLAYERS", ToggleFreezeAll)
end

-- PLAYER TAB
local function PlayerTab()
    CreateHeader("GRAB PLAYERS")
    CreateButton("GRAB TARGET (TOGGLE)", function()
        local target = Players:GetPlayers()[2]
        if target then
            GrabPlayer(target.Name)
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
            if grabTarget and grabTarget.Character then
                local targetHum = grabTarget.Character:FindFirstChild("Humanoid")
                if targetHum then targetHum.PlatformStand = false end
            end
            grabTarget = nil
        end
    end)
    
    CreateHeader("FTAP BOOST")
    CreateToggle("FTAP BOOST (STATS)", function(state)
        ToggleFTAPBoost(state)
    end)
    CreateButton("BOOST NOW", function()
        local char = Player.Character
        if char then
            local function scanAndBoost(obj, depth)
                if depth > 10 then return end
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("NumberValue") or child:IsA("IntValue") or child:IsA("FloatValue") then
                        child.Value = child.Value * 10
                    end
                    scanAndBoost(child, depth + 1)
                end
            end
            scanAndBoost(char, 0)
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum.WalkSpeed = 50
                hum.JumpPower = 100
            end
        end
    end)
end

-- SETTINGS TAB
local function SettingsTab()
    CreateHeader("SETTINGS")
    CreateTextBox("SET SPEED MULTIPLIER", "3", function(text)
        local value = tonumber(text)
        if value and value > 0 and value < 100 then
            speedMultiplier = value
        end
    end)
    CreateTextBox("SET FLY SPEED", "60", function(text)
        local value = tonumber(text)
        if value and value > 0 and value < 500 then
            flySpeed = value
        end
    end)
    CreateButton("RESET CHARACTER", function()
        Player.Character = nil
        Player.CharacterAdded:Wait()
    end)
    CreateButton("CLOSE GUI", function()
        ScreenGui:Destroy()
    end)
end

-- REGISTER TABS
tabContents["Main"] = MainTab
tabContents["Visuals"] = VisualsTab
tabContents["Player"] = PlayerTab
tabContents["Settings"] = SettingsTab

-- CREATE SIDEBAR BUTTONS
local tabButtons = {}
local function CreateSidebarButton(text, tabName)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 40, 100)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 180, 220)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
        btn.BorderColor3 = Color3.fromRGB(130, 50, 200)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.BorderColor3 = Color3.fromRGB(60, 40, 100)
    end)
    btn.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            b.BorderColor3 = Color3.fromRGB(60, 40, 100)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
        btn.BorderColor3 = Color3.fromRGB(130, 50, 200)
    end)
    table.insert(tabButtons, btn)
    return btn
end

CreateSidebarButton("MAIN", "Main")
CreateSidebarButton("VISUALS", "Visuals")
CreateSidebarButton("PLAYER", "Player")
CreateSidebarButton("SETTINGS", "Settings")

-- LOAD FIRST TAB
SwitchTab("Main")

-- =====================================================
-- AUTO-RECOVERY
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
    if ftapBoostEnabled then
        wait(0.3)
        ToggleFTAPBoost(true)
    end
end)

-- =====================================================
-- CONSOLE COMMANDS
-- =====================================================
_G.grab = function(name)
    if name then
        GrabPlayer(name)
    else
        local target = Players:GetPlayers()[2]
        if target then GrabPlayer(target.Name) end
    end
end

_G.ftap = function(state)
    ToggleFTAPBoost(state or true)
end

_G.release = function()
    if grabEnabled then
        grabEnabled = false
        if grabConnection then grabConnection:Disconnect() grabConnection = nil end
        if grabBodyVelocity then grabBodyVelocity:Destroy() grabBodyVelocity = nil end
        if grabTarget and grabTarget.Character then
            local targetHum = grabTarget.Character:FindFirstChild("Humanoid")
            if targetHum then targetHum.PlatformStand = false end
        end
        grabTarget = nil
    end
end

-- =====================================================
-- CONSOLE OUTPUT
-- =====================================================
print("==========================================")
print("ROCKET ULTRA v6.0 LOADED")
print("WINDOWS UI - NO EMOJIS - STABLE")
print("==========================================")
print("FUNCTIONS:")
print("FLY | NOCLIP | SPEED | GOD MODE")
print("INFINITE JUMP | ANTI-FALL | ESP")
print("AIMBOT | FREEZE | ANTI-KICK")
print("AUTO-FARM | THIRD PERSON | GRAB")
print("FTAP BOOST | TELEPORT")
print("==========================================")
print("COMMANDS:")
print("_G.grab('name') - grab player")
print("_G.grab() - grab second player")
print("_G.ftap(true/false) - ftap boost")
print("_G.release() - release target")
print("==========================================")

-- =====================================================
-- END
-- =====================================================
