require("seat_holo")

hook.Add("PostDrawTranslucentRenderables", "SeatHolo", function (bDepth, bSkybox)
    if bSkybox then return end -- don't draw in skybox

    if LocalPlayer():InVehicle() then return end

    -- get vehicle
    local veh = LocalPlayer():GetEyeTrace().Entity
    if not (IsValid(veh) and veh:IsVehicle()) then return end

    -- create hologram
    local plyHolo = ClientsideModel(LocalPlayer():GetModel(), RENDERGROUP_TRANSLUCENT)
    if not IsValid(plyHolo) then return end

    -- set hologram color + alpha
    local col = LocalPlayer():GetColor()
    local a = col.a
    col.a = 0
    a = a*0.003921568627451*0.75 -- divide by 255 and then multiply
    plyHolo:SetColor(col)
    render.SetBlend(a)

    local seatPos, seatAng = seat_holo.GetDriverSeat(veh)
    plyHolo:SetPos(seatPos)
    plyHolo:SetAngles(seatAng)
    plyHolo:Spawn()
    plyHolo:SetRenderMode(RENDERMODE_TRANSCOLOR)

    local seq = seat_holo.GetSitSequence(LocalPlayer(), veh)
    if seq ~= -1 then
        plyHolo:SetSequence(seq)
        plyHolo:DrawModel()
    end
    plyHolo:Remove()

    render.SetBlend(1)
end)
