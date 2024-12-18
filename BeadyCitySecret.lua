-- KeySystem.lua

local keys = {
    ["FORTUNE-D6X-K61-7BA"] = { clientId = "311F338E-A4B6-4AE8-AE25-C56B209C7E1A", used = false, admin = false, gameAccess = {BeadyCity = true, BlueLockRival = false} },
    ["FORTUNE-PDV-J33-3L6"] = { clientId = "B42CE9D5-5A28-45F1-BAF8-EFBFA6F6B6E1", used = false, admin = false, gameAccess = {BeadyCity = true, BlueLockRival = false} },
    ["FORTUNE-MEV-RJM-74N"] = { clientId = nil, used = false, admin = false, gameAccess = {BeadyCity = true, BlueLockRival = false} },
    ["FORTUNE-ADMIN-ADMIN-ADMIN"] = { clientIds = {"311F338E-A4B6-4AE8-AE25-C56B209C7E1A", "B42CE9D5-5A28-45F1-BAF8-EFBFA6F6B6E1"}, used = false, admin = true, gameAccess = {BeadyCity = true, BlueLockRival = true} },  -- เพิ่ม 2 Client IDs สำหรับแอดมิน
    -- เพิ่มคีย์อื่นๆ
}

-- ฟังก์ชันดึง Client ID
local function getClientId()
    return tostring(game:GetService("RbxAnalyticsService"):GetClientId())
end

-- ฟังก์ชันสำหรับรันสคริปต์เมื่อการตรวจสอบสำเร็จ
local function runScript()
    warn("SUCCESFULLY CHECK KEY/HWID")
    wait(1)
    warn("LOADING...")
end

-- ฟังก์ชันสำหรับฟังก์ชันแอดมินที่สามารถใช้งานได้
local function adminScript()
    print("Admin access granted! Running admin script...")
    -- ฟังก์ชันพิเศษที่แอดมินสามารถใช้งาน
    -- ตัวอย่างฟังก์ชันที่ใช้เฉพาะแอดมิน
    game.ReplicatedStorage:WaitForChild("AdminFunction"):FireServer()
end

-- ฟังก์ชันตรวจสอบคีย์และทำงานตามเงื่อนไข
local function checkKey(inputKey)
    local player = game.Players.LocalPlayer
    local playerClientId = getClientId()

    if not keys[inputKey] then
        -- คีย์ไม่ถูกต้อง
        player:Kick("Invalid key!")
        return
    end

    local keyData = keys[inputKey]

    if keyData.used then
        -- คีย์ถูกใช้งานแล้ว
        player:Kick("Key already used!")
        return
    end

    if keyData.clientId == nil then
        -- ถ้า Client ID ของคีย์ยังไม่ได้ถูกใช้
        keyData.clientId = playerClientId
        print("Client ID registered successfully!")
        return
    end

    if keyData.admin then
        -- ตรวจสอบว่าผู้เล่นมี Client ID ที่ตรงกับ 2 ตัวที่กำหนดในคีย์แอดมิน
        local isValidAdmin = false
        for _, adminClientId in ipairs(keyData.clientIds) do
            if adminClientId == playerClientId then
                isValidAdmin = true
                break
            end
        end

        if isValidAdmin then
            -- หากตรงกับ 2 Client ID สำหรับแอดมิน
            print("Admin Key validated successfully! Client ID matched.")
            keyData.used = true
            adminScript()  -- รันสคริปต์แอดมิน
        else
            -- ถ้า Client ID ไม่ตรงกับแอดมิน
            player:Kick("Client ID mismatch for Admin key!")
        end
    else
        -- หากคีย์ไม่ใช่แอดมิน
        if keyData.clientId == playerClientId then
            print("Key validated successfully! Client ID matched.")
            keyData.used = true
            local gameAccess = keyData.gameAccess
            if gameAccess.BeadyCity == true then
                local success, err = pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Malemz1/FORTUNE-HUB/refs/heads/main/BeadyCity.lua"))()
                end)
                if not success then
                    error("Error Message: "..err)
                else
                    runScript()  -- รันสคริปต์ปกติ
                end
            elseif gameAccess.BlueLockRival == true then
                error("เข้าถึงได้ไงยังไม่เสร็จ")
                task.wait(10)
                game.Players.LocalPlayer:Kick("ตัวเจาะกัง")
            end
        else
            -- ถ้า Client ID ไม่ตรงกัน
            player:Kick("Client ID mismatch!")
        end
    end
end

-- รับคีย์จากภายนอกและตรวจสอบ
local inputKey = _G.inputKey
if inputKey then
    checkKey(inputKey)
else
    warn("No input key provided.")
end
