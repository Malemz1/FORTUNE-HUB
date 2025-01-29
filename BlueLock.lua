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
    Title = "Fearise Hub" .. " | " .. "BlueLock : Rival" .. " | " .. "[Version 2]",
    TabWidth = 160,
    Size = Device,
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Legit = Window:AddTab({ Title = "Legit", Icon = "align-justify" }),
    Kaitan = Window:AddTab({ Title = "Kaitan", Icon = "crown" }),
    OP = Window:AddTab({ Title = "OP", Icon = "apple" }),
    Spin = Window:AddTab({ Title = "Spin", Icon = "box" }),
    Rage = Window:AddTab({ Title = "Rage", Icon = "baby" }),
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

-- ฟังก์ชันสำหรับบังคับค่า WalkSpeed
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
    Max = 90,
    Default = WalkSpeed,
    Rounding = 1,
    Callback = function(value)
        WalkSpeed = value
        if WalkSpeedEnabled and h then
            h.WalkSpeed = WalkSpeed
        end
    end
})

local p = game:GetService("Players").LocalPlayer
local h
local JumpPower = 50 -- ค่าตั้งต้นของ JumpPower
local JumpPowerEnabled = false

-- ฟังก์ชันสำหรับบังคับค่า JumpPower
local function enforceJumpPower()
    if h and JumpPowerEnabled then
        h.UseJumpPower = true
        h.JumpPower = JumpPower
    end
end

-- ตรวจจับตัวละครของผู้เล่น
local function onCharacterAdded(character)
    h = character:WaitForChild("Humanoid")
    if JumpPowerEnabled then
        enforceJumpPower()
    end
end

-- ตรวจจับตัวละครปัจจุบัน
if p.Character then
    onCharacterAdded(p.Character)
end
p.CharacterAdded:Connect(onCharacterAdded)

-- Toggle สำหรับเปิด/ปิด JumpPower
local JumpPowerToggle = Tabs.Legit:AddToggle("JumpPowerToggle", {
    Title = "Toggle JumpPower",
    Default = false,
    Callback = function(state)
        JumpPowerEnabled = state
        if h then
            if state then
                h.UseJumpPower = true
                enforceJumpPower()
                Fluent:Notify({
                    Title = "JumpPower",
                    Content = "JumpPower enabled: " .. tostring(JumpPower),
                    Duration = 3
                })
            else
                h.UseJumpPower = false
                Fluent:Notify({
                    Title = "JumpPower",
                    Content = "JumpPower disabled.",
                    Duration = 3
                })
            end
        end
    end
})

-- Slider สำหรับตั้งค่า JumpPower
local JumpPowerSlider = Tabs.Legit:AddSlider("JumpPowerSlider", {
    Title = "JumpPower Slider",
    Min = 10,
    Max = 100,
    Default = JumpPower,
    Rounding = 1,
    Callback = function(value)
        JumpPower = value
        if JumpPowerEnabled and h then
            h.JumpPower = JumpPower
        end
    end
})

local currentSize = 3

local function findFootball()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Football" then
            return obj
        end
    end
    return nil
end

local HitboxTitle = Tabs.Legit:AddSection("Hitbox")

local dribblingEnabled = false

local Toggle = Tabs.Legit:AddToggle("MyToggle", { Title = "Hitbox", Default = false })
Options.MyToggle = Toggle

local function updateHitboxSize()
    local football = findFootball()
    if football then
        local hitbox = football:FindFirstChild("Hitbox")
        if hitbox and hitbox:IsA("Part") then
            hitbox.Material = Enum.Material.ForceField
            hitbox.BrickColor = BrickColor.new("Really red")
            hitbox.Transparency = 0.5
            hitbox.Size = Vector3.new(currentSize, currentSize, currentSize)
        end
    end
end

Toggle:OnChanged(function()
    local toggleValue = Options.MyToggle.Value
    if toggleValue then
        updateHitboxSize()
    else
        local football = findFootball()
        if football then
            local hitbox = football:FindFirstChild("Hitbox")
            if hitbox and hitbox:IsA("Part") then
                hitbox.Material = Enum.Material.Plastic
                hitbox.BrickColor = BrickColor.new("Institutional white")
                hitbox.Transparency = 1
                hitbox.Size = Vector3.new(2.5, 2.5, 2.5)
            end
        end
    end
end)

local Input = Tabs.Legit:AddInput("Input", {
    Title = "Hitbox Size",
    Default = tostring(currentSize),
    Placeholder = "Enter size (1-30)",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local newSize = tonumber(Value)
        if newSize and newSize >= 1 and newSize <= 30 then
            currentSize = newSize
            if Options.MyToggle.Value then
                updateHitboxSize()
            end
        else
            Fluent:Notify({
                Title = "Invalid Input",
                Content = "Size must be between 1 and 30.",
                Duration = 3
            })
        end
    end
})

local HitboxKeybind = Tabs.Legit:AddKeybind("HitboxKeybind", {
    Title = "Toggle Hitbox Keybind",
    Mode = "Toggle", 
    Default = "...",
    Callback = function()

        local currentState = Options.MyToggle.Value
        Options.MyToggle:SetValue(not currentState)
        Fluent:Notify({
            Title = "Hitbox Toggled",
            Content = "Hitbox has been " .. (Options.MyToggle.Value and "enabled" or "disabled") .. ".",
            Duration = 3
        })
    end,
    ChangedCallback = function(NewKey)
        Fluent:Notify({
            Title = "Keybind Changed",
            Content = "Hitbox Toggle Keybind is now set to: " .. tostring(NewKey),
            Duration = 3
        })
    end
})
local MiscTitle = Tabs.Legit:AddSection("Misc")

local vipToggle = Tabs.Legit:AddToggle("vipToggle", {
    Title = "Toggle VIP",
    Description = "Enable or disable VIP status for your player.",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local hasVIP = player:FindFirstChild("HasVIP")

        if hasVIP then
            hasVIP.Value = state
            if state then
                Fluent:Notify({
                    Title = "VIP Activated",
                    Content = "You are now a VIP! Enjoy your perks!",
                    Duration = 3
                })
            else
                Fluent:Notify({
                    Title = "VIP Deactivated",
                    Content = "VIP status disabled. You lost your perks.",
                    Duration = 3
                })
            end
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Could not find the 'HasVIP' property.",
                Duration = 3
            })
        end
    end
})

local Toggle = Tabs.Legit:AddToggle("AntiAFK", {Title = "Anti-AFK", Default = false})

local afkLoop
Toggle:OnChanged(function(state)
    if state then
        afkLoop = game:GetService("RunService").RenderStepped:Connect(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new(0, 0))
        end)
    else
        if afkLoop then
            afkLoop:Disconnect()
            afkLoop = nil
        end
    end
end)
local InfiniteStaminaEnabled = false

Tabs.Legit:AddButton({
    Title = "Infinite Stamina",
    Description = "Click to enable Infinite Stamina (cannot be disabled)",
    Callback = function()
        if not InfiniteStaminaEnabled then
            InfiniteStaminaEnabled = true
            Fluent:Notify({
                Title = "Infinite Stamina",
                Content = "Enabled",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Infinite Stamina",
                Content = "Already Enabled",
                Duration = 3
            })
        end
    end
})

