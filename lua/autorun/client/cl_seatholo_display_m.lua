AddCSLuaFile()

require("seat_holo")

-- this is for displaying holograms on more vehicles

hook.Add("Think", "SeatHolo_display_m", function ()
    if !GetConVar("seatholo_enabled"):GetBool() then return end
    
    for i,vehicle in ipairs(ents.FindByClass("*vehicle*")) do
        if seat_holo.IsValidVehicle(vehicle) then
            local holo = vehicle:GetVar("SeatHolo_holo", NULL)
            local shouldHolo = vehicle:GetVar("SeatHolo_forceHolo", false)
            if !IsValid(holo) && shouldHolo then
                -- create hologram
                holo = ClientsideModel(LocalPlayer():GetModel(), RENDERGROUP_TRANSLUCENT)
                holo:Spawn()
            
                -- model
                if GetConVar("seatholo_no_outfitter"):GetBool() then
                    holo:SetModel(player_manager.TranslatePlayerModel(GetConVar("cl_playermodel"):GetString())) -- cheap hack for now, it will very much lead to inconsistencies
                else
                    holo:SetModel(LocalPlayer():GetModel())
                end
            
                -- color
                local col = LocalPlayer():GetColor()
                col.a = GetConVar("seatholo_alpha"):GetInt()
                holo:SetColor(col)
                holo:SetRenderMode(RENDERMODE_TRANSCOLOR)
            
                -- flicker effect
                if GetConVar("seatholo_flicker"):GetBool() then
                    holo:SetRenderFX(kRenderFxHologram)
                else
                    holo:SetRenderFX(kRenderFxNone)
                end
                
                -- move to driver seat
                local driverPos, driverAng = seat_holo.GetDriverSeat(vehicle)
                holo:SetPos(driverPos)
                holo:SetAngles(driverAng)
            
                -- parent hologram to vehicle
                holo:SetParent(vehicle)
                
                if vehicle:GetVar("SeatHolo_sitSequence") != nil then
                    -- if we already have a sequence, set
                    holo:SetSequence(seat_holo.GetSitSequence(LocalPlayer(), vehicle))
                else
                    -- if we don't, set default
                    holo:SetSequence("sit")
                end

                vehicle:SetVar("SeatHolo_holo", holo)

                vehicle:CallOnRemove("RemoveSeatHolo", function (self)
                    timer.Simple(0, function ()
                        if !IsValid(vehicle) && IsValid(holo) then
                            holo:Remove()
                        end
                    end)
                end)
            elseif !shouldHolo then
                vehicle:RemoveCallOnRemove("RemoveSeatHolo")
                if IsValid(holo) then
                    holo:Remove()
                    vehicle:SetVar("SeatHolo_holo", NULL)
                end
            end
        end
    end
end)
