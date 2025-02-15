

local player = game.Players.LocalPlayer
local host = "http://ec2-3-106-212-13.ap-southeast-2.compute.amazonaws.com:3000/api/"

local url = host.."/getaccess?userKey=" .. getgenv().Key

-- ตรวจสอบว่า request() ใช้ได้หรือไม่
local requestFunction = (http_request or request or syn.request)
if not requestFunction then
    return
end

-- กำหนด Header และทำ Request
local response = requestFunction({
    Url = url,
    Method = "GET",
    Headers = {
        ["Content-Type"] = "application/json"
    }
})

-- ตรวจสอบผลลัพธ์
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
if response and response.Success then
    -- แปลง JSON string เป็น table
    local data = game.HttpService:JSONDecode(response.Body)

    if data.success then
        if not data.isBanned then
            if data.hwid and data.hwid == tostring(HWID) then
                print("Your Have Access")
                getgenv().path = data.gameNames
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Malemz1/FORTUNE-HUB/refs/heads/main/CheckMapSrc.lua", true))()
            elseif data.hwid and data.hwid == "N/A" then
                local postData = game.HttpService:JSONEncode({
                    userKey = getgenv().Key,
                    myHwid = HWID
                })
                
                local postResponse = requestFunction({
                    Url = host.."/resethwid",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = postData
                })

                if postResponse and postResponse.Success then
                    getgenv().path = data.gameNames
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Malemz1/FORTUNE-HUB/refs/heads/main/CheckMapSrc.lua", true))()
                end
            else
                player:Kick("Got Kick Code [AR01]") --HWID NOT MATCH
            end
        else
            player:Kick("Got Banneded")
        end
    end
else
    warn("Key cant Empty")
end
