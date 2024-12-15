-- KeySystem.lua

local keys = {
    ["FORTUNE-D6X-K61-7BA"] = { hwid = "311F338E-A4B6-4AE8-AE25-C56B209C7E1A", used = true },
    ["FORTUNE-PDV-J33-3L6"] = { hwid = "B42CE9D5-5A28-45F1-BAF8-EFBFA6F6B6E1", used = true },
    ["FORTUNE-MEV-RJM-74N"] = { hwid = nil, used = false },
    -- เพิ่มคีย์อื่นๆ ตามต้องการ
}

local function getHwid()
    -- ดึง HWID ของผู้เล่น (ใช้ UserId แทนใน Roblox)
    return game:GetService("Players").LocalPlayer.UserId
end

local function runScript()
    -- สคริปต์ที่ต้องการให้รันเมื่อการตรวจสอบสำเร็จ
    print("Executing custom script after successful key validation!")
    -- ตัวอย่างสคริปต์ที่ต้องการให้รัน
    -- สามารถเพิ่มฟังก์ชันเพิ่มเติมตามต้องการ
    game.ReplicatedStorage:WaitForChild("MyCustomFunction"):FireServer()
end

local function checkKey(inputKey)
    local player = game.Players.LocalPlayer
    local playerHwid = getHwid()

    if keys[inputKey] then
        if keys[inputKey].used then
            -- ถ้าคีย์นี้ถูกใช้งานแล้ว
            player:Kick("Key already used!")  -- เตะผู้เล่นและแสดงข้อความ
        else
            if keys[inputKey].hwid == nil then
                -- ถ้า HWID ของคีย์ยังเป็น nil (ยังไม่ได้ถูกใช้)
                keys[inputKey].hwid = playerHwid
                print("HWID registered successfully!")
            elseif keys[inputKey].hwid == playerHwid then
                -- ถ้า HWID ตรงกัน
                print("Key validated successfully! HWID matched.")
                keys[inputKey].used = true
                -- เมื่อทุกอย่างสำเร็จให้รันสคริปต์ที่กำหนด
                runScript()
            else
                -- ถ้า HWID ไม่ตรงกัน
                player:Kick("HWID mismatch!")  -- เตะผู้เล่นและแสดงข้อความ
            end
        end
    else
        -- ถ้าคีย์ไม่ถูกต้อง
        player:Kick("Invalid key!")  -- เตะผู้เล่นและแสดงข้อความ
    end
end

-- คอยรับคีย์จากภายนอก (จาก `loadstring` ใน Roblox)
local inputKey = _G.inputKey  -- รับคีย์จากภายนอก
checkKey(inputKey)
