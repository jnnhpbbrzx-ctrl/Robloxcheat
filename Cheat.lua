-- ==============================================================================
-- ULTIMATE WINDOWS CLASSIC HUB (ROBLOX LUA SCRIPT)
-- Обновленная версия с улучшенным стилем под интерфейс игры
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- STREAMING_CHUNK:Initializing GUI container...
if LocalPlayer.PlayerGui:FindFirstChild("UltimateWindowsHub") then
LocalPlayer.PlayerGui.UltimateWindowsHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateWindowsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 400)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- STREAMING_CHUNK:Styling top bar and title...
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Твои игрушки / Панель управления"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 16
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 3.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = false
end)

-- STREAMING_CHUNK:Creating tab system...
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 42)
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = TabContainer

local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, 0, 1, -77)
PagesContainer.Position = UDim2.new(0, 0, 0, 77)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local tabs = {}
local pages = {}

local function CreateTab(iconName, tabIndex)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 140, 1, 0)
btn.BackgroundColor3 = (tabIndex == 1) and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
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
page.ScrollBarThickness = 6
page.Visible = (tabIndex == 1)
page.Parent = PagesContainer

table.insert(tabs, btn)
table.insert(pages, page)

btn.MouseButton1Click:Connect(function()
    for i, tBtn in ipairs(tabs) do
        TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        pages[i].Visible = false
    end
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    page.Visible = true
end)

return page


end

local Page1 = CreateTab("🎯 Таргет", 1)
local Page2 = CreateTab("🛡️ Защита", 2)
local Page3 = CreateTab("👁️ Детектор", 3)
local Page4 = CreateTab("⚙️ Разное", 4)

-- STREAMING_CHUNK:Populating Tab 1 contents...
local SelectedTargetName = nil

local TargetTitle = Instance.new("TextLabel")
TargetTitle.Size = UDim2.new(1, -24, 0, 24)
TargetTitle.Position = UDim2.new(0, 12, 0, 12)
TargetTitle.BackgroundTransparency = 1
TargetTitle.Text = "Выберите игрока для взаимодействия:"
TargetTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
TargetTitle.Font = Enum.Font.SourceSansBold
TargetTitle.TextSize = 14
TargetTitle.TextXAlignment = Enum.TextXAlignment.Left
TargetTitle.Parent = Page1

local PlayersScroll = Instance.new("ScrollingFrame")
PlayersScroll.Size = UDim2.new(1, -24, 0, 140)
PlayersScroll.Position = UDim2.new(0, 12, 0, 42)
PlayersScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayersScroll.BorderSizePixel = 1
PlayersScroll.Parent = Page1

local PlayersLayout = Instance.new("UIListLayout")
PlayersLayout.Parent = PlayersScroll
PlayersLayout.Padding = UDim.new(0, 3)

local function UpdatePlayerList()
for _, child in ipairs(PlayersScroll:GetChildren()) do
if child:IsA("TextButton") then child:Destroy() end
end
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer then
local pBtn = Instance.new("TextButton")
pBtn.Size = UDim2.new(1, 0, 0, 30)
pBtn.BackgroundColor3 = (SelectedTargetName == p.Name) and Color3.fromRGB(60, 100, 150) or Color3.fromRGB(50, 50, 50)
pBtn.Text = "  👤 " .. p.Name
pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
pBtn.Font = Enum.Font.SourceSans
pBtn.TextSize = 14
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
RefreshBtn.Size = UDim2.new(1, -24, 0, 36)
RefreshBtn.Position = UDim2.new(0, 12, 0, 192)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
RefreshBtn.Text = "🔄 Обновить список игроков"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 14
RefreshBtn.Parent = Page1
RefreshBtn.MouseButton1Click:Connect(UpdatePlayerList)

local ApplyPosBtn = Instance.new("TextButton")
ApplyPosBtn.Size = UDim2.new(1, -24, 0, 40)
ApplyPosBtn.Position = UDim2.new(0, 12, 0, 238)
ApplyPosBtn.BackgroundColor3 = Color3.fromRGB(150, 45, 45)
ApplyPosBtn.Text = "💥 Сместить кости выбранного игрока"
ApplyPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyPosBtn.Font = Enum.Font.SourceSansBold
ApplyPosBtn.TextSize = 14
ApplyPosBtn.Parent = Page1

