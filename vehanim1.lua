-- vehicle scripts don't handle animation, the HandleAnimation function does:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/autorun/base_vehicles.lua#L92

-- HandleAnimation example:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/autorun/base_vehicles.lua#L74
-- this function takes 2 arguments: vehicle and the player
-- inside, :SelectWeightedSequence() returns the sequence ID for the activity ID

-- some more info:
-- HandleAnimation doesn't exist on client in some cases, so the most reliable way for that is getting sequences serverside

local ply = Entity(1)
local ent = ply:GetEyeTrace().Entity

local function GetVehicleSeq(veh)
    if type(veh.HandleAnimation) == "function" then
        -- this vehicle has custom animations
        return veh.HandleAnimation(veh, ply)
    else
        -- this vehicle doesn't have custom animations, check by class
        local class = veh:GetClass()
        if class == "prop_vehicle_jeep" then
            -- hl2 jeep
            return (ply:LookupSequence("drive_jeep"))
        elseif class == "prop_vehicle_airboat" then
            -- hl2 airboat
            return (ply:LookupSequence("drive_airboat"))
        elseif class == "prop_vehicle_prisoner_pod" then
            -- hl2 prisoner pod
            return (ply:LookupSequence("drive_pd"))
        else
            -- uuuhhhh
            return -1
        end
    end
end

if IsValid(ent) and ent:IsVehicle() then
    local seqid = GetVehicleSeq(ent)
    if seqid ~= -1 then
        print("Vehicle animation: " .. ply:GetSequenceName(seqid)) -- print the sequence name in chat
    else
        print("Vehicle animation not found")
    end
end
