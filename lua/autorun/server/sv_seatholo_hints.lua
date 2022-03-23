require("seat_holo")

-- if the server has this hook, it will send hints about the hologram behaviour to players

util.AddNetworkString("SeatHolo_sitSequence")

hook.Add("Tick", "SeatHolo_hints", function ()
    for i,ent in ipairs(ents.FindByClass("*vehicle*")) do
        if seat_holo.IsValidVehicle(ent) then
            local sitseq = seat_holo.GetSitSequence(ply, ent)
            if sitseq != nil then
                for i,ply in ipairs(player.GetAll()) do
                    net.Start("SeatHolo_sitSequence", true) -- unreliable because this is sent every tick anyway
                        net.WriteEntity(ent)
                        net.WriteString(sitseq)
                    net.Send(ply)
                end
            end
        end
    end
end)
