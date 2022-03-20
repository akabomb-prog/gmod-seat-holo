AddCSLuaFile()

properties.Add("enable_seat_holo", 
{
    MenuLabel = "Show seat hologram",
    Order = 850,
    MenuIcon = "icon16/camera.png",
    Filter = function (self, ent, ply) 
        return seat_holo.IsValidVehicle(ent) && !ent:GetVar("SeatHolo_forceHolo", false)
    end,
    Action = function (self, ent)
        ent:SetVar("SeatHolo_forceHolo", true)
    end
})

properties.Add("disable_seat_holo", 
{
    MenuLabel = "Hide seat hologram",
    Order = 850,
    MenuIcon = "icon16/camera.png",
    Filter = function (self, ent, ply) 
        return seat_holo.IsValidVehicle(ent) && ent:GetVar("SeatHolo_forceHolo", false)
    end,
    Action = function (self, ent)
        ent:SetVar("SeatHolo_forceHolo", false)
    end
})
