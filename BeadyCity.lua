-- KeySystem.lua

local keys = {
    -- เก็บคีย์และ HWID (แต่ไม่มีคีย์ในโค้ดนี้)
    ["FORTUNE-D6X-K61-7BA"] = { hwid = nil, used = false },
    ["FORTUNE-PDV-J33-3L6"] = { hwid = nil, used = false },
    -- เพิ่มคีย์อื่นๆ ได้ตามต้องการ
}

local function getHwid()
    -- ดึง HWID ของผู้เล่น (UserId)
    return game:GetService("Players").LocalPlayer.UserId
end

local function checkKey(inputKey)
    local playerHwid = getHwid()

    if keys[inputKey] then
        if keys[inputKey].used then
            -- ถ้าคีย์นี้ถูกใช้งานแล้ว
            print("Key already used!")
        else
            if keys[inputKey].hwid == nil then
                -- ถ้า HWID ของคีย์ยังเป็น nil (ยังไม่ได้ถูกใช้)
                keys[inputKey].hwid = playerHwid
                print("HWID registered successfully!")
            elseif keys[inputKey].hwid == playerHwid then
                -- ถ้า HWID ตรงกัน
                print("successful")
                keys[inputKey].used = true
            else
                -- ถ้า HWID ไม่ตรงกัน
                print("HWID mismatch!")
            end
        end
    else
        -- ถ้าคีย์ไม่ถูกต้อง
        print("Invalid key!")
    end
end

-- คอยรับคีย์จากภายนอก (จาก `loadstring` ใน Roblox)
local inputKey = _G.inputKey  -- รับคีย์จากภายนอก
checkKey(inputKey)
