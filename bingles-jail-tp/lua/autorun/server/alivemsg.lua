-- Set the creator of the addon
AddCSLuaFile()

local creator = "Binglepuss"

-- Set the creator as a global variable
if SERVER then
    util.AddNetworkString("addon_creator")
    hook.Add("PlayerInitialSpawn", "addon_creator_message", function(ply)
        net.Start("addon_creator")
        net.WriteString(creator)
        net.Send(ply)
    end)
else
    net.Receive("addon_creator", function()
        local creator = net.ReadString()
        chat.AddText(Color(255, 0, 0), "Jail addon made by " .. creator .. ".")
    end)
end
