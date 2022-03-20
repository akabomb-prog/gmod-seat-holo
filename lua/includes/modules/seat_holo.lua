local CLIENT = CLIENT
local SERVER = SERVER
local isfunction = isfunction
local IsValid = IsValid

local function _GetSitSequence(ply, veh)
    if IsValid(veh) && veh:IsVehicle() then
        if isfunction(veh.HandleAnimation) then
            -- this vehicle has custom animations
            return ply:GetSequenceName(veh.HandleAnimation(veh, ply))
        else
            -- this vehicle doesn't have custom animations, check by class
            local class = veh:GetClass()
            if class == "prop_vehicle_jeep" then
                -- hl2 jeep
                return "drive_jeep"
            elseif class == "prop_vehicle_airboat" then
                -- hl2 airboat
                return "drive_airboat"
            elseif class == "prop_vehicle_prisoner_pod" then
                -- hl2 prisoner pod
                return "drive_pd"
            end
        end
    end
    -- uuuhhhh
    return nil
end

module("seat_holo")

if CLIENT then

function GetSitSequence(ply, veh)
    if veh:GetVar("SeatHolo_hasHints", false) then
        return veh:GetVar("SeatHolo_sitSequence")
    end
    _GetSitSequence(ply, veh)
end

elseif SERVER then

GetSitSequence =_GetSitSequence

end

if CLIENT then

function GetDriverSeat(veh)
    if IsValid(veh) && veh:IsVehicle() then
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

elseif SERVER then

function GetDriverSeat(veh)
    if IsValid(veh) && veh:IsVehicle() then
        local dSeatAttachment = veh:LookupAttachment("vehicle_feet_passenger0")
        if dSeatAttachment > 0 then
            local dSeat = veh:GetAttachment(dSeatAttachment)
            return dSeat.Pos, dSeat.Ang
        else
            return veh:GetPassengerSeatPoint(0)
        end
    end
    return nil, nil
end

end
