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
    Main = Window:AddTab({ Title = "Main", Icon = "apple" }),
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

local autoRush = false
local bossType = "MirrorWorld"
local attackDistance = 6
local DungeonFound = false

local rs = game:GetService("ReplicatedStorage")
local ws = game:GetService("Workspace")
local p = game.Players.LocalPlayer
local pg = p:FindFirstChild("PlayerGui")

local toggle = Tabs.Main:AddToggle("AutoBossRush", {Title = "Enable Auto Boss Rush", Default = false})
toggle:OnChanged(function(v)
    autoRush = v
    print("[DEBUG] Toggle AutoBossRush:", autoRush)
    if autoRush then
        if not DungeonFound then
            print("[DEBUG] No Dungeon found! Entering BossRush in 12s...")
            task.wait(12)
            enterBossRush()
        end
    else
        DungeonFound = false
    end
end)

local dropdown = Tabs.Main:AddDropdown("BossType", {
    Title = "Select Boss Rush Type",
    Values = {"MirrorWorld", "Xmas", "AncientWorld", "SmartWorld"},
    Default = "MirrorWorld"
})
dropdown:OnChanged(function(v)
    bossType = v
    print("[DEBUG] Boss Type changed to:", bossType)
end)

local slider = Tabs.Main:AddSlider("AttackDistance", {
    Title = "Attack Distance",
    Default = 6,
    Min = 3,
    Max = 15,
    Rounding = 1
})
slider:OnChanged(function(v)
    attackDistance = v
    print("[DEBUG] Attack Distance changed to:", attackDistance)
end)

function enterBossRush()
    print("[DEBUG] Entering BossRush...")
    rs.Remote.Event.RiderManager:FireServer("Resource")
end

function SelectBossType()
    repeat task.wait() until pg:FindFirstChild("BossRushGUI")
    print("[DEBUG] BossRushGUI found! Selecting Boss Type:", bossType)
    pg.BossRushGUI.BossRushRemote:FireServer(bossType)
end

p.ChildAdded:Connect(function(child)
    if child.Name == "Dungeon" then
        print("[DEBUG] Dungeon Created! Waiting for BossRushGUI...")
        DungeonFound = true
        SelectBossType()
        autoFarm()
    end
end)

p.ChildRemoved:Connect(function(child)
    if child.Name == "Dungeon" and autoRush then
        print("[DEBUG] Dungeon Removed! Waiting 12s before re-entering...")
        DungeonFound = false
        task.wait(12)
        if autoRush and not DungeonFound then
            print("[DEBUG] Re-entering BossRush...")
            enterBossRush()
        end
    end
end)

function autoFarm()
    if not DungeonFound then return end
    print("[DEBUG] AutoFarm Running...")

    while autoRush and DungeonFound do
        if not DungeonFound then
            print("[DEBUG] Dungeon disappeared! Waiting 12s before re-entering...")
            task.wait(12)
            if autoRush and not DungeonFound then
                print("[DEBUG] Entering BossRush again...")
                enterBossRush()
            end
            break
        end

        local boss = nil
        for _, m in ipairs(ws.Lives:GetChildren()) do
            if m:IsA("Model") and m:FindFirstChild("Boss") and m.Name ~= "T-Rex Dopant Lv.80" then
                boss = m
                print("[DEBUG] Boss found:", boss.Name)
                break
            end
        end

        if boss then
            local hrp = boss:FindFirstChild("HumanoidRootPart")
            if hrp then
                print("[DEBUG] Moving to Boss:", boss.Name)
                p.Character:PivotTo(hrp.CFrame * CFrame.new(0, 0, attackDistance))
                ws.Lives[p.Name].PlayerHandler.HandlerEvent:FireServer({
                    CombatAction = true,
                    MouseData = hrp.CFrame,
                    Input = "Mouse1",
                    LightAttack = true,
                    Attack = true
                })
                print("[DEBUG] Attacking Boss!")
            end
        else
            print("[DEBUG] No valid Boss found...")
        end

        task.wait(0.5)
    end
end

local PropertiesTitle = Tabs.Main:AddSection("Properties")

-- local Toggle = Tabs.Main:AddToggle("AutoTransform", {Title = "Auto Transform", Default = false })

-- Toggle:OnChanged(function()
--     if Toggle.Value then
--         task.spawn(function()
--             while Toggle.Value do
--                 local rider = game:GetService("Players").LocalPlayer.RiderStats.ClientRider.Value
                
--                 if rider == "Cobra" then
--                     game:GetService("ReplicatedStorage").Remote.Function.InventoryFunction:InvokeServer("Survive Cobra")
--                     game:GetService("ReplicatedStorage").Remote.Function.InventoryFunction:InvokeServer(2, "Backpack")
--                     task.wait(1)
--                     game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
--                     game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
--                     task.wait(6)
--                     if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Form") then
--                         task.wait(1)
--                         game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
--                         game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
--                     end
--                 elseif rider == "Kugha" then
--                     game:GetService("ReplicatedStorage").Remote.Function.AncientWorldEventRemote:InvokeServer({
--                         ["ActiveForm"] = "Ultimated",
--                         ["ActiveRider"] = true
--                     })
--                     task.wait(15)
--                 elseif rider == "Double" then
--                     game:GetService("ReplicatedStorage").Remote.Function.FoundationEventRemote:InvokeServer({
--                         ["ActiveForm"] = "Fang Joker",
--                         ["ActiveRider"] = true
--                     })
--                     task.wait(15)
--                 end
                
--                 task.wait(1) 
--             end
--         end)
--     end
-- end)

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

-- ✅ หา Remote แบบชัวร์
local remote
repeat
    char = plr.Character or plr.CharacterAdded:Wait()
    remote = char:FindFirstChild("PlayerHandler") and char.PlayerHandler:FindFirstChild("HandlerEvent")
    task.wait(1)
until remote

local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Toggle", Default = false })

local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
    Title = "Dropdown",
    Description = "You can select multiple values.",
    Values = {"E", "R", "C", "V"},
    Multi = true,
    Default = {"E", "R"},
})

local enabled = false
local selectedSkills = {}

Toggle:OnChanged(function(v)
    enabled = v
end)

MultiDropdown:OnChanged(function(Value)
    selectedSkills = {}
    for Key, State in next, Value do
        if State then
            table.insert(selectedSkills, Key)
        end
    end

    -- ✅ Debug เช็คค่า
    print("Selected Skills:", table.concat(selectedSkills, ", "))
end)

spawn(function()
    while wait(0.1) do
        if enabled and remote then
            for _, Key in ipairs(selectedSkills) do
                local ohTable1 = {
                    ["Skill"] = true,
                    ["AttackType"] = "Down",
                    ["Key"] = Key,
                    ["MouseData"] = CFrame.new(-822.493286, 25.6408768, -93.336174, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                }
                remote:FireServer(ohTable1)

                -- ✅ Debug เช็คว่าส่ง Remote จริงมั้ย
                print("Fired Skill:", Key)
            end
        end
    end
end)

local r = workspace.Lives
local p = game.Players.LocalPlayer
local c = r:FindFirstChild(p.Name)
local t = Tabs.Main:AddToggle("AutoHenshin", {Title = "Auto Henshin", Default = false})
local h = false

task.spawn(function()
    while task.wait(1) do
        if t.Value then
            c = r:FindFirstChild(p.Name)
            if c and not c:FindFirstChild("Transformed") then
                c.PlayerHandler.HandlerFunction:InvokeServer("Henshin")
            end
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
