require("seat_holo")

local playerHologram = NULL
local holoCleanupTime = 0
local vehicleAtAim = NULL

hook.Add("Tick", "SeatHolo", function ()
    -- get vehicle
    local dir = LocalPlayer():GetAimVector()
    dir:Mul(128)
    dir:Add(LocalPlayer():EyePos())
    local tr = util.TraceLine({
        start = LocalPlayer():EyePos(),
        endpos = dir,
        filter = LocalPlayer()
    })
    if IsValid(tr.Entity) and tr.Entity:IsVehicle() then
        vehicleAtAim = tr.Entity
    else
        vehicleAtAim = NULL
    end

    -- update hologram
    if not IsValid(playerHologram) then return end

    if holoCleanupTime <= CurTime() then
        playerHologram:Remove()
        -- print("cleaning up player hologram " .. tostring(playerHologram))
        holoCleanupTime = CurTime() + 2
    else
        -- update hologram color
        local col = LocalPlayer():GetColor()
        col.a = 0
        playerHologram:SetColor(col)
        playerHologram:SetRenderMode(RENDERMODE_TRANSCOLOR)
    end
end)

hook.Add("PostDrawTranslucentRenderables", "SeatHolo", function (bDepth, bSkybox)
    if bSkybox then return end -- don't draw in skybox

    -- don't draw if we're in vehicle already or the vehicle is not valid
    if LocalPlayer():InVehicle() then return end
    if not (IsValid(vehicleAtAim) and vehicleAtAim:IsVehicle()) then return end

    -- re-create hologram if needed
    if not IsValid(playerHologram) then
        playerHologram = ClientsideModel(LocalPlayer():GetModel(), RENDERGROUP_TRANSLUCENT)
        playerHologram:Spawn()
    end

    -- set hologram alpha
    local a = LocalPlayer():GetColor().a*0.003921568627451*0.75 -- divide by 255 and then multiply
    render.SetBlend(a)

    -- get driver's seat
    local seatPos, seatAng = seat_holo.GetDriverSeat(vehicleAtAim)
    playerHologram:SetPos(seatPos)
    playerHologram:SetAngles(seatAng)

    -- set hologram sequence
    local seq = seat_holo.GetSitSequence(LocalPlayer(), vehicleAtAim)
    if seq ~= -1 then
        playerHologram:SetSequence(seq)
        playerHologram:DrawModel()
    end

    -- set render alpha to 1
    render.SetBlend(1)
    
    -- reset cleanup timer
    holoCleanupTime = CurTime() + 2
end)
