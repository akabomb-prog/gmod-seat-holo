-- this will receive hints from the server

net.Receive("SeatHolo_sitSequence", function (len)
    local ent, sitSeq = net.ReadEntity(), net.ReadString()
    if !IsValid(ent) then return end
    ent:SetVar("SeatHolo_hasHints", true)
    ent:SetVar("SeatHolo_sitSequence", sitSeq)
end)
