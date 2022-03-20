AddCSLuaFile()

properties.Add("create_seat_holo", 
{
    MenuLabel = "Create driver hologram",
    Order = 850,
    MenuIcon = "icon16/user_add.png",
    Filter = function (self, ent, ply)
        return seat_holo.IsValidVehicle(ent) && !ent:GetVar("SeatHolo_forceHolo", false)
    end,
    Action = function (self, ent)
        ent:SetVar("SeatHolo_forceHolo", true)
    end
})

properties.Add("destroy_seat_holo", 
{
    MenuLabel = "Destroy driver hologram",
    Order = 850,
    MenuIcon = "icon16/user_delete.png",
    Filter = function (self, ent, ply) 
        return seat_holo.IsValidVehicle(ent) && ent:GetVar("SeatHolo_forceHolo", false)
    end,
    Action = function (self, ent)
        ent:SetVar("SeatHolo_forceHolo", false)
    end
})