task.spawn(function()
    while task.wait(0.1) do
        if InfiniteStaminaEnabled then
            pcall(function()
                local plr = game.Players.LocalPlayer
                local stats = plr:FindFirstChild("PlayerStats")
                if stats then
                    local stamina = stats:FindFirstChild("Stamina")
                    if stamina then
                        stamina:Destroy()
                        local fakeStamina = Instance.new("NumberValue")
                        fakeStamina.Name = "Stamina"
                        fakeStamina.Value = math.huge
                        fakeStamina.Parent = stats
                    end
                end
            end)
        end
    end
end)

local GG = Tabs.Legit:AddSection("Enchanted")

local ohNumber1 = 110
local ohNil2 = nil
local ohNil3 = nil
local ohVector34 = Vector3.new(-0.8265021443367004, -0.5140766501426697, -0.22938911616802216)

local function shootBall()
    game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Shoot:FireServer(ohNumber1, ohNil2, ohNil3, ohVector34)
end

local InstantKick = Tabs.Legit:AddKeybind("KickKeybind", {
    Title = "Instance Kick Keybind (PC Only)",
    Mode = "Toggle",
    Default = "...",
    Callback = function()
        shootBall()
    end,
})

local Input1 = Tabs.Legit:AddInput("Input", {
    Title = "Adjust Power (55-110)",
    Default = "110",
    Placeholder = "Enter power...",
    Numeric = true,
    Finished = true,
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue and numValue >= 55 and numValue <= 110 then
            ohNumber1 = numValue
            Fluent:Notify({
                Title = "Power Adjustment",
                Content = "Power updated to: " .. ohNumber1,
                Duration = 3
            })
        else
            ohNumber1 = 110
            Fluent:Notify({
                Title = "Invalid Input",
                Content = "Out of range! Power reset to: " .. ohNumber1,
                Duration = 3
            })
        end
    end,
})
----------------- Kaitan Tab ------------------
local Striker = Tabs.Kaitan:AddSection("Striker")

local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")

local HomeGoal = workspace.Goals.Away
local AwayGoal = workspace.Goals.Home

local GameValues = game:GetService("ReplicatedStorage"):WaitForChild("GameValues")
local State = GameValues.State -- เข้าถึงตัวแปร State

local running = false -- ควบคุมสถานะการทำงานของระบบ Auto Goal

-- ฟังก์ชันสร้าง UI
local function createUI()
    local screenGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
    screenGui.Name = "AutoGoalUI"
    screenGui.IgnoreGuiInset = true

    local background = Instance.new("Frame", screenGui)
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundTransparency = 0 -- ทำให้พื้นหลังโปร่งใส
    background.BorderSizePixel = 0
    background.BackgroundColor3 = Color3.new(0, 0, 0)
    background.ZIndex = 100

    local playerName = Instance.new("TextLabel", background)
    playerName.Size = UDim2.new(0.3, 0, 0.1, 0)
    playerName.Position = UDim2.new(0.35, 0, 0.2, 0)
    playerName.Text = "Player: " .. plr.Name
    playerName.TextColor3 = Color3.new(1, 1, 1)
    playerName.BackgroundTransparency = 1
    playerName.TextScaled = true
    playerName.Font = Enum.Font.SourceSansBold
    playerName.ZIndex = 101

    local moneyLabel = Instance.new("TextLabel", background)
    moneyLabel.Size = UDim2.new(0.3, 0, 0.1, 0)
    moneyLabel.Position = UDim2.new(0.35, 0, 0.35, 0)
    moneyLabel.TextColor3 = Color3.new(1, 1, 1)
    moneyLabel.BackgroundTransparency = 1
    moneyLabel.TextScaled = true
    moneyLabel.Font = Enum.Font.SourceSansBold
    moneyLabel.ZIndex = 101

    local levelLabel = Instance.new("TextLabel", background)
    levelLabel.Size = UDim2.new(0.3, 0, 0.1, 0)
    levelLabel.Position = UDim2.new(0.35, 0, 0.5, 0)
    levelLabel.TextColor3 = Color3.new(1, 1, 1)
    levelLabel.BackgroundTransparency = 1
    levelLabel.TextScaled = true
    levelLabel.Font = Enum.Font.SourceSansBold
    levelLabel.ZIndex = 101

    -- อัปเดตค่า Level และ Money แบบเรียลไทม์
    local stats = plr:WaitForChild("ProfileStats")
    local money = stats:WaitForChild("Money")
    local level = stats:WaitForChild("Level")

    local function updateStats()
        moneyLabel.Text = "Money: " .. money.Value
        levelLabel.Text = "Level: " .. level.Value
    end

    -- เรียกใช้เมื่อค่าเปลี่ยน
    money:GetPropertyChangedSignal("Value"):Connect(updateStats)
    level:GetPropertyChangedSignal("Value"):Connect(updateStats)

    -- อัปเดตครั้งแรก
    updateStats()

    return screenGui
end

-- ฟังก์ชันลบ UI
local function removeUI()
    local screenGui = plr:WaitForChild("PlayerGui"):FindFirstChild("AutoGoalUI")
    if screenGui then
        screenGui:Destroy()
    end
end

-- ฟังก์ชันรอจนกว่าผู้เล่นจะอยู่ในทีม Home หรือ Away
local function waitForValidTeam()
    while not (plr.Team and (plr.Team.Name == "Home" or plr.Team.Name == "Away")) do
        task.wait(1) -- รอ 1 วินาทีแล้วตรวจสอบใหม่
    end
end

-- ฟังก์ชันเทเลพอร์ตบอลไปยังประตู
local function teleportBallToGoal(ball, goal)
    if ball and goal then
        for i = 1, 5 do
            ball.CFrame = goal.CFrame
            task.wait(0.1)
        end
    end
end

-- ฟังก์ชันตรวจสอบสถานะว่าเรามีบอลหรือไม่
local function hasBall()
    local values = chr:FindFirstChild("Values")
    if values then
        local hasBallValue = values:FindFirstChild("HasBall")
        if hasBallValue and hasBallValue.Value == true then
            return true -- เรามีบอลอยู่ในตัว
        end
    end
    return false -- เราไม่มีบอล
end

-- ฟังก์ชันสำหรับยิงบอลและเทเลพอร์ต
local function shootAndTeleport()
    local ball = nil

    -- ค้นหาบอล
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("hitbox") and obj.Parent.Name:lower():find("football") then
            ball = obj
            break
        end
    end

    if ball then
        if hasBall() then
            -- ยิงบอล
            local ohNumber1 = 64.49900161242113
            local ohNil2 = nil
            local ohNil3 = nil
            local ohVector34 = Vector3.new(0.07641301304101944, -0.35041216015815735, -0.9334732294082642)
            game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Shoot:FireServer(ohNumber1, ohNil2, ohNil3, ohVector34)

            -- รอสักครู่ก่อนวาร์ปบอล
            task.wait(0.3)

            -- เทเลพอร์ตบอลไปยังประตูฝั่งตรงข้าม
            local team = plr.Team
            if team and team.Name == "Home" then
                teleportBallToGoal(ball, AwayGoal)
            elseif team and team.Name == "Away" then
                teleportBallToGoal(ball, HomeGoal)
            end
        else
            -- ถ้าเราไม่มีบอล ให้ส่งคำสั่ง Slide
            game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Slide:FireServer()
        end
    end
end

