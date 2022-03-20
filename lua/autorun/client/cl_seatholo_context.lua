AddCSLuaFile()

properties.Add("toggle_seat_holo", 
{
    MenuLabel = "Toggle Seat Holo",
    Orde = 850,
    MenuIcon = "icon16/camera.png",
    Filter = function (self, ent, ply) 
        return seat_holo.IsValidVehicle(ent)
    end,
    Action = function (self, ent)
        print(ent) -- test
    end
})
