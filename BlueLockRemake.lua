repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
getgenv().Settings = {
    WalkSpeedToggle = nil,
    WalkSpeedInput = nil,
    JumpPowerToggle = nil,
    JumpPowerInput = nil,
    HitboxToggle = nil,
    HitboxInput = nil,
    HitboxKeybind = nil,
    AutoDribble = nil,
    vipToggle = nil,
    InstantKickKeybind = nil,
    InputPower = nil,
    espToggle = nil,
    espStyleToggle = nil,
    espAwakeningToggle = nil,
    espFlowToggle  = nil,
    espStaminaToggle = nil,
    BallPredicToggle = nil,
    AutoFarmTweenToggle = nil,
    AutoFarmTeleportToggle = nil,
    WhiteScreen = nil,
    AutoGoalKeeper = nil,
    AutoGKKeybind = nil,
    TeamPositionDropdown = nil,
    AutoTeamToggle = nil,
    AutoTeamForAutoFarmToggle = nil,
    InstantGoalToggle = nil,
    AutoHopToggle = nil,
    AutoHopThresholdInput = nil,
    KaiserToggle = nil,
    InstantKeybind = nil,
    CurveShotProMaxToggle = nil,
    CurveShotProMaxKeybind = nil,
    NoCooldownStealToggle = nil,
    NoCooldownAirDribbleToggle = nil,
    NoCooldownAirDashToggle = nil,
    StyleLockDropdown = nil,
    AutoSpinToggle = nil,
    FlowLockDropdown = nil,
    AutoFlowToggle = nil,
    EffectsDropdown = nil,
    CosmeticsDropdown = nil,
    CardsDropdown = nil,

}

