repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local Device
local Players = game:GetService("Players")

local function checkDevice()
    local player = Players.LocalPlayer
    if player then
        local UserInputService = game:GetService("UserInputService")
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            Device = UDim2.fromOffset(480, 360)
        else
            Device = UDim2.fromOffset(580, 460)
        end
    end
end

checkDevice()

local ToggleGui = Instance.new("ScreenGui")
local Toggle = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

local IsOpen = true

ToggleGui.Name = "ToggleGui"
ToggleGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") -- Parent the GUI to the player's screen
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.ResetOnSpawn = false

Toggle.Name = "Toggle"
Toggle.Parent = ToggleGui
Toggle.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
Toggle.Position = UDim2.new(0, 10, 0.8, 0)
Toggle.Size = UDim2.new(0, 100, 0, 40)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.Text = "Close GUI"
Toggle.TextColor3 = Color3.fromRGB(203, 122, 49)
Toggle.TextSize = 20
Toggle.Draggable = true

UICorner.Parent = Toggle

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fearise Hub" .. " | " .. "Rider World" .. " | " .. "[Version X]",
    TabWidth = 160,
    Size = Device,
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Legit = Window:AddTab({ Title = "Legit", Icon = "align-justify" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Toggle.MouseButton1Click:Connect(function()
    IsOpen = not IsOpen

    if Window then

        local gui = Window.Instance or game:GetService("CoreGui"):FindFirstChild("ScreenGui")
        if gui then
            gui.Enabled = IsOpen
        end
    end


    Toggle.Text = IsOpen and "Close GUI" or "Open GUI"
end)

task.spawn(function()
    while task.wait(1) do
        if Fluent.Unloaded then
            Toggle:Destroy()
            break
        end
    end
end)
----------------- Legit Tab ------------------
local Options = {}

local SpeedTitle = Tabs.Legit:AddSection("Player Modifiers")

local p = game:GetService("Players").LocalPlayer
local h
local WalkSpeed = 16
local WalkSpeedEnabled = false

-- ฟังก์ชันสำหรับบังคับค่า WalkSpeedw
local function enforceWalkSpeed()
    if h and WalkSpeedEnabled then
        -- ใช้ทั้ง GetPropertyChangedSignal และ Loop
        h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if h.WalkSpeed ~= WalkSpeed then
                h.WalkSpeed = WalkSpeed
            end
        end)

        task.spawn(function()
            while WalkSpeedEnabled do
                task.wait(0.1)
                if h.WalkSpeed ~= WalkSpeed then
                    h.WalkSpeed = WalkSpeed
                end
            end
        end)
    end
end

-- ตรวจจับตัวละครของผู้เล่น
local function onCharacterAdded(character)
    h = character:WaitForChild("Humanoid")
    if WalkSpeedEnabled then
        h.WalkSpeed = WalkSpeed
        enforceWalkSpeed()
    end
end

-- ตรวจจับตัวละครปัจจุบัน
if p.Character then
    onCharacterAdded(p.Character)
end
p.CharacterAdded:Connect(onCharacterAdded)

-- Toggle สำหรับเปิด/ปิด WalkSpeed
local WalkSpeedToggle = Tabs.Legit:AddToggle("WalkSpeedToggle", {
    Title = "Toggle WalkSpeed",
    Default = false,
    Callback = function(state)
        WalkSpeedEnabled = state
        if state and h then
            h.WalkSpeed = WalkSpeed
            enforceWalkSpeed()
            Fluent:Notify({
                Title = "WalkSpeed",
                Content = "WalkSpeed enabled: " .. tostring(WalkSpeed),
                Duration = 3
            })
        elseif h then
            h.WalkSpeed = 16 -- ค่าเริ่มต้น
            Fluent:Notify({
                Title = "WalkSpeed",
                Content = "WalkSpeed reset to default.",
                Duration = 3
            })
        end
    end
})

-- Slider สำหรับตั้งค่า WalkSpeed
local WalkSpeedSlider = Tabs.Legit:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed Slider",
    Min = 16,   
    Max = 500,
    Default = WalkSpeed,
    Rounding = 1,
    Callback = function(value)
        WalkSpeed = value
        if WalkSpeedEnabled and h then
            h.WalkSpeed = WalkSpeed
        end
    end
})

local plr = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")

local t = Tabs.Legit:AddToggle("MyToggle", {Title = "Infinite Jump", Default = false})

t:OnChanged(function(v)
    if v then
        con = uis.JumpRequest:Connect(function()
            plr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
        end)
    else
        if con then
            con:Disconnect()
        end
    end
end)

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("Fearise Hub interface")
SaveManager:SetFolder("Fearise Hub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fearise Hub",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()