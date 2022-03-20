AddCSLuaFile()

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
                return ply:GetSequenceName(ply:SelectWeightedSequence(ACT_DRIVE_JEEP))
            elseif class == "prop_vehicle_airboat" then
                -- hl2 airboat
                return ply:GetSequenceName(ply:SelectWeightedSequence(ACT_DRIVE_AIRBOAT))
            elseif class == "prop_vehicle_prisoner_pod" then
                -- hl2 prisoner pod (which can also be a seat)
                local model = veh:GetModel():lower()
                if model:find("seat") || model:find("chair") then
                    -- seat/chair
                    return ply:GetSequenceName(ply:SelectWeightedSequence(ACT_GMOD_SIT_ROLLERCOASTER))
                else
                    -- pod
                    return ply:GetSequenceName(ply:SelectWeightedSequence(ACT_DRIVE_POD))
                end
            end
        end
    end
    -- uuuhhhh
    return nil
end

module("seat_holo")

function IsValidVehicle(vehicle)
    return IsValid(vehicle) && vehicle:IsVehicle() && !vehicle:IsScripted() && !IsValid(vehicle:GetDriver())
end

if CLIENT then

function GetSitSequence(ply, veh)
    if veh:GetVar("SeatHolo_sitSequence") != nil then
        return veh:GetVar("SeatHolo_sitSequence")
    end
    return _GetSitSequence(ply, veh)
end

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

GetSitSequence = _GetSitSequence

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
