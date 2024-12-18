local keys = {
    ["FORTUNE-D6X-K61-7BA"] = { clientId = "311F338E-A4B6-4AE8-AE25-C56B209C7E1A", used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-PDV-J33-3L6"] = { clientId = "B42CE9D5-5A28-45F1-BAF8-EFBFA6F6B6E1", used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-MEV-RJM-74N"] = { clientId = "36BECFFC-B312-4A6C-B3FA-22ADBE4A33C8", used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-30K-I1F-C2U"] = { clientId = nil, used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-VJT-H1G-14F"] = { clientId = nil, used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-PZK-NWV-RCX"] = { clientId = nil, used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-HWS-ITG-OU2"] = { clientId = nil, used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-VS8-QKM-5EV"] = { clientId = nil, used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-D90-USN-2T2"] = { clientId = nil, used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-RV8-OY3-7IE"] = { clientId = nil, used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-EPJ-RCX-9X4"] = { clientId = nil, used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-RMB-9KU-5TE"] = { clientId = nil, used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-168-NDX-OP2"] = { clientId = nil, used = false, admin = false, gameAccess = { BeadyCity = true, BlueLockRival = false } },
    ["FORTUNE-ADMIN-ADMIN-ADMIN"] = { clientIds = { "311F338E-A4B6-4AE8-AE25-C56B209C7E1A", "B42CE9D5-5A28-45F1-BAF8-EFBFA6F6B6E1" }, used = false, admin = true, gameAccess = { BeadyCity = true, BlueLockRival = true } }
}

local function getClientId()
    return tostring(game:GetService("RbxAnalyticsService"):GetClientId())
end

local function runScript()
    warn("SUCCESSFULLY CHECKED KEY/HWID")
    task.wait(1)
    warn("LOADING...")
end

local function adminScript()
    print("Admin access granted! Running admin script...")
    game.ReplicatedStorage:WaitForChild("AdminFunction"):FireServer()
end

local function checkKey(inputKey)
    local player = game.Players.LocalPlayer
    local playerClientId = getClientId()

    if not keys[inputKey] then
        player:Kick("Invalid key!")
        return
    end

    local keyData = keys[inputKey]

    if keyData.used then
        player:Kick("Key already used!")
        return
    end

    if keyData.clientId == nil then
        keyData.clientId = playerClientId
        print("Client ID registered successfully!")
        return
    end

    if keyData.admin then
        local isValidAdmin = false
        for _, adminClientId in ipairs(keyData.clientIds) do
            if adminClientId == playerClientId then
                isValidAdmin = true
                break
            end
        end

        if isValidAdmin then
            print("Admin Key validated successfully! Client ID matched.")
            keyData.used = true
            adminScript()
        else
            player:Kick("Client ID mismatch for Admin key!")
        end
    else
        if keyData.clientId == playerClientId then
            print("Key validated successfully! Client ID matched.")
            keyData.used = true
            if keyData.gameAccess.BeadyCity then
                local success, err = pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Malemz1/FORTUNE-HUB/refs/heads/main/BeadyCity.lua"))()
                end)
                if not success then
                    error("Error Message: " .. err)
                else
                    runScript()
                end
            elseif keyData.gameAccess.BlueLockRival then
                error("เข้าถึงได้ไงยังไม่เสร็จ")
                task.wait(10)
                player:Kick("ตัวเจาะกัง")
            end
        else
            player:Kick("Client ID mismatch!")
        end
    end
end

local inputKey = _G.inputKey
if inputKey then
    checkKey(inputKey)
else
    print("No input key provided.")
end
