local ply = Entity(1)
local ent = ply:GetEyeTrace().Entity

local function GetVehicleSeq(veh)
    if type(veh.HandleAnimation) == "function" then
        return veh.HandleAnimation(veh, ply)
    else
        local class = veh:GetClass()
        if class == "prop_vehicle_jeep" then
            return (ply:LookupSequence("drive_jeep"))
        elseif class == "prop_vehicle_airboat" then
            return (ply:LookupSequence("drive_airboat"))
        elseif class == "prop_vehicle_prisoner_pod" then
            return (ply:LookupSequence("drive_pd"))
        else
            return -1
        end
    end
end

if IsValid(ent) and ent:IsVehicle() then
    local seqid = GetVehicleSeq(ent)
    if seqid ~= -1 then
        print("Vehicle animation: " .. ply:GetSequenceName(seqid))
        local driverSeatAttachment = ent:LookupAttachment("vehicle_feet_passenger0")
        local driverSeat = {}
        if driverSeatAttachment < 1 then
            driverSeat.Pos, driverSeat.Ang = ent:GetPassengerSeatPoint(0)
        else
            driverSeat = ent:GetAttachment(driverSeatAttachment)
        end
        local prop = ents.Create("prop_dynamic")
        if IsValid(prop) then
            prop:SetModel(ply:GetModel())
            prop:SetPos(driverSeat.Pos)
            prop:SetAngles(driverSeat.Ang)
            prop:Spawn()
            prop:SetSequence(seqid)
            prop:SetParent(ent)
            prop:SetCollisionGroup(COLLISION_GROUP_VEHICLE)
        end
    else
        print("Vehicle animation not found")
    end
end
