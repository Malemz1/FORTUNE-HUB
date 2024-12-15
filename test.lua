-- Import services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Table to store keys and HWIDs
local keyTable = {
    ["FORTUNE-D6X-K61-7BA"] = "HWID1",
    ["FORTUNE-PDV-J33-3L6"] = "HWID2",
}

-- Function to get the unique Client ID
local function getClientID()
    return game:GetService("RbxAnalyticsService"):GetClientId() -- Fetch Client ID
end

-- Function to validate the key locally
local function validateKey(key)
    local clientID = getClientID()
    local registeredHWID = keyTable[key]

    if not registeredHWID then
        return false, "Invalid key"
    end

    if registeredHWID ~= clientID then
        return false, "Key already used on another device"
    end

    return true, "Key is valid"
end

-- Function to kick the player if the key is invalid
local function kickIfKeyInvalid()
    local userKey = getgenv().key -- Get the key from global environment
    if not userKey then
        Players.LocalPlayer:Kick("Key is missing. Please provide a valid key.")
        return
    end

    local isValid, message = validateKey(userKey)
    if not isValid then
        Players.LocalPlayer:Kick("Key validation failed: " .. message)
    end
end

-- Validate the key
kickIfKeyInvalid()

-- Continue executing the script if key is valid
print("Key validated successfully!")

print("Test")
