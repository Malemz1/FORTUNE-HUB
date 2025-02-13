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
    SubTitle = "by Rowlet/Blobby",
    TabWidth = 160,
    Size = Device,
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Legit = Window:AddTab({ Title = "Legit", Icon = "align-justify" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "view" }),
    Kaitan = Window:AddTab({ Title = "Kaitan", Icon = "crown" }),
    OP = Window:AddTab({ Title = "OP", Icon = "apple" }),
    Spin = Window:AddTab({ Title = "Spin", Icon = "box" }),
    Item = Window:AddTab({ Title = "Item", Icon = "archive" }),
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

local ToggleTG = Tabs.Legit:AddToggle("HitboxTG", { Title = "Hitbox", Default = false })
Options.HitboxTG = ToggleTG

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

ToggleTG:OnChanged(function()
    local toggleValue = Options.HitboxTG.Value
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

local Input = Tabs.Legit:AddInput("HitboxIP", {
    Title = "Hitbox Size",
    Default = tostring(currentSize),
    Placeholder = "Enter size (1-30)",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local newSize = tonumber(Value)
        if newSize and newSize >= 1 and newSize <= 30 then
            currentSize = newSize
            if Options.HitboxTG.Value then
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
    Default = "",
    Callback = function()

        local currentState = Options.HitboxTG.Value
        Options.HitboxTG:SetValue(not currentState)
        Fluent:Notify({
            Title = "Hitbox Toggled",
            Content = "Hitbox has been " .. (Options.HitboxTG.Value and "enabled" or "disabled") .. ".",
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

local v = game:GetService("VirtualInputManager")
local lp = game:GetService("Players").LocalPlayer
local ws = game:GetService("Workspace")
local d = 20
local tracked = {}
local enabled = false

local AutoDB = Tabs.Legit:AddToggle("AutoDribble", {Title = "AutoDribble", Description = "Testing.", Default = false })

AutoDB:OnChanged(function(val)
    enabled = val
            Fluent:Notify({
            Title = "AutoDribble",
            Content = "AutoDribble " .. (enabled  and "enabled" or "disabled") .. ".",
            Duration = 3
        })
end)

local function isSameTeam(p)
    return p.Team == lp.Team -- ✅ ถ้าอยู่ทีมเดียวกัน return true
end

local function triggerQ(p)
    if enabled and p and p:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        if isSameTeam(game:GetService("Players"):FindFirstChild(p.Name)) then return end -- ❌ ไม่กด Q ถ้าอยู่ทีมเดียวกัน
        
        local dist = (lp.Character.HumanoidRootPart.Position - p.HumanoidRootPart.Position).Magnitude
        if dist <= d then
            v:SendKeyEvent(true, Enum.KeyCode.Q, false, nil)
            task.wait()
            v:SendKeyEvent(false, Enum.KeyCode.Q, false, nil)
            return true
        end
    end
    return false
end

local function checkPlayer(p)
    local pws = ws:FindFirstChild(p.Name)
    if not pws or isSameTeam(p) then return end -- ❌ ไม่ track ถ้าอยู่ทีมเดียวกัน
    tracked[pws] = { inside = false }

    local s = pws:FindFirstChild("Values") and pws.Values:FindFirstChild("Sliding")
    if s then
        s.Changed:Connect(function(val)
            if enabled and val and triggerQ(pws) then
                tracked[pws].inside = true
            end
        end)
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    if not enabled then return end -- ❌ หยุดทำงานถ้า Toggle ปิด

    for pws, data in pairs(tracked) do
        if pws and pws:FindFirstChild("HumanoidRootPart") then
            local p = game:GetService("Players"):FindFirstChild(pws.Name)
            if p and isSameTeam(p) then continue end -- ❌ ไม่กด Q ถ้าอยู่ทีมเดียวกัน

            local dist = (lp.Character.HumanoidRootPart.Position - pws.HumanoidRootPart.Position).Magnitude
            local s = pws:FindFirstChild("Values") and pws.Values:FindFirstChild("Sliding")
            local isSliding = s and s.Value

            for _, c in pairs(pws:GetChildren()) do
                if c.Name:match("^Slide%d+$") or isSliding then
                    if dist <= d and not data.inside then
                        if triggerQ(pws) then
                            tracked[pws].inside = true
                        end
                    elseif dist > d then
                        tracked[pws].inside = false
                    end
                    break
                end
            end
        end
    end
end)

ws.ChildAdded:Connect(function(c)
    local p = game:GetService("Players"):FindFirstChild(c.Name)
    if p and not isSameTeam(p) then
        checkPlayer(p)
    end
end)

for _, p in pairs(game:GetService("Players"):GetPlayers()) do
    if ws:FindFirstChild(p.Name) and not isSameTeam(p) then
        checkPlayer(p)
    end
end

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

local ToggleAFK = Tabs.Legit:AddToggle("AntiAFK", {Title = "Anti-AFK", Default = false})

local afkLoop
ToggleAFK:OnChanged(function(state)
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

local p = 500
local plr = game:GetService("Players").LocalPlayer
local mouse = plr:GetMouse()

local function shootBall()
    local args = {
        [1] = p,
        [4] = mouse
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("BallService"):WaitForChild("RE"):WaitForChild("Shoot"):FireServer(unpack(args))
    
end

local InstantKick = Tabs.Legit:AddKeybind("KickKeybind", {
    Title = "Shoot Keybind",
    Mode = "Toggle",
    Default = "",
    Callback = function()
        shootBall()
    end,
})

local InputPower = Tabs.Legit:AddInput("PowerInput", {
    Title = "Adjust Power (1-100000)",
    Default = "500",
    Placeholder = "Enter power...",
    Numeric = true,
    Finished = true,
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue and numValue >= 1 and numValue <= 100000 then
            p = numValue
            Fluent:Notify({
                Title = "Power Adjustment",
                Content = "Power updated to: " .. p,
                Duration = 3
            })
        else
            p = 500
            Fluent:Notify({
                Title = "Invalid Input",
                Content = "Out of range! Power reset to: " .. p,
                Duration = 3
            })
        end
    end,
})
----------------- ESP -------------------------
local p = game:GetService("Players")
local r = game:GetService("RunService")
local cam = workspace.CurrentCamera
local lp = p.LocalPlayer
local espEnabled = false
local espFeatures = {Style = true, Awakening = true, Flow = true, Stamina = true}
local espObjects = {}

local function createESP(plr)
    if plr == lp then return end
    local espData = {}

    local function onCharacterAdded(c)
        local h = c:WaitForChild("HumanoidRootPart", 10)
        if not h then return end

        local function createBillboard(size, offset)
            local b = Instance.new("BillboardGui")
            b.Adornee = h
            b.Size = size
            b.StudsOffset = offset
            b.AlwaysOnTop = true
            b.Parent = game.CoreGui
            return b
        end

        local styleGui = createBillboard(UDim2.new(3, 0, 1, 0), Vector3.new(0, 4, 0))
        local styleTxt = Instance.new("TextLabel", styleGui)
        styleTxt.Size = UDim2.new(1, 0, 1, 0)
        styleTxt.BackgroundTransparency = 1
        styleTxt.TextStrokeTransparency = 0.5
        styleTxt.TextColor3 = Color3.new(1, 1, 1)
        styleTxt.TextScaled = true
        styleTxt.Text = "Style: ???"

        local function createBarGui(offset)
            local gui = createBillboard(UDim2.new(2, 0, 6, 0), offset)
            local frame = Instance.new("Frame", gui)
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 1
            return gui, frame
        end

        local function createBar(parent, color, pos)
            local bg = Instance.new("Frame", parent)
            bg.Size = UDim2.new(0.2, 0, 0.8, 0)
            bg.Position = UDim2.new(pos, 0, 0.1, 0)
            bg.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            bg.BackgroundTransparency = 0.3
            bg.BorderSizePixel = 0

            local fill = Instance.new("Frame", bg)
            fill.Size = UDim2.new(1, 0, 1, 0)
            fill.AnchorPoint = Vector2.new(0, 1)
            fill.Position = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = color
            fill.BorderSizePixel = 0

            return fill
        end

        local awakeGui, awakeFrame = createBarGui(Vector3.new(4, 0, 0))
        local flowGui, flowFrame = createBarGui(Vector3.new(4.2, 0, 0))
        local stamGui, stamFrame = createBarGui(Vector3.new(4.4, 0, 0))

        local awkBar = createBar(awakeFrame, Color3.new(1, 0.2, 0.2), 0)
        local flowBar = createBar(flowFrame, Color3.new(0.921569, 1.000000, 0.200000), 0.25)
        local stmBar = createBar(stamFrame, Color3.new(0.196078, 0.019608, 1.000000), 0.5)

        table.insert(espData, {gui = styleGui, feature = "Style"})
        table.insert(espData, {gui = awakeGui, feature = "Awakening"})
        table.insert(espData, {gui = flowGui, feature = "Flow"})
        table.insert(espData, {gui = stamGui, feature = "Stamina"})

        r.RenderStepped:Connect(function()
            if c and h and cam then
                local dist = (cam.CFrame.Position - h.Position).Magnitude
                styleGui.Size = UDim2.new(math.clamp(dist / 10, 3, 10), 0, math.clamp(dist / 20, 1, 5), 0)

                local s = plr:FindFirstChild("PlayerStats")
                if s then
                    styleTxt.Text = (s:FindFirstChild("Style") and s.Style.Value or "None")
                    awkBar.Size = UDim2.new(1, 0, math.clamp((s:FindFirstChild("AwakeningBar") and s.AwakeningBar.Value or 0) / 100, 0, 1), 0)
                    flowBar.Size = UDim2.new(1, 0, math.clamp((s:FindFirstChild("FlowBar") and s.FlowBar.Value or 0) / 100, 0, 1), 0)
                    stmBar.Size = UDim2.new(1, 0, math.clamp((s:FindFirstChild("Stamina") and s.Stamina.Value or 0) / 100, 0, 1), 0)
                end

                for _, obj in ipairs(espData) do
                    obj.gui.Enabled = espEnabled and espFeatures[obj.feature]
                end
            end
        end)
    end

    if plr.Character then
        onCharacterAdded(plr.Character)
    end
    plr.CharacterAdded:Connect(onCharacterAdded)

    espObjects[plr] = espData
end

for _, v in pairs(p:GetPlayers()) do
    createESP(v)
end

p.PlayerAdded:Connect(createESP)

local UI = Tabs.Visual
local espToggle = UI:AddToggle("espToggle", {Title = "Enable ESP", Default = false})
espToggle:OnChanged(function(value)
    espEnabled = value
    for _, data in pairs(espObjects) do
        for _, obj in ipairs(data) do
            obj.gui.Enabled = espEnabled and espFeatures[obj.feature]
        end
    end
end)

for _, feature in pairs({"Style", "Awakening", "Flow", "Stamina"}) do
    local toggle = UI:AddToggle(feature .. "Toggle", {Title = "Enable " .. feature, Default = true})
    toggle:OnChanged(function(value)
        espFeatures[feature] = value
        for _, data in pairs(espObjects) do
            for _, obj in ipairs(data) do
                if obj.feature == feature then
                    obj.gui.Enabled = espEnabled and espFeatures[feature]
                end
            end
        end
    end)
end

----------------- Kaitan Tab ------------------
local Striker = Tabs.Kaitan:AddSection("Striker")

-- 🛠️ โหลด Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- 📌 กำหนดตัวแปรหลัก
local plr = Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local State = ReplicatedStorage:FindFirstChild("GameState") or Instance.new("StringValue") -- ตรวจสอบสถานะเกม

local HomeGoal = Workspace:FindFirstChild("HomeGoal")
local AwayGoal = Workspace:FindFirstChild("AwayGoal")

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

local Toggle1 = Tabs.Kaitan:AddToggle("AutoFarmTG", { Title = "Auto Farm(Tween)", Default = false })

Toggle1:OnChanged(function()
    _G.AutoFarm = Toggle1.Value
    if _G.AutoFarm then
        task.spawn(function()
            while _G.AutoFarm do
                task.wait()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)

                player.CharacterAdded:Connect(function(newCharacter)
                    character = newCharacter
                    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
                end)

                local function noclip()
                    for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        if v:IsA("BasePart") and v.CanCollide == true then
                            v.CanCollide = false
                            HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        end
                    end
                end

                local function Goto(Target, Goal, Action)
                    local NoClipConnect
                    local TweenService = game:GetService("TweenService")
                    local Distance = (HumanoidRootPart.Position - Target.Position).Magnitude
                    local Speed = 80
                    local Tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear), {CFrame = Target})
                    NoClipConnect = game:GetService("RunService").Stepped:Connect(noclip)
                    Tween:Play()
                    local ActionActive = Action or "None"
                    if ActionActive == "Slide" then
                        Tween.Completed:Connect(function()
                            if Distance < 3 then
                                game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Slide:FireServer()
                            end
                        end)
                    elseif ActionActive == "Kick" then
                        Tween.Completed:Connect(function()
                            local args = {
                                [1] = 100,
                                [4] = workspace.Goals[Goal].Position
                            }
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Shoot:FireServer(unpack(args))
                            task.wait(.1)
                            local Ball = workspace:FindFirstChild("Football") or workspace:WaitForChild("Football", 5)
                            if Ball then
                                repeat task.wait()
                                    Ball.CFrame = workspace.Goals[Goal].CFrame * CFrame.new(0, 0, 10)
                                    NoClipConnect:Disconnect()
                                until Ball.CFrame == workspace.Goals[Goal].CFrame * CFrame.new(0, 0, 10)
                            end
                        end)
                    end
                end

                function ClosestCharacter(originCharacter, searchInWorkspace)
                    local closestCharacter = nil
                    local shortestDistance = math.huge
                    
                    if not originCharacter or not originCharacter:FindFirstChild("HumanoidRootPart") then
                        return nil
                    end
                    
                    local originPosition = originCharacter.HumanoidRootPart.Position

                    local searchArea = searchInWorkspace or game.Workspace

                    for _, model in ipairs(searchArea:GetDescendants()) do
                        if model:IsA("Model") and model ~= originCharacter and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChild("Football") then
                            local targetPosition = model.HumanoidRootPart.Position
                            local distance = (originPosition - targetPosition).Magnitude

                            if distance < shortestDistance then 
                                shortestDistance = distance
                                closestCharacter = model
                            end
                        end
                    end

                    return closestCharacter
                end

                while _G.AutoFarm do
                    task.wait()
                    local Values = character:FindFirstChild("Values") or character:WaitForChild("Values", 5)
                    local HasBall = Values:FindFirstChild("HasBall") or Values:WaitForChild("HasBall", 5)
                    local Goal = {
                        ["Away"] = "Away",
                        ["Home"] = "Home"
                    }
                    if player.Team.Name == "Visitor" then
                        task.wait(.1)
                    else
                        if HumanoidRootPart:FindFirstChild("Antifall") then
                            if HasBall.Value then
                                Goto(HumanoidRootPart.CFrame * CFrame.new(0, 50, 0), Goal[game.Players.LocalPlayer.Team.Name], "Kick")
                                task.wait(2)
                            else
                                if workspace:FindFirstChild("Football") then
                                    for BallIndex, BallValue in pairs(workspace:GetChildren()) do
                                        if BallValue.Name == "Football" and BallValue:FindFirstChild("Hitbox") then
                                            Goto(BallValue.CFrame * CFrame.new(0, 3.5, 0), Goal[game.Players.LocalPlayer.Team.Name])
                                        end
                                    end
                                else
                                    local Target = ClosestCharacter(character)
                                    local Ball = Target:FindFirstChild("Football") or Target:WaitForChild("Football")

                                    Goto(Ball.CFrame, Goal[game.Players.LocalPlayer.Team.Name], "Slide")
                                end
                            end
                        else
                            local antifall = Instance.new("BodyVelocity", HumanoidRootPart)
                            antifall.P = 1250
                            antifall.Velocity = Vector3.new(0, 0, 0)
                            antifall.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            antifall.Name = "Antifall"
                        end
                    end
                end
                task.wait(.1)
                if not _G.AutoFarm then
                    for i, v in pairs(HumanoidRootPart:GetChildren()) do
                        if v.Name == "Antifall" and v:IsA("BodyVelocity") then
                            v:Destroy()
                        end
                    end
                end
            end
        end)
    end
end)

local Toggle2 = Tabs.Kaitan:AddToggle("AutoFarmTP", { Title = "Auto Farm(TP)", Default = false })

Toggle2:OnChanged(function()
    _G.AutoFarm1 = Toggle2.Value
    if _G.AutoFarm1 then
        task.spawn(function()
            while _G.AutoFarm1 do
                task.wait()
                local p = game.Players.LocalPlayer
                local c = p.Character or p.CharacterAdded:Wait()
                local hrp = c:FindFirstChild("HumanoidRootPart") or c:WaitForChild("HumanoidRootPart", 5)

                p.CharacterAdded:Connect(function(nc)
                    c = nc
                    hrp = nc:WaitForChild("HumanoidRootPart")
                end)

                function Goto(t, g, a)
                    hrp.CFrame = t
                    if a == "Slide" then
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Slide:FireServer()
                    elseif a == "Kick" then
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Shoot:FireServer(100, nil, nil, workspace.Goals[g].Position)
                        task.wait(.1)
                        local ball = workspace:FindFirstChild("Football") or workspace:WaitForChild("Football", 5)
                        if ball then
                            repeat task.wait()
                                ball.CFrame = workspace.Goals[g].CFrame * CFrame.new(0, 0, 10)
                            until ball.CFrame == workspace.Goals[g].CFrame * CFrame.new(0, 0, 10)
                        end
                    end
                end

                function ClosestCharacter(o, w)
                    local c, d = nil, math.huge
                    if not o or not o:FindFirstChild("HumanoidRootPart") then return nil end
                    for _, m in ipairs((w or workspace):GetDescendants()) do
                        if m:IsA("Model") and m ~= o and m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChild("Football") then
                            local dist = (o.HumanoidRootPart.Position - m.HumanoidRootPart.Position).Magnitude
                            if dist < d then c, d = m, dist end
                        end
                    end
                    return c
                end

                while _G.AutoFarm1 do
                    task.wait()
                    local v = c:FindFirstChild("Values") or c:WaitForChild("Values", 5)
                    local h = v:FindFirstChild("HasBall") or v:WaitForChild("HasBall", 5)
                    local g = {["Away"] = "Away", ["Home"] = "Home"}
                    if p.Team.Name == "Visitor" then
                        task.wait(.1)
                    else
                        if hrp:FindFirstChild("Antifall") then
                            if h.Value then
                                Goto(hrp.CFrame * CFrame.new(0, 50, 0), g[p.Team.Name], "Kick")
                                task.wait(2)
                            else
                                local b = workspace:FindFirstChild("Football")
                                if b then
                                    for _, v in pairs(workspace:GetChildren()) do
                                        if v.Name == "Football" and v:FindFirstChild("Hitbox") then
                                            Goto(v.CFrame * CFrame.new(0, 3.5, 0), g[p.Team.Name])
                                        end
                                    end
                                else
                                    local t = ClosestCharacter(c)
                                    local b = t and t:FindFirstChild("Football") or t:WaitForChild("Football")
                                    if b then Goto(b.CFrame, g[p.Team.Name], "Slide") end
                                end
                            end
                        else
                            local af = Instance.new("BodyVelocity", hrp)
                            af.P = 1250
                            af.Velocity = Vector3.new(0, 0, 0)
                            af.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            af.Name = "Antifall"
                        end
                    end
                end
                task.wait(.1)
                if not _G.AutoFarm1 then
                    for _, v in pairs(hrp:GetChildren()) do
                        if v.Name == "Antifall" and v:IsA("BodyVelocity") then
                            v:Destroy()
                        end
                    end
                end
            end
        end)
    end
end)

-- Toggle สำหรับเปิด/ปิดระบบ Auto Goal
local ToggleBL = Tabs.Kaitan:AddToggle("BlToggle", {Title = "BlackScreen", Default = false })

ToggleBL:OnChanged(function()
    running = ToggleBL.Value -- อัปเดตสถานะการทำงาน
    if running then
        createUI()
    else
        removeUI()
    end
end)

local GoalTitle = Tabs.Kaitan:AddSection("Goal (In Testing)")

local tState = false

local t = Tabs.Kaitan:AddToggle("AutoGK", {Title = "Auto GK", Default = false})

t:OnChanged(function()
    tState = t.Value
    Fluent:Notify({
        Title = "Auto GK Toggled",
        Content = "Auto GK has been " .. (tState and "enabled" or "disabled") .. ".",
        Duration = 3
    })
end)

local kb = Tabs.Kaitan:AddKeybind("AutoGKKeybind", {
    Title = "Auto GK Keybind",
    Mode = "Toggle",
    Default = "",
    Callback = function()
        tState = not tState
        t:SetValue(tState)
    end
})

local p = game.Players.LocalPlayer
local char = p.Character or p.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local vInput = game:GetService("VirtualInputManager")
local rService = game:GetService("RunService")

local function getBall()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Name == "Football" then
            return o
        end
    end
end

local function isBallInPlayer()
    local b = getBall()
    if not b then return false end

    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= p and plr.Character and b:IsDescendantOf(plr.Character) then
            return true
        end
    end
    return false
end

local function pressQ()
    vInput:SendKeyEvent(true, Enum.KeyCode.Q, false, nil)
    task.wait(0.1)
    vInput:SendKeyEvent(false, Enum.KeyCode.Q, false, nil)
end

rService.RenderStepped:Connect(function()
    if not tState then return end

    local ball = getBall()
    if not ball or not ball.Parent or isBallInPlayer() then return end

    local mag = (hrp.Position - ball.Position).Magnitude
    if mag > 3 and mag <= 50 then
        hrp.CFrame = CFrame.new(ball.Position)
        pressQ()
    end
end)


local Properties = Tabs.Kaitan:AddSection("Properties")

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

local rs = game:GetService("ReplicatedStorage")
local teams = rs:WaitForChild("Teams")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")

local remote = rs:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("TeamService"):WaitForChild("RE"):WaitForChild("Select")

local AutoTeamEnabled1 = false
local lastTeam = "Visitor"

local function isVisitor()
    local currentTeam = localPlayer.Team and localPlayer.Team.Name or "Visitor"
    return currentTeam == "Visitor", currentTeam
end

local function getAvailableTeam()
    for _, team in ipairs(teams:GetChildren()) do
        if team:IsA("Folder") then
            for _, pos in ipairs(team:GetChildren()) do
                if pos:IsA("ObjectValue") and pos.Value == nil then
                    return team.Name:gsub("Team", ""), pos.Name
                end
            end
        end
    end
    return nil, nil
end

local connection
local function autoTeam()
    if connection then connection:Disconnect() end -- ป้องกันการซ้อนกันของฟังก์ชัน
    connection = runService.Heartbeat:Connect(function()
        if not AutoTeamEnabled1 then
            connection:Disconnect()
            return
        end

        local isVisitorNow, currentTeam = isVisitor()

        if not isVisitorNow then
            if lastTeam ~= currentTeam then
                lastTeam = currentTeam
            end
            return
        end

        if lastTeam ~= "Visitor" then
            lastTeam = "Visitor"
        end

        local team, position = getAvailableTeam()
        if team and position then
            remote:FireServer(team, position)
        end
    end)
end

local AutoTeamToggle1 = Tabs.Kaitan:AddToggle("AutoTeamToggle1", {
    Title = "Auto Team & Position (For Auto Farm)",
    Default = false,
    Callback = function(Value)
        AutoTeamEnabled1 = Value
        Fluent:Notify({
            Title = "Auto Team",
            Content = AutoTeamEnabled1 and "✅ Enabled: Auto-selecting team and position." or "❌ Disabled: Auto team selection stopped.",
            Duration = 3
        })
        if AutoTeamEnabled1 then
            task.spawn(autoTeam)
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
local ToggleInstance = Tabs.Kaitan:AddToggle("InstantGoalToggle1", {
    Title = "Instant Goal (Auto Farm Only)",
    Default = false,
    Callback = function(s)
        ig = s
    end
})

local HopTitle = Tabs.Kaitan:AddSection("Hop Server")

local ts = game:GetService("TeleportService")
local http = game:GetService("HttpService")
local plr = game.Players.LocalPlayer
local placeID = game.PlaceId
local autoHopEnabled = false
local playerThreshold = 4

local function getNewServer()
    local url = "https://games.roblox.com/v1/games/"..placeID.."/servers/Public?sortOrder=Asc&limit=100"
    local response = http:JSONDecode(game:HttpGet(url))
    for _, server in pairs(response.data) do
        if server.playing and server.playing < playerThreshold then
            return server.id
        end
    end
end

local function randomServer()
    local serverID = getNewServer()
    if serverID then
        ts:TeleportToPlaceInstance(placeID, serverID, plr)
    else
        ts:Teleport(placeID, plr)
    end
end

local function autoHop()
    while autoHopEnabled do
        if #game.Players:GetPlayers() <= playerThreshold then
            randomServer()
        end
        task.wait(2)
    end
end

local toggleHop = Tabs.Kaitan:AddToggle("AutoHopToggle", {
    Title = "Auto Hop",
    Default = false,
    Callback = function(state)
        autoHopEnabled = state
        if state then
            task.spawn(autoHop)
        end
    end
})

local inputThreshold = Tabs.Kaitan:AddInput("AutoHopThreshold", {
    Title = "Auto Hop When Players ≤",
    Description = "ย้ายเซิฟหากผู้เล่นน้อยกว่า",
    Default = "4",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            playerThreshold = num
        end
    end
})

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

local toggle = Tabs.OP:AddToggle("KaiserToggle", {
    Title = "Kaiser Impack",
    Default = false,
    Callback = function(state)
        ig = state
    end
})

local keybind = Tabs.OP:AddKeybind("InstantKeybind", {
    Title = "Toggle Kaiser Impack Keybind",
    Mode = "Toggle",
    Default = "",
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
    Default = "",
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

local SkillTitle = Tabs.OP:AddSection("No CD Skill (Wave Required)")
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

                v15.HumanoidRootPart.Anchored = false
                v13.Animations:StopAnims()

                local hrp = v15.HumanoidRootPart
                local dashDirection = hrp.CFrame:VectorToObjectSpace(v15.Humanoid.MoveDirection).X < 0 and "Left" or "Right"
                local directionVector = dashDirection == "Right" and hrp.CFrame.RightVector or hrp.CFrame.RightVector * -1

                v13.AbilityService.Ability:Fire("AirDash", directionVector)
                v13.Animations.Abilities["AirDribble" .. dashDirection].Priority = Enum.AnimationPriority.Action4
                v13.Animations.Abilities["AirDribble" .. dashDirection]:Play()
                v13.Animations.Ball["AirDribble" .. dashDirection].Priority = Enum.AnimationPriority.Action4
                v13.Animations.Ball["AirDribble" .. dashDirection]:Play()
            end

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
    Values = {"Isagi", "Chigiri", "Bachira", "Otoya", "Hiori", "Gagamaru", "King", "Nagi", "Reo",  "Karasu", "Shidou", "Kunigami", "Sae", "Aiku", "Rin", "Yukimiya"}, -- Replace with actual style names
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
    Values = { "Ice", "Lightning", "Puzzle", "Monster", "Gale Burst", "Genius", "King's Instinct", "Trap", "Crow", "Demon Wings", "Chameleon", "Wild Card", "Snake", "Prodigy", "Awakened Genius", "Dribbler"}, -- Actual flow names
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

local EffectsTitle = Tabs.Legit:AddSection("Goal Effects")

local opts1 = {"Conquer", "Blossom", "Heart", "Step", "Rin", "Sae", "Gingerbread", "Woderland", "Presents",
"Snowflakes", "Glitch", "City", "Dragon", "Lantern", "Blackhole", "Card", "Thunder", 
"Lightning", "Crow", "Fire", "Glass", "Time Stop"}
local sel = opts1[1]

local d = Tabs.Item:AddDropdown("Effects", {
    Title = "Goal Effects",
    Values = opts1,
    Multi = false,
    Default = 1,
})

d:OnChanged(function(v)
    sel = v
end)

Tabs.Item:AddButton({
    Title = "Apply Effect",
    Callback = function()
        game:GetService("ReplicatedStorage").Packages.Knit.Services.CustomizationService.RE.Customize:FireServer("GoalEffects", sel)
    end
})

local opts2 = {
    "Cape", "Santa Hat", "Peppermint Cape", "Snowman Cape", "Gingerbread Cape", "Santa Scarf",
    "Angel Wings", "Heart Aura", "Fireworks", "Ninja", "SHADOW", "Shadow Cape", "GLITCH",
    "Dribbler's Glasses", "Dragon Cape", "Lanterns!"
}

local CosmeticsTitle = Tabs.Legit:AddSection("Cosmetics")

local sel = opts2[1]

local d = Tabs.Item:AddDropdown("Cosmetics", {
    Title = "Cosmetics",
    Values = opts2,
    Multi = false,
    Default = 1,
})

d:OnChanged(function(v)
    sel = v
end)

Tabs.Item:AddButton({
    Title = "Apply Cosmetic",
    Callback = function()
        game:GetService("ReplicatedStorage").Packages.Knit.Services.CustomizationService.RE.Customize:FireServer("Cosmetics", sel)
    end
})

local CardsTitle = Tabs.Legit:AddSection("Cards")

local opts3 = {
    "Crystal", "Crow", "Heart", "Itoshi Rin", "Itoshi Sae", "Dragon", "Galaxy", "Golden Winter",
    "Holiday", "New Years", "Glitch", "Street", "Premiere", "Golden", "Specialty", "Liga",
    "Rage", "Inside", "Water", "Earthquake", "Blue Sky", "Pattern", "Forest", "Pinky",
    "YingYang", "Orange", "Blue", "Red", "Green", "Wood", "Basic"
}

local sel = opts3[1]

local d = Tabs.Item:AddDropdown("Cards", {
    Title = "Cards",
    Values = opts3,
    Multi = false,
    Default = 1,
})

d:OnChanged(function(v)
    sel = v
end)

Tabs.Item:AddButton({
    Title = "Apply Card",
    Callback = function()
        game:GetService("ReplicatedStorage").Packages.Knit.Services.CustomizationService.RE.Customize:FireServer("Cards", sel)
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
SaveManager:SetFolder("Fearise Hub/BlueLock")

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
