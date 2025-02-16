local path = getgenv().path    
warn("Script Lodded")
    if game.PlaceId == 18668065416 then
        if string.find(path, "BluelockRival") then
            print("Bluelock : Rival Lodded")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Malemz1/FORTUNE-HUB/refs/heads/main/BlueLock.lua", true))()
        else
            player:Kick("Your Not Have Game Access")
        end
    elseif game.PlaceId == 73956553001240 then
        if string.find(path, "VolleyballLegend") then
            print("Volleyball Legend Lodded")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Malemz1/FORTUNE-HUB/refs/heads/main/Haikyuu.lua", true))()
        else
            player:Kick("Your Not Have Game Access")
        end
    elseif  game.PlaceId == 115815718131154 then
        if string.find(path, "KuroKuNoBasketball") then
            print("KuroKu No Basketball Lodded")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Malemz1/FORTUNE-HUB/refs/heads/main/Kuroku.lua", true))()
        else
            player:Kick("Your Not Have Game Access")
        end
    end