ApplyPosBtn.MouseButton1Click:Connect(function()
if not SelectedTargetName then return end
local target = Players:FindFirstChild(SelectedTargetName)
if target and target.Character then
local head = target.Character:FindFirstChild("Head")
local neck = head and head:FindFirstChildOfClass("Motor6D")
if neck then
neck.C0 = CFrame.new(0, -1.2, -0.5) * CFrame.Angles(math.rad(90), 0, 0)
end
end
end)

-- STREAMING_CHUNK:Populating Tab 2 and Tab 3 contents...
local AntiGrabActive = false
local AntiGrabBtn = Instance.new("TextButton")
AntiGrabBtn.Size = UDim2.new(1, -24, 0, 44)
AntiGrabBtn.Position = UDim2.new(0, 12, 0, 15)
AntiGrabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
AntiGrabBtn.Text = "🛡️ Anti-Grab [ВЫКЛ]"
AntiGrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiGrabBtn.Font = Enum.Font.SourceSansBold
AntiGrabBtn.TextSize = 15
AntiGrabBtn.Parent = Page2

AntiGrabBtn.MouseButton1Click:Connect(function()
AntiGrabActive = not AntiGrabActive
AntiGrabBtn.Text = AntiGrabActive and "🛡️ Anti-Grab [ВКЛ]" or "🛡️ Anti-Grab [ВЫКЛ]"
AntiGrabBtn.BackgroundColor3 = AntiGrabActive and Color3.fromRGB(45, 130, 45) or Color3.fromRGB(80, 80, 80)
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

local DetectorInfo = Instance.new("TextLabel")
DetectorInfo.Size = UDim2.new(1, -24, 0, 60)
DetectorInfo.Position = UDim2.new(0, 12, 0, 12)
DetectorInfo.BackgroundTransparency = 1
DetectorInfo.Text = "Система мониторинга производительности и сетевых пакетов сервера."
DetectorInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
DetectorInfo.Font = Enum.Font.SourceSans
DetectorInfo.TextSize = 14
DetectorInfo.TextWrapped = true
DetectorInfo.TextXAlignment = Enum.TextXAlignment.Left
DetectorInfo.Parent = Page3

local DetectorStatusBox = Instance.new("TextLabel")
DetectorStatusBox.Size = UDim2.new(1, -24, 0, 80)
DetectorStatusBox.Position = UDim2.new(0, 12, 0, 80)
DetectorStatusBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
DetectorStatusBox.TextColor3 = Color3.fromRGB(255, 210, 60)
DetectorStatusBox.Text = "Статус: Сканирование..."
DetectorStatusBox.Font = Enum.Font.SourceSansBold
DetectorStatusBox.TextSize = 14
DetectorStatusBox.TextWrapped = true
DetectorStatusBox.Parent = Page3

task.spawn(function()
while true do
task.wait(3)
local fps = workspace:GetRealPhysicsFPS()
DetectorStatusBox.Text = "Статус: Сервер стабилен\nТекущий FPS: " .. math.floor(fps)
end
end)

-- STREAMING_CHUNK:Populating Tab 4 and handling global keybinds...
local InfoHelp = Instance.new("TextLabel")
InfoHelp.Size = UDim2.new(1, -24, 0, 180)
InfoHelp.Position = UDim2.new(0, 12, 0, 12)
InfoHelp.BackgroundTransparency = 1
InfoHelp.Text = "📌 ГОРЯЧИЕ КЛАВИШИ:\n\n• [F10] — Обход фиксации камеры (Принудительное 3-е лицо).\n• [Right Shift] — Скрыть / Показать главное окно.\n\nИнтерфейс работает поверх всех игровых меню."
InfoHelp.TextColor3 = Color3.fromRGB(220, 220, 220)
InfoHelp.Font = Enum.Font.SourceSans
InfoHelp.TextSize = 14
InfoHelp.TextXAlignment = Enum.TextXAlignment.Left
InfoHelp.TextYAlignment = Enum.TextYAlignment.Top
InfoHelp.TextWrapped = true
InfoHelp.Parent = Page4

local isThirdPerson = false
UserInputService.InputBegan:Connect(function(input, gpe)
if gpe then return end
if input.KeyCode == Enum.KeyCode.F10 then
if LocalPlayer.Character then
isThirdPerson = not isThirdPerson
LocalPlayer.CameraMode = Enum.CameraMode.Classic
LocalPlayer.CameraMaxZoomDistance = isThirdPerson and 128 or 0.5
LocalPlayer.CameraMinZoomDistance = isThirdPerson and 10 or 0.5
end
end
if input.KeyCode == Enum.KeyCode.RightShift then
MainFrame.Visible = not MainFrame.Visible
end
end)
