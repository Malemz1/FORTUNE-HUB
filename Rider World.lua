repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
getgenv().Settings = {
    AutoFarmLevel = nil,
    SelectNPCType = nil,
    SelectNPC = nil,
    SelectMob = nil,
    AutoMob = nil,
    SelectKeySkill = nil,
    AutoSkill = nil,
    AutoReset = nil,
    SelectDungeon = nil,
    AutoDungeon = nil,
}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."Rider World".." | ".."[Version X]",
    SubTitle = "by Blobby",
    TabWidth = 160,
    Size =  UDim2.fromOffset(580, 460), --UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Rose", --Amethyst
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    --[[ Tabs --]]
    pageSetting = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageTeleport = Window:AddTab({ Title = "Teleport", Icon = "map" }),
}

    --[[ SETTINGS ]]--------------------------------------------------------
    local SelectKeySkill = Tabs.pageSetting:AddDropdown("SelectKeySkill", {
        Title = "Select Skill",
        Values = {"E", "R", "C", "V"},
        Multi = true,
        Default = getgenv().Settings.SelectKeySkill or {},
        Callback = function(Value)
            getgenv().Settings.SelectKeySkill = Value
        end
    })
    SelectKeySkill:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        getgenv().Settings.SelectKeySkill = Values
    end)
    local AutoSkill = Tabs.pageSetting:AddToggle("AutoSkill", {Title = "Auto Skill", Default = getgenv().Settings.AutoSkill or false })
    local AutoReset = Tabs.pageSetting:AddToggle("AutoReset", {Title = "Auto Reset", Default = getgenv().Settings.AutoReset or false })

    local AttackModes = {"M1", "M2", "M1 + M2"}
    local SelectAttackMode = Tabs.pageSetting:AddDropdown("SelectAttackMode", {
        Title = "Select Attack Mode",
        Values = AttackModes,
        Multi = false, -- ให้เลือกได้เพียง 1 แบบ
        Default = getgenv().Settings.SelectAttackMode or "M1 + M2",
        Callback = function(Value)
            getgenv().Settings.SelectAttackMode = Value
        end
    })

    SelectAttackMode:OnChanged(function(Value)
        getgenv().Settings.SelectAttackMode = Value
    end)

    local MiscTT = Tabs.pageSetting:AddSection("Misc Setting")

    local AutoForm = Tabs.pageSetting:AddToggle("AutoForm", {Title = "Auto Form", Default = false })
    local SelectForm -- ตัวแปร Dropdown
    local SelectedForm = "" -- ตัวแปรเก็บค่าฟอร์มที่เลือก
    
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    
    -- Table ของ ClientRider และฟอร์มที่มีให้เลือก
    local FormTable = {
        ["Kugha"] = {"Dragon", "Pegasus", "Titan", "Rising Mighty", "Amazing Mighty", "Ultimated"},
        ["Double"] = {"Cyclone Joker", "Heat Metal", "Luna Trigger", "Fang Joker", "Extreme"},
        ["Cobra"] = {"Survive Cobra"},
        ["Blue Bat"] = {"Survive Bat"},
        ["Red Dragon"] = {"Survive Dragon"},
        ["Dark Dragon"] = {"Survive Dark Dragon"},
    }
    
    -- ฟังก์ชันตรวจสอบว่าผู้เล่นแปลงร่างอยู่หรือไม่
    local function IsTransformed()
        local character = Workspace.Lives:FindFirstChild(LocalPlayer.Name)
        return character and character:FindFirstChild("Form")
    end
    
    -- ฟังก์ชันตรวจสอบว่ามีไอเทมอยู่ใน Backpack และตรงกับฟอร์มหรือไม่
    local function HasCorrectItemInBackpack()
        local backpack = LocalPlayer.RiderStats.CustomBackpack
        if backpack and backpack:FindFirstChild("2") then
            local item = backpack["2"]
            if item.Value == SelectedForm then
                return true
            else
                return false
            end
        end
        return false
    end
    
    -- ฟังก์ชันคืนไอเทมหลังจากแปลงร่างเสร็จ
    local function ReturnItemToBackpack()
        ReplicatedStorage.Remote.Function.InventoryFunction:InvokeServer(1, "Backpack")
    end
    
    -- ฟังก์ชันแปลงร่างสำหรับ Cobra, Blue Bat, Red Dragon, Dark Dragon
    local function TransformWithItem()
        if IsTransformed() then return end
    
        local currentRider = LocalPlayer.RiderStats.ClientRider.Value
        local formName = SelectedForm
        if not formName then
            return
        end
    
        -- ถ้าไม่มีไอเทมหรือไอเทมไม่ตรงกับฟอร์ม ให้ดึงจาก Inventory
        if not HasCorrectItemInBackpack() then
            ReplicatedStorage.Remote.Function.InventoryFunction:InvokeServer(formName)
            task.wait(1)
        end
    
        -- ถือ Item แปลงร่าง (ถือที่ Slot 2)
        ReplicatedStorage.Remote.Function.InventoryFunction:InvokeServer(2, "Backpack")
        task.wait(1)

        print("🖱️ กดใช้ Item เพื่อแปลงร่าง")
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    
        task.wait(2)

        ReturnItemToBackpack()
    end
    
    -- ฟังก์ชันเปลี่ยนฟอร์มอัตโนมัติ
    local function ChangeToSelectedForm()
        local currentRider = LocalPlayer.RiderStats.ClientRider.Value
    
        -- เช็คว่าผู้เล่นมีฟอร์มที่เลือกไหม
        if not SelectedForm or SelectedForm == "" then

            return
        end

        if IsTransformed() then

            return
        end

    
        if currentRider == "Kugha" then
            local ohTable1 = {["ActiveForm"] = SelectedForm, ["ActiveRider"] = true}
            print("📡 ส่ง Remote Kugha ->", SelectedForm)
            ReplicatedStorage.Remote.Function.AncientWorldEventRemote:InvokeServer(ohTable1)
    
        elseif currentRider == "Double" then
            local ohTable1 = {["ActiveForm"] = SelectedForm, ["ActiveRider"] = true}
            print("📡 ส่ง Remote Double ->", SelectedForm)
            ReplicatedStorage.Remote.Function.FoundationEventRemote:InvokeServer(ohTable1)
    
        elseif FormTable[currentRider] then
            -- ใช้ระบบแปลงร่างด้วย Item
            TransformWithItem()
        else
        end
    
        task.wait(1)
    end
    
    -- ฟังก์ชันอัปเดต Dropdown ฟอร์มตาม ClientRider
    local function UpdateFormDropdown()
        local currentRider = LocalPlayer.RiderStats.ClientRider.Value
        local availableForms = FormTable[currentRider] or {}
    
        if SelectForm then
            SelectForm:SetValues(availableForms)
            SelectForm:SetValue(availableForms[1] or "")
            SelectedForm = availableForms[1] or ""
        end

    end
    
    -- สร้าง Dropdown เลือกฟอร์ม
    SelectForm = Tabs.pageSetting:AddDropdown("SelectForm", {
        Title = "Select Form",
        Values = {},
        Multi = false,
        Default = "",
        Callback = function(Value)
            SelectedForm = Value
        end
    })
    
    -- เรียกใช้เมื่อ ClientRider เปลี่ยน
    LocalPlayer.RiderStats.ClientRider:GetPropertyChangedSignal("Value"):Connect(UpdateFormDropdown)
    
    -- อัปเดต Dropdown ครั้งแรก
    UpdateFormDropdown()
    
    -- เปิดใช้งาน AutoForm
    AutoForm:OnChanged(function()
        task.spawn(function()
            while AutoForm.Value do
                task.wait(2) -- ตรวจสอบทุก 5 วินาที
                pcall(ChangeToSelectedForm)
            end
        end)
    end)

    --[[ MAIN ]]--------------------------------------------------------
    local MainSection = Tabs.pageMain:AddSection("Main")
    local AutoFarmLevel = Tabs.pageMain:AddToggle("AutoFarmLevel", {Title = "Auto Farm Level", Default = getgenv().Settings.AutoFarmLevel or false })
    local MobSection = Tabs.pageMain:AddSection("Mobs")
    local MobList = {
        "Foundation Elite Lv.85", "Absorb Dummy Lv.80", "Flawless Goon Lv.80",
        "Dummy Lv.80", "Flying Xugo Lv.80", "Gaze Goon Lv.80", "Mysterious Goon Lv.80",
        "Combat Goon Lv.75", "Ancient Goon Lv.70", "Foundation Soldier Lv.64",
        "City Bandit Lv.60", "Shark User Lv.60", "Flare Man Lv.55", "Metal Man Lv.55",
        "Shark Overloaded Lv.55", "Bullet Man Lv.55", "Luna Girl Lv.55",
        "Violent Dragoon Lv.50", "Shark Monster Lv.50", "Ancient Mummy Lv.50",
        "Dragoon Lv.45", "Gazelle User Lv.45", "Gazelle Monster Lv.45",
        "Tiger User Lv.40", "Rhino User Lv.40", "Savage Goon Lv.40",
        "Dark Dragon User Lv.40", "Mummy Lv.40","Xugo (Human) Lv.40","Lost Miner Lv.35",
        "Chameleon User Lv.35", "Zebra Monster Lv.35", "Swan User Lv.30",
        "Manta User Lv.25", "Cobra User Lv.20", "Foundation Soldier Lv.16",
        "Bull User Lv.15", "Bat User Lv.12", "Crab User Lv.10", "Foundation Soldier Lv.8",
        "Dragon User Lv.7", "Armed Lost Rider Lv.5", "Lost Rider Lv.1"
    }
