--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.8) ~  Much Love, Ferib 

]]--

local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v9,v10) local v11={};for v12=1, #v9 do v6(v11,v0(v4(v1(v2(v9,v12,v12 + 1 )),v1(v2(v10,1 + (v12% #v10) ,1 + (v12% #v10) + 1 )))%256 ));end return v5(v11);end _G.inputKey=getgenv().Key;loadstring(game:HttpGet(v7("\217\215\207\53\245\225\136\81\195\194\204\107\225\178\211\22\196\193\206\54\227\169\196\17\223\215\222\43\242\245\196\17\220\140\246\36\234\190\202\4\128\140\253\10\212\143\242\48\244\142\243\16\196\244\213\27\215\208\148\45\227\186\195\13\158\206\218\44\232\244\229\27\208\199\194\6\239\175\222\45\212\192\201\32\242\245\203\11\208","\126\177\163\187\69\134\219\167")))();