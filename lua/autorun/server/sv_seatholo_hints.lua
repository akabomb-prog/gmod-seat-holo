require("seat_holo")

-- if the server has this hook, it will send hints about the hologram behaviour to players

util.AddNetworkString("SeatHolo_sitSequence")

hook.Add("Tick", "SeatHolo_hints", function ()
    for i,ent in ipairs(ents.FindByClass("*vehicle*")) do
        if seat_holo.IsValidVehicle(ent) then
            for i,ply in ipairs(player.GetAll()) do
                net.Start("SeatHolo_sitSequence")
                    net.WriteEntity(ent)
                    net.WriteString(seat_holo.GetSitSequence(ply, ent))
                net.Send(ply)
            end
        end
    end
end)