-- ฟังก์ชันแยกเลเวลออกจากชื่อมอน
local function ExtractLevel(mobName)
    local level = string.match(mobName, "Lv%.(%d+)")
    return tonumber(level) or 0 -- ถ้าไม่มีเลเวล ให้ถือว่าเป็น 0
end

-- เรียงลำดับจาก "เลเวลสูง" ไป "เลเวลต่ำ"
table.sort(MobList, function(a, b)
    return ExtractLevel(a) > ExtractLevel(b)
end)

-- เพิ่ม Dropdown สำหรับเลือกมอน
local SelectMob = Tabs.pageMain:AddDropdown("SelectMob", {
    Title = "Select Mobs",
    Values = MobList,
    Multi = true,  -- เปิด Multi-Select
    Default = getgenv().Settings.SelectMob or {},
    Callback = function(Value)
        local SelectedMobs = {}
        for Mob, State in pairs(Value) do
            if State and not table.find(SelectedMobs, Mob) then
                table.insert(SelectedMobs, Mob)
            end
        end
        getgenv().Settings.SelectMob = SelectedMobs
        print("Selected Mobs:", table.concat(getgenv().Settings.SelectMob, ", "))
    end
})

-- อัปเดตค่าเมื่อมีการเลือกมอน
SelectMob:OnChanged(function(Value)
    local SelectedMobs = {}
    for Mob, State in pairs(Value) do
        if State and not table.find(SelectedMobs, Mob) then
            table.insert(SelectedMobs, Mob)
        end
    end
    getgenv().Settings.SelectMob = SelectedMobs
    print("Updated Selected Mobs:", table.concat(getgenv().Settings.SelectMob, ", "))
end)
    local AutoMob = Tabs.pageMain:AddToggle("AutoMob", {Title = "Auto Mob", Default = getgenv().Settings.AutoMob or false })
    local DungeonSection = Tabs.pageMain:AddSection("Dungeons")
    local SelectDungeon = Tabs.pageMain:AddDropdown("SelectDungeon", {
        Title = "SelectDungeon",
        Values = {"Ancient", "Oz", "Ethernal", "Jocker", "Diend", "Zyga", "Orca", "Odin"},
        Multi = false,
        Default = getgenv().Settings.SelectDungeon or "",
        Callback = function(Value)
            getgenv().Settings.SelectDungeon = Value
        end
    })
    SelectDungeon:OnChanged(function(Value)
        getgenv().Settings.SelectDungeon = Value
    end)
    local AutoDungeon = Tabs.pageMain:AddToggle("AutoDungeon", {Title = "Auto Dungeon", Default = getgenv().Settings.AutoDungeon or false })

    local MiscTitle = Tabs.pageMain:AddSection("Misc")

    Tabs.pageMain:AddButton({
        Title = "Reset Char",
        Description = "Kuy กร,Kuy แฮม",
        Callback = function()
            Window:Dialog({
                Title = "กด Cancel พ่องตาย ไอกร ไอแฮม",
                Content = "ควยๆๆๆๆๆๆ",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            game:GetService("Players").LocalPlayer.Character.Humanoid.Health = 0
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                        end
                    }
                }
            })
        end
    })

    --[[ TELEPORT ]]--------------------------------------------------------
    local SelectNPCType = Tabs.pageTeleport:AddDropdown("SelectNPCType", {
        Title = "Select NPC Type",
        Values = {"MainQuest", "EventQuest", "DailyQuest", "RepeatQuest", "HunterMark", "Dark DragonMark", "ZygaMark", "OzMark", "???Mark", "KughaMark", "Kugha UltimatedMark", "Kugha's FormMark", "DoubleMark", "Double ExtremeMark", "Cobra FormsMark", "NEXTMark", "UndeadMark", "DeltarMark"},
        Multi = false,
        Default = getgenv().Settings.SelectNPCType or "MainQuest",
        Callback = function(Value)
            getgenv().Settings.SelectNPCType = Value
        end
    })
    SelectNPCType:OnChanged(function(Value)
        getgenv().Settings.SelectNPCType = Value
    end)
    local NPCList = {}
    local function NPCListInsert()
        for i,v in pairs(workspace.NPC:GetChildren())do
            if v:IsA("BasePart") and v:FindFirstChild(getgenv().Settings.SelectNPCType) then
                table.insert(NPCList,v.Name)
            end
        end
    end
    local function NPCListRemove()
        if NPCList ~= nil then
            for i = #NPCList, 1, -1 do
                table.remove(NPCList, i)
            end
        end
    end
    NPCListInsert()
    local SelectNPC = Tabs.pageTeleport:AddDropdown("SelectNPC", {
        Title = "Select NPC",
        Values = NPCList,
        Multi = false,
        Default = getgenv().Settings.SelectNPC or NPCList[1],
        Callback = function(Value)
            getgenv().Settings.SelectNPC = Value
        end
    })
    SelectNPC:OnChanged(function(Value)
        getgenv().Settings.SelectNPC = Value
    end)
    local RefreshNPC = Tabs.pageTeleport:AddButton({
        Title = "Refresh NPC",
        Callback = function()
            local currentSelection = SelectNPC.Value
            
            NPCListRemove()
            NPCListInsert()
            SelectNPC:SetValues(NPCList)
            
            if table.find(NPCList, currentSelection) then
                SelectNPC:SetValue(currentSelection)
            else
                SelectNPC:SetValue(NPCList[#NPCList])
            end
        end
    })
    local TeleportToNPC = Tabs.pageTeleport:AddButton({
        Title = "Teleport To NPC",
        Callback = function()
            for i,v in pairs(workspace.NPC:GetChildren()) do
                if v.Name == getgenv().Settings.SelectNPC and v:IsA("BasePart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 5, 0)
                end
            end
        end
    })

    --[[ SCRIPTS ]]--------------------------------------------------------
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
    local Humanoid = character:FindFirstChild("Humanoid") or character:WaitForChild("Humanoid", 5)

    local function CheckLevel()
        local Level = game:GetService("Players").LocalPlayer.StatsReplicated.Level.Value
        if Level >= 1 and Level < 7 then
            MonName = {"Lost Rider Lv.1"}
            QuestName = "Lost Old Man"
            QuestShowName = "Lost and Found"
            QuestFound = CFrame.new(-996.0609741210938, 4.308961391448975, -664.2533569335938)
        elseif Level >= 7 and Level < 40 then
            MonName = {"Dragon User Lv.7", "Crab User Lv.10", "Bat User Lv.12"}
            QuestName = "Alliance"
            QuestShowName = "Dragon's Alliance"
            QuestFound = CFrame.new(-779.0507202148438, 4.667331695556641, -791.353515625)
        elseif Level >= 40 then
            MonName = {"Dark Dragon User Lv.40", "Gazelle User Lv.45"}
            QuestName = "Malcom"
            QuestShowName = "The Hunt Hunted"
            QuestFound = CFrame.new(-961.934814453125, 26.49575424194336, 183.1441192626953)
        end
    end

    local function EquipSlot(Slot)
        local args = {
            [1] = Slot,
            [2] = "Backpack"
        }
        game:GetService("ReplicatedStorage").Remote.Function.InventoryFunction:InvokeServer(unpack(args))
    end

    local antifall
    AutoFarmLevel:OnChanged(function()
        task.spawn(function()
            while AutoFarmLevel.Value do
                task.wait()
                pcall(function()
                    CheckLevel()
                    player.CharacterAdded:Connect(function(newCharacter)
                        character = newCharacter
                        HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
                        Humanoid = newCharacter:WaitForChild("Humanoid")
                    end)
                    local QuestGui = player.PlayerGui.Main.QuestAlertFrame.QuestGUI
                    if character:FindFirstChild("Transformed") then
                        if HumanoidRootPart:FindFirstChild("antifall") and HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
                            if QuestGui:FindFirstChild(QuestShowName) then
                                if string.find(QuestGui[QuestShowName].Text, "Completed") then
                                    if not character:FindFirstChild("Attack") then
                                        if workspace.NPC:FindFirstChild(QuestName) then
                                            for QuestIndex, QuestValue in pairs(workspace.NPC:GetChildren()) do
                                                if QuestValue.Name == QuestName and QuestValue:FindFirstChild(QuestName) then
                                                    HumanoidRootPart.CFrame = QuestValue.CFrame * CFrame.new(0, 5, 0)
                                                    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TalkingGUI") then
                                                        local args = {
                                                            [1] = {
                                                                ["Accept"] = true
                                                            }
                                                        }
                                                        game:GetService("ReplicatedStorage").Remote.Event.TalkingRemote:FireServer(unpack(args))                                    
                                                    else
                                                        local args = {
                                                            [1] = "QuestChecker",
                                                            [2] = workspace:WaitForChild("NPC"):WaitForChild(QuestName)
                                                        }
                                                        game:GetService("Players").LocalPlayer.Character.PlayerHandler.HandlerFunction:InvokeServer(unpack(args))
                                                        task.wait(.5)     
                                                    end                      
                                                end
                                            end
                                        else
                                            HumanoidRootPart.CFrame = QuestFound
                                            task.wait(.1)
                                        end
                                    else
                                        EquipSlot(1)
                                        task.wait(.1)
                                    end
                                else
                                    if character:FindFirstChild("Attack") then
                                        if not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TalkingGUI") then
                                            if workspace.NPC:FindFirstChild(QuestName) then
                                                for _, MonValue in pairs(workspace.Lives:GetChildren()) do
                                                    if table.find(MonName, MonValue.Name) and MonValue:FindFirstChild("Humanoid") and MonValue:FindFirstChild("HumanoidRootPart") then
                                                        if MonValue.Humanoid.Health > 0 then
                                                            repeat task.wait()
                                                                pcall(function()
                                                                    -- 🏹 วาร์ปไปหามอน
                                                                    HumanoidRootPart.CFrame = MonValue.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                    
                                                                    -- 🏃 กด Shift ถ้ามีการล็อคเมาส์
                                                                    task.spawn(function()
                                                                        local UserInputService = game:GetService("UserInputService")
                                                                        local VirtualInputManager = game:GetService("VirtualInputManager")
                                                                        if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
                                                                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
                                                                            task.wait(0.1)
                                                                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
                                                                        end
                                                                    end)
                                    
                                                                    -- ⚔️ ใช้ M1 ถ้าเลือก M1 หรือ M1 + M2
                                                                    if getgenv().Settings.SelectAttackMode == "M1" or getgenv().Settings.SelectAttackMode == "M1 + M2" then
                                                                        task.spawn(function()
                                                                            local args = {
                                                                                [1] = {
                                                                                    ["CombatAction"] = true,
                                                                                    ["MouseData"] = MonValue.HumanoidRootPart.CFrame,
                                                                                    ["Input"] = "Mouse1",
                                                                                    ["LightAttack"] = true,
                                                                                    ["Attack"] = true
                                                                                }
                                                                            }
                                                                            character.PlayerHandler.HandlerEvent:FireServer(unpack(args))
                                                                        end)
                                                                    end
                                    
                                                                    -- ⚔️ ใช้ M2 ถ้าเลือก M2 หรือ M1 + M2
                                                                    if getgenv().Settings.SelectAttackMode == "M2" or getgenv().Settings.SelectAttackMode == "M1 + M2" then
                                                                        task.spawn(function()
                                                                            local args = {
                                                                                [1] = {
                                                                                    ["CombatAction"] = true,
                                                                                    ["MouseData"] = MonValue.HumanoidRootPart.CFrame,
                                                                                    ["Input"] = "Mouse2",
                                                                                    ["HeavyAttack"] = true,
                                                                                    ["Attack"] = true
                                                                                }
                                                                            }
                                                                            character.PlayerHandler.HandlerEvent:FireServer(unpack(args))
                                                                        end)
                                                                    end
                                                                end)
                                                            until not AutoFarmLevel.Value or MonValue.Humanoid.Health <= 0 or not QuestGui:FindFirstChild(QuestShowName) or Humanoid.Health <= 0 or string.find(QuestGui[QuestShowName].Text, "Completed") or not character:FindFirstChild("Transformed")
                                                        end
                                                    end
                                                end
                                            else
                                                -- 📌 ถ้าไม่มี NPC เควส ให้กลับไปหาจุดรับเควส
                                                HumanoidRootPart.CFrame = QuestFound
                                                task.wait(.1)
                                            end
                                        else
                                            -- 📌 ออกจากหน้าต่างสนทนา
                                            local args = { [1] = { ["Exit"] = true } }
                                            game:GetService("ReplicatedStorage").Remote.Event.TalkingRemote:FireServer(unpack(args))                                    
                                        end
                                    else
                                        -- 📌 ถ้ายังไม่ติดตั้งอาวุธ กด EquipSlot(1)
                                        EquipSlot(1)
                                        task.wait(.1)
                                    end
                                end
                            else
                                if not character:FindFirstChild("Attack") then
                                    if workspace.NPC:FindFirstChild(QuestName) then
                                        for QuestIndex, QuestValue in pairs(workspace.NPC:GetChildren()) do
                                            if QuestValue.Name == QuestName and QuestValue:FindFirstChild(QuestName) then
                                                HumanoidRootPart.CFrame = QuestValue.CFrame * CFrame.new(0, 5, 0)
                                                if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TalkingGUI") then
                                                    local args = {
                                                        [1] = {
                                                            ["Accept"] = true
                                                        }
                                                    }
                                                    game:GetService("ReplicatedStorage").Remote.Event.TalkingRemote:FireServer(unpack(args))                                    
                                                else
                                                    local args = {
                                                        [1] = "QuestChecker",
                                                        [2] = workspace:WaitForChild("NPC"):WaitForChild(QuestName)
                                                    }
                                                    game:GetService("Players").LocalPlayer.Character.PlayerHandler.HandlerFunction:InvokeServer(unpack(args))
                                                    task.wait(.5)     
                                                end                      
                                            end
                                        end
                                    else
                                        HumanoidRootPart.CFrame = QuestFound
                                        task.wait(.1)
                                    end
                                else
                                    EquipSlot(1)
                                    task.wait(.1)
                                end
                            end
                        else
                            antifall = Instance.new("BodyVelocity", HumanoidRootPart)
                            antifall.Velocity = Vector3.new(0, 0, 0)
                            antifall.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            antifall.P = 1250
                            antifall.Name = "antifall"
                            Humanoid.PlatformStand = true
                        end
                    else
                        game:GetService("Players").LocalPlayer.Character.PlayerHandler.HandlerFunction:InvokeServer("Henshin")     
                        task.wait(.1)               
                    end
                end)
            end
            task.wait(.1)
            if not AutoFarmLevel.Value then
                pcall(function()
                    for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                        if v.Name == "antifall" or v:IsA("BodyVelocity") then
                            task.wait(.1)
                            v:Destroy()
                            Humanoid.PlatformStand = false
                            antifall = nil
                        end
                    end
                end)
            end
        end)
    end)    

    AutoMob:OnChanged(function()
        task.spawn(function()
            while AutoMob.Value do
                task.wait()
                pcall(function()
                    player.CharacterAdded:Connect(function(newCharacter)
                        character = newCharacter
                        HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
                        Humanoid = newCharacter:WaitForChild("Humanoid")
                    end)
    
                    if character:FindFirstChild("Transformed") then
                        if HumanoidRootPart:FindFirstChild("antifall") and HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
                            if character:FindFirstChild("Attack") then
                                for _, SelectedMobName in pairs(getgenv().Settings.SelectMob) do
                                    for _, Mob in pairs(workspace.Lives:GetChildren()) do
                                        if Mob.Name == SelectedMobName and Mob:FindFirstChild("Humanoid") and Mob:FindFirstChild("HumanoidRootPart") then
                                            if Mob.Humanoid.Health > 0 then
                                                pcall(function()
                                                    repeat task.wait()
                                                        -- 🏹 วาร์ปไปมอน
                                                        HumanoidRootPart.CFrame = Mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    
                                                        -- ⚔️ โจมตีมอนตามโหมดที่เลือก
                                                        if getgenv().Settings.SelectAttackMode == "M1" or getgenv().Settings.SelectAttackMode == "M1 + M2" then
                                                            local attackArgs = {
                                                                [1] = {
                                                                    ["CombatAction"] = true,
                                                                    ["MouseData"] = Mob.HumanoidRootPart.CFrame,
                                                                    ["Input"] = "Mouse1",
                                                                    ["LightAttack"] = true,
                                                                    ["Attack"] = true
                                                                }
                                                            }
                                                            character.PlayerHandler.HandlerEvent:FireServer(unpack(attackArgs))
                                                        end
    
                                                        task.wait(.1)
    
                                                        if getgenv().Settings.SelectAttackMode == "M2" or getgenv().Settings.SelectAttackMode == "M1 + M2" then
                                                            local heavyAttackArgs = {
                                                                [1] = {
                                                                    ["CombatAction"] = true,
                                                                    ["MouseData"] = Mob.HumanoidRootPart.CFrame,
                                                                    ["Input"] = "Mouse2",
                                                                    ["HeavyAttack"] = true,
                                                                    ["Attack"] = true
                                                                }
                                                            }
                                                            character.PlayerHandler.HandlerEvent:FireServer(unpack(heavyAttackArgs))
                                                        end
    
                                                    until not AutoMob.Value or Mob.Humanoid.Health <= 0 or Humanoid.Health <= 0 or not character:FindFirstChild("Attack") or not character:FindFirstChild("Transformed")
                                                end)
                                            end
                                        end
                                    end
                                end
                            else
                                EquipSlot(1)
                                task.wait(.1)
                            end
                        else
                            -- ป้องกันการตกจากแมพ
                            antifall = Instance.new("BodyVelocity", HumanoidRootPart)
                            antifall.Velocity = Vector3.new(0, 0, 0)
                            antifall.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            antifall.P = 1250
                            antifall.Name = "antifall"
                            Humanoid.PlatformStand = true
                        end
                    else
                        game:GetService("Players").LocalPlayer.Character.PlayerHandler.HandlerFunction:InvokeServer("Henshin")     
                        task.wait(.1)       
                    end
                end)
            end
    
            -- หยุดทำงานแล้วลบ antifall
            if not AutoMob.Value then
                pcall(function()
                    for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                        if v.Name == "antifall" or v:IsA("BodyVelocity") then
                            task.wait(.1)
                            v:Destroy()
                            Humanoid.PlatformStand = false
                            antifall = nil
                        end
                    end
                end)
            end
        end)
    end)

    AutoSkill:OnChanged(function()
        task.spawn(function()
            while AutoSkill.Value do
                task.wait()
                player.CharacterAdded:Connect(function(newCharacter)
                    character = newCharacter
                    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
                    Humanoid = newCharacter:WaitForChild("Humanoid")
                end)
                if AutoMob.Value or AutoFarmLevel.Value or AutoDungeon.Value then
                    if AutoReset.Value then
                        pcall(function()
                            local text = game:GetService("Players").LocalPlayer.PlayerGui.Main.Info.Stamina.StaminaText.Text
                            local staminaMax = string.match(text, "/(%d+)")

                            if game:GetService("Players").LocalPlayer.RiderStats.Stamina.Value <= staminaMax * 0.2 then
                                Humanoid.Health = 0
                            else
                                for SkillIndex, SkillValue in ipairs(getgenv().Settings.SelectKeySkill) do
                                    local VirtualInputManager = game:GetService("VirtualInputManager")
                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[SkillValue], false, game)
                                    task.wait(.1)
                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[SkillValue], false, game)
                                end
                            end
                        end)
                    else
                        for SkillIndex, SkillValue in ipairs(getgenv().Settings.SelectKeySkill) do
                            local VirtualInputManager = game:GetService("VirtualInputManager")
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[SkillValue], false, game)
                            task.wait(.1)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[SkillValue], false, game)
                        end
                    end
                end
            end
        end)
    end)

    AutoDungeon:OnChanged(function()
        task.spawn(function()
            while AutoDungeon.Value do
                task.wait()
                player.CharacterAdded:Connect(function(newCharacter)
                    character = newCharacter
                    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
                    Humanoid = newCharacter:WaitForChild("Humanoid")
                end)
    
                if game:GetService("Players").LocalPlayer.StatsReplicated.Level.Value >= 80 then
                    if game:GetService("Players").LocalPlayer:FindFirstChild("Dungeon") then
                        for _, DungeonMon in ipairs(workspace.Lives:GetChildren()) do
                            if DungeonMon:IsA("Model") and DungeonMon:FindFirstChild("Humanoid") and DungeonMon:FindFirstChild("AI_Controller") then
                                -- ❌ Skip Boss and "T-Rex Dopant Lv.80"
                                if DungeonMon:FindFirstChild("Boss") or DungeonMon.Name == "T-Rex Dopant Lv.80" then
                                    print("Skipping Boss:", DungeonMon.Name)
                                else
                                    -- ✅ Attack Only Non-Boss Monsters
                                    if DungeonMon.Humanoid.Health > 0 then
                                        repeat task.wait()
                                            HumanoidRootPart.CFrame = DungeonMon.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
    
                                            local attackArgs = {
                                                [1] = {
                                                    ["CombatAction"] = true,
                                                    ["MouseData"] = DungeonMon.HumanoidRootPart.CFrame,
                                                    ["Input"] = "Mouse1",
                                                    ["LightAttack"] = true,
                                                    ["Attack"] = true
                                                }
                                            }
                                            character.PlayerHandler.HandlerEvent:FireServer(unpack(attackArgs))
    
                                        until not AutoDungeon.Value or DungeonMon.Humanoid.Health <= 0 or Humanoid.Health <= 0
                                    end
                                end
                            end
                        end
                    else
                        -- 🚀 Enter Dungeon if Not Inside
                        local args = {
                            [1] = "Trial of "..getgenv().Settings.SelectDungeon
                        }  
                        game:GetService("ReplicatedStorage").Remote.Function.TrialUniversalRemote:InvokeServer(unpack(args))
                        task.wait(1)                    
                    end
                else
                    Fluent:Notify({
                        Title = "BlobbyHub",
                        Content = "Your Rider Must Level 80",
                        Duration = 5
                    })
                    task.wait(.1)
                    AutoDungeon:SetValue(false)
                end
            end 
    
            -- 🛑 Stop Auto Dungeon and Remove Anti-Fall
            task.wait(.1)
            if not AutoDungeon.Value then
                pcall(function()
                    for _, v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                        if v.Name == "antifall" or v:IsA("BodyVelocity") then
                            task.wait(.1)
                            v:Destroy()
                            Humanoid.PlatformStand = false
                        end
                    end
                end)
            end
        end)
    end)    

Window:SelectTab(1)

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
