-- =====================================================
-- ROCKET ULTRA v6.1 - FIXED VERSION
-- =====================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- CREATE GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ROCKET_GUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(130, 50, 200)
MainFrame.Active = true
MainFrame.Draggable = true

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.BorderSizePixel = 0
Title.Text = "ROCKET ULTRA v6.1"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- SCROLLING FRAME
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(130, 50, 200)

local UIList = Instance.new("UIListLayout")
UIList.Parent = ScrollFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 5)

-- BUTTON FUNCTION
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 40, 100)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 180, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
        btn.BorderColor3 = Color3.fromRGB(130, 50, 200)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.BorderColor3 = Color3.fromRGB(60, 40, 100)
    end)
    return btn
end

-- TOGGLE FUNCTION
local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 40, 100)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(220, 180, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.BorderColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 40, 100)
        callback(state)
    end)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
        btn.BorderColor3 = Color3.fromRGB(130, 50, 200)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.BorderColor3 = Color3.fromRGB(60, 40, 100)
    end)
    return btn
end

-- =====================================================
-- VARIABLES
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

-- =====================================================
-- FLY FUNCTION
-- =====================================================
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

-- =====================================================
-- NOCLIP FUNCTION
-- =====================================================
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

-- =====================================================
-- SPEED FUNCTION
-- =====================================================
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

-- =====================================================
-- GOD MODE FUNCTION
-- =====================================================
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

-- =====================================================
-- INFINITE JUMP FUNCTION
-- =====================================================
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

-- =====================================================
-- CREATE UI BUTTONS
-- =====================================================
CreateToggle("FLY (WASD + Space/Shift)", function(state)
    if state then StartFly() else StopFly() end
end)

CreateToggle("NOCLIP", ToggleNoclip)
CreateToggle("SPEED HACK", ToggleSpeed)
CreateToggle("GOD MODE", ToggleGodMode)
CreateToggle("INFINITE JUMP", ToggleInfiniteJump)

CreateButton("RESET CHARACTER", function()
    Player.Character = nil
    Player.CharacterAdded:Wait()
end)

CreateButton("CLOSE GUI", function()
    ScreenGui:Destroy()
end)

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
end)

-- =====================================================
-- OUTPUT
-- =====================================================
print("ROCKET ULTRA v6.1 LOADED")
print("GUI should appear in the center of the screen")
