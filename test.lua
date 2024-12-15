-- Import services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

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
    local userKey = getgenv().key  -- Fetch the key from the global environment

    -- Check if a key is provided
    if not userKey then
        Players.LocalPlayer:Kick("Key is missing. Please provide a valid key.")
        return
    end

    -- Validate the key
    local isValid, message = validateKey(userKey)
    if not isValid then
        Players.LocalPlayer:Kick("Key validation failed: " .. message)
        return
    end

    -- Add HWID to the key
    local success, hwidMessage = addHWIDToKey(userKey)
    if not success then
        Players.LocalPlayer:Kick("HWID registration failed: " .. hwidMessage)
        return
    end

    -- Print success message to the console
    print("Key validated and HWID added successfully!")
end

-- Dynamic script execution through loadstring
loadstring([[
    -- Player input their key here
    getgenv().key = "FORTUNE-D6X-K61-7BA"  -- Player enters their key dynamically

    -- Now we validate the key and proceed
    kickIfKeyInvalid()
]])()

print("Test")
