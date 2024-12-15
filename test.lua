-- Import services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Set the key manually (replace with actual key)
getgenv().key = "FORTUNE-PDV-J33-3L6"  -- Example key

-- Table to store keys and HWIDs
local keyTable = {
    ["FORTUNE-D6X-K61-7BA"] = nil,  -- No HWID registered initially
    ["FORTUNE-PDV-J33-3L6"] = nil,  -- No HWID registered initially
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

    if registeredHWID and registeredHWID ~= clientID then
        return false, "Key already used on another device"
    end

    return true, "Key is valid"
end

-- Function to add HWID to the key if not already associated
local function addHWIDToKey(key)
    local clientID = getClientID()
    if keyTable[key] == nil then
        keyTable[key] = clientID  -- Assign the Client ID to the key
        return true, "HWID added successfully"
    end
    return false, "Key already has a registered HWID"
end

-- Function to kick the player if the key is invalid
local function kickIfKeyInvalid()
    local userKey = getgenv().key -- Get the key from the global environment
    if not userKey then
        Players.LocalPlayer:Kick("Key is missing. Please provide a valid key.")
        return
    end

    local isValid, message = validateKey(userKey)
    if not isValid then
        Players.LocalPlayer:Kick("Key validation failed: " .. message)
        return
    end

    local success, hwidMessage = addHWIDToKey(userKey)
    if not success then
        Players.LocalPlayer:Kick("HWID registration failed: " .. hwidMessage)
        return
    end

    print("Key validated and HWID added successfully!")
end

-- Validate the key
kickIfKeyInvalid()

-- If the key is valid and HWID added, continue executing the script
print("Test")
