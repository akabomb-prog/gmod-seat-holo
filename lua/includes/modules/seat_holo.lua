local CLIENT = CLIENT
local isfunction = isfunction
local IsValid = IsValid

module("seat_holo")

function GetSitSequence(ply, veh)
    if IsValid(veh) and veh:IsVehicle() then
        if isfunction(veh.HandleAnimation) then
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
            end
        end
    end
    -- uuuhhhh
    return -1
end

function GetDriverSeat(veh)
    if IsValid(veh) and veh:IsVehicle() then
        local dSeatAttachment = veh:LookupAttachment("vehicle_feet_passenger0")
        if dSeatAttachment > 0 then
            local dSeat = veh:GetAttachment(dSeatAttachment)
            return dSeat.Pos, dSeat.Ang
        else
            return veh:GetPos(), veh:GetAngles()
        end
    end
    return nil, nil
end