-- ฟังก์ชันสำหรับเคลื่อนที่เข้าใกล้บอล
local function autoGoal()
    -- รอจนกว่าผู้เล่นจะอยู่ในทีม Home หรือ Away
    waitForValidTeam()

    while running do
        -- ตรวจสอบว่า State เป็น "Playing" หรือไม่
        if State.Value ~= "Playing" then
            -- รอจนกว่า State จะกลับมาเป็น "Playing"
            repeat
                State:GetPropertyChangedSignal("Value"):Wait()
            until State.Value == "Playing" or not running -- ออกจาก loop ถ้า running ถูกปิด
        end

        if not running then
            break -- หากระบบถูกปิด ให้หยุดลูป
        end

        -- ค้นหาบอล
        local ball = nil
        for _, obj in pairs(game.workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Parent and obj.Parent.Name:lower():find("football") then
                ball = obj
                break
            end
        end

        if ball then
            -- วาร์ปตัวละครไปยังตำแหน่งของบอลทันที
            hrp.CFrame = ball.CFrame
            shootAndTeleport() -- ยิงบอลหรือสไลด์บอล
        end

        task.wait(0.4) -- รอในแต่ละรอบ
    end
end

-- Toggle สำหรับเปิด/ปิดระบบ Auto Goal
local Toggle = Tabs.Kaitan:AddToggle("MyToggle", {Title = "Auto Farm", Default = false })

Toggle:OnChanged(function()
    running = Toggle.Value -- อัปเดตสถานะการทำงาน
    if running then
        task.spawn(autoGoal) -- เริ่มทำงานใน Thread ใหม่
    end
end)

-- Toggle สำหรับเปิด/ปิดระบบ Auto Goal
local Toggle = Tabs.Kaitan:AddToggle("MyToggle", {Title = "BlackScreen", Default = false })

Toggle:OnChanged(function()
    running = Toggle.Value -- อัปเดตสถานะการทำงาน
    if running then
        createUI()
    else
        removeUI()
    end
end)

local Striker = Tabs.Kaitan:AddSection("Properties(Striker)")

Options.MyToggle:SetValue(false) -- ตั้งค่าเริ่มต้น Toggle เป็นปิด

local TeamService = game:GetService("ReplicatedStorage").Packages.Knit.Services.TeamService

local TeamPositionDropdown = Tabs.Kaitan:AddDropdown("TeamPositionDropdown", {
    Title = "Team and Position",
    Description = "Select your preferred team and position.",
    Values = {
        "Home_CF", "Home_LW", "Home_RW", "Home_CM", "Home_DM", "Home_CB", "Home_GK",
        "Away_CF", "Away_LW", "Away_RW", "Away_CM", "Away_DM", "Away_CB", "Away_GK"
    },
    Multi = false,
    Default = "Home_CF",
})

local AutoTeamEnabled = false

local function autoTeam()
    while AutoTeamEnabled do
        -- ตรวจสอบว่าผู้เล่นอยู่ในทีม Visitor
        if game.Players.LocalPlayer.Team and game.Players.LocalPlayer.Team.Name == "Visitor" then
            local selectedValue = TeamPositionDropdown.Value
            if selectedValue then
                local team, position = unpack(string.split(selectedValue, "_"))
                if team and position then
                    -- ส่งคำสั่งเลือกทีมและตำแหน่งไปยังเซิร์ฟเวอร์
                    TeamService.RE.Select:FireServer(team, position)
                    Fluent:Notify({
                        Title = "Team Selection",
                        Content = "Attempted to select team: " .. team .. ", position: " .. position,
                        Duration = 2
                    })
                else
                    Fluent:Notify({
                        Title = "Error",
                        Content = "Invalid team or position selected.",
                        Duration = 2
                    })
                end
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "No team or position selected.",
                    Duration = 2
                })
            end
end

        task.wait(3) -- รอ 3 วินาทีก่อนตรวจสอบใหม่
    end
end

local AutoTeamToggle = Tabs.Kaitan:AddToggle("AutoTeamToggle", {
    Title = "Auto Team & Position",
    Default = false,
    Callback = function(Value)
        AutoTeamEnabled = Value
        if AutoTeamEnabled then
            Fluent:Notify({
                Title = "Auto Team",
                Content = "Enabled: Auto-selecting team and position.",
                Duration = 3
            })
            task.spawn(autoTeam) -- เริ่มการทำงาน Auto Team
        else
            Fluent:Notify({
                Title = "Auto Team",
                Content = "Disabled: Auto team selection stopped.",
                Duration = 3
            })
        end
    end
})

TeamPositionDropdown:OnChanged(function(Value)
end)

local plrs = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local lp = plrs.LocalPlayer
local bs = rs.Packages.Knit.Services.BallService
local ig = false
local mouse = lp:GetMouse()

local function getBall()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Name == "Football" then
            return o
        end
    end
end

local function warpBallToGoal()
    local b = getBall()
    if b then
        -- Find the goal based on the player's team
        local goal
        if lp.Team and lp.Team.Name == "Home" then
            goal = workspace.Goals.Home -- Warp ball to the opponent's goal
        elseif lp.Team and lp.Team.Name == "Away" then
            goal = workspace.Goals.Away -- Warp ball to the opponent's goal
        end

        if goal then
            b.CFrame = goal.CFrame + Vector3.new(0, 1, 0) -- Warp ball directly to the goal's position with slight offset
        end
    end
end

-- Event listener for the shoot command
bs.RE.Shoot.OnClientEvent:Connect(function()
    if ig then
        warpBallToGoal()
    end
end)

-- Toggle to enable/disable Instant Goal
local toggle = Tabs.Kaitan:AddToggle("InstantGoalToggle", {
    Title = "Instant Goal",
    Default = false,
    Callback = function(s)
        ig = s
    end
})

-- Keybind to toggle Instant Goal
local keybind = Tabs.Kaitan:AddKeybind("InstantKeybind", {
    Title = "Toggle Instant Goal Keybind",
    Mode = "Toggle",
    Default = "...",
    Callback = function()
        ig = not ig
        toggle:SetValue(ig)
        Fluent:Notify({
            Title = "Instant Goal Toggled",
            Content = "Instant Goal has been " .. (ig and "enabled" or "disabled") .. ".",
            Duration = 3
        })
    end,
    ChangedCallback = function(k)
        Fluent:Notify({
            Title = "Keybind Changed",
            Content = "Instant Goal Keybind is now set to: " .. tostring(k),
            Duration = 3
        })
    end
})