local function CreateToggle()
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "ToggleGui"
    toggleGui.DisplayOrder = 1e+04
    toggleGui.IgnoreGuiInset = true
    toggleGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
    toggleGui.ResetOnSpawn = false
    toggleGui.Parent = game:GetService("CoreGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BackgroundTransparency = 1
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.fromScale(0.925, 0.116)
    mainFrame.Size = UDim2.fromScale(0.083, 0.148)

    local uICorner = Instance.new("UICorner")
    uICorner.Name = "UICorner"
    uICorner.CornerRadius = UDim.new(1, 0)
    uICorner.Parent = mainFrame

    local toggleButton = Instance.new("ImageButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Image = "rbxassetid://112196145837803"
    toggleButton.ImageTransparency = 0.3
    toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.BackgroundTransparency = 1
    toggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.fromScale(0.491, 0.482)
    toggleButton.Size = UDim2.fromScale(1, 1)

    local uICorner1 = Instance.new("UICorner")
    uICorner1.Name = "UICorner"
    uICorner1.CornerRadius = UDim.new(1, 0)
    uICorner1.Parent = toggleButton

    toggleButton.Parent = mainFrame

    local uIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    uIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    uIAspectRatioConstraint.AspectRatio = 1
    uIAspectRatioConstraint.Parent = mainFrame

    mainFrame.Parent = toggleGui

    return toggleButton
end

local Device;
local function checkDevice()
    local player = game.Players.LocalPlayer
    if player then
        local UserInputService = game:GetService("UserInputService")
        
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            local FeariseToggle = CreateToggle()
            FeariseToggle.MouseButton1Click:Connect(function()
                for _, guiObject in ipairs(game:GetService("CoreGui"):GetChildren()) do
                    if guiObject.Name == "FeariseHub" and guiObject:IsA("ScreenGui") then
                        guiObject.Enabled = not guiObject.Enabled
                    end
                end
            end)
            game:GetService("CoreGui").ChildRemoved:Connect(function(Value)
                if Value.Name == "FeariseHub" then
                    FeariseToggle.Parent.Parent:Destroy()
                end
            end)
            Device = UDim2.fromOffset(480, 360)
        else
            Device = UDim2.fromOffset(580, 460)
        end
    end
end
checkDevice()

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Malemz1/FORTUNE-HUB/refs/heads/main/FeariseHub_UI.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fearise Hub" .. " | ".."BlueLock : Rival".." | ".."[Version 3]",
    SubTitle = "by Rowlet/Blobby",
    TabWidth = 160,
    Size =  Device, --UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Rose", --Amethyst
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    --[[ Tabs --]]
    pageLegit = Window:AddTab({ Title = "Legit", Icon = "align-justify" }),
    pageVisual = Window:AddTab({ Title = "Visual", Icon = "view" }),
    pageKaitan = Window:AddTab({ Title = "Kaitan", Icon = "crown" }),
    pageOP = Window:AddTab({ Title = "OP", Icon = "apple" }),
    pageSpin = Window:AddTab({ Title = "Spin", Icon = "box" }),
    pageItem = Window:AddTab({ Title = "Item", Icon = "archive" }),
}

do
    -------------------------------------------------------[[ LEGIT ]]-------------------------------------------------------
    local SpeedTitle = Tabs.pageLegit:AddSection("Player Modifiers")
    local WalkSpeedToggle = Tabs.pageLegit:AddToggle("WalkSpeedToggle", {Title = "Toggle WalkSpeed", Default = getgenv().Settings.WalkSpeedToggle or false })
    local WalkSpeedInput = Tabs.pageLegit:AddInput("WalkSpeedInput", {
        Title = "WalkSpeed Input",
        Default = getgenv().Settings.WalkSpeedInput or 16,
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            getgenv().Settings.WalkSpeedInput = Value
        end
    })
    WalkSpeedInput:OnChanged(function(Value)
        getgenv().Settings.WalkSpeedInput = Value
    end)
    local JumpPowerToggle = Tabs.pageLegit:AddToggle("JumpPowerToggle", {Title = "Toggle JumpPower", Default = getgenv().Settings.JumpPowerToggle or false })
    local JumpPowerInput = Tabs.pageLegit:AddInput("JumpPowerInput", {
        Title = "JumpPower Input",
        Default = getgenv().Settings.JumpPowerInput or 50,
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            getgenv().Settings.JumpPowerInput = Value
        end
    })
    JumpPowerInput:OnChanged(function(Value)
        getgenv().Settings.JumpPowerInput = Value
    end)
    local HitboxTitle = Tabs.pageLegit:AddSection("Hitbox")
    local HitboxToggle = Tabs.pageLegit:AddToggle("HitboxToggle", { Title = "Hitbox", Default = getgenv().Settings.HitboxToggle or false })
    local HitboxInput = Tabs.pageLegit:AddInput("HitboxInput", {
        Title = "Hitbox Input",
        Default = getgenv().Settings.HitboxInput or 10,
        Placeholder = "Enter size (1-30)",
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            getgenv().Settings.HitboxInput = Value
        end
    })
    HitboxInput:OnChanged(function(Value)
        getgenv().Settings.HitboxInput = Value
    end)
    local HitboxKeybind = Tabs.pageLegit:AddKeybind("HitboxKeybind", {
        Title = "Toggle Hitbox Keybind",
        Mode = "Toggle",
        Default = getgenv().Settings.HitboxKeybind or "",
        Callback = function(Value)
            getgenv().Settings.HitboxKeybind = Value
        end,
        ChangedCallback = function(NewKey)
            getgenv().Settings.HitboxKeybind = NewKey
        end
    })
    HitboxKeybind:OnChanged(function(Value)
        getgenv().Settings.HitboxKeybind = Value
    end)
    local MiscTitle = Tabs.pageLegit:AddSection("Misc")
    local AutoDribble = Tabs.pageLegit:AddToggle("AutoDribble", {Title = "AutoDribble", Description = "Testing.", Default = getgenv().Settings.AutoDribble or false })
    local vipToggle = Tabs.pageLegit:AddToggle("vipToggle", {Title = "vipToggle", Description = "Testing.", Default = getgenv().Settings.vipToggle or false })
    local InfiniteStaminaButton Tabs.pageLegit:AddButton({
        Title = "Infinite Stamina",
        Description = "Click to enable Infinite Stamina (cannot be disabled)",
        Callback = function()
            
        end
    })
    local EnchantedTitle = Tabs.pageLegit:AddSection("Enchanted")
    local InstantKickKeybind = Tabs.pageLegit:AddKeybind("InstantKickKeybind", {
        Title = "Shoot Keybind",
        Mode = "Toggle",
        Default = getgenv().Settings.InstantKickKeybind or "",
        Callback = function(Value)
            getgenv().Settings.InstantKickKeybind = Value
        end,
        ChangedCallback = function(Value)
            getgenv().Settings.InstantKickKeybind = Value
        end
    })
    InstantKickKeybind:OnChanged(function(Value)
        getgenv().Settings.InstantKickKeybind = Value
    end)
    local InputPower = Tabs.pageLegit:AddInput("InputPower", {
        Title = "Adjust Power (1-100000)",
        Default = getgenv().Settings.InputPower or 500,
        Placeholder = "Enter power...",
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            getgenv().Settings.InputPower = Value
        end
    })
    InputPower:OnChanged(function(Value)
        getgenv().Settings.InputPower = Value
    end)

    -------------------------------------------------------[[ VISUAL ]]-------------------------------------------------------
    local espToggle = Tabs.pageVisual:AddToggle("espToggle", {Title = "Enable ESP", Default = getgenv().Settings.espToggle or false })
    local espStyleToggle = Tabs.pageVisual:AddToggle("espStyleToggle", {Title = "Enable Style", Default = getgenv().Settings.espStyleToggle or false })
    local espAwakeningToggle = Tabs.pageVisual:AddToggle("espAwakeningToggle", {Title = "Enable Awakning", Default = getgenv().Settings.espAwakeningToggle or false })
    local espFlowToggle = Tabs.pageVisual:AddToggle("espFlowToggle", {Title = "Enable Flow", Default = getgenv().Settings.espFlowToggle or false })
    local espStaminaToggle = Tabs.pageVisual:AddToggle("espStaminaToggle", {Title = "Enable Stamina", Default = getgenv().Settings.espStaminaToggle or false })
    local BallPredicToggle = Tabs.pageVisual:AddToggle("BallPredicToggle", {Title = "ESP BallPredic", Default = getgenv().Settings.BallPredicToggle or false})

    -------------------------------------------------------[[ KAITAN ]]-------------------------------------------------------
    local Striker = Tabs.pageKaitan:AddSection("Striker")
    local AutoFarmTweenToggle = Tabs.pageKaitan:AddToggle("AutoFarmTweenToggle", { Title = "Auto Farm(Tween)", Default = getgenv().Settings.AutoFarmTweenToggle or false })
    local AutoFarmTeleportToggle = Tabs.pageKaitan:AddToggle("AutoFarmTeleportToggle", { Title = "Auto Farm(TP)", Default = getgenv().Settings.AutoFarmTeleportToggle or false })
    local WhiteScreen = Tabs.pageKaitan:AddToggle("WhiteScreen", { Title = "WhiteScreen [GPU 0%]", Default = getgenv().Settings.WhiteScreen or false })
    local GoalTitle = Tabs.pageKaitan:AddSection("Goal (In Testing)")
    local AutoGoalKeeper = Tabs.pageKaitan:AddToggle("WhitAutoGoalKeepereScreen", { Title = "Auto GK", Default = getgenv().Settings.AutoGoalKeeper or false })
    local AutoGKKeybind = Tabs.pageKaitan:AddKeybind("AutoGKKeybind", {
        Title = "Auto GK Keybind",
        Mode = "Toggle",
        Default = getgenv().Settings.AutoGKKeybind or "",
        Callback = function(Value)
            getgenv().Settings.AutoGKKeybind = Value
        end,
        ChangedCallback = function(Value)
            getgenv().Settings.AutoGKKeybind = Value
        end
    })
    AutoGKKeybind:OnChanged(function(Value)
        getgenv().Settings.AutoGKKeybind = Value
    end)
    local Properties = Tabs.pageKaitan:AddSection("Properties")
    local TeamPositionDropdown = Tabs.pageKaitan:AddDropdown("TeamPositionDropdown", {
        Title = "Team and Position",
        Description = "Select your preferred team and position.",
        Values = {
            "Home_CF", "Home_LW", "Home_RW", "Home_CM", "Home_DM", "Home_CB", "Home_GK",
            "Away_CF", "Away_LW", "Away_RW", "Away_CM", "Away_DM", "Away_CB", "Away_GK"
        },
        Multi = false,
        Default = getgenv().Settings.TeamPositionDropdown or "Home_CF",
        Callback = function(Value)
            getgenv().Settings.TeamPositionDropdown = Value
        end
    })
    TeamPositionDropdown:OnChanged(function(Value)
        getgenv().Settings.TeamPositionDropdown = Value
    end)
    local AutoTeamToggle = Tabs.pageKaitan:AddToggle("AutoTeamToggle", { Title = "Auto Team & Position", Default = getgenv().Settings.AutoTeamToggle or false })
    local AutoTeamForAutoFarmToggle = Tabs.pageKaitan:AddToggle("AutoTeamForAutoFarmToggle", { Title = "Auto Team & Position (For Auto Farm)", Default = getgenv().Settings.AutoTeamForAutoFarmToggle or false })
    local InstantGoalToggle = Tabs.pageKaitan:AddToggle("InstantGoalToggle", { Title = "Instant Goal (Auto Farm Only)", Default = getgenv().Settings.InstantGoalToggle or false })
    local HopTitle = Tabs.pageKaitan:AddSection("Hop Server")
    local AutoHopToggle = Tabs.pageKaitan:AddToggle("AutoHopToggle", { Title = "Auto Hop", Default = getgenv().Settings.AutoHopToggle or false })
    local AutoHopThresholdInput = Tabs.pageKaitan:AddInput("AutoHopThresholdInput", {
        Title = "Auto Hop When Players ≤",
        Description = "ย้ายเซิฟหากผู้เล่นน้อยกว่า",
        Default = getgenv().Settings.AutoHopThresholdInput or 4,
        Placeholder = "Enter Number Of Players",
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            getgenv().Settings.AutoHopThresholdInput = Value
        end
    })
    AutoHopThresholdInput:OnChanged(function(Value)
        getgenv().Settings.AutoHopThresholdInput = Value
    end)

    -------------------------------------------------------[[ OP ]]-------------------------------------------------------
    local KaiserToggle = Tabs.pageOP:AddToggle("KaiserToggle", { Title = "Kaiser Impack", Default = getgenv().Settings.KaiserToggle or false })
    local InstantKeybind = Tabs.pageOP:AddKeybind("InstantKeybind", {
        Title = "Toggle Kaiser Impack Keybind",
        Mode = "Toggle",
        Default = getgenv().Settings.InstantKeybind or "",
        Callback = function(Value)
            getgenv().Settings.InstantKeybind = Value
        end,
        ChangedCallback = function(Value)
            getgenv().Settings.InstantKeybind = Value
        end
    })
    InstantKeybind:OnChanged(function(Value)
        getgenv().Settings.InstantKeybind = Value
    end)
    local CurveShotProMaxToggle = Tabs.pageOP:AddToggle("CurveShotProMaxToggle", { Title = "Curve Shot Pro Max", Default = getgenv().Settings.CurveShotProMaxToggle or false })
    local CurveShotProMaxKeybind = Tabs.pageOP:AddKeybind("CurveShotProMaxKeybind", {
        Title = "Toggle Curve Shot Keybind",
        Mode = "Toggle",
        Default = getgenv().Settings.CurveShotProMaxKeybind or "",
        Callback = function(Value)
            getgenv().Settings.CurveShotProMaxKeybind = Value
        end,
        ChangedCallback = function(Value)
            getgenv().Settings.CurveShotProMaxKeybind = Value
        end
    })
    CurveShotProMaxKeybind:OnChanged(function(Value)
        getgenv().Settings.CurveShotProMaxKeybind = Value
    end)
    local SkillTitle = Tabs.pageOP:AddSection("No CD Skill (Wave Required)")
    local NoCooldownStealToggle = Tabs.pageOP:AddToggle("NoCooldownStealToggle", { Title = "No Cooldown - Steal", Default = getgenv().Settings.NoCooldownStealToggle or false })
    local NoCooldownAirDribbleToggle = Tabs.pageOP:AddToggle("NoCooldownAirDribbleToggle", { Title = "No Cooldown - AirDribble", Default = getgenv().Settings.NoCooldownAirDribbleToggle or false })
    local NoCooldownAirDashToggle = Tabs.pageOP:AddToggle("NoCooldownAirDashToggle", { Title = "No Cooldown - AirDash", Default = getgenv().Settings.NoCooldownAirDashToggle or false })

    -------------------------------------------------------[[ SPIN ]]-------------------------------------------------------
    local StyleTitle = Tabs.pageSpin:AddSection("Style Spin")
    local StyleLockDropdown = Tabs.pageSpin:AddDropdown("StyleLockDropdown", {
        Title = "Style Lock",
        Description = "Select styles to stop spinning.",
        Values = {"Isagi", "Chigiri", "Bachira", "Otoya", "Hiori", "Gagamaru", "King", "Nagi", "Reo",  "Karasu", "Shidou", "Kunigami", "Sae", "Aiku", "Rin", "Yukimiya"}, -- Replace with actual style names
        Multi = true,
        Default = {}
    })
    StyleLockDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        getgenv().Settings.StyleLockDropdown = Values
    end)
    local AutoSpinToggle = Tabs.pageSpin:AddToggle("AutoSpinToggle", { Title = "Auto Style Spin", Default = getgenv().Settings.AutoSpinToggle or false })
    local FlowTitle = Tabs.pageSpin:AddSection("Flow Spin")
    local FlowLockDropdown = Tabs.pageSpin:AddDropdown("FlowLockDropdown", {
        Title = "Flow Lock",
        Description = "Select Flow to stop spinning.",
        Values = { "Ice", "Lightning", "Puzzle", "Monster", "Gale Burst", "Genius", "King's Instinct", "Trap", "Crow", "Demon Wings", "Chameleon", "Wild Card", "Snake", "Prodigy", "Awakened Genius", "Dribbler"}, -- Actual flow names
        Multi = true,
        Default = {}
    })
    FlowLockDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        getgenv().Settings.FlowLockDropdown = Values
    end)
    local AutoFlowToggle = Tabs.pageSpin:AddToggle("AutoFlowToggle", { Title = "Auto Flow Spin", Default = getgenv().Settings.AutoFlowToggle or false })

    -------------------------------------------------------[[ ITEM ]]-------------------------------------------------------
    local EffectsTitle = Tabs.pageItem:AddSection("Goal Effects")
    local ItemsList = {
        EFX = {},
        Cosmatics = {},
        Cards = {},

    }
    local function GetAllItem()
        for _, v in ipairs(game:GetService("ReplicatedStorage").Assets.GoalEffects:GetChildren()) do
            table.insert(ItemsList.EFX, v.Name)
        end
        for _, v in ipairs(game:GetService("ReplicatedStorage").Assets.Cosmetics:GetChildren()) do
            table.insert(ItemsList.Cosmatics, v.Name)
        end
        for _, v in ipairs(game:GetService("ReplicatedStorage").Assets.Customization.Cards:GetChildren()) do
            table.insert(ItemsList.Cards, v.Name)
        end
    end
    GetAllItem()
    local EffectsDropdown = Tabs.pageItem:AddDropdown("EffectsDropdown", {
        Title = "Goal Effects",
        Values = ItemsList.EFX,
        Multi = false,
        Default = getgenv().Settings.EffectsDropdown or "",
        Callback = function(Value)
            getgenv().Settings.EffectsDropdown = Value
        end
    })
    EffectsDropdown:OnChanged(function(Value)
        getgenv().Settings.EffectsDropdown = Value
    end)
    local ApplyEffectButton = Tabs.pageItem:AddButton({
        Title = "Apply Effect",
        Callback = function()
            if getgenv().Settings.EffectsDropdown ~= "" then
                game:GetService("ReplicatedStorage").Packages.Knit.Services.CustomizationService.RE.Customize:FireServer("GoalEffects", getgenv().Settings.EffectsDropdown)
                Fluent:Notify({
                    Title = "Fearise Hub",
                    Content = "Your Wear Goal Effect "..tostring(getgenv().Settings.EffectsDropdown),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Fearise Hub",
                    Content = "Please Select Goal Effect Before Use.",
                    Duration = 3
                })
            end
        end
    })
    local CosmeticsTitle = Tabs.pageItem:AddSection("Cosmetics")
    local CosmeticsDropdown = Tabs.pageItem:AddDropdown("CosmeticsDropdown", {
        Title = "Cosmetics",
        Values = ItemsList.Cosmatics,
        Multi = false,
        Default = getgenv().Settings.CosmeticsDropdown or "",
        Callback = function(Value)
            getgenv().Settings.CosmeticsDropdown = Value
        end
    })
    CosmeticsDropdown:OnChanged(function(Value)
        getgenv().Settings.CosmeticsDropdown = Value
    end)
    local ApplyCosmetic = Tabs.pageItem:AddButton({
        Title = "Apply Cosmetic",
        Callback = function()
            if getgenv().Settings.CosmeticsDropdown ~= "" then
                game:GetService("ReplicatedStorage").Packages.Knit.Services.CustomizationService.RE.Customize:FireServer("Cosmetics", getgenv().Settings.CosmeticsDropdown)
                Fluent:Notify({
                    Title = "Fearise Hub",
                    Content = "Your Wear Cosmetic "..tostring(getgenv().Settings.CosmeticsDropdown),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Fearise Hub",
                    Content = "Please Select Cosmetic Before Use.",
                    Duration = 3
                })
            end
        end
    })
    local CardsTitle = Tabs.pageItem:AddSection("Cards")
    local CardsDropdown = Tabs.pageItem:AddDropdown("CardsDropdown", {
        Title = "Cards",
        Values = ItemsList.Cards,
        Multi = false,
        Default = getgenv().Settings.CardsDropdown or "",
        Callback = function(Value)
            getgenv().Settings.CardsDropdown = Value
        end
    })
    CardsDropdown:OnChanged(function(Value)
        getgenv().Settings.CardsDropdown = Value
    end)
    local ApplyCard = Tabs.pageItem:AddButton({
        Title = "Apply Card",
        Callback = function()
            if getgenv().Settings.CardsDropdown ~= "" then
                game:GetService("ReplicatedStorage").Packages.Knit.Services.CustomizationService.RE.Customize:FireServer("Cards", getgenv().Settings.CardsDropdown)
                Fluent:Notify({
                    Title = "Fearise Hub",
                    Content = "Your Wear Card "..tostring(getgenv().Settings.CardsDropdown),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Fearise Hub",
                    Content = "Please Select Card Before Use.",
                    Duration = 3
                })
            end
        end
    })

    -------------------------------------------------------[[ ABOUT SCRIPT ]]-------------------------------------------------------
    -------------------------------------------------------[[ VARIABLES ]]-------------------------------------------------------
    local Services = {
        Players = game:GetService("Players"),
        RunServices = game:GetService("RunService"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        Workspace = game:GetService("Workspace"),
        VirtualInputManager = game:GetService("VirtualInputManager"),
        TeleportService = game:GetService("TeleportService"),
        HttpService = game:GetService("HttpService"),
        TweenService = game:GetService("TweenService"),
        CollectionService = game:GetService("CollectionService"),
        CoreGui = game:GetService("CoreGui")
    }

    local player = Services.Players.LocalPlayer
    local mouse = player:GetMouse()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid") or character:WaitForChild("Humanoid", 9e99)
    local humanoidrootpart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 9e99)
    local camera = Services.Workspace.CurrentCamera

    local Remotes = {
        Dribble = Services.ReplicatedStorage.Packages.Knit.Services.BallService.RE.Dribble,
        Shoot = Services.ReplicatedStorage.Packages.Knit.Services.BallService.RE.Shoot
    }
    local Debris_Variables = {
        Function_Variables = {
            getAllFromCollection = {
                taggedInstances
            },
            GetBallInPlayer =  {
                FootBall
            },
            triggerQ = {
                Distance
            },
            shootBall = {
                Args = {
                    [1] = tonumber(getgenv().Settings.InputPower),
                    [4] = mouse
                }
            },
            createBillboard = {
                BillboardGui
            },
            createBarGui = {
                gui,
                frame
            },
            createBar = {
                BackgroundFrame,
                FillFrame
            },
            onCharacterAdded = {
                HumanoidRootPart,
                styleGui,
                styleTxt,
                awakeGui,
                awakeFrame,
                flowGui,
                flowFrame,
                stamGui,
                stamFrame,
                awkBar,
                flowBar,
                stmBar,
                Distance,
                PlayerStats,
            },
            createESP = {
                espData,
            }
        },
        ESP_Features = {
            Features = {Style = true, Awakening = true, Flow = true, Stamina = true},
            espObjects = {}
        },
        WalkSpeedToggle = {
            WalkSpeedConnect
        },
        HitboxToggle = {
            FootBall,
            HitBox,
            Char,
        },
        HitboxKeybind = {
            State
        },
        AutoDribble = {
            tracked = {},
            TargetPlayer,
            Distance,
            Sliding,
            isSliding
        },
        vipToggle = {
            hasVIP
        },
        Raycast = {
            lastPosition,
            ball,
            GRAVITY,
            
        }

    }

    -------------------------------------------------------[[ FUNCTION STORAGE ]]-------------------------------------------------------
    local Function_Storage = {}

    Function_Storage.getAllFromCollection = function(tagName)
        Debris_Variables.Function_Variables.getAllFromCollection.taggedInstances = Services.CollectionService:GetTagged(tagName)
        return Debris_Variables.Function_Variables.getAllFromCollection.taggedInstances
    end
    Function_Storage.GetBall = function()
        for _, obj in pairs(Function_Storage.getAllFromCollection("Football")) do
            if obj.Name == "Football" and obj.Parent ~= Services.ReplicatedStorage.Assets then
                return obj
            end
        end
    end
    Function_Storage.GetBallInPlayer = function()
        Debris_Variables.Function_Variables.GetBallInPlayer.FootBall = Function_Storage.GetBall()
        if not Debris_Variables.Function_Variables.GetBallInPlayer.FootBall then return false end
        
        for PlayerIndex, PlayerValue in ipairs(game.Players:GetPlayers()) do
            if PlayerValue ~= player and PlayerValue.Character and Debris_Variables.Function_Variables.GetBallInPlayer.FootBall:IsDescendantOf(PlayerValue.Character) then
                return true
            end
        end
        return false
    end
    Function_Storage.PressKey = function(KeyCode) --Example: Enum.KeyCode.Q
        Services.VirtualInputManager:SendKeyEvent(true, KeyCode, false, nil)
        task.wait(0.1)
        Services.VirtualInputManager:SendKeyEvent(false, KeyCode, false, nil)
    end
    Function_Storage.UpdateHitboxSize = function(TargetHitbox, Transparency, HitboxSize)
        TargetHitbox.Material = Enum.Material.ForceField
        TargetHitbox.BrickColor = BrickColor.new("Neon orange")
        TargetHitbox.Transparency = Transparency
        TargetHitbox.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
    end
    Function_Storage.triggerQ = function(Target)
        if Target and Target:FindFirstChild("HumanoidRootPart") and character and character:FindFirstChild("HumanoidRootPart") then
            if Target.Team == player.Team then return end
            
            Debris_Variables.Function_Variables.triggerQ.Distance = (humanoidrootpart.Position - Target.HumanoidRootPart.Position).Magnitude
            if Debris_Variables.Function_Variables.triggerQ.Distance <= 20 then
                Remotes.Dribble:FireServer()
                return true
            end
        end
        return false
    end
    Function_Storage.shootBall = function()
        Remotes.Shoot:FireServer(unpack(Debris_Variables.Function_Variables.shootBall.Args))
    end
    Function_Storage.createBillboard = function(size, offset, adornee)
        Debris_Variables.Function_Variables.createBillboard.BillboardGui = Instance.new("BillboardGui")
        Debris_Variables.Function_Variables.createBillboard.BillboardGui.Adornee = adornee
        Debris_Variables.Function_Variables.createBillboard.BillboardGui.Size = size
        Debris_Variables.Function_Variables.createBillboard.BillboardGui.StudsOffset = offset
        Debris_Variables.Function_Variables.createBillboard.BillboardGui.AlwaysOnTop = true
        Debris_Variables.Function_Variables.createBillboard.BillboardGui.Parent = Services.CoreGui
        return Debris_Variables.Function_Variables.createBillboard.BillboardGui
    end
    Function_Storage.createBarGui = function(offset)
        Debris_Variables.Function_Variables.createBarGui.gui = Function_Storage.createBillboard(UDim2.new(2, 0, 6, 0), offset)
        Debris_Variables.Function_Variables.createBarGui.frame = Instance.new("Frame", Debris_Variables.Function_Variables.createBarGui.gui)
        Debris_Variables.Function_Variables.createBarGui.frame.Size = UDim2.new(1, 0, 1, 0)
        Debris_Variables.Function_Variables.createBarGui.frame.BackgroundTransparency = 1
        return Debris_Variables.Function_Variables.createBarGui.gui, Debris_Variables.Function_Variables.createBarGui.frame
    end
    Function_Storage.createBar = function(parent, color, pos)
        Debris_Variables.Function_Variables.createBar.BackgroundFrame = Instance.new("Frame", parent)
        Debris_Variables.Function_Variables.createBar.BackgroundFrame.Size = UDim2.new(0.2, 0, 0.8, 0)
        Debris_Variables.Function_Variables.createBar.BackgroundFrame.Position = UDim2.new(pos, 0, 0.1, 0)
        Debris_Variables.Function_Variables.createBar.BackgroundFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        Debris_Variables.Function_Variables.createBar.BackgroundFrame.BackgroundTransparency = 0.3
        Debris_Variables.Function_Variables.createBar.BackgroundFrame.BorderSizePixel = 0

        Debris_Variables.Function_Variables.createBar.FillFrame = Instance.new("Frame", Debris_Variables.Function_Variables.createBar.BackgroundFrame)
        Debris_Variables.Function_Variables.createBar.FillFrame.Size = UDim2.new(1, 0, 1, 0)
        Debris_Variables.Function_Variables.createBar.FillFrame.AnchorPoint = Vector2.new(0, 1)
        Debris_Variables.Function_Variables.createBar.FillFrame.Position = UDim2.new(0, 0, 1, 0)
        Debris_Variables.Function_Variables.createBar.FillFrame.BackgroundColor3 = color
        Debris_Variables.Function_Variables.createBar.FillFrame.BorderSizePixel = 0

        return Debris_Variables.Function_Variables.createBar.FillFrame
    end
    Function_Storage.onCharacterAdded = function(Character, Data)
        Debris_Variables.Function_Variables.onCharacterAdded.HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 9e99)
        if not Debris_Variables.Function_Variables.onCharacterAdded.HumanoidRootPart then return end

        Debris_Variables.Function_Variables.onCharacterAdded.styleGui = Function_Storage.createBillboard(UDim2.new(3, 0, 1, 0), Vector3.new(0, 4, 0), Debris_Variables.Function_Variables.onCharacterAdded.HumanoidRootPart)
        Debris_Variables.Function_Variables.onCharacterAdded.styleTxt = Instance.new("TextLabel", Debris_Variables.Function_Variables.onCharacterAdded.styleGui)
        Debris_Variables.Function_Variables.onCharacterAdded.styleTxt.Size = UDim2.new(1, 0, 1, 0)
        Debris_Variables.Function_Variables.onCharacterAdded.styleTxt.BackgroundTransparency = 1
        Debris_Variables.Function_Variables.onCharacterAdded.styleTxt.TextStrokeTransparency = 0.5
        Debris_Variables.Function_Variables.onCharacterAdded.styleTxt.TextColor3 = Color3.new(1, 1, 1)
        Debris_Variables.Function_Variables.onCharacterAdded.styleTxt.TextScaled = true
        Debris_Variables.Function_Variables.onCharacterAdded.styleTxt.Text = "Style: ???"

        Debris_Variables.Function_Variables.onCharacterAdded.awakeGui, Debris_Variables.Function_Variables.onCharacterAdded.awakeFrame = Function_Storage.createBarGui(Vector3.new(4, 0, 0))
        Debris_Variables.Function_Variables.onCharacterAdded.flowGui, Debris_Variables.Function_Variables.onCharacterAdded.flowFrame = Function_Storage.createBarGui(Vector3.new(4.2, 0, 0))
        Debris_Variables.Function_Variables.onCharacterAdded.stamGui, Debris_Variables.Function_Variables.onCharacterAdded.stamFrame = Function_Storage.createBarGui(Vector3.new(4.4, 0, 0))

        Debris_Variables.Function_Variables.onCharacterAdded.awkBar = Function_Storage.createBar(awakeFrame, Color3.new(1, 0.2, 0.2), 0)
        Debris_Variables.Function_Variables.onCharacterAdded.flowBar = Function_Storage.createBar(flowFrame, Color3.new(0.921569, 1.000000, 0.200000), 0.25)
        Debris_Variables.Function_Variables.onCharacterAdded.stmBar = Function_Storage.createBar(stamFrame, Color3.new(0.196078, 0.019608, 1.000000), 0.5)

        table.insert(Data, {gui = Debris_Variables.Function_Variables.onCharacterAdded.styleGui, feature = "Style"})
        table.insert(Data, {gui = Debris_Variables.Function_Variables.onCharacterAdded.awakeGui, feature = "Awakening"})
        table.insert(Data, {gui = Debris_Variables.Function_Variables.onCharacterAdded.flowGui, feature = "Flow"})
        table.insert(Data, {gui = Debris_Variables.Function_Variables.onCharacterAdded.stamGui, feature = "Stamina"})

        Services.RunServices.RenderStepped:Connect(function()
            if Character and Debris_Variables.Function_Variables.onCharacterAdded.HumanoidRootPart and camera then
                Debris_Variables.Function_Variables.onCharacterAdded.Distance = (camera.CFrame.Position - Debris_Variables.Function_Variables.onCharacterAdded.HumanoidRootPart.Position).Magnitude
                Debris_Variables.Function_Variables.onCharacterAdded.styleTxt.Size = UDim2.new(math.clamp(Debris_Variables.Function_Variables.onCharacterAdded.Distance / 10, 3, 10), 0, math.clamp(Debris_Variables.Function_Variables.onCharacterAdded.Distance / 20, 1, 5), 0)

                Debris_Variables.Function_Variables.onCharacterAdded.PlayerStats = player:FindFirstChild("PlayerStats")
                if Debris_Variables.Function_Variables.onCharacterAdded.PlayerStats then
                    Debris_Variables.Function_Variables.onCharacterAdded.styleTxt.Text = (Debris_Variables.Function_Variables.onCharacterAdded.PlayerStats:FindFirstChild("Style") and Debris_Variables.Function_Variables.onCharacterAdded.PlayerStats.Style.Value or "None")
                    Debris_Variables.Function_Variables.onCharacterAdded.awkBar.Size = UDim2.new(1, 0, math.clamp((Debris_Variables.Function_Variables.onCharacterAdded.PlayerStats:FindFirstChild("AwakeningBar") and Debris_Variables.Function_Variables.onCharacterAdded.PlayerStats.AwakeningBar.Value or 0) / 100, 0, 1), 0)
                    Debris_Variables.Function_Variables.onCharacterAdded.flowBar.Size = UDim2.new(1, 0, math.clamp((Debris_Variables.Function_Variables.onCharacterAdded.PlayerStats:FindFirstChild("FlowBar") and Debris_Variables.Function_Variables.onCharacterAdded.PlayerStats.FlowBar.Value or 0) / 100, 0, 1), 0)
                    Debris_Variables.Function_Variables.onCharacterAdded.stmBar.Size = UDim2.new(1, 0, math.clamp((Debris_Variables.Function_Variables.onCharacterAdded.PlayerStats:FindFirstChild("Stamina") and Debris_Variables.Function_Variables.onCharacterAdded.PlayerStats.Stamina.Value or 0) / 100, 0, 1), 0)
                end

                for _, obj in ipairs(Data) do
                    obj.gui.Enabled = espToggle.Value and Debris_Variables.ESP_Features.Features[obj.feature]
                end
            end
        end)
    end
    Function_Storage.createESP = function(Player)
        if Player == player then return end
        Debris_Variables.Function_Variables.createESP.espData = {}

        if Player.Character then
            Function_Storage.onCharacterAdded(Player.Character, Debris_Variables.Function_Variables.createESP.espData)
        end
        Player.CharacterAdded:Connect(Function_Storage.onCharacterAdded)
    
        Debris_Variables.Function_Variables.ESP_Features.espObjects[Player] = Debris_Variables.Function_Variables.createESP.espData
    end
    Function_Storage.getballs = function()
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "Football" and v:FindFirstChild("Hitbox") then
                return v
            end
        end
        return nil
    end

    -------------------------------------------------------[[ CONNECTION ]]-------------------------------------------------------
    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoid = newCharacter:FindFirstChild("Humanoid") or newCharacter:WaitForChild("Humanoid", 9e99)
        humanoidrootpart = newCharacter:FindFirstChild("HumanoidRootPart") or newCharacter:WaitForChild("HumanoidRootPart", 9e99)
    end)

    Services.Players.PlayerAdded:Connect(Function_Storage.createESP)

    -------------------------------------------------------[[ SCRIPT WORKING ]]-------------------------------------------------------
    -------------------------------------------------------[[ LEGITS SCRIPT ]]-------------------------------------------------------
    WalkSpeedToggle:OnChanged(function()
        task.spawn(function()
            if WalkSpeedToggle.Value then
                Debris_Variables.WalkSpeedToggle.WalkSpeedConnect = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                    if humanoid.WalkSpeed ~= getgenv().Settings.WalkSpeedInput then
                        humanoid.WalkSpeed = getgenv().Settings.WalkSpeedInput
                    end
                end)
    
                task.spawn(function()
                    while WalkSpeedToggle.Value do
                        task.wait(0.1)
                        if humanoid.WalkSpeed ~= getgenv().Settings.WalkSpeedInput then
                            humanoid.WalkSpeed = getgenv().Settings.WalkSpeedInput
                        end
                    end
    
                    if Debris_Variables.WalkSpeedToggle.WalkSpeedConnect then
                        Debris_Variables.WalkSpeedToggle.WalkSpeedConnect:Disconnect()
                        Debris_Variables.WalkSpeedToggle.WalkSpeedConnect = nil
                    end
                end)
            else
                if Debris_Variables.WalkSpeedToggle.WalkSpeedConnect then
                    Debris_Variables.WalkSpeedToggle.WalkSpeedConnect:Disconnect()
                    Debris_Variables.WalkSpeedToggle.WalkSpeedConnect = nil
                end
            end
        end)
    end)
    JumpPowerToggle:OnChanged(function()
        task.spawn(function()
            while JumpPowerToggle.Value do
                task.wait()
                humanoid.UseJumpPower = true
                humanoid.JumpPower = getgenv().Settings.JumpPowerInput
            end
            task.wait(.1)
            if not JumpPowerToggle.Value then
                humanoid.JumpPower = 50
            end
        end)
    end)
    HitboxToggle:OnChanged(function()
        task.spawn(function()
            while HitboxToggle.Value do
                task.wait()
                Debris_Variables.HitboxToggle.FootBall = Function_Storage.GetBall()
                Debris_Variables.HitboxToggle.HitBox = Debris_Variables.HitboxToggle.FootBall:FindFirstChild("Hitbox")
                Debris_Variables.HitboxToggle.Char = Debris_Variables.HitboxToggle.FootBall:FindFirstChild("Char")
                if Debris_Variables.HitboxToggle.FootBall and Debris_Variables.HitboxToggle.FootBall.Parent == Services.Workspace then
                    if Debris_Variables.HitboxToggle.Char.Value ~= character then
                        if Debris_Variables.HitboxToggle.HitBox:IsA("Part") and Debris_Variables.HitboxToggle.HitBox then
                            Function_Storage.UpdateHitboxSize(Debris_Variables.HitboxToggle.HitBox, 0.5, getgenv().Settings.HitboxInput)
                        end
                    else
                        if Debris_Variables.HitboxToggle.HitBox:IsA("Part") and Debris_Variables.HitboxToggle.HitBox then
                            Function_Storage.UpdateHitboxSize(Debris_Variables.HitboxToggle.HitBox, 1, 2.5)
                        end
                    end
                else
                    if Debris_Variables.HitboxToggle.Char.Value ~= character then
                        if Debris_Variables.HitboxToggle.HitBox:IsA("Part") and Debris_Variables.HitboxToggle.HitBox then
                            Function_Storage.UpdateHitboxSize(Debris_Variables.HitboxToggle.HitBox, 0.5, getgenv().Settings.HitboxInput)
                        end
                    else
                        if Debris_Variables.HitboxToggle.HitBox:IsA("Part") and Debris_Variables.HitboxToggle.HitBox then
                            Function_Storage.UpdateHitboxSize(Debris_Variables.HitboxToggle.HitBox, 1, 2.5)
                        end
                    end
                end
            end
            task.wait(.1)
            if not HitboxToggle.Value and Debris_Variables.HitboxToggle.HitBox then
                Function_Storage.UpdateHitboxSize(Debris_Variables.HitboxToggle.HitBox, 1, 2.5)
            end
        end)
    end)
    HitboxKeybind:OnClick(function()
        task.spawn(function()
            Debris_Variables.HitboxKeybind.State = not HitboxToggle.Value
            HitboxToggle:SetValue(Debris_Variables.HitboxKeybind.State)
        end)
    end)
    AutoDribble:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.AutoDribble = AutoDribble.Value
        end)
    end)
    Services.RunServices.Heartbeat:Connect(function()
        if not AutoDribble.Value then return end

        for PlayerIndex, PlayerValue in pairs(Debris_Variables.AutoDribble.tracked) do
            if PlayerIndex and PlayerIndex:FindFirstChild("HumanoidRootPart") then
                Debris_Variables.AutoDribble.TargetPlayer = Services.Players:FindFirstChild(PlayerIndex.Name)
                if Debris_Variables.AutoDribble.TargetPlayer and Debris_Variables.AutoDribble.TargetPlayer.Team == player.Team then wait() end

                Debris_Variables.AutoDribble.Distance = (humanoidrootpart.Position - PlayerIndex.HumanoidRootPart.Position).Magnitude
                Debris_Variables.AutoDribble.Sliding = PlayerIndex:FindFirstChild("Values") and PlayerIndex.Values:FindFirstChild("Sliding")
                Debris_Variables.AutoDribble.isSliding = Debris_Variables.AutoDribble.Sliding and Debris_Variables.AutoDribble.Sliding.Value

                for SlideIndex, SlideValue in pairs(PlayerIndex:GetChildren()) do
                    if SlideValue.Name:match("^Slide%d+$") or Debris_Variables.AutoDribble.isSliding then
                        if Debris_Variables.AutoDribble.Distance <= 20 and not data.inside then
                            if Function_Storage.triggerQ(PlayerIndex) then
                                Debris_Variables.AutoDribble.tracked[PlayerIndex].inside = true
                            end
                        elseif Debris_Variables.AutoDribble.Distance > 20 then
                            Debris_Variables.AutoDribble.tracked[PlayerIndex].inside = false
                        end
                        break
                    end
                end
            end
        end
    end)
    vipToggle:OnChanged(function()
        task.spawn(function()
            Debris_Variables.vipToggle.hasVIP = player:FindFirstChild("HasVIP")

            if Debris_Variables.vipToggle.hasVIP then
                Debris_Variables.vipToggle.hasVIP.Value = vipToggle.Value
                if vipToggle.Value then
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
                    Content = "Could not find the 'HasVIP' property Try Again.",
                    Duration = 3
                })
                vipToggle:SetValue(false)
            end
        end)
    end)
    InstantKickKeybind:OnClick(function()
        task.spawn(function()
            Function_Storage.shootBall()
        end)
    end)

    -------------------------------------------------------[[ VISUAL SCRIPT ]]-------------------------------------------------------
    espToggle:OnChanged(function()
        task.spawn(function()
            for _, data in pairs(Debris_Variables.Function_Variables.ESP_Features.espObjects) do
                for _, obj in ipairs(data) do
                    obj.gui.Enabled = espToggle.Value and Debris_Variables.Function_Variables.ESP_Features.Features[obj.feature]
                end
            end
        end)
    end)
    espStyleToggle:OnChanged(function()
        task.spawn(function()
            for _, data in pairs(Debris_Variables.Function_Variables.ESP_Features.espObjects) do
                for _, obj in ipairs(data) do
                    if obj.feature == "Style" then
                        obj.gui.Enabled = espStyleToggle.Value and Debris_Variables.Function_Variables.ESP_Features.Features["Style"]
                    end
                end
            end
        end)
    end)
    espAwakeningToggle:OnChanged(function()
        task.spawn(function()
            for _, data in pairs(Debris_Variables.Function_Variables.ESP_Features.espObjects) do
                for _, obj in ipairs(data) do
                    if obj.feature == "Awakening" then
                        obj.gui.Enabled = espAwakeningToggle.Value and Debris_Variables.Function_Variables.ESP_Features.Features["Awakening"]
                    end
                end
            end
        end)
    end)
    espFlowToggle:OnChanged(function()
        task.spawn(function()
            for _, data in pairs(Debris_Variables.Function_Variables.ESP_Features.espObjects) do
                for _, obj in ipairs(data) do
                    if obj.feature == "Flow" then
                        obj.gui.Enabled = espFlowToggle.Value and Debris_Variables.Function_Variables.ESP_Features.Features["Flow"]
                    end
                end
            end
        end)
    end)
    espStaminaToggle:OnChanged(function()
        task.spawn(function()
            for _, data in pairs(Debris_Variables.Function_Variables.ESP_Features.espObjects) do
                for _, obj in ipairs(data) do
                    if obj.feature == "Stamina" then
                        obj.gui.Enabled = espStaminaToggle.Value and Debris_Variables.Function_Variables.ESP_Features.Features["Stamina"]
                    end
                end
            end
        end)
    end)
    BallPredicToggle:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.BallPredicToggle = BallPredicToggle.Value
        end)
    end)
    getgenv().Settings = {
        ["RayColor"] = Color3.new(1, 0, 0), -- สีของเส้น (แดง)
        ["RayThickness"] = 0.2, -- ความหนาของเส้น
        ["TweenSpeed"] = 0.0001 -- ความเร็วของ Tween
    }
    
    local GRAVITY = workspace.Gravity
    local TIME_STEP = 0.1
    local MAX_TIME = 3
    local VELOCITY_THRESHOLD = 1
    local MOVEMENT_THRESHOLD = 1
    
    local rayPart -- เส้นที่แสดงวิถีลูกบอล
    local tween -- Tween ปัจจุบัน
    
    function getballs()
        
    end
    
    function updateBall()
        if not getgenv().Toggle then return end -- ถ้า Toggle ปิด ไม่ต้องอัปเดตบอล
    
        local newBall = getballs()
        if newBall and newBall ~= ball then
            ball = newBall
            lastPosition = ball.Position
        end
    end
    
    function createRayPart()
        if not rayPart then
            rayPart = Instance.new("Part")
            rayPart.Anchored = true
            rayPart.CanCollide = false
            rayPart.Material = Enum.Material.Neon
            rayPart.Color = getgenv().Settings["RayColor"]
            rayPart.Size = Vector3.new(getgenv().Settings["RayThickness"], getgenv().Settings["RayThickness"], 1)
            rayPart.Parent = workspace
        end
    end
    
    function predictBallPath()
        if not getgenv().Toggle then
            if rayPart then
                rayPart.Transparency = 1 -- ซ่อนเส้นเมื่อปิด Toggle
            end
            return
        end
    
        if not ball then return end
    
        local velocity = ball.Velocity
        local currentPosition = ball.Position
        local movementAmount = (currentPosition - lastPosition).Magnitude
    
        -- ตรวจสอบว่าบอลกำลังเคลื่อนที่หรือไม่
        if velocity.Magnitude < VELOCITY_THRESHOLD or movementAmount < MOVEMENT_THRESHOLD then
            if rayPart then
                -- ถ้าบอลช้ามาก ปรับขนาดเส้นให้เล็กลง แทนที่จะซ่อน
                local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tweenGoal = {Size = Vector3.new(getgenv().Settings["RayThickness"], getgenv().Settings["RayThickness"], 0.1)}
                if tween then tween:Cancel() end
                tween = TweenService:Create(rayPart, tweenInfo, tweenGoal)
                tween:Play()
            end
            return
        end
    
        -- สร้างเส้นถ้ายังไม่มี
        createRayPart()
    
        local position = currentPosition
        local lastPos = position
        local endPos = position
    
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {ball}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
        for t = 0, MAX_TIME, TIME_STEP do
            local newPosition = position + velocity * t + Vector3.new(0, -0.5 * GRAVITY * t^2, 0)
    
            local result = workspace:Raycast(lastPos, newPosition - lastPos, raycastParams)
            if result then
                endPos = result.Position
                break
            end
    
            lastPos = newPosition
            endPos = newPosition
        end
    
        -- อัปเดตตำแหน่งของเส้นด้วย Tween
        local distance = (endPos - ball.Position).Magnitude
        local newSize = Vector3.new(getgenv().Settings["RayThickness"], getgenv().Settings["RayThickness"], distance)
        local newPosition = ball.Position + (endPos - ball.Position) / 2
        local newCFrame = CFrame.lookAt(newPosition, endPos)
    
        local tweenInfo = TweenInfo.new(getgenv().Settings["TweenSpeed"], Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenGoal = {Size = newSize, Position = newPosition, CFrame = newCFrame}
    
        if tween then tween:Cancel() end
        tween = TweenService:Create(rayPart, tweenInfo, tweenGoal)
        tween:Play()

        rayPart.Transparency = 0
    
        lastPosition = currentPosition
    end
    
    RunService.Stepped:Connect(function()
        updateBall()
    end)
    
    RunService.RenderStepped:Connect(predictBallPath)

    -------------------------------------------------------[[ KAITAN SCRIPT ]]-------------------------------------------------------
    AutoFarmTweenToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    AutoFarmTeleportToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    WhiteScreen:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    AutoGoalKeeper:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    AutoGKKeybind:OnClick(function()
        task.spawn(function()
            --AutoGKKeybind:GetState()
        end)
    end)
    AutoTeamToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    AutoTeamForAutoFarmToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    InstantGoalToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    AutoHopToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)

    -------------------------------------------------------[[ OP SCRIPT ]]-------------------------------------------------------
    KaiserToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    InstantKeybind:OnClick(function()
        task.spawn(function()
            --AutoGKKeybind:GetState()
        end)
    end)
    CurveShotProMaxToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    CurveShotProMaxKeybind:OnClick(function()
        task.spawn(function()
            --CurveShotProMaxKeybind:GetState()
        end)
    end)
    NoCooldownStealToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    NoCooldownAirDribbleToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    NoCooldownAirDashToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)

    -------------------------------------------------------[[ SPIN SCRIPT ]]-------------------------------------------------------
    AutoSpinToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
    AutoFlowToggle:OnChanged(function()
        task.spawn(function()
        
        end)
    end)
