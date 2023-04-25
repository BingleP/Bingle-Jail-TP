-- This function teleports a player to a specific location (in this case, a jail)
function JailPlayer(ply, target)
    if target and IsValid(target) and target:IsPlayer() then
        target:SetPos(Vector(0, 0, 0)) -- Replace with the coordinates of your jail location
        target:ChatPrint("You have been jailed by " .. ply:Nick() .. ".")
        ply:ChatPrint("You have jailed " .. target:Nick() .. ".")
    else
        ply:ChatPrint("Invalid target.")
    end
end

-- This function is called when a player types a message in chat
function TeleportToJail(ply, text, public)
    local args = string.Split(text, " ")
    if string.lower(args[1]) == "!jailtp" then -- The player typed "!jailtp" in chat
        -- Define a table of allowed user groups
        local allowedGroups = {"superadmin", "admin", "trialadmin", "senioradmin"}
        
        -- Check if the player's user group is in the allowedGroups table
        if table.HasValue(allowedGroups, ply:GetUserGroup()) then
            local target = DarkRP.findPlayer(args[2])
            if not target or not IsValid(target) or not target:IsPlayer() then
                ply:ChatPrint("Invalid target.")
                return ""
            end
            
            local jailTime = 300 -- Default jail time in seconds (5 minutes)
            if args[3] then
                local timeArg = args[3]
                local timeNum = tonumber(timeArg:sub(1, -2))
                local timeUnit = timeArg:sub(-1)
                
                if not timeNum or (timeUnit ~= "m" and timeUnit ~= "h" and timeUnit ~= "d") then
                    ply:ChatPrint("Invalid jail time format. Use a number followed by m (minutes), h (hours), or d (days).")
                    return ""
                end
                
                if timeUnit == "m" then
                    jailTime = timeNum * 60
                elseif timeUnit == "h" then
                    jailTime = timeNum * 60 * 60
                elseif timeUnit == "d" then
                    jailTime = timeNum * 60 * 60 * 24
                end
            end
            
            JailPlayer(ply, target, jailTime)
        else
            ply:ChatPrint("You don't have permission to use this command.")
        end
        return ""
    end
end


-- This hook is called whenever a player types a message in chat
hook.Add("PlayerSay", "TeleportToJail", TeleportToJail)

-- This console command is registered to teleport a player to jail
concommand.Add("jailtp", function(ply, cmd, args)
    -- Check if the player has either the "admin" or "superadmin" usergroup
    if ply:IsUserGroup("superadmin") or ply:IsUserGroup("admin") or ply:IsUserGroup("trialadmin") or ply:IsUserGroup("senioradmin") then
        JailPlayer(ply)
    else
        ply:ChatPrint("You don't have permission to use this command.")
    end
end)