Tabs.Kaitan:AddButton({
    Title = "Hop Server (Test)",
    Description = "Switch to a mid-population server",
    Callback = function()
        local hs = game:GetService("HttpService")
        local ts = game:GetService("TeleportService")
        local cursor = nil
        local minPlayers = 4  -- จำนวนผู้เล่นต่ำสุดที่ต้องการ
        local maxPlayers = 7  -- จำนวนผู้เล่นสูงสุดที่ต้องการ
        local maxRetries = 5  -- จำกัดจำนวนครั้งที่พยายามดึงข้อมูล
        local retries = 0

        while true do
            local s = {}
            retries = retries + 1
            if retries > maxRetries then
                warn("Max retries reached. Waiting longer...")
                Fluent:Notify({
                    Title = "Too Many Requests",
                    Content = "Waiting 15 seconds before retrying...",
                    Duration = 5
                })
                task.wait(15)
                retries = 0 -- รีเซ็ตจำนวนครั้งที่พยายาม
            end

            print("Fetching server list... Attempt:", retries)

            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            if cursor then
                url = url .. "&cursor=" .. cursor
            end

            local success, res = pcall(function()
                return hs:JSONDecode(game:HttpGet(url))
            end)

            if success and res and res.data then
                print("Server list fetched.")
                for _, v in pairs(res.data) do
                    if v.playing >= minPlayers and v.playing <= maxPlayers and v.playing < v.maxPlayers and v.id ~= game.JobId then
                        table.insert(s, v.id)
                        print("Found mid-pop server:", v.id, "Players:", v.playing, "/", v.maxPlayers)
                    end
                end
                
                if res.nextPageCursor and #s == 0 then
                    cursor = res.nextPageCursor -- ไปหน้าถัดไปถ้ายังหาไม่เจอ
                    task.wait(math.random(7, 15)) -- รอแบบสุ่ม 7-15 วินาที ลดโอกาสโดน Rate Limit
                else
                    if #s > 0 then
                        local sid = s[math.random(1, #s)]
                        print("Hopping to mid-pop server:", sid)
                        Fluent:Notify({
                            Title = "Server Hopping",
                            Content = "Switching to a mid-pop server with " .. minPlayers .. "-" .. maxPlayers .. " players.",
                            Duration = 3
                        })
                        ts:TeleportToPlaceInstance(game.PlaceId, sid)
                        return
                    else
                        warn("No suitable mid-pop servers found. Retrying in 10 seconds...")
                        Fluent:Notify({
                            Title = "No Server Found",
                            Content = "Retrying in 10 seconds...",
                            Duration = 3
                        })
                        task.wait(10) -- รอ 10 วินาทีแล้วลองใหม่
                        cursor = nil -- รีเซ็ต cursor เพื่อค้นหาใหม่ทั้งหมด
                    end
                end
            else
                warn("Failed to fetch server list:", res)
                Fluent:Notify({
                    Title = "Server Fetch Failed",
                    Content = "Retrying in 10 seconds...",
                    Duration = 3
                })
                task.wait(10) -- ถ้าเกิด HTTP 429 ให้รอ 10 วินาทีก่อนลองใหม่
            end
        end
    end
})

local GoalTitle = Tabs.Kaitan:AddSection("Goal (In Testing)")

local toggleState = false

-- เพิ่ม Toggle สำหรับ Auto Goal
local toggle = Tabs.Kaitan:AddToggle("AutoGoal", {Title = "Auto GK", Default = false})

toggle:OnChanged(function()
    toggleState = toggle.Value -- ดึงค่าปัจจุบันของ Toggle
    Fluent:Notify({
        Title = "Auto GK Toggled",
        Content = "Auto GK has been " .. (toggleState and "enabled" or "disabled") .. ".", -- ตรวจสอบสถานะ Toggle
        Duration = 3
    })
end)

-- เพิ่ม Keybind สำหรับเปิด/ปิด Auto Goal
local keybind = Tabs.Kaitan:AddKeybind("AutoGoalKeybind", {
    Title = "Auto GK Keybind",
    Mode = "Toggle", -- Toggle mode: กดเปิด/ปิด
    Default = "...", -- ค่าปุ่มเริ่มต้น
    Callback = function(Value)
        toggleState = not toggleState -- พลิกค่า Toggle State
        toggle:SetValue(toggleState) -- อัปเดตสถานะของ Toggle
        if toggleState then
        end
    end,
    ChangedCallback = function(New)
    end
})

local p = game.Players.LocalPlayer
local char = p.Character or p.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local distance = 50
local ball = nil

local function getBall()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Name == "Football" then
            return o
        end
    end
end

local function isBallInPlayer()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= p then -- ไม่เช็คตัวเอง
            local playerChar = player.Character
            if playerChar and ball and ball:IsDescendantOf(playerChar) then
                return true -- บอลอยู่ใน Player คนอื่น
            end
        end
    end
    return false
end

local function pressQ()
    local virtualInput = game:GetService("VirtualInputManager")
    virtualInput:SendKeyEvent(true, Enum.KeyCode.Q, false, nil) -- กดปุ่ม Q
    task.wait(0.1)
    virtualInput:SendKeyEvent(false, Enum.KeyCode.Q, false, nil) -- ปล่อยปุ่ม Q
end

game:GetService("RunService").RenderStepped:Connect(function()
    if toggleState then
        ball = ball or getBall()
        if ball and ball.Parent then
            local ballPos = ball.Position
            local mag = (hrp.Position - ballPos).Magnitude

            -- ตรวจสอบว่าบอลอยู่ในตัวเรา หรือใน Player คนอื่น
            if mag > 3 and mag <= distance and not ball:IsDescendantOf(char) and not isBallInPlayer() then
                hrp.CFrame = CFrame.new(ballPos) -- วาร์ปไปหาบอล
                pressQ() -- กดปุ่ม Q
            elseif mag <= 3 then
            elseif isBallInPlayer() then
            end
        else
            ball = nil
        end
    end
end)
----------------- OP Tab ------------------
local plrs = game:GetService("Players")
local runService = game:GetService("RunService")
local lp = plrs.LocalPlayer
local bs = game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService
local ig = false

local function getBall()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Name == "Football" then
            return o
        end
    end
end

local goalCFrames = {
    Home = {
        CFrame.new(323.849396, 11.1665344, -29.958168, -0.346998423, -2.85511348e-08, -0.937865734, 2.543152e-08, 1, -3.98520079e-08, 0.937865734, -3.76799356e-08, -0.346998423),
        CFrame.new(326.027893, 11.1665325, -67.0218277, 0.910013974, -1.74189319e-09, -0.414577574, -1.44234642e-08, 1, -3.58616781e-08, 0.414577574, 3.86142709e-08, 0.910013974)
    },
    Away = {
        CFrame.new(-247.79953, 11.1665344, -68.2236633, 0.441729337, -3.98036413e-08, -0.897148371, 8.61732801e-08, 1, -1.93767069e-09, 0.897148371, -7.64542918e-08, 0.441729337),
        CFrame.new(-247.711075, 25.6309118, -30.344408, 0.936370671, 0.0215997752, -0.350347638, -3.86210353e-08, 0.99810493, 0.0615354702, 0.351012826, -0.0576199964, 0.934596181)
    }
}

local function getRandomTargetCFrame(team)
    if team == "Home" then
        return goalCFrames.Away[math.random(1, #goalCFrames.Away)]
    elseif team == "Away" then
        return goalCFrames.Home[math.random(1, #goalCFrames.Home)]
    end
end

-- local function moveWithCurvedPath(ball, startPos, targetCF, height, duration, curveIntensity)
--     local startTime = tick()
--     local connection
--     local endPos = targetCF.Position

--     -- สุ่มว่าจะโค้งไปทางซ้าย (-1) หรือขวา (1)
--     local curveDirection = math.random(0, 1) == 0 and -1 or 1

--     connection = runService.RenderStepped:Connect(function()
--         local elapsed = tick() - startTime
--         if elapsed > duration then
--             ball.CFrame = targetCF
--             connection:Disconnect()
--             return
--         end

--         local t = elapsed / duration
--         local lerpPos = startPos:Lerp(endPos, t)

--         local arcHeight = math.sin(t * math.pi) * height
--         local horizontalCurve = math.sin(t * math.pi) * curveIntensity * curveDirection

--         ball.CFrame = CFrame.new(
--             lerpPos.X + horizontalCurve, -- โค้งซ้ายหรือขวา
--             startPos.Y + arcHeight,     -- โค้งขึ้น-ลง
--             lerpPos.Z
--         )
--     end)
-- end

local function moveWithCurvedPath(ball, startPos, targetCF, height, duration, curveIntensity)
    local startTime = tick()
    local connection
    local endPos = targetCF.Position
    connection = runService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed > duration then
            ball.CFrame = targetCF
            connection:Disconnect()
            return
        end

        local t = elapsed / duration
        local currentXZ = startPos:Lerp(endPos, t)

        local arcHeight = math.sin(t * math.pi) * height
        local curve = math.sin(t * math.pi * curveIntensity) * 15 -- เพิ่มความโค้งซ้าย-ขวา

        ball.CFrame = CFrame.new(currentXZ.X + curve, startPos.Y + arcHeight, currentXZ.Z)
    end)
end

local function teleportBallToGoal()
    local ball = getBall()
    if ball then
        local team = lp.Team and lp.Team.Name
        if team then
            local startPos = ball.Position
            local targetCFrame = getRandomTargetCFrame(team)
            if targetCFrame then
                moveWithCurvedPath(ball, startPos, targetCFrame, 40, 1, 5) -- เพิ่ม curveIntensity = 5
            end
        end
    end
end

bs.RE.Shoot.OnClientEvent:Connect(function()
    if ig then
        teleportBallToGoal()
    end
end)

local toggle = Tabs.OP:AddToggle("InstantGoalToggle", {
    Title = "Kaiser Impack",
    Default = false,
    Callback = function(state)
        ig = state
    end
})

local keybind = Tabs.OP:AddKeybind("InstantKeybind", {
    Title = "Toggle Kaiser Impack Keybind",
    Mode = "Toggle",
    Default = "...",
    Callback = function()
        ig = not ig
        toggle:SetValue(ig)
        Fluent:Notify({
            Title = "Kaiser Impack Toggled",
            Content = "Kaiser Impack has been " .. (ig and "enabled" or "disabled") .. ".",
            Duration = 3
        })
    end,
    ChangedCallback = function(newKey)
        Fluent:Notify({
            Title = "Keybind Changed",
            Content = "Kaiser Impack Keybind is now set to: " .. tostring(newKey),
            Duration = 3
        })
    end
})

----------------------------------------------------------------
local plrs = game:GetService("Players")
local runService = game:GetService("RunService")
local lp = plrs.LocalPlayer
local bs = game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService
local ig = false

local function getBall()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Name == "Football" then
            return o
        end
    end
end

local goalCFrames = {
    Home = {
        CFrame.new(323.849396, 11.1665344, -29.958168, -0.346998423, -2.85511348e-08, -0.937865734, 2.543152e-08, 1, -3.98520079e-08, 0.937865734, -3.76799356e-08, -0.346998423),
        CFrame.new(326.027893, 11.1665325, -67.0218277, 0.910013974, -1.74189319e-09, -0.414577574, -1.44234642e-08, 1, -3.58616781e-08, 0.414577574, 3.86142709e-08, 0.910013974)
    },
    Away = {
        CFrame.new(-247.79953, 11.1665344, -68.2236633, 0.441729337, -3.98036413e-08, -0.897148371, 8.61732801e-08, 1, -1.93767069e-09, 0.897148371, -7.64542918e-08, 0.441729337),
        CFrame.new(-247.711075, 25.6309118, -30.344408, 0.936370671, 0.0215997752, -0.350347638, -3.86210353e-08, 0.99810493, 0.0615354702, 0.351012826, -0.0576199964, 0.934596181)
    }
}

local function getRandomTargetCFrame(team)
    if team == "Home" then
        return goalCFrames.Away[math.random(1, #goalCFrames.Away)]
    elseif team == "Away" then
        return goalCFrames.Home[math.random(1, #goalCFrames.Home)]
    end
end

local function moveWithCurvedPath(ball, startPos, targetCF, height, duration, curveIntensity)
    local startTime = tick()
    local connection
    local endPos = targetCF.Position

    -- สุ่มว่าจะโค้งไปทางซ้าย (-1) หรือขวา (1)
    local curveDirection = math.random(0, 1) == 0 and -1 or 1

    connection = runService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed > duration then
            ball.CFrame = targetCF
            connection:Disconnect()
            return
        end

        local t = elapsed / duration
        local lerpPos = startPos:Lerp(endPos, t)

        local arcHeight = math.sin(t * math.pi) * height
        local horizontalCurve = math.sin(t * math.pi) * curveIntensity * curveDirection

        ball.CFrame = CFrame.new(
            lerpPos.X + horizontalCurve, -- โค้งซ้ายหรือขวา
            startPos.Y + arcHeight,     -- โค้งขึ้น-ลง
            lerpPos.Z
        )
    end)
end

-- local function moveWithCurvedPath(ball, startPos, targetCF, height, duration, curveIntensity)
--     local startTime = tick()
--     local connection
--     local endPos = targetCF.Position
--     connection = runService.RenderStepped:Connect(function()
--         local elapsed = tick() - startTime
--         if elapsed > duration then
--             ball.CFrame = targetCF
--             connection:Disconnect()
--             return
--         end

--         local t = elapsed / duration
--         local currentXZ = startPos:Lerp(endPos, t)

--         local arcHeight = math.sin(t * math.pi) * height
--         local curve = math.sin(t * math.pi * curveIntensity) * 15 -- เพิ่มความโค้งซ้าย-ขวา

--         ball.CFrame = CFrame.new(currentXZ.X + curve, startPos.Y + arcHeight, currentXZ.Z)
--     end)
-- end

local function teleportBallToGoal()
    local ball = getBall()
    if ball then
        local team = lp.Team and lp.Team.Name
        if team then
            local startPos = ball.Position
            local targetCFrame = getRandomTargetCFrame(team)
            if targetCFrame then
                moveWithCurvedPath(ball, startPos, targetCFrame, 10, 1, 150) -- เพิ่ม curveIntensity = 5
            end
        end
    end
end

bs.RE.Shoot.OnClientEvent:Connect(function()
    if ig then
        teleportBallToGoal()
    end
end)

local toggle = Tabs.OP:AddToggle("InstantGoalToggle", {
    Title = "Curve Shot Pro Max",
    Default = false,
    Callback = function(state)
        ig = state
    end
})

local keybind = Tabs.OP:AddKeybind("InstantKeybind", {
    Title = "Toggle Curve Shot Keybind",
    Mode = "Toggle",
    Default = "...",
    Callback = function()
        ig = not ig
        toggle:SetValue(ig)
        Fluent:Notify({
            Title = "Curve Shot Toggled",
            Content = "Curve Shot has been " .. (ig and "enabled" or "disabled") .. ".",
            Duration = 3
        })
    end,
    ChangedCallback = function(newKey)
        Fluent:Notify({
            Title = "Keybind Changed",
            Content = "Curve Shot Keybind is now set to: " .. tostring(newKey),
            Duration = 3
        })
    end
})

local SkillTitle = Tabs.OP:AddSection("No CD Skill")
-- Variables
local noCooldownEnabled = false

-- No Cooldown Skill Toggle
-- Toggle for Steal Function Override
Tabs.OP:AddToggle("NoCooldownSteal", {
Title = "No Cooldown - Steal",
Default = false,
Callback = function(state)
    if state then
        local originalSteal = require(game:GetService("ReplicatedStorage").Controllers.AbilityController.Abilities.Bachira.Steal)

        local TweenService = game:GetService("TweenService")
        local originalSteal = require(game:GetService("ReplicatedStorage").Controllers.AbilityController.Abilities.Bachira.Steal)
        
        local newSteal = function(v11, v12, v13)
            -- ข้ามเงื่อนไขคูลดาวน์และพลังงาน
            if false then -- ข้ามการตรวจสอบทุกอย่าง
                return
            end
        
            if v11.ABC then
                v11.ABC:Clean()
            end
            if v11.SlideTrove then
                v11.SlideTrove:Destroy()
            end
        
            -- ส่วนสำหรับเมื่อผู้เล่นมีบอล
            if v13.Values.HasBall.Value then
                v11.AbilityController:AbilityCooldown("1", 1) -- ไม่มีคูลดาวน์
                v11.StaminaService.DecreaseStamina:Fire(10) -- ไม่ลด Stamina
                v11.StatesController.States.Ability = true
                v11.StatesController.OwnWalkState = true
                v11.StatesController.SpeedBoost = 5
        
                task.delay(2, function()
                    v11.StatesController.States.Ability = false
                    v11.StatesController.OwnWalkState = false
                    v11.StatesController.SpeedBoost = 0
                end)
        
                v11.Animations:StopAnims()
                v11.Animations.Abilities.HeelPass.Priority = Enum.AnimationPriority.Action3
                v11.Animations.Abilities.HeelPass:Play()
                v11.Animations.Ball.HeelPass.Priority = Enum.AnimationPriority.Action3
                v11.Animations.Ball.HeelPass:Play()
                v11.AbilityService.Ability:Fire("HeelPass")
                v11.ABC:Connect(v11.AbilityService.Ability, function(v14)
                    v11.ABC:Clean()
                    v11.StatesController.States.Ability = false
                    v11.StatesController.OwnWalkState = false
                    v11.StatesController.SpeedBoost = 0
                    v14.AssemblyLinearVelocity = (v13.HumanoidRootPart.CFrame.LookVector + Vector3.new(0, 0.55, 0)) * 80
                    v11.BallController:DragBall(v14)
                end)
            else
                -- ส่วนสำหรับเมื่อผู้เล่นไม่มีบอล
                v11.AbilityController:AbilityCooldown("1", 1) -- ไม่มีคูลดาวน์
                v11.StaminaService.DecreaseStamina:Fire(10) -- ไม่ลด Stamina
                v11.Animations:StopAnims()
                v11.Animations.Abilities.Steal.Priority = Enum.AnimationPriority.Action
                v11.Animations.Abilities.Steal:Play()
        
                -- เรียกใช้ RemoteEvent "Slide" เพื่อ FireServer
                game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Slide:FireServer()
        
                -- ใช้ TweenService แทนการพุ่งด้วย BodyVelocity
                local rootPart = v13.HumanoidRootPart
                if rootPart then
                    local targetPosition = rootPart.Position + (rootPart.CFrame.LookVector * 30) -- พุ่งไปข้างหน้า 10 หน่วย
        
                    local tweenInfo = TweenInfo.new(
                        0.4, -- ระยะเวลาพุ่ง (0.5 วินาที)
                        Enum.EasingStyle.Linear, -- รูปแบบการเคลื่อนไหวแบบ Linear
                        Enum.EasingDirection.Out, -- ทิศทางการเคลื่อนไหวแบบ Out
                        0, -- จำนวนรอบ (0 = ไม่ทำซ้ำ)
                        false, -- ไม่ย้อนกลับ
                        0 -- ไม่มีดีเลย์ก่อนเริ่ม Tween
                    )
        
                    local tweenGoal = {Position = targetPosition}
                    local tween = TweenService:Create(rootPart, tweenInfo, tweenGoal)
        
                    tween:Play()
        
                    tween.Completed:Connect(function()
                        tween:Destroy() -- ลบ Tween หลังการใช้งาน
                    end)
                end
            end
        end
        
        -- แทนที่ฟังก์ชันใน ModuleScript
        hookfunction(originalSteal, newSteal)
        Fluent:Notify({ Title = "No Cooldown - Steal Enabled", Content = "Cooldown removed for Steal.", Duration = 3 })
    else
        Fluent:Notify({ Title = "No Cooldown - Steal Disabled", Content = "Cooldown restored for Steal.", Duration = 3 })
    end
end
})

-- Toggle for AirDribble Function Override
Tabs.OP:AddToggle("NoCooldownAirDribble", {
Title = "No Cooldown - AirDribble",
Default = false,
Callback = function(state)
    if state then
        local airdribbleModule = require(game:GetService("ReplicatedStorage").Controllers.AbilityController.Abilities.Nagi.AirDribble)

        -- Hook the original AirDribble function
        local originalAirDribble = airdribbleModule
        
        -- Define the new function
        local function newAirDribble(v13, v14, v15)
            if v13.__trapped then
                if not v15.Values.HasBall.Value then
                    return
                else
                    v14.PlayerGui.InGameUI.Bottom.Abilities["1"].Timer.Text = "Trap"
                    v13.Animations:StopAnims()
                    v13.Animations.Abilities.AirDribbleShoot.Priority = Enum.AnimationPriority.Action4
                    v13.Animations.Abilities.AirDribbleShoot:Play()
                    v13.Animations.Ball.AirDribbleShoot.Priority = Enum.AnimationPriority.Action4
                    v13.Animations.Ball.AirDribbleShoot:Play()
                    if v13.ABC then
                        v13.ABC:Clean()
                    end
                    v13.ABC:Add(function()
                        v13.__trapped = nil
                    end)
                    task.delay(0.35, function()
                        v13.AbilityService.Ability:Fire("AirDribble", "shotStart")
                    end)
                    v13.ABC:Add(v13.AbilityService.Ability:Connect(function(v16)
                        v16.AssemblyLinearVelocity = (workspace.CurrentCamera.CFrame.LookVector + Vector3.new(0, 0.35, 0)) * 125
                        v13.BallController:DragBall(v16)
                    end))
                    return
                end
            else
                if v13.ABC then
                    v13.ABC:Clean()
                end
                v14.PlayerGui.InGameUI.Bottom.Abilities["1"].Timer.Text = "Shoot"
                task.delay(0.45, function()
                    v13.InAbility = true
                end)
                local l_Value_0 = v15.Values.HasBall.Value
                v15.HumanoidRootPart.Anchored = true
                v13.AbilityService.Ability:Fire("AirDribble")
                v13.Animations:StopAnims()
                if l_Value_0 then
                    v13.Animations.Abilities.AirDribbleUp.Priority = Enum.AnimationPriority.Action2
                    v13.Animations.Abilities.AirDribbleUp:Play()
                    v13.Animations.Ball.AirDribbleUp.Priority = Enum.AnimationPriority.Action2
                    v13.Animations.Ball.AirDribbleUp:Play()
                    v13.Animations.Abilities.AirDribbleUp:AdjustSpeed(1.35)
                    v13.Animations.Ball.AirDribbleUp:AdjustSpeed(1.35)
                end
                v13.Animations.Ball.AirDribbleStart.Priority = Enum.AnimationPriority.Action3
                v13.Animations.Ball.AirDribbleStart:Play()
                v13.Animations.Ball.AirDribbleStart:AdjustSpeed(1.35)
                v13.Animations.Abilities.AirDribbleStart.Priority = Enum.AnimationPriority.Action3
                v13.Animations.Abilities.AirDribbleStart:Play()
                v13.__trapped = true
                v13.ABC:Add(function()
                    v13.__trapped = nil
                end)
                local v18 = os.time() + 4
                task.delay(0.65, function()
                    v13.ABC:Connect(game:GetService("RunService").Heartbeat, function()
                        if v15 == nil then
                            if v13.ABC then
                                v13.ABC:Clean()
                            end
                            v13.InAbility = false
                            return
                        else
                            if v15.Values.HasBall.Value then
                                l_Value_0 = true
                            end
                            if (v18 < os.time() or not v13.InAbility or not v15.Values.HasBall.Value and l_Value_0) and v13.ABC then
                                v13.ABC:Clean()
                            end
                            return
                        end
                    end)
                end)
                v13.ABC:Add(function()
                    v14.PlayerGui.InGameUI.Bottom.Abilities["1"].Timer.Text = "Trap"
                    task.delay(0.15, function()
                        v15.HumanoidRootPart.Anchored = false
                    end)
                    v13.InAbility = false
                    v13.Animations.Abilities.AirDribbleStart:Stop()
                    v13.Animations.Ball.AirDribbleStart:Stop()
                end)
                return
            end
        end
        
        -- Hook the function using hookfunction
        hookfunction(originalAirDribble, newAirDribble)
        Fluent:Notify({ Title = "No Cooldown - AirDribble Enabled", Content = "Cooldown removed for AirDribble.", Duration = 3 })
    else
        Fluent:Notify({ Title = "No Cooldown - AirDribble Disabled", Content = "Cooldown restored for AirDribble.", Duration = 3 })
    end
end
})

-- Toggle for AirDash Function Override
Tabs.OP:AddToggle("NoCooldownAirDash", {
Title = "No Cooldown - AirDash",
Default = false,
Callback = function(state)
    if state then
        local originalAirDash = require(game:GetService("ReplicatedStorage").Controllers.AbilityController.Abilities.Nagi.AirDash)

        local function newAirDash(v13, v14, v15)
            if v13.ABC then
                v13.ABC:Clean()
            end
        
            -- Un-anchor the player's HumanoidRootPart
            v15.HumanoidRootPart.Anchored = false
        
            -- Stop animations
            v13.Animations:StopAnims()
        
            -- Determine dash direction
            local dashDirection = "Right"
            if v15.HumanoidRootPart.CFrame:VectorToObjectSpace(v15.Humanoid.MoveDirection).X < 0 then
                dashDirection = "Left"
            end
            local directionVector = dashDirection == "Right" and v15.HumanoidRootPart.CFrame.RightVector or -v15.HumanoidRootPart.CFrame.RightVector
        
            -- Adjust position instantly
            local dashDistance = 15 -- Dash distance
            v15.HumanoidRootPart.CFrame = v15.HumanoidRootPart.CFrame + (directionVector * dashDistance)
        
            -- Trigger ability and animations
            v13.AbilityService.Ability:Fire("AirDash", directionVector)
            v13.Animations.Abilities["AirDribble" .. dashDirection].Priority = Enum.AnimationPriority.Action4
            v13.Animations.Abilities["AirDribble" .. dashDirection]:Play()
            v13.Animations.Ball["AirDribble" .. dashDirection].Priority = Enum.AnimationPriority.Action4
            v13.Animations.Ball["AirDribble" .. dashDirection]:Play()
        end
        
        -- Hook the original AirDash function

        hookfunction(originalAirDash, newAirDash)
        Fluent:Notify({ Title = "No Cooldown - AirDash Enabled", Content = "Cooldown removed for AirDash.", Duration = 3 })
    else
        Fluent:Notify({ Title = "No Cooldown - AirDash Disabled", Content = "Cooldown restored for AirDash.", Duration = 3 })
    end
end
})
----------------- Spin Tab ------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Paths to Spins, Money, and Style
local ProfileStats = LocalPlayer:WaitForChild("ProfileStats")
local PlayerStats = LocalPlayer:WaitForChild("PlayerStats")
local Spins = ProfileStats:WaitForChild("Spins")
local Money = ProfileStats:WaitForChild("Money")
local FlowSpins = ProfileStats:WaitForChild("FlowSpins")
local Style = PlayerStats:WaitForChild("Style")
local Flow = PlayerStats:WaitForChild("Flow")

-- Initialize Auto Spin Variables
local AutoSpinEnabled = false
local SelectedStyles = {}

local StyleTitle = Tabs.Spin:AddSection("Style Spin")

-- Add MultiDropdown for Style Selection
local MultiDropdown = Tabs.Spin:AddDropdown("StyleLockDropdown", {
    Title = "Style Lock",
    Description = "Select styles to stop spinning.",
    Values = {"Isagi", "Chigiri", "Bachira", "Gagamaru", "King", "Nagi", "Reo", "Shidou", "Sae", "Aiku", "Rin", "Hiori", "Yukimiya"}, -- Replace with actual style names
    Multi = true,
    Default = {}
})

MultiDropdown:OnChanged(function(Value)
    -- Clear and rebuild SelectedStyles
    SelectedStyles = {}
    for StyleName, IsSelected in next, Value do
        if IsSelected then
            table.insert(SelectedStyles, StyleName)
        end
    end
    Fluent:Notify({
        Title = "Style Lock Updated",
        Content = "Selected styles: " .. table.concat(SelectedStyles, ", "),
        Duration = 3
    })
end)

-- Add Toggle for Auto Spin
local AutoSpinToggle = Tabs.Spin:AddToggle("AutoSpinToggle", {
    Title = "Auto Spin",
    Default = false,
    Callback = function(Value)
        AutoSpinEnabled = Value
        if Value then
            task.spawn(function()
                while AutoSpinEnabled do
                    -- Check if player has Spins and Money
                    if Spins.Value > 0 or Money.Value > 2500 then
                        -- Check if the current style matches any selected style
                        if table.find(SelectedStyles, Style.Value) then
                            Fluent:Notify({
                                Title = "Style Locked",
                                Content = "You obtained: " .. Style.Value,
                                Duration = 5
                            })
                            AutoSpinEnabled = false
                            AutoSpinToggle:SetValue(false)
                            break
                        end

                        -- Fire the Spin Remote
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RE.Spin:FireServer()
                        task.wait(0.5) -- Add a small delay to prevent spamming

                    else
                        Fluent:Notify({
                            Title = "Auto Spin",
                            Content = "Insufficient Spins or Money.",
                            Duration = 5
                        })
                        AutoSpinEnabled = false
                        AutoSpinToggle:SetValue(false)
                        break
                    end
                end
            end)
        end
    end
})
local FlowTitle = Tabs.Spin:AddSection("Flow Spin")

local AutoFlowEnabled = false
local SelectedFlow = {}

-- Add MultiDropdown for Flow Lock
local MultiDropdown = Tabs.Spin:AddDropdown("FlowLockDropdown", {
    Title = "Flow Lock",
    Description = "Select Flow to stop spinning.",
    Values = {"Lightning", "Puzzle", "Monster", "Gale Burst", "Genius", "King's Instinct", "Trap", "Demon Wings", "Chameleon", "Wild Card", "Snake", "Prodigy", "Awakened Genius", "Dribbler"}, -- Actual flow names
    Multi = true,
    Default = {}
})

-- Update Selected Styles from Dropdown
MultiDropdown:OnChanged(function(Value)
    SelectedFlow = {}
    for FlowName, IsSelected in next, Value do
        if IsSelected then
            table.insert(SelectedFlow, FlowName)
        end
    end
    Fluent:Notify({
        Title = "Flow Lock Updated",
        Content = "Selected Flow: " .. table.concat(SelectedFlow, ", "),
        Duration = 3
    })
end)

-- Add Toggle for Auto Spin
local AutoFlowToggle = Tabs.Spin:AddToggle("AutoFlowToggle", {
    Title = "Auto Flow Spin",
    Default = false,
    Callback = function(Value)
        AutoFlowEnabled = Value
        if Value then
            task.spawn(function()
                while AutoFlowEnabled do
                    -- Check if player has Spins and Money
                    if FlowSpins.Value > 0 or Money.Value >= 2000 then -- Adjusted Money value for spin cost
                        -- Check if the current style matches any selected style
                        if table.find(SelectedFlow, Flow.Value) then
                            Fluent:Notify({
                                Title = "Flow Lock Activated",
                                Content = "You obtained: " .. Flow.Value,
                                Duration = 5
                            })
                            AutoFlowEnabled = false
                            AutoFlowToggle:SetValue(false)
                            break
                        end

                        -- Fire the Spin Remote
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.FlowService.RE.Spin:FireServer()
                        task.wait(0.5) -- Delay to prevent spamming

                    else
                        Fluent:Notify({
                            Title = "Auto Flow Spin",
                            Content = "Insufficient Spins or Money.",
                            Duration = 5
                        })
                        AutoSpinEnabled = false
                        AutoSpinToggle:SetValue(false)
                        break
                    end
                end
            end)
        end
    end
})

------------------------------------------------- Rage -----------------------------------------------------------------
local function getBall()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Football" then
            return obj
        end
    end
    return nil
end

local function autoGoal(targetGoal)
    local ball = getBall()
    if ball and ball:IsA("BasePart") then
        ball.CFrame = targetGoal.CFrame + Vector3.new(0, 0, 1)
    end
end

local function teleportAllToPosition(pos)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end
end

local function freezeAllPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            root.Anchored = true
        end
    end
end

local function unfreezeAllPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            root.Anchored = false
        end
    end
end

local function nukeServer()
    local ball = getBall()
    for i = 1, 50 do
        if ball then
            ball.CFrame = CFrame.new(Vector3.new(math.random(-500, 500), math.random(50, 100), math.random(-500, 500)))
            wait(0.1)
        end
    end
end

-- Get goals for auto-goal targeting
local homeGoal = workspace.Goals.Home
local awayGoal = workspace.Goals.Away

----------------- Rage Tab ------------------
local RageTitle = Tabs.Rage:AddSection("Rage Features")

local autoGoalEnabled = false

local autoGoalToggle = Tabs.Rage:AddToggle("autoGoalToggle", {
    Title = "Auto Goal (Spam)",
    Description = "Toggle spamming auto-goals into the opponent's net.",
    Default = false,
    Callback = function(state)
        autoGoalEnabled = state
        if autoGoalEnabled then
            Fluent:Notify({
                Title = "Auto Goal (Spam)",
                Content = "Spamming goals enabled! Opponents will cry >:D",
                Duration = 3
            })
            task.spawn(function()
                while autoGoalEnabled do
                    if autoGoalEnabled == false then break end

                    -- Find the football
                    local football = findFootball()

                    if football and football:IsA("BasePart") then
                        -- Determine which goal to teleport the ball into
                        local targetGoal = nil
                        local player = game.Players.LocalPlayer

                        if player.Team and player.Team.Name == "Home" then
                            targetGoal = AwayGoal
                        elseif player.Team and player.Team.Name == "Away" then
                            targetGoal = HomeGoal
                        end

                        if targetGoal then
                            football.CFrame = targetGoal.CFrame

                            shootBall()
                        end
                    end

                    task.wait(0.2)
                end
            end)
        else
            Fluent:Notify({
                Title = "Auto Goal (Spam)",
                Content = "Spamming goals disabled! You're being nice now.",
                Duration = 3
            })
        end
    end
})

local autoSlideToggle = Tabs.Rage:AddToggle("autoSlideToggle", {
    Title = "Auto Slide (Steal Ball)",
    Description = "Automatically slide to steal the ball from opponents.",
    Default = false,
    Callback = function(state)
        autoSlideEnabled = state
        if autoSlideEnabled then
            Fluent:Notify({
                Title = "Auto Slide",
                Content = "Automatic sliding to steal the ball is now enabled!",
                Duration = 3
            })

            task.spawn(function()
                while autoSlideEnabled do
                    local player = game.Players.LocalPlayer

                    if not player.Character or not player.Character:FindFirstChild("Values") then
                        task.wait(0.1)
                    end

                    local hasBall = player.Character.Values:FindFirstChild("HasBall")
                    if hasBall and not hasBall.Value then

                        local football = findFootball()

                        if football and football:IsA("BasePart") then

                            local distance = (player.Character.HumanoidRootPart.Position - football.Position).Magnitude
                            if distance <= 20 then
                                
                                game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Slide:FireServer()
                            end
                        end
                    end

                    task.wait(0.1)
                end
            end)
        else
            Fluent:Notify({
                Title = "Auto Slide",
                Content = "Automatic sliding to steal the ball is now disabled!",
                Duration = 3
            })
        end
    end
})

local autoTeleportToggle = Tabs.Rage:AddToggle("autoTeleportToggle", {
    Title = "Auto Teleport to Ball",
    Description = "Automatically teleport to the ball when active.",
    Default = false,
    Callback = function(state)
        autoTeleportEnabled = state
        if autoTeleportEnabled then
            Fluent:Notify({
                Title = "Auto Teleport",
                Content = "Teleporting to the ball is now enabled!",
                Duration = 3
            })

            task.spawn(function()
                while autoTeleportEnabled do
                    local player = game.Players.LocalPlayer

                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local football = findFootball()

                        if football and football:IsA("BasePart") then
                            local humanoidRootPart = player.Character.HumanoidRootPart
                            humanoidRootPart.CFrame = football.CFrame + Vector3.new(0, 5, 0) -- Add slight offset above the ball
                        end
                    end

                    task.wait(0.1)
                end
            end)
        else
            Fluent:Notify({
                Title = "Auto Teleport",
                Content = "Teleporting to the ball is now disabled.",
                Duration = 3
            })
        end
    end
})


Tabs.Rage:AddButton({
    Title = "Teleport All Players",
    Description = "Teleport all players to a random position on the map.",
    Callback = function()
        local randomPos = Vector3.new(math.random(-200, 200), math.random(50, 100), math.random(-200, 200))
        teleportAllToPosition(randomPos)
        Fluent:Notify({
            Title = "Teleport All Players",
            Content = "Everyone teleported to: " .. tostring(randomPos),
            Duration = 3
        })
    end
})

Tabs.Rage:AddButton({
    Title = "Freeze All Players",
    Description = "Freeze every player in the server.",
    Callback = function()
        freezeAllPlayers()
        Fluent:Notify({
            Title = "Freeze Players",
            Content = "Everyone is now frozen. Haha!",
            Duration = 3
        })
    end
})

Tabs.Rage:AddButton({
    Title = "Unfreeze All Players",
    Description = "Unfreeze all players in the server.",
    Callback = function()
        unfreezeAllPlayers()
        Fluent:Notify({
            Title = "Unfreeze Players",
            Content = "Everyone is now unfrozen.",
            Duration = 3
        })
    end
})

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