end

-- Anti AFK
task.spawn(function()
    while wait(320) do
        pcall(function()
            local anti = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:connect(function()
                anti:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                wait(1)
                anti:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        end)
    end
end)

Fluent:Notify({
    Title = "Fearise Hub",
    Content = "Anti AFK Is Actived",
    Duration = 5
})

Window:SelectTab(1)

--[[
function CreateFeariseHubMobileToggle()
    local feariseHubMobile = Instance.new("ScreenGui")
    feariseHubMobile.Name = "FeariseHubMobile"
    feariseHubMobile.IgnoreGuiInset = true
    feariseHubMobile.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
    feariseHubMobile.ResetOnSpawn = false
    feariseHubMobile.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if protect_gui then
        feariseHubMobile.Parent = protect_gui(game:GetService("CoreGui"))
    elseif gethui then
        feariseHubMobile.Parent = gethui(game:GetService("CoreGui"))
    else
        feariseHubMobile.Parent = game:GetService("CoreGui")
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BackgroundTransparency = 1
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.Size = UDim2.fromScale(1, 1)

    local uIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    uIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    uIAspectRatioConstraint.AspectRatio = 1.78
    uIAspectRatioConstraint.Parent = mainFrame

    local instantKick = Instance.new("ImageButton")
    instantKick.Name = "InstantKick"
    instantKick.Image = "rbxassetid://100284446653174"
    instantKick.AnchorPoint = Vector2.new(0.5, 0.5)
    instantKick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    instantKick.BackgroundTransparency = 1
    instantKick.BorderColor3 = Color3.fromRGB(0, 0, 0)
    instantKick.BorderSizePixel = 0
    instantKick.Position = UDim2.fromScale(0.954, 0.725)
    instantKick.Size = UDim2.fromScale(0.124, 0.124)
    instantKick.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local buttonName = Instance.new("TextLabel")
    buttonName.Name = "ButtonName"
    buttonName.FontFace = Font.new(
    "rbxasset://fonts/families/GothamSSm.json",
    Enum.FontWeight.ExtraBold,
    Enum.FontStyle.Normal
    )
    buttonName.Text = "Instant Kick"
    buttonName.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonName.TextScaled = true
    buttonName.TextSize = 14
    buttonName.TextWrapped = true
    buttonName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    buttonName.BackgroundTransparency = 1
    buttonName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    buttonName.BorderSizePixel = 0
    buttonName.Position = UDim2.fromScale(-0.215, 0.33)
    buttonName.Size = UDim2.fromScale(1.4, 0.449)
    buttonName.ZIndex = 2

    local uIStroke = Instance.new("UIStroke")
    uIStroke.Name = "UIStroke"
    uIStroke.Thickness = 3
    uIStroke.Transparency = 0.5
    uIStroke.Parent = buttonName

    local uIPadding = Instance.new("UIPadding")
    uIPadding.Name = "UIPadding"
    uIPadding.PaddingBottom = UDim.new(0.00668, 0)
    uIPadding.PaddingLeft = UDim.new(0.223, 0)
    uIPadding.PaddingRight = UDim.new(0.223, 0)
    uIPadding.PaddingTop = UDim.new(0.00668, 0)
    uIPadding.Parent = buttonName

    buttonName.Parent = instantKick

    instantKick.Parent = mainFrame

    local kaiserImpack = Instance.new("ImageButton")
    kaiserImpack.Name = "KaiserImpack"
    kaiserImpack.Image = "rbxassetid://100284446653174"
    kaiserImpack.AnchorPoint = Vector2.new(0.5, 0.5)
    kaiserImpack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    kaiserImpack.BackgroundTransparency = 1
    kaiserImpack.BorderColor3 = Color3.fromRGB(0, 0, 0)
    kaiserImpack.BorderSizePixel = 0
    kaiserImpack.Position = UDim2.fromScale(0.903, 0.846)
    kaiserImpack.Size = UDim2.fromScale(0.124, 0.124)
    kaiserImpack.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local buttonName1 = Instance.new("TextLabel")
    buttonName1.Name = "ButtonName"
    buttonName1.FontFace = Font.new(
    "rbxasset://fonts/families/GothamSSm.json",
    Enum.FontWeight.ExtraBold,
    Enum.FontStyle.Normal
    )
    buttonName1.Text = "Kaiser Impack"
    buttonName1.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonName1.TextScaled = true
    buttonName1.TextSize = 14
    buttonName1.TextWrapped = true
    buttonName1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    buttonName1.BackgroundTransparency = 1
    buttonName1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    buttonName1.BorderSizePixel = 0
    buttonName1.Position = UDim2.fromScale(-0.215, 0.33)
    buttonName1.Size = UDim2.fromScale(1.4, 0.449)
    buttonName1.ZIndex = 2

    local uIStroke1 = Instance.new("UIStroke")
    uIStroke1.Name = "UIStroke"
    uIStroke1.Thickness = 3
    uIStroke1.Transparency = 0.5
    uIStroke1.Parent = buttonName1

    local uIPadding1 = Instance.new("UIPadding")
    uIPadding1.Name = "UIPadding"
    uIPadding1.PaddingBottom = UDim.new(0.00668, 0)
    uIPadding1.PaddingLeft = UDim.new(0.223, 0)
    uIPadding1.PaddingRight = UDim.new(0.223, 0)
    uIPadding1.PaddingTop = UDim.new(0.00668, 0)
    uIPadding1.Parent = buttonName1

    buttonName1.Parent = kaiserImpack

    kaiserImpack.Parent = mainFrame

    local curveShotProMax = Instance.new("ImageButton")
    curveShotProMax.Name = "CurveShotProMax"
    curveShotProMax.Image = "rbxassetid://100284446653174"
    curveShotProMax.AnchorPoint = Vector2.new(0.5, 0.5)
    curveShotProMax.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    curveShotProMax.BackgroundTransparency = 1
    curveShotProMax.BorderColor3 = Color3.fromRGB(0, 0, 0)
    curveShotProMax.BorderSizePixel = 0
    curveShotProMax.Position = UDim2.fromScale(0.786, 0.344)
    curveShotProMax.Size = UDim2.fromScale(0.124, 0.124)
    curveShotProMax.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local buttonName2 = Instance.new("TextLabel")
    buttonName2.Name = "ButtonName"
    buttonName2.FontFace = Font.new(
    "rbxasset://fonts/families/GothamSSm.json",
    Enum.FontWeight.ExtraBold,
    Enum.FontStyle.Normal
    )
    buttonName2.Text = "Curve Shot"
    buttonName2.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonName2.TextScaled = true
    buttonName2.TextSize = 14
    buttonName2.TextWrapped = true
    buttonName2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    buttonName2.BackgroundTransparency = 1
    buttonName2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    buttonName2.BorderSizePixel = 0
    buttonName2.Position = UDim2.fromScale(-0.215, 0.33)
    buttonName2.Size = UDim2.fromScale(1.4, 0.449)
    buttonName2.ZIndex = 2

    local uIStroke2 = Instance.new("UIStroke")
    uIStroke2.Name = "UIStroke"
    uIStroke2.Thickness = 3
    uIStroke2.Transparency = 0.5
    uIStroke2.Parent = buttonName2

    local uIPadding2 = Instance.new("UIPadding")
    uIPadding2.Name = "UIPadding"
    uIPadding2.PaddingBottom = UDim.new(0.00668, 0)
    uIPadding2.PaddingLeft = UDim.new(0.223, 0)
    uIPadding2.PaddingRight = UDim.new(0.223, 0)
    uIPadding2.PaddingTop = UDim.new(0.00668, 0)
    uIPadding2.Parent = buttonName2

    buttonName2.Parent = curveShotProMax

    curveShotProMax.Parent = mainFrame

    local autoGK = Instance.new("ImageButton")
    autoGK.Name = "AutoGK"
    autoGK.Image = "rbxassetid://100284446653174"
    autoGK.AnchorPoint = Vector2.new(0.5, 0.5)
    autoGK.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    autoGK.BackgroundTransparency = 1
    autoGK.BorderColor3 = Color3.fromRGB(0, 0, 0)
    autoGK.BorderSizePixel = 0
    autoGK.Position = UDim2.fromScale(0.0837, 0.315)
    autoGK.Size = UDim2.fromScale(0.124, 0.124)
    autoGK.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local buttonName3 = Instance.new("TextLabel")
    buttonName3.Name = "ButtonName"
    buttonName3.FontFace = Font.new(
    "rbxasset://fonts/families/GothamSSm.json",
    Enum.FontWeight.ExtraBold,
    Enum.FontStyle.Normal
    )
    buttonName3.Text = "AutoGK Toggle"
    buttonName3.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonName3.TextScaled = true
    buttonName3.TextSize = 14
    buttonName3.TextWrapped = true
    buttonName3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    buttonName3.BackgroundTransparency = 1
    buttonName3.BorderColor3 = Color3.fromRGB(0, 0, 0)
    buttonName3.BorderSizePixel = 0
    buttonName3.Position = UDim2.fromScale(-0.215, 0.33)
    buttonName3.Size = UDim2.fromScale(1.4, 0.449)
    buttonName3.ZIndex = 2

    local uIStroke3 = Instance.new("UIStroke")
    uIStroke3.Name = "UIStroke"
    uIStroke3.Thickness = 3
    uIStroke3.Transparency = 0.5
    uIStroke3.Parent = buttonName3

    local uIPadding3 = Instance.new("UIPadding")
    uIPadding3.Name = "UIPadding"
    uIPadding3.PaddingBottom = UDim.new(0.00668, 0)
    uIPadding3.PaddingLeft = UDim.new(0.223, 0)
    uIPadding3.PaddingRight = UDim.new(0.223, 0)
    uIPadding3.PaddingTop = UDim.new(0.00668, 0)
    uIPadding3.Parent = buttonName3

    buttonName3.Parent = autoGK

    autoGK.Parent = mainFrame

    local hitBox = Instance.new("ImageButton")
    hitBox.Name = "HitBox"
    hitBox.Image = "rbxassetid://100284446653174"
    hitBox.AnchorPoint = Vector2.new(0.5, 0.5)
    hitBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hitBox.BackgroundTransparency = 1
    hitBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    hitBox.BorderSizePixel = 0
    hitBox.Position = UDim2.fromScale(0.0837, 0.465)
    hitBox.Size = UDim2.fromScale(0.124, 0.124)
    hitBox.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local buttonName4 = Instance.new("TextLabel")
    buttonName4.Name = "ButtonName"
    buttonName4.FontFace = Font.new(
    "rbxasset://fonts/families/GothamSSm.json",
    Enum.FontWeight.ExtraBold,
    Enum.FontStyle.Normal
    )
    buttonName4.Text = "HitBox Toggle"
    buttonName4.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonName4.TextScaled = true
    buttonName4.TextSize = 14
    buttonName4.TextWrapped = true
    buttonName4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    buttonName4.BackgroundTransparency = 1
    buttonName4.BorderColor3 = Color3.fromRGB(0, 0, 0)
    buttonName4.BorderSizePixel = 0
    buttonName4.Position = UDim2.fromScale(-0.215, 0.33)
    buttonName4.Size = UDim2.fromScale(1.4, 0.449)
    buttonName4.ZIndex = 2

    local uIStroke4 = Instance.new("UIStroke")
    uIStroke4.Name = "UIStroke"
    uIStroke4.Thickness = 3
    uIStroke4.Transparency = 0.5
    uIStroke4.Parent = buttonName4

    local uIPadding = Instance.new("UIPadding")
    uIPadding.Name = "UIPadding"
    uIPadding.PaddingBottom = UDim.new(0.00668, 0)
    uIPadding.PaddingLeft = UDim.new(0.223, 0)
    uIPadding.PaddingRight = UDim.new(0.223, 0)
    uIPadding.PaddingTop = UDim.new(0.00668, 0)
    uIPadding.Parent = buttonName4

    buttonName4.Parent = hitBox

    hitBox.Parent = mainFrame

    mainFrame.Parent = feariseHubMobile

    local ToggleList = {
        feariseHubMobileUI = feariseHubMobile,
        instantKickToggle = instantKick,
        kaiserImpackToggle = kaiserImpack,
        curveShotProMaxToggle = curveShotProMax,
        autoGKToggle = autoGK,
        hitBoxToggle = hitBox
    }

    return ToggleList
end
]]--