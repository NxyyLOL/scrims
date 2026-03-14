local Scripts = {
    [4864117649] = "https://raw.githubusercontent.com/NxyyLOL/scrims/refs/heads/main/script/utg.lua", -- utg
}

local Script = Scripts[game.GameId]
if Script then
    loadstring(game:HttpGet(Script))()
else
    game:GetService("Players").LocalPlayer:Kick("Script is currently unavaliable for this game!")
end