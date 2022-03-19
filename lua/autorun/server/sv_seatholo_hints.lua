require("seat_holo")

-- if the server has this hook, it will send the sit sequence to players

util.AddNetworkString("SeatHolo_sitSequence")

hook.Add("Tick", "SeatHolo", function ()
    for i,ent in ipairs(ents.FindByClass("*vehicle*")) do
        if ent:IsVehicle() then
            for i,ply in ipairs(player.GetAll()) do
                net.Start("SeatHolo_sitSequence")
                    net.WriteEntity(ent)
                    net.WriteInt(seat_holo.GetSitSequence(ply, ent), 16)
                net.Send(ply)
            end
        end
    end
end)
