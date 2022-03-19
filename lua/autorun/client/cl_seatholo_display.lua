require("seat_holo")

local vehicle = NULL
local SHholo = NULL

local function DestroyHologram()
    if IsValid(SHholo) then SHholo:Remove() end
end

cvars.AddChangeCallback("seatholo_alpha", DestroyHologram)
cvars.AddChangeCallback("seatholo_flicker", DestroyHologram)

hook.Add("Think", "SeatHolo_Hook", function()
    if not GetConVar("seatholo_enabled"):GetBool() then
        if IsValid(SHholo) then SHholo:Remove() end -- if we still have a holo prop, remove it so that the it doesn't get stuck always appearing
        return
    end
    
    -- get vehicle being aimed at limited by 128 units
    vehicle = util.TraceLine({
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + LocalPlayer():GetAimVector() * 128,
        filter = LocalPlayer()
    }).Entity

    -- destroy hologram (if it's valid) if we're in a vehicle, dead, the vehicle we're aiming at is not valid or it has a driver in it and return
    if LocalPlayer():InVehicle() || !LocalPlayer():Alive() || !IsValid(vehicle) || !vehicle:IsVehicle() || vehicle:IsScripted() || vehicle:GetDriver() != NULL then
        if IsValid(SHholo) then SHholo:Remove() end
        return 
    end

    if IsValid(SHholo) then
        -- if we have a hologram, set sequence
        local seq = seat_holo.GetSitSequence(LocalPlayer(), vehicle)
        SHholo:SetSequence(seq)
        vehicle:SetVar("SeatHolo_sitSequence", seq)
        return
    end
    
    -- initialize hologram only if it doesn't exist

    -- create hologram
    SHholo = ClientsideModel(LocalPlayer():GetModel(), RENDERGROUP_TRANSLUCENT)
    SHholo:Spawn()

    -- model
    if GetConVar("seatholo_no_outfitter"):GetBool() then
        SHholo:SetModel(player_manager.TranslatePlayerModel(GetConVar("cl_playermodel"):GetString())) -- cheap hack for now, it will very much lead to inconsistencies
    else
        SHholo:SetModel(LocalPlayer():GetModel())
    end

    -- color
    local col = LocalPlayer():GetColor()
    col.a = GetConVar("seatholo_alpha"):GetInt()
    SHholo:SetColor(col)
    SHholo:SetRenderMode(RENDERMODE_TRANSCOLOR)

    -- flicker effect
    if GetConVar("seatholo_flicker"):GetBool() then
        SHholo:SetRenderFX(kRenderFxHologram)
    else
        SHholo:SetRenderFX(kRenderFxNone)
    end
    
    -- move to driver seat
    local driverPos, driverAng = seat_holo.GetDriverSeat(vehicle)
    SHholo:SetPos(driverPos)
    SHholo:SetAngles(driverAng)

    -- parent hologram to vehicle
    SHholo:SetParent(vehicle)
    
    if !vehicle:GetVar("SeatHolo_hasHints", false) then
        -- if we don't have a sequence, set default
        SHholo:SetSequence(SHholo:LookupSequence("sit"))
    else
        -- if we already have
        SHholo:SetSequence(seat_holo.GetSitSequence(LocalPlayer(), vehicle))
    end
end)
