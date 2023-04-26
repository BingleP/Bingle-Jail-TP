-- This function teleports a player to a specific location (in this case, a jail) and sets their jail status in the database

-- Define a table of allowed user groups
local allowedGroups = {"superadmin", "admin", "trialadmin", "senioradmin"}

function JailPlayer(ply, target, jailTime)
    if target and IsValid(target) and target:IsPlayer() then
        target:StripWeapons() -- Strip the player's weapons and sweps
        target:SetPos(Vector(0, 0, 0)) -- Replace with the coordinates of your jail location
        target:ChatPrint("You have been jailed by " .. ply:Nick() .. " for " .. jailTime .. " seconds.")
        ply:ChatPrint("You have jailed " .. target:Nick() .. ".")

        -- Set the player's jail status in the database
        if DarkRP and DarkRP.storeJailPos and DarkRP.storeJailStatus then
            DarkRP.storeJailPos(target)
            DarkRP.storeJailStatus(target, true, os.time() + jailTime)
        end 

        target:SetWalkSpeed(100) -- Set the player's walk speed to a slow value
        target:SetRunSpeed(100) -- Set the player's run speed to a slow value
    else
        ply:ChatPrint("Invalid target.")
    end
end
        
        target:SetWalkSpeed(100) -- Set the player's walk speed to a slow value
        target:SetRunSpeed(100) -- Set the player's run speed to a slow value
    else
        ply:ChatPrint("Invalid target.")
    end

-- This function teleports a player to a specific location (in this case, out of jail) and sets their jail status in the database
function UnjailPlayer(ply, args)

    if string.lower(args[1]) == "!unjailtp" then -- The player typed "!unjailtp" in chat
        if table.HasValue(allowedGroups, ply:GetUserGroup()) then
            local target = DarkRP.findPlayer(args[2])
            if not target or not IsValid(target) or not target:IsPlayer() then
                ply:ChatPrint("Invalid target.")
                return ""
            end
            
            target:SetPos(Vector(0, 0, 0)) -- Replace with the coordinates of your unjail location
            target:ChatPrint("You have been released from jail by " .. ply:Nick() .. ".")
            ply:ChatPrint("You have released " .. target:Nick() .. " from jail.")
            
            -- Remove the player's jail status from the database
            if DarkRP and DarkRP.createDatabaseEntry then
                DarkRP.createDatabaseEntry(target, "jailData", nil)
            end 
            
            target:SetWalkSpeed(200) -- Reset the player's walk speed
            target:SetRunSpeed(400) -- Reset the player's run speed
        else
            ply:ChatPrint("You are not authorized to use this command.")
        end
    end

-- This function checks if a player is jailed by checking the database
function IsPlayerJailed(ply)
    if DarkRP and DarkRP.createDatabaseEntry then
        local jailData = ply:getDarkRPVar("jailPos")
        if jailData and jailData.jailed and jailData.jailTime and jailData.jailTime > os.time() then
            return true
        end
    end
    return false
end

-- This function is called when a player types a message in chat
function TeleportToJail(ply, text, public)
    local args = string.Split(text, " ")
    if string.lower(args[1]) == "!jailtp" then -- The player typed "!jailtp" in chat
               
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

            
